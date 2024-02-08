import { useState } from 'react';
import axios from 'axios';

const useForecast = () => {
  const [forecastData, setForecastData] = useState(null);
  const [isCached, setIsCached] = useState(false);
  const [error, setError] = useState('');

  const fetchForecast = async (zipCode) => {
    setError('');
    try {
      const response = await axios.post(`/v1/forecasts/fetch_forecast`, { zip_code: zipCode });
      setForecastData(response.data.forecast_data);
      setIsCached(response.data.cached);
    } catch (err) {
      setError('Failed to fetch forecast data.');
      console.error(err);
    }
  };

  return { fetchForecast, forecastData, isCached, error };
};

export default useForecast;
