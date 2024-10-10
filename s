import React, { useState } from 'react';

const HtmlRenderer = ({ initialHtml }) => {
  const [inputs, setInputs] = useState({});

  // Function to replace placeholders with React inputs
  const parseHtmlToComponents = (htmlString) => {
    const parts = htmlString.split(/(\[\$.*?\$])/g); // Split the string into parts by placeholder patterns
    return parts.map((part, index) => {
      const match = part.match(/\[\$(.*?)\$]/); // Check if part is a placeholder
      if (match) {
        const placeholder = match[1]; // Extract placeholder name
        return (
          <input
            key={index}
            type="text"
            placeholder={placeholder}
            value={inputs[placeholder] || ''}
            onChange={(e) => handleInputChange(placeholder, e.target.value)}
          />
        );
      }
      return <span key={index}>{part}</span>; // If it's not a placeholder, render it as text
    });
  };

  const handleInputChange = (placeholder, value) => {
    setInputs(prev => ({
      ...prev,
      [placeholder]: value,
    }));
  };

  const getFinalHtmlString = () => {
    return initialHtml.replace(/\[\$(.*?)\$]/g, (match, placeholder) => {
      return inputs[placeholder] || '';
    });
  };

  return (
    <>
      <div>{parseHtmlToComponents(initialHtml)}</div>
      <button onClick={() => console.log(getFinalHtmlString())}>
        Get Final HTML String
      </button>
    </>
  );
};

export default HtmlRenderer;
