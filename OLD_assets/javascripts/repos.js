// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function() {
  // Make table of student submissions on the assignment show page sortable
  $('#submission-table').DataTable({
    paging: false,
    "order": [[ 0, "asc" ]]
  });

  // Make the master table of repos on the index page sortable
  $('#assignment-table').DataTable({
    paging: false,
    "order": [[ 4, "desc" ]]
  });
});
