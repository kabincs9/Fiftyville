-- Keep a log of any SQL queries you execute as you solve the mystery.

-- first to gather information as date and place  took place on July 28, 2024 and that it took place on Humphrey Street.
SELECT description FROM crime_scene_reports WHERE year = 2024 AND month = 7 AND day = 28 AND street = 'Humphrey Street';

-- we can read it happened at 10;15...
--three people who saw
SELECT transcript FROM interviews WHERE year = 2024 AND month = 7 AND day = 28 AND transcript LIKE '%courthouse%'; -- now not humphery street

SELECT transcript FROM interviews WHERE year = 2024 AND month = 7 AND day = 28;
-- some clues like withdraw money plaining
-- to identity withdraw -- three click to copy
SELECT account_number FROM atm_transactions WHERE year = 2024 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw';
-- to find which accounts withdrew money near the crime scene on the crime day

SELECT people.name, people.id, people.phone_number FROM people JOIN bank_accounts ON people.id = bank_accounts.person_id WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2024 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw');
-- to find suspect number and name
SELECT flights.id, flights.hour, flights.minute, airports.city AS destination_city FROM flights
JOIN airports ON flights.destination_airport_id = airports.id WHERE flights.origin_airport_id
 = (SELECT id FROM airports WHERE city = 'Fiftyville') AND flights.year = 2024 AND flights.month = 7 AND flights.day = 29 ORDER BY flights.hour, flights.minute LIMIT 1;
-- fastest flight to leave and there is passport number
SELECT people.name, people.phone_number FROM passengers JOIN people ON passengers.passport_number = people.passport_number
 WHERE passengers.flight_id = (SELECT id FROM flights WHERE origin_airport_id = (SELECT id FROM airports WHERE city = 'Fiftyville') AND year = 2024 AND month = 7 AND day = 29 ORDER BY hour, minute LIMIT 1);
-- people between 10;15 to 10;25 in bakery ... and people

SELECT people.name, people.license_plate FROM bakery_security_logs JOIN people ON bakery_security_logs.license_plate = people.license_plate WHERE bakery_security_logs.year = 2024 AND bakery_security_logs.month = 7
 AND bakery_security_logs.day = 28 AND bakery_security_logs.hour = 10 AND bakery_security_logs.minute BETWEEN 15 AND 25 AND bakery_security_logs.activity = 'exit';
-- to find short phone calls

SELECT caller, receiver, duration FROM phone_calls WHERE year = 2024 AND month = 7 AND day = 28 AND duration < 60;

-- find people in this call
SELECT people.name, people.phone_number FROM people WHERE phone_number IN
(SELECT caller FROM phone_calls WHERE year = 2024 AND month = 7 AND day = 28 AND duration < 60 UNION SELECT receiver FROM phone_calls WHERE year = 2024 AND month = 7 AND day = 28 AND duration < 60);

--So, the crime happened on July 28, 2024 at 10:15 on Humphrey Street.  learned the thief used the ATM on Leggett Street to withdraw money the same day. Checking who withdrew Bruce showed up.
-- the earliest flight leaving Fiftyville on July 29 and found Bruce was a passenger. The bakery security logs showed Bruce’s car left between 10:15 and 10:25, right after the crime...
-- Finally.. Bruce made short phone calls that day, and one was to Robin, who seems to be the accomplice.... So, Bruce is the thief and Robin helped him.
