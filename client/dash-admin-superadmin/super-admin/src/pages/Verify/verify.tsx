import { useEffect } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import axios from "axios"

export default function VerifyLogin() {
  const [params] = useSearchParams();
  const navigate = useNavigate();

  useEffect(() => {
    const token = params.get("Token");

    if (!token) {
      console.error("No token found!");
      navigate("/login");
      return;
    }

    const verify = async () => {
      try {
        const res = await axios.get("http://localhost:3000/api/super-admin/verify", {
          withCredentials: true,
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });

        console.log("hiii there verify", res.data);

        if (res.status !== 200) {
          throw new Error("Verification failed");
        }

        console.log(res.data);

        // backend should set cookie here
        navigate("/dashboard");

      } catch (err) {
        console.error("Error verifying login:", err);
        navigate("/login");
      }
    };

    verify();
  }, [params, navigate]);

  return (
    <p className="text-black flex items-center justify-center h-screen text-center">
      Verifying login...
    </p>
  );
}