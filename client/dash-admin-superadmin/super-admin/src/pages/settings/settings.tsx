import { useState } from "react";
import { Card } from "../../components/ui/card";

export default function Settings() {
  const [form, setForm] = useState<{ companyName: string; email: string; currency: string; timezone: string }>({ companyName: "SwiftLogistics India", email: "admin@logistics.com", currency: "INR", timezone: "Asia/Kolkata" });
  const [notifyEmail, setNotifyEmail] = useState(true);
  const [notifySMS, setNotifySMS] = useState(false);

  const Toggle = ({ on, toggle }:any) => (
    <div onClick={toggle} className={`w-11 h-6 rounded-full cursor-pointer transition-colors relative ${on ? "bg-indigo-600" : "bg-slate-600"}`}>
      <div className={`absolute top-0.5 w-5 h-5 rounded-full bg-white shadow transition-all ${on ? "left-5" : "left-0.5"}`} />
    </div>
  );

  return (
    <div className="space-y-5">
      <div>
        <h1 className="font-display text-slate-900 text-2xl font-bold dark:text-white">Settings</h1>
        <p className="text-slate-400 text-sm mt-1">Configure platform preferences</p>
      </div>

      <div className="grid md:grid-cols-2 gap-5">
        <Card className="p-6">
          <h3 className="font-display font-bold text-slate-900 dark:text-white mb-5">General Settings</h3>
          {[{ label: "Company Name", key: "companyName" as const }, { label: "Admin Email", key: "email" as const }, { label: "Currency", key: "currency" as const }, { label: "Timezone", key: "timezone" as const }].map((f) => (
            <div key={f.key} className="mb-4">
              <label className="block text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2">{f.label}</label>
              <input value={form[f.key]} onChange={(e) => setForm({ ...form, [f.key]: e.target.value })}
                className="w-full bg-gray-200 dark:bg-slate-900/60 border border-slate-700 text-gray-900 dark:text-slate-200 rounded-xl px-4 py-2.5 text-sm outline-none focus:border-indigo-500 transition-colors" />
            </div>
          ))}
          <button className="w-full bg-indigo-600 hover:bg-indigo-500 text-white py-2.5 rounded-xl font-semibold text-sm transition-colors mt-1">Save Changes</button>
        </Card>

        <div className="space-y-5">
          <Card className="p-6">
            <h3 className="font-display font-bold text-gray-950 dark:text-white mb-5">Notifications</h3>
            <div className="space-y-4">
              {[{ label: "Email Notifications", sub: "Receive order updates via email", on: notifyEmail, toggle: () => setNotifyEmail(!notifyEmail) },
                { label: "SMS Notifications", sub: "Receive alerts via SMS", on: notifySMS, toggle: () => setNotifySMS(!notifySMS) }].map((n) => (
                <div key={n.label} className="flex justify-between items-center">
                  <div>
                    <p className="text-sm font-semibold text-gray-950 dark:text-white">{n.label}</p>
                    <p className="text-xs text-gray-950 dark:text-slate-500">{n.sub}</p>
                  </div>
                  <Toggle on={n.on} toggle={n.toggle} />
                </div>
              ))}
            </div>
          </Card>

          <Card className="p-6">
            <h3 className="font-display font-bold text-gray-950 dark:text-white mb-2">Danger Zone</h3>
            <p className="text-xs text-slate-500 mb-4">These actions are irreversible. Proceed with caution.</p>
            <button className="w-full bg-red-500/10 hover:bg-red-500/20 text-red-400 border border-red-500/20 py-2.5 rounded-xl font-semibold text-sm transition-colors">
              Reset All Data
            </button>
          </Card>
        </div>
      </div>
    </div>
  );
}