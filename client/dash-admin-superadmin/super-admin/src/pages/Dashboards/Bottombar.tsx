import { useDispatch, useSelector } from "react-redux";
import Badge from "../../components/ui/Badge";
import { Card } from "../../components/ui/card";
import type { RootState } from "../../app/store";
import { useEffect } from "react";
import {
  fetchActivityRequest,
  fetchOrdersRequest,
} from "../../features/post/postSlice";
import { useTheme } from "../../components/ui/DarkmodeToggle";
import { Spinner } from "@/components/ui/spinner";

export default function Bottombar() {
  const dispatch = useDispatch();
  const { data, ordersLoading, activities, activityLoading } =
    useSelector((state: RootState) => state.posts);

  const { theme } = useTheme();

  useEffect(() => {
    dispatch(fetchOrdersRequest());
    dispatch(fetchActivityRequest());
  }, [dispatch]);

  return (
    <div
      className={`px-4 sm:px-6 lg:px-8 ${theme === "dark" ? "bg-slate-950" : "bg-white"
        }`}
    >
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">

        {/* Recent Orders */}
        <Card
          className={`p-4 sm:p-6 h-full ${theme === "dark"
            ? "bg-slate-800 border border-slate-700"
            : "bg-white border border-slate-200"
            }`}
        >
          <h3
            className={`font-display font-bold mb-4 text-lg sm:text-xl ${theme === "dark" ? "text-white" : "text-gray-900"
              }`}
          >
            Recent Orders
          </h3>

          {ordersLoading ? (
            <p className="text-gray-400 flex text-center items-center justify-center h-screen dark:text-gray-400">
              <Spinner className="size-12 text-gray-900 dark:text-slate-200" />
            </p>
          ) : (
            <div
              className={`divide-y ${theme === "dark" ? "divide-slate-700/40" : "divide-slate-200/50"
                }`}
            >
              {data.slice(0, 5).map((o) => (
                <div
                  key={o.id}
                  className="flex flex-col sm:flex-row sm:items-center sm:justify-between py-3 gap-2"
                >
                  {/* Left */}
                  <div>
                    <p
                      className={`text-sm font-bold ${theme === "dark" ? "text-indigo-400" : "text-indigo-600"
                        } break-all`}
                    >
                      {o.id}
                    </p>
                    <p
                      className={`text-xs ${theme === "dark" ? "text-gray-400" : "text-gray-500"
                        }`}
                    >
                      {o.customer}
                    </p>
                  </div>

                  {/* Right */}
                  <div className="flex sm:flex-col sm:items-end justify-between sm:justify-end gap-2">
                    <Badge value={o.status} />
                    <p
                      className={`text-xs font-bold ${theme === "dark" ? "text-white" : "text-gray-900"
                        }`}
                    >
                      ₹{o.amount}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          )}
        </Card>

        {/* Live Activity */}
        <Card
          className={`p-4 sm:p-6 h-full ${theme === "dark"
            ? "bg-slate-800 border border-slate-700"
            : "bg-white border border-slate-200"
            }`}
        >
          <h3
            className={`font-display font-bold mb-4 text-lg sm:text-xl ${theme === "dark" ? "text-white" : "text-gray-900"
              }`}
          >
            Live Activity
          </h3>

          {activityLoading ? (
            <p className="flex justify-center text-center items-center text-gray-400 dark:text-gray-400 ">
              <Spinner className="size-12 text-gray-900 dark:text-slate-200" />
            </p>
          ) : (
            <div
              className={`divide-y ${theme === "dark" ? "divide-slate-700/40" : "divide-slate-200/50"
                }`}
            >
              {activities.map((a) => (
                <div
                  key={a.id}
                  className="flex gap-3 py-3 items-start"
                >
                  <div
                    className={`w-2 h-2 rounded-full mt-1.5 flex-shrink-0 ${a.dot}`}
                  />
                  <div className="min-w-0">
                    <p
                      className={`text-sm leading-snug break-words ${theme === "dark" ? "text-gray-300" : "text-gray-700"
                        }`}
                    >
                      {a.msg}
                    </p>
                    <p
                      className={`text-xs mt-0.5 ${theme === "dark" ? "text-gray-400" : "text-gray-500"
                        }`}
                    >
                      {a.time}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          )}
        </Card>
      </div>
    </div>
  );
}