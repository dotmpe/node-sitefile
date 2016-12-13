(function(exports) {
  "use strict";

  function Bookmark(name, description, href, tags) {
    this.name = name || "Untitled Bookmark";
    this.description = description;
    this.href = href || "about:blank";
    this.tags = tags || [];
  }
  exports.Bookmark = Bookmark;

  Bookmark.prototype = {
    link: function(format) {
      switch (format) {
        case "html": return [
            '<a href="', this.href, '">', this.name, '</a>'
          ].join("");
        case "rst": return [
            '`', this.name, ' <', this.href, '>`_'
          ].join("");
        default: throw "No such format";
      }
    },
  };
})(this);
