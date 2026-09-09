import { useState } from "react";
import { Outlet, useNavigate, useLocation } from "react-router-dom";
import { NAV } from "../mockdata/data";
import { useTheme } from "../components/ui/DarkmodeToggle";
import Header from "@/pages/Dashboards/Header";
import { Suspense } from "react";
import { Spinner } from "@/components/ui/spinner";
import { LogOut } from "lucide-react";
import { useLogout } from "@/Hooks/Logout";

export default function DashboardLayout() {
    const [collapsed, setCollapsed] = useState(false);
    const [mobileOpen, setMobileOpen] = useState(false);

    const navigate = useNavigate();
    const location = useLocation();
    const { theme } = useTheme();
    const { logout } = useLogout();

    console.log(location.pathname)

    // get active page from URL
    const pathParts = location.pathname.split("/");
    console.log("pathparts", pathParts);

    const activePage = pathParts[pathParts.length - 1] || "dashboard";

    console.log("activePage", activePage);


    // navigation click
    const handleNavClick = (id: string) => {
        navigate(`/dashboard/${id === "dashboard" ? "" : id}`);
        setMobileOpen(false);
    };

    return (
        <div className={theme === "dark" ? "dark" : ""}>
            <div className="flex h-screen bg-slate-50 dark:bg-slate-950 overflow-hidden relative">

                {/* Sidebar */}
                <aside
                    className={`
            fixed lg:static z-50 top-0 left-0 h-full
            ${mobileOpen ? "translate-x-0" : "-translate-x-full"}
            lg:translate-x-0
            ${collapsed ? "lg:w-16" : "lg:w-56"}
            w-64
            bg-white dark:bg-slate-900
            border-r border-slate-200 dark:border-slate-800
            flex flex-col
            transition-all duration-300
          `}
                >

                    {/* Logo / top bar */}
                    <div className={`flex items-center ${collapsed ? "justify-center" : "justify-between"} p-4 border-b border-slate-200 dark:border-slate-800`}>

                        {!collapsed && (
                            <div className="flex items-center gap-3">
                                <div className="w-8 h-8 rounded-xl bg-gradient-to-br from-indigo-500 to-violet-600 flex items-center justify-center text-sm">
                                    🚀
                                </div>
                                <span className="font-bold text-gray-800 dark:text-white text-base">
                                    DASH
                                </span>
                            </div>
                        )}

                        {/* collapse toggle */}
                        <button
                            onClick={() => setCollapsed(!collapsed)}
                            className="hidden lg:block text-slate-400"
                        >
                            ☰
                        </button>

                        {/* mobile close */}
                        <button
                            onClick={() => setMobileOpen(false)}
                            className="lg:hidden text-slate-400 text-xl"
                        >
                            ✕
                        </button>
                    </div>

                    {/* Navigation */}
                    <nav className="flex-1 p-2 space-y-1 overflow-y-auto">
                        {NAV.map(item => {
                            const isActive = activePage === item.id;
                            return (
                                <button
                                    key={item.id}
                                    onClick={() => handleNavClick(item.id)}
                                    className={`
                    w-full flex items-center
                    ${collapsed ? "justify-center" : "gap-3"}
                    px-3 py-2.5 rounded-xl
                    transition-all text-left
                    ${isActive
                                            ? "bg-indigo-500/20 text-indigo-400"
                                            : "text-gray-500 dark:text-gray-300 hover:bg-slate-100 dark:hover:bg-slate-800"
                                        }
                  `}
                                >
                                    <span className="text-base">{item.icon}</span>
                                    {!collapsed && <span className="text-sm font-medium">{item.label}</span>}
                                </button>
                            );
                        })}
                    </nav>

                    {/* Logout */}
                    <div className="p-2 mt-auto border-t border-slate-200 dark:border-slate-800">
                        <button
                            onClick={logout}
                            className={`
    w-full flex items-center
    ${collapsed ? "justify-center" : "gap-3"}
    px-3 py-2.5 rounded-xl
    text-red-500 hover:bg-red-500/10
    transition-all
  `}
                        >
                            <span className="text-lg">
                                <LogOut size={18} />
                            </span>

                            {!collapsed && (
                                <span className="text-sm font-medium">Logout</span>
                            )}
                        </button>
                    </div>

                </aside>

                {/* Main content */}
                <div className="flex-1 flex flex-col overflow-hidden">

                    {/* Header */}
                    <Header
                        active={activePage}
                        toggleSidebar={() => {
                            if (window.innerWidth < 1024) setMobileOpen(!mobileOpen);
                            else setCollapsed(!collapsed);
                        }}
                    />

                    {/* Page Content */}
                    <main className="flex-1 overflow-y-auto p-4 sm:p-6">
                        <Suspense fallback={
                            <div className="p-6 animate-pulse flex justify-center items-center h-screen">
                                <Spinner className="size-12 text-gray-900 dark:text-slate-200" />
                            </div>
                        }>
                            <Outlet /> {/* only this changes on navigation */}
                        </Suspense>
                    </main>

                </div>

            </div>
        </div>
    );
}