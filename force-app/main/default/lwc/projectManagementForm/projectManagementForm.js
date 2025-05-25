import { LightningElement, track, wire, api } from "lwc";

import { getObjectInfo } from "lightning/uiObjectInfoApi";
import { getPicklistValues } from "lightning/uiObjectInfoApi";

import PROJECT_OBJECT from "@salesforce/schema/Projects__c";
import PRIORITY_FIELD from "@salesforce/schema/Projects__c.Priority__c";

export default class ProjectManagementForm extends LightningElement {
  @track
  priorityOptions;
  priority;

  projectData = { milestoneNumber: 1 };

  @wire(getObjectInfo, { objectApiName: PROJECT_OBJECT })
  projectInfo;

  @wire(getPicklistValues, {
    recordTypeId: "$projectInfo.data.defaultRecordTypeId",
    fieldApiName: PRIORITY_FIELD
  })
  wiredPicklistValues({ error, data }) {
    if (data) {
      this.priorityOptions = data.values;
      this.priority = this.priorityOptions[0].value;
    } else if (error) {
      console.log("Error retrieving data", error);
    }
  }

  inputChangeHandler(event) {
    const { name, value } = event.target;
    this.projectData[name] = value;
  }

  @api
  validateInputs() {
    const inputs = this.template.querySelectorAll("lightning-input");
    let isValid = true;

    console.log("VALIDATION 1 STEP");
    inputs.forEach((input) => {
      if (!input.checkValidity()) {
        input.reportValidity();
        isValid = false;
      }
    });

    if (isValid) {
      this.dispatchEvent(
        new CustomEvent("eventprojectdata", {
          detail: { ...this.projectData }
        })
      );
    }

    return isValid;
  }
}
