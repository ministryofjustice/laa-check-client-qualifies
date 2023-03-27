import { initAll } from "govuk-frontend";
import Rails from '@rails/ujs';

// NOTE: suggestions input component not yet part of GOV.UK frontend
// https://github.com/alphagov/govuk-frontend/pull/2453
import Input from "./suggestions"
import initChangeLogs from "./change-logs";

const $inputs = document.querySelectorAll('[data-module="govuk-input"]')
if ($inputs) {
  for (let i = 0; i < $inputs.length; i++) {
    new Input($inputs[i]).init()
  }
}

Rails.start();
initAll();
initChangeLogs();
