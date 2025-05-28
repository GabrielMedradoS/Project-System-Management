## Project System Management

<p align='center'>
<b height="50%" width="50%"></b>
</p>

<p align="center">
    <img alt="Platform" src="https://img.shields.io/static/v1?label=Platform&message=Salesforce&color=0369a1&labelColor=f0f9ff">
    <img alt="project name" src="https://img.shields.io/badge/Project-Management-0369a1?&labelColor=f0f9ff"></img>    
    <img alt="Repository size" src="https://img.shields.io/github/repo-size/GabrielMedradoS/Project-System-Management?color=0369a1&labelColor=f0f9ff">
    <img alt="GitHub Last Commit" src="https://img.shields.io/github/last-commit/gabrielmedrados/Project-System-Management?&color=0369a1&labelColor=f0f9ff">    
</p>

<p align="center">
    <a href="#-Objectives">Objectives</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
    <a href="#-features">Features</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
    <a href="#-Demonstration">Demonstration</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
    <a href="#-Documentation">Documentation</a> &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
    <a href="#-autor">Author</a> 
</p>

## 📷 Layout

#### Screenshot:

<div align='center'>
<img src=".github/github image.png"/>
</div>

## 🎯 Objectives

<div align="justify">
    (Project System Management) <br>
    This project aims to create a simple project management system within Salesforce, leveraging standard platform features such as standard objects (Task) and Lightning Web Components (LWC), and extending the functionality with custom objects such as Projects__c and Milestones__c. The system allows you to track the lifecycle of a project, its milestones, and the tasks (to-dos) associated with each stage.
</div>

## ✨ Features

- [x] 1. Automatic calculation of the % completion of Milestones based on tasks.
- [x] 2. Automatic calculation of the % completion of Projects based on Milestones.
- [x] 3. Automatic status control: “Not Started”, “In Progress” or “Completed.
- [x] 4. Restriction with Validation Rules so that regular users cannot manually change the status of projects and milestones.

## 💻 Demonstration:

<div align='center'>
🚧 Under construction 🚧
</div>

## 🚴🏻‍♂️ Run the project

To download the project's source code to your machine, you will first need to have [**Git**](https://git-scm.com/).
With Git installed, run the following command in your terminal:

```bash
git clone https://github.com/GabrielMedradoS/Project-System-Management.git
```

To install the dependencies and run the project you will need to have [**node.js**](https://nodejs.org/en/), installed on your machine, which comes with npm.

Install dependencies with **npm**:

```bash
# npm
npm install
```

Execute the project:

```bash
# npm
npm run dev
```

Log in a Org Salesforce

## 📜 Documentation

The main App is Project Management, there you will see all related tabs to make your first project.

You will see a full documentation under [documents | Salesforce]() provided in email for more details.

#### 👇 Click to view Project Dependencies

<details>
  <summary>Package XML</summary>
  
```bash
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
	<types>
		<members>Milestones__c.Validation_Rule_Change_Status</members>
		<members>Projects__c.Validation_Rule_Change_Status</members>
		<name>ValidationRule</name>
	</types>
	<types>
		<members>MilestoneTrigger</members>
		<members>TaskTrigger</members>
		<name>ApexTrigger</name>
	</types>
	<types>
		<members>TaskTriggerHandler</members>
		<members>TaskController</members>
		<members>TaskControllerTest</members>
		<members>MilestoneController</members>
		<members>MilestoneControllerTest</members>
		<members>MilestoneTriggerHandler</members>
		<members>MilestoneWrapper</members>
		<members>ProjectController</members>
		<members>ProjectMilestoneTaskProcessor</members>
		<members>ProjectMilestoneTaskProcessorTest</members>
		<members>ProjectWrapper</members>
		<members>TaskWrapper</members>
		<name>ApexClass</name>
	</types>
	<types>
		<members>Milestones__c.Milestone_Compact_Layout</members>
		<members>Projects__c.Project_Compact_Layout</members>
		<name>CompactLayout</name>
	</types>
	<types>
		<members>image_branding</members>
		<name>ContentAsset</name>
	</types>
	<types>
		<members>Project_Management</members>
		<name>CustomApplication</name>
	</types>
	<types>
		<members>Activity</members>
		<members>Milestones__c</members>
		<members>Projects__c</members>
		<members>Task</members>
		<name>CustomObject</name>
	</types>
	<types>
		<members>Milestones__c</members>
		<members>Projects__c</members>
		<name>CustomTab</name>
	</types>
	<types>
		<members>Milestone_Record_Page</members>
		<members>Project_Management_UtilityBar</members>
		<members>Project_Record_Page</members>
		<members>Task_Record_Page</members>
		<members>Project_Home_Page</members>
		<name>FlexiPage</name>
	</types>
	<types>
		<members>GlobalStatusValue</members>
		<name>GlobalValueSet</name>
	</types>
	<types>
		<members>Milestones__c-Milestone Layout</members>
		<members>Projects__c-Project Layout</members>
		<members>Task-Project Task Layout</members>
		<name>Layout</name>
	</types>
	<types>
		<members>approvalManagementForm</members>
		<members>milestoneManagmentForm</members>
		<members>progressBar</members>
		<members>projectOverview</members>
		<members>projectManagementForm</members>
		<members>tasksManagementForm</members>
		<name>LightningComponentBundle</name>
	</types>
	<types>
		<members>Projects__c.All</members>
		<members>Projects__c.Completed_Projects</members>
		<members>Projects__c.New_Projects</members>
		<members>Projects__c.On_going_Projects</members>
		<name>ListView</name>
	</types>
	<types>
		<members>Milestone_Status_Path</members>
		<members>Project_Status_Path</members>
		<name>PathAssistant</name>
	</types>
	<version>63.0</version>
</Package>

````

</details>


<details>
    <summary>Dependencies</summary>

```json
{
  "name": "salesforce-app",
  "private": true,
  "version": "1.0.0",
  "description": "Project System Management",
  "scripts": {
    "lint": "eslint **/{aura,lwc}/**/*.js",
    "test": "npm run test:unit",
    "test:unit": "sfdx-lwc-jest",
    "test:unit:watch": "sfdx-lwc-jest --watch",
    "test:unit:debug": "sfdx-lwc-jest --debug",
    "test:unit:coverage": "sfdx-lwc-jest --coverage",
    "prettier": "prettier --write \"**/*.{cls,cmp,component,css,html,js,json,md,page,trigger,xml,yaml,yml}\"",
    "prettier:verify": "prettier --check \"**/*.{cls,cmp,component,css,html,js,json,md,page,trigger,xml,yaml,yml}\"",
    "postinstall": "husky init",
    "precommit": "lint-staged",
    "prepare": "husky"
  },
  "devDependencies": {
    "@lwc/eslint-plugin-lwc": "^2.2.0",
    "@lwc/engine-dom": "^8.18.0",
    "@lwc/jest-preset": "^19.1.0",
    "@prettier/plugin-xml": "^3.4.1",
    "@salesforce/eslint-config-lwc": "^3.7.2",
    "@salesforce/eslint-plugin-aura": "^2.1.0",
    "@salesforce/eslint-plugin-lightning": "^1.0.0",
    "@salesforce/sfdx-lwc-jest": "^7.0.1",
    "eslint": "^8.57.0",
    "eslint-plugin-import": "^2.31.0",
    "eslint-plugin-jest": "^28.11.0",
    "husky": "^9.1.7",
    "jest": "^29.7.0",
    "lint-staged": "^15.5.1",
    "prettier": "^3.5.3",
    "prettier-plugin-apex": "^2.2.6"
  },
  "lint-staged": {
    "**/*.{cls,cmp,component,css,html,js,json,md,page,trigger,xml,yaml,yml}": [
      "prettier --write"
    ],
    "**/{aura,lwc}/**/*.js": ["eslint"]
  }
}
````

</details>

- [Salesforce | documentation](https://developer.salesforce.com/docs)
- [Trailhead | documentation](https://trailhead.salesforce.com/pt-BR/today)

## 💡 Como contribuir

- Faça um **_fork_** desse repositório;
- Crie um **branch** para a sua feature: `git checkout -b minha-feature`;
- Faça um **commit** com suas alterações: `git commit -m 'feat: Minha nova feature'`;
- Faça um **push** para o seu branch: `git push origin minha-feature`;
- Faça um **pull request** com sua feature;

Pull requests são sempre bem-vindos. Em caso de dúvidas ou sugestões, crie uma _**issue**_ ou entre em contato comigo.

## ✍🏾 Autor

| <a href="https://github.com/gabrielmedrados/"><img src="https://user-images.githubusercontent.com/73303001/126536001-655e3cbd-facd-4de1-992f-b8d9d3656ace.jpg" width="100" alt="perfil"/><br>
| :-------------------------: |
| <a href="https://github.com/gabrielmedrados/"> Gabriel Medrado |</a> |

[![Linkedin Badge](https://img.shields.io/badge/-GabrielMedrado-blue?style=flat-square&logo=Linkedin&logoColor=white)](https://www.linkedin.com/in/gabriel-medrado-de-souza-9a30b3206/)
[![Gmail Badge](https://img.shields.io/badge/-gabriel.medradoo@hotmail.com-1769ff?style=flat-square&logo=Gmail&logoColor=white)](mailto:gabriel.medradoo@hotmail.com)
