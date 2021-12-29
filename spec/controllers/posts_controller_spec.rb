require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:company) { FactoryBot.create(:company) }
  let(:user) { FactoryBot.create(:user, company: company, cards_attributes: { "0": FactoryBot.attributes_for(:card) }) }

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

  describe "Get #new" do
    render_views
    before do
      sign_in user
      get :new
    end

    it "should render template" do
      expect(response).to render_template('new')
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    it 'render post partial' do
      expect(response).to render_template('posts/partials/_form')
    end
  end

  describe "Post #create" do
    context 'positive cases' do
      render_views
      before do
        sign_in user
        post :create, xhr: true, params: { post: { title: "test", platform_name: ["linked in"], main_url: "http://test.com", notification: true,
                                                   commentries_attributes: { "0": FactoryBot.attributes_for(:commentry) },
                                                   tags_attributes: { "0": FactoryBot.attributes_for(:tag) } } }
      end

      it "should render template" do
        expect(response).to render_template('posts/create')
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'returns a change the post count' do
        expect {
          post :create, xhr: true, params: { post: { title: "test", platform_name: ["linked in"], main_url: "http://test.com", notification: true,
                                                     commentries_attributes: { "0": FactoryBot.attributes_for(:commentry) },
                                                     tags_attributes: { "0": FactoryBot.attributes_for(:tag) } } }
        }.to change(Post, :count).by(1)
      end
    end

    context 'negative cases' do
      render_views
      before do
        sign_in user
        post :create, xhr: true, params: { post: { title: '' } }
      end

      it 'returns a error message' do
        expect(assigns(:post).errors.messages).to eq(:title => ["can't be blank"])
      end
    end
  end
end