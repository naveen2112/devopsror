require 'rails_helper'

RSpec.describe BillingsController, type: :controller do

  let(:company) { FactoryBot.create(:company) }
  let(:user) { FactoryBot.create(:user, company: company, cards_attributes: { "0": FactoryBot.attributes_for(:card) }) }

  describe "Get #index" do
    before do
      sign_in user
      get :index
    end

    it "should render template" do
      expect(response).to render_template('index')
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

  describe "Put #cancel_subscription" do
    before do
      sign_in user
      put :cancel_subscription, params: { company: { subscription_status: "active", subscription_cancelled_at: Date.current } }
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    it "redirect response" do
      expect(response).to have_http_status 302
    end
  end
end