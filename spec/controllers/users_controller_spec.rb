require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:company) { FactoryBot.create(:company) }
  let(:user) { FactoryBot.create(:user, company: company, cards_attributes: { "0": FactoryBot.attributes_for(:card) }) }

  describe "Get #profile" do
    before do
      sign_in user
      get :profile
    end

    it "should render template" do
      expect(response).to render_template('profile')
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
  end

  describe "Get #update" do
    before do
      sign_in user
      put :update, params: { user: { first_name: 'test name' }, id: user.id }
    end

    it 'returns a success response' do
      expect(response.status).to eq(302)
    end

    it 'should redirect' do
      expect(response).to redirect_to(profile_users_path)
    end
  end
end