public class ProjectMilestoneTaskProcessor {
  public class ProcessResult {
    public Boolean success;
    public String message;
    public String projectId;
    public String errorDetails;
    public List<Milestones__c> milestones;
    public List<Task> tasks;

    public ProcessResult() {
      this.milestones = new List<Milestones__c>();
      this.tasks = new List<Task>();
    }
  }

  @AuraEnabled
  public static ProcessResult processFromJSON(Map<String, Object> data) {
    String jsonString = (String) JSON.serializePretty(data);
    return processProjectData(jsonString);
  }

  public static ProcessResult processProjectData(String jsonString) {
    ProcessResult result = new ProcessResult();
    Savepoint sp = Database.setSavepoint();

    try {
      ProjectWrapper projectData = (ProjectWrapper) JSON.deserialize(
        jsonString,
        ProjectWrapper.class
      );

      Projects__c projectToInsert = projectData.getProject();
      insert projectToInsert;
      result.projectId = projectToInsert.Id;

      List<MilestoneWrapper> milestoneListWrappers = projectData.getMilestones();
      List<Milestones__c> milestonesToInsert = new List<Milestones__c>();
      List<List<TaskWrapper>> taskWrapperGroups = new List<List<TaskWrapper>>();

      for (MilestoneWrapper mw : milestoneListWrappers) {
        Milestones__c milestone = mw.getMilestone(projectToInsert.Id);
        milestonesToInsert.add(milestone);
        taskWrapperGroups.add(mw.getTasks());
      }

      if (!milestonesToInsert.isEmpty()) {
        insert milestonesToInsert;
        result.milestones = milestonesToInsert;
      }

      List<Task> allTasksToInsert = new List<Task>();
      for (Integer i = 0; i < milestonesToInsert.size(); i++) {
        Milestones__c milestone = milestonesToInsert[i];
        List<TaskWrapper> wrappers = taskWrapperGroups[i];

        for (TaskWrapper tw : wrappers) {
          Task task = tw.getTask(milestone.Id);
          allTasksToInsert.add(task);
        }
      }

      result.tasks = allTasksToInsert;

      if (!allTasksToInsert.isEmpty()) {
        insert allTasksToInsert;
      }

      result.success = true;
      result.message =
        'Successfully created ' +
        '1 Project, ' +
        result.milestones.size() +
        ' Milestones, ' +
        result.tasks.size() +
        ' Tasks';
    } catch (Exception e) {
      result.success = false;
      result.message = 'Error processing project data: ' + e.getMessage();
      result.errorDetails = e.getStackTraceString();
      System.debug('Error in processProjectData: ' + e.getMessage());
      System.debug('Stack trace: ' + e.getStackTraceString());
    }

    return result;
  }
}
