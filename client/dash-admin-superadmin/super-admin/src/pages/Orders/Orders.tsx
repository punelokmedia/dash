import { useEffect, useMemo, useState } from "react";
import { Card } from "../../components/ui/card";
import Badge from "../../components/ui/Badge";
import { useDispatch, useSelector } from "react-redux";
import type { RootState } from "../../app/store";
import { fetchOrdersRequest } from "../../features/post/postSlice";
import { useTheme } from "@/components/ui/DarkmodeToggle";
import { Spinner } from "@/components/ui/spinner";

export default function Orders() {
  const [search, setSearch] = useState("");
  const [filter, setFilter] = useState("all");
  const FILTERS = ["all", "pending", "in-transit", "delivered", "cancelled"];

  const dispatch = useDispatch();
  const { data, ordersLoading } = useSelector(
    (state: RootState) => state.posts
  );

  const { theme } = useTheme();

  useEffect(() => {
    dispatch(fetchOrdersRequest());
  }, [dispatch]);

  const filtered = useMemo(() => {
    return data.filter((o) => {
      const s =
        o.id.toLowerCase().includes(search.toLowerCase()) ||
        o.customer.toLowerCase().includes(search.toLowerCase());
      return s && (filter === "all" || o.status === filter);
    });
  }, [search, filter, data]);

  if (ordersLoading)
    return (
      <div className="flex justify-center items-center h-screen">
        <p className={theme === "dark" ? "text-white" : "text-gray-900"}>
          <Spinner className="size-12 text-gray-900 dark:text-slate-200" />
        </p>
      </div>
    );

  return (
    <div
      className={`space-y-6 px-4 sm:px-6 lg:px-8 py-6 ${theme === "dark" ? "bg-slate-950" : "bg-gray-50"
        }`}
    >

      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
        <div>
          <h1
            className={`font-display text-xl sm:text-2xl lg:text-3xl font-bold ${theme === "dark" ? "text-white" : "text-gray-900"
              }`}
          >
            Orders
          </h1>
          <p
            className={`text-sm mt-1 ${theme === "dark" ? "text-gray-400" : "text-gray-600"
              }`}
          >
            {filtered.length} total orders
          </p>
        </div>

        <button
          className="bg-indigo-600 hover:bg-indigo-700 transition text-white px-4 py-2 rounded-xl text-sm font-semibold w-full sm:w-auto"
        >
          + New Order
        </button>
      </div>

      <Card
        className={`p-4 sm:p-6 ${theme === "dark"
          ? "bg-slate-800 border border-slate-700"
          : "bg-white border border-slate-200"
          }`}
      >

        {/* Filter Bar */}
        <div className="flex flex-col lg:flex-row gap-4 mb-6">
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search orders, customers..."
            className={`w-full lg:flex-1 rounded-xl px-4 py-2.5 text-sm outline-none border focus:border-indigo-500 ${theme === "dark"
              ? "bg-slate-900/60 border-slate-700 text-gray-200 placeholder-gray-400"
              : "bg-gray-100 border-gray-300 text-gray-900 placeholder-gray-500"
              }`}
          />

          <div className="flex flex-wrap gap-2">
            {FILTERS.map((f) => (
              <button
                key={f}
                onClick={() => setFilter(f)}
                className={`px-3 py-2 rounded-xl text-xs font-semibold capitalize transition-all ${filter === f
                  ? "bg-indigo-600 text-white"
                  : theme === "dark"
                    ? "bg-slate-700/50 text-gray-400 hover:bg-slate-700"
                    : "bg-gray-200 text-gray-700 hover:bg-gray-300"
                  }`}
              >
                {f}
              </button>
            ))}
          </div>
        </div>

        {/* Desktop Table */}
        <div className="hidden md:block overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr
                className={`border-b ${theme === "dark" ? "border-slate-700/60" : "border-gray-300"
                  }`}
              >
                {["Order ID", "Customer", "Route", "Driver", "Type", "Status", "Amount"].map(
                  (h) => (
                    <th
                      key={h}
                      className={`pb-3 text-left text-xs font-semibold uppercase tracking-wider px-3 first:pl-0 ${theme === "dark" ? "text-gray-400" : "text-gray-500"
                        }`}
                    >
                      {h}
                    </th>
                  )
                )}
              </tr>
            </thead>
            <tbody>
              {filtered.map((o) => (
                <tr
                  key={o.id}
                  className={`border-b ${theme === "dark" ? "border-slate-700/30" : "border-gray-200"
                    }`}
                >
                  <td
                    className={`py-3 px-3 font-bold ${theme === "dark" ? "text-indigo-400" : "text-indigo-600"
                      }`}
                  >
                    {o.id}
                  </td>
                  <td
                    className={`py-3 px-3 ${theme === "dark" ? "text-gray-200" : "text-gray-900"
                      }`}
                  >
                    {o.customer}
                  </td>
                  <td
                    className={`py-3 px-3 text-xs ${theme === "dark" ? "text-gray-300" : "text-gray-600"
                      }`}
                  >
                    {o.pickup} → {o.drop}
                  </td>
                  <td
                    className={`py-3 px-3 ${theme === "dark" ? "text-gray-300" : "text-gray-700"
                      }`}
                  >
                    {o.driver}
                  </td>
                  <td
                    className={`py-3 px-3 ${theme === "dark" ? "text-gray-400" : "text-gray-600"
                      }`}
                  >
                    {o.type}
                  </td>
                  <td className="py-3 px-3">
                    <Badge value={o.status} />
                  </td>
                  <td
                    className={`py-3 px-3 font-bold ${theme === "dark" ? "text-white" : "text-gray-900"
                      }`}
                  >
                    ₹{o.amount}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Mobile Card Layout */}
        <div className="md:hidden space-y-4">
          {filtered.map((o) => (
            <div
              key={o.id}
              className={`rounded-xl p-4 space-y-2 ${theme === "dark"
                ? "bg-slate-800/50"
                : "bg-gray-100"
                }`}
            >
              <div className="flex justify-between items-center">
                <p
                  className={`font-bold ${theme === "dark" ? "text-indigo-400" : "text-indigo-600"
                    }`}
                >
                  {o.id}
                </p>
                <Badge value={o.status} />
              </div>

              <p
                className={`text-sm ${theme === "dark" ? "text-gray-200" : "text-gray-900"
                  }`}
              >
                {o.customer}
              </p>

              <div
                className={`text-xs ${theme === "dark" ? "text-gray-400" : "text-gray-600"
                  }`}
              >
                {o.pickup} → {o.drop}
              </div>

              <div
                className={`flex justify-between text-xs ${theme === "dark" ? "text-gray-400" : "text-gray-600"
                  }`}
              >
                <span>{o.driver}</span>
                <span
                  className={`font-bold ${theme === "dark" ? "text-white" : "text-gray-900"
                    }`}
                >
                  ₹{o.amount}
                </span>
              </div>
            </div>
          ))}
        </div>

        {filtered.length === 0 && (
          <div
            className={`text-center py-10 ${theme === "dark" ? "text-gray-400" : "text-gray-500"
              }`}
          >
            No orders found
          </div>
        )}
      </Card>
    </div>
  );
}