-- users.id mirrors the Keycloak JWT `sub` claim directly (no separate
-- mapping table): Keycloak stays the source of truth for auth, this table
-- only holds the app-domain profile data auth doesn't have.
CREATE TABLE users (
    id          UUID PRIMARY KEY,
    username    VARCHAR(50) NOT NULL UNIQUE,
    email       VARCHAR(255) NOT NULL UNIQUE,
    banned      BOOLEAN NOT NULL DEFAULT FALSE,
    banned_at   TIMESTAMPTZ,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Split from `users` deliberately: this row is mutated on every single
-- submission (XP/streak update), so it's the hot write-contention point
-- that needs optimistic locking (`version`). Keeping it separate from the
-- rarely-changed profile row, and from the append-only `submissions`
-- history table, keeps that contention scoped to only the columns that
-- actually need it.
CREATE TABLE user_stats (
    user_id             UUID PRIMARY KEY REFERENCES users(id),
    total_xp            BIGINT NOT NULL DEFAULT 0,
    current_streak      INT NOT NULL DEFAULT 0,
    longest_streak      INT NOT NULL DEFAULT 0,
    -- UTC date of the last accepted submission, per the strict UTC-day
    -- streak rule in docs/architecture/03-core-gamification-engine.md.
    last_submission_date DATE,
    version             INT NOT NULL DEFAULT 0,
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Leaderboard fallback query path (Redis is the primary read path per
-- docs/architecture/05-data-engineering-pipeline.md; this backs the Spark
-- job that populates it, and works even if the cache is cold).
CREATE INDEX idx_user_stats_total_xp ON user_stats (total_xp DESC);
