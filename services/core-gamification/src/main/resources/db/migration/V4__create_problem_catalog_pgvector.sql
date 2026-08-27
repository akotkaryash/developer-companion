CREATE EXTENSION IF NOT EXISTS vector;

-- One row per known problem (LeetCode/GfG), holding a semantic embedding
-- of its topic/description. Shared by two AI features
-- (docs/architecture/08-ai-integration-strategy.md):
--   1. DSA Coach RAG: find similar problems/context for a hint.
--   2. Knowledge Decay: find topically-similar problems to recommend once
--      a topic (joined from `submissions`, see V2) has gone stale.
--
-- Embedding dimension is 384, matching sentence-transformers'
-- all-MiniLM-L6-v2 - a small open-source model that runs on CPU with no
-- GPU and no paid embedding API, which matters for the project's
-- zero-cost/free-tier constraint (docs/architecture/07-devops-and-deployment.md).
CREATE TABLE problem_catalog (
    problem_id      VARCHAR(255) PRIMARY KEY,
    platform        platform_enum NOT NULL,
    title           VARCHAR(255) NOT NULL,
    primary_topic   VARCHAR(100) NOT NULL,
    difficulty      difficulty_enum NOT NULL,
    embedding       vector(384) NOT NULL
);

-- HNSW: approximate-nearest-neighbor index so "find problems similar to
-- this one" stays fast as the catalog grows, instead of a full scan
-- computing cosine distance against every row. Cosine distance is the
-- standard choice for sentence-embedding similarity (magnitude doesn't
-- carry meaning here, direction does).
CREATE INDEX idx_problem_catalog_embedding ON problem_catalog
    USING hnsw (embedding vector_cosine_ops);

CREATE INDEX idx_problem_catalog_topic ON problem_catalog (primary_topic);
