import { call, put, takeLatest } from "redux-saga/effects";
import { activityApi, driversApi, loginAPI, logoutAPI, ordersApi, pieApi, revenueApi, statsApi, usersApi } from "./api";
import {
  fetchOrdersRequest,
  fetchOrdersSuccess,
  fetchOrdersFailure,
  fetchStatsSuccess,
  fetchStatsFailure,
  fetchStatsRequest,
  fetchActivityRequest,
  fetchActivitySuccess,
  fetchActivityFailure,
  fetchDriversSuccess,
  fetchDriversFailure,
  fetchDriversRequest,
  fetchUsersSuccess,
  fetchUsersFailure,
  fetchUsersRequest,
  fetchRevenueSuccess,
  fetchRevenueFailure,
  fetchRevenueRequest,
  fetchPieSuccess,
  fetchPieFailure,
  fetchPieRequest,
  loginRequest,
  loginSuccess,
  loginFailure,
  logoutSuccess,
  logoutFailure,
  logoutRequest,

} from "./postSlice";
import type { Driver, PieChartItem, RevenueChartItem, User } from "../../constants/type";
import type { SagaIterator } from "redux-saga";

// function* workerFetchPosts(): Generator<any, void, Post[]> {
//   try {
//     const data = yield call(fetchPostsAPI);
//     yield put(fetchPostsSuccess(data));
//   } catch (error: any) {
//     yield put(fetchPostsFailure(error.message));
//   }
// };

function* handleFetchOrders(): SagaIterator {
  try {
    const data = yield call(ordersApi.getOrders);
    yield put(fetchOrdersSuccess(data));
  } catch (error: any) {
    yield put(fetchOrdersFailure(error.message));
  }
};


function* handleFetchStats(): SagaIterator {
  try {
    const data = yield call(statsApi.getStats);
    yield put(fetchStatsSuccess(data));
  } catch (error: any) {
    yield put(fetchStatsFailure(error.message));
  }
};


function* handleFetchActivity(): SagaIterator {
  try {
    const data = yield call(activityApi.getActivity);
    yield put(fetchActivitySuccess(data));
  } catch (error: any) {
    yield put(fetchActivityFailure(error.message));
  }
};


function* handleFetchDrivers(): SagaIterator {
  try {
    const data: Driver[] = yield call(driversApi.getDrivers);
    yield put(fetchDriversSuccess(data));
  } catch (error: any) {
    yield put(fetchDriversFailure(error.message));
  }
};


function* handleFetchUsers(): SagaIterator {
  try {
    const data: User[] = yield call(usersApi.getUsers);
    yield put(fetchUsersSuccess(data));
  } catch (error: any) {
    yield put(fetchUsersFailure(error.message));
  }
};



function* handleFetchRevenue(): SagaIterator {
  try {
    const data: RevenueChartItem[] = yield call(
      revenueApi.getRevenueChart
    );
    yield put(fetchRevenueSuccess(data));
  } catch (error: any) {
    yield put(fetchRevenueFailure(error.message));
  }
}



function* handleFetchPie(): SagaIterator {
  try {
    const data: PieChartItem[] = yield call(pieApi.getPieData);
    yield put(fetchPieSuccess(data));
  } catch (error: any) {
    yield put(fetchPieFailure(error.message));
  }
}


function* handleLogin(action: any): any {
  try {
    const data = yield call(loginAPI, action.payload.email);

    if (data.status === "success") {
      yield put(loginSuccess(data.message));
    } else {
      yield put(loginFailure("Login failed"));
    }
  } catch (error: any) {
    yield put(loginFailure(error.message));
  }
}


function* handleLogout(): any {
  try {
    const data = yield call(logoutAPI);

    if (data.status === "success") {
      yield put(logoutSuccess(data.message));
    } else {
      yield put(logoutFailure("Logout failed"));
    }

  } catch (error: any) {
    yield put(logoutFailure(error.message));
  }
}



export default function* postSaga(): SagaIterator {
  // yield takeLatest(fetchPostsRequest.type, workerFetchPosts);
  yield takeLatest(fetchOrdersRequest.type, handleFetchOrders);
  yield takeLatest(fetchStatsRequest.type, handleFetchStats);
  yield takeLatest(fetchActivityRequest.type, handleFetchActivity);
  yield takeLatest(fetchDriversRequest.type, handleFetchDrivers);
  yield takeLatest(fetchUsersRequest.type, handleFetchUsers);
  yield takeLatest(fetchRevenueRequest.type, handleFetchRevenue);
  yield takeLatest(fetchPieRequest.type, handleFetchPie);
  yield takeLatest(loginRequest.type, handleLogin);
  yield takeLatest(logoutRequest.type, handleLogout);


}


