import {
  Bar,
  BarChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import { Card } from "../../components/ui/card";
import Avatar from "../../components/ui/Avatar";
import { useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import type { RootState } from "../../app/store";
import {
  fetchDriversRequest,
  fetchRevenueRequest,
} from "../../features/post/postSlice";
import React, { Suspense, lazy } from "react";

const RevenueChart = lazy(() => import("../Dashboards/RevenueChart")); import { Spinner } from "@/components/ui/spinner";

export default function Analytics() {
  const dispatch = useDispatch();

  const {
    drivers,
    revenueChart,
    driversLoading,
    revenueLoading,
  } = useSelector((state: RootState) => state.posts);

  useEffect(() => {
    dispatch(fetchDriversRequest());
    dispatch(fetchRevenueRequest());
  }, [dispatch]);

  const chartLoading = revenueLoading || !revenueChart?.length;
  const leaderboardLoading = driversLoading || !drivers?.length;

  return (
    <div className="space-y-6 px-4 sm:px-6 lg:px-8 py-6">

      {/* Header */}
      <div>
        <h1 className="font-display text-xl sm:text-2xl lg:text-3xl font-bold text-black dark:text-white">
          Analytics
        </h1>
        <p className="text-slate-400 text-sm mt-1">
          Business performance overview
        </p>
      </div>

      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">

        {/* Revenue Chart */}
        <Card className="p-4 sm:p-6">
          <h3 className="font-bold text-black dark:text-white mb-5 text-lg">
            Monthly Revenue (₹)
          </h3>

          {chartLoading ? (
            <div className="h-[220px] flex items-center justify-center text-slate-400">
              Loading chart...
            </div>
          ) : (
            <ResponsiveContainer width="100%" height={220}>
              <BarChart data={revenueChart}>
                <CartesianGrid strokeDasharray="3 3" stroke="#1e293b" />
                <XAxis
                  dataKey="month"
                  tick={{ fontSize: 11, fill: "#64748b" }}
                  axisLine={false}
                  tickLine={false}
                />
                <YAxis
                  tick={{ fontSize: 11, fill: "#64748b" }}
                  axisLine={false}
                  tickLine={false}
                />
                <Tooltip
                  contentStyle={{
                    background: "#1e293b",
                    border: "1px solid #334155",
                    borderRadius: 10,
                    fontSize: 12,
                  }}
                />
                <Bar dataKey="revenue" fill="#818cf8" radius={[5, 5, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          )}
        </Card>

        {/* Orders Chart */}
        <Card className="p-4 sm:p-6">
          <h3 className="font-bold text-black dark:text-white mb-5 text-lg">
            Monthly Orders
          </h3>

          {chartLoading ? (
            <div className="h-[220px] flex items-center justify-center text-slate-400">
              Loading chart...
            </div>
          ) : (
            <ResponsiveContainer width="100%" height={220}>
              <BarChart data={revenueChart}>
                <CartesianGrid strokeDasharray="3 3" stroke="#1e293b" />
                <XAxis dataKey="month" />
                <YAxis />
                <Tooltip />
                <Bar dataKey="orders" fill="#34d399" radius={[5, 5, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          )}
        </Card>
      </div>

      {/* Leaderboard */}
      <Card className="overflow-hidden">
        <div className="p-4 sm:p-6 border-b border-slate-700/50">
          <h3 className="font-bold text-black dark:text-white text-lg">
            Driver Performance Leaderboard
          </h3>
        </div>

        {leaderboardLoading ? (
          <div className="py-16 flex justify-center items-center text-center h-screen text-slate-400">
            <Spinner className="size-12 text-gray-900 dark:text-slate-200" />
          </div>
        ) : (
          <>
            {/* Desktop Table */}
            <div className="hidden md:block overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-slate-700/50">
                    {["#", "Driver", "Trips", "Rating", "Earnings"].map((h) => (
                      <th
                        key={h}
                        className="px-5 py-3 text-left text-xs font-semibold text-slate-500 uppercase"
                      >
                        {h}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {[...drivers]
                    .sort((a, b) => b.trips - a.trips)
                    .map((d, i) => (
                      <tr key={d.id} className="border-b border-slate-700/30">
                        <td className="px-5 py-4 font-bold">{i + 1}</td>
                        <td className="px-5 py-4 flex items-center gap-3">
                          <Avatar initials={d.avatar} size="w-8 h-8" text="text-xs" />
                          <span className="text-white">{d.name}</span>
                        </td>
                        <td className="px-5 py-4">{d.trips}</td>
                        <td className="px-5 py-4">⭐ {d.rating}</td>
                        <td className="px-5 py-4 text-emerald-400 font-bold">
                          ₹{d.earnings}
                        </td>
                      </tr>
                    ))}
                </tbody>
              </table>
            </div>

            {/* Mobile Cards */}
            <div className="md:hidden p-4 space-y-4">
              {[...drivers]
                .sort((a, b) => b.trips - a.trips)
                .map((d, i) => (
                  <div
                    key={d.id}
                    className="bg-slate-800/50 rounded-xl p-4 space-y-2"
                  >
                    <div className="flex items-center gap-3">
                      <Avatar initials={d.avatar} size="w-8 h-8" text="text-xs" />
                      <div>
                        <p className="text-white font-semibold">{d.name}</p>
                        <p className="text-xs text-slate-400">
                          #{i + 1} • ⭐ {d.rating}
                        </p>
                      </div>
                    </div>

                    <div className="flex justify-between text-sm text-slate-300">
                      <span>Trips: {d.trips}</span>
                      <span className="text-emerald-400 font-bold">
                        ₹{d.earnings}
                      </span>
                    </div>
                  </div>
                ))}
            </div>
          </>
        )}
      </Card>

      <Suspense
        fallback={
          <div className="flex items-center justify-center h-40">
            <Spinner className="size-8" />
          </div>
        }
      >
        <RevenueChart />
      </Suspense>
    </div>
  );
}