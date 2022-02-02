class LinkedinController < ApplicationController
  include LinkedinAuthentication

  def callback
    if params[:code]
      response = JSON.parse(get_access_token(params[:code]))

      if response["refresh_token"].present?
        if current_user.integrated_accounts.with_platform("linked_in").first.nil?
          current_user.integrated_accounts.create(platform: "linked_in", data: { access_token: Encryptor.encrypt(response["access_token"]), referesh_token: Encryptor.encrypt(response["refresh_token"]) })

          profile_response = get_profile_information(response["access_token"])
          profile_response = JSON.parse(profile_response)
          current_user.update(linked_in_id: Encryptor.encrypt(profile_response["id"])) if profile_response["id"].present?
        end
      end

      redirect_to post_path(session[:post_id])
    else
      redirect_to post_path(session[:post_id])
    end
    session[:post_id] = nil
  end
end