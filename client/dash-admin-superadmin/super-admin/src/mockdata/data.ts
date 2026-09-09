import type { Location, Order, PieChartItem, RevenueChartItem, User } from "../constants/type";

export const STATS = {
  totalRevenue: 1084320, totalOrders: 12483, activeDeliveries: 342,
  pendingOrders: 87, totalDrivers: 198, completedToday: 156,
  cancelledToday: 12, avgDeliveryTime: "38 min",
};

export const REVENUE_CHART: RevenueChartItem[] = [
  { month: "Jan", revenue: 65000, orders: 820 }, { month: "Feb", revenue: 72000, orders: 940 },
  { month: "Mar", revenue: 68000, orders: 880 }, { month: "Apr", revenue: 85000, orders: 1100 },
  { month: "May", revenue: 91000, orders: 1240 }, { month: "Jun", revenue: 78000, orders: 980 },
  { month: "Jul", revenue: 95000, orders: 1320 }, { month: "Aug", revenue: 102000, orders: 1450 },
  { month: "Sep", revenue: 88000, orders: 1180 }, { month: "Oct", revenue: 110000, orders: 1560 },
  { month: "Nov", revenue: 98000, orders: 1380 }, { month: "Dec", revenue: 132000, orders: 1820 },
];

export const ORDERS = [
  { id: "ORD-10291", customer: "Rahul Mehta", pickup: "Andheri West, Mumbai", drop: "Powai, Mumbai", driver: "Suresh Kumar", status: "delivered", amount: 450, weight: "12 kg", date: "2024-03-15", type: "Express" },
  { id: "ORD-10292", customer: "Priya Sharma", pickup: "Koramangala, Bengaluru", drop: "Whitefield, Bengaluru", driver: "Ravi Patil", status: "in-transit", amount: 320, weight: "5 kg", date: "2024-03-15", type: "Standard" },
  { id: "ORD-10293", customer: "Amit Joshi", pickup: "Connaught Place, Delhi", drop: "Gurgaon, Haryana", driver: "Unassigned", status: "pending", amount: 780, weight: "20 kg", date: "2024-03-15", type: "Heavy" },
  { id: "ORD-10294", customer: "Sneha Reddy", pickup: "T. Nagar, Chennai", drop: "Anna Nagar, Chennai", driver: "Vijay S.", status: "in-transit", amount: 210, weight: "2 kg", date: "2024-03-15", type: "Express" },
  { id: "ORD-10295", customer: "Karan Patel", pickup: "Banjara Hills, Hyderabad", drop: "Secunderabad", driver: "Mohammed A.", status: "cancelled", amount: 560, weight: "8 kg", date: "2024-03-15", type: "Standard" },
  { id: "ORD-10296", customer: "Deepa Nair", pickup: "MG Road, Kochi", drop: "Kakkanad, Kochi", driver: "Thomas K.", status: "delivered", amount: 390, weight: "6 kg", date: "2024-03-14", type: "Standard" },
  { id: "ORD-10297", customer: "Arjun Singh", pickup: "Salt Lake, Kolkata", drop: "Park Street, Kolkata", driver: "Bikash D.", status: "delivered", amount: 270, weight: "3 kg", date: "2024-03-14", type: "Express" },
  { id: "ORD-10298", customer: "Meera Iyer", pickup: "Juhu, Mumbai", drop: "Bandra, Mumbai", driver: "Anil W.", status: "pending", amount: 490, weight: "9 kg", date: "2024-03-14", type: "Heavy" },
] satisfies Order[];;

export const DRIVERS = [
  { id: "DRV-001", name: "Suresh Kumar", phone: "+91 98201 12345", vehicle: "Tata Ace — MH01-AB1234", status: "active", rating: 4.8, trips: 1240, earnings: 82400, location: "Andheri, Mumbai", avatar: "SK" },
  { id: "DRV-002", name: "Ravi Patil", phone: "+91 97302 23456", vehicle: "Mahindra Bolero — KA05-CD5678", status: "active", rating: 4.6, trips: 980, earnings: 64200, location: "Koramangala, Bengaluru", avatar: "RP" },
  { id: "DRV-003", name: "Vijay S.", phone: "+91 94403 34567", vehicle: "Ashok Leyland Dost — TN09-EF9012", status: "on-trip", rating: 4.9, trips: 1560, earnings: 102800, location: "T. Nagar, Chennai", avatar: "VS" },
  { id: "DRV-004", name: "Mohammed A.", phone: "+91 96504 45678", vehicle: "Force Tempo — TS07-GH3456", status: "inactive", rating: 4.3, trips: 720, earnings: 47600, location: "Banjara Hills, Hyderabad", avatar: "MA" },
  { id: "DRV-005", name: "Thomas K.", phone: "+91 95605 56789", vehicle: "Eicher Pro — KL12-IJ7890", status: "active", rating: 4.7, trips: 1100, earnings: 72400, location: "MG Road, Kochi", avatar: "TK" },
  { id: "DRV-006", name: "Bikash D.", phone: "+91 93706 67890", vehicle: "Tata 407 — WB24-KL1234", status: "on-trip", rating: 4.5, trips: 860, earnings: 56800, location: "Salt Lake, Kolkata", avatar: "BD" },
];

export const USERS: User[] = [
  { id: "USR-001", name: "Rahul Mehta", email: "rahul@email.com", phone: "+91 98201 11111", role: "customer", status: "active", orders: 24, city: "Mumbai", avatar: "RM" },
  { id: "USR-002", name: "Priya Sharma", email: "priya@email.com", phone: "+91 97302 22222", role: "customer", status: "active", orders: 18, city: "Bengaluru", avatar: "PS" },
  { id: "USR-003", name: "Admin User", email: "admin@logistics.com", phone: "+91 94403 33333", role: "admin", status: "active", orders: 0, city: "Mumbai", avatar: "AU" },
  { id: "USR-004", name: "Karan Patel", email: "karan@email.com", phone: "+91 96504 44444", role: "customer", status: "suspended", orders: 7, city: "Hyderabad", avatar: "KP" },
  { id: "USR-005", name: "Manager Raj", email: "manager@logistics.com", phone: "+91 95605 55555", role: "manager", status: "active", orders: 0, city: "Delhi", avatar: "MR" },
];

export const ACTIVITY = [
  { id: 1, dot: "bg-indigo-400", msg: "New order ORD-10298 placed by Meera Iyer", time: "2 min ago" },
  { id: 2, dot: "bg-blue-400", msg: "Driver Ravi Patil started delivery for ORD-10292", time: "8 min ago" },
  { id: 3, dot: "bg-emerald-400", msg: "ORD-10291 delivered successfully", time: "15 min ago" },
  { id: 4, dot: "bg-red-400", msg: "ORD-10295 cancelled by customer", time: "32 min ago" },
  { id: 5, dot: "bg-amber-400", msg: "New customer registered: Deepa Nair", time: "1 hr ago" },
  { id: 6, dot: "bg-emerald-400", msg: "Payment ₹780 received for ORD-10293", time: "2 hr ago" },
];

export const PIE_DATA: PieChartItem[] = [
  { name: "Delivered", value: 8420, color: "#34d399" },
  { name: "In Transit", value: 342, color: "#818cf8" },
  { name: "Pending", value: 87, color: "#fbbf24" },
  { name: "Cancelled", value: 234, color: "#f87171" },
];

export const STATUS_MAP = {
  delivered: { cls: "bg-emerald-500/10 text-emerald-400 ring-1 ring-emerald-500/20", label: "Delivered" },
  "in-transit": { cls: "bg-indigo-500/10 text-indigo-400 ring-1 ring-indigo-500/20", label: "In Transit" },
  pending: { cls: "bg-amber-500/10 text-amber-400 ring-1 ring-amber-500/20", label: "Pending" },
  cancelled: { cls: "bg-red-500/10 text-red-400 ring-1 ring-red-500/20", label: "Cancelled" },
  active: { cls: "bg-emerald-500/10 text-emerald-400 ring-1 ring-emerald-500/20", label: "Active" },
  "on-trip": { cls: "bg-indigo-500/10 text-indigo-400 ring-1 ring-indigo-500/20", label: "On Trip" },
  inactive: { cls: "bg-slate-500/10 text-slate-400 ring-1 ring-slate-500/20", label: "Inactive" },
  suspended: { cls: "bg-red-500/10 text-red-400 ring-1 ring-red-500/20", label: "Suspended" },
  customer: { cls: "bg-violet-500/10 text-violet-400 ring-1 ring-violet-500/20", label: "Customer" },
  admin: { cls: "bg-pink-500/10 text-pink-400 ring-1 ring-pink-500/20", label: "Admin" },
  manager: { cls: "bg-sky-500/10 text-sky-400 ring-1 ring-sky-500/20", label: "Manager" },
};


export const NAV = [
  { id: "dashboard", label: "Dashboard", icon: "▦" },
  { id: "livetracking", label: "LiveTracking", icon: "🗺️" },
  { id: "orders", label: "Orders", icon: "📦" },
  { id: "drivers", label: "Drivers", icon: "🚚" },
  { id: "users", label: "Users", icon: "👥" },
  { id: "analytics", label: "Analytics", icon: "📈" },
  { id: "settings", label: "Settings", icon: "⚙️" },
];


export const kpis = [
  { label: "Total Revenue", value: `₹${(STATS.totalRevenue / 100000).toFixed(1)}L`, sub: "+12% vs last month", icon: "💰", accent: "from-indigo-500 to-violet-500" },
  { label: "Total Orders", value: STATS.totalOrders.toLocaleString(), sub: `${STATS.completedToday} completed today`, icon: "📦", accent: "from-emerald-500 to-teal-500" },
  { label: "Active Deliveries", value: STATS.activeDeliveries, sub: "Live right now", icon: "🚚", accent: "from-sky-500 to-blue-500" },
  { label: "Pending Orders", value: STATS.pendingOrders, sub: "Need assignment", icon: "⏳", accent: "from-amber-500 to-orange-500" },
  { label: "Total Drivers", value: STATS.totalDrivers, sub: "Registered drivers", icon: "👤", accent: "from-violet-500 to-purple-600" },
  { label: "Avg Delivery", value: STATS.avgDeliveryTime, sub: "Across all orders", icon: "⏱️", accent: "from-pink-500 to-rose-500" },
];




export const LOCATIONS = Array.from({ length: 100 }, (_, i) => {
  const isWarehouse = Math.random() < 0.1; // ~10% warehouses
  const latOffset = (Math.random() - 0.5) * 0.05; // ±0.025
  const lngOffset = (Math.random() - 0.5) * 0.05; // ±0.025
  return {
    id: i + 1,
    type: isWarehouse ? "warehouse" : "delivery",
    name: isWarehouse
      ? `Warehouse ${String.fromCharCode(65 + (i % 26))}`
      : `Rider ${i + 1}`,
    lat: 18.5204 + latOffset,
    lng: 73.8567 + lngOffset,
  };
}) satisfies Location[];
