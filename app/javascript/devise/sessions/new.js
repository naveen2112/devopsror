$(document).on('turbolinks:load', function() {
    let sign_in_form = $("#sign-in")
    $("#sign-in").validate({
        rules: {
            "user[email]": {
                required: true
            },
            "user[password]": {
                required: true,
                minlength: 6,
                maxlength: 60
            }
        },
        messages: {
            "user[password]": {
                maxlength: "Please enter not more than 60 characters."
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

    $("#sign-in").on( "keypress", function(event) {
        if (event.which == 13) {
            $("#sign-in").submit()
        }
    })

    $(document).on('click','.toggleButton',function(){

        var input = $("#exampleInputPassword");

        if (input.attr("type") === "password") {
            input.attr("type", "text");
            $(this).addClass("password-visible")
        } else {
            input.attr("type", "password");
            $(this).removeClass("password-visible")
        }
    })
})