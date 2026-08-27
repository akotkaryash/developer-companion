# Database Schema and Vector Storage

## 1. Domain Responsibility
This is the C4 Level 5 (Database & Contracts) deliverable for DEV-204. It maps the PostgreSQL relational schema owned by Core Gamification, and the `pgvector` embedding storage shared with the AI Agent service. Source of truth is the Flyway migrations in
`services/core-gamification/src/main/resources/db/migration/` — this document explains and diagrams them, it doesn't duplicate them.

## 2. Entity-Relationship Diagram

```mermaid
erDiagram
    USERS ||--|| USER_STATS : has
    USERS ||--o{ SUBMISSIONS : makes
    USERS ||--o{ USER_BADGES : earns
    BADGES ||--o{ USER_BADGES : "awarded as"
    SUBMISSIONS }o--|| PROBLEM_CATALOG : "solves (by problem_id, not FK-enforced)"

    USERS {
        uuid id PK "= Keycloak JWT sub claim"
        varchar username UK
        varchar email UK
        boolean banned
        timestamptz banned_at
        timestamptz created_at
    }
    USER_STATS {
        uuid user_id PK_FK
        bigint total_xp
        int current_streak
        int longest_streak
        date last_submission_date
        int version "optimistic lock"
        timestamptz updated_at
    }
    SUBMISSIONS {
        uuid id PK
        uuid user_id FK
        enum platform
        varchar problem_id
        enum difficulty
        varchar language
        text code_snapshot
        enum status
        varchar source_submission_id "platform's own ID"
        int xp_awarded
        timestamptz submitted_at
    }
    BADGES {
        varchar id PK
        varchar name
        varchar description
        varchar icon_url
    }
    USER_BADGES {
        uuid user_id PK_FK
        varchar badge_id PK_FK
        timestamptz unlocked_at
    }
    PROBLEM_CATALOG {
        varchar problem_id PK
        enum platform
        varchar title
        varchar primary_topic
        enum difficulty
        vector_384 embedding
    }
```

## 3. Design Decisions

*   **`users` mirrors Keycloak's `sub` claim as its primary key**, rather than a separate mapping table. Keycloak remains the sole source of truth for authentication; this table only holds domain profile data auth doesn't have (username, ban state). See `02-system-topology-and-hld.md`.
*   **`user_stats` is split from `users`**, not merged. Every accepted submission mutates this row (XP, streak) — it's the highest-contention write in the whole schema, which is exactly why it carries the `version` column for JPA's `@OptimisticLockingFailureException` retry behavior specified in `03-core-gamification-engine.md`. Keeping it separate means that contention is scoped to only the columns that actually need it, instead of locking the whole (rarely-changed) profile row too.
*   **Idempotency is enforced at the database level**, not just application code: `UNIQUE (user_id, platform, source_submission_id)` on `submissions` means a duplicate replay physically cannot be inserted twice, regardless of any race in the service layer.
*   **Badges are normalized** (`badges` + `user_badges` join table) instead of a JSON/array column on `users`, so the badge catalog is independently queryable and "who has badge X" is a cheap query, not a full scan.
*   **`problem_catalog` is the pgvector table**, shared by two AI features from `08-ai-integration-strategy.md`: DSA Coach RAG (finding similar problems for hint context) and the Knowledge Decay predictor (finding topically-similar problems once a topic — joined from `submissions.problem_id` — has gone stale). It's deliberately *not* per-user embeddings for v1: recency ("hasn't solved a Graph problem in 14 days") is computed from plain `submissions` timestamps, not vector math; the vector search only answers "what's similar," keeping this simpler than a personalized-embedding model. A per-user preference embedding is a plausible future addition once basic recommendations are working, not a v1 requirement.
*   **Embedding dimension is 384** (`vector(384)`), matching `sentence-transformers/all-MiniLM-L6-v2` — a small open-source model that runs on CPU. This is a direct consequence of the project's zero-cost constraint (`07-devops-and-deployment.md`): no GPU, no paid embedding API (OpenAI/Cohere) required.
*   **HNSW index with cosine distance** on the embedding column: approximate-nearest-neighbor search so similarity queries stay fast as the catalog grows, instead of a full table scan computing distance against every row. Cosine is the standard choice for sentence-embedding similarity, where direction (not magnitude) carries the meaning.

## 4. Known Follow-ups
*   `application.yaml`'s `hibernate.ddl-auto` was `update`; changed to `validate` alongside this schema landing, so Hibernate checks JPA entities against what Flyway created instead of silently auto-altering tables Flyway already owns (Epic 6 will add the actual entity classes).
*   `infrastructure/docker/docker-compose.yml`'s `postgres` service was retargeted from `postgres:15-alpine` to `pgvector/pgvector:pg15` (same Postgres, extension pre-installed) — plain Postgres can't run `CREATE EXTENSION vector`.
