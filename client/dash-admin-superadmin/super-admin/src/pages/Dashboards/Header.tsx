import Avatar from "@/components/ui/Avatar";
import { useTheme } from "@/components/ui/DarkmodeToggle";
import { Switch } from "@/components/ui/switch";
import AdminProfile from "./Profile";
import Profile from "./Profile";

type HeaderProps = {
  active: string;
  toggleSidebar: () => void;
};

export default function Header({ active, toggleSidebar }: HeaderProps) {
  const { theme, toggleTheme } = useTheme();

  return (
    <header className="h-14 bg-white dark:bg-slate-900 border-b border-slate-200 dark:border-slate-800 flex items-center justify-between px-4 lg:px-6">

      <div className="flex items-center gap-3">

        {/* Sidebar Toggle */}
        <button
          onClick={toggleSidebar}
          className="lg:hidden text-gray-400 dark:text-gray-300 text-2xl"
        >
          ☰
        </button>

        {/* Breadcrumb */}
        <div className="text-xs hidden sm:flex items-center gap-2">

          <span className="text-gray-500 dark:text-gray-400">
            Super Admin
          </span>

          <span className="text-gray-700 dark:text-gray-300">
            ›
          </span>

          <span className="text-gray-800 dark:text-gray-200 font-semibold capitalize">
            {active}
          </span>

        </div>

      </div>

      <div className="flex items-center gap-3 lg:gap-4">

        {/* Theme Switch */}
        <div className="flex items-center gap-2">

          {/* <span>☀️</span> */}

          <Switch
            checked={theme === "dark"}
            onCheckedChange={toggleTheme}
          />

          {/* <span>🌙</span> */}

        </div>

        {/* Admin card */}
        <div className="flex items-center">
          <AdminProfile />
        </div>

      </div>

    </header>
  );
}