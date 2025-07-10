# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


curl --location 'http://127.0.0.1:3000/pets'

* Tracker type medium cannot have for cats

curl --location 'http://127.0.0.1:3000/pets' \
--header 'Content-Type: application/json' \
--data '{
    "pet": {
        "pet_type": "cat",
        "tracker_type": "medium",
        "owner_id": 2,
        "in_zone": true,
        "lost_tracker": false
    }
}'