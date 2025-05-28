@isTest
public with sharing class ProjectControllerTest {
  @TestSetup
  static void makeData() {
    Projects__c project = new Projects__c();
    project.ProjectTitle__c = 'Test Project ';
    project.PercentCompleted__c = 0;

    insert project;

    List<Milestones__c> milestones = new List<Milestones__c>();
    for (Integer i = 1; i <= 2; i++) {
      milestones.add(
        new Milestones__c(
          Name = 'Milestone ' + i,
          ProjectId__c = project.Id,
          Status__c = i <= 2 ? 'Completed' : 'Not Started',
          IsActive__c = i > 2
        )
      );
    }

    insert milestones;

    List<Task> TasksList = new List<Task>();
    for (Integer i = 0; i < milestones.size(); i++) {
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
  public static void getMilestonesWithTasksTest() {
    Projects__c project = [
      SELECT Id, ProjectTitle__c, PercentCompleted__c
      FROM Projects__c
    ];

    Test.startTest();
    List<ProjectController.ResponseWrapper> result = ProjectController.projectOverview(
      project.Id
    );
    Test.stopTest();

    System.assertNotEquals(null, result);
    System.assertEquals(2, result.size(), 'Should return 2 milestones');

    Boolean foundTasks = false;
    for (ProjectController.ResponseWrapper wrapper : result) {
      System.assertNotEquals(
        null,
        wrapper.milestone,
        'Milestone should not be null'
      );

      if (!wrapper.tasks.isEmpty()) {
        foundTasks = true;
      }
    }

    System.assertEquals(
      true,
      foundTasks,
      'At least one milestone should have tasks'
    );
  }
}
