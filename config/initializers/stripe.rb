Rails.configuration.stripe = {
    :publishable_key => "pk_test_51K4by0Gm7mBiaCNXEtSq8ENz711i5Ux26UqS0GICz3KWdGx85isgpkMPMx3gNb3EIKs9TxVu02wqny3I3sbqgP7x00n9MEtZLB",
    :secret_key => "sk_test_51K4by0Gm7mBiaCNXSd1DIZMe8tPncA7HjCDhCaSlm6EMLiIhINuF2yDOUC2HEVn5fufGMv1x57xoPHBb1g9b5hX700Ra9cPY4g"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]