class DeliverAddressesController < ApplicationController
  layout 'mypage'
  def new
    @@path = Rails.application.routes.recognize_path(request.referer)
    redirect_to edit_deliver_address_path(DeliverAddress.find_by(user_id: current_user)) if DeliverAddress.exists?(user_id: current_user) 
    @deliver_address = DeliverAddress.new
    render layout: 'simple' if @@path[:controller] == 'tradings'
  end
  
  def create
    deliver_address = DeliverAddress.new(deliver_address_params)
    if deliver_address.save
      if @@path[:controller] == 'tradings'
        redirect_to @@path
      else
        redirect_to edit_deliver_address_path(current_user.deliver_address), notice: "お届け先情報を登録しました"
      end
    else
      redirect_to new_deliver_address_path, alert: "入力情報を確認してください"
    end
  end

  def edit
    @@path = Rails.application.routes.recognize_path(request.referer)
    @deliver_address = DeliverAddress.find_by(user_id: current_user)
    render layout: 'simple' if @@path[:controller] == 'tradings'
  end

  def update
    deliver_address = DeliverAddress.find(params[:id])
    if  deliver_address.update(deliver_address_params)
      if @@path[:controller] == 'tradings'
        redirect_to @@path
      else
        redirect_to edit_deliver_address_path(current_user.deliver_address), notice: "お届け先情報を更新しました"
      end
    else
      redirect_to edit_deliver_address_path(current_user.deliver_address), alert: "入力情報を確認してください"
    end
  end

  private
  def deliver_address_params
    params.require(:deliver_address).permit(:deliver_family_name,:deliver_first_name,:deliver_family_name_kana,:deliver_first_name_kana,:deliver_yubin_bango,:deliver_todofuken,:deliver_shichoson,:deliver_banchi,:deliver_building,:deliver_tel_no).merge(user_id: current_user.id)
  end
end