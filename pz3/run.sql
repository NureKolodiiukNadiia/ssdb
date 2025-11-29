-- EXEC pz.DiscountProducts @discountPercent = 10, @minTotalSales = 100.00;

SELECT id, product_name, quantity stock_qty, price current_price
FROM pz.product;

SELECT oi.product_id, SUM(oi.quantity * oi.price) total_sold, SUM(oi.quantity) total_qty_sold
FROM pz.order_items oi
GROUP BY oi.product_id;
