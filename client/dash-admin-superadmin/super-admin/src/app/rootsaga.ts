import { all } from "redux-saga/effects";
import postSaga from "../features/post/postsaga";

export default function* rootSaga() {
  yield all([
    postSaga(),
  ]);
}