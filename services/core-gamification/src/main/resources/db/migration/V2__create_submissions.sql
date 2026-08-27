CREATE TYPE platform_enum AS ENUM ('LEETCODE', 'GFG');
CREATE TYPE difficulty_enum AS ENUM ('EASY', 'MEDIUM', 'HARD');
CREATE TYPE submission_status_enum AS ENUM ('ACCEPTED');

CREATE TABLE submissions (
    id                  UUID PRIMARY KEY,
    user_id             UUID NOT NULL REFERENCES users(id),
    platform            platform_enum NOT NULL,
    problem_id          VARCHAR(255) NOT NULL,
    difficulty          difficulty_enum NOT NULL,
    language            VARCHAR(50) NOT NULL,
    code_snapshot       TEXT,
    status              submission_status_enum NOT NULL,
    -- The source platform's own submission ID - required for idempotency,
    -- see contracts/rest/core-api.yaml's SubmissionRequest.submissionId.
    source_submission_id VARCHAR(255) NOT NULL,
    xp_awarded          INT NOT NULL,
    submitted_at        TIMESTAMPTZ NOT NULL,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- The idempotency rule itself, enforced at the DB level (not just in
    -- application code): a duplicate replay of the same submission can't
    -- be inserted twice, no matter what races in the service layer.
    CONSTRAINT uq_submission_identity UNIQUE (user_id, platform, source_submission_id)
);

-- Dashboard/profile queries: "this user's recent submissions" ordered by time.
CREATE INDEX idx_submissions_user_submitted_at ON submissions (user_id, submitted_at DESC);

-- Knowledge-decay queries: "when did this user last touch problem X /
-- this topic" - joined against problem_catalog (see V4).
CREATE INDEX idx_submissions_user_problem ON submissions (user_id, problem_id);
