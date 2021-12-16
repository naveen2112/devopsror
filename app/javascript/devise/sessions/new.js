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

    $(document).on('click','.toggleButton',function(){

        var input = $("#exampleInputPassword");

        if (input.attr("type") === "password") {
            input.attr("type", "text");
            $(this).addClass("password-visible")
        } else {
            input.attr("type", "password");
            $(this).removeClass("password-visible")
        }
    })
})