# Admin API – Admin App

APIs for **Admin App**. Base path: **`/api/admin`**.

**Authentication:** All endpoints require header:

```
X-Admin-API-Key: <your-admin-api-key>
```

Set `ADMIN_API_KEY` in backend `.env`; use the same value in this header. No JWT.

---

## Endpoints

### 1. Partner counts (total, pending, approved, rejected)

**`GET /api/admin/partners/counts`**

**For:** Admin App – use this to show “kitne total, kitne pending, kitne approved, kitne rejected”.

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

- `401` – Missing or invalid `X-Admin-API-Key`.

---

### 2. List partners (delivery boys)

**`GET /api/admin/partners`**

Returns paginated list of delivery partners.

**Query parameters**

| Param  | Type   | Default | Description      |
|--------|--------|---------|------------------|
| `page` | number | 1       | Page number      |
| `limit`| number | 20      | Items per page   |

**Example**

```
GET /api/admin/partners?page=1&limit=20
```

**Response (200)**

```json
{
  "items": [
    {
      "id": "uuid",
      "mobile_number": "9876543210",
      "full_name": "John Doe",
      "status": "pending",
      "is_active": true,
      "is_online": false,
      "created_at": "2025-01-01T00:00:00.000Z"
    }
  ],
  "total": 100,
  "page": 1,
  "limit": 20,
  "total_pages": 5
}
```

**Errors**

- `401` – Missing or invalid `X-Admin-API-Key`.

---

### 3. Update partner status

**`PATCH /api/admin/partner/status`**

Updates a delivery boy’s approval status.

**Request body**

```json
{
  "partner_id": "uuid-of-partner",
  "status": "approved"
}
```

- `partner_id` – UUID of the delivery partner.
- `status` – One of: **`pending`**, **`approved`**, **`rejected`**.

**Response (200)**

```json
{
  "id": "uuid",
  "status": "approved"
}
```

**Errors**

- `401` – Invalid admin API key.
- `404` – Partner not found.

---

## Summary

| Method | Endpoint                     | Description                              |
|--------|------------------------------|------------------------------------------|
| GET    | `/api/admin/partners/counts` | Counts: total, pending, approved, rejected |
| GET    | `/api/admin/partners`       | List partners (paginated)                |
| PATCH  | `/api/admin/partner/status` | Update partner status (approve/reject)   |

All require **`X-Admin-API-Key`** header.
