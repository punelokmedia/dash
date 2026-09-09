import { configureStore } from "@reduxjs/toolkit";
import createSagaMiddleware from "redux-saga";
import postReducer from "../features/post/postSlice";
import rootSaga from "./rootsaga";

const sagaMiddleware = createSagaMiddleware();

export const store = configureStore({
  reducer: {
    posts: postReducer,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({ thunk: false }).concat(sagaMiddleware),
});

sagaMiddleware.run(rootSaga);

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;