function Main() {

  this.init = function() {
    this.initializeEditor();
    this.uploadTheme();
  }

  this.initializeEditor = function() {
    var codeMirror = CodeMirror.fromTextArea($('#themes_template_body')[0], {
      lineNumbers: true,
      extraKeys: { "Ctrl-Space": "autocomplete" },
      mode: { name: "javascript", globalVars: true }
    });

    codeMirror.setSize(800, 500);
  }

}

$(document).ready(function() {
  new Main().init();
});
