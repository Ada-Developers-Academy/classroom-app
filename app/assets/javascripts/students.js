// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  // Make table of students sortable
  $('#student-table').DataTable({
    paging: false,
    "order": [[ 0, "asc" ]]
  });
});
