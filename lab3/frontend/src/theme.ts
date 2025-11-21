import { createTheme } from '@mui/material/styles';

export const theme = createTheme({
    colorSchemes: {
        light: {
            palette: {
                primary: {
                    main: '#000000',
                },
                secondary: {
                    main: '#4338ca',
                }

            },
        },
        dark: {
            palette: {
                primary: {
                    main: '#ffffff',
                },
                secondary: {
                    main: '#4338ca', 
                }
            },
        },
    },
    
    typography: {
        fontFamily: 'Inter, Roboto, Arial, sans-serif',
        fontSize: 14,
    },
    
    components: {
        MuiButton: {
            styleOverrides: {
                root: {
                    borderRadius: 5, 
                },
            },
        },
    },
});