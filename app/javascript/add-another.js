import Input from "./suggestions"

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

    setNumberings(addAnotherContainer.querySelector('[data-add-another-role="sectionList"]'));
  });
}

const addAnother = (addAnotherContainer) => {
  const newSection = addAnotherContainer.querySelector('[data-add-another-role="template"]').firstChild.cloneNode(true);
  const sections = addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').querySelectorAll('[data-add-another-role="section"]');
  const counter = sections.length + 1;
  setUpSection(newSection, counter)
  addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').append(newSection);
};

const setUpSection = (newSection, counter) => {
  setUpRemoveButton(newSection);
  setUpTitle(newSection, counter);
  setUpSuggestions(newSection);
  setNumbering(newSection, counter);
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

const setUpTitle = (newSection, counter) => {
  newSection.querySelector('[data-add-another-role="counter"]').innerHTML = counter
};

const setUpSuggestions = (newSection) => {
  newSection.querySelectorAll('[data-module="govuk-input"]').forEach((input) => {
    new Input(input).init()
  });
}

const remove = (section) => {
  const sectionList = section.closest('[data-add-another-role="sectionList"]')
  section.remove();
  setNumberings(sectionList);
}

const setNumberings = (sectionList) => {
  sectionList.querySelectorAll('[data-add-another-role="section"]').forEach((section, index) => {
    setNumbering(section, index + 1)
  });
}

const setNumbering = (section, counter) => {
  const counterElement = section.querySelector('[data-add-another-role="counter"]')
  if (counterElement) {
    counterElement.innerHTML = counter
  }
  section.querySelectorAll('input, label, select, textarea').forEach((element) => {
    if (element.dataset.addAnotherForPattern) {
      element.setAttribute("for", element.dataset.addAnotherForPattern.replace("ID", counter))
    }

    if (element.dataset.addAnotherIdPattern) {
      element.setAttribute("id", element.dataset.addAnotherIdPattern.replace("ID", counter))
    }

    if (element.dataset.addAnotherNamePattern) {
      element.setAttribute("name", element.dataset.addAnotherNamePattern.replace("ID", counter))
    }
  })
}

export default initAddAnother;