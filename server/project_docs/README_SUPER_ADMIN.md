# Super Admin API – Super Admin App

APIs for **Super Admin** (platform-wide). Base path: **`/api/super-admin`**.

**Authentication:** All endpoints (except `GET /`) require header:

```
X-Super-Admin-API-Key: <your-super-admin-api-key>
```

Set `SUPER_ADMIN_API_KEY` in backend `.env`. Same partner data as Admin (same DB); when admin approves a partner, that data is visible in both Admin and Super Admin.

---

## Endpoints

### 1. API info

**`GET /api/super-admin`**

**Response (200)**

```json
{
  "app": "super-admin",
  "message": "Super Admin API"
}
```

---

### 2. Partner counts (total, pending, approved, rejected)

**`GET /api/super-admin/partners/counts`**

**For:** Super Admin App – show “kitne total, kitne pending, kitne approved, kitne rejected”.

**Response (200)**

```json
{
  "total": 100,
  "pending": 30,
  "approved": 60,
  "rejected": 10
}
```

**Errors**

- `401` – Missing or invalid `X-Super-Admin-API-Key`.

---

### 3. List partners

**`GET /api/super-admin/partners`**

**Query parameters**

| Param  | Type   | Default | Description    |
|--------|--------|---------|----------------|
| `page` | number | 1       | Page number    |
| `limit`| number | 20      | Items per page |

**Response (200)** – Same shape as Admin: `{ items, total, page, limit, total_pages }`.

---

### 4. Update partner status

**`PATCH /api/super-admin/partner/status`**

**Request body**

```json
{
  "partner_id": "uuid-of-partner",
  "status": "approved"
}
```

- `status` – One of: **`pending`**, **`approved`**, **`rejected`**.

**Response (200)** – `{ id, status }`.


### 5. Get partner document

**`POST /api/super-admin/partner/documents`**

**Request body**

```json
{
  "partner_id": "uuid-of-partner",
}
```

**Response (200)**.

{
  "success": true,
  "data": {
    "vehiclePhoto": "http://documentURL",
    "vehicleDocument": "http://documentURL",
    "aadhaarImageUrl": "http://documentURL",
    "aadhaarPdfUrl": "http://documentURL",
    "panCardUrl": "http://documentURL"
  }
}


### 6. Get partner document verification Status ( pending | rejected | verified )

**`POST /api/super-admin/partner/documents/status`**

**Request body**

```json
{
  "partner_id": "uuid-of-partner",
}
```

**Response (200)**.

{
  "success": true,
  "data": {
    "verifiedDocuments": {
      "id": "36b3a51b-dae6-4f53-be80-353de97ade86",
      "aadhaar": "verified",                         // verified | rejected | pending
      "panCard": "pending",                          // verified | rejected | pending
      "Licence": "pending",                          // verified | rejected | pending
      "Bank": "pending",                             // verified | rejected | pending
      "vehicleDocument": "pending",                  // verified | rejected | pending
      "partnerId": "36b3a51b-dae6-4f53-be80-353de97ade85"
    }
  }
}

### 7. Set partner document verification Status ( pending | rejected | verified ) and Partner status ( rejected | approved )

**`PATCH /api/super-admin/partner/documents/status`**

**Request body**

```json
{
  "partner_id": "uuid-of-partner",
}
```

**Response (200)**.

{
 	    "aadhaar": "verified",
      "panCard": "verified",
      "licence": "verified",
      "bank": "pending",
      "vehicleDocument": "pending",
      "partner_id": "bfe1cc7c-1f89-4479-8058-5d01467a6ee9",
  	  "status":"rejected"
}

**`POST /api/super-admin/partner/toggle/isactive`**

**Request body**

```json
{
  "partner_id": "uuid-of-partner",
   "isActive":true
}
```

**Response (200)**.

{
  "success": true,
  "data": {
    "fullName": "pranav",
    "isActive": true
  }
}

**`GET /api/super-admin/partner/status/count`**

**Request body**

```json
cookie => token required
```

**Response (200)**.

{
    "success": true,
    "data": {
        "totaldrivers": 2,
        "newdrivers": 0,
        "online_drivers": 1,
        "offline_drivers": 1,
        "blocked_drivers": 1
    }
}

**`GET /api/super-admin/partners/all`**

**Response (200)**.

{
  "success": true,
  "data": [
    {
      "id": "82a9517a-17a3-4a85-a952-6a4eec2a174f",
      "profilePhoto": "https://res.cloudinary.com/dldae5bc7/image/upload/v1774871412/partners/profile_photo/82a9517a-17a3-4a85-a952-6a4eec2a174f.jpg",
      "fullName": "pranav",
      "mobileNumber": "9307923973",
      "vehicleBrandName": "Tata",
      "vehicleRegistrationNumber": "MH12HJ4356",
      "address": "kondhwa"
    }
  ]
}
**Errors**

- `401` – Invalid super admin API key.
- `404` – Partner not found.

---

## Summary

| Method | Endpoint                         | Description                              |
|--------|-----------------------------------|------------------------------------------|
| GET    | `/api/super-admin`                | API info                                 |
| GET    | `/api/super-admin/partners/counts`| Counts: total, pending, approved, rejected |
| GET    | `/api/super-admin/partners`       | List partners (paginated)                |
| PATCH  | `/api/super-admin/partner/status` | Update partner status                    |
| POST | `/api/super-admin/partner/documents/status`  | Partner document ( Verification status ) | 
| PATCH | `/api/super-admin/partner/documents/status`  | Partner document ( Set Verification status ) | 
| GET | `/api/super-admin/partner/status/count`  | getting ( total,rejected,appoved etc ) | 
| GET | `/api/super-admin/partners/all` | getting all partners | 
| POST | `/api/super-admin/partner/toggle/isactive`  | block or unblock partner | 

All except `GET /` require **`X-Super-Admin-API-Key`** header.

See **API_REFERENCE.md** for “kon sa API kiske liye” (who uses which API) and flow (document submit → admin approve → data in both sections).
