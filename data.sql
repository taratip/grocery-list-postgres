-- insert grocery items
INSERT INTO groceries (name) VALUES ('bread');
INSERT INTO groceries (name) VALUES ('eggs');
INSERT INTO groceries (name) VALUES ('coffee');
INSERT INTO groceries (name) VALUES ('peanut butter')

insert comments
INSERT INTO comments (body, grocery_id)
SELECT 'make sure it is fresh', id
FROM groceries
WHERE name = 'eggs';

INSERT INTO comments (body, grocery_id)
SELECT 'buy two loaves', id
FROM groceries
WHERE name = 'bread';

INSERT INTO comments (body, grocery_id)
SELECT 'one multigrain bread and one white bread', id
FROM groceries
WHERE name = 'bread';

INSERT INTO comments (body, grocery_id)
SELECT 'buy starbucks brand', id
FROM groceries
WHERE name = 'coffee';
