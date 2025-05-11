# Event Registration System – Mobile Frontend

This project is the mobile frontend component for the EventRegistrationSystem GitHub organisation.

## How It's Made

**Tech used:** All code is written using the Flutter framework in the Dart language.

## Prerequisites for Local Setup

* Flutter Framework installed: https://docs.flutter.dev/get-started/install  
* Android SDK installed: https://developer.android.com/about/versions/14/setup-sdk  
* Backend setup locally (will not require in future): https://github.com/EventRegistrationSystem/EventRegistrationSystem-Backend/blob/Staging/README.md

## Local Setup Instructions

* Step 0: Install and setup all prerequisites  
* Step 1: Clone Repository:  
  ```bash
  git clone https://github.com/EventRegistrationSystem/EventRegistrationSystem-MobileFrontend.git
  ```
* Step 2: Import packages:  
  In the root directory of the project, enter the following command:  
  ```bash
  flutter pub get
  ```
* Step 3: Run Project  
  **In VSCode:**  
  Open the command palette and enter:  
  ```bash
  >flutter select device
  ```
  Then select your emulator. Navigate to the main file and run the project without debugging.  
  **From Command Line:**  
  ```bash
  flutter run lib/main.dart
  ```

## Completed Features

### User Account Authentication and Management

* User Login  
* User Registration  
* Change Password  
* User Logout  

### Event Management

* Event & Questionnaire Creation  
* Event Drafting and Publishing  
* Preliminary Event Management Page  

### Event Exploration and Registration

* Exploration Page shows events in backend  
* Exploration Page links to registration page  

## In Progress Features

* Filtered Searching  
* All event management features completed:  
  * Edit Event Description  
  * Edit Event Questions  
  * Edit Event Tickets  
* Payment and Registration Backend Integration

## Branch Structure

* **main** – latest stable version  
* **staging** – any final steps before deployment of a feature to main  
* **uat** – dedicated environment for User Acceptance Testing  
* **development** – environment for in-progress code  
* **feature/*** – before features are merged to the development branch they are created and implemented in their separate branch

## For More Information

See: [Link to docs here]