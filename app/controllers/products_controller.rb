class ProductsController < ApplicationController
  def index
    @products = Product.page params[:page]
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Product has been successfully created"
      redirect_to products_path
    else
      flash.now[:danger] = "Product has not been created"
      render 'new'
    end
  end

  private
  def product_params
    params.require(:product).permit(:name)
  end
end
