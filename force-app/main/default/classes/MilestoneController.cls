public with sharing class MilestoneController {
  public static void validateStatusTransitions(
    List<Milestones__c> newMilestones,
    Map<Id, Milestones__c> oldMilestoneMap
  ) {
    for (Milestones__c milestone : newMilestones) {
      Milestones__c oldMilestone = oldMilestoneMap.get(milestone.Id);

      // Example: Prevent changing from Completed to Not Started
      if (
        oldMilestone.Status__c == 'Completed' &&
        milestone.Status__c == 'Not Started'
      ) {
        milestone.Status__c.addError(
          'Cannot change status from Completed to Not Started'
        );
      }
    }
  }

  public static void preventCriticalMilestoneDeletion(
    List<Milestones__c> milestones
  ) {
    for (Milestones__c milestone : milestones) {
      if (milestone.Status__c == 'Completed' || milestone.IsActive__c) {
        milestone.addError('Cannot delete completed or active milestones');
      }
    }
  }

  public static List<Milestones__c> getStatusChangedMilestones(
    List<Milestones__c> newMilestones,
    Map<Id, Milestones__c> oldMilestoneMap
  ) {
    List<Milestones__c> statusChangedMilestones = new List<Milestones__c>();

    for (Milestones__c milestone : newMilestones) {
      Milestones__c oldMilestone = oldMilestoneMap.get(milestone.Id);

      if (milestone.Status__c != oldMilestone.Status__c) {
        statusChangedMilestones.add(milestone);
      }
    }

    return statusChangedMilestones;
  }

  public static void updateProjectCompletionPercentage(
    List<Milestones__c> milestones
  ) {
    Set<Id> projectIds = new Set<Id>();

    for (Milestones__c milestone : milestones) {
      if (milestone.ProjectId__c != null) {
        projectIds.add(milestone.ProjectId__c);
      }
    }

    if (projectIds.isEmpty()) {
      return;
    }

    Map<Id, Map<String, Object>> projectCompletionMap = calculateProjectCompletion(
      projectIds
    );

    updateProjectPercentageRecords(projectCompletionMap);
  }

  private static Map<Id, Map<String, Object>> calculateProjectCompletion(
    Set<Id> projectIds
  ) {
    Map<Id, Map<String, Object>> resultMap = new Map<Id, Map<String, Object>>();

    List<AggregateResult> totalResults = [
      SELECT ProjectId__c, COUNT(Id) totalMilestones
      FROM Milestones__c
      WHERE ProjectId__c IN :projectIds
      GROUP BY ProjectId__c
    ];

    List<AggregateResult> completedResults = [
      SELECT ProjectId__c, COUNT(Id) completedMilestones
      FROM Milestones__c
      WHERE ProjectId__c IN :projectIds AND Status__c = 'Completed'
      GROUP BY ProjectId__c
    ];

    Map<Id, Integer> totalMilestonesMap = new Map<Id, Integer>();
    for (AggregateResult result : totalResults) {
      Id projectId = (Id) result.get('ProjectId__c');
      Integer totalMilestones = (Integer) result.get('totalMilestones');
      totalMilestonesMap.put(projectId, totalMilestones);
    }

    Map<Id, Integer> completedMilestonesMap = new Map<Id, Integer>();
    for (AggregateResult result : completedResults) {
      Id projectId = (Id) result.get('ProjectId__c');
      Integer completedMilestones = (Integer) result.get('completedMilestones');
      completedMilestonesMap.put(projectId, completedMilestones);
    }

    for (Id projectId : totalMilestonesMap.keySet()) {
      Integer totalMilestones = totalMilestonesMap.get(projectId) != null
        ? totalMilestonesMap.get(projectId)
        : 0;
      Integer completedMilestones = completedMilestonesMap.get(projectId) !=
        null
        ? completedMilestonesMap.get(projectId)
        : 0;

      String status = '';
      Decimal percentage = 0;
      if (totalMilestones > 0) {
        percentage = (completedMilestones * 100.0) / totalMilestones;
        if (percentage == 100) {
          status = 'Completed';
        } else if (percentage > 0 && percentage < 100) {
          status = 'In Progress';
        } else {
          status = 'Not Started';
        }
      }

      resultMap.put(
        projectId,
        new Map<String, Object>{
          'percentage' => percentage,
          'status' => status
        }
      );
    }

    return resultMap;
  }

  private static void updateProjectPercentageRecords(
    Map<Id, Map<String, Object>> projectCompletionMap
  ) {
    List<Projects__c> projectsToUpdate = new List<Projects__c>();

    for (Id projectId : projectCompletionMap.keySet()) {
      Map<String, Object> dataMap = projectCompletionMap.get(projectId);

      Projects__c project = new Projects__c();
      project.Id = projectId;
      project.PercentCompleted__c = (Decimal) dataMap.get('percentage');
      project.Status__c = (String) dataMap.get('status');

      projectsToUpdate.add(project);
    }

    if (!projectsToUpdate.isEmpty()) {
      try {
        update projectsToUpdate;

        System.debug(
          'Successfully updated ' +
            projectsToUpdate.size() +
            ' project completion percentages'
        );
      } catch (DmlException e) {
        System.debug(
          'Error updating project completion percentages: ' + e.getMessage()
        );
        // Handle the exception as per your org's error handling strategy
      }
    }
  }
}
