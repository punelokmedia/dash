import { LoginResponse, STATS, type Activity, type Driver, type Order, type PieChartItem, type RevenueChartItem, type User } from "../../constants/type";
import { ACTIVITY, DRIVERS, ORDERS, PIE_DATA, REVENUE_CHART, USERS } from "../../mockdata/data";
import axios from "axios";



export const fetchPostsAPI = async () => {
  const response = await fetch("https://jsonplaceholder.typicode.com/posts");
  if (!response.ok) throw new Error("Failed to fetch posts");
  return response.json();
};


export const ordersApi = {
  getOrders: async (): Promise<Order[]> => {
    await new Promise((resolve) => setTimeout(resolve, 800));
    return ORDERS;
  },
};


export const statsApi = {
  getStats: async (): Promise<any> => {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(STATS);
      }, 500);
    });
  },
};


export const activityApi = {
  getActivity: async (): Promise<Activity[]> => {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(ACTIVITY);
      }, 500);
    });
  },
};


export const driversApi = {
  getDrivers: async (): Promise<Driver[]> => {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(DRIVERS as Driver[]);
      }, 700);
    });
  },
};



export const usersApi = {
  getUsers: async (): Promise<User[]> => {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(USERS);
      }, 600);
    });
  },
};


export const revenueApi = {
  getRevenueChart: async (): Promise<RevenueChartItem[]> => {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(REVENUE_CHART);
      }, 500);
    });
  },
};



export const pieApi = {
  getPieData: async (): Promise<PieChartItem[]> => {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(PIE_DATA);
      }, 400);
    });
  },
};




export async function loginAPI(email: string): Promise<LoginResponse> {
  const res = await axios.post(
    "http://localhost:3000/api/super-admin/signin",
    { email },
    {
      headers: {
        "Content-Type": "application/json",
      },
    }
  );

  return res.data;
}

export async function logoutAPI() {
  const res = await axios.get(
    "http://localhost:3000/api/super-admin/logout",
    {
      withCredentials: true,
    }
  );

  return res.data;
}