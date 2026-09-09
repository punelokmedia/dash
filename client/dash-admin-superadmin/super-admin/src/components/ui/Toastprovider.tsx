import { ToastContainer } from "react-toastify";
import { useTheme } from "../ui/DarkmodeToggle"; 
import "react-toastify/dist/ReactToastify.css";

export default function ToastProvider() {
  const { theme } = useTheme(); 

  return (
    <ToastContainer
      position="top-right"
      autoClose={3000}
      theme={theme}
      newestOnTop
      pauseOnHover
    />
  );
}