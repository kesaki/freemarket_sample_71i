# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  after_action :delete_flash
  layout 'simple'
  def after_sign_in_path_for(resource)
    user_path(current_user)
  end 

  def edit
    render layout: 'mypage'
  end

  def delete_flash
    flash.delete(:notice) if flash[:notice].present?
  end
end
