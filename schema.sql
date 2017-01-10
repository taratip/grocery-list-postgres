-- If you want to run this schema repeatedly you'll need to drop
-- the table before re-creating it. Note that you'll lose any
-- data if you drop and add a table:
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS groceries;

-- Define your schema here:

CREATE TABLE groceries (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  body VARCHAR(255) NOT NULL,
  grocery_id INT REFERENCES groceries(id)
)
