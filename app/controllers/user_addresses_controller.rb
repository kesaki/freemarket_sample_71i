class UserAddressesController < ApplicationController
  layout 'mypage'
  def new
    if UserAddress.exists?(user_id: current_user)
      redirect_to edit_user_address_path(current_user.user_address)
    else
      @user_address = UserAddress.new
    end
  end

  def create
    user_address = UserAddress.new(user_address_params)
    if user_address.save
      redirect_to edit_user_address_path(current_user.user_address), notice: "連絡先を登録しました"
    else
      redirect_to new_user_address_path, alert: '入力事項を確認してください'
    end
  end

  def edit
    @user_address = current_user.user_address
  end
  
  def update
    user_address = UserAddress.find(params[:id])
    if user_address.update(user_address_params)
      redirect_to edit_user_address_path(current_user.user_address),notice: "連絡先を更新しました"
    else
      redirect_to edit_user_address_path(current_user.user_address), alert: '入力事項を確認してください'
    end
  end

  private
  def user_address_params
    params.require(:user_address).permit(:user_yubin_bango,:user_todofuken,:user_shichoson,:user_banchi,:user_building).merge(user_id: current_user.id)
  end
end


