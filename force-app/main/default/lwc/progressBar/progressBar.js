import { LightningElement, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import processFromJSON from "@salesforce/apex/ProjectMilestoneTaskProcessor.processFromJSON";

export default class ProgressBar extends LightningElement {
  @track isLoading = false;
  @track currentStep = "projectStepDetails";
  @track projectData;
  @track milestoneData;
  @track projectCreatedInfo;

  steps = {
    project: {
      label: "Project Details",
      value: "projectStepDetails"
    },
    milestone: {
      label: "Milestones Details",
      value: "milestoneStepDetails"
    },
    tasks: {
      label: "Tasks Details",
      value: "tasksStepDetails"
    },
    approved: {
      label: "Approved Project",
      value: "approvedProjectStepDetails"
    }
  };

  get disablePrevious() {
    return (
      this.currentStep === "projectStepDetails" ||
      this.currentStep === "approvedProjectStepDetails"
    );
  }

  get disabledNext() {
    return this.currentStep === "approvedProjectStepDetails";
  }

  get projectStepDetails() {
    return this.currentStep === "projectStepDetails";
  }

  get milestoneStepDetails() {
    return this.currentStep === "milestoneStepDetails";
  }

  get tasksStepDetails() {
    return this.currentStep === "tasksStepDetails";
  }

  get approvedProjectStepDetails() {
    return this.currentStep === "approvedProjectStepDetails";
  }

  previousStep() {
    if (this.currentStep === "milestoneStepDetails") {
      this.currentStep = this.steps.project.value;
    }
    if (this.currentStep === "tasksStepDetails") {
      this.currentStep = this.steps.milestone.value;
    }
  }

  nextStep() {
    if (this.currentStep === "projectStepDetails") {
      const cmp = this.template.querySelector("c-project-management-form");
      if (cmp && cmp.validateInputs()) {
        this.currentStep = this.steps.milestone.value;
      }
    }

    if (this.currentStep === "milestoneStepDetails") {
      const cmp = this.template.querySelector("c-milestone-managment-form");
      if (cmp && cmp.validateInputs()) {
        this.currentStep = this.steps.tasks.value;
      }
    }
  }

  projectHandleChange(event) {
    this.projectData = event.detail;
    console.log("projectData: ", JSON.stringify(this.projectData));
  }

  milestoneHandleChange(event) {
    this.milestoneData = event.detail;
    console.log("milestoneData: ", JSON.stringify(this.milestoneData));
  }

  taskHandleChange(event) {
    this.milestoneData = event.detail;
    console.log("milestoneDataTasks: ", JSON.stringify(this.milestoneData));
  }

  handleSubmit() {
    const cmp = this.template.querySelector("c-tasks-management-form");
    if (cmp && cmp.validateInputs()) {
      if (this.projectData && this.milestoneData) {
        const payload = { ...this.projectData, milestones: this.milestoneData };
        console.log("Joined Summary: ", JSON.stringify(payload));
        this.isLoading = true;
        this.createProjectRecord(payload);
      }
    }
  }

  createProjectRecord(payload) {
    processFromJSON({ data: payload })
      .then((result) => {
        console.log("result " + JSON.stringify(result));
        this.projectCreatedInfo = result;

        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: result.message,
            variant: "success"
          })
        );
        this.isLoading = false;
        this.currentStep = this.steps.approved.value;
      })
      .catch((error) => {
        console.error("Apex call error:", error);
        console.error(error);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Apex Error",
            message: error.body.message,
            variant: "error"
          })
        );
      });
  }
}
