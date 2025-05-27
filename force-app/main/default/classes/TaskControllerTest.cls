@isTest
public with sharing class TaskControllerTest {
  @TestSetup
  static void makeData() {
    // Create test Projects
    List<Projects__c> projects = new List<Projects__c>();
    for (Integer i = 1; i <= 3; i++) {
      projects.add(
        new Projects__c(
          ProjectTitle__c = 'Test Project ' + i,
          PercentCompleted__c = 0
        )
      );
    }
    insert projects;

    // Create test Milestones
    List<Milestones__c> milestones = new List<Milestones__c>();
    for (Integer i = 0; i < projects.size(); i++) {
      // Create 4 milestones per project
      for (Integer j = 1; j <= 4; j++) {
        milestones.add(
          new Milestones__c(
            Name = 'Milestone ' + j + ' - Project ' + (i + 1),
            ProjectId__c = projects[i].Id,
            Status__c = j <= 2 ? 'Completed' : 'Not Started',
            IsActive__c = j > 2
          )
        );
      }
    }
    insert milestones;

    List<Task> TasksList = new List<Task>();
    for (Integer i = 0; i < milestones.size(); i++) {
      // Create 4 TasksList per milestone
      for (Integer j = 1; j <= 4; j++) {
        TasksList.add(
          new Task(
            Subject = 'Task ' + j + ' - Milestone ' + (i + 1),
            WhatId = milestones[i].Id,
            Status = j <= 2 ? 'Completed' : 'Not Started'
          )
        );
      }
    }
    insert TasksList;
  }

  @isTest
  static void testValidateStatusTransitions_ValidTransition() {
    // Test valid status transition (should not throw error)
    List<Task> TasksList = [
      SELECT Id, Status, WhatId
      FROM Task
      WHERE Status = 'Not Started'
      LIMIT 1
    ];
    Map<Id, Task> oldTasksMap = new Map<Id, Task>();

    Task oldTask = TasksList[0].clone(true);
    oldTask.Status = 'Not Started';
    oldTasksMap.put(TasksList[0].Id, oldTask);

    TasksList[0].Status = 'In Progress';

    Test.startTest();
    try {
      TaskController.validateStatusTransitions(TasksList, oldTasksMap);
      // If no exception is thrown, the test passes
      Assert.areEqual(
        'In Progress',
        TasksList[0].Status,
        'Status should be updated to In Progress'
      );
    } catch (Exception e) {
      Assert.fail(
        'Valid transition should not throw an exception: ' + e.getMessage()
      );
    }
    Test.stopTest();
  }

  @isTest
  static void testGetStatusChangedTasks_WithChanges() {
    // Test getting tasksList with status changes
    List<Task> tasksList = [
      SELECT Id, Status, WhatId
      FROM Task
      LIMIT 2
    ];

    Map<Id, Task> oldTasksMap = new Map<Id, Task>();

    // Create old versions with different status
    for (Task taskObj : tasksList) {
      Task oldTask = taskObj.clone(true);
      oldTask.Status = 'In Progress';
      oldTasksMap.put(taskObj.Id, oldTask);
    }

    Test.startTest();
    List<Task> changedTasksList = TaskController.getStatusChangedTasks(
      tasksList,
      oldTasksMap
    );
    Test.stopTest();

    Assert.areEqual(
      2,
      changedTasksList.size(),
      'Should return 2 tasksList with status changes'
    );
  }

  @isTest
  static void testGetStatusChangedTasks_NoChanges() {
    // Test getting tasksList with no status changes
    List<Task> tasksList = [
      SELECT Id, Status, WhatId
      FROM Task
      LIMIT 2
    ];
    Map<Id, Task> oldTasksMap = new Map<Id, Task>();

    // Create old versions with same status
    for (Task taskObj : tasksList) {
      Task oldTask = taskObj.clone(true);
      oldTask.Status = taskObj.Status;
      oldTasksMap.put(taskObj.Id, oldTask);
    }

    Test.startTest();
    List<Task> changedTasksList = TaskController.getStatusChangedTasks(
      tasksList,
      oldTasksMap
    );
    Test.stopTest();

    Assert.areEqual(
      0,
      changedTasksList.size(),
      'Should return 0 tasksList when no status changes'
    );
  }

  @isTest
  static void testUpdateMilestoneCompletionPercentage_WithTasks() {
    // Test Milestone completion percentage update
    List<Task> tasksList = [
      SELECT Id, WhatId
      FROM Task
      LIMIT 4
    ];

    Set<Id> milestoneIds = new Set<Id>();
    for (Task t : tasksList) {
      milestoneIds.add(t.WhatId);
    }

    Test.startTest();
    TaskController.updateMilestoneCompletionPercentage(tasksList);
    Test.stopTest();

    // Verify that milestone completion percentages were updated
    List<Milestones__c> updatedMilestones = [
      SELECT Id, PercentCompleted__c
      FROM Milestones__c
      WHERE Id IN :milestoneIds
    ];

    for (Milestones__c milestone : updatedMilestones) {
      Assert.isNotNull(
        milestone.PercentCompleted__c,
        'milestone completion percentage should be updated'
      );
      Assert.isTrue(
        milestone.PercentCompleted__c >= 0 &&
          milestone.PercentCompleted__c <= 100,
        'Completion percentage should be between 0 and 100'
      );
    }
  }

  @isTest
  static void testBulkOperations() {
    List<Task> allTasks = [
      SELECT Id, Status, WhatId
      FROM Task
    ];
    Map<Id, Task> oldTasksMap = new Map<Id, Task>();

    for (Task taskObj : allTasks) {
      Task oldTask = taskObj.clone(true);
      oldTask.Status = 'In Progress'; // Different status to simulate change
      oldTasksMap.put(taskObj.Id, oldTask);
    }

    Test.startTest();

    List<Task> changedMilestones = TaskController.getStatusChangedTasks(
      allTasks,
      oldTasksMap
    );

    // Test bulk milestone completion update
    TaskController.updateMilestoneCompletionPercentage(allTasks);

    Test.stopTest();

    Assert.isTrue(
      changedMilestones.size() > 0,
      'Should detect status changes in bulk operations'
    );

    // Verify milestones were updated
    List<Milestones__c> updatedMilestones = [
      SELECT Id, PercentCompleted__c
      FROM Milestones__c
    ];
    for (Milestones__c milestone : updatedMilestones) {
      Assert.isNotNull(
        milestone.PercentCompleted__c,
        'All  milestones should have updated completion percentages'
      );
    }
  }
}
