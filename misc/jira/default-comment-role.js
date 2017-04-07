jQuery.noConflict();

var defaultRoleName = "role:10001";
var roleSelected = false;

function changeCommentLevel() {
  if (roleSelected) {
    return;
  }

  if (jQuery('#comment').val() != "") {
    roleSelected = true;
    return;
  }

  var commentLevelSelect = jQuery('.security-level select#commentLevel option[value=\'' + defaultRoleName + '\']');

  if (commentLevelSelect) {
    var labelText = commentLevelSelect.first().text();
    jQuery("select#commentLevel").val(defaultRoleName);
    jQuery("#commentLevel-multi-select a.drop span.icon").removeClass("icon-unlocked").addClass("icon-locked");
    var htmlEscapedLabel = AJS.$("<div/>").text(labelText).html();
    jQuery(".security-level span.current-level").html(AJS.format(AJS.params.securityLevelViewableRestrictedTo, htmlEscapedLabel));
    roleSelected = true;
  }

}

jQuery('#comment').live('focus', changeCommentLevel);
