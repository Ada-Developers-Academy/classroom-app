# Ada Pull Request Application

This app is created to use the GitHub API to read pull request data for configured projects in order to determine whether or not a student has submitted their assignment.

## Overall Setup
To setup the application overall, it requires the initial seeding of classroom information as well as students.

## Project Setup
Each individual project must be added to the list of repositories to be set up for configuration. The URL for each individual repo should be in the "Ada-CX/ProjectName" format. No additional portion of the URL needs to be provided. The repo configuration shall indicate whether or not the project was set up as individual or group, in order for the logic to appropriately determine submissions.

## Roles
Ideally this application has configuration for two different roles, **Instructor** and **Student**. Instructors shall have access to configuration for Students, Assignments and submitting Feedback. Students shall have access to their submissions and the corresponding URLs to their PR as well as feedback (once submitted).

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


## IMPORTANT!
Things NOT done from Rails Guide [update list](http://guides.rubyonrails.org)
- [Autoloading is Disabled After Booting in the Production Environment](http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#autoloading-is-disabled-after-booting-in-the-production-environment)
- [Removed Support for Legacy mysql Database Adapter](http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#removed-support-for-legacy-mysql-database-adapter)
- [Removed Support for Debugger](http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#removed-support-for-debugger)
- [Use bin/rails for running tasks and tests](http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#use-bin-rails-for-running-tasks-and-tests) - nothing to change(?)
- [ActionController::Parameters No Longer Inherits from HashWithIndifferentAccess](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#actioncontroller-parameters-no-longer-inherits-from-hashwithindifferentaccess)
- [protect_from_forgery Now Defaults to prepend: false](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#protect-from-forgery-now-defaults-to-prepend-false)
- [Default Template Handler is Now RAW](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#default-template-handler-is-now-raw)
- [Added Wildcard Matching for Template Dependencies](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#added-wildcard-matching-for-template-dependencies)
- [ActionView::Helpers::RecordTagHelper moved to external gem (record_tag_helper)](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#actionview-helpers-recordtaghelper-moved-to-external-gem-record-tag-helper)
- [Removed Support for protected_attributes Gem](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#removed-support-for-protected-attributes-gem)
- [Removed support for activerecord-deprecated_finders gem](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#removed-support-for-activerecord-deprecated-finders-gem)
- [ActiveSupport::TestCase Default Test Order is Now Random](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#activesupport-testcase-default-test-order-is-now-random)
- [ActionController::Live became a Concern](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#actioncontroller-live-became-a-concern)
- [New Framework Defaults (several!)](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#new-framework-defaults)
- [Changes with JSON/JSONB serialization](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#changes-with-json-jsonb-serialization)
- [Expiry in signed or encrypted cookie is now embedded in the cookies values](http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#expiry-in-signed-or-encrypted-cookie-is-now-embedded-in-the-cookies-values)

## Issues
1. enum gem no longer supported.
1. btree thing missing from schema
1. workaround for tests is probably wrong (or maybe not?? https://stackoverflow.com/questions/43797133/controller-spec-unknown-keyword-id)
1. gems for markdown preview no longer works or is supported. List is possible replacements
    - [draft-js](https://github.com/facebook/draft-js) ([Docs](https://draftjs.org/docs/getting-started.html)) - also has an active community building [resources](https://github.com/nikgraf/awesome-draft-js)
    - [react-markdown-editor](https://github.com/jrm2k6/react-markdown-editor)
    - [react-mde](https://github.com/andrerpena/react-mde)
    
## Kirsten's Random Notes
from /Users/kirstenschumy/Documents/Ada/capstone-project/ada-prs/app/assets/javascripts/application.js  
//= require epiceditor

## Significant Changes
- repos table renamed to assignments
- cohort table renamed to classroom
- front-end deleted 
