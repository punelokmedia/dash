import { RootState } from "@/app/store";
import { logoutRequest } from "@/features/post/postSlice";
import { useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { toast } from "react-toastify";

export const useLogout = () => {
  const dispatch = useDispatch();

  const { Logoutloading, LogoutSuccess, LogoutError } = useSelector(
    (state: RootState) => state.posts
  );

  console.log("Redux State:", LogoutSuccess, LogoutError);

  const logout = () => dispatch(logoutRequest());


  // useEffect(() => {
  //   if (LogoutSuccess) {
  //     console.log("success happens");

  //     toast.success("Logged out successfully");
  //   };

  //   console.log("hiii there");
    

  //   if (LogoutError) {
  //     console.log("Error happens");

  //     toast.error("Logout failed");
  //   }
  // }, [LogoutSuccess, LogoutError]);

  return { logout, Logoutloading };
};



// //rest actions
// resetLogoutState: (state) => {
//   state.logoutSuccess = false;
//   state.logoutError = null;
// }