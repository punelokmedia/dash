export interface Post {
  id: number;
  userId: number;
  title: string;
  body: string;
}

export const STATS = {
  totalRevenue: 984320,
  totalOrders: 12483,
  activeDeliveries: 342,
  pendingOrders: 87,
  totalDrivers: 198,
  completedToday: 156,
  cancelledToday: 12,
  avgDeliveryTime: "38 min",
};

export const STATUS_MAP = {
  delivered:  { cls: "bg-emerald-500/10 text-emerald-400", label: "Delivered" },
  "in-transit":{ cls: "bg-indigo-500/10 text-indigo-400", label: "In Transit" },
  pending:    { cls: "bg-amber-500/10 text-amber-400", label: "Pending" },
  cancelled:  { cls: "bg-red-500/10 text-red-400", label: "Cancelled" },
};

export type OrderStatus =
  | "delivered"
  | "in-transit"
  | "pending"
  | "cancelled";

export interface Order {
  id: string;
  customer: string;
  pickup: string;
  drop: string;
  driver: string;
  status: OrderStatus;
  amount: number;
  weight: string;
  date: string;
  type: string;
}




export interface Stats {
  totalRevenue: number;
  totalOrders: number;
  activeDeliveries: number;
  pendingOrders: number;
  totalDrivers: number;
  completedToday: number;
  cancelledToday: number;
  avgDeliveryTime: string;
}



export interface Activity {
  id: number;
  dot: string;
  msg: string;
  time: string;
}



export type DriverStatus = "active" | "inactive" | "on-trip";

export interface Driver {
  id: string;
  name: string;
  phone: string;
  vehicle: string;
  status: DriverStatus;
  rating: number;
  trips: number;
  earnings: number;
  location: string;
  avatar: string;
}



export type UserRole = "customer" | "admin" | "manager";
export type UserStatus = "active" | "suspended";

export interface User {
  id: string;
  name: string;
  email: string;
  phone: string;
  role: UserRole;
  status: UserStatus;
  orders: number;
  city: string;
  avatar: string;
}


export interface RevenueChartItem {
  month: string;
  revenue: number;
  orders: number;
}


export interface PieChartItem {
  name: string;
  value: number;
  color: string;
}


export type Location = {
  id: number
  type: "delivery" | "warehouse"
  name: string
  lat: number
  lng: number
}

export interface LoginResponse {
  status: string;
  message: string;
}


export interface Locationnn {
  latitude: number
  longitude: number
  lat: number
  lng: number
  type: "rider" | "warehouse"
}