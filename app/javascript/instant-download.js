const initInstantDownload = () => {
  document.querySelectorAll('[data-module="instant-download"').forEach((link) => {
    link.click();
  })
}

export default initInstantDownload;
