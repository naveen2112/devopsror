$(document).on('turbolinks:load', function() {
    $("#users-update-password").validate({
        rules: {
            "user[password]": {
                required: true
            },
            "user[password_confirmation]": {
                equalTo: "#user_password"
            }
        },
        messages:{
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