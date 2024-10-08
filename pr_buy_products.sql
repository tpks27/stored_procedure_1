CREATE OR ALTER PROCEDURE pr_buy_products
    @p_product_name NVARCHAR(100),  -- Input parameter for product name
    @p_quantity INT       -- Input parameter for quantity ordered
AS
BEGIN
      declare @v_product_code int ;
      declare  @v_price int ; 
      declare @v_orderId int ;
-- Fetch product code and price for the given product name
  select @v_product_code = product_code, @v_price = price
  from products
  where product_name = @p_product_name;

  --Check if the product code was found
  if @v_product_code is NULL
  Begin 
  print 'Error: Product not found';
  return;
  end

  --Generate a new orderID using the sequence
  set @v_orderId = NEXT VALUE For order_id_seq;

  -- Insert the sale record into iphonesales

  insert into iphonesales(orderId, order_date, product_code, quantity_ordered, sale_price)
  values(@v_orderId, Getdate(), @v_product_code, @p_quantity, @v_price*@p_quantity);

  --Alter Qunatity remained and quantity Sold 

  update products
  set quantity_remained = quantity_remained - @p_quantity,
      quantity_sold = quantity_sold + @p_quantity
  where product_name = @p_product_name;

END;


-------execution example----
-- exec pr_buy_products
   --  @p_product_name = 'iphone14', 
   -- @p_quantity = 2;

    
