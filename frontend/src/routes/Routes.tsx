import App from "../App.tsx";
import {createBrowserRouter} from "react-router-dom";
import ThreeTables from "../pages/ThreeTables.tsx";
import OrderParentChild from "../pages/OrderParentChild.tsx";
import StatisticsDashboard from "../pages/Stats/StatisticsDashboard.tsx";

export const router = createBrowserRouter([
    {
        path: '/',
        element: <App/>,
        children: [
            { path: '/threetables', element: <ThreeTables /> },
            { path: '/parentchild', element: <OrderParentChild /> },
            { path: '/statistics', element: <StatisticsDashboard /> },
            // { path: '*', element: <MainPage/>},
        ],
    }
]);