import * as Sentry from "@sentry/browser";

const sentryDsn = document.querySelector("body").dataset.sentryDsn;
if (sentryDsn) {
  Sentry.init({
    dsn: sentryDsn,
    integrations: [Sentry.browserTracingIntegration(), Sentry.replayIntegration()],
    // All errors are captured
    sampleRate: 1,
    // All erroring sessions are replayable
    replaysOnErrorSampleRate: 1.0,

    // No non-erroring sessions are captured for performance monitoring
    tracesSampleRate: 0,
    // No non-erroring sessions are replayable
    replaysSessionSampleRate: 0,
  });
}

import { initAll } from "govuk-frontend";
import initResults from "./results";
import Rails from '@rails/ujs';

// NOTE: suggestions input component not yet part of GOV.UK frontend
// https://github.com/alphagov/govuk-frontend/pull/2453
import Input from "./suggestions"
import initAddAnother from "./add-another";
import initFeedback from "./feedback";
import initInstantDownload from "./instant-download";

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
initInstantDownload();
