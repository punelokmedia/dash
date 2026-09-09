import { useEffect, useMemo, useState } from "react";
import { Card } from "../../components/ui/card";
import Avatar from "../../components/ui/Avatar";
import { useDispatch, useSelector } from "react-redux";
import type { RootState } from "../../app/store";
import { fetchUsersRequest } from "../../features/post/postSlice";
import { Spinner } from "@/components/ui/spinner";

export default function Users() {
  const dispatch = useDispatch();
  const { users, usersLoading } = useSelector((state: RootState) => state.posts);

  const [search, setSearch] = useState("");
  const [roleFilter, setRoleFilter] = useState("all");

  useEffect(() => {
    dispatch(fetchUsersRequest());
  }, [dispatch]);

  const filtered = useMemo(
    () =>
      users.filter(
        (u) =>
          (u.name.toLowerCase().includes(search.toLowerCase()) ||
            u.email.toLowerCase().includes(search.toLowerCase())) &&
          (roleFilter === "all" || u.role === roleFilter)
      ),
    [users, search, roleFilter]
  );

  return (
    <div className="space-y-6 px-4 sm:px-6 lg:px-8 py-6 bg-gray-50 dark:bg-gray-900 min-h-screen transition-colors duration-300">

      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
        <div>
          <h1 className="font-display text-xl sm:text-2xl lg:text-3xl font-bold text-gray-800 dark:text-slate-100">
            Users
          </h1>
          <p className="text-gray-500 dark:text-slate-400 text-sm mt-1">
            {filtered.length} registered users
          </p>
        </div>

        <button className="bg-indigo-600 hover:bg-indigo-700 transition text-white px-4 py-2 rounded-xl text-sm font-semibold w-full sm:w-auto">
          + Add User
        </button>
      </div>

      {/* Filters */}
      <div className="flex flex-col lg:flex-row gap-4">
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Search users..."
          className="w-full lg:flex-1 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-700 text-gray-900 dark:text-slate-200 placeholder-gray-400 dark:placeholder-slate-500 rounded-xl px-4 py-2.5 text-sm outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 transition"
        />

        <div className="flex flex-wrap gap-2">
          {["all", "admin", "manager", "customer"].map((r) => (
            <button
              key={r}
              onClick={() => setRoleFilter(r)}
              className={`px-3 py-2 rounded-xl text-xs font-semibold capitalize transition ${roleFilter === r
                  ? "bg-indigo-600 text-white shadow-sm"
                  : "bg-gray-100 dark:bg-slate-700 text-gray-700 dark:text-slate-300 hover:bg-gray-200 dark:hover:bg-slate-600"
                }`}
            >
              {r}
            </button>
          ))}
        </div>
      </div>

      {/* Users List */}
      <Card className="overflow-hidden">
        {usersLoading ? (
          <div className="flex items-center justify-center h-screen">
            <Spinner className="size-12 text-gray-900 dark:text-slate-200" />
          </div>
        ) : (
          <>
            {/* Desktop Table */}
            <div className="hidden md:block dark:bg-slate-900 bg-white overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-gray-200 dark:border-slate-700">
                    {["User", "Email", "Phone", "Role", "Orders", "City", "Actions"].map((h) => (
                      <th
                        key={h}
                        className="px-5 py-3.5 text-left text-xs font-semibold text-gray-500 dark:text-slate-400 uppercase"
                      >
                        {h}
                      </th>
                    ))}
                  </tr>
                </thead>

                <tbody>
                  {filtered.map((u) => (
                    <tr
                      key={u.id}
                      className="border-b border-gray-200 dark:border-slate-700 hover:bg-gray-100 dark:hover:bg-slate-800 transition"
                    >
                      <td className="px-5 py-3.5">
                        <div className="flex items-center gap-3">
                          <Avatar initials={u.avatar} size="w-8 h-8" text="text-xs" />
                          <div>
                            <p className="font-semibold text-gray-900 dark:text-white">
                              {u.name}
                            </p>
                            <p className="text-xs text-gray-500 dark:text-slate-400">
                              {u.id}
                            </p>
                          </div>
                        </div>
                      </td>

                      <td className="px-5 py-3.5 text-gray-700 dark:text-slate-300 text-xs">
                        {u.email}
                      </td>

                      <td className="px-5 py-3.5 text-gray-700 dark:text-slate-300 text-xs">
                        {u.phone}
                      </td>

                      <td className="px-5 py-3.5 text-gray-800 dark:text-slate-200 capitalize">
                        {u.role}
                      </td>

                      <td className="px-5 py-3.5 font-bold text-gray-900 dark:text-white">
                        {u.orders}
                      </td>

                      <td className="px-5 py-3.5 text-gray-700 dark:text-slate-400 text-xs">
                        {u.city}
                      </td>

                      <td className="px-5 py-3.5 flex gap-2">
                        <button className="text-xs font-semibold text-indigo-600 dark:text-indigo-400 bg-indigo-50 dark:bg-indigo-500/10 hover:bg-indigo-100 dark:hover:bg-indigo-500/20 px-2.5 py-1 rounded-lg transition">
                          Edit
                        </button>

                        <button className="text-xs font-semibold text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-500/10 hover:bg-red-100 dark:hover:bg-red-500/20 px-2.5 py-1 rounded-lg transition">
                          Ban
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Mobile Cards */}
            <div className="md:hidden p-4 space-y-4">
              {filtered.map((u) => (
                <div
                  key={u.id}
                  className="bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl p-4 space-y-3"
                >
                  <div className="flex items-center gap-3">
                    <Avatar initials={u.avatar} size="w-8 h-8" text="text-xs" />
                    <div>
                      <p className="text-gray-900 dark:text-white font-semibold">
                        {u.name}
                      </p>
                      <p className="text-xs text-gray-500 dark:text-slate-400">
                        {u.email}
                      </p>
                    </div>
                  </div>

                  <div className="flex justify-between text-xs text-gray-700 dark:text-slate-400">
                    <span className="capitalize">{u.role}</span>
                    <span>{u.city}</span>
                  </div>

                  <div className="flex justify-between text-sm">
                    <span className="text-gray-800 dark:text-slate-200">
                      Orders: {u.orders}
                    </span>
                    <span className="text-gray-700 dark:text-slate-400">
                      {u.phone}
                    </span>
                  </div>

                  <div className="flex gap-2 pt-2">
                    <button className="flex-1 text-xs font-semibold text-indigo-600 dark:text-indigo-400 bg-indigo-50 dark:bg-indigo-500/10 hover:bg-indigo-100 dark:hover:bg-indigo-500/20 px-2.5 py-2 rounded-lg transition">
                      Edit
                    </button>

                    <button className="flex-1 text-xs font-semibold text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-500/10 hover:bg-red-100 dark:hover:bg-red-500/20 px-2.5 py-2 rounded-lg transition">
                      Ban
                    </button>
                  </div>
                </div>
              ))}
            </div>

            {filtered.length === 0 && (
              <div className="text-center py-12 text-gray-500 dark:text-slate-400">
                No users found
              </div>
            )}
          </>
        )}
      </Card>
    </div>
  );
}