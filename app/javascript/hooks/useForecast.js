import { useState } from 'react';
import axios from 'axios';

const useForecast = () => {
  const [forecastData, setForecastData] = useState(null);
  const [isCached, setIsCached] = useState(false);
  const [error, setError] = useState('');

  const fetchForecast = async (zipCode) => {
    setError('');
    setForecastData(null);
    setIsCached(false);

    try {
      const response = await axios.post(`/v1/forecasts/fetch_forecast`, { zip_code: zipCode, days: 10 });
      setForecastData(response.data.forecast_data);
      setIsCached(response.data.cached);
    } catch (err) {
      if (err.response && err.response.data.error) {
        setError(err.response.data.error.message || 'Failed to fetch forecast data.');
      } else {
        setError('Failed to fetch forecast data.');
      }
      setForecastData(null);
      setIsCached(false);
      console.error(err);
    }
  };

  return { fetchForecast, forecastData, isCached, error };
};

export default useForecast;

