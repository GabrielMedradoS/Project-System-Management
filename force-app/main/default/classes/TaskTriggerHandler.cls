public with sharing class TaskTriggerHandler {
  // Static variable to prevent recursive trigger calls
  private static Boolean isExecuting = false;

  public static void execute() {
    // Prevent recursive calls
    if (isExecuting) {
      return;
    }

    isExecuting = true;

    try {
      if (Trigger.isBefore) {
        if (Trigger.isInsert) {
          beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
          handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
          beforeDelete(Trigger.old);
        }
      } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
          afterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
          afterUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
          afterDelete(Trigger.old);
        } else if (Trigger.isUndelete) {
          afterUndelete(Trigger.new);
        }
      }
    } finally {
      isExecuting = false;
    }
  }

  // BEFORE INSERT
  private static void beforeInsert(List<Task> newTasks) {
  }

  // BEFORE UPDATE
  private static void handleBeforeUpdate(
    List<Task> newTasks,
    Map<Id, sObject> oldMap
  ) {
    Map<Id, Task> oldTaskMap = new Map<Id, Task>((List<Task>) oldMap.values());

    System.debug(
      'TaskTriggerHandler: Before Update executed for ' +
        newTasks.size() +
        ' records'
    );

    TaskController.validateStatusTransitions(newTasks, oldTaskMap);
  }

  // BEFORE DELETE
  private static void beforeDelete(List<Task> oldTasks) {
    System.debug(
      'TaskTriggerHandler: Before Delete executed for ' +
        oldTasks.size() +
        ' records'
    );

    TaskController.preventCriticalTaskDeletion(oldTasks);
  }

  // AFTER INSERT
  private static void afterInsert(List<Task> newTasks) {
    System.debug(
      'TaskTriggerHandler: After Insert executed for ' +
        newTasks.size() +
        ' records'
    );

    TaskController.updateMilestoneCompletionPercentage(newTasks);
  }

  // AFTER UPDATE
  private static void afterUpdate(
    List<Task> newTasks,
    Map<Id, sObject> oldMap
  ) {
    Map<Id, Task> oldTaskMap = new Map<Id, Task>((List<Task>) oldMap.values());
    System.debug(
      'TaskTriggerHandler: After Update executed for ' +
        newTasks.size() +
        ' records'
    );

    List<Task> statusChangedMilestones = TaskController.getStatusChangedTasks(
      newTasks,
      oldTaskMap
    );

    if (!statusChangedMilestones.isEmpty()) {
      TaskController.updateMilestoneCompletionPercentage(
        statusChangedMilestones
      );
    }
  }

  // AFTER DELETE
  private static void afterDelete(List<Task> oldTasks) {
    System.debug(
      'TaskTriggerHandler: After Delete executed for ' +
        oldTasks.size() +
        ' records'
    );

    TaskController.updateMilestoneCompletionPercentage(oldTasks);
  }

  // AFTER UNDELETE
  private static void afterUndelete(List<Task> newTasks) {
  }
}
