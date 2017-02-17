# Ada Pull Request Application

This app is created to use the GitHub API to read pull request data for configured projects in order to determine whether or not a student has submitted their assignment.

## Overall Setup
To setup the application overall, it requires the initial seeding of cohort information as well as students.

## Project Setup
Each individual project must be added to the list of repositories to be set up for configuration. The URL for each individual repo should be in the "Ada-CX/ProjectName" format. No additional portion of the URL needs to be provided. The repo configuration shall indicate whether or not the project was set up as individual or group, in order for the logic to appropriately determine submissions.

## Roles
Ideally this application has configuration for two different roles, **Instructor** and **Student**. Instructors shall have access to configuration for Students, Repos and submitting Feedback. Students shall have access to their submissions and the corresponding URLs to their PR as well as feedback (once submitted).

## Development Setup

1. Clone this repo
1. `rvm install ruby-2.2.1`
1. `gem install bundle`
1. `bundle install`
1. Email Charles to get the `lib/seeds/students.csv` file, and add it to the project. It will be ignored by git.
1. `bin/rake db:migrate`
1. [Register a new app on github](https://github.com/settings/developers), with a callback URL of `http://localhost:3000/auth/github/callback`
1. `touch .env`
1. Add the `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` from the app you just registered to the `.env` file
1. `rails s`
1. App should be running at `localhost:3000`
