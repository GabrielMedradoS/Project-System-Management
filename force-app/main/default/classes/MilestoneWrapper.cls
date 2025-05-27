public with sharing class MilestoneWrapper {
  @AuraEnabled
  public String name { get; set; }
  @AuraEnabled
  public Decimal type { get; set; }
  @AuraEnabled
  public String dueDate { get; set; }
  @AuraEnabled
  public List<TaskWrapper> tasks { get; set; }

  public Milestones__c getMilestone() {
    Milestones__c mile = new Milestones__c();
    mile.Name = this.name;
    mile.Type__c = this.type;
    mile.DueDate__c = Date.valueOf(this.dueDate);

    return mile;
  }

  public List<TaskWrapper> getTasks() {
    return this.tasks != null ? this.tasks : new List<TaskWrapper>();
  }
}
