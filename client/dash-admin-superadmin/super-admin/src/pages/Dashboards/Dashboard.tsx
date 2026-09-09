import { useDispatch, useSelector } from "react-redux";
import Bottombar from "./Bottombar";
import KpiCard from "./KpiCard";
import type { RootState } from "../../app/store";
import { useEffect } from "react";
import { fetchStatsRequest } from "../../features/post/postSlice";
import { Spinner } from "@/components/ui/spinner";


export default function Dashboard() {

  const dispatch = useDispatch();

  const { stats, statsLoading } = useSelector(
    (state: RootState) => state.posts
  );

  useEffect(() => {
    dispatch(fetchStatsRequest());
  }, [dispatch]);

if (statsLoading) {
  return (
    <div className="flex items-center justify-center h-screen">
      <Spinner className="size-12 text-gray-900 dark:text-slate-200" />
    </div>
  );
}
  const kpis = stats
    ? [
      {
        label: "Total Revenue",
        value: `₹${(stats.totalRevenue / 100000).toFixed(1)}L`,
      },
    ]
    : [];

  return (
    <>
      <div className=" overflow-x-auto   scrollbar-hide">
        {kpis.map((k) => (
          <KpiCard key={k.label} {...k} />
        ))}
      </div>

      <div className="mt-12">
        <Bottombar />
      </div>

    </>
  );
}