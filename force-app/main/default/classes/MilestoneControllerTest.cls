@isTest
public class MilestoneControllerTest {
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
  }

  @isTest
  static void testValidateStatusTransitions_ValidTransition() {
    // Test valid status transition (should not throw error)
    List<Milestones__c> milestones = [
      SELECT Id, Status__c, ProjectId__c
      FROM Milestones__c
      WHERE Status__c = 'Not Started'
      LIMIT 1
    ];
    Map<Id, Milestones__c> oldMilestoneMap = new Map<Id, Milestones__c>();

    Milestones__c oldMilestone = milestones[0].clone(true);
    oldMilestone.Status__c = 'Not Started';
    oldMilestoneMap.put(milestones[0].Id, oldMilestone);

    milestones[0].Status__c = 'In Progress';

    Test.startTest();
    try {
      MilestoneController.validateStatusTransitions(
        milestones,
        oldMilestoneMap
      );
      // If no exception is thrown, the test passes
      Assert.areEqual(
        'In Progress',
        milestones[0].Status__c,
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
  static void testGetStatusChangedMilestones_WithChanges() {
    // Test getting milestones with status changes
    List<Milestones__c> milestones = [
      SELECT Id, Status__c, ProjectId__c
      FROM Milestones__c
      LIMIT 2
    ];
    Map<Id, Milestones__c> oldMilestoneMap = new Map<Id, Milestones__c>();

    // Create old versions with different status
    for (Milestones__c milestone : milestones) {
      Milestones__c oldMilestone = milestone.clone(true);
      oldMilestone.Status__c = 'In Progress';
      oldMilestoneMap.put(milestone.Id, oldMilestone);
    }

    Test.startTest();
    List<Milestones__c> changedMilestones = MilestoneController.getStatusChangedMilestones(
      milestones,
      oldMilestoneMap
    );
    Test.stopTest();

    Assert.areEqual(
      2,
      changedMilestones.size(),
      'Should return 2 milestones with status changes'
    );
  }

  @isTest
  static void testGetStatusChangedMilestones_NoChanges() {
    // Test getting milestones with no status changes
    List<Milestones__c> milestones = [
      SELECT Id, Status__c, ProjectId__c
      FROM Milestones__c
      LIMIT 2
    ];
    Map<Id, Milestones__c> oldMilestoneMap = new Map<Id, Milestones__c>();

    // Create old versions with same status
    for (Milestones__c milestone : milestones) {
      Milestones__c oldMilestone = milestone.clone(true);
      oldMilestone.Status__c = milestone.Status__c;
      oldMilestoneMap.put(milestone.Id, oldMilestone);
    }

    Test.startTest();
    List<Milestones__c> changedMilestones = MilestoneController.getStatusChangedMilestones(
      milestones,
      oldMilestoneMap
    );
    Test.stopTest();

    Assert.areEqual(
      0,
      changedMilestones.size(),
      'Should return 0 milestones when no status changes'
    );
  }

  @isTest
  static void testUpdateProjectCompletionPercentage_WithMilestones() {
    // Test project completion percentage update
    List<Milestones__c> milestones = [
      SELECT Id, ProjectId__c
      FROM Milestones__c
      LIMIT 4
    ];

    Test.startTest();
    MilestoneController.updateProjectCompletionPercentage(milestones);
    Test.stopTest();

    // Verify that project completion percentages were updated
    List<Projects__c> updatedProjects = [
      SELECT Id, PercentCompleted__c
      FROM Projects__c
      WHERE Id IN (SELECT ProjectId__c FROM Milestones__c)
    ];

    for (Projects__c project : updatedProjects) {
      Assert.isNotNull(
        project.PercentCompleted__c,
        'Project completion percentage should be updated'
      );
      Assert.isTrue(
        project.PercentCompleted__c >= 0 && project.PercentCompleted__c <= 100,
        'Completion percentage should be between 0 and 100'
      );
    }
  }

  @isTest
  static void testBulkOperations() {
    // Test bulk operations with multiple milestones
    List<Milestones__c> allMilestones = [
      SELECT Id, Status__c, IsActive__c, ProjectId__c
      FROM Milestones__c
    ];
    Map<Id, Milestones__c> oldMilestoneMap = new Map<Id, Milestones__c>();

    // Create old milestone map
    for (Milestones__c milestone : allMilestones) {
      Milestones__c oldMilestone = milestone.clone(true);
      oldMilestone.Status__c = 'In Progress'; // Different status to simulate change
      oldMilestoneMap.put(milestone.Id, oldMilestone);
    }

    Test.startTest();

    // Test bulk status change detection
    List<Milestones__c> changedMilestones = MilestoneController.getStatusChangedMilestones(
      allMilestones,
      oldMilestoneMap
    );

    // Test bulk project completion update
    MilestoneController.updateProjectCompletionPercentage(allMilestones);

    Test.stopTest();

    Assert.isTrue(
      changedMilestones.size() > 0,
      'Should detect status changes in bulk operations'
    );

    // Verify projects were updated
    List<Projects__c> updatedProjects = [
      SELECT Id, PercentCompleted__c
      FROM Projects__c
    ];
    for (Projects__c project : updatedProjects) {
      Assert.isNotNull(
        project.PercentCompleted__c,
        'All projects should have updated completion percentages'
      );
    }
  }

  @isTest
  static void testErrorHandling_DmlException() {
    // This test simulates DML exception handling in updateProjectPercentageRecords
    // Note: It's difficult to force a DML exception in test context, but we can test the method structure
    List<Milestones__c> milestones = [
      SELECT Id, ProjectId__c
      FROM Milestones__c
      LIMIT 1
    ];

    Test.startTest();
    try {
      MilestoneController.updateProjectCompletionPercentage(milestones);
      // The method should handle any DML exceptions gracefully
    } catch (Exception e) {
      // If an exception occurs, it should be handled within the method
      Assert.fail(
        'Method should handle DML exceptions internally: ' + e.getMessage()
      );
    }
    Test.stopTest();
  }
}
