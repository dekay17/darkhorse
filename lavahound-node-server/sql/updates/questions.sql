-- add questions for hunt photos

alter table hunt_photo add column question_id bigint;

CREATE TABLE question (
    question_id bigint NOT NULL,
    question varchar NOT NULL,
    answer varchar NOT NULL,
	points bigint NOT NULL,
    created_date timestamp without time zone DEFAULT now() NOT NULL,
    updated_date timestamp without time zone NOT NULL,
    CONSTRAINT question_pk PRIMARY KEY (question_id)
);

ALTER TABLE hunt_photo ADD CONSTRAINT hunt_photo_question_fk
    FOREIGN KEY (question_id)
    REFERENCES question (question_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

CREATE SEQUENCE question_id_seq  START WITH 1000;