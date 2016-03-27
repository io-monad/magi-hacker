"use strict";

jQuery(document).ready(function ($) {
  if (location.hash && /^#[^<>"'&]+$/.test(location.hash)) {
    var $anchor = $(location.hash);
    if ($anchor.length > 0) {
      var targetTop = $anchor.offset().top - 100;
      $("html, body").animate({ scrollTop: targetTop });
      $anchor.parents().andSelf().addClass("target");
    }
  }
});
