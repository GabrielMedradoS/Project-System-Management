import { LightningElement, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import processFromJSON from "@salesforce/apex/ProjectMilestoneTaskProcessor.processFromJSON";

export default class ProgressBar extends LightningElement {
  @track isLoading = false;
  @track currentStep = "projectStepDetails";
  @track projectData;
  @track milestoneData;
  @track data;

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
    summary: {
      label: "Summary",
      value: "summaryStepDetails"
    }
  };

  get disablePrevious() {
    return this.currentStep === "projectStepDetails";
  }

  get disabledNext() {
    return this.currentStep === "summaryStepDetails";
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

  get summaryStepDetails() {
    return this.currentStep === "summaryStepDetails";
  }

  previousStep() {
    if (this.currentStep === "milestoneStepDetails") {
      this.currentStep = this.steps.project.value;
    }
    if (this.currentStep === "tasksStepDetails") {
      this.currentStep = this.steps.milestone.value;
    }
    if (this.currentStep === "summaryStepDetails") {
      this.currentStep = this.steps.tasks.value;
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

    // if (this.currentStep === "tasksStepDetails") {
    //   const cmp = this.template.querySelector("c-tasks-management-form");
    //   if (cmp && cmp.validateInputs()) {
    //     console.log("milestoneDataTasks " + this.milestoneData);
    //     this.currentStep = this.steps.summary.value;
    //   }
    // }
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

    if (this.projectData && this.milestoneData) {
      const data = { ...this.projectData, milestones: this.milestoneData };
      console.log("Joined Summary: ", JSON.stringify(data));
    }
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
        console.log(JSON.stringify(result.data));
        console.log(result.data);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Order created",
            variant: "success"
          })
        );
        this.isLoading = false;
      })
      .catch((error) => {
        console.error(error);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error",
            message: error.body.message,
            variant: "error"
          })
        );
      });
  }
}
