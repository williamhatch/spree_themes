function Main() {

  this.init = function() {
    this.initializeEditor();
  }

  this.initializeEditor = function() {
    CodeMirror.fromTextArea($('#themes_template_body')[0], {
      lineNumbers: true,
      extraKeys: { "Ctrl-Space": "autocomplete" },
      mode: { name: "javascript", globalVars: true }
    });
  }
}

$(document).ready(function() {
  new Main().init();
});
