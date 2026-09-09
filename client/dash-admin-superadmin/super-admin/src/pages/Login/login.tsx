"use client";

import { useEffect, useState } from "react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Check } from "lucide-react";
import { useDispatch, useSelector } from "react-redux";
import { loginRequest } from "@/features/post/postSlice";
import { RootState } from "@/app/store";
import { Spinner } from "@/components/ui/spinner";
import { toast } from "react-toastify";

export default function Login() {
  const dispatch = useDispatch();
  const { Loginloading, LoginSuccess, loginError } = useSelector(
    (state: RootState) => state.posts
  )

  const [email, setEmail] = useState("");
  const [verified, setVerified] = useState(false);


  const validateEmail = (value: string) => {
    const regex =
      /^(?!.*\.\.)[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$/;
    return regex.test(value);
  };

  const handleVerify = () => {
    if (validateEmail(email)) {
      setVerified(true);
    }
  };

  useEffect(() => {
    if (LoginSuccess) {
      toast.success("Email sent successfully");
    }

    if (loginError) {
      toast.error("Something went wrong");
    }
  }, [LoginSuccess, loginError]);

  const handleSubmit = () => {
    if (!verified) return;

    dispatch(
      loginRequest({
        email,
      })
    );
  };

  if (Loginloading) {
    return (
      <div className="flex items-center justify-center h-screen">
        <Spinner className="size-12 text-gray-900 dark:text-slate-200" />
      </div>
    );
  }


  return (
    <div className="min-h-screen flex items-center justify-center  px-4">
      <div className="w-full max-w-md  p-6 md:p-8">

        {/* Title */}
        <h1 className="text-3xl font-bold text-center text-green-600 mb-6">
          Super Admin
        </h1>

        {/* Illustration */}
        <div className="flex justify-center mb-6">
          <img
            src="/loginprofile.jpg"
            alt="admin"
            className="w-56 md:w-64"
          />
        </div>

        {/* Email */}
        <label className="text-[17px] text-gray-600">
          Email ID*
        </label>

        <div className="flex gap-2 mt-2">
          <div className="relative w-full">
            <Input
              className="p-7 text-[17px] rounded-2xl pr-24"
              placeholder="example@email.com"
              value={email}
              onChange={(e) => {
                setEmail(e.target.value)
                setVerified(false)
              }}
            />

            <div className="absolute right-2 top-1/2 -translate-y-1/2">
              {!verified ? (
                <Button
                  className="bg-transparent text-yellow-500 text-[17px]"
                  // size="sm"
                  variant="secondary"
                  onClick={handleVerify}
                >
                  Verify
                </Button>
              ) : (
                <div className="flex items-center text-green-500 justify-center w-8 h-8 rounded-md font-extrabold">
                  <Check size={35} />
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Submit */}
        <div className="text-center justify-center items-center">
          <Button
            onClick={handleSubmit}
            className="w-[247px] h-[50px] text-[20px] mt-6 bg-green-500 hover:bg-green-600"
          >
            Submit
          </Button>
        </div>
      </div>
    </div>
  );
}