import React from 'react';
import { format, parseISO, isToday } from 'date-fns';
import getWeatherIconUrl from '../utils/getWeatherIcon';

const ExtendedForecast = ({ forecast }) =>  {
  return (
    <div className="mt-4 p-2 rounded-lg bg-gray-700 bg-opacity-80">
      <p className="text-sm text-gray-200 mb-1">10-DAY FORECAST</p>
      <div className="flex flex-col">
        {forecast.forecastday.map((item, index) => {
            const date = parseISO(item.date);
            const formattedDate = isToday(date) ? 'Today' : format(date, 'EE');
            return (
              <div 
                className="flex items-center justify-between border-t border-white border-opacity-75 py-2"
                key={`${item.date}-${index}`}
              >
                <div className="flex justify-between items-center w-[27%]">
                  <p className="text-white">{formattedDate}</p>
                  <img
                    className="w-8 h-8"
                    src={getWeatherIconUrl(item.day.condition.icon)}
                    alt={item.day.condition.text}
                  />
                </div>
                <div className="flex items-center">
                  <p className="text-gray-100">{Math.round(item.day.mintemp_f)}°</p>
                  <p className="mx-1 text-gray-100">-</p>
                  <p className="text-gray-100">{Math.round(item.day.maxtemp_f)}°</p>
                </div>
              </div>
            );
          })}
      </div>
    </div>
  );
};

export default ExtendedForecast;