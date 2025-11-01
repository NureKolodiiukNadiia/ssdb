import React from 'react';
import CustomersWithHighestOrder from './CustomerWithHighestOrder';
import UsersWithMultipleOrders from './UsersWithMultipleOrders';
import UsersWhicOrederedWashing from './UsersWhichOrderedWashing';


const StatisticsDashboard: React.FC = () => {
  return (
    <div>
      <h1>Statistics</h1>

      <h2>Користувач, який має замовлення на найбільшу суму</h2>
      <CustomersWithHighestOrder />

      <h2>Користувачі, який мають більше одного замовлення за останній місяць</h2>
      <UsersWithMultipleOrders />
      <UsersWhicOrederedWashing />
    </div>
  );
};

export default StatisticsDashboard;
