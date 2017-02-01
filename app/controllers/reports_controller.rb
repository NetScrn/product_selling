class ReportsController < ApplicationController
  def sales_per_product
    @result = ReportCreator.sales_per_product(report_params)
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def report_params
    params.permit(:product_name, :between1, :between2)
  end
end