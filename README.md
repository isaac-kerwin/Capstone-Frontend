# Event Registration System - Moible Frontend
This project is the mobile frontend component for the EventRegistrationSystem GitHub Organisation

## How It's Made:

**Tech used:** all code is written using the flutter frameworking in the dart language.

## Prequisites for local setup
*Flutter Framework Installed:https://docs.flutter.dev/get-started/install
*Android SDK installed: https://developer.android.com/about/versions/14/setup-sdk
*Backend setup locally (will not require in future): https://github.com/EventRegistrationSystem/EventRegistrationSystem-Backend/blob/Staging/README.md

## Local Setup Instructions
*Step 0: Install and setup all Prerequisites
*Step 1: Clone Repository: ''''git clone https://github.com/EventRegistrationSystem/EventRegistrationSystem-MobileFrontend.git''''
*Step 2: Import packages: In root directory of project enter the following command into the terminal ''''flutter pub get''''
*Step 3: Run Project
** in VSCode: In VSCode command bar enter ''''>flutter select device'''' then select your emulator, Navigate to main file and run project without debugging
** from Command Line: ''''flutter run lib/main.dart''''

## Completed Features:
###User Account Autentication and Management
*User Login
*User Registration
*Change Password
*User Logout

###Event Management
*Event & Questionairre Creation
*Event Drafting and publishing
*Preliminary Event Management page

###Event Exploration and Registration
*Exploration Page shows events in backend
*Exploration Page links to registration page

##In Progress Features
*Filtered Searching
*All event management features completed
**Edit Event Description
**Edit Event Questions
**Edit Event Tickets
*Payment and Registration Backend integration

## For more information see: Link to docs here

## Branch Structure
*Main - latest stable version
*Staging - Any final steps before deployment of a feature to main
*UAT - dedicated environment for User Acceptance Testing to be performed
*development - environment for in-progress code
*other features - before features are merged to development branch they are created and implemented in their seperate branch

