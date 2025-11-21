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

interface UserFormProps {
    open: boolean;
    onClose: () => void;
    onCreate: (userData: any) => void;
    initialData?: any;
    onEdit?: (updatedUserData: any) => void;
}

export default function UserForm({ open, onClose, onCreate, initialData, onEdit } : UserFormProps) {

    const [userData, setUserData] = useState({
        firstName: '',
        lastName: '',
        email: '',
        phoneNumber: '',
        password: '',
        role: '',
        address: '',
    });

    useEffect(() => {
        if (initialData) {
            setUserData(initialData);
        }
    }, [initialData]);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | { name?: string; value: unknown }>) => {

        const { name, value } = e.target;
        setUserData({ ...userData, [name as string]: value });
    };

    const handleSave = () => {

        if (initialData && onEdit) {
            onEdit(userData);
        } else {
            onCreate(userData);
        }

        onClose();
    };

    return (
        <Dialog open={open} onClose={onClose} fullWidth maxWidth="sm">
            <DialogTitle>{initialData ? 'Edit User' : 'Create a new user'}</DialogTitle>
            <DialogContent>
                <TextField
                    name="firstName"
                    label="First Name"
                    fullWidth
                    margin="dense"
                    value={userData.firstName}
                    onChange={handleChange}
                    InputLabelProps={{ shrink: true }}
                />
                <TextField
                    name="lastName"
                    label="Last Name"
                    fullWidth
                    margin="dense"
                    value={userData.lastName}
                    onChange={handleChange}
                    InputLabelProps={{ shrink: true }}
                />
                <TextField
                    name="email"
                    label="Email"
                    type="email"
                    fullWidth
                    margin="dense"
                    value={userData.email}
                    onChange={handleChange}
                    InputLabelProps={{ shrink: true }}
                />
                <TextField
                    name="phoneNumber"
                    label="Phone Number"
                    fullWidth
                    margin="dense"
                    value={userData.phoneNumber}
                    onChange={handleChange}
                    InputLabelProps={{ shrink: true }}
                />
                <TextField
                    name="password"
                    label="Password"
                    fullWidth
                    margin="dense"
                    value={userData.password}
                    onChange={handleChange}
                    InputLabelProps={{ shrink: true }}
                />
                <FormControl fullWidth margin="dense">
                    <InputLabel id="role-label">Role</InputLabel>
                    <Select
                        labelId="role-label"
                        name="role"
                        value={userData.role}
                        onChange={handleChange}
                        variant="outlined"
                    >
                        <MenuItem value="User">User</MenuItem>
                        <MenuItem value="Admin">Admin</MenuItem>
                    </Select>
                </FormControl>
                <TextField
                    name="address"
                    label="Address"
                    fullWidth
                    margin="dense"
                    value={userData.address}
                    onChange={handleChange}
                    InputLabelProps={{ shrink: true }}
                />
            </DialogContent>
            <DialogActions>
                <Button onClick={onClose}>Cancel</Button>
                <Button onClick={handleSave}>{initialData ? 'Save Changes' : 'Create'}</Button>
            </DialogActions>
        </Dialog>
    );
}