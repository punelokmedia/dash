import { useEffect, useState } from "react";
import { DRIVERS } from "../../mockdata/data";
import { Card } from "../../components/ui/card";
import Avatar from "../../components/ui/Avatar";
import { useDispatch, useSelector } from "react-redux";
import type { RootState } from "../../app/store";
import { fetchDriversRequest } from "../../features/post/postSlice";
import { Spinner } from "@/components/ui/spinner";

export default function Drivers() {
  const dispatch = useDispatch();
  const { drivers, driversLoading } = useSelector((state: RootState) => state.posts);

  useEffect(() => {
    dispatch(fetchDriversRequest());
  }, [dispatch]);

  const [search, setSearch] = useState("");
  const filtered = drivers.filter(d =>
    d.name.toLowerCase().includes(search.toLowerCase()) ||
    d.id.toLowerCase().includes(search.toLowerCase())
  );

  if (driversLoading) {
  return (
    <div className="flex items-center justify-center h-screen">
      <Spinner className="size-12 text-gray-900 dark:text-slate-200" />
    </div>
  );
}


  return (
    <div className="space-y-5 px-4 sm:px-6 lg:px-8 py-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3">
        <div>
          <h1 className="font-display text-2xl sm:text-3xl font-bold text-gray-900 dark:text-white">Drivers</h1>
          <p className="text-gray-500 dark:text-gray-400 text-sm mt-1">{DRIVERS.length} registered drivers</p>
        </div>
        <button className="btn-primary bg-indigo-600 hover:bg-indigo-500 text-white px-5 py-2.5 rounded-xl text-sm font-semibold transition-colors">
          + Add Driver
        </button>
      </div>

      {/* Search */}
      <input
        value={search}
        onChange={e => setSearch(e.target.value)}
        placeholder="Search drivers..."
        className="w-full max-w-xs bg-gray-100 dark:bg-slate-800/60 border border-gray-300 dark:border-slate-700 text-gray-900 dark:text-slate-200 placeholder-gray-400 dark:placeholder-slate-500 rounded-xl px-4 py-2.5 text-sm outline-none focus:border-indigo-500 transition-colors"
      />

      {/* Driver Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-4">
        {filtered.map(d => (
          <Card key={d.id} className="p-5 bg-white dark:bg-slate-900 shadow dark:shadow-lg transition-colors">
            <div className="flex gap-4 items-center mb-4">
              <Avatar initials={d.avatar} size="w-12 h-12" text="text-base" />
              <div className="flex-1 min-w-0">
                <div className="flex justify-between items-center gap-2">
                  <p className="font-bold text-gray-900 dark:text-white text-base truncate">{d.name}</p>
                  {/* <Badge value={d.status} /> */}
                </div>
                <p className="text-xs text-gray-500 dark:text-slate-400 mt-0.5">{d.id} · {d.phone}</p>
              </div>
            </div>

            <div className="bg-gray-100 dark:bg-slate-800/50 rounded-xl px-4 py-2.5 mb-4 text-xs text-gray-500 dark:text-slate-400">
              🚛 {d.vehicle}
            </div>

            <div className="grid grid-cols-3 gap-2 mb-4">
              {[
                { label: "Rating", value: `⭐ ${d.rating}` },
                { label: "Trips", value: d.trips.toLocaleString() },
                { label: "Earnings", value: `₹${(d.earnings / 1000).toFixed(0)}K` },
              ].map(s => (
                <div key={s.label} className="bg-gray-100 dark:bg-slate-800/50 rounded-xl py-2.5 text-center">
                  <p className="text-sm font-bold text-gray-900 dark:text-white">{s.value}</p>
                  <p className="text-xs text-gray-500 dark:text-slate-400 uppercase tracking-wide mt-0.5">{s.label}</p>
                </div>
              ))}
            </div>

            <div className="flex flex-col sm:flex-row justify-between text-xs gap-2 text-gray-500 dark:text-slate-400">
              <span>📍 {d.location}</span>
              <div className="flex gap-2">
                <button className="text-indigo-600 dark:text-indigo-400 hover:text-indigo-500 dark:hover:text-indigo-300 font-semibold transition-colors">View</button>
                <button className="text-red-600 dark:text-red-400 hover:text-red-500 dark:hover:text-red-300 font-semibold transition-colors">Remove</button>
              </div>
            </div>
          </Card>
        ))}
      </div>

      {filtered.length === 0 && (
        <p className="text-center text-gray-500 dark:text-slate-400 py-10">No drivers found</p>
      )}
    </div>
  );
}