import React, { useState } from "react";

const DynamicTextBox = () => {
  // Initial input string with placeholders
  const initialInputString = 'Here is a [$placeholder1$] and another [$placeholder2$] in the sentence.';

  // State to store the HTML with dynamic textboxes
  const [inputString, setInputString] = useState(initialInputString);

  // State to store the input values entered by the user
  const [inputs, setInputs] = useState({});

  // Function to convert placeholders to textboxes
  const convertToTextBoxes = (htmlString) => {
    const parts = [];
    const regex = /\[\$(.*?)\$\]/g;
    let lastIndex = 0;

    let match;
    while ((match = regex.exec(htmlString)) !== null) {
      // Push the text before the match
      if (match.index > lastIndex) {
        parts.push(htmlString.slice(lastIndex, match.index));
      }

      // Push the input element for the match
      const placeholderText = match[1];
      parts.push(
        <input
          key={match.index}
          type="text"
          className="dynamic-input"
          placeholder={placeholderText}
          value={inputs[placeholderText] || ""}
          onChange={(e) => handleInputChange(e, placeholderText)}
          onInput={(e) => adjustWidth(e)}
        />
      );

      lastIndex = regex.lastIndex;
    }

    // Add any remaining text after the last match
    if (lastIndex < htmlString.length) {
      parts.push(htmlString.slice(lastIndex));
    }

    return parts;
  };

  // Function to handle changes in input fields
  const handleInputChange = (e, placeholder) => {
    setInputs({
      ...inputs,
      [placeholder]: e.target.value
    });
  };

  // Function to dynamically adjust the textbox size based on the content
  const adjustWidth = (e) => {
    e.target.style.width = e.target.value.length > 0 ? `${e.target.value.length + 1}ch` : "auto";
  };

  // Function to replace textboxes with user input values
  const replacePlaceholders = () => {
    let updatedContent = initialInputString;

    // Replace placeholders with the user input
    Object.keys(inputs).forEach((placeholder) => {
      const regex = new RegExp(`\\[\\$${placeholder}\\$\\]`, "g");
      updatedContent = updatedContent.replace(regex, inputs[placeholder] || placeholder);
    });

    setInputString(updatedContent);
  };

  return (
    <div>
      <div id="content">{convertToTextBoxes(inputString)}</div>
      <button onClick={replacePlaceholders}>Replace Textboxes</button>
    </div>
  );
};

export default DynamicTextBox;
