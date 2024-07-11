-- +goose Up
ALTER TABLE users
ADD COLUMN apikey VARCHAR(64) NOT NULL
DEFAULT encode(sha256(random()::text::bytea), 'hex');

ALTER TABLE users
ADD CONSTRAINT unique_apikey UNIQUE (apikey); 

-- +goose Down
ALTER TABLE users
  DELETE apikey;