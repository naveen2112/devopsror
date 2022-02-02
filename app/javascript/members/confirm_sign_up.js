$(document).on('turbolinks:load', function() {

    $("#confirm-sign-up").validate({
        rules: {
            "user[password]": {
                required: true,
                minlength: 6,
                maxlength: 60
            },
            "user[password_confirmation]": {
                equalTo: "#user_password",
                minlength: 6,
                maxlength: 60
            }
        },
        messages: {
            "user[password]": {
                maxlength: "Please enter not more than 60 characters."
            },
            "user[password_confirmation]": {
                equalTo: "Password does not match"
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

})