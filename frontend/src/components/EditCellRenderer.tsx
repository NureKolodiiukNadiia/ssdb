import type { CustomCellRendererProps } from "@ag-grid-community/react";
import { type FunctionComponent } from "react";
import Button from "@mui/material/Button";

export const EditCellRenderer: FunctionComponent<CustomCellRendererProps & { onEdit: (orderItem: any) => void }> = ({ data, onEdit }) => {
    return (
        <Button
            sx={{ width: '100%', height: '100%', padding: 0, margin: 0, border: 'none' }}
            onClick={() => onEdit(data)}
        >
            Edit
        </Button>
    );
};