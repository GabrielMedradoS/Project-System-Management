public with sharing class MilestoneWrapper {
  public Integer id { get; set; }
  public String name { get; set; }
  public String type { get; set; }
  public String dueDate { get; set; }
  public Boolean tasksCheckbox { get; set; }
  public List<TaskWrapper> tasks { get; set; }

  public Milestones__c getMilestone(String projectId) {
    Milestones__c mile = new Milestones__c();
    mile.Name = this.name;
    mile.ProjectId__c = projectId;
    mile.Type__c = this.type;
    mile.DueDate__c = Date.valueOf(this.dueDate);

    return mile;
  }

  public List<TaskWrapper> getTasks() {
    return this.tasks != null ? this.tasks : new List<TaskWrapper>();
  }
}
