import React from 'react';
import Autocomplete from 'react-google-autocomplete';

const AddressAutocompleteInput = ({ onPlaceSelected }) => {
  return (
    <Autocomplete
      apiKey={window.REACT_APP_GOOGLE_MAPS_API_KEY}
      onPlaceSelected={onPlaceSelected}
      options={{
        types: ['address'],
        fields: ['address_components', 'geometry.location', 'place_id', 'formatted_address'],
      }}
      style={{
        width: '100%',
        padding: '8px',
        border: '2px solid #d1d5db',
        borderRadius: '0.375rem',
        fontSize: '1rem',
        lineHeight: '1.5rem',
      }}
    />
  );
};

export default AddressAutocompleteInput;