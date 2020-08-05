class ItemsController < ApplicationController
  require "payjp"

  def new
    @item = Item.new
    @item.images.new
    @parents = Category.where(ancestry: nil).limit(13).pluck(:category_name, :id)
    respond_to do |format|
      format.html {render layout: 'simple'}
      format.json { render json: get_category_children}
    end
  end

  def create
    item = Item.new(item_params)
    if item.save
      redirect_to item_path(item)
    else
      render :new
    end

  end

  def edit
    @item = Item.find(params[:id])
    @grand_child = Category.find(@item.category_id)
    @child = @grand_child.parent
    @parent = @child.parent
    @grand_children = @grand_child.siblings.limit(13).pluck(:category_name, :id)
    @children = @child.siblings.limit(13).pluck(:category_name, :id)
    @parents = @parent.siblings.limit(13).pluck(:category_name, :id)
    respond_to do |format|
      format.html {render layout: 'simple'}
      format.json { render json: get_category_children}
    end
  end
  
  def update
    item = Item.find(params[:id])
    if item.update (item_params)
      redirect_to item_path(item)
    else
      render :edit
    end
  end

  def show
    @item = Item.find(params[:id])
    @images = Image.where(item_id: @item)
  end

  def destroy
    item = Item.find(params[:id])
    images = Image.where(item_id: item)
    images.delete_all
    item.destroy
    redirect_to user_path(current_user)
  end

  def get_category_children
    @category_children = Category.find(params[:category_id]).children
  end

private
  def item_params
    params.require(:item).permit(:item_name, :item_info, :brand_id, :condition, :postage_burden, :shipping_area, :days_to_ship, :price, images_attributes: [:item_image, :_destroy, :id]).merge(user_id: current_user.id).merge(category_id: params[:category_id])
  end

end

