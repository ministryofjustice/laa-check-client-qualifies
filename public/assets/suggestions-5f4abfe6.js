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
})();
//
