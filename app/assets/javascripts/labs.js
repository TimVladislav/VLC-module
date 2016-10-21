jQuery(function($) {
  $('label').on("click", function(){
    var radio = "#" + $(this).attr("for").toString();
    var id = $('.code-write').attr("id")
    if ($(radio).attr("type").toString() == "radio") {

      $.ajax({
        url: 'butt_send',
        type: 'POST',
        data: { dev_id: $('#dev').attr("value"),lab_id: id, butt_name: $(this).attr("for").toString() },
        success: function(data) {
          document.getElementById('codewrite_code').focus();
          document.getElementById('codewrite_code').value = data;
        }
      });
    }
  });
});
