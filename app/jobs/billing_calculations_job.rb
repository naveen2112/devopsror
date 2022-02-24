class BillingCalculationsJob < ApplicationJob
  queue_as :default

  def perform
    Company.product_led_plan.subscription_started.subscribed.each do |company|
      if company.next_billing_date&.to_date == Date.current
        response = Stripe::Charge.create({
                                amount: (company.billed_amount.to_s + "00").to_i,
                                currency: 'usd',
                                customer: company.users.owner_admin.stripe_customer_id
                              })

        company.update(next_billing_date: (Date.current + 30.days))  if response.status == "succeeded"
      end
    end
  end
end
