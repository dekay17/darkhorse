alter table hunt_photo add column depends_on_photo bigint;

ALTER TABLE hunt_photo ADD CONSTRAINT hunt_photo_depenency_fk
    FOREIGN KEY (depends_on_photo)
    REFERENCES photo (photo_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;