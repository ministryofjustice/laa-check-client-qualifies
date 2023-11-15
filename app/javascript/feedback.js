const initFeedback = () => {
  onClickElementWithRole("initial-trigger", () => {
    showSection("message");
    document.querySelector('[data-feedback-role="text-input"]').focus();
  });

  onClickElementWithRole("submit-text", (e) => {
    if (textBlank()) {
      e.preventDefault();
      showSection("initial")
    } else {
      showSection("final");
      document.querySelector('[data-feedback-role="final-message"]').focus();
    }
  });

  onClickElementWithRole("cancel", () => {
    showSection("initial");
  });

  onClickElementWithRole("skip", () => {
    showSection("final");
  });

  document.querySelectorAll('[data-feedback-role="satisfaction-form"]').forEach((element) => {
    element.addEventListener('ajax:success', (e) => {
      document.querySelectorAll('[data-feedback-role="comment-form"]').forEach((form) => {
        form.action = `/feedbacks/${e.detail[0].id}`;
      });
    });
  });

}

const onClickElementWithRole = (role, callback) => {
  document.querySelectorAll(`[data-feedback-role="${role}"]`).forEach((element) => {
    element.addEventListener('click', callback);
  });
}

const textBlank = () => {
  const freetextField = document.querySelector('[data-feedback-role="text-input"]');
  return freetextField.value.replace(/\s+/g, '') === "";
}

const showSection = (sectionArea) => {
  ['initial', 'message', 'final'].forEach((section) => {
    const sectionElement = document.querySelector(`[data-feedback-section="${section}"]`);

     if (sectionElement) {
      sectionElement.hidden = (section !== sectionArea);
     }
  });
}

export default initFeedback;
