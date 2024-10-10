import React, { useState } from 'react';

const DynamicTextboxes = ({ initialHtml }) => {
  const [htmlContent, setHtmlContent] = useState(initialHtml);
  const [inputValues, setInputValues] = useState({}); // Track input values

  // Generate unique IDs for placeholders to handle duplicates
  const generateUniqueId = (() => {
    let count = 0;
    return () => `placeholder_${count++}`;
  })();

  // Function to replace [$some text$] placeholders with unique input textboxes
  const generateHtmlWithTextboxes = () => {
    const regex = /\[\$(.*?)\$\]/g;
    let match;
    let processedHtml = htmlContent;
    const ids = {};

    // Replace placeholders and assign unique IDs to each input box
    while ((match = regex.exec(htmlContent)) !== null) {
      const placeholderText = match[1].trim() || 'input'; // Default placeholder if empty
      const uniqueId = generateUniqueId();
      ids[uniqueId] = placeholderText;

      const inputHtml = `<input id="${uniqueId}" type="text" value="${inputValues[uniqueId] || ''}" placeholder="${placeholderText}" data-placeholder="${placeholderText}" style="width:${(inputValues[uniqueId] || placeholderText).length + 2}ch;" />`;
      
      processedHtml = processedHtml.replace(match[0], inputHtml); // Ensure this replaces the current match only
    }

    return processedHtml;
  };

  // Function to replace placeholders with the input values
  const replacePlaceholdersWithValues = () => {
    const inputs = document.querySelectorAll('input[data-placeholder]');
    let updatedHtml = htmlContent;

    inputs.forEach((input) => {
      const uniqueId = input.id;
      const value = input.value || input.placeholder; // Use placeholder if input is empty
      const placeholder = input.getAttribute('data-placeholder');

      updatedHtml = updatedHtml.replace(
        new RegExp(`\\[\\$${placeholder}\\$\\]`), 
        value
      );
    });

    setHtmlContent(updatedHtml); // Update state with replaced values
  };

  // Function to dynamically resize the textbox and update its value in the state
  const handleInputChange = (event) => {
    const input = event.target;
    const uniqueId = input.id;

    setInputValues((prevValues) => ({
      ...prevValues,
      [uniqueId]: input.value,
    }));

    input.style.width = `${input.value.length + 2}ch`; // Adjust width dynamically
  };

  return (
    <div>
      <div
        dangerouslySetInnerHTML={{ __html: generateHtmlWithTextboxes() }}
        onInput={handleInputChange} // Listen for input changes to resize textboxes
      />
      <button onClick={replacePlaceholdersWithValues}>Replace Values</button>
    </div>
  );
};

export default DynamicTextboxes;
