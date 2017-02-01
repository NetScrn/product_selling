class ReportCreator
  SALES_PER_PRODUCT_QUERY = <<-SQL
    SELECT
      p.name,
      SUM(s.cost)
    FROM products p
    JOIN sales s ON p.id = s.product_id
    GROUP BY p.name
    ORDER BY SUM(s.cost) DESC
  SQL

  BETWEEN_DATE_QUERY = <<-SQL
    SELECT
      p.name,
      SUM(s.cost)
    FROM products p
    JOIN sales s ON p.id = s.product_id
    WHERE s.date_of_purchase BETWEEN %s AND %s
    GROUP BY p.name
    ORDER BY SUM(s.cost) DESC
  SQL

  PRODUCT_NAME_QUERY = <<-SQL
    SELECT
      p.name,
      SUM(s.cost)
    FROM products p
    JOIN sales s ON p.id = s.product_id
    WHERE p.name LIKE %s
    GROUP BY p.name
    ORDER BY SUM(s.cost) DESC
  SQL

  PRODUCT_NAME_AND_BETWEEN_QUERY = <<-SQL
    SELECT
      p.name,
      SUM(s.cost)
    FROM products p
    JOIN sales s ON p.id = s.product_id
    WHERE (s.date_of_purchase BETWEEN %s AND %s) AND (p.name LIKE %s)
    GROUP BY p.name
    ORDER BY SUM(s.cost) DESC
  SQL

  def self.sales_per_product(params)
    if !params[:product_name].blank? && !params[:between1].blank?
      between1, between2 = parse_time(params[:between1], params[:between2])
      product_name = quote("%#{params[:product_name]}%")
      result = conn.execute(PRODUCT_NAME_AND_BETWEEN_QUERY % [between1, between2, product_name])
      return result.values
    elsif !params[:product_name].blank?
      product_name = quote("%#{params[:product_name]}%")
      result = conn.execute(PRODUCT_NAME_QUERY % product_name)
      return result.values
    elsif !params[:between1].blank?
      between1, between2 = parse_time(params[:between1], params[:between2])
      result = conn.execute(BETWEEN_DATE_QUERY % [between1, between2])
      return result.values
    else
      conn.execute(SALES_PER_PRODUCT_QUERY).values
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