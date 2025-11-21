import React, { useEffect, useState } from 'react';
import { AgGridReact } from 'ag-grid-react';
import 'ag-grid-community/styles/ag-grid.css';
import 'ag-grid-community/styles/ag-theme-alpine.css';
import agent from '../../api/agent';

const UsersWithMultipleOrders: React.FC = () => {
  const [rowData, setRowData] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const data = await agent.Statistics.getUsersWithMultipleOrders();
        setRowData(data);
      } catch (error) {
        console.error("Failed to fetch users with multiple orders:", error);
      }
    };

    fetchData();
  }, []);

  const columnDefs = [
    { headerName: "User ID", field: "userId", sortable: true, filter: true },
    { headerName: "First Name", field: "firstName", sortable: true, filter: true },
    { headerName: "Last Name", field: "lastName", sortable: true, filter: true },
    { headerName: "Order Count", field: "orderCount", sortable: true, filter: true }
  ];

  return (
    <div className="ag-theme-alpine" style={{ height: 400, width: '100%' }}>
      <AgGridReact rowData={rowData} columnDefs={columnDefs} />
    </div>
  );
};

export default UsersWithMultipleOrders;
