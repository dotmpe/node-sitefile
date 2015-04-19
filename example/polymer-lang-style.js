Polymer('lang-style-select', {

  linkId: 'lang-style',

  setStyle: function(e) {
    var link = document.querySelector('link#'+this.linkId);
    var style = e.target.templateInstance.model.style;
    var href = "/components/prism/themes/prism-"+style.name+".css";
    link.setAttribute( 'href', href );
  },

  initLink: function() {
    var link = document.createElement('link');
    link.setAttribute('id', this.linkId);
    link.setAttribute('rel', 'stylesheet');
    link.setAttribute('type', 'text/css');
    var head = document.querySelector('head');
    head.appendChild(link);
  },

  init: function() {
    var link = document.querySelector('link#'+this.linkId);
    if (typeof link === 'undefined') {
      this.initLink();
    }
    this.styles = [
      {label: 'Coy (Light)', name: 'coy'},
      {label: 'Dark (Brown)', name: 'dark'},
      //{label: 'Tomorrow (Dark Brown)', name: 'tomorrow'},
      //{label: 'Twilight (Black)', name: 'twilight'},
    ];
  }
});
