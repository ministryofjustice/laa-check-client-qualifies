const initChangeLogs = () => {
  hideItems();

  const toggle = document.querySelector('[data-change-log-role="toggle"]')
  toggle.classList.remove(HIDDEN);
  putToggleInCollapsedState(toggle);

  toggle.addEventListener('click', () => {
    if (toggle.dataset.state === COLLAPSED) {
      putToggleInExpandedState(toggle);
      showItems();
    } else {
      putToggleInCollapsedState(toggle);
      hideItems();
    }
  })
};

const putToggleInCollapsedState = (toggle) => {
  toggle.dataset.state = COLLAPSED;
  toggle.textContent = toggle.dataset.showText;
};

const putToggleInExpandedState = (toggle) => {
  toggle.dataset.state = EXPANDED;
  toggle.textContent = toggle.dataset.hideText;
};

const hideItems = () => {
  modifyItems((item) => {
    item.classList.add(HIDDEN);
  })
};

const showItems = () => {
  modifyItems((item) => {
    item.classList.remove(HIDDEN);
  })
};

const modifyItems = (func) => {
  document.querySelectorAll('[data-change-log-role="item"]').forEach(func)
};

const COLLAPSED = "collapsed";
const EXPANDED = "expanded";
const HIDDEN = "hidden";

export default initChangeLogs;