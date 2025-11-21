import {Outlet, useLocation} from "react-router-dom";
import ThreeTables from "./pages/ThreeTables.tsx";
import { CssBaseline, ThemeProvider } from "@mui/material";
import { theme } from "./theme.ts";

function App() {
  const location = useLocation();

  return (
    <>
    <ThemeProvider theme={theme}>
      <CssBaseline>
        {location.pathname === '/' ? (
          <ThreeTables/>
        ) : (
                <Outlet/>
        )}
        </CssBaseline>
    </ThemeProvider>
    </>
  )
}

export default App
