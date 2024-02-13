# Apple Forecast App

## Check it out here!:

[Apple Forecast App](https://apple-forecast-app-b586018d8099.herokuapp.com/)

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

  # Weather API Credentials
  WEATHER_API_KEY: "WHATEVER_YOUR_WEATHER_API_KEY_IS"

test:
  WEATHER_API_KEY: WEATHER_API_TEST_KEY
  DB_USERNAME: test_user
  DB_PASSWORD: test_password
```

There are two API keys you'll need to obtain on your own:

For the Weather API key, go [here](https://www.weatherapi.com/) and sign up. You'll set this in the application.yml file.

You'll also need a Google Maps API key, check out the instructions [here.](https://developers.google.com/maps/documentation/embed/get-api-key). Once you obtain that you'll set it in your terminal under the project directory like this: `export REACT_APP_GOOGLE_MAPS_API_KEY='WhateverYourGoogleMapsAPIKeyIs`.

Once you have your `config/application.yml` file set up, you should be set to get started. 

## Installation

1. run `bundle install`
2. run `yarn build`
3. run `rails s`


## Usage
Open your browser and go to `localhost:3000/`.

Now all you need to do is type in the desired address, click on it and then hit the "Get Forecast" button.

## How to Run Tests

All you need to give the tests a spin is run `rspec` in your console.

## Caching Strategy

There are two caching strategies that take place in the ForecastUpdateService:

1. In-Memory Caching: Upon receiving a request for forecast data for a specific zip code, the service first attempts to retrieve the forecast from Redis cache using the key forecast:<zip_code>. If the data is found in the cache (meaning it was fetched within the last 30 minutes, based on the EXPIRATION_IN_SECONDS constant), it is immediately returned to the user, indicating that the response is cached.
2. Database Fallback: If the cache does not contain data for the requested zip code, the service then checks the PostgreSQL database for any existing records. If found and not expired, the service updates the Redis cache with this data as a fallback mechanism, ensuring that subsequent requests will be served from the cache.

If the forecast data is neither in the cache nor the database or if it is expired, the service makes an external API call to fetch fresh data, processes it, and stores it both in the database and Redis cache. Cached data expires after 30 minutes. This means after 30 minutes, the next request will trigger a new fetch sequence, ensuring that users receive up-to-date forecast information. This caching strategy reduces the number of external API calls, thereby enhancing performance and ensuring faster response times for the end-users.

## Design Patterns

There are several design patterns I implemented in this application. Here are some:

- MVC Pattern, although not used traditionally in my application, I do have Models that handle business logic and database interactions, Controllers that process incoming requests, interact with models, and render JSON, and the React presenting the JSON data (Views).
- Microservice Architecture via RESTful API endpoint w/versioning that lends to scalability
- Service Object Pattern, using service objects to handle business logic, ultimately keeping that separation of concerns
- Singleton Pattern, via a single instance of our Redis client used throughout the application

## Future Feature Additions

- Improved error handling from the backend to the frontend

- ~~Expanding the API endpoint to receive an additional parameter for the number days of forecasts was something I considered and could implement easily in the future~~ (This feature was added 2/12/24)

- Adding a switch for displaying temperatures in fahrenheit or celcius

- Loading state for when the API is fetching data

- Adding a user model, authentication and the ability for those users to save their forecast locations for quick access to updated forecasts 

- Adding additional UI updates

## Scalability Considerations

- API Rate Limiting: Implementing rate limiting could prevent abuse of the WeatherService API, so the application won't be overwhelmed by too many requests in a short period.

- Horizontal Scaling for Redis: Redis can become a bottleneck as the number of concurrent users grows. Redis clusters could be used to distribute the cache data across multiple nodes.

- Fault Tolerance: Retry mechanisms and fallback strategies could be implemented in the WeatherService class to handle failures when calling the external API.

- Monitoring and Logging: In a production-level application robust monitoring and logging system would be needed to keep track of my application's performance and errors. This data would be invaluable for diagnosing issues and planning for future scalability needs.

- CI/CD Improvements: Additional pipeline improvements like requiring Rspec tests to be passing on the pipeline before automatically deploying to Heroku

- Frontend testing: Unit tests for more complex components and Cypress integration testing.

## Decomposition

**Ruby on Rails (Backend)**

Models: `Forecast` model stores weather forecasts associated with zip codes. Handles data persistence and provides methods to query and manipulate forecast records.

Controllers: `ForecastsController` manages incoming requests for weather data, interacting with the `ForecastUpdateService` to retrieve or update data as needed.

Services:

- `ForecastUpdateService` orchestrates the logic of checking the cache, fetching data from the database, or calling the `WeatherService` based on cache expiration.

- `WeatherService` responsible for making external API calls to fetch weather data, parsing the response, and handling errors.

Concerns: `WeatherDataProcessor` module is specifically designed to transform and standardize the structure of the weather data fetched from WeatherAPI, into a format that's more compact and convenient.

**React (Frontend)**

- `AddressAutocompleteInput` is responsible for rendering our autocomplete address input with Google Maps API integration
- `TodaysForecast` is our component that displays the data for the day-of's forecast and the location (city) of the forecast data displayed
- `ExtendedForecast` is in charge of mapping through our multiple days (10 to be specific) of forecasts and rendering elements for each one
- `ForecastDisplay` simply displays our forecast components (TodaysForecast and ExtendedForecast)
- `ForecastForm` renders our form, holds state for our forecast and displays the forecast data using our ForecastDisplay. Given more time, I would likely break this out to separate concerns. The form would be just the form and the state would be lifted to a main/page component, responsible for rendering the main (and currently only) feature of our application
- `IPhoneWrapper` is a component that is responsible for wrapping our application inside a iPhone simulator-looking image and displaying night/day backgrounds
- `useForecast` is a hook built to handle the axios API call to our forecast-fetching endpoint
