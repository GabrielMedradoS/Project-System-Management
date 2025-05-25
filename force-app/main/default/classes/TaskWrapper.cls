public with sharing class TaskWrapper {
  public String subject { get; set; }
  public String dueDate { get; set; }

  public Task getTask(String milestoneId) {
    Task taskObj = new Task();
    taskObj.Subject = this.subject;
    taskObj.WhatId = milestoneId;
    taskObj.ActivityDate = Date.valueOf(this.dueDate);

    return taskObj;
  }
}
