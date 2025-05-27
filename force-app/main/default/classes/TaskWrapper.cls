public with sharing class TaskWrapper {
  @AuraEnabled
  public String subject { get; set; }
  @AuraEnabled
  public String dueDate { get; set; }

  public Task getTask() {
    Task taskObj = new Task();
    taskObj.Subject = this.subject;
    taskObj.ActivityDate = Date.valueOf(this.dueDate);

    return taskObj;
  }
}
