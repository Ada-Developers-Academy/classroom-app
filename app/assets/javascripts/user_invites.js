// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  // Make table of students sortable
  $('#invites-table').DataTable({
    paging: false,
    "order": [[1, "asc"], [ 4, "desc" ], [ 2, "asc" ], [ 0, "asc" ]]
  });
});
