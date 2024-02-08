import React from 'react';

const IPhoneWrapper = ({ children }) => {
  const imageUrl = '/assets/iphone-15-pro-max.png';

  return (
    <div className="flex justify-center items-center h-screen overflow-hidden">
      <div className="relative h-[90vh] max-h-[800px] w-auto">
        <img src={imageUrl} alt="iphone-15" className="h-full w-auto" />
        <div className="absolute top-0 left-0 right-0 bottom-0 flex justify-center items-center">
          <div className="w-[94%] h-[87%] rounded-xl overflow-hidden p-4">
            {children}
          </div>
        </div>
      </div>
    </div>
  );
};

export default IPhoneWrapper;


