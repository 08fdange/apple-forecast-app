import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

document.addEventListener('DOMContentLoaded', () => {
  const root = document.getElementById('root') || document.body.appendChild(document.createElement('div'));
  const rootElement = ReactDOM.createRoot(root);
  rootElement.render(<App />);
});