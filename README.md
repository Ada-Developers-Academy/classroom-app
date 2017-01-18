# Ada Pull Request Application

This app is created to use the GitHub API to read pull request data for configured projects in order to determine whether or not a student has submitted their assignment.

## Overall Setup
To setup the application overall, it requires the initial seeding of cohort information as well as students.

## Project Setup
Each individual project must be added to the list of repositories to be set up for configuration. The URL for each individual repo should be in the "Ada-CX/ProjectName" format. No additional portion of the URL needs to be provided. The repo configuration shall indicate whether or not the project was set up as individual or group, in order for the logic to appropriately determine submissions.

## Roles
Ideally this application has configuration for two different roles, **Instructor** and **Student**. Instructors shall have access to configuration for Students, Repos and submitting Feedback. Students shall have access to their submissions and the corresponding URLs to their PR as well as feedback (once submitted).
