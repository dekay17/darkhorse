CREATE TABLE hunt_points (
    hunt_id bigint NOT NULL,
    account_id bigint NOT NULL,
    points bigint NOT NULL,
    completed boolean NOT NULL,
    created_date timestamp without time zone DEFAULT now() NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    CONSTRAINT hunt_points_pk PRIMARY KEY (hunt_id, account_id)
);

CREATE TRIGGER set_updated_date BEFORE INSERT OR UPDATE ON hunt_points FOR EACH ROW EXECUTE PROCEDURE set_updated_date();
