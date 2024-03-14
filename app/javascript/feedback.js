const initFeedback = () => {
  onClickElementWithRole("initial-trigger", () => {
    showSection("message");
    document.querySelector('[data-feedback-role="text-input"]').focus();
  });

  onClickElementWithRole("submit-text", (e) => {
    if (textBlank()) {
      e.preventDefault();
      showSection(e.target.dataset.feedbackSectionIfBlank);
      showSectionNotification('blank')
    } else {
      showSection("final");
      document.querySelector('[data-feedback-role="final-message"]').focus();
    }
  });

  onClickElementWithRole("cancel", () => {
    showSection("initial");
    showSectionNotification('cancel')
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


const showSectionNotification = (section) => {
  const sectionElement = document.querySelector(`[data-feedback-section="${section}"]`);
  const blankSectionElement = document.querySelector('[data-feedback-section="blank"]');
  const cancelSectionElement = document.querySelector('[data-feedback-section="cancel"]');
  
  if (sectionElement) {
    if (section === 'blank') {
      blankSectionElement.hidden = false;
      cancelSectionElement.hidden = true;
      document.querySelector('[data-feedback-role="blank-message"]').focus();
    } else {
      blankSectionElement.hidden = true;
      cancelSectionElement.hidden = false;
      document.querySelector('[data-feedback-role="cancel-message"]').focus();
    }
  }
}
export default initFeedback;
