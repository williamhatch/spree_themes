function Search() {

  this.init = function() {
    this.initializeTemplateSearch();
  }

  this.initializeTemplateSearch = function() {
    $('#search-input').on('keyup', function() {
      var keyword = $(this).val().toUpperCase();
      var $table = $('#listing_templates');
      var rows = $table.find('tr');

      $.each(rows, function(i, val) {
        var td = $(this).find('td')[0];
        if(td) {
          // finding index 0 as searching on the basis of name only.
          var name = $(td).find('a.template-name')[0];

          if(name.innerHTML.toUpperCase().indexOf(keyword) > -1) {
            $(this).css('display','');
          } else {
            $(this).css('display','none');
          }
        }
      });
    });
  }
}

$(document).ready(function() {
  new Search().init();
});
