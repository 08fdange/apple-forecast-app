import React from 'react';
import ForecastForm from './components/ForecastForm';
import IPhoneWrapper from './components/IPhoneWrapper';


const App = () => {
  return (
    <div className="flex flex-col h-screen justify-center items-center bg-gray-100">
      <IPhoneWrapper>
        <ForecastForm />
      </IPhoneWrapper>
    </div>
  );
};

export default App;
