class PerMonthReportCreator
  SALES_PER_MONTH_QUERY = <<-SQL
    SELECT
      EXTRACT(month from date_of_purchase) as m,
      EXTRACT(year from date_of_purchase) as y,
      SUM(cost) sales
    FROM sales
    GROUP BY m, y
    ORDER BY m DESC, y DESC;
  SQL

  BETWEEN_DATE_QUERY = <<-SQL
    SELECT
      EXTRACT(month from date_of_purchase) as m,
      EXTRACT(year from date_of_purchase) as y,
      SUM(cost) sales
    FROM sales
    WHERE date_of_purchase BETWEEN %s AND %s
    GROUP BY m, y
    ORDER BY m DESC, y DESC;
  SQL

  PRODUCT_ID_QUERY = <<-SQL
    SELECT
      EXTRACT(month from date_of_purchase) as m,
      EXTRACT(year from date_of_purchase) as y,
      SUM(cost) sales
    FROM sales
    WHERE product_id = %s
    GROUP BY m, y
    ORDER BY m DESC, y DESC;
  SQL

  PRODUCT_ID_AND_BETWEEN_QUERY = <<-SQL
    SELECT
      EXTRACT(month from date_of_purchase) as m,
      EXTRACT(year from date_of_purchase) as y,
      SUM(cost) sales
    FROM sales
    WHERE (product_id = %s) AND (date_of_purchase BETWEEN %s AND %s)
    GROUP BY m, y
    ORDER BY m DESC, y DESC;
  SQL


  def self.create_report(params)
    if !params[:product_name].blank? && !params[:between1].blank?
      between1, between2 = parse_time(params[:between1], params[:between2])
      product_name = quote("#{params[:product_name]}")
      result = conn.execute(PRODUCT_ID_AND_BETWEEN_QUERY % [product_name, between1, between2])
      return result.values
    elsif !params[:product_name].blank?
      product_name = quote("#{params[:product_name]}")
      result = conn.execute(PRODUCT_ID_QUERY % product_name)
      return result.values
    elsif !params[:between1].blank?
      between1, between2 = parse_time(params[:between1], params[:between2])
      result = conn.execute(BETWEEN_DATE_QUERY % [between1, between2])
      return result.values
    else
      conn.execute(SALES_PER_MONTH_QUERY).values
    end
  end

  private
  def self.conn
    ActiveRecord::Base.connection
  end

  def self.quote(q)
    ActiveRecord::Base.connection.quote(q)
  end

  def self.parse_time(*time)
    time[1] = time[0] if time[1].blank?
    time.map do |time|
      quote(Time.parse(time).strftime("%Y-%m-%d"))
    end
  end
end