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