import React, { useState } from 'react';

const HtmlRenderer = ({ initialHtml }) => {
  const [inputs, setInputs] = useState({});

  // Handler for input change
  const handleInputChange = (placeholder, value) => {
    setInputs((prev) => ({
      ...prev,
      [placeholder]: value,
    }));
  };

  // Parse the HTML string and convert it into React components
  const parseHtmlToComponents = (htmlString) => {
    const parts = htmlString.split(/(\[\$.*?\$])/g); // Split the string by the placeholders
    return parts.map((part, index) => {
      const match = part.match(/\[\$(.*?)\$]/); // Match placeholder pattern
      if (match) {
        const placeholder = match[1]; // Extract placeholder value
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
      return <span key={index} dangerouslySetInnerHTML={{ __html: part }} />; // Render other HTML elements
    });
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
