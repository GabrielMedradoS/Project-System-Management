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
    List<Milestones__c> milestones = [
      SELECT Id, Status__c, ProjectId__c
      FROM Milestones__c
      LIMIT 2
    ];
    Map<Id, Milestones__c> oldMilestoneMap = new Map<Id, Milestones__c>();

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
    List<Milestones__c> milestones = [
      SELECT Id, Status__c, ProjectId__c
      FROM Milestones__c
      LIMIT 2
    ];
    Map<Id, Milestones__c> oldMilestoneMap = new Map<Id, Milestones__c>();

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
    List<Milestones__c> milestones = [
      SELECT Id, ProjectId__c
      FROM Milestones__c
      LIMIT 4
    ];

    Test.startTest();
    MilestoneController.updateProjectCompletionPercentage(milestones);
    Test.stopTest();

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
    List<Milestones__c> allMilestones = [
      SELECT Id, Status__c, IsActive__c, ProjectId__c
      FROM Milestones__c
    ];
    Map<Id, Milestones__c> oldMilestoneMap = new Map<Id, Milestones__c>();

    // Create old milestone map
    for (Milestones__c milestone : allMilestones) {
      Milestones__c oldMilestone = milestone.clone(true);
      oldMilestone.Status__c = 'In Progress';
      oldMilestoneMap.put(milestone.Id, oldMilestone);
    }

    Test.startTest();

    List<Milestones__c> changedMilestones = MilestoneController.getStatusChangedMilestones(
      allMilestones,
      oldMilestoneMap
    );

    MilestoneController.updateProjectCompletionPercentage(allMilestones);

    Test.stopTest();

    Assert.isTrue(
      changedMilestones.size() > 0,
      'Should detect status changes in bulk operations'
    );

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
    List<Milestones__c> milestones = [
      SELECT Id, ProjectId__c
      FROM Milestones__c
      LIMIT 1
    ];

    Test.startTest();
    try {
      MilestoneController.updateProjectCompletionPercentage(milestones);
    } catch (Exception e) {
      Assert.fail(
        'Method should handle DML exceptions internally: ' + e.getMessage()
      );
    }
    Test.stopTest();
  }
}
