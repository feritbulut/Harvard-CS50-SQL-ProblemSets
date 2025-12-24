CREATE TABLE Users(
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "passsword" INTEGER,
    PRIMARY KEY ("id")
);

CREATE TABLE Schools(
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "type" TEXT,
    "location" TEXT,
    "year" INTEGER,
    PRIMARY KEY("id")
);

CREATE TABLE Companies(
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "industry" TEXT,
    "location" TEXT,
    PRIMARY KEY("id")
);

CREATE TABLE ConnectionswithPeople(
    "user_id1" INTEGER NOT NULL,
    "user_id2" INTEGER NOT NULL,
    PRIMARY KEY ("user_id1", "user_id2"),

    FOREIGN KEY ("user_id1") REFERENCES Users("user_id"),
    FOREIGN KEY ("user_id2") REFERENCES Users("user_id"),

    CHECK (user_id1 < user_id2)
);

CREATE TABLE ConnectionswithSchools(
    "id" INTEGER,
    "user_id" INTEGER,
    "school_id" INTEGER,
    "start_date" NUMERIC,
    "end_date" NUMERIC,
    "degree" TEXT,
    FOREIGN KEY("user_id") REFERENCES "Users"("id"),
    FOREIGN KEY("school_id") REFERENCES "Schools"("id")
);

CREATE TABLE ConnectionswithCompanies(
    "id" INTEGER,
    "user_id" INTEGER,
    "company_id" INTEGER,
    "start_date" NUMERIC,
    "end_date" NUMERIC,
    FOREIGN KEY("user_id") REFERENCES "Users"("id"),
    FOREIGN KEY("company_id") REFERENCES "Companies"("id")
);
