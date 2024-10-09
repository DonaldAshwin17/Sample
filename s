import React, { useRef, useState } from "react";

const DynamicTextBox = () => {
  const initialInputString = `Here is a [$placeholder1$] and another [$placeholder2$] in the sentence.`;
  
  // Store dynamic inputs
  const inputsRef = useRef({});
  const [htmlContent, setHtmlContent] = useState(initialInputString);

  // Function to convert placeholders to textboxes
  const createDynamicHTML = (htmlString) => {
    const updatedHTML = htmlString.replace(/\[\$(.*?)\$\]/g, (match, placeholder) => {
      return `<input 
                type="text" 
                class="dynamic-input" 
                data-placeholder="${placeholder}" 
                placeholder="${placeholder}" 
                style="width: auto; min-width: 50px; border: 1px solid #ccc; padding: 5px;" 
                oninput="this.style.width = (this.value.length + 1) + 'ch'"
              />`;
    });
    return updatedHTML;
  };

  // Function to update the HTML content with the input values
  const replacePlaceholders = () => {
    let updatedHTML = htmlContent;

    // Loop through each input and replace the placeholders with the values
    Object.keys(inputsRef.current).forEach((placeholder) => {
      const inputElement = inputsRef.current[placeholder];
      const value = inputElement.value || placeholder; // use the placeholder if no value
      const regex = new RegExp(`\\[\\$${placeholder}\\$\\]`, "g");
      updatedHTML = updatedHTML.replace(regex, value);
    });

    setHtmlContent(updatedHTML); // Set the new HTML content with replaced values
  };

  // Handle dynamically setting refs on input elements
  const setInputRefs = () => {
    const inputElements = document.querySelectorAll("input[data-placeholder]");
    inputElements.forEach((input) => {
      const placeholder = input.getAttribute("data-placeholder");
      inputsRef.current[placeholder] = input; // Store the reference to each input by its placeholder
    });
  };

  return (
    <div>
      {/* Render HTML content with dynamic inputs */}
      <div
        id="content"
        dangerouslySetInnerHTML={{ __html: createDynamicHTML(htmlContent) }}
        onInput={setInputRefs} // Every input change updates refs
      />
      <button onClick={replacePlaceholders}>Replace Textboxes</button>
    </div>
  );
};

export default DynamicTextBox;
