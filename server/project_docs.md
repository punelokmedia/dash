# Backend – Project Documentation

Single NestJS backend serving four app boundaries: **Admin**, **User**, **Delivery (partner = delivery boy)**, and **Super Admin**.

---

## 1. Architecture overview

```
Single NestJS Backend
│
├── Dash (customer)   → /api/auth (OTP), /api/user/* (profile, address)
├── Delivery (partner)→ /api/auth/partner (OTP), /api/partner/* (profile, vehicle, bank, documents)
├── Admin             → /api/admin/* (partners, counts, approve/reject)
└── Super Admin       → /api/super-admin/* (same partner data + counts)
```

- **Partner** = delivery boy. **User** = Dash e-commerce customer (separate `users` table).
- One codebase, one server; routes are split by prefix per app.

---

## 2. Tech stack

| Layer        | Technology                    |
|-------------|--------------------------------|
| Framework   | NestJS (TypeScript)           |
| Database    | PostgreSQL                    |
| ORM         | Prisma                        |
| Cache       | Redis (OTP storage, optional in dev) |
| Auth        | JWT (access token)            |
| OTP         | 6-digit, 5 min expiry; dev = console, prod = MSG91 |
| File upload | AWS S3 (profile photo)        |

---

## 3. Folder structure

```
backend/
├── prisma/
│   └── schema.prisma          # delivery_partners + users tables
├── src/
│   ├── modules/
│   │   ├── auth/              # Common auth (OTP, JWT) → /api/auth
│   │   ├── user/              # User App → /api/user/*
│   │   │   ├── user.controller.ts
│   │   │   ├── user.service.ts
│   │   │   └── user.module.ts
│   │   ├── partner/           # Delivery App (delivery boy) → /api/partner/*
│   │   │   ├── partner.controller.ts
│   │   │   ├── partner.service.ts
│   │   │   ├── partner.module.ts
│   │   │   ├── s3-upload.service.ts
│   │   │   ├── dto/
│   │   │   └── repository/
│   │   ├── admin/             # Admin App → /api/admin/*
│   │   │   ├── admin.controller.ts
│   │   │   ├── admin.service.ts
│   │   │   ├── admin.module.ts
│   │   │   ├── dto/, repository/, guards/
│   │   └── super-admin/       # Super Admin → /api/super-admin/*
│   │       ├── super-admin.controller.ts
│   │       ├── super-admin.service.ts
│   │       └── super-admin.module.ts
│   ├── common/                # Filters, interceptors, utils, middleware
│   ├── config/                # App config, Redis, Prisma
│   ├── main.ts
│   └── API_STRUCTURE.md       # Route map and module layout
├── .env / .env.example
├── project_docs.md             # This file
└── package.json
```

---

## 4. API route map

| Prefix                 | Module           | Purpose                          |
|------------------------|------------------|----------------------------------|
| `/api/auth`            | AuthModule       | Dash user OTP (send/verify)      |
| `/api/auth/partner`    | AuthModule       | Partner OTP (send/verify)        |
| `/api/user/*`         | UserModule       | Dash – profile & address         |
| `/api/partner/*`      | PartnerModule    | Delivery App (partner)          |
| `/api/admin/*`        | AdminModule      | Admin – partners, counts, status |
| `/api/super-admin/*`  | SuperAdminModule | Super Admin – same partner data  |

Full list and “kon sa API kiske liye”: **project_docs/API_REFERENCE.md**.

---

## 5. API reference (summary)

### 5.1 Auth – Dash user (`/api/auth`)

| Method | Endpoint              | Notes |
|--------|------------------------|-------|
| POST   | `/api/auth/send-otp`   | `{ "mobile_number" }`; dev_otp in dev |
| POST   | `/api/auth/verify-otp` | Returns `access_token`, `profileCompleted`, `user` |

### 5.2 Auth – Partner (`/api/auth/partner`)

| Method | Endpoint                        | Notes |
|--------|----------------------------------|-------|
| POST   | `/api/auth/partner/send-otp`    | `{ "mobile_number" }` |
| POST   | `/api/auth/partner/verify-otp` | Returns `access_token`, `partner` |

### 5.3 User (Dash) – JWT required

| Method | Endpoint              | Notes |
|--------|------------------------|-------|
| GET    | `/api/user/profile`   | Profile + delivery address |
| PUT    | `/api/user/profile`   | Update name, email, address_line1, city, state, pincode, etc. |

### 5.4 Partner (delivery boy) – JWT required

| Method | Endpoint                    | Notes |
|--------|-----------------------------|-------|
| GET    | `/api/partner/profile`     | — |
| POST   | `/api/partner/profile`     | full_name, profile_photo |
| POST   | `/api/partner/upload-photo` | Form `photo`; S3 |
| POST   | `/api/partner/vehicle`     | vehicle_type, vehicle_number, aadhaar_number, license_number |
| POST   | `/api/partner/bank`        | account_number, ifsc_code, bank_name |
| POST   | `/api/partner/upload-aadhaar-image`, `upload-aadhaar-pdf`, `upload-pan-card` | Form `file`; 2 MB max |

### 5.5 Admin – header `X-Admin-API-Key`

| Method | Endpoint                     | Notes |
|--------|------------------------------|-------|
| GET    | `/api/admin/partners/counts` | total, pending, approved, rejected |
| GET    | `/api/admin/partners`        | page, limit |
| PATCH  | `/api/admin/partner/status`  | partner_id, status |

### 5.6 Super Admin – header `X-Super-Admin-API-Key`

Same as Admin: `partners/counts`, `partners`, `partner/status`.

---

## 6. Environment variables

Copy `.env.example` to `.env` and set:

| Variable               | Purpose |
|------------------------|--------|
| `PORT`                 | Server port (default 3000) |
| `NODE_ENV`             | `development` \| `production` |
| `DATABASE_URL`         | PostgreSQL connection string |
| `JWT_SECRET`           | JWT signing secret |
| `JWT_EXPIRES_IN`       | e.g. `7d` |
| `REDIS_HOST`, `REDIS_PORT`, `REDIS_PASSWORD` | Redis (OTP); optional in dev (in-memory fallback) |
| `MSG91_AUTH_KEY`       | Production OTP SMS (msg91.com) |
| `MSG91_SENDER_ID`, `MSG91_OTP_EXPIRY_MINUTES` | Optional MSG91 settings |
| `ADMIN_API_KEY`        | Required for `/api/admin/*` (`X-Admin-API-Key` header) |
| `SUPER_ADMIN_API_KEY`  | Required for `/api/super-admin/*` (`X-Super-Admin-API-Key` header) |
| `AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `S3_BUCKET_NAME` | Partner profile/document uploads (S3); optional (clear error if missing) |

---

## 7. Database (Prisma)

- **users** – Dash customers: id, mobile_number, full_name, profile_photo, email, address_line1, address_line2, city, state, pincode, landmark, role, is_active, created_at, last_login.
- **delivery_partners** – Partners: id, mobile_number, full_name, profile_photo, vehicle_type, vehicle_number, aadhaar_number, aadhaar_image_url, aadhaar_pdf_url, pan_card_url, license_number, account_number, ifsc_code, bank_name, status, is_active, is_online, created_at, last_login.
- After schema changes: `npx prisma generate` and `npx prisma migrate dev --name <name>`.
- Commands: `npx prisma generate`, `npx prisma migrate dev`, `npx prisma studio`.

---

## 8. Run & scripts

```bash
npm install
npx prisma generate
npx prisma migrate dev --name init   # first time
npm run start:dev                    # dev server
npm run build && npm run start:prod # production
```

---

## 9. Glossary & docs index

| Term          | Meaning |
|---------------|---------|
| **Dash**      | E-commerce customer app; auth `/api/auth`, profile `/api/user/*` |
| **Partner**   | Delivery boy; auth `/api/auth/partner`, APIs `/api/partner/*` |
| **Admin / Super Admin** | Same partner data; different API keys |

**Detailed API docs:** See folder **project_docs/** – README_AUTH.md, README_USER.md, README_PARTNER.md, README_ADMIN.md, README_SUPER_ADMIN.md, API_REFERENCE.md.

---

*Last updated to match the current backend structure and APIs.*
