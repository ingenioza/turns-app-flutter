# API Contract — Client Mirror (Flutter)

> This is a **mirror** of the authoritative contract in `turns-laravel/docs/api-contract.md`.  
> Do **not** invent fields here. When the server updates, sync DTOs and tests accordingly.

## Endpoints Used
- POST `/api/v1/auth/firebase/exchange` → obtain API token from Firebase ID token
- `/api/v1/groups` CRUD
- `/api/v1/groups/{id}/participants` CRUD
- POST `/api/v1/groups/{id}/turns/next` → run algorithm (random/round_robin/weighted)
- GET `/api/v1/groups/{id}/turns/history` → show history
- POST `/api/v1/devices` → register FCM/APNs token

## DTO Notes
Keep DTOs in sync with server shapes. Update unit/integration tests if fields change.
