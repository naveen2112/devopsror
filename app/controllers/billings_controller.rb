class BillingsController < ApplicationController
  skip_before_action :authenticate_user!
  rescue_from Stripe::CardError do |e|
    redirect_to billings_path, alert: e.message
  end

  def index
    @new_card = current_user.cards.new
  end

  def company_tags
    company = Company.find(params[:id])
    render json: company.tags
  end

  def create
    Card.transaction do
      if current_user.stripe_customer_id.present?
        Stripe::Customer.update(current_user.stripe_customer_id, card: cards_params[:token])
      else
        response = Stripe::Customer.create(email: current_user.email, card: cards_params[:token])
        current_user.update(stripe_customer_id: response.id)
      end
      card = current_user.cards.new(cards_params)
      if verify_recaptcha && card.save
        redirect_to billings_path, notice: "Card updated successfully."
      else
        redirect_to billings_path, alert: "Recaptcha verification failed"
      end
    end
  end

  def cancel_subscription
    current_company.update(company_params)
    if company_params[:subscription_status] == "active"
      flash[:notice] = "Subscription renewed successfully."
    else
      flash[:notice] = "Subscription cancelled successfully."
    end
    redirect_to billings_path
  end

  private

  def company_params
    params.require(:company).permit(:subscription_status, :subscription_cancelled_at)
  end

  def cards_params
    params.require(:card).permit(:last_four_digits, :expiry, :stripe_card_id, :token)
  end
end
