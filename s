import React, { useState, useEffect } from 'react';

const DynamicTextBox = ({ htmlString }) => {
  const [inputValues, setInputValues] = useState({});

  // Function to handle input change and store value
  const handleInputChange = (index, e) => {
    setInputValues(prevValues => ({
      ...prevValues,
      [index]: e.target.value
    }));
  };

  // Function to adjust the textbox size based on content
  const adjustTextboxSize = (e) => {
    e.target.style.width = (e.target.value.length + 1) + "ch";
  };

  // Function to parse the input string and insert textboxes
  const createTextBoxes = (html) => {
    const regex = /\[\$(.*?)\$\]/g;
    let processedHtml = html;
    let match;
    let index = 0;

    // Replacing placeholders with input elements
    while ((match = regex.exec(html)) !== null) {
      const placeholder = match[1]; // Extract text between [$ $]
      const textbox = `<input type="text" 
                             value="${inputValues[index] || ''}" 
                             placeholder="${placeholder}" 
                             oninput="this.style.width = ((this.value.length + 1) + 'ch')" 
                             data-index="${index}" />`;
      processedHtml = processedHtml.replace(match[0], textbox);
      index++;
    }

    return processedHtml;
  };

  // Using dangerouslySetInnerHTML to display processed HTML with textboxes
  return (
    <div
      dangerouslySetInnerHTML={{ __html: createTextBoxes(htmlString) }}
    />
  );
};

const App = () => {
  const htmlString = `<p>Hello, [$name$]! Please enter your [$email$] and [$phone$] for contact.</p>`;

  return (
    <div>
      <DynamicTextBox htmlString={htmlString} />
    </div>
  );
};

export default App;


// Function to replace [$text$] with input fields
const createTextBoxes = (htmlString, inputValues) => {
  const regex = /\[\$(.*?)\$\]/g;
  let processedHtml = htmlString;
  let match;
  let index = 0;

  // Replace each match with an input field
  while ((match = regex.exec(htmlString)) !== null) {
    const placeholder = match[1];
    const inputElement = `<input type="text" 
                            value="${inputValues[index] || ''}" 
                            placeholder="${placeholder}" 
                            data-index="${index}" />`;

    processedHtml = processedHtml.replace(match[0], inputElement);
    index++;
  }

  return processedHtml;
};

// Function to replace input fields with spans containing the input values
const replaceInputsWithSpans = (htmlString, inputValues) => {
  const regex = /\[\$(.*?)\$\]/g;
  let processedHtml = htmlString;
  let match;
  let index = 0;

  // Replace each match with a span containing the input value
  while ((match = regex.exec(htmlString)) !== null) {
    const inputValue = inputValues[index] || ''; // Get the current input value
    const spanElement = `<span>${inputValue}</span>`;
    
    processedHtml = processedHtml.replace(match[0], spanElement);
    index++;
  }

  return processedHtml;
};


