import { initAll } from "govuk-frontend";
import Rails from '@rails/ujs';

// NOTE: suggestions input component not yet part of GOV.UK frontend
// https://github.com/alphagov/govuk-frontend/pull/2453
import Input from "./suggestions"
import initChangeLogs from "./change-logs";
import initAddAnother from "./add-another";

initChangeLogs();
initAddAnother();

document.querySelectorAll('[data-module="govuk-input"]').forEach((input) => {
  new Input(input).init()
});

document.querySelectorAll('[data-trigger="print"]').forEach((button) => {
  button.addEventListener('click', () => window.print());
});

Rails.start();
initAll();
