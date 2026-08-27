-- Normalized rather than a JSON/array column on users: badges need their
-- own catalog (name/description/icon) independent of who's earned them,
-- and a join table lets us query "everyone who has badge X" cheaply too.
CREATE TABLE badges (
    id          VARCHAR(50) PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,
    icon_url    VARCHAR(255)
);

CREATE TABLE user_badges (
    user_id     UUID NOT NULL REFERENCES users(id),
    badge_id    VARCHAR(50) NOT NULL REFERENCES badges(id),
    unlocked_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, badge_id)
);
