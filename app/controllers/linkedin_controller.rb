class LinkedinController < ApplicationController
  include LinkedinAuthentication
  include EncryptCredentails

  def integrate
    if current_user.linked_in_code.nil?
      redirect_to linked_in_authorizaion_url
    else
      redirect_to share_linkedin_index_path
    end
  end

  def share
    post = Post.find(session["post_id"])
    share_post(post.id, current_user.id)
    post.update(shared_count: (post.shared_count + 1))
    redirect_to posts_path
  end

  def callback
    if params[:code]
      response = JSON.parse(get_access_token(params[:code]))

      if response["refresh_token"].present?
        if current_user.integrated_accounts.with_platform("linked_in").first.nil?
          integrated_account = current_user.integrated_accounts.new(platform: "linked_in", data: { access_token: encrypt(response["access_token"]), referesh_token: encrypt(response["refresh_token"]) })
          integrated_account.save

          profile_response = get_profile_information(response["access_token"])
          profile_response = JSON.parse(profile_response)
          current_user.update(linked_in_id: encrypt(profile_response["id"])) if profile_response["id"].present?
        end
      end
      redirect_to share_linkedin_index_path
    else
      redirect_to share_linkedin_index_path
    end
  end
end