$(document).on('click', '.users-password', function () {

    var input = $("#user_password");

    if (input.attr("type") === "password") {
        $(this).addClass("password-visible")
        input.attr("type", "text");
    } else {
        input.attr("type", "password");
        $(this).removeClass("password-visible")
    }
})

$(document).on('click', '.users-password-confirmation', function () {

    var input = $("#user_password_confirmation");

    if (input.attr("type") === "password") {
        input.attr("type", "text");
        $(this).addClass("password-visible")
    } else {
        input.attr("type", "password");
        $(this).removeClass("password-visible")
    }
})

$(document).on('turbolinks:load', function() {

    $("#users-update-password").validate({
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
        messages:{
            "user[password]": {
                maxlength: "Please enter not more than 60 characters."
            },
            "user[password_confirmation]": {
                equalTo: "Password does not match"
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
})