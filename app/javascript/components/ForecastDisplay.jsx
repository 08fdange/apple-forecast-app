import React from 'react';
import ExtendedForecast from './ExtendedForecast';
import TodaysForecast from './TodaysForecast'

const ForecastDisplay = ({ forecastData, isCached }) => {

  return (
    <div>
      {isCached && <p className="mt-4 text-sm text-white">This data was loaded from cache.</p>}
      <TodaysForecast forecastData={forecastData} />
      <ExtendedForecast forecast={forecastData.forecast} />
    </div>
  );
};

export default ForecastDisplay;
