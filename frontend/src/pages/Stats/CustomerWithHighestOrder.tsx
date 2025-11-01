import React, { useEffect, useState } from 'react';
import { AgGridReact } from 'ag-grid-react';
import 'ag-grid-community/styles/ag-grid.css';
import 'ag-grid-community/styles/ag-theme-alpine.css';
import agent from '../../api/agent';

const CustomersWithHighestOrder: React.FC = () => {
  const [rowData, setRowData] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const data = await agent.Statistics.getCustomersWithHighestOrder();
        setRowData(data);
      } catch (error) {
        console.error("Failed to fetch customers with highest order:", error);
      }
    };

    fetchData();
  }, []);

  const columnDefs = [
    { headerName: "First Name", field: "firstName", sortable: true, filter: true },
    { headerName: "Last Name", field: "lastName", sortable: true, filter: true },
    { headerName: "Subtotal", field: "subtotal", sortable: true, filter: true }
  ];

  return (
    <div className="ag-theme-alpine" style={{ height: 400, width: '100%' }}>
      <AgGridReact rowData={rowData} columnDefs={columnDefs} />
    </div>
  );
};

export default CustomersWithHighestOrder;
