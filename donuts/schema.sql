-- INGREDIENTS
CREATE TABLE ingredients (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    price_per_unit REAL NOT NULL
);

-- DONUTS
CREATE TABLE donuts (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    gluten_free BOOLEAN NOT NULL,
    price REAL NOT NULL
);

-- DONUT INGREDIENTS
CREATE TABLE donut_ingredients (
    donut_id INTEGER NOT NULL,
    ingredient_id INTEGER NOT NULL,

    FOREIGN KEY (donut_id) REFERENCES donuts(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id),

    PRIMARY KEY (donut_id, ingredient_id)
);

-- CUSTOMERS
CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL
);

-- ORDERS
CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- ORDER ITEMs
CREATE TABLE order_items (
    order_id INTEGER NOT NULL,
    donut_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,

    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (donut_id) REFERENCES donuts(id),

    PRIMARY KEY (order_id, donut_id)
);
