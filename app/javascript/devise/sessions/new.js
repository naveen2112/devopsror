$(document).on('turbolinks:load', function() {
    $("#sign-in").validate({
        rules: {
            "user[email]": {
                required: true
            },
            "user[password]": {
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