class UsersController < ApplicationController
  layout 'mypage'
  def show
    @user = User.where(user_id: current_user)
  end

end
