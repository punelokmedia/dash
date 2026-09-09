import { CartesianGrid, Cell, Line, LineChart, Pie, PieChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { Card } from "../../components/ui/card";
import { useDispatch, useSelector } from "react-redux";
import type { RootState } from "../../app/store";
import { useEffect } from "react";
import { fetchPieRequest, fetchRevenueRequest } from "../../features/post/postSlice";
import { Spinner } from "@/components/ui/spinner";

export default function RevenueChart() {

  const dispatch = useDispatch();

  const { revenueLoading, pieLoading, revenueChart, pieData, } = useSelector(
    (state: RootState) => state.posts
  );

  useEffect(() => {
    dispatch(fetchRevenueRequest());
    dispatch(fetchPieRequest());
  }, [dispatch]);

  if (revenueLoading || pieLoading) {
    return (
      <div className="flex items-center justify-center h-screen">
        <Spinner className="size-12 text-gray-900 dark:text-slate-200" />
      </div>
    );
  }



  return (
    <div>
      <div className="grid grid-cols-3 gap-4">
        <Card className="col-span-2 p-6">
          <h3 className="font-display font-bold text-black dark:text-white mb-5">Revenue & Orders — 2025</h3>
          <ResponsiveContainer width="100%" height={210}>
            <LineChart data={revenueChart}>
              <CartesianGrid strokeDasharray="3 3" stroke="#1e293b" />
              <XAxis dataKey="month" tick={{ fontSize: 11, fill: "#64748b" }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 11, fill: "#64748b" }} axisLine={false} tickLine={false} />
              <Tooltip contentStyle={{ background: "#1e293b", border: "1px solid #334155", borderRadius: 10, fontSize: 12, color: "#e2e8f0" }} />
              <Line type="monotone" dataKey="revenue" stroke="#818cf8" strokeWidth={2.5} dot={false} />
              <Line type="monotone" dataKey="orders" stroke="#34d399" strokeWidth={2} dot={false} strokeDasharray="5 5" />
            </LineChart>
          </ResponsiveContainer>
          <div className="flex gap-5 mt-3">
            <div className="flex items-center gap-2 text-xs text-slate-400"><div className="w-3 h-0.5 bg-indigo-400 rounded" /> Revenue (₹)</div>
            <div className="flex items-center gap-2 text-xs text-slate-400"><div className="w-3 h-0.5 bg-emerald-400 rounded border-dashed" /> Orders</div>
          </div>
        </Card>

        <Card className="p-6">
          <h3 className="font-display font-bold text-black dark:text-white mb-4">Order Status</h3>
          <ResponsiveContainer width="100%" height={150}>
            <PieChart>
              <Pie data={pieData} cx="50%" cy="50%" innerRadius={42} outerRadius={65} dataKey="value">
                {pieData.map((e, i) => <Cell key={i} fill={e.color} />)}
              </Pie>
              <Tooltip contentStyle={{ background: "#1e293b", border: "1px solid #334155", borderRadius: 8, fontSize: 12, color: "#e2e8f0" }} />
            </PieChart>
          </ResponsiveContainer>
          <div className="space-y-2 mt-3">
            {pieData.map((d) => (
              <div key={d.name} className="flex justify-between items-center text-xs">
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full" style={{ background: d.color }} />
                  <span className="text-slate-400">{d.name}</span>
                </div>
                <span className="font-bold text-white">{d.value.toLocaleString()}</span>
              </div>
            ))}
          </div>
        </Card>
      </div>
    </div>
  )
}