public with sharing class TaskController {
  public static void validateStatusTransitions(
    List<Task> newTasks,
    Map<Id, Task> oldTaskMap
  ) {
    for (Task taskObj : newTasks) {
      Task oldTask = oldTaskMap.get(taskObj.Id);

      if (oldTask.Status == 'Completed' && taskObj.Status == 'Not Started') {
        taskObj.Status.addError(
          'Cannot change status from Completed to Not Started'
        );
      }
    }
  }

  public static void preventCriticalTaskDeletion(List<Task> tasksList) {
    for (Task taskObj : tasksList) {
      if (taskObj.Status == 'Completed') {
        taskObj.addError('Cannot delete completed tasksList');
      }
    }
  }

  public static List<Task> getStatusChangedTasks(
    List<Task> newTasks,
    Map<Id, Task> oldTaskMap
  ) {
    List<Task> statusChangedTask = new List<Task>();

    for (Task taskObj : newTasks) {
      Task oldTask = oldTaskMap.get(taskObj.Id);

      if (taskObj.Status != oldTask.Status) {
        statusChangedTask.add(taskObj);
      }
    }

    return statusChangedTask;
  }

  public static void updateMilestoneCompletionPercentage(List<Task> tasksList) {
    Set<Id> milestoneId = new Set<Id>();

    for (Task taskObj : tasksList) {
      if (taskObj.WhatId != null) {
        milestoneId.add(taskObj.WhatId);
      }
    }

    if (milestoneId.isEmpty()) {
      return;
    }

    Map<Id, Map<String, Object>> milestoneCompletionMap = calculateMilestoneCompletion(
      milestoneId
    );

    updateMilestonePercentageRecords(milestoneCompletionMap);
  }

  private static Map<Id, Map<String, Object>> calculateMilestoneCompletion(
    Set<Id> milestoneIds
  ) {
    Map<Id, Map<String, Object>> resultMap = new Map<Id, Map<String, Object>>();

    List<AggregateResult> totalResults = [
      SELECT WhatId, COUNT(Id) totalTasks
      FROM Task
      WHERE WhatId IN :milestoneIds
      GROUP BY WhatId
    ];

    List<AggregateResult> completedResults = [
      SELECT WhatId, COUNT(Id) completedTasks
      FROM Task
      WHERE WhatId IN :milestoneIds AND Status = 'Completed'
      GROUP BY WhatId
    ];

    Map<Id, Integer> totalTasksMap = new Map<Id, Integer>();
    for (AggregateResult result : totalResults) {
      Id milestoneId = (Id) result.get('WhatId');
      Integer totalTasks = (Integer) result.get('totalTasks');
      totalTasksMap.put(milestoneId, totalTasks);
    }

    Map<Id, Integer> completedTasksMap = new Map<Id, Integer>();
    for (AggregateResult result : completedResults) {
      Id milestoneId = (Id) result.get('WhatId');
      Integer completedTasks = (Integer) result.get('completedTasks');
      completedTasksMap.put(milestoneId, completedTasks);
    }

    for (Id milestoneId : totalTasksMap.keySet()) {
      Integer totalTasks = totalTasksMap.get(milestoneId) != null
        ? totalTasksMap.get(milestoneId)
        : 0;
      Integer completedTasks = completedTasksMap.get(milestoneId) != null
        ? completedTasksMap.get(milestoneId)
        : 0;

      String status = '';
      Decimal percentage = 0;
      Boolean isActive = false;
      if (totalTasks > 0) {
        percentage = (completedTasks * 100.0) / totalTasks;
        if (percentage == 100) {
          status = 'Completed';
          isActive = false;
        } else if (percentage > 0 && percentage < 100) {
          status = 'In Progress';
          isActive = false;
        } else {
          status = 'Not Started';
        }
      }

      resultMap.put(
        milestoneId,
        new Map<String, Object>{
          'isActive' => isActive,
          'percentage' => percentage,
          'status' => status
        }
      );
    }

    return resultMap;
  }

  private static void updateMilestonePercentageRecords(
    Map<Id, Map<String, Object>> milestoneCompletionMap
  ) {
    List<Milestones__c> milestonesToUpdate = new List<Milestones__c>();

    for (Id milestoneId : milestoneCompletionMap.keySet()) {
      Map<String, Object> dataMap = milestoneCompletionMap.get(milestoneId);

      Milestones__c milestone = new Milestones__c();
      milestone.Id = milestoneId;
      milestone.PercentCompleted__c = (Decimal) dataMap.get('percentage');
      milestone.Status__c = (String) dataMap.get('status');
      milestone.IsActive__c = (Boolean) dataMap.get('isActive');

      milestonesToUpdate.add(milestone);
    }

    if (!milestonesToUpdate.isEmpty()) {
      try {
        update milestonesToUpdate;

        System.debug(
          'Successfully updated ' +
            milestonesToUpdate.size() +
            ' project completion percentages'
        );
      } catch (DmlException e) {
        System.debug(
          'Error updating project completion percentages: ' + e.getMessage()
        );
      }
    }
  }
}
