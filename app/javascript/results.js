const initResults = () => {
  document.querySelectorAll(".summary-box-link").forEach((link) => {
    link.addEventListener("click", () => {
      const expansionButton = document.querySelector(`#${link.href.split("#")[1]} .govuk-accordion__section-button`);
      if (expansionButton.getAttribute("aria-expanded") === "false") {
        expansionButton.click();
      }
    });
  });

  document.querySelectorAll(".govuk-accordion").forEach((accordion) => {
    const removeRedundantAccessibleNames = () => {
      accordion.querySelectorAll(".govuk-accordion__section-button[aria-label]").forEach((button) => {
        button.removeAttribute("aria-label");
      });
    };

    removeRedundantAccessibleNames();
    accordion.addEventListener("click", removeRedundantAccessibleNames);
  });
}

export default initResults;