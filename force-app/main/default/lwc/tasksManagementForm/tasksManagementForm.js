import { LightningElement, track, api } from "lwc";

export default class tasksManagementForm extends LightningElement {
  @track milestoneDataStorage = [];
  @api milestoneData;

  connectedCallback() {
    if (this.milestoneData) {
      this.milestoneDataStorage = Object.values(this.milestoneData).map(
        (mile) => ({
          ...mile,
          tasks: mile.tasks || []
        })
      );
    }
  }

  handleAddTask(event) {
    const milestoneId = parseInt(event.target.dataset.id, 10);
    const newTask = {
      name: "",
      dueDate: ""
    };

    this.milestoneDataStorage = this.milestoneDataStorage.map((mile) => {
      if (mile.id === milestoneId) {
        return {
          ...mile,
          tasks: [...mile.tasks, newTask]
        };
      }

      return mile;
    });
  }

  handleTaskChange(event) {
    const milestoneId = parseInt(event.target.dataset.id, 10);
    const index = parseInt(event.target.dataset.taskId, 10);
    const fieldName = event.target.name;
    const fieldValue = event.target.value;

    this.milestoneDataStorage = this.milestoneDataStorage.map((mile) => {
      if (mile.id === milestoneId) {
        const updatedTasks = [...mile.tasks];
        updatedTasks[index] = {
          ...updatedTasks[index],
          [fieldName]: fieldValue
        };

        console.log("handleTaskChange 1" + JSON.stringify(mile));
        return {
          ...mile,
          tasks: updatedTasks
        };
      }

      console.log("handleTaskChange 2" + JSON.stringify(mile));
      return mile;
    });
  }

  handleRemoveTask(event) {
    const milestoneId = parseInt(event.target.dataset.id, 10);
    const index = parseInt(event.target.dataset.taskId, 10);

    this.milestoneDataStorage = this.milestoneDataStorage.map((mile) => {
      if (mile.id === milestoneId) {
        const updatedTasks = [...mile.tasks];
        updatedTasks.splice(index, 1);

        console.log("handleRemoveTask 1" + JSON.stringify(mile));
        return { ...mile, tasks: updatedTasks };
      }

      console.log("handleRemoveTask 2" + JSON.stringify(mile));
      return mile;
    });
  }

  @api
  validateInputs() {
    const inputs = this.template.querySelectorAll("lightning-input");
    let isValid = true;

    console.log("VALIDATION 3 STEP");
    inputs.forEach((input) => {
      if (!input.checkValidity()) {
        input.reportValidity();
        isValid = false;
      }
    });

    if (isValid) {
      this.dispatchEvent(
        new CustomEvent("eventtaskdata", {
          detail: [...this.milestoneDataStorage]
        })
      );
    }

    return isValid;
  }
}
