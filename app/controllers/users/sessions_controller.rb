class Users::SessionsController < Devise::SessionsController
  
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    resource.increment!(:login_count)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end
end