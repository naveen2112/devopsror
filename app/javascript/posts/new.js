$(document).on('turbolinks:load', function() {
    $("#new-post").validate({
        rules: {
            "post[title]": {
                required: true
            },
            "post[main_url]": {
                maxlength: 240 ,
                url: true
            }
        },
        highlight: function(element) {
            $(element).addClass("invalid")
        },
        unhighlight: function(element) {
            $(element).removeClass("invalid")
        },
        errorClass: 'error',
        validClass: 'success',
        errorElement: 'div',
        errorPlacement: function (error, element) {
            if (element.hasClass("password-type")) {
                error.insertAfter(element.next());
            } else {
                error.insertAfter(element);
            }
        }
    });

    $('form').on('click', '.add_fields', function(event) {
        var regexp, time;
        time = new Date().getTime();
        regexp = new RegExp($(this).data('id'), 'g');
        $('.fields').append($(this).data('fields').replace(regexp, time));
        return event.preventDefault();
      });
})
