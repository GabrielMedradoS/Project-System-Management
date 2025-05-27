public class MilestoneTriggerHandler {
  // Static variable to prevent recursive trigger calls
  private static Boolean isExecuting = false;

  // Main entry point for all trigger contexts
  public static void execute() {
    // Prevent recursive calls
    if (isExecuting) {
      return;
    }

    isExecuting = true;

    try {
      // Handle different trigger contexts
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
  private static void beforeInsert(List<Milestones__c> newMilestones) {
  }

  // BEFORE UPDATE
  private static void handleBeforeUpdate(
    List<Milestones__c> newMilestones,
    Map<Id, sObject> oldMap
  ) {
    Map<Id, Milestones__c> oldMilestoneMap = new Map<Id, Milestones__c>(
      (List<Milestones__c>) oldMap.values()
    );

    System.debug(
      'MilestoneTriggerHandler: Before Update executed for ' +
        newMilestones.size() +
        ' records'
    );

    // Validate status transitions, update fields, etc.
    MilestoneController.validateStatusTransitions(
      newMilestones,
      oldMilestoneMap
    );
  }

  // BEFORE DELETE
  private static void beforeDelete(List<Milestones__c> oldMilestones) {
    System.debug(
      'MilestoneTriggerHandler: Before Delete executed for ' +
        oldMilestones.size() +
        ' records'
    );

    //Prevent deletion of critical milestones
    MilestoneController.preventCriticalMilestoneDeletion(oldMilestones);
  }

  // AFTER INSERT
  private static void afterInsert(List<Milestones__c> newMilestones) {
    System.debug(
      'MilestoneTriggerHandler: After Insert executed for ' +
        newMilestones.size() +
        ' records'
    );

    // Update project completion percentage after new milestones are added
    MilestoneController.updateProjectCompletionPercentage(newMilestones);
  }

  // AFTER UPDATE
  private static void afterUpdate(
    List<Milestones__c> newMilestones,
    Map<Id, sObject> oldMap
  ) {
    Map<Id, Milestones__c> oldMilestoneMap = new Map<Id, Milestones__c>(
      (List<Milestones__c>) oldMap.values()
    );
    System.debug(
      'MilestoneTriggerHandler: After Update executed for ' +
        newMilestones.size() +
        ' records'
    );

    // Filter milestones where status has changed
    List<Milestones__c> statusChangedMilestones = MilestoneController.getStatusChangedMilestones(
      newMilestones,
      oldMilestoneMap
    );

    if (!statusChangedMilestones.isEmpty()) {
      // Update project completion percentage
      MilestoneController.updateProjectCompletionPercentage(
        statusChangedMilestones
      );
    }
  }

  // AFTER DELETE
  private static void afterDelete(List<Milestones__c> oldMilestones) {
    System.debug(
      'MilestoneTriggerHandler: After Delete executed for ' +
        oldMilestones.size() +
        ' records'
    );

    // Update project completion percentage after milestones are deleted
    MilestoneController.updateProjectCompletionPercentage(oldMilestones);
  }

  // AFTER UNDELETE
  private static void afterUndelete(List<Milestones__c> newMilestones) {
  }
}
