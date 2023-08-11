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

    addAnotherContainer.querySelectorAll('[data-add-another-role="section"]').forEach((section) => {
      setUpRemoveButton(section);
    });

    setUpSections(addAnotherContainer.querySelector('[data-add-another-role="sectionList"]'));
    setUpAddButton(addAnotherContainer);
  });
}

const addAnother = (addAnotherContainer) => {
  const newSection = addAnotherContainer.querySelector('[data-add-another-role="template"]').firstChild.cloneNode(true);
  const sections = addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').querySelectorAll('[data-add-another-role="section"]');
  const counter = sections.length;
  addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').append(newSection);
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
  section.remove();
  setUpSections(sectionList); // Some JS triggers, in particular radio conditional reveals, must be re-initialised
  setUpAddButton(sectionList.closest('[data-module="add-another"]'));
}

const setUpSections = (sectionList) => {
  sectionList.querySelectorAll('[data-add-another-role="section"]').forEach((section, index) => {
    setUpSection(section, index)
  });
}

const setNumbering = (section, counter) => {
  const counterElement = section.querySelector('[data-add-another-role="counter"]')
  if (counterElement) {
    counterElement.innerHTML = counterElement.dataset.addAnotherNumberFrom === "zero" ? counter : counter + 1;
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
  radios.init();
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