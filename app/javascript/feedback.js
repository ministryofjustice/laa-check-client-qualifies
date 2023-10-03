const initFeedback = () => {
  document.querySelector('data-module="promt"]').addEventListener('click', () => {
    document.querySelector('[data-freetext-feedback="query"]').hidden = true;
  },
  false,
  )
};


const revealElements = () => {
  const feedbackPrompt = document.querySelector('[data-module="promt"');
  const widthContainer = document.querySelector('.govuk-width-container');

  if (feedbackPrompt) {
    feedbackPrompt.hidden = true;
  }

  if (widthContainer) {
    widthContainer.hidden = true;
  }
};


const displayWhiteBackground = () => {

};



const cancel = () => {

};


const send = () => {

};


export default initFeedback;
