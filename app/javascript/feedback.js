const initFeedback = () => {
  const prompt = document.querySelector('[data-freetext-feedback="prompt"]');
  const cancel = document.querySelector('[data-freetext-feedback="cancel"]');
  const send  = document.querySelector('[data-freetext-feedback="send"]');
  const yes_button = document.querySelector('#data-satisfaction-feedback-yes');
  const no_button = document.querySelector('#data-satisfaction-feedback-no');


  prompt?.addEventListener('click', () => {
    showSection("freetext");
  });

  cancel?.addEventListener('click', () => {
    showSection("prompt");
  })

  send?.addEventListener('click', (e) => {
    const freetextField = document.getElementById("text-field")

    if (freetextField.value === "") {
      e.preventDefault();
      showSection("prompt")
    } else {
      showSection("message");
    }
  })

  yes_button?.addEventListener('click', () => {
    showSection("link");
  })

  no_button?.addEventListener('click', () => {
    showSection("link");
  })
};

function showSection(sectionArea) {
  ['freetext', 'message', 'prompt', 'link', 'question'].forEach((section) => {
    const sectionElement = document.querySelector(`[data-feedback-section="${section}-area"]`);

     if (sectionElement) {
      sectionElement.hidden = (section !== sectionArea);
     }
  });
}

export default initFeedback;
