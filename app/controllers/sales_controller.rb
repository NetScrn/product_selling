class SalesController < ApplicationController
  def index
    @sales = Sale.includes(:product).page params[:page]
  end

  def new
    @products = Product.all
    @sale = Sale.new
  end

  def create
    @sale = Sale.new(sale_params)
    if @sale.save
      flash[:success] = 'Sale has been created'
      redirect_to sales_path
    else
      flash.now[:danger] = 'Sale has not been created'
      @products = Product.all
      render 'new'
    end
  end

  private
  def sale_params
    params.require(:sale).permit(:product_id, :cost, :date_of_purchase)
  end
end