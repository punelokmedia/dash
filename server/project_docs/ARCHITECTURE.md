# Backend – MVC & Clean Architecture

This backend follows **MVC** (Model–View–Controller) with **Clean Architecture** separation.

---

## 1. MVC flow

| Layer       | Responsibility        | Example (Partner)              |
|------------|------------------------|---------------------------------|
| **Controller** | HTTP in/out, validation (via DTOs), delegates to service | `partner.controller.ts` |
| **Service**    | Business logic, orchestration, no HTTP | `partner.service.ts`     |
| **Repository** | Data access only (DB), no business rules | `partner.repository.ts` |
| **Model/Entity** | Data shape (Prisma schema) | `delivery_partners` table |

**Request flow:**  
`Request` → **Controller** (parse, validate DTO) → **Service** (business logic) → **Repository** (DB) → **Service** (map to response) → **Controller** (return) → `Response`.

---

## 2. Clean Architecture (dependency direction)

- **Controller** depends on **Service** (not the other way).
- **Service** depends on **Repository** (abstraction over data).
- **Repository** depends on **Prisma** (infrastructure).
- **DTOs** define input contracts; **entities** (Prisma models) define persistence.

No business logic in controllers or repositories; orchestration and rules live in services.

---

## 3. Per-module layout (e.g. Partner)

```
partner/
├── partner.controller.ts   # HTTP only → calls service
├── partner.service.ts      # Business logic → calls repository (+ S3 if needed)
├── partner.module.ts       # Wiring
├── repository/
│   └── partner.repository.ts   # Prisma only
├── dto/
│   ├── profile.dto.ts
│   ├── vehicle.dto.ts
│   └── bank.dto.ts
└── s3-upload.service.ts    # Infrastructure (used by service)
```

---

## 4. Cross-cutting

- **common/filters** – Global exception handling (consistent error JSON).
- **common/interceptors** – Response shape (`success`, `data`).
- **config** – Env-based configuration, Prisma, Redis.

---

## 5. Summary

- **MVC:** Controller → Service → Repository; clear separation of HTTP, logic, and data.
- **Clean:** Dependencies point inward (controller → service → repository); no logic in controller/repository.
- **Partner module** follows this flow and is optimized for it.
