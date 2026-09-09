# API Reference – Kon sa API kiske liye (Who uses which API)

All APIs are on one backend. Below: **For** = which app/person uses this API.

---

## Flow: Document submit → Admin approve → Data in Admin & Super Admin

1. **Delivery partner** completes profile (profile, vehicle, bank, documents) via **Partner APIs** (`/api/partner/*`).
2. Partner’s record is stored in `delivery_partners` with `status: "pending"`.
3. **Admin** sees the request in **Admin** section and approves/rejects via **Admin APIs** (`/api/admin/*`).
4. When admin approves, `status` becomes `"approved"` in the same table. That data is **visible in both Admin and Super Admin** (same database). No separate copy – both use the same `delivery_partners` table.
5. **Counts** (total, pending, approved, rejected) are available in both Admin and Super Admin so you can show “kitne approve hai, kitne pending hai, kitne total hai”.

---

## Counts (Total / Pending / Approved / Rejected)

| For            | Endpoint                         | Description |
|----------------|----------------------------------|-------------|
| **Admin**      | `GET /api/admin/partners/counts` | `{ total, pending, approved, rejected }` |
| **Super Admin** | `GET /api/super-admin/partners/counts` | Same counts (same data) |

Use these to show: **Total**, **Pending**, **Approved**, **Rejected** in Admin and Super Admin UIs.

---

## Full API list – Kis ke liye (Who uses which)

### Auth – Dash (E-commerce user)

| Method | Endpoint | For | Description |
|--------|----------|-----|-------------|
| POST | `/api/auth/check-user` | **Dash** (Customer app) | Check if mobile already has a user (login screen routing) |
| POST | `/api/auth/send-otp` | **Dash** (Customer app) | Send / resend OTP to mobile |
| POST | `/api/auth/verify-otp` | **Dash** (Customer app) | Verify OTP, get JWT + profileCompleted + user |

### Auth – Delivery Partner (Delivery boy)

| Method | Endpoint | For | Description |
|--------|----------|-----|-------------|
| POST | `/api/auth/partner/send-otp` | **Partner** (Delivery app) | Send OTP to mobile |
| POST | `/api/auth/partner/verify-otp` | **Partner** (Delivery app) | Verify OTP, get JWT + partner |

---

### User – Dash (E-commerce customer)

For now, only the **Create account** API is needed for the Dash app. Profile fetch and address update APIs exist in backend but are not used yet.

| Method | Endpoint | For | Description |
|--------|----------|-----|-------------|
| POST | `/api/user/create-account` | **Dash** | Create basic profile (full_name, email/phone text, using_for) – no address |
| POST | `/api/user/add-gstin` | **Dash** | Adding GstIn (gstin) – require jwt 

**Auth:** JWT (`Authorization: Bearer <token>` from `/api/auth/verify-otp`).

---

### Partner – Delivery App (Delivery boy)

| Method | Endpoint | For | Description |
|--------|----------|-----|-------------|
| GET | `/api/partner/profile` | **Partner** | Get my profile |
| POST | `/api/partner/profile` | **Partner** | Update name/photo |
| POST | `/api/partner/upload-photo` | **Partner** | Upload profile photo |
| POST | `/api/partner/vehicle` | **Partner** | Update vehicle + Aadhaar |
| GET | `/api/partner/vehicle` | **Partner** | getting vehicle details |
| POST | `/api/partner/bank` | **Partner** | Update bank details |
| POST | `/api/partner/upload-aadhaar-image` | **Partner** | Upload Aadhaar image |
| POST | `/api/partner/upload-aadhaar-pdf` | **Partner** | Upload Aadhaar PDF |
| POST | `/api/partner/upload-pan-card` | **Partner** | Upload PAN card |
| POST | `/api/partner/personal-details` | **Partner** | add Personal details |
| POST | `/api/partner/upload-vehicle-document` | **Partner** | add vehicle document(vehicle papers) |
| POST | `/api/partner/upload-vehicle-photo` | **Partner** | add vehicle photo |
| POST | `/api/partner/toggle/status` | **Partner** | status toggle for partner is online or offline |
| POST | `/api/partner/update/profile` | **Partner** | change personal details(email && mobile number) |

**Auth:** JWT (`Authorization: Bearer <token>`).

---

### Admin – Admin App

| Method | Endpoint | For | Description |
|--------|----------|-----|-------------|
| GET | `/api/admin/partners/counts` | **Admin** | Total, pending, approved, rejected |
| GET | `/api/admin/partners` | **Admin** | List partners (paginated) |
| PATCH | `/api/admin/partner/status` | **Admin** | Approve/reject partner |

**Auth:** `X-Admin-API-Key` header.

---

### Super Admin – Super Admin App

| Method | Endpoint | For | Description |
|--------|----------|-----|-------------|
| GET | `/api/super-admin` | **Super Admin** | API info |
| GET | `/api/super-admin/partners/counts` | **Super Admin** | Total, pending, approved, rejected |
| GET | `/api/super-admin/partners` | **Super Admin** | List partners (paginated) |
| PATCH | `/api/super-admin/partner/status` | **Super Admin** | Approve/reject partner |
| POST | `/api/super-admin/partner/documents` | **Super Admin** | List of All Partner document ( All URL ) |
| POST | `/api/super-admin/partner/documents/status` | **Super Admin** | Partner document ( Verification status ) | 
| PATCH | `/api/super-admin/partner/documents/status` | **Super Admin** | Partner document ( Set Verification status ) | 
| GET | `/api/super-admin/partner/status/count` | **Super Admin** | Partner all status ( partner active | rejected | total ) | 
| GET | `/api/super-admin/partners/all` | **Super Admin** | getting all partners | 
| POST | `/api/super-admin/partner/toggle/isactive` | **Super Admin** | block or unblock partner | 

<!-- **Auth:** `X-Super-Admin-API-Key` header.   -->
**Auth:** `cookie && role` header.  
Same partner data as Admin (one DB); when admin approves, data is visible here too.

---

## Summary by app

| App | Base path | Auth | Counts endpoint |
|-----|-----------|------|-----------------|
| **Dash** (Customer) | `/api/auth`, `/api/user` | JWT | – |
| **Partner** (Delivery) | `/api/auth/partner`, `/api/partner` | JWT | – |
| **Admin** | `/api/admin` | X-Admin-API-Key | `GET /api/admin/partners/counts` |
| **Super Admin** | `/api/super-admin` | X-Super-Admin-API-Key | `GET /api/super-admin/partners/counts` |

Detailed request/response: see README_AUTH.md, README_USER.md, README_PARTNER.md, README_ADMIN.md, README_SUPER_ADMIN.md.
