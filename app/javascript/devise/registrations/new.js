$(document).on('turbolinks:load', function () {
    $("#sign-up").validate({
        rules: {
            "user[first_name]": {
                required: true
            },
            "user[email]": {
                required: true,
                remote: "/users/validate_email"
            },
            "user[company_attributes][name]": {
                required: true,
                remote: "/users/validate_organisation"
            },
            "user[password]": {
                required: true
            },
            "user[password_confirmation]": {
                equalTo: "#user_password"
            }
        },
        messages: {
            "user[email]": {
                remote: jQuery.validator.format("{0} is already in use.")
            },
            "user[company_attributes][name]": {
                remote: jQuery.validator.format("{0} is already in use.")
            },
            "user[password_confirmation]": {
                equalTo: "Password does not match"
            }
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