CREATE TABLE account (
    account_id bigint NOT NULL,
    email varchar NOT NULL,
    name varchar NOT NULL,
    password varchar NOT NULL,
    remember_me_token varchar NOT NULL,
    created_date timestamp without time zone DEFAULT now() NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    CONSTRAINT account_pk PRIMARY KEY (account_id)
);

CREATE TABLE place (
    place_id bigint NOT NULL,
    image_file_name varchar NOT NULL, -- character varying
    name varchar NOT NULL, -- character varying
    description varchar NOT NULL, -- character varying
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    created_date timestamp without time zone DEFAULT now() NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    CONSTRAINT place_pk PRIMARY KEY (place_id)
);

CREATE TABLE hunt (
    hunt_id bigint NOT NULL,
    place_id bigint NOT NULL,
    image_file_name varchar NOT NULL, -- character varying
    name varchar NOT NULL, -- character varying
    description varchar NOT NULL, -- character varying   
    points bigint NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,    
    created_date timestamp without time zone DEFAULT now() NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    CONSTRAINT hunt_pk PRIMARY KEY (hunt_id)
);

CREATE TABLE photo (
    photo_id bigint NOT NULL,
    account_id bigint NOT NULL,
    image_file_name varchar NOT NULL,
    title varchar NOT NULL,
    description varchar NOT NULL,
    points bigint NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,    
    created_date timestamp without time zone DEFAULT now() NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    CONSTRAINT photo_pk PRIMARY KEY (photo_id)
);

CREATE TABLE hunt_photo (
    photo_id bigint NOT NULL,
    hunt_id bigint NOT NULL,
    created_date timestamp without time zone DEFAULT now() NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    CONSTRAINT hunt_photo_pk PRIMARY KEY (photo_id, hunt_id)
);

CREATE TABLE photo_found (
    photo_id bigint NOT NULL,
    account_id bigint NOT NULL,
    created_date timestamp without time zone DEFAULT now() NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    CONSTRAINT photo_found_pk PRIMARY KEY (photo_id, account_id)
);

ALTER TABLE photo ADD CONSTRAINT account_fk
    FOREIGN KEY (account_id)
    REFERENCES account (account_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE hunt ADD CONSTRAINT place_fk
    FOREIGN KEY (place_id)
    REFERENCES place (place_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE hunt_photo ADD CONSTRAINT hunt_photo_photo_fk
    FOREIGN KEY (photo_id)
    REFERENCES photo (photo_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE hunt_photo ADD CONSTRAINT hunt_photo_hunt_fk
    FOREIGN KEY (hunt_id)
    REFERENCES hunt (hunt_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

CREATE SEQUENCE account_id_seq  START WITH 1000;
CREATE SEQUENCE photo_id_seq START WITH 1000;
CREATE SEQUENCE hunt_id_seq START WITH 1000;
CREATE SEQUENCE place_id_seq START WITH 1000;

-- Indexes --
CREATE UNIQUE INDEX account_email_address_idx ON account(email);

-- Functions --

CREATE OR REPLACE FUNCTION set_updated_date() RETURNS TRIGGER AS $$
BEGIN        
    NEW.updated_date := 'now';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers --

CREATE TRIGGER set_updated_date BEFORE INSERT OR UPDATE ON account FOR EACH ROW EXECUTE PROCEDURE set_updated_date();
CREATE TRIGGER set_updated_date BEFORE INSERT OR UPDATE ON photo FOR EACH ROW EXECUTE PROCEDURE set_updated_date();
CREATE TRIGGER set_updated_date BEFORE INSERT OR UPDATE ON place FOR EACH ROW EXECUTE PROCEDURE set_updated_date();
CREATE TRIGGER set_updated_date BEFORE INSERT OR UPDATE ON hunt FOR EACH ROW EXECUTE PROCEDURE set_updated_date();
CREATE TRIGGER set_updated_date BEFORE INSERT OR UPDATE ON hunt_photo FOR EACH ROW EXECUTE PROCEDURE set_updated_date();
CREATE TRIGGER set_updated_date BEFORE INSERT OR UPDATE ON photo_found FOR EACH ROW EXECUTE PROCEDURE set_updated_date();

-- Views --

-- CREATE OR REPLACE VIEW v_video
-- AS
-- SELECT v.*, va.name_prefix AS author_name_prefix, va.first_name AS author_first_name, va.last_name AS author_last_name, va.company_id,
-- va.name_suffix AS author_name_suffix
-- FROM video v, video_author va
-- WHERE v.video_author_id = va.video_author_id;