$(document).on('turbolinks:load', function () {
    if ($("#new-card-form").length > 0) {

        const stripe = Stripe(process.env.STRIPE_PUBLIC_KEY);
        var elements = stripe.elements();

        var cardNumber = elements.create('cardNumber');
        var cardExpiry = elements.create('cardExpiry');
        var cardCvc = elements.create('cardCvc');


        cardNumber.mount('#card-number');
        cardExpiry.mount('#card-expiry');
        cardCvc.mount('#card-cvc');

        $("#new-card-form").submit(function (event) {
            event.preventDefault()

            var $form = $('#new-card-form');

            stripe.createToken(cardNumber, cardCvc, cardExpiry).then(function (result) {
                if (result.error) {
                    // Inform the user if there was an error.
                    var errorElement = document.getElementById('card-errors');
                    errorElement.textContent = result.error.message;
                } else {
                    // Send the token to your server.
                    cardNumber.unmount('#card-number');
                    cardExpiry.unmount('#card-expiry');
                    cardCvc.unmount('#card-cvc');

                    $("#card_last_four_digits").val(result.token.card.last4)
                    $("#card_expiry").val(result.token.card.exp_month.toString() + "/" + result.token.card.exp_year.toString())
                    $("#card_token").val(result.token.id)
                    $("#card_stripe_card_id").val(result.token.card.id)

                    $form.get(0).submit();
                }
            });
        })
    }
})