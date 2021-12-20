$(document).on('turbolinks:load', function () {

    $("#users-forgot-password").validate({
        rules: {
            "user[email]": {
                required: true,
                remote: "/users/validate_presence_of_email"
            }
        },
        messages: {
            "user[email]": {
                remote: jQuery.validator.format("{0} is not in use.")
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