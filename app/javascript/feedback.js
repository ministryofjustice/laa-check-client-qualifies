const initFeedback = () => {
  const query = document.querySelector('[data-freetext-feedback="query"]');
  const cancel = document.querySelector('[data-freetext-feedback="cancel"]');
  const send  = document.querySelector('[data-freetext-feedback="send"]');
  const yes_button = document.querySelector('[data-satisfaction-feedback="yes-button"]');
  const no_button = document.querySelector('[data-satisfaction-feedback="no-button"]');

  if (query) {
    query.addEventListener('click', () => {
     freetextAreaShow();
    })
  }

  if (cancel) { 
    cancel.addEventListener('click', () => {
     freetextAreaHide();
    })
  }

  if (send) {
    send.addEventListener('click', () => {
     messageAreaShow();
    })
  }

  if (yes_button) {
    yes_button.addEventListener('click', () => {
     linkAreaShow();
    })
  }

  if (no_button) {
    no_button.addEventListener('click', () => {
     linkAreaShow();
    })
  }
};

function freetextAreaShow() {
  document.querySelector('[data-module="prompt-area"]').hidden = true;
  document.querySelector('[data-module="freetext-area"]').hidden = false;
  document.querySelector('[data-module="message-area"]').hidden = true;
  document.querySelector('[data-module="freetext-feedback-area"]').style.backgroundColor = "white";
}

function freetextAreaHide() {
  document.querySelector('[data-module="prompt-area"]').hidden = false;
  document.querySelector('[data-module="freetext-area"]').hidden = true;
  document.querySelector('[data-module="message-area"]').hidden = true;
  document.querySelector('[data-module="freetext-feedback-area"]').style.backgroundColor = "#f3f2f1";
}

function messageAreaShow() {
  document.querySelector('[data-module="freetext-area"]').hidden = true;
  document.querySelector('[data-module="message-area"]').hidden = false;
  document.querySelector('[data-module="freetext-feedback-area"]').style.backgroundColor = "#f3f2f1";
}

function linkAreaShow() {
  document.querySelector('[data-module="question-area"]').hidden = true;
  document.querySelector('[data-module="link-area"]').hidden = false;
}

export default initFeedback;
