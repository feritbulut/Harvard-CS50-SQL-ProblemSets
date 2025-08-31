
-- *** The Lost Letter ***

SELECT * FROM "adresses" WHERE "address" = '900 Somerville Avenue';

SELECT * FROM "addresses" WHERE "address" LIKE "2 Fin%";

SELECT * FROM "packages" WHERE from_address_id = (
    SELECT "id" FROM "addresses"
    WHERE "address" = '900 Somerville Avenue'
) AND to_address_id = (
    SELECT "id" FROM "addresses"
    WHERE "address" LIKE "2 Fin%"
);

SELECT * FROM "scans"
WHERE "package_id" = (
    SELECT "id" FROM "packages" WHERE from_address_id = (
    SELECT "id" FROM "addresses"
    WHERE "address" = '900 Somerville Avenue'
) AND to_address_id = (
    SELECT "id" FROM "addresses"
    WHERE "address" LIKE "2 Fin%"
)
);

-- *** The Devious Delivery ***

SELECT "type" FROM "addresses"
WHERE "id" = (SELECT "address_id" FROM "scans"
                WHERE "package_id" = (SELECT "id" FROM "packages"
                WHERE "from_address_id" IS NULL)
                AND "action" = 'Drop'
);

SELECT "contents" FROM "packages"
WHERE "from_address_id" IS NULL;

-- *** The Forgotten Gift ***

SELECT "contents" FROM "packages"
WHERE "from_address_id" = ( SELECT "id" FROM "addresses" WHERE "address" = '109 Tileston Street');

SELECT "name" FROM "drivers" WHERE "id" = (SELECT "driver_id" FROM "scans"
WHERE "address_id" = (SELECT "id" FROM "addresses"
WHERE "address" = '109 Tileston Street'));

select * from scans where package_id = (
    select "id" from packages where "from_address_id" = (select "id" from addresses where "address" = "109 Tileston Street")
);

select * from drivers where id = 17;
