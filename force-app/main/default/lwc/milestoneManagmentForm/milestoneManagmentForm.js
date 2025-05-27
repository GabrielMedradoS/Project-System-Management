import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class MilestoneManagmentForm extends LightningElement {
  @api projectData;
  milestoneData = [];

  renderedCallback() {
    if (this.projectData && this.milestoneData.length === 0) {
      this.initializeMilestones();
    }
  }

  initializeMilestones() {
    const count = parseInt(this.projectData.milestoneNumber, 10) || 0;

    this.milestoneData = Array.from({ length: count }, (_, i) => ({
      id: i,
      name: `${this.getOrdinal(i + 1)} Milestone`,
      type: i + 1,
      dueDate: null,
      tasksCheckbox: false,
      tasks: []
    }));
  }

  inputHandleChange(event) {
    const index = parseInt(event.target.dataset.index, 10);
    const field = event.target.name;
    const value =
      field === "tasksCheckbox" ? event.target.checked : event.target.value;

    this.milestoneData = this.milestoneData.map((item) => {
      if (item.id === index) {
        item[field] = value;
      }

      return item;
    });
  }

  @api
  validateInputs() {
    const inputs = this.template.querySelectorAll("lightning-input");
    let isValid = true;

    console.log("VALIDATION 2 STEP");
    inputs.forEach((input) => {
      if (!input.checkValidity()) {
        input.reportValidity();
        isValid = false;

        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error",
            message: "Please fill all required fields",
            variant: "error"
          })
        );
      }
    });

    if (isValid) {
      this.dispatchEvent(
        new CustomEvent("eventmilestonedata", {
          detail: [...this.milestoneData]
        })
      );
    }

    return isValid;
  }

  getOrdinal(n) {
    const s = ["th", "st", "nd", "rd"];
    const v = n % 100;
    return n + (s[(v - 20) % 10] || s[v] || "th");
  }
}
