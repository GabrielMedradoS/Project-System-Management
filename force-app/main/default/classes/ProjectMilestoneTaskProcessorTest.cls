@isTest
public class ProjectMilestoneTaskProcessorTest {
  @isTest
  static void testProcessProjectData() {
    String testJson =
      '{\n' +
      '  "milestoneNumber": "3",\n' +
      '  "title": "Test Project",\n' +
      '  "description": "Test description",\n' +
      '  "startDate": "2025-05-19",\n' +
      '  "endDate": "2025-05-20",\n' +
      '  "milestones": [\n' +
      '    {\n' +
      '      "id": 0,\n' +
      '      "name": "1st Milestone",\n' +
      '      "type": "1",\n' +
      '      "dueDate": "2025-05-25",\n' +
      '      "tasksCheckbox": false,\n' +
      '      "tasks": [{ "name": "Task 1", "dueDate": "2025-05-25", "subject": "Test Subject" }]\n' +
      '    },\n' +
      '    {\n' +
      '      "id": 1,\n' +
      '      "name": "2nd Milestone",\n' +
      '      "type": 2,\n' +
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
      result.projectTitle,
      'Project should not be null'
    );

    System.assertEquals(
      String.valueOf(2),
      result.milestones,
      'Should create 2 milestones'
    );

    System.assertEquals(
      String.valueOf(2),
      result.tasks,
      'Should create 2 tasks'
    );
  }
}
