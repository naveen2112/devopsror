$(document).on('turbolinks:load', function () {
    $("#new-post").validate({
        rules: {
            "post[title]": {
                required: true,
                remote: "validate_title"
            },
            "post[main_url]": {
                maxlength: 240,
                url: true,
                required: true
            },
            "post[commentries_attributes[1]][description]": {
                required: true
            }
        },
        messages: {
            "post[title]": {
                remote: jQuery.validator.format("Title is already in use.")
            },
            "post[commentries_attributes[1]][description]": {
                maxlength: "Please enter not more than 3000 characters"
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

    $("#new-post").on( "keypress", function(event) {
        if (event.which == 13 && event.shiftKey) {
            event.stopPropagation();
        }
        else if(event.which == 13){
            var $form = $('#new-post');
            $form.submit()
        }
    })
})
