-- Індекс 1: Оптимізація для Запиту 1 (Quantity < 100)
CREATE NONCLUSTERED INDEX IX_Goods_Quantity_Include
ON Goods(Quantity)
INCLUDE (Id, Label);
-- Покриваючий індекс для швидкого відбору за Quantity

-- Індекс 2: Оптимізація для Запиту 2 (Price AND InputDate)
CREATE NONCLUSTERED INDEX IX_Goods_InputDate_Price_Include
ON Goods(InputDate, Price)
INCLUDE (Id, Label);
-- InputDate на першому місці, бо використовується рівність (=)

-- Індекс 3: Оптимізація для Запиту 3 (GROUP BY InputDate)
CREATE NONCLUSTERED INDEX IX_Goods_InputDate_Quantity
ON Goods(InputDate)
INCLUDE (Quantity);
-- Покриваючий індекс для агрегації по InputDate

-- Кластеризований індекс (рекомендується на первинний ключ)
CREATE CLUSTERED INDEX IX_Goods_Id_Clustered
ON Goods(Id);

ALTER INDEX IX_Goods_Quantity_Include ON Goods DISABLE;
ALTER INDEX IX_Goods_InputDate_Price_Include ON Goods DISABLE;
ALTER INDEX IX_Goods_InputDate_Quantity ON Goods DISABLE;
ALTER INDEX IX_Goods_Id_Clustered ON Goods DISABLE;

SET STATISTICS IO ON;
