#  Pet Tracking Application

##  Project Overview

This project is a Ruby on Rails API that tracks pets (cats and dogs) using data from different types of trackers. It allows external systems to send pet tracking data through a RESTful API, stores that information, and provides endpoints to query which pets are currently outside the power-saving zone.

The app includes validation rules (e.g., only cats can have lost trackers), supports grouped counts by pet and tracker type, and is designed to use an in-memory database with the option to switch to a persistent one later.

## Project Structure

* db/migrate : Folder contains migration file.
	* db/migrate/20250710193956_create_pets.rb
* app/models : Folder contains Pet model file
    * app/models/pet.rb : Model related validation.
* app/controllers : Folder contains controller file.
	* app/controllers/pets_controller.rb
* config/initializers/string_to_boolean.rb : This file contains casting method.
* config/locales/en.yml : This file is the language file.
* test/controllers : Folder contains tests for controllers
	* test/controllers/pets_controller_test.rb
* test/models : Folder contains test for models
	* test/models/pet_test.rb 

## Installation

Please use This guide will walk you through installing the Ruby programming language and the Rails framework on your operating system.

### Install Ruby on macOS

You'll need macOS Catalina 10.15 or newer to follow these instructions.

For macOS, you'll need Xcode Command Line Tools and Homebrew to install dependencies needed to compile Ruby.

Open Terminal and run the following commands:

```
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
brew install openssl@3 libyaml gmp rust
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate)"' >> ~/.zshrc
source ~/.zshrc
mise use -g ruby@3
```
Once Ruby is installed, you can verify it works by running:
```
$ ruby --version
ruby 3.4.4
```

### Installing Rails

Run the following command to install the Rails and make it available in your terminal.
```
$ gem install rails
```
To verify that Rails is installed correctly,
```
$ rails --version
Rails 8.0.0
```
For other operating systems please refer following link.
https://guides.rubyonrails.org/install_ruby_on_rails.html

### Setup

1.  Clone the repository.
```
https://github.com/kaushik0911/fantastic-fiesta.git
```
2. Navigate to the project directory.
```
cd fantastic-fiesta
```
3. Install gems
```
bundle install
```
4. Run migrations - This will create the database in SQLite and run the migrations.
```
rails db:migrate
```
5. Start the server.
```
rails s
```
6. To run tests.
```
rails t
```

## Example cURL

1. Get all the pets.
```
curl --location 'http://127.0.0.1:3000/pets'
``` 
2. Query by power saving zone.
```
curl --location 'http://127.0.0.1:3000/pets?in_zone=true'
```
3. Number of pets currently outside the power saving zone
grouped by pet type and tracker type.
```
curl --location 'http://127.0.0.1:3000/pets/outside_zone_count'
```
4. Create new pet.
```
curl --location 'http://127.0.0.1:3000/pets' \
--header 'Content-Type: application/json' \
--data '{
    "pet": {
        "pet_type": "cat",
        "tracker_type": "small",
        "owner_id": 1,
        "in_zone": false,
        "lost_tracker": false
    }
}'
```
##  Improvements

1. Error handling
2. API version controls (eg. api/v1/pets)
3. API json.jbuilder
4. Config solid caching properly for dev using sqlite
