class ReportsController < ApplicationController
  def sales_per_product
    @result = PerProductReportCreator.create_report(report_params)
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def sales_per_month
    @products = Product.all
    @result = PerMonthReportCreator.create_report(report_params)
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  private
  def report_params
    params.permit(:product_name, :between1, :between2)
  end
end