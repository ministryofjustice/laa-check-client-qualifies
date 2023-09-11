import "rails_admin/src/rails_admin/base";

document.addEventListener("trix-before-initialize", () => {
  Trix.config.blockAttributes.heading1.tagName = "h3";
  Trix.config.blockAttributes.default.tagName = "p"
})