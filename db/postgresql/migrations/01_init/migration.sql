-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- CreateTable
CREATE TABLE "user" (
    "user_id" UUID NOT NULL,
    "username" VARCHAR(255) NOT NULL,
    "password" VARCHAR(60) NOT NULL,
    "role" VARCHAR(50) NOT NULL,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6),
    "deleted_at" TIMESTAMPTZ(6),
    CONSTRAINT "user_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "session" (
    "session_id" UUID NOT NULL,
    "website_id" UUID NOT NULL,
    "hostname" VARCHAR(100),
    "browser" VARCHAR(20),
    "os" VARCHAR(20),
    "device" VARCHAR(20),
    "screen" VARCHAR(11),
    "language" VARCHAR(35),
    "country" CHAR(2),
    "subdivision1" VARCHAR(20),
    "subdivision2" VARCHAR(50),
    "city" VARCHAR(50),
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "session_pkey" PRIMARY KEY ("session_id")
);

-- CreateTable
CREATE TABLE "website" (
    "website_id" UUID NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "domain" VARCHAR(500),
    "share_id" VARCHAR(50),
    "reset_at" TIMESTAMPTZ(6),
    "user_id" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6),
    "deleted_at" TIMESTAMPTZ(6),
    CONSTRAINT "website_pkey" PRIMARY KEY ("website_id")
);

-- CreateTable
CREATE TABLE "website_event" (
    "event_id" UUID NOT NULL,
    "website_id" UUID NOT NULL,
    "session_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "url_path" VARCHAR(500) NOT NULL,
    "url_query" VARCHAR(500),
    "referrer_path" VARCHAR(500),
    "referrer_query" VARCHAR(500),
    "referrer_domain" VARCHAR(500),
    "page_title" VARCHAR(500),
    "event_type" INTEGER NOT NULL DEFAULT 1,
    "event_name" VARCHAR(50),
    CONSTRAINT "website_event_pkey" PRIMARY KEY ("event_id")
);

-- CreateTable
CREATE TABLE "event_data" (
    "event_id" UUID NOT NULL,
    "website_id" UUID NOT NULL,
    "website_event_id" UUID NOT NULL,
    "event_key" VARCHAR(500) NOT NULL,
    "event_string_value" VARCHAR(500),
    "event_numeric_value" DECIMAL(19,4),
    "event_date_value" TIMESTAMPTZ(6),
    "event_data_type" INTEGER NOT NULL,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "event_data_pkey" PRIMARY KEY ("event_id")
);

-- CreateTable
CREATE TABLE "team" (
    "team_id" UUID NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "access_code" VARCHAR(50),
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6),
    CONSTRAINT "team_pkey" PRIMARY KEY ("team_id")
);

-- CreateTable
CREATE TABLE "team_user" (
    "team_user_id" UUID NOT NULL,
    "team_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "role" VARCHAR(50) NOT NULL,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6),
    CONSTRAINT "team_user_pkey" PRIMARY KEY ("team_user_id")
);

-- CreateTable
CREATE TABLE "team_website" (
    "team_website_id" UUID NOT NULL,
    "team_id" UUID NOT NULL,
    "website_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "team_website_pkey" PRIMARY KEY ("team_website_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_user_id_key" ON "user"("user_id");
CREATE UNIQUE INDEX "user_username_key" ON "user"("username");
CREATE UNIQUE INDEX "session_session_id_key" ON "session"("session_id");
CREATE INDEX "session_created_at_idx" ON "session"("created_at");
CREATE INDEX "session_website_id_idx" ON "session"("website_id");
CREATE UNIQUE INDEX "website_website_id_key" ON "website"("website_id");
CREATE UNIQUE INDEX "website_share_id_key" ON "website"("share_id");
CREATE INDEX "website_user_id_idx" ON "website"("user_id");
CREATE INDEX "website_created_at_idx" ON "website"("created_at");
CREATE INDEX "website_share_id_idx" ON "website"("share_id");
CREATE INDEX "website_event_created_at_idx" ON "website_event"("created_at");
CREATE INDEX "website_event_session_id_idx" ON "website_event"("session_id");
CREATE INDEX "website_event_website_id_idx" ON "website_event"("website_id");
CREATE INDEX "website_event_website_id_created_at_idx" ON "website_event"("website_id", "created_at");
CREATE INDEX "website_event_website_id_session_id_created_at_idx" ON "website_event"("website_id", "session_id", "created_at");
CREATE INDEX "event_data_created_at_idx" ON "event_data"("created_at");
CREATE INDEX "event_data_website_id_idx" ON "event_data"("website_id");
CREATE INDEX "event_data_website_event_id_idx" ON "event_data"("website_event_id");
CREATE UNIQUE INDEX "team_team_id_key" ON "team"("team_id");
CREATE UNIQUE INDEX "team_access_code_key" ON "team"("access_code");
CREATE INDEX "team_access_code_idx" ON "team"("access_code");
CREATE UNIQUE INDEX "team_user_team_user_id_key" ON "team_user"("team_user_id");
CREATE INDEX "team_user_team_id_idx" ON "team_user"("team_id");
CREATE INDEX "team_user_user_id_idx" ON "team_user"("user_id");
CREATE UNIQUE INDEX "team_website_team_website_id_key" ON "team_website"("team_website_id");
CREATE INDEX "team_website_team_id_idx" ON "team_website"("team_id");
CREATE INDEX "team_website_website_id_idx" ON "team_website"("website_id");

-- AddSystemUser
INSERT INTO "user" (user_id, username, role, password) VALUES ('41e2b680-648e-4b09-bcd7-3e2b10c06264' , 'admin', 'admin', '$2b$10$BUli0c.muyCW1ErNJc3jL.vFRFtFJWrT8/GcR4A.sUdCznaXiqFXa');

--------------------------------------------------------------
--  RLS FIXES AND POLICIES  
--------------------------------------------------------------

-- Enable RLS on all public tables
ALTER TABLE "public"."user" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."session" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."website" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."website_event" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."event_data" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."team" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."team_user" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."team_website" ENABLE ROW LEVEL SECURITY;

-- Policies for "public.user"
-- Allows authenticated users to view and update only their own user record.
CREATE POLICY "Users can view their own profile"
  ON "public"."user"
  FOR SELECT
  USING (auth.uid() = "user_id");

CREATE POLICY "Users can update their own profile"
  ON "public"."user"
  FOR UPDATE
  USING (auth.uid() = "user_id");

-- Policies for "public.website"
-- Allows a user to manage (CRUD) their own websites.
CREATE POLICY "Users can manage their websites"
  ON "public"."website"
  FOR ALL -- Covers SELECT, INSERT, UPDATE, and DELETE
  USING (auth.uid() = "user_id")
  WITH CHECK (auth.uid() = "user_id"); -- The WITH CHECK clause is used for INSERT and UPDATE

-- Policies for "public.session"
-- Allows authenticated users to view sessions associated with their own websites.
CREATE POLICY "Users can view sessions on their websites"
  ON "public"."session"
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM "public"."website"
      WHERE "website"."website_id" = "session"."website_id"
      AND "website"."user_id" = auth.uid()
    )
  );

-- Policies for "public.website_event"
-- Allows a user to view events related to their websites.
CREATE POLICY "Users can view website events"
  ON "public"."website_event"
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM "public"."website"
      WHERE "website"."website_id" = "website_event"."website_id"
      AND "website"."user_id" = auth.uid()
    )
  );

-- Policies for "public.event_data"
-- Allows authenticated users to view event data if it's associated with a website they own.
CREATE POLICY "Users can view event data"
  ON "public"."event_data"
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM "public"."website"
      WHERE "website"."website_id" = "event_data"."website_id"
      AND "website"."user_id" = auth.uid()
    )
  );

-- Policies for "public.team"
-- Allows a team member to view their teams.
CREATE POLICY "Team members can view their teams"
  ON "public"."team"
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM "public"."team_user"
      WHERE "team_user"."team_id" = "team"."team_id"
      AND "team_user"."user_id" = auth.uid()
    )
  );

-- Policies for "public.team_user"
-- Allows a user to view their own team memberships.
CREATE POLICY "Users can view their team memberships"
  ON "public"."team_user"
  FOR SELECT
  USING (auth.uid() = "user_id");

-- Policies for "public.team_website"
-- Allows team members to view the websites associated with their teams.
CREATE POLICY "Team members can view their team's websites"
  ON "public"."team_website"
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1
      FROM "public"."team_user"
      WHERE "team_user"."team_id" = "team_website"."team_id"
      AND "team_user"."user_id" = auth.uid()
    )
  );







-- -- CreateExtension
-- CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- -- CreateTable
-- CREATE TABLE "user" (
--     "user_id" UUID NOT NULL,
--     "username" VARCHAR(255) NOT NULL,
--     "password" VARCHAR(60) NOT NULL,
--     "role" VARCHAR(50) NOT NULL,
--     "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
--     "updated_at" TIMESTAMPTZ(6),
--     "deleted_at" TIMESTAMPTZ(6),

--     CONSTRAINT "user_pkey" PRIMARY KEY ("user_id")
-- );

-- -- CreateTable
-- CREATE TABLE "session" (
--     "session_id" UUID NOT NULL,
--     "website_id" UUID NOT NULL,
--     "hostname" VARCHAR(100),
--     "browser" VARCHAR(20),
--     "os" VARCHAR(20),
--     "device" VARCHAR(20),
--     "screen" VARCHAR(11),
--     "language" VARCHAR(35),
--     "country" CHAR(2),
--     "subdivision1" VARCHAR(20),
--     "subdivision2" VARCHAR(50),
--     "city" VARCHAR(50),
--     "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

--     CONSTRAINT "session_pkey" PRIMARY KEY ("session_id")
-- );

-- -- CreateTable
-- CREATE TABLE "website" (
--     "website_id" UUID NOT NULL,
--     "name" VARCHAR(100) NOT NULL,
--     "domain" VARCHAR(500),
--     "share_id" VARCHAR(50),
--     "reset_at" TIMESTAMPTZ(6),
--     "user_id" UUID,
--     "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
--     "updated_at" TIMESTAMPTZ(6),
--     "deleted_at" TIMESTAMPTZ(6),

--     CONSTRAINT "website_pkey" PRIMARY KEY ("website_id")
-- );

-- -- CreateTable
-- CREATE TABLE "website_event" (
--     "event_id" UUID NOT NULL,
--     "website_id" UUID NOT NULL,
--     "session_id" UUID NOT NULL,
--     "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
--     "url_path" VARCHAR(500) NOT NULL,
--     "url_query" VARCHAR(500),
--     "referrer_path" VARCHAR(500),
--     "referrer_query" VARCHAR(500),
--     "referrer_domain" VARCHAR(500),
--     "page_title" VARCHAR(500),
--     "event_type" INTEGER NOT NULL DEFAULT 1,
--     "event_name" VARCHAR(50),

--     CONSTRAINT "website_event_pkey" PRIMARY KEY ("event_id")
-- );

-- -- CreateTable
-- CREATE TABLE "event_data" (
--     "event_id" UUID NOT NULL,
--     "website_id" UUID NOT NULL,
--     "website_event_id" UUID NOT NULL,
--     "event_key" VARCHAR(500) NOT NULL,
--     "event_string_value" VARCHAR(500),
--     "event_numeric_value" DECIMAL(19,4),
--     "event_date_value" TIMESTAMPTZ(6),
--     "event_data_type" INTEGER NOT NULL,
--     "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

--     CONSTRAINT "event_data_pkey" PRIMARY KEY ("event_id")
-- );

-- -- CreateTable
-- CREATE TABLE "team" (
--     "team_id" UUID NOT NULL,
--     "name" VARCHAR(50) NOT NULL,
--     "access_code" VARCHAR(50),
--     "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
--     "updated_at" TIMESTAMPTZ(6),

--     CONSTRAINT "team_pkey" PRIMARY KEY ("team_id")
-- );

-- -- CreateTable
-- CREATE TABLE "team_user" (
--     "team_user_id" UUID NOT NULL,
--     "team_id" UUID NOT NULL,
--     "user_id" UUID NOT NULL,
--     "role" VARCHAR(50) NOT NULL,
--     "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
--     "updated_at" TIMESTAMPTZ(6),

--     CONSTRAINT "team_user_pkey" PRIMARY KEY ("team_user_id")
-- );

-- -- CreateTable
-- CREATE TABLE "team_website" (
--     "team_website_id" UUID NOT NULL,
--     "team_id" UUID NOT NULL,
--     "website_id" UUID NOT NULL,
--     "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

--     CONSTRAINT "team_website_pkey" PRIMARY KEY ("team_website_id")
-- );

-- -- CreateIndex
-- CREATE UNIQUE INDEX "user_user_id_key" ON "user"("user_id");

-- -- CreateIndex
-- CREATE UNIQUE INDEX "user_username_key" ON "user"("username");

-- -- CreateIndex
-- CREATE UNIQUE INDEX "session_session_id_key" ON "session"("session_id");

-- -- CreateIndex
-- CREATE INDEX "session_created_at_idx" ON "session"("created_at");

-- -- CreateIndex
-- CREATE INDEX "session_website_id_idx" ON "session"("website_id");

-- -- CreateIndex
-- CREATE UNIQUE INDEX "website_website_id_key" ON "website"("website_id");

-- -- CreateIndex
-- CREATE UNIQUE INDEX "website_share_id_key" ON "website"("share_id");

-- -- CreateIndex
-- CREATE INDEX "website_user_id_idx" ON "website"("user_id");

-- -- CreateIndex
-- CREATE INDEX "website_created_at_idx" ON "website"("created_at");

-- -- CreateIndex
-- CREATE INDEX "website_share_id_idx" ON "website"("share_id");

-- -- CreateIndex
-- CREATE INDEX "website_event_created_at_idx" ON "website_event"("created_at");

-- -- CreateIndex
-- CREATE INDEX "website_event_session_id_idx" ON "website_event"("session_id");

-- -- CreateIndex
-- CREATE INDEX "website_event_website_id_idx" ON "website_event"("website_id");

-- -- CreateIndex
-- CREATE INDEX "website_event_website_id_created_at_idx" ON "website_event"("website_id", "created_at");

-- -- CreateIndex
-- CREATE INDEX "website_event_website_id_session_id_created_at_idx" ON "website_event"("website_id", "session_id", "created_at");

-- -- CreateIndex
-- CREATE INDEX "event_data_created_at_idx" ON "event_data"("created_at");

-- -- CreateIndex
-- CREATE INDEX "event_data_website_id_idx" ON "event_data"("website_id");

-- -- CreateIndex
-- CREATE INDEX "event_data_website_event_id_idx" ON "event_data"("website_event_id");

-- -- CreateIndex
-- CREATE UNIQUE INDEX "team_team_id_key" ON "team"("team_id");

-- -- CreateIndex
-- CREATE UNIQUE INDEX "team_access_code_key" ON "team"("access_code");

-- -- CreateIndex
-- CREATE INDEX "team_access_code_idx" ON "team"("access_code");

-- -- CreateIndex
-- CREATE UNIQUE INDEX "team_user_team_user_id_key" ON "team_user"("team_user_id");

-- -- CreateIndex
-- CREATE INDEX "team_user_team_id_idx" ON "team_user"("team_id");

-- -- CreateIndex
-- CREATE INDEX "team_user_user_id_idx" ON "team_user"("user_id");

-- -- CreateIndex
-- CREATE UNIQUE INDEX "team_website_team_website_id_key" ON "team_website"("team_website_id");

-- -- CreateIndex
-- CREATE INDEX "team_website_team_id_idx" ON "team_website"("team_id");

-- -- CreateIndex
-- CREATE INDEX "team_website_website_id_idx" ON "team_website"("website_id");

-- -- AddSystemUser
-- INSERT INTO "user" (user_id, username, role, password) VALUES ('41e2b680-648e-4b09-bcd7-3e2b10c06264' , 'admin', 'admin', '$2b$10$BUli0c.muyCW1ErNJc3jL.vFRFtFJWrT8/GcR4A.sUdCznaXiqFXa');