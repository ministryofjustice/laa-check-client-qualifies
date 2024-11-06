(() => {
  // app/javascript/instant-download.js
  var initInstantDownload = () => {
    document.querySelectorAll('[data-module="instant-download"]').forEach((link) => {
      link.click();
    });
  };
  var instant_download_default = initInstantDownload;
})();
//
