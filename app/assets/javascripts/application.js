// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require select2-full
//= require Chart.bundle
//= require chartkick
//= require best_in_place
//= require jquery-ui/datepicker
//= require best_in_place.jquery-ui
//= require jquery.ui.widget
//= require z.jquery.fileupload
//= require_tree .

$(document).ready(function() {
  var payeeSelect = $('select#payee').select2({
    width: '100%',
    theme: "bootstrap",
    placeholder: 'Payee',
    tags: true
  });
  var categorySelect = $('select#category').select2({
    width: '100%',
    theme: "bootstrap",
    placeholder: 'Category',
    tags: true
  });
  payeeSelect.val([' ']).trigger("change");
  categorySelect.val([' ']).trigger("change");

  $('.datepicker').datepicker({dateFormat: 'yy-mm-dd'});

  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();

});

$(function() {
  var fileInput = $("#receipt");
  var form = $(".directUpload");
  var submitButton = $("#submit");
  var progressBar  = $("<div class='bar'></div>");
  var barContainer = $("<div class='progress'></div>").append(progressBar);
  fileInput.after(barContainer);
  fileInput.fileupload({
    fileInput:       fileInput,
    url:             form.data('url'),
    type:            'POST',
    autoUpload:       true,
    formData:         form.data('form-data'),
    paramName:        'file',
    dataType:         'XML',
    replaceFileInput: false,
    progressall: function (e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      progressBar.css('width', progress + '%')
    },
    start: function (e) {
      submitButton.prop('disabled', true);

      progressBar.
        css('background', 'green').
        css('display', 'block').
        css('width', '0%').
        text("Loading...");
    },
    done: function(e, data) {
      submitButton.prop('disabled', false);
      progressBar.text("Uploading done");    
      // extract key and generate URL from response
      var key   = $(data.jqXHR.responseXML).find("Key").text();   
      var url   = 'https://' + form.data('host') + '/' + key;
      // create hidden field
      var input = $("<input />", { type:'hidden', name: fileInput.attr('name'), value: url });  
      form.append(input);
      fileInput.attr('name','diasabled-receipt');
    },
    fail: function(e, data) {
      submitButton.prop('disabled', false);

      progressBar.
        css("background", "red").
        text("Failed");
    }
  });
});  
