require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  let(:company) { FactoryBot.create(:company) }
  let(:user) { FactoryBot.create(:user, company: company, cards_attributes: { "0": FactoryBot.attributes_for(:card) }) }

  describe "Get #index" do

    it "should success response" do
      sign_in user
      get :index
      expect(response).to have_http_status 200
      expect(response).to render_template('index')
    end
  end

  describe "Get #batch_event" do
    before do
      sign_in user
      get :batch_event
    end

    it 'returns a redirected response' do
      expect(response.status).to eq(302)
    end
  end

  describe "Get #resend_invite" do
    before do
      sign_in user
      get :resend_invite, xhr: true, params: { id: user.id }
    end

    it 'returns a redirected response' do
      expect(response.status).to eq(302)
    end
  end

  describe "Post #create" do
    context 'positive cases' do
      render_views
      before do
        sign_in user
        post :create, xhr: true, params: { user: { first_name: "test", last_name: "test", email: "test@gmail.com",
                                                   role: "admin", password: "password" } }
      end

      it "should render template" do
        expect(response).to render_template('users/create')
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'returns a change the post count' do
        expect {
          post :create, xhr: true, params: { user: { first_name: "test", last_name: "test", email: "test@gmail.com",
                                                     role: "admin", password: "password" } }
        }.to change(User, :count).by(1)
      end
    end

    context 'negative cases' do
      render_views
      before do
        sign_in user
        post :create, xhr: true, params: { user: { email: "" } }
      end

      it 'returns a error message' do
        expect(assigns(:user).errors.messages).to eq(:email => ["can't be blank"])
      end
    end
  end

  describe 'DELETE #destroy' do

    it 'destroys the requested post' do
      sign_in user
      expect {
        delete :destroy, params: {id: user.id}, xhr: true
      }.to change { User.count }.by(-1)
    end

    it 'returns a redirected status' do
      sign_in user
      delete :destroy, xhr: true, params: {id: user.to_param}
      expect(response.status).to eq(200)
    end

    it 'returns a redirect path' do
      sign_in user
      delete :destroy, xhr: true, params: {id: user.to_param}
      expect(response).to redirect_to(member_path(user))
    end
  end
end