import { Navigate } from "react-router-dom";
import { useEffect, useState } from "react";
import axios from "axios";
import { Spinner } from "@/components/ui/spinner";

interface Props {
  children: React.ReactNode;
}

export default function ProtectedRoute({ children }: Props) {
  const [loading, setLoading] = useState(true);
  const [authorized, setAuthorized] = useState(false);

  useEffect(() => {
    axios
      .get("http://localhost:3000/api/super-admin/me", {
        withCredentials: true,
      })
      .then(() => {
        setAuthorized(true);
      })
      .catch(() => {
        setAuthorized(false);
      })
      .finally(() => {
        setLoading(false);
      });
  }, []);

 if (loading)
    return (
      <div className="flex items-center justify-center h-screen">
        <Spinner className="size-12 text-gray-900 dark:text-slate-200" />
      </div>
    );
  if (!authorized) {
    // return <Navigate to="/login" replace />;
  }

  return <>{children}</>;
}






























// // import { Navigate } from "react-router-dom";

// interface Props {
//   children: React.ReactNode;
// }

// export default function ProtectedRoute({ children }: Props) {

//   const token = document.cookie.includes("access_token");

//   console.log(token);
  

//   if (!token) {
//     // return <Navigate to="/Dashboard" replace />;
//   }

//   return <>{children}</>;
// }

















