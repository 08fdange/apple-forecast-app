import React from 'react';

const IPhoneWrapper = ({ children }) => {
  const imageUrl = '/assets/iphone-15-pro-max.png';
  const daytimeBackground = '/assets/clear-sunrise.webp';
  const nighttimeBackground = '/assets/clear-night.webp';

    const isDaytime = () => {
      const hour = new Date().getHours();
      return hour >= 6 && hour < 20;
    };
  
    const backgroundUrl = isDaytime() ? daytimeBackground : nighttimeBackground;

  return (
    <div className="flex justify-center items-center h-screen overflow-hidden">
      <div className="relative h-[90vh] max-h-[800px] w-auto">
        <img src={imageUrl} alt="iphone-15" className="h-full w-auto" />
        <div className="absolute z-20 top-[22px] left-[37%] w-16 h-7 bg-black rounded-full" />
        <div className="absolute flex items-center justify-center z-20 top-[22px] right-[37%] w-7 h-7 bg-black rounded-full">
          <div className="w-[12px] h-[12px] bg-gray-900 rounded-full flex items-center justify-center">
            <div className="w-2 h-2 bg-black rounded-full"/>
          </div>
        </div>
        <div 
          className="absolute z-0 top-[12px] bottom-[11px] left-[15px] right-[15px] rounded-[44px]"
          style={{
            backgroundImage: `url(${backgroundUrl})`,
            backgroundPosition: 'center',
          }}
        />
        <div className="absolute z-10 top-0 left-0 right-0 bottom-0 flex justify-center items-center">
          <div className="w-[94%] h-[97%] rounded-t-[58px] rounded-b-[53px] overflow-scroll no-scrollbar p-4">
            {children}
          </div>
        </div>
      </div>
    </div>
  );
};

export default IPhoneWrapper;


