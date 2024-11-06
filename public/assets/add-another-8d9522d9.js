(() => {
  // app/javascript/suggestions.js
  function Input($module) {
    this.$module = $module;
  }
  Input.prototype.init = function() {
    this.$formGroup = this.$module.parentNode;
    var suggestionsSourceId = this.$module.getAttribute("data-suggestions");
    if (suggestionsSourceId) {
      this.suggestions = document.getElementById(suggestionsSourceId);
      this.$formGroup.setAttribute("role", "combobox");
      this.$formGroup.setAttribute("aria-haspopup", "listbox");
      this.$formGroup.setAttribute("aria-expanded", "false");
      this.$suggestionsHeader = document.createElement("h2");
      this.$suggestionsHeader.setAttribute("class", "govuk-input__suggestions-header");
      this.$suggestionsHeader.textContent = this.$module.getAttribute("data-suggestions-header") || "Suggestions";
      this.$suggestionsHeader.hidden = true;
      this.$ul = document.createElement("ul");
      this.$ul.setAttribute("id", this.$module.getAttribute("id") + "-suggestions");
      this.$ul.addEventListener("click", this.handleSuggestionClicked.bind(this));
      this.$ul.addEventListener("keydown", this.handleSuggestionsKeyDown.bind(this));
      this.$ul.hidden = true;
      this.$ul.setAttribute("class", "govuk-input__suggestions-list");
      this.$ul.setAttribute("role", "listbox");
      this.$formGroup.appendChild(this.$suggestionsHeader);
      this.$formGroup.appendChild(this.$ul);
      this.$module.removeAttribute("list");
      this.$module.setAttribute("aria-autocomplete", "list");
      this.$module.setAttribute("aria-controls", this.$module.getAttribute("id") + "-suggestions");
      this.$module.addEventListener("input", this.handleInputInput.bind(this));
      this.$module.addEventListener("keydown", this.handleInputKeyDown.bind(this));
    }
  };
  Input.prototype.handleInputInput = function(event) {
    this.updateSuggestions();
  };
  Input.prototype.updateSuggestions = function() {
    if (this.$module.value.trim().length < 2) {
      this.hideSuggestions();
      return;
    }
    var queryRegexes = this.$module.value.trim().replace(/['’]/g, "").replace(/[.,"/#!$%^&*;:{}=\-_~()]/g, " ").split(/\s+/).map(function(word) {
      return new RegExp("\\b" + word, "i");
    });
    var matchingOptions = [];
    for (var option of this.suggestions.getElementsByTagName("option")) {
      var optionTextAndSynonyms = [option.textContent];
      var synonyms = option.getAttribute("data-synonyms");
      if (synonyms) {
        optionTextAndSynonyms = optionTextAndSynonyms.concat(synonyms.split("|"));
      }
      if (optionTextAndSynonyms.find(function(name) {
        return queryRegexes.filter(function(regex) {
          return name.search(regex) >= 0;
        }).length === queryRegexes.length;
      })) {
        matchingOptions.push(option);
      }
    }
    if (matchingOptions.length === 0) {
      this.displayNoSuggestionsFound();
    } else if (matchingOptions.length === 1 && matchingOptions[0].textContent === this.$module.value.trim()) {
      this.hideSuggestions();
    } else {
      this.updateSuggestionsWithOptions(matchingOptions);
    }
  };
  Input.prototype.updateSuggestionsWithOptions = function(options) {
    this.$ul.textContent = "";
    for (var option of options) {
      var li = document.createElement("li");
      li.textContent = option.textContent;
      li.setAttribute("role", "option");
      li.setAttribute("tabindex", "-1");
      li.setAttribute("data-value", option.value);
      li.setAttribute("class", "govuk-input__suggestion");
      this.$ul.appendChild(li);
    }
    this.$ul.hidden = false;
    this.$suggestionsHeader.hidden = false;
    this.$formGroup.setAttribute("aria-expanded", "true");
  };
  Input.prototype.handleSuggestionClicked = function(event) {
    var suggestionClicked = event.target;
    this.selectSuggestion(suggestionClicked);
  };
  Input.prototype.selectSuggestion = function(option) {
    option.setAttribute("aria-selected", "true");
    this.$module.value = option.dataset.value;
    this.$module.focus();
    this.hideSuggestions();
  };
  Input.prototype.handleInputKeyDown = function(event) {
    switch (event.keyCode) {
      // Down
      case 40:
        if (this.$ul.hidden !== true) {
          if (this.$ul.querySelector('li[role="option"]')) {
            this.moveFocusToOptions();
          }
          event.preventDefault();
        }
        break;
      // Up
      case 38:
        if (this.$ul.hidden !== true) {
          if (this.$ul.querySelector('li[role="option"]')) {
            this.moveFocusToOptions(false);
          }
          event.preventDefault();
        }
        break;
      // Tab
      case 9:
        this.hideSuggestions();
        break;
    }
  };
  Input.prototype.handleSuggestionsKeyDown = function(event) {
    var optionSelected;
    switch (event.keyCode) {
      // Down
      case 40:
        optionSelected = this.$ul.querySelector("li:focus");
        if (optionSelected.nextSibling) {
          optionSelected.nextSibling.focus();
        }
        event.preventDefault();
        break;
      // Up
      case 38:
        optionSelected = this.$ul.querySelector("li:focus");
        if (optionSelected.previousSibling) {
          optionSelected.previousSibling.focus();
        } else {
          this.$module.focus();
        }
        event.preventDefault();
        break;
      // Enter
      case 13:
        optionSelected = this.$ul.querySelector("li:focus");
        this.selectSuggestion(optionSelected);
        event.preventDefault();
        break;
      default:
        this.$module.focus();
    }
  };
  Input.prototype.moveFocusToOptions = function() {
    this.$ul.getElementsByTagName("li")[0].focus();
  };
  Input.prototype.hideSuggestions = function() {
    this.$ul.hidden = true;
    this.$suggestionsHeader.hidden = true;
    this.$formGroup.setAttribute("aria-expanded", "false");
  };
  Input.prototype.displayNoSuggestionsFound = function() {
    this.$ul.hidden = true;
    this.$suggestionsHeader.hidden = true;
    this.$formGroup.setAttribute("aria-expanded", "false");
  };
  var suggestions_default = Input;

  // node_modules/govuk-frontend/dist/govuk/common/index.mjs
  function isSupported($scope = document.body) {
    if (!$scope) {
      return false;
    }
    return $scope.classList.contains("govuk-frontend-supported");
  }

  // node_modules/govuk-frontend/dist/govuk/errors/index.mjs
  var GOVUKFrontendError = class extends Error {
    constructor(...args) {
      super(...args);
      this.name = "GOVUKFrontendError";
    }
  };
  var SupportError = class extends GOVUKFrontendError {
    /**
     * Checks if GOV.UK Frontend is supported on this page
     *
     * @param {HTMLElement | null} [$scope] - HTML element `<body>` checked for browser support
     */
    constructor($scope = document.body) {
      const supportMessage = "noModule" in HTMLScriptElement.prototype ? 'GOV.UK Frontend initialised without `<body class="govuk-frontend-supported">` from template `<script>` snippet' : "GOV.UK Frontend is not supported in this browser";
      super($scope ? supportMessage : 'GOV.UK Frontend initialised without `<script type="module">`');
      this.name = "SupportError";
    }
  };
  var ElementError = class extends GOVUKFrontendError {
    constructor(messageOrOptions) {
      let message = typeof messageOrOptions === "string" ? messageOrOptions : "";
      if (typeof messageOrOptions === "object") {
        const {
          componentName,
          identifier,
          element,
          expectedType
        } = messageOrOptions;
        message = `${componentName}: ${identifier}`;
        message += element ? ` is not of type ${expectedType != null ? expectedType : "HTMLElement"}` : " not found";
      }
      super(message);
      this.name = "ElementError";
    }
  };

  // node_modules/govuk-frontend/dist/govuk/govuk-frontend-component.mjs
  var GOVUKFrontendComponent = class {
    constructor() {
      this.checkSupport();
    }
    checkSupport() {
      if (!isSupported()) {
        throw new SupportError();
      }
    }
  };

  // node_modules/govuk-frontend/dist/govuk/components/radios/radios.mjs
  var Radios = class extends GOVUKFrontendComponent {
    /**
     * Radios can be associated with a 'conditionally revealed' content block –
     * for example, a radio for 'Phone' could reveal an additional form field for
     * the user to enter their phone number.
     *
     * These associations are made using a `data-aria-controls` attribute, which
     * is promoted to an aria-controls attribute during initialisation.
     *
     * We also need to restore the state of any conditional reveals on the page
     * (for example if the user has navigated back), and set up event handlers to
     * keep the reveal in sync with the radio state.
     *
     * @param {Element | null} $module - HTML element to use for radios
     */
    constructor($module) {
      super();
      this.$module = void 0;
      this.$inputs = void 0;
      if (!($module instanceof HTMLElement)) {
        throw new ElementError({
          componentName: "Radios",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      const $inputs = $module.querySelectorAll('input[type="radio"]');
      if (!$inputs.length) {
        throw new ElementError({
          componentName: "Radios",
          identifier: 'Form inputs (`<input type="radio">`)'
        });
      }
      this.$module = $module;
      this.$inputs = $inputs;
      this.$inputs.forEach(($input) => {
        const targetId = $input.getAttribute("data-aria-controls");
        if (!targetId) {
          return;
        }
        if (!document.getElementById(targetId)) {
          throw new ElementError({
            componentName: "Radios",
            identifier: `Conditional reveal (\`id="${targetId}"\`)`
          });
        }
        $input.setAttribute("aria-controls", targetId);
        $input.removeAttribute("data-aria-controls");
      });
      window.addEventListener("pageshow", () => this.syncAllConditionalReveals());
      this.syncAllConditionalReveals();
      this.$module.addEventListener("click", (event) => this.handleClick(event));
    }
    syncAllConditionalReveals() {
      this.$inputs.forEach(($input) => this.syncConditionalRevealWithInputState($input));
    }
    syncConditionalRevealWithInputState($input) {
      const targetId = $input.getAttribute("aria-controls");
      if (!targetId) {
        return;
      }
      const $target = document.getElementById(targetId);
      if ($target != null && $target.classList.contains("govuk-radios__conditional")) {
        const inputIsChecked = $input.checked;
        $input.setAttribute("aria-expanded", inputIsChecked.toString());
        $target.classList.toggle("govuk-radios__conditional--hidden", !inputIsChecked);
      }
    }
    handleClick(event) {
      const $clickedInput = event.target;
      if (!($clickedInput instanceof HTMLInputElement) || $clickedInput.type !== "radio") {
        return;
      }
      const $allInputs = document.querySelectorAll('input[type="radio"][aria-controls]');
      const $clickedInputForm = $clickedInput.form;
      const $clickedInputName = $clickedInput.name;
      $allInputs.forEach(($input) => {
        const hasSameFormOwner = $input.form === $clickedInputForm;
        const hasSameName = $input.name === $clickedInputName;
        if (hasSameName && hasSameFormOwner) {
          this.syncConditionalRevealWithInputState($input);
        }
      });
    }
  };
  Radios.moduleName = "govuk-radios";

  // app/javascript/add-another.js
  var initAddAnother = () => {
    document.querySelectorAll('[data-module="add-another"]').forEach((addAnotherContainer) => {
      addAnotherContainer.querySelector('[data-add-another-role="add"]').addEventListener("click", () => {
        addAnother(addAnotherContainer);
      });
      const sectionList = addAnotherContainer.querySelector('[data-add-another-role="sectionList"]');
      setUpSections(sectionList);
      setUpAddButton(addAnotherContainer);
    });
  };
  var addAnother = (addAnotherContainer) => {
    const newSection = addAnotherContainer.querySelector('[data-add-another-role="template"]').firstChild.cloneNode(true);
    const sections = addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').querySelectorAll('[data-add-another-role="section"]');
    const counter = sections.length;
    addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').append(newSection);
    const newSectionHeader = newSection.querySelector("h2");
    if (newSectionHeader) {
      newSectionHeader.setAttribute("tabindex", "0");
      newSectionHeader.focus();
    }
    setUpSection(newSection, counter, { setUpSuggestions: true });
    setUpAddButton(addAnotherContainer);
  };
  var setUpSection = (section, counter, options) => {
    setUpRemoveButton(section);
    if (options && options.setUpSuggestions) {
      setUpSuggestions(section);
    }
    setNumbering(section, counter);
    setUpRadios(section);
  };
  var setUpRemoveButton = (section) => {
    const removeButton = section.querySelector('[data-add-another-role="remove"]');
    if (!removeButton) {
      return;
    }
    if (removeButton.dataset.removeListenerSet) {
      return;
    }
    removeButton.dataset.removeListenerSet = true;
    removeButton.addEventListener("click", () => {
      remove(section);
    });
  };
  var setUpSuggestions = (section) => {
    section.querySelectorAll('[data-module="govuk-input"]').forEach((input) => {
      new suggestions_default(input).init();
    });
  };
  var remove = (section) => {
    const sectionList = section.closest('[data-add-another-role="sectionList"]');
    showItemRemovedFeedback(section);
    updateErrorMessages(section, sectionList);
    section.remove();
    setUpSections(sectionList);
    setUpAddButton(sectionList.closest('[data-module="add-another"]'));
  };
  var showItemRemovedFeedback = (section) => {
    const topLevelElement = section.closest('[data-module="add-another"]');
    const feedback = document.createElement("div");
    feedback.className = "add-another-removed-feedback";
    feedback.setAttribute("tabindex", "0");
    const text = document.createElement("div");
    text.className = "add-another-removed-feedback-text govuk-body";
    text.innerHTML = topLevelElement.dataset.addAnotherRemovedFeedbackText;
    const button = document.createElement("button");
    button.className = "add-another-removed-feedback-button govuk-body";
    button.innerHTML = topLevelElement.dataset.addAnotherHideMessageText;
    feedback.append(text);
    feedback.append(button);
    section.after(feedback);
    feedback.focus();
    button.addEventListener("click", () => {
      feedback.remove();
    });
  };
  var updateErrorMessages = (sectionToRemove, sectionList) => {
    let reachedSectionToRemove = false;
    sectionList.querySelectorAll('[data-add-another-role="section"]').forEach((currentSection, index) => {
      const currentSectionCurrentPosition = index + 1;
      if (currentSection === sectionToRemove) {
        reachedSectionToRemove = true;
        document.querySelectorAll(`[data-add-another-role="errorMessage"][data-add-another-item-position="${currentSectionCurrentPosition}"]`).forEach((redundantErrorMessage) => {
          redundantErrorMessage.closest("li").remove();
        });
      } else if (reachedSectionToRemove) {
        const newPosition = index;
        document.querySelectorAll(`[data-add-another-role="errorMessage"][data-add-another-item-position="${currentSectionCurrentPosition}"]`).forEach((elementToUpdate) => {
          elementToUpdate.dataset.addAnotherItemPosition = newPosition;
          elementToUpdate.querySelectorAll('[data-add-another-role="errorPosition"]').forEach((positionText) => {
            positionText.innerHTML = newPosition;
          });
          elementToUpdate.closest("a").href = elementToUpdate.closest("a").href.replace(`-${currentSectionCurrentPosition}-`, `-${newPosition}-`);
        });
      }
    });
    document.querySelectorAll(".govuk-error-summary__list").forEach((summaryList) => {
      if (summaryList.childNodes.length === 0) {
        summaryList.closest(".govuk-error-summary").remove();
      }
    });
  };
  var setUpSections = (sectionList) => {
    sectionList.querySelectorAll('[data-add-another-role="section"]').forEach((section, index) => {
      setUpSection(section, index);
    });
  };
  var setNumbering = (section, counter) => {
    const counterElement = section.querySelector('[data-add-another-role="counter"]');
    if (counterElement) {
      counterElement.innerHTML = counter + 1;
    }
    section.querySelectorAll("[data-add-another-dynamic-elements]").forEach((element) => {
      element.dataset.addAnotherDynamicElements.split(",").forEach((pairString) => {
        const parts = pairString.split(":");
        element.setAttribute(parts[0], parts[1].replace("ID", counter + 1));
      });
    });
  };
  var setUpRadios = (section) => {
    if (section.querySelector('input[type="radio"]')) {
      const radios = new Radios(section);
    }
  };
  var setUpAddButton = (addAnotherContainer) => {
    const button = addAnotherContainer.querySelector('[data-add-another-role="add"]');
    if (button.dataset.addAnotherMaximum) {
      const sections = addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').querySelectorAll('[data-add-another-role="section"]');
      if (button.dataset.addAnotherMaximum <= sections.length) {
        button.classList.add("add-another-hidden");
      } else {
        button.classList.remove("add-another-hidden");
      }
    }
  };
  var add_another_default = initAddAnother;
})();
/*! Bundled license information:

govuk-frontend/dist/govuk/components/radios/radios.mjs:
  (**
   * Radios component
   *
   * @preserve
   *)
*/
//
