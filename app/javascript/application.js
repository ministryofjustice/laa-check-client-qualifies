import { initAll } from "govuk-frontend";
import initResults from "./results";
import Rails from '@rails/ujs';
import * as Sentry from "@sentry/browser";

// NOTE: suggestions input component not yet part of GOV.UK frontend
// https://github.com/alphagov/govuk-frontend/pull/2453
import Input from "./suggestions"
import initAddAnother from "./add-another";
import initFeedback from "./feedback";

initAddAnother();

document.querySelectorAll('[data-module="govuk-input"]').forEach((input) => {
  new Input(input).init()
});

document.querySelectorAll('a[data-behaviour="browser-back"]').forEach((link) => {
  link.addEventListener('click', (event) => {
    event.preventDefault();
    history.back();
  });
});

if (!window._rails_loaded) {
  Rails.start();
}
initAll();
initResults();
initFeedback();

const sentryDsn = document.querySelector("body").dataset.sentryDsn;
if (sentryDsn) {
  Sentry.init({
    dsn: sentryDsn,
    integrations: [new Sentry.BrowserTracing(), new Sentry.Replay()],
    tracesSampleRate: 1.0,
    replaysSessionSampleRate: 0.1,
    replaysOnErrorSampleRate: 1.0,
  });
}
