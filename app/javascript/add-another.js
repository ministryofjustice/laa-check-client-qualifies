import Input from "./suggestions"
import { Radios } from "govuk-frontend";

/* This method assumes that there will be zero or more sections of HTML on the page structured as follows:
<div data-module="add-another">
  <div data-add-another-role="template">
     <div data-add-another-role="section">
        <!-- ... -->
        <span data-add-another-role="counter"></span>
        <!-- ... -->
        <button type="button" data-add-another-role="remove">Remove</button>
     </div>
  </div>
  <div data-add-another-role="sectionList">
     <div data-add-another-role="section">
        <!-- ... -->
     </div>
  </div>
  <button type="button" data-add-another-role="add">Add</button>
</div>
*/

const initAddAnother = () => {
  document.querySelectorAll('[data-module="add-another"]').forEach((addAnotherContainer) => {
    addAnotherContainer.querySelector('[data-add-another-role="add"]').addEventListener('click', () => {
      addAnother(addAnotherContainer)
    })

    const sectionList = addAnotherContainer.querySelector('[data-add-another-role="sectionList"]');

    setUpSections(sectionList);
    setUpAddButton(addAnotherContainer);
  });
}

const addAnother = (addAnotherContainer) => {
  const newSection = addAnotherContainer.querySelector('[data-add-another-role="template"]').firstChild.cloneNode(true);
  const sections = addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').querySelectorAll('[data-add-another-role="section"]');
  const counter = sections.length;
  addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').append(newSection);
  const newSectionHeader = newSection.querySelector("h2");
  if (newSectionHeader) {
    newSectionHeader.setAttribute('tabindex', '0')
    newSectionHeader.focus();
  }
  setUpSection(newSection, counter, { setUpSuggestions: true })
  setUpAddButton(addAnotherContainer);
};

const setUpSection = (section, counter, options) => {
  setUpRemoveButton(section);
  if (options && options.setUpSuggestions) {
    setUpSuggestions(section)
  }
  setNumbering(section, counter);
  setUpRadios(section);
};

const setUpRemoveButton = (section) => {
  const removeButton = section.querySelector('[data-add-another-role="remove"]');
  if (!removeButton) {
    return;
  }
  if (removeButton.dataset.removeListenerSet) {
    return;
  }
  removeButton.dataset.removeListenerSet = true;
  removeButton.addEventListener('click', () => {
    remove(section)
  })
};

const setUpSuggestions = (section) => {
  section.querySelectorAll('[data-module="govuk-input"]').forEach((input) => {
    new Input(input).init()
  });
}

const remove = (section) => {
  const sectionList = section.closest('[data-add-another-role="sectionList"]')
  showItemRemovedFeedback(section);
  updateErrorMessages(section, sectionList)
  section.remove();
  setUpSections(sectionList); // Some JS triggers, in particular radio conditional reveals, must be re-initialised
  setUpAddButton(sectionList.closest('[data-module="add-another"]'));
}

const showItemRemovedFeedback = (section) => {
  const topLevelElement = section.closest('[data-module="add-another"]');
  const feedback = document.createElement("div");
  feedback.className = "add-another-removed-feedback";
  feedback.setAttribute("tabindex", "0")

  const text = document.createElement("div");
  text.className = "add-another-removed-feedback-text govuk-body";
  text.innerHTML = topLevelElement.dataset.addAnotherRemovedFeedbackText;

  const button = document.createElement("button")
  button.className = "add-another-removed-feedback-button govuk-body";
  button.innerHTML = topLevelElement.dataset.addAnotherHideMessageText;

  feedback.append(text);
  feedback.append(button);
  section.after(feedback);

  feedback.focus();

  button.addEventListener("click", () => { feedback.remove() });
};

const updateErrorMessages = (sectionToRemove, sectionList) => {
  let reachedSectionToRemove = false
  sectionList.querySelectorAll('[data-add-another-role="section"]').forEach((currentSection, index) => {
    const currentSectionCurrentPosition = index + 1;
    // Remove all error summary messages pertaining to an item that has been removed
    if (currentSection === sectionToRemove) {
      reachedSectionToRemove = true;
      document.querySelectorAll(`[data-add-another-role="errorMessage"][data-add-another-item-position="${currentSectionCurrentPosition}"]`).forEach((redundantErrorMessage) => {
        redundantErrorMessage.closest("li").remove();
      });
    // Decrement the numbers of all error messages that are for items that come after the removed item.
    } else if (reachedSectionToRemove) {
      const newPosition = index;
      document.querySelectorAll(`[data-add-another-role="errorMessage"][data-add-another-item-position="${currentSectionCurrentPosition}"]`).forEach((elementToUpdate) => {
        elementToUpdate.dataset.addAnotherItemPosition = newPosition;
        elementToUpdate.querySelectorAll('[data-add-another-role="errorPosition"]').forEach((positionText) => {
          positionText.innerHTML = newPosition;
        })

        elementToUpdate.closest("a").href = elementToUpdate.closest("a").href.replace(`-${currentSectionCurrentPosition}-`, `-${newPosition}-`);
      });
    }
  });

  // Remove the error summary if there are no errors left in it
  document.querySelectorAll(".govuk-error-summary__list").forEach((summaryList) => {
    if (summaryList.childNodes.length === 0) {
      summaryList.closest(".govuk-error-summary").remove();
    }
  })
}

const setUpSections = (sectionList) => {
  sectionList.querySelectorAll('[data-add-another-role="section"]').forEach((section, index) => {
    setUpSection(section, index)
  });
}

const setNumbering = (section, counter) => {
  const counterElement = section.querySelector('[data-add-another-role="counter"]')
  if (counterElement) {
    counterElement.innerHTML = counter + 1;
  }
  section.querySelectorAll('[data-add-another-dynamic-elements]').forEach((element) => {
    element.dataset.addAnotherDynamicElements.split(",").forEach((pairString) => {
      const parts = pairString.split(":");
      element.setAttribute(parts[0], parts[1].replace("ID", counter + 1))
    });
  })
}

const setUpRadios = (section) => {
  const radios = new Radios(section);
}

const setUpAddButton = (addAnotherContainer) => {
  const button = addAnotherContainer.querySelector('[data-add-another-role="add"]');
  if (button.dataset.addAnotherMaximum) {
    const sections = addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').querySelectorAll('[data-add-another-role="section"]');
    if (button.dataset.addAnotherMaximum <= sections.length) {
      button.classList.add("add-another-hidden");
    } else {
      button.classList.remove("add-another-hidden");
    }
  }
}

export default initAddAnother;
