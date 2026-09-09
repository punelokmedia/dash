# Single Backend – Four App Structure

```
Single NestJS Backend
│
├── Admin App       → /api/admin/*
├── User App        → /api/user/*
├── Delivery App    → /api/partner/*   (login: /api/auth)
└── Super Admin     → /api/super-admin/*
```

## Folder structure (flat per module)

```
src/
├── modules/
│   ├── auth/              ← common auth (OTP, JWT)
│   │
│   ├── user/              ← User App
│   │   ├── user.controller.ts
│   │   ├── user.service.ts
│   │   └── user.module.ts
│   │
│   ├── partner/           ← Delivery App (partner = delivery boy)
│   │   ├── partner.controller.ts
│   │   ├── partner.service.ts
│   │   ├── partner.module.ts
│   │   ├── s3-upload.service.ts
│   │   ├── dto/
│   │   └── repository/
│   │
│   ├── admin/             ← Admin App
│   │   ├── admin.controller.ts
│   │   ├── admin.service.ts
│   │   ├── admin.module.ts
│   │   ├── dto/
│   │   ├── repository/
│   │   └── guards/
│   │
│   └── super-admin/       ← Super Admin
│       ├── super-admin.controller.ts
│       ├── super-admin.service.ts
│       └── super-admin.module.ts
│
└── main.ts
```

## Route map

| Prefix               | Module          | Purpose                 |
|----------------------|-----------------|-------------------------|
| `/api/auth`          | AuthModule      | Delivery partner OTP    |
| `/api/partner/*`     | PartnerModule   | Delivery App (delivery boy) |
| `/api/admin/*`       | AdminModule     | Admin App               |
| `/api/user/*`        | UserModule      | User App                |
| `/api/super-admin/*` | SuperAdminModule| Super Admin             |

## Delivery App (partner = delivery boy)

- **Auth:** `POST /api/auth/send-otp`, `POST /api/auth/verify-otp`
- **Partner (delivery boy):** `GET|POST /api/partner/profile`, `POST /api/partner/vehicle`, `POST /api/partner/bank`, `POST /api/partner/upload-photo`
