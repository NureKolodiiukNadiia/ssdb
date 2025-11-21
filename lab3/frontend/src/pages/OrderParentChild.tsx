import React, { useState } from 'react';
import { AgGridReact } from 'ag-grid-react';
import 'ag-grid-community/styles/ag-grid.css';
import 'ag-grid-community/styles/ag-theme-alpine.css';
import agent from '../api/agent';
import { OrderItem } from '../models/OrderItem';

const OrderParentChild: React.FC = () => {
  const [orderId, setOrderId] = useState<number | undefined>();
  const [rowData, setRowData] = useState<OrderItem[]>([]);

  const handleFetch = async () => {
    if (!orderId) {
      alert("Please enter a valid order ID.");
      return;
    }

    try {
      const data = await agent.OrderItems.getByOrderId(orderId);
      console.log("data", data);
      setRowData(data);
    } catch (error) {
      console.error("Failed to fetch order items:", error);
      alert("Failed to fetch order items. Please check the order ID and try again.");
    }
  };

  const columnDefs = [
    { 
        field: 'id', 
        headerName: 'ID',
        sortable: true,
        filter: true,
        width: 80
    },
    { 
        field: 'quantity', 
        headerName: 'Quantity',
        sortable: true,
        filter: true,
        width: 100
    },
    { 
        field: 'pricePerUnit', 
        headerName: 'Price Per Unit',
        sortable: true,
        filter: true,
        width: 120
    },
    { 
        field: 'serviceName', 
        headerName: 'Service',
        sortable: true,
        filter: true,
        flex: 1
    },
    { 
        field: 'orderId', 
        headerName: 'Order ID',
        sortable: true,
        filter: true,
        width: 100
    }
];

  return (
    <div>
      <div style={{ marginBottom: '20px' }}>
        <input
          type="number"
          placeholder="Enter Order ID"
          value={orderId || ''}
          onChange={(e) => setOrderId(Number(e.target.value))}
          style={{ marginRight: '10px', padding: '5px' }}
        />
        <button onClick={handleFetch} style={{ padding: '5px 10px' }}>
          Підтвердити
        </button>
      </div>
      <div className="ag-theme-alpine" style={{ height: 400, width: '100%' }}>
        <AgGridReact rowData={rowData} columnDefs={columnDefs} />
      </div>
    </div>
  );
};

export default OrderParentChild;
