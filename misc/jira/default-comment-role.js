(function ($) {
  var defaultRoleName = "role:10001";

  function changeCommentLevel() {
    var $form = $(this).closest('form');

    if ($(this).val() !== "") {
      return;
    }

    var commentLevelSelect = $('.security-level select#commentLevel option[value=\'' + defaultRoleName + '\']', $form);

    if (commentLevelSelect) {
      var labelText = commentLevelSelect.first().text();
      $("select#commentLevel", $form).val(defaultRoleName);
      $("#commentLevel-multi-select a.drop span.icon", $form).removeClass("icon-unlocked").addClass("icon-locked");
      var htmlEscapedLabel = AJS.$("<div/>").text(labelText).html();
      $(".security-level span.current-level", $form).html(AJS.format(AJS.params.securityLevelViewableRestrictedTo, htmlEscapedLabel));
    }
  }

  $(document).on('focus', '#comment', changeCommentLevel);
})(jQuery);
