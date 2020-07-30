class TradingsController < ApplicationController
  before_action :authenticate_user!
  layout 'simple'
  require "payjp"
  def new
    @item = Item.find(params[:item_id])
    @deliver_address = current_user.deliver_address
    @user_card = current_user.user_card
    @card = UserCard.find_by(user_id: current_user.id)
    if @user_card.present?
      Payjp.api_key = Rails.application.secrets.payjp_access_key
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @customer_card = customer.cards.retrieve(@card.card_id)
      @card_brand = @customer_card.brand
      case @card_brand
      when "Visa"
        @card_src = "visa.png"
      when "JCB"
        @card_src = "jcb.png"
      when "MasterCard"
        @card_src = "master.png"
      when "American Express"
        @card_src = "amex.png"
      when "Diners Club"
        @card_src = "diners.png"
      when "Discover"
        @card_src = "discover.png"
      end
      @exp_month = @customer_card.exp_month.to_s
      @exp_year = @customer_card.exp_year.to_s.slice(2,3)
    end
  end

  def create
    trading = Trading.new(trading_params)
    pay
    trading.save
    item = Item.find(params[:item_id])
    item.update(trading_id: trading.id)
  end

  def pay
    @item = Item.find(params[:item_id])
    @images = @item.images.all
    @item.with_lock do
      if current_user.user_card.present?
        @card = UserCard.find_by(user_id: current_user.id)
        Payjp.api_key = Rails.application.secrets.payjp_access_key
        charge = Payjp::Charge.create(
        amount: @item.price,
        customer: Payjp::Customer.retrieve(@card.customer_id),
        currency: 'jpy'
        )
      else
        Payjp::Charge.create(
        amount: @item.price,
        card: params['payjp-token'], 
        currency: 'jpy'
        )
      end
    end
  end
end

private
def trading_params
  params.require(:trading).permit(:user_id, :trading_family_name, :trading_first_name, :trading_family_name_kana, :trading_first_name_kana, :trading_yubin_bango, :trading_todofuken, :trading_shichoson, :trading_banchi, :trading_building, :trading_tel_no, :trading_card_id, :trading_customer_id)
end
