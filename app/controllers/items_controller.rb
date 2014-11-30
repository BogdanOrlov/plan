class ItemsController < ApplicationController
  autocomplete :item, :name
  def index
    @items = scope.search(params[:search])
  end

  def new
    @item = account.items.build
    render 'edit'
  end

  def create
    @item = account.items.build(item_params)
    if @item.save
      redirect_to [:items], notice: 'Номенклатура добавлена'
    else
      logger.info "=="
      logger.info @item.errors.full_messages
      logger.info "=="
      render 'edit'
    end
  end

  def edit
    @item = scope.find(params[:id])
  end

  def update
    @item = scope.find(params[:id])
    if @item.update(item_params)
      redirect_to [:items], notice: 'Номенклатура обновлена'
    else
      render 'edit'
    end
  end

  def show
    @item = scope.find(params[:id])
  end

  def destroy
    @item = scope.find(params[:id])
  end

  private

  def scope
    return Item.for_account(account.id).complex(account.id) if params[:tab] == 'complex'
    return Item.for_account(account.id).basic(account.id) if params[:tab] == 'basic'
    Item.for_account(account.id)
  end

  def item_params
    res = params[:item]
    res[:itemizations_attributes].each { |k, v| v.merge!(account_id: account.id) } if res[:itemizations_attributes]
    res.permit!
  end
end
