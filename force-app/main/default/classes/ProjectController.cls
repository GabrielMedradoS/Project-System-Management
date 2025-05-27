public with sharing class ProjectController {
  @AuraEnabled(cacheable=true)
  public static List<MilestoneWrapper> projectOverview(Id projectId) {
    return getMilestonesWithTasks(projectId);
  }

  @TestVisible
  private static List<MilestoneWrapper> getMilestonesWithTasks(Id projectId) {
    List<MilestoneWrapper> milestoneWrappers = new List<MilestoneWrapper>();

    try {
      List<Milestones__c> milestonesList = [
        SELECT
          Id,
          Name,
          Description__c,
          Status__c,
          DueDate__c,
          PercentCompleted__c,
          Priority__c,
          projectId__c
        FROM Milestones__c
        WHERE projectId__c = :projectId
        ORDER BY DueDate__c ASC NULLS LAST, Priority__c DESC
      ];

      Set<Id> milestoneIds = new Set<Id>();
      for (Milestones__c milestone : milestonesList) {
        milestoneIds.add(milestone.Id);
      }

      Map<Id, List<Task>> milestoneTasksMap = new Map<Id, List<Task>>();

      if (!milestoneIds.isEmpty()) {
        List<Task> tasksList = [
          SELECT
            Id,
            Subject,
            WhatId,
            Status,
            Priority,
            ActivityDate,
            WhatId,
            Owner.Name
          FROM Task
          WHERE WhatId IN :milestoneIds
          ORDER BY ActivityDate ASC NULLS LAST, Priority DESC
        ];

        for (Task taskObj : tasksList) {
          if (!milestoneTasksMap.containsKey(taskObj.WhatId)) {
            milestoneTasksMap.put(taskObj.WhatId, new List<Task>());
          }

          milestoneTasksMap.get(taskObj.WhatId).add(taskObj);
        }
      }

      for (Milestones__c milestone : milestonesList) {
        MilestoneWrapper wrapper = new MilestoneWrapper();

        wrapper.Id = milestone.Id;

        List<Task> milestoneTasks = milestoneTasksMap.get(milestone.Id);
        if (milestoneTasks != null && !milestoneTasks.isEmpty()) {
          List<TaskWrapper> taskWrappers = new List<TaskWrapper>();
          for (Task taskObj : milestoneTasks) {
            TaskWrapper taskWrapper = new TaskWrapper();
            taskWrapper.id = taskObj.Id;

            taskWrappers.add(taskWrapper);
          }

          wrapper.tasks = taskWrappers;
        }

        milestoneWrappers.add(wrapper);
      }
    } catch (Exception e) {
      throw new AuraHandledException(
        'Error retrieving milestones and tasks: ' + e.getMessage()
      );
    }

    return milestoneWrappers;
  }
}
