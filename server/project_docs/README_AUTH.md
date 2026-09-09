# Auth API – OTP + JWT (User & Partner)

Two separate auth flows on the same backend:

| Base path | For | Used by |
|-----------|-----|---------|
| **`/api/auth`** | Dash (e-commerce customer) | Dash frontend |
| **`/api/auth/partner`** | Delivery partner (delivery boy) | Partner frontend |
| **`/api/auth/super-admin`** | super-admin (dashboard) | login |

All endpoints are **public** (no JWT required to call them).

---

## 1. Dash user auth – `/api/auth`

### Check user (login screen – existing vs new)

**`POST /api/auth/check-user`**

Use this on the **first login screen** after the user enters mobile number.

**Request body**

```json
{
  "mobile_number": "9876543210"
}
```

**Response – existing user (200)**

```json
{
  "success": true,
  "exists": true,
  "profileCompleted": false,
  "user": {
    "id": "uuid",
    "mobile_number": "9876543210",
    "full_name": null,
    "email": null
  }
}
```

**Response – new user (200)**

```json
{
  "success": true,
  "exists": false
}
```

- If `exists: true` → directly show **Enter OTP** screen (you can immediately call **Send OTP** below).
- If `exists: false` → redirect to **Create your account** screen (after OTP flow, app will call **`POST /api/user/create-account`** – see `README_USER.md`).

### Send OTP (first time + resend)

**`POST /api/auth/send-otp`**

Use this for:

- **First OTP** after login screen.
- **Resend OTP** button on OTP screen.

**Request body**

```json
{
  "mobile_number": "9876543210"
}
```

**Response (200)**

```json
{
  "success": true,
  "message": "...",
  "dev_otp": "123456"
}
```

`dev_otp` is only present in **development**.

### Verify OTP (get JWT + create user if first time)

**`POST /api/auth/verify-otp`**

**Request body:** `{ "mobile_number": "9876543210", "otp": "123456" }`

**Response (200):**

```json
{
  "success": true,
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "profileCompleted": false,
  "user": {
    "id": "uuid",
    "mobile_number": "9876543210",
    "full_name": null,
    "email": null,
    "is_new": true
  }
}
```

- **profileCompleted** – `true` when `full_name` is set; Dash app redirects to complete-profile when `false`.
- **is_new** – `true` **only the very first time** a given `mobile_number` verifies OTP (user row is created in `users` table). On all later logins for the same mobile, no new user is created – we just update `last_login` and return `is_new: false`.
- There is **exactly one user per mobile number** (Prisma `User.mobileNumber` is unique), so other users cannot create another account with the same number.
- Use `access_token` as **`Authorization: Bearer <token>`** for `/api/user/*`.

---

## 2. Partner auth – `/api/auth/partner`

### Send OTP

**`POST /api/auth/partner/send-otp`**

**Request body:** `{ "mobile_number": "9876543210" }`

**Response (200):** Same shape as user send-otp.

### Verify OTP

**`POST /api/auth/partner/verify-otp`**

**Request body:** `{ "mobile_number": "9876543210", "otp": "123456" }`

**Response (200):**

```json
{
  "success": true,
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "partner": {
    "id": "uuid",
    "mobile_number": "9876543210",
    "full_name": null,
    "status": "pending",
    "is_new": true
  }
}
```

- Use `access_token` as **`Authorization: Bearer <token>`** for `/api/partner/*`.

---

## OTP delivery

| Environment | Behaviour |
|-------------|-----------|
| **Development** | OTP logged to server console + returned as `dev_otp` (no SMS). |
| **Production** | OTP sent via MSG91; requires `MSG91_AUTH_KEY` in `.env`. |

---

## 2. super-admin auth – `/api/auth/superadmin`

### Send email

**`POST /api/auth/super-admin/signin`**

**Request body:** `{ "email": "your email" }`

**Response (200):** 
{
    "success": true,
    "message": "please check your email..."
} 

redirect to dashboard verification page after review email .

### Verify

**`POST /api/auth/super-admin/verify`**

**Response (200):** 
{
    "success": true,
    "data": {
        "message": "Super Admin verified successfully",
        "statusCode": 200
    }
}

### logout

**`POST /api/auth/super-admin/logout`**
   req with cookie
**Response (200):**    
   {
    "success": true,
    "message": "logout success..."
   }
## Summary

| Method | Endpoint | For | Description |
|--------|----------|-----|-------------|
| POST | `/api/auth/send-otp` | Dash user | Send OTP |
| POST | `/api/auth/verify-otp` | Dash user | Verify OTP, get JWT + profileCompleted + user |
| POST | `/api/auth/partner/send-otp` | Partner | Send OTP |
| POST | `/api/auth/partner/verify-otp` | Partner | Verify OTP, get JWT + partner |
| POST | `/api/auth/super-admin/signin` | Dashboard | send login email |
| POST | `/api/auth/super-admin/verify` | Dashboard | verify super-admin email |
| POST | `/api/auth/super-admin/logout` | Dashboard | logout super-admin |

User and partner OTP are stored separately in Redis (scopes `user` and `partner`) so the same mobile can have both.
