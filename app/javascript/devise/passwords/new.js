$(document).on('turbolinks:load', function() {
    $("#users-forgot-password").validate({
        rules: {
            "user[email]": {
                required: true
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