# Apple Forecast App

## Check it out here!:

[Apple Forecast App] (https://apple-forecast-app-b586018d8099.herokuapp.com/)

## Description

The Apple Forecast App is a Ruby on Rails application that provides weather forecasting. Users can input an address, and the application retrieves and displays the forecast data for the input location, including the current temperature, high and low temperatures.

## Features

- Accepts an address as input through a React-based front end.
- Uses the Google Maps API for address autocomplete suggestions.
- Retrieves forecast data from Weather API.
- Caches forecast data by zip code for 30 minutes to optimize performance, via Redis with backup DB caching.
- Indicates whether the displayed forecast is served from cache (whether that be the Redis cache or from the db) or freshly fetched from the API.

## Tech Stack

- Ruby on Rails 7.1.3
- React.js
- Tailwind CSS for styling
- ESBuild for JavaScript and CSS bundling
- PostgreSQL as the database
- Redis for caching
- RSpec for backend testing
- Google Maps API integration
- Weather API integration
- Hosted on Heroku

## Prior Setup

If running it locally, you'll first need to create/setup an `application.yml` in the `config` directory. It should look like this:

```
development:
  # Database credentials
  DB_USERNAME: "postgres"
  DB_PASSWORD: "postgres"
  DB_DBNAME: "apple_forecast_app_development"

  # Google Maps API Key
  REACT_APP_GOOGLE_MAPS_API_KEY: "WHATEVER_YOUR_GOOGLE_MAPS_API_KEY_IS"

  # Weather API Credentials
  WEATHER_API_KEY: "WHATEVER_YOUR_WEATHER_API_KEY_IS"

test:
  WEATHER_API_KEY: WEATHER_API_TEST_KEY
  DB_USERNAME: test_user
  DB_PASSWORD: test_password
```

As you might have noticed, there are two API keys you'll need to obtain on your own.

For the Google Maps API key, check out the instructions [here.] (https://developers.google.com/maps/documentation/embed/get-api-key)

For a Weather API key, go [here] (https://www.weatherapi.com/) and sign up.

Once you have your `config/application.yml` file set up, you should be set to get started. 

## Installation

1. run `bundle install`
2. run `yarn build`
3. run `rails s`


## Usage
Open your browser and go to `localhost:3000/`.

Now all you need to do is type in the desired address, click on it and then hit the "Get Forecast" button.

## How to run tests

All you need to give the tests a spin is run `rspec` in your console.