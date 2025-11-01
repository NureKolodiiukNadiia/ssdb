import { useEffect, useState } from 'react';
import {
    Dialog,
    DialogTitle,
    DialogContent,
    DialogActions,
    TextField,
    Button,
    FormControl,
    InputLabel,
    Select,
    MenuItem,
    SelectChangeEvent,
} from '@mui/material';
import { User } from "../../models/User.ts";
import agent from "../../api/agent.ts";
import { format, isValid, parse, parseISO } from 'date-fns';

interface OrderFormProps {
    open: boolean;
    onClose: () => void;
    onCreate: (orderData: any) => void;
    initialData?: any;
    onEdit?: (updatedOrderData: any) => void;
}

export default function OrderForm({ open, onClose, onCreate, initialData, onEdit }: OrderFormProps) {

    const [orderData, setOrderData] = useState({
        userId: '',
        status: '',
        paymentMethod: '',
        paymentStatus: '',
        description: '',
        deliveryFee: '',
        collectedDate: '',
        deliveredDate: '',
        subtotal: '',
    });

    const [users, setUsers] = useState<User[]>([]);

    useEffect(() => {
        agent.Users.getAll()
            .then((data) => setUsers(data))
            .catch((error) => {
                console.error("Error fetching data:", error);
            });
    }, []);

    const formatDateForForm = (dateString: string | null | undefined): string => {
        if (!dateString) return '';
        try {
            let parsedDate = parseISO(dateString);
            if (!isValid(parsedDate)) {
                parsedDate = parse(dateString, 'dd.MM.yyyy', new Date());
            }
            if (!isValid(parsedDate)) {
                console.log('Invalid date after parsing');
                return '';
            }
            return format(parsedDate, 'yyyy-MM-dd');
        } catch (error) {
            console.error('Error parsing date:', error);
            return '';
        }
    };

    const paymentMethodMapping: { [key: string]: string } = {
        'Cash': 'Cash',
        'CreditCard': 'Credit Card' // Changed from 'Credit Card': 'CreditCard'
    };
    
    const reversePaymentMethodMapping: { [key: string]: string } = {
        'Cash': 'Cash',
        'Credit Card': 'CreditCard'  // Match the enum value
    };

    useEffect(() => {
        if (initialData) {
            console.log('Initial Data:', initialData); // Log the initial data
            setOrderData({
                ...initialData,
                collectedDate: formatDateForForm(initialData.collectedDate),
                deliveredDate: formatDateForForm(initialData.deliveredDate),
                paymentMethod: initialData.paymentMethod,
            });
        }
    }, [initialData]);

    const handleChange = (e: SelectChangeEvent<string>) => {
        const { name, value } = e.target;
        setOrderData({ ...orderData, [name]: reversePaymentMethodMapping[value] });
    };

    const handleSave = () => {
        if (initialData && onEdit) {
            onEdit(orderData);
        } else {
            onCreate(orderData);
        }
        onClose();
    };

    return (
        <Dialog open={open} onClose={onClose} fullWidth maxWidth="sm">
            <DialogTitle>{initialData ? 'Edit Order' : 'Create a new order'}</DialogTitle>
            <DialogContent>
                <TextField
                    name="description"
                    label="Description"
                    fullWidth
                    margin="dense"
                    multiline
                    rows={4}
                    value={orderData.description}
                    onChange={(e) => setOrderData({ ...orderData, description: e.target.value })}
                />

                <FormControl fullWidth margin="dense">
                    <InputLabel id="status-label">Status</InputLabel>
                    <Select
                        labelId="status-label"
                        name="status"
                        value={orderData.status}
                        onChange={(e) => setOrderData({ ...orderData, status: e.target.value })}
                        variant={'outlined'}>
                        <MenuItem value="Created">Created</MenuItem>
                        <MenuItem value="Accepted">Accepted</MenuItem>
                        <MenuItem value="Collected">Collected</MenuItem>
                        <MenuItem value="InProgress">In Progress</MenuItem>
                        <MenuItem value="Delivered">Delivered</MenuItem>
                    </Select>
                </FormControl>

                <TextField
                    name="subtotal"
                    label="Subtotal"
                    fullWidth
                    margin="dense"
                    value={orderData.subtotal}
                    onChange={(e) => setOrderData({ ...orderData, subtotal: e.target.value })}
                />

                <TextField
                    name="deliveryFee"
                    label="Delivery Fee"
                    fullWidth
                    margin="dense"
                    value={orderData.deliveryFee}
                    onChange={(e) => setOrderData({ ...orderData, deliveryFee: e.target.value })}
                />

<Select
    labelId="paymentMethod-label"
    name="paymentMethod"
    value={orderData.paymentMethod === 'CreditCard' ? 'Credit Card' : orderData.paymentMethod} // Add conversion
    onChange={handleChange}
    variant={'outlined'}>
    {Object.entries(paymentMethodMapping).map(([key, value]) => (
        <MenuItem key={key} value={value}>
            {value}
        </MenuItem>
    ))}
</Select>

                <FormControl fullWidth margin="dense">
                    <InputLabel id="paymentStatus-label">Payment Status</InputLabel>
                    <Select
                        labelId="paymentStatus-label"
                        name="paymentStatus"
                        value={orderData.paymentStatus}
                        onChange={(e) => setOrderData({ ...orderData, paymentStatus: e.target.value })}
                        variant={'outlined'}>
                        <MenuItem value="Unpaid">Unpaid</MenuItem>
                        <MenuItem value="Paid">Paid</MenuItem>
                    </Select>
                </FormControl>

                <TextField
                    name="collectedDate"
                    label="Collected Date"
                    type="date"
                    fullWidth
                    margin="dense"
                    value={orderData.collectedDate}
                    onChange={(e) => setOrderData({ ...orderData, collectedDate: e.target.value })}
                    InputLabelProps={{ shrink: true }}
                />

                <TextField
                    name="deliveredDate"
                    label="Delivered Date"
                    type="date"
                    fullWidth
                    margin="dense"
                    value={orderData.deliveredDate}
                    onChange={(e) => setOrderData({ ...orderData, deliveredDate: e.target.value })}
                    InputLabelProps={{ shrink: true }}
                />

                <FormControl fullWidth margin="dense">
                    <InputLabel id="userId-label">User ID</InputLabel>
                    <Select
                        labelId="userId-label"
                        name="userId"
                        value={orderData.userId}
                        onChange={(e) => setOrderData({ ...orderData, userId: e.target.value })}
                        variant={'outlined'}>
                        {users.map((user: User) => (
                            <MenuItem key={user.id} value={user.id}>
                                {user.id}
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
}