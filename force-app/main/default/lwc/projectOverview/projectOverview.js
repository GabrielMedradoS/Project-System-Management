// projectMilestonesOverview.js
import { LightningElement, api, wire, track } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

import projectOverview from "@salesforce/apex/ProjectController.projectOverview";

import PROJECT_NAME_FIELD from "@salesforce/schema/Projects__c.ProjectTitle__c";
import PROJECT_DESCRIPTION_FIELD from "@salesforce/schema/Projects__c.Description__c";
import PROJECT_STATUS_FIELD from "@salesforce/schema/Projects__c.Status__c";
import PROJECT_START_DATE_FIELD from "@salesforce/schema/Projects__c.StartDate__c";
import PROJECT_END_DATE_FIELD from "@salesforce/schema/Projects__c.EndDate__c";

const PROJECT_FIELDS = [
  PROJECT_NAME_FIELD,
  PROJECT_DESCRIPTION_FIELD,
  PROJECT_STATUS_FIELD,
  PROJECT_START_DATE_FIELD,
  PROJECT_END_DATE_FIELD
];

export default class ProjectMilestonesOverview extends LightningElement {
  @api recordId;

  @track projectData = {};
  milestonesData = [];
  error;
  isLoading = true;

  @wire(getRecord, { recordId: "$recordId", fields: PROJECT_FIELDS })
  wiredProject({ error, data }) {
    if (data) {
      this.projectData = {
        name: getFieldValue(data, PROJECT_NAME_FIELD),
        description: getFieldValue(data, PROJECT_DESCRIPTION_FIELD),
        status: getFieldValue(data, PROJECT_STATUS_FIELD),
        startDate: getFieldValue(data, PROJECT_START_DATE_FIELD),
        endDate: getFieldValue(data, PROJECT_END_DATE_FIELD)
      };
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.projectData = undefined;
    }
  }

  // Wire to get Milestones and Tasks
  @wire(projectOverview, { projectId: "$recordId" })
  wiredMilestones({ error, data }) {
    this.isLoading = false;
    if (data) {
      this.milestonesData = data;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.milestonesData = [];
    }
  }

  get projectStatus() {
    switch (this.projectData.status) {
      case "Active":
      case "In Progress":
        return "success";
      case "Completed":
        return "success";
      default:
        return "neutral";
    }
  }

  projectDescription() {
    return this.projectData.description;
  }
}
