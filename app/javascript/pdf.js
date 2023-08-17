const pdfjsLib = require("pdfjs-dist/legacy/build/pdf.js");

const loadPdf = () => {
  const options =   document.querySelector("body").dataset;
  pdfjsLib.GlobalWorkerOptions.workerSrc = options.workerPath;

  const loadingTask = pdfjsLib.getDocument(options.pdfPath);
  let pdfDoc = null;
  let canvas = document.querySelector('#canvas');
  let context = canvas.getContext('2d');
  let container = document.querySelector('#canvas-container');
  let pageNumber = parseInt(options.pageNumber);

  const renderPdfPage = requestedPageNumber => {
    pdfDoc.getPage(requestedPageNumber).then(page => {
      let defaultViewport = page.getViewport({ scale: 1});
      const maxWidth = Math.min(1200, container.clientWidth);
      let scale = maxWidth / defaultViewport.width;
      let viewport = page.getViewport({ scale: scale });

      canvas.height = viewport.height;
      canvas.width = viewport.width;

      page.render({
        canvasContext : context,
        viewport:  viewport
      });
    });
  };

  const renderPreviousPage = () => {
    if(pageNumber === 1){
        return
    }
    pageNumber--;
    renderPdfPage(pageNumber);
  }

  const renderNextPage = () => {
    if(pageNumber >= pdfDoc.numPages){
        return
    }
    pageNumber++;
    renderPdfPage(pageNumber);
  }

  document.querySelector('#prev').addEventListener('click', renderPreviousPage)
  document.querySelector('#next').addEventListener('click', renderNextPage )

  loadingTask.promise.then(doc => {
    pdfDoc = doc;
    renderPdfPage(pageNumber)
  });
}

window.addEventListener('load', loadPdf);