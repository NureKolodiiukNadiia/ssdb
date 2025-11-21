import { AgGridReact } from "ag-grid-react";
import { useState, useEffect } from "react";
import "ag-grid-community/styles/ag-grid.css";
import "ag-grid-community/styles/ag-theme-alpine.min.css";
import { EditCellRenderer } from "../components/EditCellRenderer";
import { DeleteCellRenderer } from "../components/DeleteCellRenderer";
import { format } from "date-fns";
import { Button } from "@mui/material";
import OrderForm from "../components/CreateForms/OrderForm.tsx";
import agent from "../api/agent.ts";
import { convertOrderStatus, convertPaymentMethod, convertPaymentStatus } from "../utils.ts";
import { User } from "../models/User.ts";

export default function Orders() {
    const [rowData, setRowData] = useState<User[]>([]);
    const [dialogOpen, setDialogOpen] = useState(false);
    const [selectedOrder, setSelectedOrder] = useState(null);

    const columnDefs = [
        { field: 'id', headerName: 'Id' },
        { field: 'status', headerName: 'Status' },
        { field: 'subtotal', headerName: 'Subtotal' },
        { field: 'description', headerName: 'Description' },
        { field: 'paymentMethod', headerName: 'Payment Method' },
        { field: 'paymentStatus', headerName: 'Payment Status' },
        { field: 'deliveryFee', headerName: 'Delivery Fee' },
        { field: 'collectedDate', headerName: 'Collected Date' },
        { field: 'deliveredDate', headerName: 'Delivered Date' },
        { field: 'userId', headerName: 'User' },
        { field: '', cellRenderer: (params) => <EditCellRenderer {...params} onEdit={handleDialogOpen} /> },
        { 
            cellRenderer: (params) => <DeleteCellRenderer {...params} onDelete={handleDelete} />,
            width: 100 
        }        ];

    const autoSizeStrategy = {
        type: 'fitCellContents'
    };

    const themeName = "ag-theme-alpine-auto-dark";

    useEffect(() => {
        agent.Orders.getAll()
            .then((orders) => {
                const formattedData = orders.map((order) => ({
                    ...order,
                    status: convertOrderStatus(order.status),
                    paymentMethod: convertPaymentMethod(order.paymentMethod),
                    paymentStatus: convertPaymentStatus(order.paymentStatus),
                    collectedDate: format(new Date(order.collectedDate), 'dd.MM.yyyy'),
                    deliveredDate: format(new Date(order.deliveredDate), 'dd.MM.yyyy'),
                }));
                setRowData(formattedData);
                console.log(formattedData);
            })
            .catch((error) => {
                console.error("Error fetching data:", error);
            });
    }, []);

    const handleDialogOpen = (order = null) => {
        setSelectedOrder(order);
        setDialogOpen(true);
    };

    const handleDialogClose = () => {
        setDialogOpen(false);
        setSelectedOrder(null);
    };

    const handleCreateOrder = (orderData) => {
        agent.Orders.create(orderData)
            .then((response) => {
                const newOrder = {
                    ...response,
                    status: convertOrderStatus(response.status),
                    paymentMethod: convertPaymentMethod(response.paymentMethod),
                    paymentStatus: convertPaymentStatus(response.paymentStatus),
                    collectedDate: format(new Date(response.collectedDate), 'dd.MM.yyyy HH:mm'),
                    deliveredDate: format(new Date(response.deliveredDate), 'dd.MM.yyyy HH:mm'),
                };
                setRowData(prevRowData => [...prevRowData, newOrder]);
                handleDialogClose();
            })
            .catch((error) => {
                console.error("Error creating order:", error);
            });
    };

    const handleEditOrder = (updatedOrderData) => {
        agent.Orders.update(updatedOrderData)
            .then((response) => {
                const updatedOrder = {
                    ...response,
                    status: convertOrderStatus(response.status),
                    paymentMethod: convertPaymentMethod(response.paymentMethod),
                    paymentStatus: convertPaymentStatus(response.paymentStatus),
                    collectedDate: format(new Date(response.collectedDate), 'dd.MM.yyyy HH:mm'),
                    deliveredDate: format(new Date(response.deliveredDate), 'dd.MM.yyyy HH:mm'),
                };
                
                setRowData(prevRowData => 
                    prevRowData.map(order => 
                        order.id === updatedOrder.id ? updatedOrder : order
                    )
                );
                
                handleDialogClose();
            })
            .catch((error) => {
                console.error("Error updating order:", error);
            });
    };

    const handleDelete = (id: number) => {
        agent.Orders.delete(id)
            .then(() => {
                setRowData(prevRowData => 
                    prevRowData.filter(order => order.id !== id)
                );
            })
            .catch((error) => {
                console.error("Error deleting order:", error);
            });
    };

    return (
        <div className={themeName} style={{ marginLeft: '1vw', height: '100%', width: '97vw' }}>
            <Button onClick={() => handleDialogOpen()} variant="contained" color="primary">Add</Button>
            <OrderForm open={dialogOpen} onClose={handleDialogClose} onCreate={handleCreateOrder} initialData={selectedOrder} onEdit={handleEditOrder} />
            <AgGridReact
                domLayout={'autoHeight'}
                autoSizeStrategy={autoSizeStrategy}
                rowData={rowData}
                columnDefs={columnDefs}
                onRowClicked={(e) => console.log(e)}
            />
        </div>
    );
}