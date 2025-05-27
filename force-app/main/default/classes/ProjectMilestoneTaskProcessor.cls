public class ProjectMilestoneTaskProcessor {
  @AuraEnabled
  public static ProcessResult processFromJSON(Map<String, Object> data) {
    String jsonString = (String) JSON.serializePretty(data);
    return processProjectData(jsonString);
  }

  @TestVisible
  private static ProcessResult processProjectData(String jsonString) {
    ProcessResult result = new ProcessResult();
    Savepoint sp = Database.setSavepoint();

    try {
      ProjectWrapper projectData = (ProjectWrapper) JSON.deserialize(
        jsonString,
        ProjectWrapper.class
      );

      Projects__c projectToInsert = projectData.getProject();
      insert projectToInsert;
      result.projectTitle = projectToInsert.ProjectTitle__c;

      List<MilestoneWrapper> milestoneListWrappers = projectData.getMilestones();
      List<Milestones__c> milestonesToInsert = new List<Milestones__c>();
      List<List<TaskWrapper>> taskWrapperGroups = new List<List<TaskWrapper>>();

      for (MilestoneWrapper mw : milestoneListWrappers) {
        Milestones__c milestone = mw.getMilestone();
        milestone.ProjectId__c = projectToInsert.Id;

        milestonesToInsert.add(milestone);
        taskWrapperGroups.add(mw.getTasks());
      }

      if (!milestonesToInsert.isEmpty()) {
        insert milestonesToInsert;
        result.milestones = String.valueOf(milestonesToInsert.size());
      }

      List<Task> allTasksToInsert = new List<Task>();
      for (Integer i = 0; i < milestonesToInsert.size(); i++) {
        Milestones__c milestone = milestonesToInsert[i];
        List<TaskWrapper> wrappers = taskWrapperGroups[i];

        for (TaskWrapper tw : wrappers) {
          Task taskObj = tw.getTask();
          taskObj.WhatId = milestone.Id;

          allTasksToInsert.add(taskObj);
        }
      }

      if (!allTasksToInsert.isEmpty()) {
        insert allTasksToInsert;
        result.tasks = String.valueOf(allTasksToInsert.size());
      }

      result.success = true;
      result.message =
        'Successfully created ' +
        '1 Project, ' +
        result.milestones +
        ' Milestones, ' +
        result.tasks +
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

  public class ProcessResult {
    @AuraEnabled
    public Boolean success;
    @AuraEnabled
    public String message;
    @AuraEnabled
    public String projectTitle;
    @AuraEnabled
    public String errorDetails;
    @AuraEnabled
    public String milestones;
    @AuraEnabled
    public String tasks;

    public ProcessResult() {
      this.milestones = '';
      this.tasks = '';
    }
  }
}
