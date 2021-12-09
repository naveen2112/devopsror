$(document).on('turbolinks:load', function() {
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
            }
        },
        messages: {
            "user[email]": {
                remote: jQuery.validator.format("{0} is already in use.")
            },
            "user[company_attributes][name]": {
                remote: jQuery.validator.format("{0} is already in use.")
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