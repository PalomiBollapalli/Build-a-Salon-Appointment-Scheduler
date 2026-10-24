SELECT 'CREATE DATABASE salon OWNER freecodecamp'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'salon')\gexec

\c salon

CREATE TABLE IF NOT EXISTS customers (
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES customers(customer_id),
  service_id INT NOT NULL REFERENCES services(service_id),
  time VARCHAR(50) NOT NULL
);

INSERT INTO services (name)
SELECT 'cut'
WHERE NOT EXISTS (SELECT 1 FROM services WHERE name = 'cut');

INSERT INTO services (name)
SELECT 'color'
WHERE NOT EXISTS (SELECT 1 FROM services WHERE name = 'color');

INSERT INTO services (name)
SELECT 'perm'
WHERE NOT EXISTS (SELECT 1 FROM services WHERE name = 'perm');

INSERT INTO services (name)
SELECT 'style'
WHERE NOT EXISTS (SELECT 1 FROM services WHERE name = 'style');

INSERT INTO services (name)
SELECT 'trim'
WHERE NOT EXISTS (SELECT 1 FROM services WHERE name = 'trim');
