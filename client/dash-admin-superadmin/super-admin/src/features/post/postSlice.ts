import { createSlice, type PayloadAction } from "@reduxjs/toolkit";
import type { Activity, Driver, Order, PieChartItem, RevenueChartItem, Stats, User } from "../../constants/type";

// interface PostState {
//   data: Post[];
//   loading: boolean;
//   error: string | null;
// }

// const initialState: PostState = {
//   data: [],
//   loading: false,
//   error: null,
// };



interface OrdersState {
  stats: Stats | null;
  data: Order[];
  activities: Activity[],
  drivers: Driver[],
  users: User[];
  revenueChart: RevenueChartItem[];
  pieData: PieChartItem[];

  Logoutmessage: string | null;
  message: string | null;

  Logoutloading: boolean;
  Loginloading: boolean;
  pieLoading: boolean;
  ordersLoading: boolean;
  statsLoading: boolean;
  activityLoading: boolean,
  driversLoading: boolean;
  usersLoading: boolean;
  revenueLoading: boolean;

  LogoutSuccess: boolean;
  LoginSuccess: boolean;
  LogoutError: string | null;
  loginError: string | null;
  pieError: string | null;
  revenueError: string | null
  usersError: string | null;
  driversError: string | null;
  activityError: string | null;
  error: string | null;
}


const initialState: OrdersState = {
  stats: null,
  data: [],
  activities: [],
  drivers: [],
  users: [],
  revenueChart: [],
  pieData: [],

  Logoutmessage: null,
  message: null,

  Logoutloading: false,
  Loginloading: false,
  pieLoading: false,
  revenueLoading: false,
  driversLoading: false,
  ordersLoading: false,
  statsLoading: false,
  activityLoading: false,
  usersLoading: false,

  LoginSuccess: false,
  LogoutSuccess: false,

  LogoutError: null,

  loginError: null,

  pieError: null,

  revenueError: null,

  usersError: null,

  driversError: null,

  activityError: null,

  error: null,
};

const postSlice = createSlice({
  name: "posts",
  initialState,
  reducers: {

    // fetchPostsRequest(state) {
    //   state.loading = true;
    //   state.error = null;
    // },
    // fetchPostsSuccess(state, action: PayloadAction<Post[]>) {
    //   state.loading = false;
    //   state.data = action.payload;
    // },
    // fetchPostsFailure(state, action: PayloadAction<string>) {
    //   state.loading = false;
    //   state.error = action.payload;
    // },



    fetchOrdersRequest(state) {
      state.ordersLoading = true;
    },
    fetchOrdersSuccess(state, action: PayloadAction<Order[]>) {
      state.ordersLoading = false;
      state.data = action.payload;
    },
    fetchOrdersFailure(state, action: PayloadAction<string>) {
      state.ordersLoading = false;
      state.error = action.payload;
    },



    fetchStatsRequest(state) {
      state.statsLoading = true;
    },
    fetchStatsSuccess(state, action: PayloadAction<Stats>) {
      state.statsLoading = false;
      state.stats = action.payload;
    },
    fetchStatsFailure(state, action: PayloadAction<string>) {
      state.statsLoading = false;
      state.error = action.payload;
    },



    fetchActivityRequest(state) {
      state.activityLoading = true;
      state.activityError = null;
    },
    fetchActivitySuccess(state, action: PayloadAction<Activity[]>) {
      state.activityLoading = false;
      state.activities = action.payload;
    },
    fetchActivityFailure(state, action: PayloadAction<string>) {
      state.activityLoading = false;
      state.activityError = action.payload;
    },


    fetchDriversRequest(state) {
      state.driversLoading = true;
      state.driversError = null;
    },
    fetchDriversSuccess(state, action: PayloadAction<Driver[]>) {
      state.driversLoading = false;
      state.drivers = action.payload;
    },
    fetchDriversFailure(state, action: PayloadAction<string>) {
      state.driversLoading = false;
      state.driversError = action.payload;
    },


    fetchUsersRequest(state) {
      state.usersLoading = true;
      state.usersError = null;
    },
    fetchUsersSuccess(state, action: PayloadAction<User[]>) {
      state.usersLoading = false;
      state.users = action.payload;
    },
    fetchUsersFailure(state, action: PayloadAction<string>) {
      state.usersLoading = false;
      state.usersError = action.payload;
    },


    fetchRevenueRequest(state) {
      state.revenueLoading = true;
      state.revenueError = null;
    },
    fetchRevenueSuccess(state, action: PayloadAction<RevenueChartItem[]>) {
      state.revenueLoading = false;
      state.revenueChart = action.payload;
    },
    fetchRevenueFailure(state, action: PayloadAction<string>) {
      state.revenueLoading = false;
      state.revenueError = action.payload;
    },


    fetchPieRequest(state) {
      state.pieLoading = true;
      state.pieError = null;
    },
    fetchPieSuccess(state, action: PayloadAction<PieChartItem[]>) {
      state.pieLoading = false;
      state.pieData = action.payload;
    },
    fetchPieFailure(state, action: PayloadAction<string>) {
      state.pieLoading = false;
      state.pieError = action.payload;
    },


    loginRequest(state, action: PayloadAction<{ email: string }>) {
      state.Loginloading = true;
      state.error = null;
      state.message = null;
    },
    loginSuccess(state, action: PayloadAction<string>) {
      state.Loginloading = false;
      state.message = action.payload;
    },
    loginFailure(state, action: PayloadAction<string>) {
      state.Loginloading = false;
      state.error = action.payload;
    },



    logoutRequest(state) {
      state.Logoutloading = true;
      state.error = null;
    },
    logoutSuccess(state, action) {
      state.Logoutloading = false;
      state.message = action.payload;
    },
    logoutFailure(state, action) {
      state.Logoutloading = false;
      state.error = action.payload;
    },
  },
});

export const {
  // fetchPostsRequest,
  // fetchPostsSuccess,
  // fetchPostsFailure,
  fetchOrdersRequest,
  fetchOrdersSuccess,
  fetchOrdersFailure,
  fetchStatsRequest,
  fetchStatsSuccess,
  fetchStatsFailure,
  fetchActivityRequest,
  fetchActivitySuccess,
  fetchActivityFailure,
  fetchDriversRequest,
  fetchDriversSuccess,
  fetchDriversFailure,
  fetchUsersRequest,
  fetchUsersSuccess,
  fetchUsersFailure,
  fetchRevenueRequest,
  fetchRevenueSuccess,
  fetchRevenueFailure,
  fetchPieRequest,
  fetchPieSuccess,
  fetchPieFailure,
  loginRequest,
  loginSuccess,
  loginFailure,
  logoutRequest,
  logoutSuccess,
  logoutFailure,
} = postSlice.actions;

export default postSlice.reducer;