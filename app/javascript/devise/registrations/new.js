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
            "user[password]": {
                required: true
            },
            "user[password_confirmation]": {
                equalTo: "#user_password"
            }
        },
        messages: {
            "user[email]": {
                remote: jQuery.validator.format("{0} is already in use.")
            },
            "user[company_attributes][name]": {
                remote: jQuery.validator.format("{0} is already in use.")
            },
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

    $("#page-1").show()
    $("#page-2").hide()

    // This is your test publishable API key.
    const stripe = Stripe("pk_test_51K4by0Gm7mBiaCNXEtSq8ENz711i5Ux26UqS0GICz3KWdGx85isgpkMPMx3gNb3EIKs9TxVu02wqny3I3sbqgP7x00n9MEtZLB");

    var elements = stripe.elements();

    var style = {
        base: {
            'background-color': "#FBFBFB",
            'border': 'none',
            'font-size': '14px',
            'line-height': '1.2',
            'font-weight': '500',
            'padding': '23px 12px',
            'color': "#6F6C99"
        }
    };

    var cardNumber = elements.create('cardNumber', { styles: style } );
    console.log(cardNumber)

    var cardExpiry = elements.create('cardExpiry', { style: style });
    var cardCvc = elements.create('cardCvc', { style: style });

    $("#sign-up-page-one").click(function () {
        if(sign_up_form.valid() == true)
        {

            cardNumber.mount('#card-number');

            console.log(cardNumber)

            cardExpiry.mount('#card-expiry');

            cardCvc.mount('#card-cvc');

            $("#page-1").hide()
            $("#page-2").show()

        }
    })

    $("#sign-up-page-two").click(function () {
        $("#page-1").show()
        $("#page-2").hide()
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
                console.log(result)
                cardNumber.unmount('#card-number');
                cardExpiry.unmount('#card-expiry');
                cardCvc.unmount('#card-cvc');

                $("#user_cards_attributes_0__number").val(result.token.card.last4)
                $("#user_cards_attributes_0__cvv").val($("input[name=cvc]").val())
                $("#user_cards_attributes_0__expiry").val(result.token.card.exp_month.toString() + "/" + result.token.card.exp_year.toString())
                $("#user_cards_attributes_0__token").val(result.token.id)
                $("#user_cards_attributes_0__card_id").val(result.token.card.id)

                $form.get(0).submit();
            }
        });
    })

})