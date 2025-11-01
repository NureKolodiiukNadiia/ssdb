import type { CustomCellRendererProps } from "@ag-grid-community/react";
import { type FunctionComponent } from "react";
import Button from "@mui/material/Button";

interface DeleteCellRendererProps extends CustomCellRendererProps {
    onDelete: (id: number) => void;
}

export const DeleteCellRenderer: FunctionComponent<DeleteCellRendererProps> = ({ data, onDelete }) => {
    const handleClick = () => {
        if (window.confirm('Are you sure you want to delete this item?')) {
            onDelete(data.id);
        }
    };

    return (
        <Button 
            onClick={handleClick}
            sx={{
                width: '100%',
                height: '100%',
                padding: 0,
                margin: 0,
                border: 'none'
            }}
            color="error"
        >
            DELETE
        </Button>
    );
};