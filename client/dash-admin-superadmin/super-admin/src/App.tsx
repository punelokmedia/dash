import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { lazy, Suspense } from "react";

import "./index.css";
import "./App.css";

import Login from "./pages/Login/login";
import VerifyLogin from "./pages/Verify/verify";
import { Spinner } from "./components/ui/spinner";
import ProtectedRoute from "./protectedroute/protected";

const DashboardLayout = lazy(() => import("./Layouts/DashboardLayout"));

const Dashboard = lazy(() => import("./pages/Dashboards/Dashboard"));
const Orders = lazy(() => import("./pages/Orders/Orders"));
const Drivers = lazy(() => import("./pages/Drivers/Driver"));
const Users = lazy(() => import("./pages/Users/User"));
const Analytics = lazy(() => import("./pages/Analytics/analytics"));
const Settings = lazy(() => import("./pages/Settings/settings"));
const LiveTracking = lazy(() => import("./pages/Maps/MainMap"));

function App() {
  return (
    <BrowserRouter>
      <Suspense fallback={<div className="flex justify-center items-center h-screen"><Spinner className="size-12 text-gray-900 dark:text-slate-200" />
      </div>}>

        <Routes>

          {/* redirect */}
          <Route path="/" element={<Navigate to="/login" />} />

          {/* public routes */}
          <Route path="/login" element={<Login />} />
          <Route path="/auth" element={<VerifyLogin />} />

          {/* protected dashboard */}
          <Route
            path="/dashboard"
            element={
              <ProtectedRoute>
                <DashboardLayout />
              </ProtectedRoute>
            }
          >

            {/* nested routes */}
            <Route index element={<Dashboard />} />
            <Route path="orders" element={<Orders />} />
            <Route path="drivers" element={<Drivers />} />
            <Route path="users" element={<Users />} />
            <Route path="analytics" element={<Analytics />} />
            <Route path="settings" element={<Settings />} />

            {/* heavy map page */}
            <Route path="livetracking" element={<LiveTracking />} />

          </Route>

        </Routes>

      </Suspense>
    </BrowserRouter>
  );
}

export default App;