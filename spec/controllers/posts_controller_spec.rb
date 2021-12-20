require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:company) { FactoryBot.create(:company) }
  let(:user) { FactoryBot.create(:user, company: company, cards_attributes: { "0": FactoryBot.attributes_for(:card) })}

  describe "Get #index" do

    it "should success response" do
      sign_in user
      get :index
      expect(response).to have_http_status 200
      expect(response).to render_template('index')
    end

    it "redirect response" do
      get :index
      expect(response).to have_http_status 302
      expect(response).to redirect_to('/users/sign_in')
    end
  end
end