class InstantBillingJob < ApplicationJob
  queue_as :default

  def perform(company, users_count: 1)
    billable_days = (company.next_billing_date.to_date - Date.today).to_i
    amount = company.billing_type == 'monthly' ? Company::PRICE_PER_USER_PER_MONTH: Company::PRICE_PER_USER_PER_YEAR

    billed_amount = (( amount/ 30.0) * billable_days * users_count).round(2)
    if billed_amount.present?
      response = Stripe::Charge.create({
                              amount: (billed_amount * 100).to_i,
                              currency: 'usd',
                              customer: company.users.owner_admin&.first&.stripe_customer_id
                            })
      company.update_columns(charged_amount: company.charged_amount + billed_amount) if response.status == "succeeded"
    end
  end
end
