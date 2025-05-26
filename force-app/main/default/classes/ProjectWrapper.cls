public with sharing class ProjectWrapper {
  public String title { get; set; }
  public String description { get; set; }
  public String startDate { get; set; }
  public String endDate { get; set; }
  public List<MilestoneWrapper> milestones { get; set; }

  public Projects__c getProject() {
    Projects__c project = new Projects__c();
    project.ProjectTitle__c = this.title;
    project.StartDate__c = Date.valueOf(this.startDate);
    project.EndDate__c = Date.valueOf(this.endDate);
    project.Description__c = this.description;
    return project;
  }

  public List<MilestoneWrapper> getMilestones() {
    return this.milestones != null
      ? this.milestones
      : new List<MilestoneWrapper>();
  }
}
