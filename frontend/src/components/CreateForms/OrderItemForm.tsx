import { useState, useEffect } from 'react';
import {
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    TextField,
    Button,
    FormControl,
    InputLabel,
    Select,
    MenuItem
} from '@mui/material';
import agent from '../../api/agent.ts';
import { Order } from '../../models/Order.ts';

interface OrderItemFormProps {
    open: boolean;
    onClose: () => void;
    onCreate: (orderItemData: any) => void;
    initialData?: any;
    onEdit?: (updatedOrderItemData: any) => void;
}

export default function OrderItemForm({ open, onClose, onCreate, initialData, onEdit }) {

    const [orderItemData, setOrderItemData] = useState({
        quantity: '',
        pricePerUnit: '',
        serviceName: '',
        orderId: ''
    });

    const [orders, setOrders] = useState<Order[]>([]);

    useEffect(() => {
        agent.Orders.getAll()
            .then((data) => setOrders(data))
            .catch((error) => {
                console.error("Error fetching data:", error);
            });
    }, []);

    useEffect(() => {
        if (initialData) {
            setOrderItemData(initialData);
        }
    }, [initialData]);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | { name?: string; value: unknown }>) => {
        const { name, value } = e.target;
        setOrderItemData({ ...orderItemData, [name as string]: value });
    };

    const handleSave = () => {
        if (initialData && onEdit) {
            onEdit(orderItemData)
        } else {
            onCreate(orderItemData);
        }
        
        onClose();
    };

    return (
        <Dialog open={open} onClose={onClose} fullWidth maxWidth="sm">
            <DialogTitle>{initialData ? 'Edit Order Item' : 'Create a new order item'}</DialogTitle>
            <DialogContent>
                <TextField
                    name="serviceName"
                    label="Service Name"
                    fullWidth
                    margin="dense"
                    value={orderItemData.serviceName}
                    onChange={handleChange}
                />
                <TextField
                    name="quantity"
                    label="Quantity"
                    type="number"
                    fullWidth
                    margin="dense"
                    value={orderItemData.quantity}
                    onChange={handleChange}
                />
                <TextField
                    name="pricePerUnit"
                    label="Price Per Unit"
                    type="number"
                    fullWidth
                    margin="dense"
                    value={orderItemData.pricePerUnit}
                    onChange={handleChange}
                />
                <FormControl fullWidth margin="dense">
                    <InputLabel id="orderId-label">Order ID</InputLabel>
                    <Select
                        labelId="orderId-label"
                        name="orderId"
                        value={orderItemData.orderId}
                        onChange={handleChange}
                        variant={'outlined'}>
                        {orders.map((order : Order) => (
                            <MenuItem key={order.id} value={order.id}>
                                {order.id}
                            </MenuItem>
                        ))}
                    </Select>
                </FormControl>
            </DialogContent>
            <DialogActions>
                <Button onClick={onClose}>Cancel</Button>
                <Button onClick={handleSave} color="primary">
                    {initialData ? 'Save Changes' : 'Create'}
                </Button>
            </DialogActions>
        </Dialog>
    );
};