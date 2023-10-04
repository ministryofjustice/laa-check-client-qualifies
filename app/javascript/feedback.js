const initFeedback = () => {
  document.querySelector('[data-freetext-feedback="query"]').addEventListener('click', () => {
    freetextAreaShow();
  })
  document.querySelector('[data-freetext-feedback="cancel"]').addEventListener('click', () => {
    freetextAreaHide();
  })
  document.querySelector('[data-freetext-feedback="send"]').addEventListener('click', () => {
    messageAreaShow();
  })
  document.querySelector('[data-satisfaction-feedback="yes-button"]').addEventListener('click', () => {
    linkAreaShow();
  })
};

const freetextAreaShow = () => {
  document.querySelector('[data-module="prompt-area"]').hidden = true;
  document.querySelector('[data-module="freetext-area"]').hidden = false;
  document.querySelector('[data-module="message-area"]').hidden = true;
  document.querySelector('[data-module="freetext-feedback-area"]').style.backgroundColor = "white"
};

const freetextAreaHide = () => { 
  document.querySelector('[data-module="prompt-area"]').hidden = false;
  document.querySelector('[data-module="freetext-area"]').hidden = true;
  document.querySelector('[data-module="message-area"]').hidden = true;
  document.querySelector('[data-module="freetext-feedback-area"]').style.backgroundColor = "#f3f2f1"
};

const messageAreaShow = () => { 
  document.querySelector('[data-module="freetext-area"]').hidden = true;
  document.querySelector('[data-module="message-area"]').hidden = false;
  document.querySelector('[data-module="freetext-feedback-area"]').style.backgroundColor = "#f3f2f1"
};

const linkAreaShow = () => { 
  document.querySelector('[data-module="question-area"]').hidden = true;
  document.querySelector('[data-module="link-area"]').hidden = false;
};


export default initFeedback;
