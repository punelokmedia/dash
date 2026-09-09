# User API – Dash (E-commerce Customer App)

APIs for **Dash** – e-commerce customers (Blinkit-style). Base path: **`/api/user`**.

**Authentication:** All endpoints except `GET /` require **JWT** in header:

```
Authorization: Bearer <access_token>
```

Token is obtained from **`POST /api/auth/verify-otp`** (user auth, not partner). First login flow uses **4 APIs**:

- `POST /api/auth/check-user` – check existing vs new.
- `POST /api/auth/send-otp` – send / resend OTP.
- `POST /api/auth/verify-otp` – verify OTP, create user first time, get JWT.
- `POST /api/user/create-account` – create basic profile (Create your account screen).

---

## Endpoints (Dash user + Create account)

### 0. Login / OTP endpoints (overview)

These are defined in `README_AUTH.md` but repeated here for Dash user flow.

1. **Check user**

   - **`POST /api/auth/check-user`**
   - Body:

   ```json
   {
     "mobile_number": "9876543210"
   }
   ```

   - If `exists: true` → go to OTP screen (send-otp).
   - If `exists: false` → after OTP, go to **Create your account** screen.

2. **Send OTP**

   - **`POST /api/auth/send-otp`**

3. **Verify OTP**

   - **`POST /api/auth/verify-otp`**
   - Returns `access_token`, `profileCompleted`, `user.is_new`.

---

### 1. Create account – “Create your account” screen

**`POST /api/user/create-account`**

Used only for **Create your account** screen (first time after OTP login).

Creates the **basic profile only** (no address fields in this API). For **Create your account** screen you send **only name, email / phone (text field), using_for**. The **mobile number used for login is already fixed from OTP and is not part of this body**.

**Request body**

```json
{
  "full_name": "John Doe",
  "email": "john@example.com",
  "using_for": "Business Usage"
}
```

- **full_name** – Required for profile completion.
- **mobile_number** – **Not sent in this API.** It comes from the JWT (same mobile number that verified OTP) and cannot be changed from this screen.
- **email** – Optional text field on the UI labelled **“Email / Phone number”**. You always send it in the `email` key – it can contain either an email or an alternate contact string, but the **primary phone number for the account is the login mobile**, not this field.
- **using_for** – Text from dropdown on **Create your account** screen — in the UI it shows as **“I will be using Porter for:”** with options like:
  - `"Business Usage"`
  - `"Personal Usage"`
  - `"House Shifting Usage"`
  
  Whatever option user selects is sent as `using_for` and stored in the `users.using_for` column.

**Response (200)** – Same shape as GET profile.

---

## Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/user/create-account` | Create basic profile (no address) (JWT) |

Profile is considered **complete** when `full_name` is not null. The Dash app uses this for redirect:

- `profileCompleted: false` (from `/api/auth/verify-otp`) → go to **Create your account** screen (call `POST /api/user/create-account`).
- `profileCompleted: true` → go to **home/dashboard**.

There is **one user per mobile number** (mobile is unique), so once a user account is created and profile is filled (including the **“I will be using porter for”** dropdown value), another user cannot create a separate account with the same mobile number.

See **API_REFERENCE.md** for “kon sa API kiske liye” and **README_AUTH.md** for user OTP endpoints (`/api/auth/send-otp`, `/api/auth/verify-otp`).


| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/user/add-gstin` | adding gst info (Required JWT)

**Request body**

```json
{
  "gstin": "29ABCDE1234F2Z6"
}
```
**Response – add-gstin (201)**

```json
{
    "success": true,
    "data": {
        "gstIn": "27ABCDE1234F1Z5",
        "message": "gstin added successfully"
    }
}
```
See **API_REFERENCE.md** for “kon sa API kiske liye” and **README_AUTH.md** for user OTP endpoints (`/api/auth/send-otp`, `/api/auth/verify-otp`).
