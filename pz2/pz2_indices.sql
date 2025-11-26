-- Індекс 1: Оптимізація для Запиту 1
CREATE NONCLUSTERED INDEX IX_Goods_Quantity_Include
ON Goods(Quantity)
INCLUDE (Id, Label);

-- Індекс 2: Оптимізація для Запиту 2
CREATE NONCLUSTERED INDEX IX_Goods_InputDate_Price_Include
ON Goods(InputDate, Price)
INCLUDE (Id, Label);

-- Індекс 3: Оптимізація для Запиту 3
CREATE NONCLUSTERED INDEX IX_Goods_InputDate_Quantity
ON Goods(InputDate)
INCLUDE (Quantity);

-- Кластеризований індекс
CREATE CLUSTERED INDEX IX_Goods_Id_Clustered
ON Goods(Id);

ALTER INDEX IX_Goods_Quantity_Include ON Goods DISABLE;
ALTER INDEX IX_Goods_InputDate_Price_Include ON Goods DISABLE;
ALTER INDEX IX_Goods_InputDate_Quantity ON Goods DISABLE;
ALTER INDEX IX_Goods_Id_Clustered ON Goods DISABLE;

SET STATISTICS IO ON;
