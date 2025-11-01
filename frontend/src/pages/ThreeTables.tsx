import { Divider, Link, Stack, Typography } from "@mui/material";
import Box from "@mui/material/Box";
import { useState } from "react";
import Users from "./Users";
import Orders from "./Orders";
import OrderItems from "./OrderItems";


export default function ThreeTables() {
    const [section, setSection] = useState("user");
    const renderSection = () => {
        switch (section) {
            case "user":
                return <Users />;
            case "order":
                return <Orders />;
            case "order item":
                return <OrderItems />;
            default:
                return <Users />
        }
    };
    
    return (
        <Box>
            <Box>
            <Stack
                sx={{
                    width: {xs: '100%', sm: '100%'},
                    height: '3vw',
                    display: 'flex',
                    flexDirection: 'row',
                    justifyItems: 'center',
                    alignItems: 'center',
                    alignContent: 'center',
                    justifyContent: 'space-evenly',

                }}   
            >
                <Link
                    underline='hover'
                    onClick={() => setSection("user")}
                >
                    <Typography>Користувачі</Typography>
                    
                </Link>
                <Divider flexItem orientation="vertical" variant='fullWidth'/>
                <Link
                    underline="hover"
                    onClick={() => setSection("order")}
                >
                    <Typography>Замовлення</Typography>
                </Link>
                <Divider flexItem orientation="vertical" variant='fullWidth'/>
                <Link
                    underline="hover"
                    onClick={() => setSection("order item")}
                >
                    <Typography>Одиниці замовлення</Typography>
                </Link>
            </Stack>            
            </Box>
            <Box mt={'10px'} width={'100%'} height={'100%'}>
                {renderSection()}
            </Box>
        </Box>
    )
}