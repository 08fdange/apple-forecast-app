import React, { useState } from 'react';
import AddressAutocompleteInput from './AddressAutocompleteInput';
import ForecastDisplay from './ForecastDisplay';
import useForecast from '../hooks/useForecast';

const ForecastForm = () => {
  const [zipCode, setZipCode] = useState('');
  const { fetchForecast, forecastData, isCached, error } = useForecast();

  const handlePlaceSelected = (place) => {
    const postalCodeComponent = place.address_components.find(component => component.types.includes("postal_code"));
    const postalCode = postalCodeComponent ? postalCodeComponent.long_name : '';
    setZipCode(postalCode);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    if (zipCode) {
      fetchForecast(zipCode);
    }
  };

  return (
    <div className="max-w-md mx-auto mt-10">
      <h3 className="font-bold text-3xl mb-2">Weather</h3>
      <form onSubmit={handleSubmit} className="flex flex-col gap-4">
        <AddressAutocompleteInput onPlaceSelected={handlePlaceSelected} />
        <button
          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          type="submit"
        >
          Get Forecast
        </button>
      </form>

      {forecastData && (
        <ForecastDisplay
          forecastData={forecastData} 
          isCached={isCached} 
        />
        )
      }

      {error && <p className="text-red-500">{error}</p>}
    </div>
  );
};

export default ForecastForm;

