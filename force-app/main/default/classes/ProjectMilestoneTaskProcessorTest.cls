@isTest
public class ProjectMilestoneTaskProcessorTest {
  @isTest
  static void testProcessProjectData() {
    String testJson =
      '{\n' +
      '  "milestoneNumber": "3",\n' +
      '  "title": "Test Project",\n' +
      '  "startDate": "2025-05-19",\n' +
      '  "endDate": "2025-05-20",\n' +
      '  "milestones": [\n' +
      '    {\n' +
      '      "id": 0,\n' +
      '      "name": "Milestone 1",\n' +
      '      "type": "Milestone 1st",\n' +
      '      "dueDate": "2025-05-25",\n' +
      '      "tasksCheckbox": false,\n' +
      '      "tasks": [{ "name": "Task 1", "dueDate": "2025-05-25", "subject": "Test Subject" }]\n' +
      '    },\n' +
      '    {\n' +
      '      "id": 1,\n' +
      '      "name": "Milestone 2",\n' +
      '      "type": "Milestone 2nd",\n' +
      '      "dueDate": "2025-05-20",\n' +
      '      "tasksCheckbox": false,\n' +
      '      "tasks": [{ "name": "Task 2", "dueDate": "2025-05-20", "subject": "Another Subject" }]\n' +
      '    }\n' +
      '  ]\n' +
      '}';

    Test.startTest();
    ProjectMilestoneTaskProcessor.ProcessResult result = ProjectMilestoneTaskProcessor.processProjectData(
      testJson
    );
    Test.stopTest();

    System.assert(
      result.success,
      'Processing should be successful: ' + result.message
    );

    System.assertNotEquals(
      null,
      result.projectId,
      'Project ID should not be null'
    );

    System.assertEquals(
      2,
      result.milestones.size(),
      'Should create 2 milestones'
    );

    System.assertEquals(2, result.tasks.size(), 'Should create 2 tasks');

    // ****** VERIFY RECORDS ******
    Projects__c project = [
      SELECT Id, ProjectTitle__c
      FROM Projects__c
      WHERE Id = :result.projectId
    ];
    System.assertEquals('Test Project', project.ProjectTitle__c);

    List<Milestones__c> milestones = [
      SELECT Id, Name, Type__c, ProjectId__c
      FROM Milestones__c
      WHERE ProjectId__c = :project.Id
    ];
    System.assertEquals(2, milestones.size());
    System.assertEquals('Milestone 1', milestones[0].Name);
    System.assertEquals('Milestone 2', milestones[1].Name);
  }
}
