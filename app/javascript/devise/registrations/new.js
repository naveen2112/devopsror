$(document).on('click', '.user-password-confirmation-button', function () {

    var input = $("#user_password_confirmation");

    if (input.attr("type") === "password") {
        $(this).addClass("password-visible")
        input.attr("type", "text");
    } else {
        input.attr("type", "password");
        $(this).removeClass("password-visible")
    }
})

$(document).on('click', '.user-password-button', function () {

    var input = $("#user_password");

    if (input.attr("type") === "password") {
        input.attr("type", "text");
        $(this).addClass("password-visible")
    } else {
        input.attr("type", "password");
        $(this).removeClass("password-visible")
    }
})

$(document).on('turbolinks:load', function () {

    let sign_up_form = $("#sign-up");

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
            "user[company_attributes][url]": {
                required: true
            },
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
        messages: {
            "user[email]": {
                remote: jQuery.validator.format("{0} is already in use.")
            },
            "user[company_attributes][name]": {
                remote: jQuery.validator.format("{0} is already in use.")
            },
            "user[password]": {
                maxlength: "Please enter not more than 60 characters."
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


    $("#page-1").show()
    $("#right-page-1").show()
    $("#page-2").hide()
    $("#right-page-2").hide()


    if ($("#sign-up").length > 0) {


        //if ($('#sign-up').length > 1) {
        // This is your test publishable API key.
        const stripe = Stripe(process.env.STRIPE_PUBLIC_KEY);
        var elements = stripe.elements();

        var cardNumber = elements.create('cardNumber');
        var cardExpiry = elements.create('cardExpiry');
        var cardCvc = elements.create('cardCvc');
        // }


        $("#sign-up-page-one").click(function () {
            if (sign_up_form.valid() == true) {

                cardNumber.mount('#card-number');
                cardExpiry.mount('#card-expiry');
                cardCvc.mount('#card-cvc');

                $("#page-1").hide()
                $("#right-page-1").hide()
                $("#page-2").show()
                $("#right-page-2").show()

            }
        })

        $("#sign-up").on("keypress", function (event) {
            if (event.which == 13 && event.shiftKey) {
                event.stopPropagation();
            }
            else if (event.which == 13) {
                if($("#user_first_name").is(":visible")){
                    cardNumber.mount('#card-number');
                    cardExpiry.mount('#card-expiry');
                    cardCvc.mount('#card-cvc');

                    $("#page-1").hide()
                    $("#right-page-1").hide()
                    $("#page-2").show()
                    $("#right-page-2").show()
                }
                else{
                    var $form = $('#sign-up');
                    $form.submit()
                }
            }
        })

        $("#sign-up-page-two").click(function () {
            $("#page-1").show()
            $("#right-page-1").show()
            $("#page-2").hide()
            $("#right-page-2").hide()
        })

        $("#sign-up").submit(function (event) {
            event.preventDefault()

            var $form = $('#sign-up');

            stripe.createToken(cardNumber, cardCvc, cardExpiry).then(function (result) {
                if (result.error) {
                    // Inform the user if there was an error.
                    var errorElement = document.getElementById('card-errors');
                    errorElement.textContent = result.error.message;
                } else {
                    // Send the token to your server.

                    $("#user_cards_attributes_0__last_four_digits").val(result.token.card.last4)
                    $("#user_cards_attributes_0__expiry").val(result.token.card.exp_month.toString() + "/" + result.token.card.exp_year.toString())
                    $("#user_cards_attributes_0__token").val(result.token.id)
                    $("#user_cards_attributes_0__stripe_card_id").val(result.token.card.id)

                    if ($("#user_terms_and_conditions").is(":checked")) {
                        cardNumber.unmount('#card-number');
                        cardExpiry.unmount('#card-expiry');
                        cardCvc.unmount('#card-cvc');
                        $form.get(0).submit();
                    } else {
                        alert("Please agree to terms and conditions")
                        $(this).find(":submit").removeAttr('disabled');
                    }
                }
            });
        })
    }

    $("#user_terms_and_conditions").change(function () {
        if ($(this).is(":checked")) {
            $("#sign-up").find(":submit").removeAttr('disabled');
        }
    })
})