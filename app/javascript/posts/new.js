$(document).on('turbolinks:load', function() {
    $("#new-post").validate({
        rules: {
            "post[title]": {
                required: true
            },
            "post[main_url]": {
                maxlength: 240,
                url: true
            },
            "post[commentries_attributes[0]][description]": {
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

})
