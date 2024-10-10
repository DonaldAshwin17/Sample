import React, { useState } from 'react';

const PlaceholderReplacer = ({ htmlString }) => {
  const [inputs, setInputs] = useState({});

  const handleChange = (key, value) => {
    setInputs(prev => ({ ...prev, [key]: value }));
  };

  const renderHtml = () => {
    return htmlString.split(/(\[\$.*?\$\])/).map((part, index) => {
      if (/\[\$.*?\$\]/.test(part)) {
        const key = part.replace(/\[\$|\$\]/g, '');
        return (
          <input
            key={index}
            placeholder={key}
            onChange={(e) => handleChange(key, e.target.value)}
          />
        );
      }
      return <span key={index}>{part}</span>; // Keep other HTML intact
    });
  };

  const getFinalHtml = () => {
    let finalHtml = htmlString;
    Object.keys(inputs).forEach(key => {
      finalHtml = finalHtml.replace(`[$${key}$]`, inputs[key]);
    });
    return finalHtml;
  };

  return (
    <div>
      <div>{renderHtml()}</div>
      <div>{getFinalHtml()}</div>
    </div>
  );
};

export default PlaceholderReplacer;
