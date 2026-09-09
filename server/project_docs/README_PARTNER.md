# Partner API – Delivery App (Delivery Boy)

APIs for **delivery boy (partner)**. Base path: **`/api/partner`**.

**Authentication:** All endpoints require **JWT** in header:

```
Authorization: Bearer <access_token>
```

Token is obtained from **`POST /api/auth/verify-otp`**.

---

## Endpoints

### 1. Get profile

**`GET /api/partner/profile`**

Returns the logged-in partner’s profile.

**Response (200)**

```json
{
  "id": "uuid",
  "mobile_number": "9876543210",
  "full_name": "John Doe",
  "profile_photo": "https://...",
  "vehicle_type": "Bike",
  "vehicle_number": "MH01AB1234",
  "aadhaar_number": "123456789012",
  "aadhaar_image_url": null,
  "aadhaar_pdf_url": null,
  "pan_card_url": null,
  "license_number": null,
  "account_number": "1234567890",
  "ifsc_code": "HDFC0001234",
  "bank_name": "HDFC Bank",
  "status": "pending",
  "is_active": true,
  "is_online": false,
  "created_at": "2025-01-01T00:00:00.000Z",
  "last_login": "2025-01-01T12:00:00.000Z"
}
```

**Errors**

- `401` – Missing or invalid JWT.

---

### 2. Update profile

**`POST /api/partner/profile`**

Updates full name and/or profile photo URL.

**Request body**

```json
{
  "full_name": "John Doe",
  "profile_photo": "https://example.com/photo.jpg"
}
```

- Both fields optional; send only what you want to update.

**Response (200)** – Same shape as GET profile.

---

### 3. Upload profile photo

**`POST /api/partner/upload-photo`**

**Content-Type:** `multipart/form-data`

**Form field**

- `photo` – Image file (JPEG, PNG, WebP, GIF). Max **5 MB**.

Uploads to S3 and updates `profile_photo` in DB.

**Response (200)**

```json
{
  "profile_photo": "https://bucket.s3.region.amazonaws.com/partners/{id}/profile/..."
}
```

**Errors**

- `400` – No file, or field name not `photo`, or file type/size invalid.
- `400` – S3 not configured (missing AWS env vars).

---

### 4. Update vehicle

**`POST /api/partner/vehicle`**

**Request body**

```json
{
    "vehicle_type":"bike",
    "vehicle_number":"123bde64jdi4idbx",
    "vehicle_body_type":"open",
    "vehicle_brand_name":"tvs",
    "vehicle_registration_number":"MH01AB129325",
    "manufacture_in":"17-03-2026",
    "vehicle_fuel_type":"petrol",
    "vehicle_height":"",
    "vehicle_weight":""
}
```

- `vehicle_type`, `vehicle_number`, `vehicle_body_type`, `vehicle_brand_name`, `manufacture_in` – **Required.**
- `license_number`, `vehicle_weight`, `vehicle_height` – Optional.

**Response (201)** – Same shape as GET profile.

### 5. Get vehicle

**`GET /api/partner/vehicle`**

**Response (201)** – Same shape as GET profile.
{
    "success": true,
    "data": {
        "vehicleBodyType": "open",
        "vehicleBrandName": "tvs",
        "vehicleDocument": "https://res.cloudinary.com/dldae5bc7/image/upload/v1773665456/partners/Vehicle_Document/36b3a51b-dae6-4f53-be80-353de97ade85.jpg",
        "vehicleFuelType": "petrol",
        "vehicleNumber": "123bde64jdi4idbx",
        "vehiclePhoto": "https://res.cloudinary.com/dldae5bc7/image/upload/v1773661643/partners/Vehicle_Photo/36b3a51b-dae6-4f53-be80-353de97ade85.jpg",
        "vehicleRegistratinNumber": "MH01AB129325",
        "vehicleType": "bike"
    }
}
---

### 6. Update bank

**`POST /api/partner/bank`**

**Request body**

```json
{
  "account_number": "458972361245",
  "ifsc_code": "HDFC0001234",
  "bank_name": "HDFC Bank",
  "account_holder_name": "Sanket Pravin Inamdar"
}
```

- All four fields required.

**Response (200)** – Same shape as GET profile.

---

### 7. Upload Aadhaar image

**`POST /api/partner/upload-aadhaar-image`**

**Content-Type:** `multipart/form-data`  
**Form field:** `file` – Image (JPEG, PNG, WebP) or PDF. **Max 2 MB.**

**Response (200)**

```json
{
  "url": "https://bucket.s3.region.amazonaws.com/...",
  "type": "aadhaar_image"
}
```

---

### 8. Upload Aadhaar PDF

**`POST /api/partner/upload-aadhaar-pdf`**

**Content-Type:** `multipart/form-data`  
**Form field:** `file` – PDF or image. **Max 2 MB.**

**Response (200)** – `{ "url": "...", "type": "aadhaar_pdf" }`.

---

### 9. Upload PAN card

**`POST /api/partner/upload-pan-card`**

**Content-Type:** `multipart/form-data`  
**Form field:** `file` – Image (JPEG, PNG, WebP) or PDF. **Max 2 MB.**

**Response (200)** – `{ "url": "...", "type": "pan_card" }`.

---


### 10. Add personal Details

**`POST /api/partner/personal-details`**

**Request body**

```json
{
    "fullName":"spi",
    "email":"spi@gmail.com",
    "city":"pune",
    "address":"pune nibm"
}

**Response (201)**

```json
{
  "url": "https://bucket.s3.region.amazonaws.com/...",
  "type": "aadhaar_image"
}

```
### 11. Upload vehicle document

**`POST /api/partner/upload-vehicle-document`**

**Content-Type:** `multipart/form-data`  
**Form field:** `file` – Image (JPEG, PNG, WebP) or PDF. **Max 2 MB.**

**Response (200)** – `{ "url": "...", "type": "vehicle_document" }`.

### 12.  Upload vehicle Photo

**`POST /api/partner/upload-vehicle-photo`**

**Content-Type:** `multipart/form-data`  
**Form field:** `file` – Image (JPEG, PNG, WebP) or PDF. **Max 2 MB.**

**Response (200)** – `{ "url": "...", "type": "vehicle_photo" }`.



### 13.  Toggle Partner Is online or Offile

**`POST /api/partner/toggle/status`**

**Request body**

```json
{
    "IsOnline":true   // true or false
}

**Response (201)**

```json
{
    "success": true,
    "data": {
        "isOnline": true
    }
}

**`POST /api/partner/update/profile`**

**Request body**

```json
{
  "email":"sanketinamdar72@gmail.com",
  "mobile_number":"9325511352"
}

**Response (201)**

```json
{
  "success": true,
  "data": {
    "email": "sanketinamdar72@gmail.com",
    "mobileNumber": "9325511352",
    "address": "pune"
  },
  "message": "partner details updated..."
}
```

## Summary

| Method | Endpoint                    | Description           |
|--------|-----------------------------|------------------------|
| GET    | `/api/partner/profile`      | Get partner profile   |
| POST   | `/api/partner/profile`      | Update name/photo URL |
| POST   | `/api/partner/upload-photo` | Upload profile photo (5 MB) |
| POST   | `/api/partner/vehicle`      | Update vehicle (Aadhaar number required) |
| POST   | `/api/partner/bank`         | Update bank details   |
| POST   | `/api/partner/upload-aadhaar-image` | Aadhaar image (2 MB) |
| POST   | `/api/partner/upload-aadhaar-pdf`   | Aadhaar PDF (2 MB)   |
| POST   | `/api/partner/upload-pan-card`      | PAN card image/PDF (2 MB) |
| POST   | `/api/partner/personal-details`      | Add partner personal details |
| POST   | `/api/partner/upload-vehicle-document`      | upload partner vehicle document(papers) |
| POST   | `/api/partner/upload-vehicle-photo`      | upload partner vehicle photo |
| POST   | `/api/partner/toggle/status`      | update status of partner is online or not |
| POST   | `/api/partner/update/profile`      | update personal details(email && mobile number) |

All require **`Authorization: Bearer <access_token>`**.
