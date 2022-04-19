$(document).on('turbolinks:load', function () {
    $("#edit-post").validate({
        rules: {
            "post[title]": {
                required: true,
                remote: "validate_title_except_current"
            },
            "post[main_url]": {
                maxlength: 240,
                url: true,
                required: true
            },
            "post[commentries_attributes[1]][description]": {
                required: true
            }
        }, messages: {
            "post[title]": {
                remote: jQuery.validator.format("Title is already in use.")
            }
        },
        highlight: function (element) {
            $(element).addClass("invalid")
        },
        unhighlight: function (element) {
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

    $("#edit-post").on( "keypress", function(event) {
        if (event.which == 13 && event.shiftKey) {
            event.stopPropagation();
        }
       else if (event.which == 13) {
            var $form = $('#edit-post');
            $form.submit()
        }
    })

})
