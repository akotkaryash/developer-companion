# Contracts

Source-of-truth wire contracts for the platform. These are language-agnostic and
are what DEV-301 (Epic 3) generates typed clients from — nobody hand-writes a
matching DTO in Java/Python/TypeScript from scratch; it comes from here.

| Path | Defines | Issue |
| :--- | :--- | :--- |
| `rest/core-api.yaml` | Public REST API (Extension/Angular ↔ Gateway) | DEV-201 |
| `internal/` *(coming)* | Service-to-service (M2M) contracts | DEV-202 |
| `events/` *(coming)* | Kafka topic schemas (AsyncAPI) | DEV-203 |

Database schema (DEV-204) lives with the owning service instead
(`services/core-gamification/src/main/resources/db/migration`) since it's
managed via Flyway migrations, not a shared wire format — though the AI agent
service reads it directly for `pgvector` search, so its shape is documented in
an ADR once DEV-204 lands.
