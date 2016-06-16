"use strict";

jQuery(document).ready(function ($) {
  if (location.hash && /^#[^<>"'&]+$/.test(location.hash)) {
    var $anchor = $(location.hash);
    if ($anchor.length > 0) {
      var targetTop = $anchor.offset().top;
      if (!$anchor.is("a.anchor")) targetTop -= 150;
      $("html, body").animate({ scrollTop: targetTop });
      $anchor.parents().andSelf().addClass("target");
    }
  }

  $("h1, h2").contents()
  .filter(function () { return this.nodeType === 3 })
  .each(function () {
    var matched = /^\s*Ch.(\d+)\s*-\s*(.+?)\s*$/.exec(this.nodeValue);
    if (matched) {
      var title = matched[2].split(/\s+/).map(function (line) {
        return $("<span>").addClass("chapter-title-line").text(line);
      });
      $("<div/>").addClass("chapter clearfix")
        .append($("<div>").addClass("chapter-number").text(matched[1]))
        .append($("<div>").addClass("chapter-title").html(title))
        .replaceAll(this);
    }
  });
});
