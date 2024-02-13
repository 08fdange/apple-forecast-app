import React from 'react';
import getWeatherIconUrl from '../utils/getWeatherIcon';

const TodaysForecast = ({ forecastData }) => {
  return (
    <div className="mt-2 p-2 flex justify-between items-center rounded-lg bg-gray-700 bg-opacity-80">
      <div className="flex items-center">
        <img src={getWeatherIconUrl(forecastData.current.condition.icon)} alt={forecastData.current.condition.text} />
        <div>
          <p className="text-lg font-bold text-white">{forecastData.location.name}</p>
          <p className="text-white">{forecastData.current.condition.text}</p>
        </div>
      </div>
      <div className="flex flex-col items-end">
        <p className="text-3xl font-bold text-white">{Math.round(forecastData.current.temp_f)}°</p>
        <div className="flex">
          <p className="text-sm text-white mr-1">H: {forecastData.forecast.forecastday[0].day.maxtemp_f}°</p>
          <p className="text-sm text-white">L: {forecastData.forecast.forecastday[0].day.mintemp_f}°</p>
        </div>
      </div>
    </div>
  );
};

export default TodaysForecast;