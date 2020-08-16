class Users::RegistrationsController < Devise::RegistrationsController
  after_action :delete_flash
  layout 'simple'
  
  def index
  end
  
  def new
    super
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to user_path(current_user)
    else
      render action: :new
    end
    
  end

  def delete_flash
    flash.delete(:notice) if flash[:notice].present?
  end

private
  def user_params
    user_params = params.require(:user).permit(:nickname, :email, :password, :family_name, :first_name, :family_name_kana, :first_name_kana)
    birthday_params = params.require(:birthday).permit("birthday(1i)", "birthday(2i)", "birthday(3i)")
    user_params = user_params.merge(birthday_params)
  end

end
