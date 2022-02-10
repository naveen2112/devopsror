$(document).on('turbolinks:load', function() {

    $("#profile-edit").validate({
        rules: {
            "user[first_name]": {
                required: true
            },
            "user[email]": {
                required: true,
                remote: "/users/validate_email_without_current_user"
            },
            "user[company_attributes][name]": {
                required: true,
                remote: "/users/validate_organisation_without_current_company"
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


    $("#profile-password-update").validate({
        rules: {
            "user[current_password]": {
                required: true,
                minlength: 6,
                maxlength: 60,
                remote: "/users/validate_current_password"
            },
            "user[password]": {
                required: true,
                minlength: 6,
                maxlength: 60,
                remote: "/users/validate_new_password"
            },
            "user[password_confirmation]": {
                equalTo: "#user_password",
                minlength: 6,
                maxlength: 60
            }
        },
        messages: {
            "user[current_password]": {
                remote: "Incorrect Current Password."
            },
            "user[password]": {
                maxlength: "Please enter not more than 60 characters.",
                remote: "Please enter a new password"
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
