trigger MilestoneTrigger on Milestones__c(
  before insert,
  before update,
  before delete,
  after insert,
  after update,
  after delete,
  after undelete
) {
  MilestoneTriggerHandler.execute();
}