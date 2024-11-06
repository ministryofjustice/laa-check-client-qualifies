(() => {
  // app/javascript/results.js
  var initResults = () => {
    document.querySelectorAll(".summary-box-link").forEach((link) => {
      link.addEventListener("click", () => {
        const expansionButton = document.querySelector(`#${link.href.split("#")[1]} .govuk-accordion__section-button`);
        if (expansionButton.getAttribute("aria-expanded") === "false") {
          expansionButton.click();
        }
      });
    });
  };
  var results_default = initResults;
})();
//
