import { AgGridReact } from "ag-grid-react";
import { useEffect, useState } from "react";
import "ag-grid-community/styles/ag-grid.css";
import "ag-grid-community/styles/ag-theme-alpine.css";
import { EditCellRenderer } from "../components/EditCellRenderer";
import { DeleteCellRenderer } from "../components/DeleteCellRenderer";
import Button from "@mui/material/Button";
import agent from "../api/agent.ts";
import { Role, User } from "../models/User.ts";
import UserForm from "../components/CreateForms/UserForm.tsx";
import { convertRole } from "../utils.ts";

export default function Users() {
    const [rowData, setRowData] = useState<User[]>([]);
    const [dialogOpen, setDialogOpen] = useState(false);
    const [selectedUser, setSelectedUser] = useState<User | null>(null);

    const columnDefs = [
        { field: 'id' },
        { field: 'firstName', headerName: 'First Name' },
        { field: 'lastName', headerName: 'Last Name' },
        { field: 'email', headerName: 'Email' },
        { field: 'phoneNumber', headerName: 'Phone Number' },
        { field: 'password', headerName: 'Password' },
        { field: 'role', headerName: 'Role' },
        { field: 'address', headerName: 'Address' },
        { field: '', cellRenderer: (params) => <EditCellRenderer {...params} onEdit={handleDialogOpen} /> },
        { 
            cellRenderer: (params) => <DeleteCellRenderer {...params} onDelete={handleDelete} />,
            width: 100 
        }    
    ];

    const autoSizeStrategy = {
        type: 'fitCellContents'
    };

    const handleDialogOpen = (user = null) => {
        setSelectedUser(user);
        setDialogOpen(true);
    };

    const handleDialogClose = () => {
        setDialogOpen(false);
        setSelectedUser(null);
    };

    const handleCreateUser = (userData) => {
        const roleConverted = (userData.role === 'User') ? Role.User : Role.Admin;
        const user = { ...userData, role: roleConverted === Role.User ? 0 : 1 };
        agent.Users.create(user)
            .then((response) => {
                const newUser = {
                    ...response,
                    role: convertRole(response.role)
                };
                setRowData(prevRowData => [...prevRowData, newUser]);
                handleDialogClose();
            })
            .catch((error) => {
                console.error("Error creating user:", error);
            });
    };

    const handleEditUser = (updatedUserData) => {
        console.log('Before conversion:', updatedUserData);
    
        const currentRole = updatedUserData.role === 'User' ? Role.User : Role.Admin;
        
        const userToUpdate = {
            ...updatedUserData,
            role: currentRole === Role.User ? 0 : 1
        };
    
        console.log('After conversion:', userToUpdate);
    
        agent.Users.update(userToUpdate)
            .then((response) => {
                console.log('API response:', response);
                
                const updatedUser = {
                    ...response,
                    role: convertRole(response.role)
                };
    
                setRowData(prevRowData =>
                    prevRowData.map(user =>
                        user.id === updatedUser.id ? updatedUser : user
                    )
                );
    
                handleDialogClose();
            })
            .catch((error) => {
                console.error("Error updating user:", error);
            });
    };

    const handleDelete = (id: number) => {
        agent.Users.delete(id)
            .then(() => {
                setRowData(prevRowData => 
                    prevRowData.filter(user => user.id !== id)
                );
            })
            .catch((error) => {
                console.error("Error deleting user:", error);
            });
    };

    useEffect(() => {
        agent.Users.getAll()
            .then((users) => {
                console.log(users);
                
                const formattedData = users.map((user) => ({
                    ...user,
                    role: convertRole(user.role),
                }));
                setRowData(formattedData);
            })
            .catch((error) => {
                console.error("Error fetching data:", error);
            });
    }, []);

    const themeName = "ag-theme-alpine-auto-dark";

    return (
        <div
            className={themeName}
            style={{ marginLeft: '1vw', height: '100%', width: '97vw' }}
        >
            <Button
                onClick={() => handleDialogOpen()}
                variant={"contained"}>Add</Button>
            <UserForm
                open={dialogOpen}
                onClose={handleDialogClose}
                onCreate={handleCreateUser}
                initialData={selectedUser}
                onEdit={handleEditUser}
            />
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