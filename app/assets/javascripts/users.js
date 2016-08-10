$(function() {
  initPage();
});
$(window).bind('page:change', function() {
  initPage();
});
function initPage() {
  $('input.location').addresspicker();
  $('input#location').addresspicker();
  $('input#profile_user_attributes_location').addresspicker();
  $('input#profile_location').addresspicker();
  $('input#job_location').addresspicker();
}
