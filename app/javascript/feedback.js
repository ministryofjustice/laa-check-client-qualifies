const initFeedback = () => {
  document.querySelector('[data-freetext-feedback="query"]').addEventListener('click', () => {
    freetextAreaShow();
  })
  document.querySelector('[data-freetext-feedback="cancel"]').addEventListener('click', () => {
    freetextAreaHide();
  })
  document.querySelector('[data-freetext-feedback="send"]').addEventListener('click', () => {
    freetextAreaMessage();
  })
};

const freetextAreaShow = () => {
  document.querySelector('[data-module="prompt-area"]').hidden = true;
  document.querySelector('[data-module="freetext-area"]').hidden = false;
  document.querySelector('[data-module="message-area"]').hidden = true;
  document.querySelector('[data-module="feedback-area"]').style.backgroundColor = "white"
};

const freetextAreaHide = () => { 
  document.querySelector('[data-module="prompt-area"]').hidden = false;
  document.querySelector('[data-module="freetext-area"]').hidden = true;
  document.querySelector('[data-module="message-area"]').hidden = true;
  document.querySelector('[data-module="feedback-area"]').style.backgroundColor = "#f3f2f1"
};

const freetextAreaMessage = () => { 
  document.querySelector('[data-module="freetext-area"]').hidden = true;
  document.querySelector('[data-module="message-area"]').hidden = false;
  document.querySelector('[data-module="feedback-area"]').style.backgroundColor = "#f3f2f1"
};


export default initFeedback;
