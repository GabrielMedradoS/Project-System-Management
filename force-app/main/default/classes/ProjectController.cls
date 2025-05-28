public with sharing class ProjectController {
  @AuraEnabled(cacheable=true)
  public static List<ResponseWrapper> projectOverview(Id projectId) {
    return getMilestonesWithTasks(projectId);
  }

  @TestVisible
  private static List<ResponseWrapper> getMilestonesWithTasks(Id projectId) {
    List<ResponseWrapper> responseWrappers = new List<ResponseWrapper>();

    try {
      List<Milestones__c> milestonesList = [
        SELECT
          Id,
          Name,
          Description__c,
          Status__c,
          DueDate__c,
          PercentCompleted__c,
          Priority__c
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
          SELECT Id, Subject, Status, Priority, ActivityDate, WhatId, Owner.Name
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
        ResponseWrapper wrapper = new ResponseWrapper();
        wrapper.milestone = milestone;
        wrapper.tasks = milestoneTasksMap.get(milestone.Id);

        if (wrapper.tasks == null) {
          wrapper.tasks = new List<Task>();
        }

        responseWrappers.add(wrapper);
      }
    } catch (Exception e) {
      throw new AuraHandledException(
        'Error retrieving milestones and tasks: ' + e.getMessage()
      );
    }

    return responseWrappers;
  }

  public class ResponseWrapper {
    @AuraEnabled
    public Milestones__c milestone { get; set; }

    @AuraEnabled
    public List<Task> tasks { get; set; }
  }
}
