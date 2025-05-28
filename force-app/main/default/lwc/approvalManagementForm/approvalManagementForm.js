import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class ApprovalManagementForm extends NavigationMixin(
  LightningElement
) {
  @api projectCreatedInfo;

  handleViewProject() {
    console.log(this.projectCreatedInfo.projectId);

    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: this.projectCreatedInfo.projectId,
        objectApiName: "Project__c",
        actionName: "view"
      }
    });
  }

  handleCreateAnother() {
    window.location.reload();
  }
}
