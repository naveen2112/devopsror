class BillingCalculationsJob < ApplicationJob
  queue_as :default

  def perform
    Company.product_led_plan.subscription_started.subscribed.each do |company|
      if company.next_billing_date&.to_date == Date.current
        billed_amount = company.billed_amount
        response = Stripe::Charge.create({
                                           amount: (billed_amount.to_s + "00").to_i,
                                           currency: 'usd',
                                           customer: company.users.owner_admin&.first&.stripe_customer_id
                                         })

        if response.status == "succeeded"
          if company.billing_type == 'monthly'
            company.update_columns(next_billing_date: (Date.current + 30.days), charged_amount: billed_amount)
          else
            company.update_columns(next_billing_date: (Date.current + 365.days), charged_amount: billed_amount)
          end
        end
      end
    end
  end
end
