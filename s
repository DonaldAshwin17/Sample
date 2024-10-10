import React, { useState } from 'react';

const HtmlRenderer = ({ initialHtml }) => {
  const [inputs, setInputs] = useState({});

  const handleInputChange = (placeholder, value) => {
    setInputs(prev => ({
      ...prev,
      [placeholder]: value
    }));
  };

  const createHtmlWithInputs = (htmlString) => {
    return htmlString.replace(/\[\$(.*?)\$]/g, (match, placeholder) => {
      return `<input type="text" placeholder="${placeholder}" value="${inputs[placeholder] || ''}" data-placeholder="${placeholder}" />`;
    });
  };

  const transformedHtml = createHtmlWithInputs(initialHtml);

  const handleInputChangeOnRender = (e) => {
    const placeholder = e.target.getAttribute('data-placeholder');
    handleInputChange(placeholder, e.target.value);
  };

  const getFinalHtmlString = () => {
    return initialHtml.replace(/\[\$(.*?)\$]/g, (match, placeholder) => {
      return inputs[placeholder] || '';
    });
  };

  return (
    <>
      <div
        dangerouslySetInnerHTML={{ __html: transformedHtml }}
        onInput={handleInputChangeOnRender}
      />
      <button onClick={() => console.log(getFinalHtmlString())}>
        Get Final HTML String
      </button>
    </>
  );
};

export default HtmlRenderer;
