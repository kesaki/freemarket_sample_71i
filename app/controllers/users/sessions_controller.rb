# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  layout 'simple'
  def after_sign_in_path_for(resource)
    user_path(current_user)
  end 

  def edit
    render layout: 'application'
  end

end
