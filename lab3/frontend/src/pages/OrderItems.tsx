import { AgGridReact } from "ag-grid-react";
import { useEffect, useState } from "react";
import "ag-grid-community/styles/ag-grid.css";
import "ag-grid-community/styles/ag-theme-alpine.css";
import { DeleteCellRenderer } from "../components/DeleteCellRenderer";
import { EditCellRenderer } from "../components/EditCellRenderer";
import { Button } from "@mui/material";
import agent from "../api/agent.ts";
import OrderItemForm from "../components/CreateForms/OrderItemForm.tsx";
import { convertPrice } from "../utils.ts";
import { OrderItem } from "../models/OrderItem.ts";

export default function OrderItems() {

    const [rowData, setRowData] = useState<OrderItem[]>([]);
    const [dialogOpen, setDialogOpen] = useState(false);
    const [selectedOrderItem, setSelectedOrderItem] = useState<OrderItem | null>(null);

    const columnDefs = [
        { field: 'id', headerName: 'Id' },
        { field: 'quantity', headerName: 'Quantity' },
        { field: 'pricePerUnit', headerName: 'Price' },
        { field: 'serviceName', headerName: 'Service' },
        { field: 'orderId', headerName: 'Order Id' },
        { field: '', cellRenderer: (params) => <EditCellRenderer {...params} onEdit={handleDialogOpen} /> },
        { 
            cellRenderer: (params) => <DeleteCellRenderer {...params} onDelete={handleDelete} />,
            width: 100 
        }        ];

    const autoSizeStrategy = {
        type: 'fitCellContents'
    };

    const handleDialogOpen = (orderItem = null) => {
        setSelectedOrderItem(orderItem);
        setDialogOpen(true);
    };

    const handleDialogClose = () => {
        setDialogOpen(false);
        setSelectedOrderItem(null);
    };

    const handleCreateOrderItem = (orderItemData : any) => {

        agent.OrderItems.create(orderItemData)
            .then((response) => {
                const newOrderItem = {
                    ...response,
                };
                setRowData(prevRowData => [...prevRowData, newOrderItem]);
                handleDialogClose();
            })
            .catch((error) => {
                console.error("Error creating order item:", error);
            });
    };

    const handleEditOrderItem = (updatedOrderItemData : any) => {
            
        const orderItemToUpdate = { 
            ...updatedOrderItemData,
        };
    
        agent.OrderItems.update(orderItemToUpdate)
            .then((response) => {
                
                const updatedOrderItem = {
                    ...response,
                };
        
                setRowData(prevRowData =>
                    prevRowData.map(orderItem =>
                        orderItem.id === updatedOrderItem.id ? updatedOrderItem : orderItem
                    )
                );
    
                handleDialogClose();
            })
            .catch((error) => {
                console.error("Error updating order item:", error);
            });
    };

    const handleDelete = (id: number) => {
        agent.OrderItems.delete(id)
            .then(() => {
                setRowData(prevRowData => 
                    prevRowData.filter(orderItem => orderItem.id !== id)
                );
            })
            .catch((error) => {
                console.error("Error deleting order item:", error);
            });
    };

    const themeName = "ag-theme-alpine-auto-dark";

    useEffect(() => {
        agent.OrderItems.getAll()
            .then((orderItems) => {
                const formattedData = orderItems.map((orderItem) => ({
                    ...orderItem,
                    price: convertPrice(orderItem.pricePerUnit),
                }));
                setRowData(formattedData);
            })
            .catch((error) => {
                console.error("Error fetching data:", error);
            });
    }, []);

    return (
        <div
            className={themeName}
            style={{ marginLeft: '1vw', height: '100%', width: '97vw' }}
        >
            <Button
                onClick={() => handleDialogOpen()}
                variant={"contained"}>Add</Button>
            <OrderItemForm
                open={dialogOpen}
                onClose={handleDialogClose}
                onCreate={handleCreateOrderItem}
                initialData={selectedOrderItem}
                onEdit={handleEditOrderItem}
            />
            <AgGridReact
                domLayout={'autoHeight'}
                autoSizeStrategy={autoSizeStrategy}
                rowData={rowData}
                columnDefs={columnDefs}
                onRowClicked={(e) => console.log(e)}
            />
        </div>
    )
}