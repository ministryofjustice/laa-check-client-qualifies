import { initAll } from "govuk-frontend";
import Rails from '@rails/ujs';

// NOTE: suggestions input component not yet part of GOV.UK frontend
// https://github.com/alphagov/govuk-frontend/pull/2453
import Input from "./suggestions"

const $inputs = document.querySelectorAll('[data-module="govuk-input"]')
if ($inputs) {
  for (let i = 0; i < $inputs.length; i++) {
    new Input($inputs[i]).init()
  }
}

document.querySelectorAll(".toggle-additional-vehicle").forEach((element) => {
  element.addEventListener("click", () => {
    if (element.dataset.additionalVehicleSection === "show") {
      document.querySelectorAll(".additional-vehicle-section").forEach((section) => {
        section.classList.add("visible");
      });
      document.querySelectorAll(".no-additional-vehicle-section").forEach((section) => {
        section.classList.remove("visible");
      });
      document.getElementById("vehicle_details_form_additional_vehicle_owned").value = "true";
    } else {
      document.querySelectorAll(".additional-vehicle-section").forEach((section) => {
        section.classList.remove("visible");
      });
      document.querySelectorAll(".no-additional-vehicle-section").forEach((section) => {
        section.classList.add("visible");
      });
      document.getElementById("vehicle_details_form_additional_vehicle_owned").value = "";
    }
  });
});

Rails.start();
initAll();
