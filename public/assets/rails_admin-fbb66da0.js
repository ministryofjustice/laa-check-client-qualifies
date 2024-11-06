(() => {
  var __create = Object.create;
  var __defProp = Object.defineProperty;
  var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
  var __getOwnPropNames = Object.getOwnPropertyNames;
  var __getProtoOf = Object.getPrototypeOf;
  var __hasOwnProp = Object.prototype.hasOwnProperty;
  var __esm = (fn2, res) => function __init() {
    return fn2 && (res = (0, fn2[__getOwnPropNames(fn2)[0]])(fn2 = 0)), res;
  };
  var __commonJS = (cb, mod) => function __require() {
    return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
  };
  var __export = (target, all) => {
    for (var name in all)
      __defProp(target, name, { get: all[name], enumerable: true });
  };
  var __copyProps = (to, from, except, desc) => {
    if (from && typeof from === "object" || typeof from === "function") {
      for (let key of __getOwnPropNames(from))
        if (!__hasOwnProp.call(to, key) && key !== except)
          __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
    }
    return to;
  };
  var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
    // If the importer is in node compatibility mode or this is not an ESM
    // file that has been converted to a CommonJS file using a Babel-
    // compatible transform (i.e. "__esModule" has not been set), then set
    // "default" to the CommonJS "module.exports" for node compatibility.
    isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
    mod
  ));

  // node_modules/rails_admin/node_modules/@rails/ujs/lib/assets/compiled/rails-ujs.js
  var require_rails_ujs = __commonJS({
    "node_modules/rails_admin/node_modules/@rails/ujs/lib/assets/compiled/rails-ujs.js"(exports, module) {
      (function() {
        var context = this;
        (function() {
          (function() {
            this.Rails = {
              linkClickSelector: "a[data-confirm], a[data-method], a[data-remote]:not([disabled]), a[data-disable-with], a[data-disable]",
              buttonClickSelector: {
                selector: "button[data-remote]:not([form]), button[data-confirm]:not([form])",
                exclude: "form button"
              },
              inputChangeSelector: "select[data-remote], input[data-remote], textarea[data-remote]",
              formSubmitSelector: "form:not([data-turbo=true])",
              formInputClickSelector: "form:not([data-turbo=true]) input[type=submit], form:not([data-turbo=true]) input[type=image], form:not([data-turbo=true]) button[type=submit], form:not([data-turbo=true]) button:not([type]), input[type=submit][form], input[type=image][form], button[type=submit][form], button[form]:not([type])",
              formDisableSelector: "input[data-disable-with]:enabled, button[data-disable-with]:enabled, textarea[data-disable-with]:enabled, input[data-disable]:enabled, button[data-disable]:enabled, textarea[data-disable]:enabled",
              formEnableSelector: "input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled, input[data-disable]:disabled, button[data-disable]:disabled, textarea[data-disable]:disabled",
              fileInputSelector: "input[name][type=file]:not([disabled])",
              linkDisableSelector: "a[data-disable-with], a[data-disable]",
              buttonDisableSelector: "button[data-remote][data-disable-with], button[data-remote][data-disable]"
            };
          }).call(this);
        }).call(context);
        var Rails3 = context.Rails;
        (function() {
          (function() {
            var nonce;
            nonce = null;
            Rails3.loadCSPNonce = function() {
              var ref;
              return nonce = (ref = document.querySelector("meta[name=csp-nonce]")) != null ? ref.content : void 0;
            };
            Rails3.cspNonce = function() {
              return nonce != null ? nonce : Rails3.loadCSPNonce();
            };
          }).call(this);
          (function() {
            var expando, m;
            m = Element.prototype.matches || Element.prototype.matchesSelector || Element.prototype.mozMatchesSelector || Element.prototype.msMatchesSelector || Element.prototype.oMatchesSelector || Element.prototype.webkitMatchesSelector;
            Rails3.matches = function(element, selector) {
              if (selector.exclude != null) {
                return m.call(element, selector.selector) && !m.call(element, selector.exclude);
              } else {
                return m.call(element, selector);
              }
            };
            expando = "_ujsData";
            Rails3.getData = function(element, key) {
              var ref;
              return (ref = element[expando]) != null ? ref[key] : void 0;
            };
            Rails3.setData = function(element, key, value) {
              if (element[expando] == null) {
                element[expando] = {};
              }
              return element[expando][key] = value;
            };
            Rails3.$ = function(selector) {
              return Array.prototype.slice.call(document.querySelectorAll(selector));
            };
          }).call(this);
          (function() {
            var $, csrfParam, csrfToken;
            $ = Rails3.$;
            csrfToken = Rails3.csrfToken = function() {
              var meta;
              meta = document.querySelector("meta[name=csrf-token]");
              return meta && meta.content;
            };
            csrfParam = Rails3.csrfParam = function() {
              var meta;
              meta = document.querySelector("meta[name=csrf-param]");
              return meta && meta.content;
            };
            Rails3.CSRFProtection = function(xhr) {
              var token;
              token = csrfToken();
              if (token != null) {
                return xhr.setRequestHeader("X-CSRF-Token", token);
              }
            };
            Rails3.refreshCSRFTokens = function() {
              var param, token;
              token = csrfToken();
              param = csrfParam();
              if (token != null && param != null) {
                return $('form input[name="' + param + '"]').forEach(function(input) {
                  return input.value = token;
                });
              }
            };
          }).call(this);
          (function() {
            var CustomEvent2, fire, matches, preventDefault;
            matches = Rails3.matches;
            CustomEvent2 = window.CustomEvent;
            if (typeof CustomEvent2 !== "function") {
              CustomEvent2 = function(event, params) {
                var evt;
                evt = document.createEvent("CustomEvent");
                evt.initCustomEvent(event, params.bubbles, params.cancelable, params.detail);
                return evt;
              };
              CustomEvent2.prototype = window.Event.prototype;
              preventDefault = CustomEvent2.prototype.preventDefault;
              CustomEvent2.prototype.preventDefault = function() {
                var result;
                result = preventDefault.call(this);
                if (this.cancelable && !this.defaultPrevented) {
                  Object.defineProperty(this, "defaultPrevented", {
                    get: function() {
                      return true;
                    }
                  });
                }
                return result;
              };
            }
            fire = Rails3.fire = function(obj, name, data) {
              var event;
              event = new CustomEvent2(name, {
                bubbles: true,
                cancelable: true,
                detail: data
              });
              obj.dispatchEvent(event);
              return !event.defaultPrevented;
            };
            Rails3.stopEverything = function(e) {
              fire(e.target, "ujs:everythingStopped");
              e.preventDefault();
              e.stopPropagation();
              return e.stopImmediatePropagation();
            };
            Rails3.delegate = function(element, selector, eventType, handler) {
              return element.addEventListener(eventType, function(e) {
                var target;
                target = e.target;
                while (!(!(target instanceof Element) || matches(target, selector))) {
                  target = target.parentNode;
                }
                if (target instanceof Element && handler.call(target, e) === false) {
                  e.preventDefault();
                  return e.stopPropagation();
                }
              });
            };
          }).call(this);
          (function() {
            var AcceptHeaders, CSRFProtection, createXHR, cspNonce, fire, prepareOptions, processResponse;
            cspNonce = Rails3.cspNonce, CSRFProtection = Rails3.CSRFProtection, fire = Rails3.fire;
            AcceptHeaders = {
              "*": "*/*",
              text: "text/plain",
              html: "text/html",
              xml: "application/xml, text/xml",
              json: "application/json, text/javascript",
              script: "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
            };
            Rails3.ajax = function(options) {
              var xhr;
              options = prepareOptions(options);
              xhr = createXHR(options, function() {
                var ref, response;
                response = processResponse((ref = xhr.response) != null ? ref : xhr.responseText, xhr.getResponseHeader("Content-Type"));
                if (Math.floor(xhr.status / 100) === 2) {
                  if (typeof options.success === "function") {
                    options.success(response, xhr.statusText, xhr);
                  }
                } else {
                  if (typeof options.error === "function") {
                    options.error(response, xhr.statusText, xhr);
                  }
                }
                return typeof options.complete === "function" ? options.complete(xhr, xhr.statusText) : void 0;
              });
              if (options.beforeSend != null && !options.beforeSend(xhr, options)) {
                return false;
              }
              if (xhr.readyState === XMLHttpRequest.OPENED) {
                return xhr.send(options.data);
              }
            };
            prepareOptions = function(options) {
              options.url = options.url || location.href;
              options.type = options.type.toUpperCase();
              if (options.type === "GET" && options.data) {
                if (options.url.indexOf("?") < 0) {
                  options.url += "?" + options.data;
                } else {
                  options.url += "&" + options.data;
                }
              }
              if (AcceptHeaders[options.dataType] == null) {
                options.dataType = "*";
              }
              options.accept = AcceptHeaders[options.dataType];
              if (options.dataType !== "*") {
                options.accept += ", */*; q=0.01";
              }
              return options;
            };
            createXHR = function(options, done) {
              var xhr;
              xhr = new XMLHttpRequest();
              xhr.open(options.type, options.url, true);
              xhr.setRequestHeader("Accept", options.accept);
              if (typeof options.data === "string") {
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
              }
              if (!options.crossDomain) {
                xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
                CSRFProtection(xhr);
              }
              xhr.withCredentials = !!options.withCredentials;
              xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                  return done(xhr);
                }
              };
              return xhr;
            };
            processResponse = function(response, type) {
              var parser, script;
              if (typeof response === "string" && typeof type === "string") {
                if (type.match(/\bjson\b/)) {
                  try {
                    response = JSON.parse(response);
                  } catch (error) {
                  }
                } else if (type.match(/\b(?:java|ecma)script\b/)) {
                  script = document.createElement("script");
                  script.setAttribute("nonce", cspNonce());
                  script.text = response;
                  document.head.appendChild(script).parentNode.removeChild(script);
                } else if (type.match(/\b(xml|html|svg)\b/)) {
                  parser = new DOMParser();
                  type = type.replace(/;.+/, "");
                  try {
                    response = parser.parseFromString(response, type);
                  } catch (error) {
                  }
                }
              }
              return response;
            };
            Rails3.href = function(element) {
              return element.href;
            };
            Rails3.isCrossDomain = function(url) {
              var e, originAnchor, urlAnchor;
              originAnchor = document.createElement("a");
              originAnchor.href = location.href;
              urlAnchor = document.createElement("a");
              try {
                urlAnchor.href = url;
                return !((!urlAnchor.protocol || urlAnchor.protocol === ":") && !urlAnchor.host || originAnchor.protocol + "//" + originAnchor.host === urlAnchor.protocol + "//" + urlAnchor.host);
              } catch (error) {
                e = error;
                return true;
              }
            };
          }).call(this);
          (function() {
            var matches, toArray;
            matches = Rails3.matches;
            toArray = function(e) {
              return Array.prototype.slice.call(e);
            };
            Rails3.serializeElement = function(element, additionalParam) {
              var inputs, params;
              inputs = [element];
              if (matches(element, "form")) {
                inputs = toArray(element.elements);
              }
              params = [];
              inputs.forEach(function(input) {
                if (!input.name || input.disabled) {
                  return;
                }
                if (matches(input, "fieldset[disabled] *")) {
                  return;
                }
                if (matches(input, "select")) {
                  return toArray(input.options).forEach(function(option) {
                    if (option.selected) {
                      return params.push({
                        name: input.name,
                        value: option.value
                      });
                    }
                  });
                } else if (input.checked || ["radio", "checkbox", "submit"].indexOf(input.type) === -1) {
                  return params.push({
                    name: input.name,
                    value: input.value
                  });
                }
              });
              if (additionalParam) {
                params.push(additionalParam);
              }
              return params.map(function(param) {
                if (param.name != null) {
                  return encodeURIComponent(param.name) + "=" + encodeURIComponent(param.value);
                } else {
                  return param;
                }
              }).join("&");
            };
            Rails3.formElements = function(form, selector) {
              if (matches(form, "form")) {
                return toArray(form.elements).filter(function(el) {
                  return matches(el, selector);
                });
              } else {
                return toArray(form.querySelectorAll(selector));
              }
            };
          }).call(this);
          (function() {
            var allowAction, fire, stopEverything;
            fire = Rails3.fire, stopEverything = Rails3.stopEverything;
            Rails3.handleConfirm = function(e) {
              if (!allowAction(this)) {
                return stopEverything(e);
              }
            };
            Rails3.confirm = function(message, element) {
              return confirm(message);
            };
            allowAction = function(element) {
              var answer, callback, message;
              message = element.getAttribute("data-confirm");
              if (!message) {
                return true;
              }
              answer = false;
              if (fire(element, "confirm")) {
                try {
                  answer = Rails3.confirm(message, element);
                } catch (error) {
                }
                callback = fire(element, "confirm:complete", [answer]);
              }
              return answer && callback;
            };
          }).call(this);
          (function() {
            var disableFormElement, disableFormElements, disableLinkElement, enableFormElement, enableFormElements, enableLinkElement, formElements, getData, isXhrRedirect, matches, setData, stopEverything;
            matches = Rails3.matches, getData = Rails3.getData, setData = Rails3.setData, stopEverything = Rails3.stopEverything, formElements = Rails3.formElements;
            Rails3.handleDisabledElement = function(e) {
              var element;
              element = this;
              if (element.disabled) {
                return stopEverything(e);
              }
            };
            Rails3.enableElement = function(e) {
              var element;
              if (e instanceof Event) {
                if (isXhrRedirect(e)) {
                  return;
                }
                element = e.target;
              } else {
                element = e;
              }
              if (matches(element, Rails3.linkDisableSelector)) {
                return enableLinkElement(element);
              } else if (matches(element, Rails3.buttonDisableSelector) || matches(element, Rails3.formEnableSelector)) {
                return enableFormElement(element);
              } else if (matches(element, Rails3.formSubmitSelector)) {
                return enableFormElements(element);
              }
            };
            Rails3.disableElement = function(e) {
              var element;
              element = e instanceof Event ? e.target : e;
              if (matches(element, Rails3.linkDisableSelector)) {
                return disableLinkElement(element);
              } else if (matches(element, Rails3.buttonDisableSelector) || matches(element, Rails3.formDisableSelector)) {
                return disableFormElement(element);
              } else if (matches(element, Rails3.formSubmitSelector)) {
                return disableFormElements(element);
              }
            };
            disableLinkElement = function(element) {
              var replacement;
              if (getData(element, "ujs:disabled")) {
                return;
              }
              replacement = element.getAttribute("data-disable-with");
              if (replacement != null) {
                setData(element, "ujs:enable-with", element.innerHTML);
                element.innerHTML = replacement;
              }
              element.addEventListener("click", stopEverything);
              return setData(element, "ujs:disabled", true);
            };
            enableLinkElement = function(element) {
              var originalText;
              originalText = getData(element, "ujs:enable-with");
              if (originalText != null) {
                element.innerHTML = originalText;
                setData(element, "ujs:enable-with", null);
              }
              element.removeEventListener("click", stopEverything);
              return setData(element, "ujs:disabled", null);
            };
            disableFormElements = function(form) {
              return formElements(form, Rails3.formDisableSelector).forEach(disableFormElement);
            };
            disableFormElement = function(element) {
              var replacement;
              if (getData(element, "ujs:disabled")) {
                return;
              }
              replacement = element.getAttribute("data-disable-with");
              if (replacement != null) {
                if (matches(element, "button")) {
                  setData(element, "ujs:enable-with", element.innerHTML);
                  element.innerHTML = replacement;
                } else {
                  setData(element, "ujs:enable-with", element.value);
                  element.value = replacement;
                }
              }
              element.disabled = true;
              return setData(element, "ujs:disabled", true);
            };
            enableFormElements = function(form) {
              return formElements(form, Rails3.formEnableSelector).forEach(enableFormElement);
            };
            enableFormElement = function(element) {
              var originalText;
              originalText = getData(element, "ujs:enable-with");
              if (originalText != null) {
                if (matches(element, "button")) {
                  element.innerHTML = originalText;
                } else {
                  element.value = originalText;
                }
                setData(element, "ujs:enable-with", null);
              }
              element.disabled = false;
              return setData(element, "ujs:disabled", null);
            };
            isXhrRedirect = function(event) {
              var ref, xhr;
              xhr = (ref = event.detail) != null ? ref[0] : void 0;
              return (xhr != null ? xhr.getResponseHeader("X-Xhr-Redirect") : void 0) != null;
            };
          }).call(this);
          (function() {
            var stopEverything;
            stopEverything = Rails3.stopEverything;
            Rails3.handleMethod = function(e) {
              var csrfParam, csrfToken, form, formContent, href, link, method;
              link = this;
              method = link.getAttribute("data-method");
              if (!method) {
                return;
              }
              href = Rails3.href(link);
              csrfToken = Rails3.csrfToken();
              csrfParam = Rails3.csrfParam();
              form = document.createElement("form");
              formContent = "<input name='_method' value='" + method + "' type='hidden' />";
              if (csrfParam != null && csrfToken != null && !Rails3.isCrossDomain(href)) {
                formContent += "<input name='" + csrfParam + "' value='" + csrfToken + "' type='hidden' />";
              }
              formContent += '<input type="submit" />';
              form.method = "post";
              form.action = href;
              form.target = link.target;
              form.innerHTML = formContent;
              form.style.display = "none";
              document.body.appendChild(form);
              form.querySelector('[type="submit"]').click();
              return stopEverything(e);
            };
          }).call(this);
          (function() {
            var ajax, fire, getData, isCrossDomain, isRemote, matches, serializeElement, setData, stopEverything, slice = [].slice;
            matches = Rails3.matches, getData = Rails3.getData, setData = Rails3.setData, fire = Rails3.fire, stopEverything = Rails3.stopEverything, ajax = Rails3.ajax, isCrossDomain = Rails3.isCrossDomain, serializeElement = Rails3.serializeElement;
            isRemote = function(element) {
              var value;
              value = element.getAttribute("data-remote");
              return value != null && value !== "false";
            };
            Rails3.handleRemote = function(e) {
              var button, data, dataType, element, method, url, withCredentials;
              element = this;
              if (!isRemote(element)) {
                return true;
              }
              if (!fire(element, "ajax:before")) {
                fire(element, "ajax:stopped");
                return false;
              }
              withCredentials = element.getAttribute("data-with-credentials");
              dataType = element.getAttribute("data-type") || "script";
              if (matches(element, Rails3.formSubmitSelector)) {
                button = getData(element, "ujs:submit-button");
                method = getData(element, "ujs:submit-button-formmethod") || element.method;
                url = getData(element, "ujs:submit-button-formaction") || element.getAttribute("action") || location.href;
                if (method.toUpperCase() === "GET") {
                  url = url.replace(/\?.*$/, "");
                }
                if (element.enctype === "multipart/form-data") {
                  data = new FormData(element);
                  if (button != null) {
                    data.append(button.name, button.value);
                  }
                } else {
                  data = serializeElement(element, button);
                }
                setData(element, "ujs:submit-button", null);
                setData(element, "ujs:submit-button-formmethod", null);
                setData(element, "ujs:submit-button-formaction", null);
              } else if (matches(element, Rails3.buttonClickSelector) || matches(element, Rails3.inputChangeSelector)) {
                method = element.getAttribute("data-method");
                url = element.getAttribute("data-url");
                data = serializeElement(element, element.getAttribute("data-params"));
              } else {
                method = element.getAttribute("data-method");
                url = Rails3.href(element);
                data = element.getAttribute("data-params");
              }
              ajax({
                type: method || "GET",
                url,
                data,
                dataType,
                beforeSend: function(xhr, options) {
                  if (fire(element, "ajax:beforeSend", [xhr, options])) {
                    return fire(element, "ajax:send", [xhr]);
                  } else {
                    fire(element, "ajax:stopped");
                    return false;
                  }
                },
                success: function() {
                  var args;
                  args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
                  return fire(element, "ajax:success", args);
                },
                error: function() {
                  var args;
                  args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
                  return fire(element, "ajax:error", args);
                },
                complete: function() {
                  var args;
                  args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
                  return fire(element, "ajax:complete", args);
                },
                crossDomain: isCrossDomain(url),
                withCredentials: withCredentials != null && withCredentials !== "false"
              });
              return stopEverything(e);
            };
            Rails3.formSubmitButtonClick = function(e) {
              var button, form;
              button = this;
              form = button.form;
              if (!form) {
                return;
              }
              if (button.name) {
                setData(form, "ujs:submit-button", {
                  name: button.name,
                  value: button.value
                });
              }
              setData(form, "ujs:formnovalidate-button", button.formNoValidate);
              setData(form, "ujs:submit-button-formaction", button.getAttribute("formaction"));
              return setData(form, "ujs:submit-button-formmethod", button.getAttribute("formmethod"));
            };
            Rails3.preventInsignificantClick = function(e) {
              var data, insignificantMetaClick, link, metaClick, method, nonPrimaryMouseClick;
              link = this;
              method = (link.getAttribute("data-method") || "GET").toUpperCase();
              data = link.getAttribute("data-params");
              metaClick = e.metaKey || e.ctrlKey;
              insignificantMetaClick = metaClick && method === "GET" && !data;
              nonPrimaryMouseClick = e.button != null && e.button !== 0;
              if (nonPrimaryMouseClick || insignificantMetaClick) {
                return e.stopImmediatePropagation();
              }
            };
          }).call(this);
          (function() {
            var $, CSRFProtection, delegate, disableElement, enableElement, fire, formSubmitButtonClick, getData, handleConfirm, handleDisabledElement, handleMethod, handleRemote, loadCSPNonce, preventInsignificantClick, refreshCSRFTokens;
            fire = Rails3.fire, delegate = Rails3.delegate, getData = Rails3.getData, $ = Rails3.$, refreshCSRFTokens = Rails3.refreshCSRFTokens, CSRFProtection = Rails3.CSRFProtection, loadCSPNonce = Rails3.loadCSPNonce, enableElement = Rails3.enableElement, disableElement = Rails3.disableElement, handleDisabledElement = Rails3.handleDisabledElement, handleConfirm = Rails3.handleConfirm, preventInsignificantClick = Rails3.preventInsignificantClick, handleRemote = Rails3.handleRemote, formSubmitButtonClick = Rails3.formSubmitButtonClick, handleMethod = Rails3.handleMethod;
            if (typeof jQuery !== "undefined" && jQuery !== null && jQuery.ajax != null) {
              if (jQuery.rails) {
                throw new Error("If you load both jquery_ujs and rails-ujs, use rails-ujs only.");
              }
              jQuery.rails = Rails3;
              jQuery.ajaxPrefilter(function(options, originalOptions, xhr) {
                if (!options.crossDomain) {
                  return CSRFProtection(xhr);
                }
              });
            }
            Rails3.start = function() {
              if (window._rails_loaded) {
                throw new Error("rails-ujs has already been loaded!");
              }
              window.addEventListener("pageshow", function() {
                $(Rails3.formEnableSelector).forEach(function(el) {
                  if (getData(el, "ujs:disabled")) {
                    return enableElement(el);
                  }
                });
                return $(Rails3.linkDisableSelector).forEach(function(el) {
                  if (getData(el, "ujs:disabled")) {
                    return enableElement(el);
                  }
                });
              });
              delegate(document, Rails3.linkDisableSelector, "ajax:complete", enableElement);
              delegate(document, Rails3.linkDisableSelector, "ajax:stopped", enableElement);
              delegate(document, Rails3.buttonDisableSelector, "ajax:complete", enableElement);
              delegate(document, Rails3.buttonDisableSelector, "ajax:stopped", enableElement);
              delegate(document, Rails3.linkClickSelector, "click", preventInsignificantClick);
              delegate(document, Rails3.linkClickSelector, "click", handleDisabledElement);
              delegate(document, Rails3.linkClickSelector, "click", handleConfirm);
              delegate(document, Rails3.linkClickSelector, "click", disableElement);
              delegate(document, Rails3.linkClickSelector, "click", handleRemote);
              delegate(document, Rails3.linkClickSelector, "click", handleMethod);
              delegate(document, Rails3.buttonClickSelector, "click", preventInsignificantClick);
              delegate(document, Rails3.buttonClickSelector, "click", handleDisabledElement);
              delegate(document, Rails3.buttonClickSelector, "click", handleConfirm);
              delegate(document, Rails3.buttonClickSelector, "click", disableElement);
              delegate(document, Rails3.buttonClickSelector, "click", handleRemote);
              delegate(document, Rails3.inputChangeSelector, "change", handleDisabledElement);
              delegate(document, Rails3.inputChangeSelector, "change", handleConfirm);
              delegate(document, Rails3.inputChangeSelector, "change", handleRemote);
              delegate(document, Rails3.formSubmitSelector, "submit", handleDisabledElement);
              delegate(document, Rails3.formSubmitSelector, "submit", handleConfirm);
              delegate(document, Rails3.formSubmitSelector, "submit", handleRemote);
              delegate(document, Rails3.formSubmitSelector, "submit", function(e) {
                return setTimeout(function() {
                  return disableElement(e);
                }, 13);
              });
              delegate(document, Rails3.formSubmitSelector, "ajax:send", disableElement);
              delegate(document, Rails3.formSubmitSelector, "ajax:complete", enableElement);
              delegate(document, Rails3.formInputClickSelector, "click", preventInsignificantClick);
              delegate(document, Rails3.formInputClickSelector, "click", handleDisabledElement);
              delegate(document, Rails3.formInputClickSelector, "click", handleConfirm);
              delegate(document, Rails3.formInputClickSelector, "click", formSubmitButtonClick);
              document.addEventListener("DOMContentLoaded", refreshCSRFTokens);
              document.addEventListener("DOMContentLoaded", loadCSPNonce);
              return window._rails_loaded = true;
            };
            if (window.Rails === Rails3 && fire(document, "rails:attachBindings")) {
              Rails3.start();
            }
          }).call(this);
        }).call(this);
        if (typeof module === "object" && module.exports) {
          module.exports = Rails3;
        } else if (typeof define === "function" && define.amd) {
          define(Rails3);
        }
      }).call(exports);
    }
  });

  // node_modules/@rails/actioncable/src/adapters.js
  var adapters_default;
  var init_adapters = __esm({
    "node_modules/@rails/actioncable/src/adapters.js"() {
      adapters_default = {
        logger: self.console,
        WebSocket: self.WebSocket
      };
    }
  });

  // node_modules/@rails/actioncable/src/logger.js
  var logger_default;
  var init_logger = __esm({
    "node_modules/@rails/actioncable/src/logger.js"() {
      init_adapters();
      logger_default = {
        log(...messages) {
          if (this.enabled) {
            messages.push(Date.now());
            adapters_default.logger.log("[ActionCable]", ...messages);
          }
        }
      };
    }
  });

  // node_modules/@rails/actioncable/src/connection_monitor.js
  var now, secondsSince, ConnectionMonitor, connection_monitor_default;
  var init_connection_monitor = __esm({
    "node_modules/@rails/actioncable/src/connection_monitor.js"() {
      init_logger();
      now = () => (/* @__PURE__ */ new Date()).getTime();
      secondsSince = (time) => (now() - time) / 1e3;
      ConnectionMonitor = class {
        constructor(connection) {
          this.visibilityDidChange = this.visibilityDidChange.bind(this);
          this.connection = connection;
          this.reconnectAttempts = 0;
        }
        start() {
          if (!this.isRunning()) {
            this.startedAt = now();
            delete this.stoppedAt;
            this.startPolling();
            addEventListener("visibilitychange", this.visibilityDidChange);
            logger_default.log(`ConnectionMonitor started. stale threshold = ${this.constructor.staleThreshold} s`);
          }
        }
        stop() {
          if (this.isRunning()) {
            this.stoppedAt = now();
            this.stopPolling();
            removeEventListener("visibilitychange", this.visibilityDidChange);
            logger_default.log("ConnectionMonitor stopped");
          }
        }
        isRunning() {
          return this.startedAt && !this.stoppedAt;
        }
        recordPing() {
          this.pingedAt = now();
        }
        recordConnect() {
          this.reconnectAttempts = 0;
          this.recordPing();
          delete this.disconnectedAt;
          logger_default.log("ConnectionMonitor recorded connect");
        }
        recordDisconnect() {
          this.disconnectedAt = now();
          logger_default.log("ConnectionMonitor recorded disconnect");
        }
        // Private
        startPolling() {
          this.stopPolling();
          this.poll();
        }
        stopPolling() {
          clearTimeout(this.pollTimeout);
        }
        poll() {
          this.pollTimeout = setTimeout(
            () => {
              this.reconnectIfStale();
              this.poll();
            },
            this.getPollInterval()
          );
        }
        getPollInterval() {
          const { staleThreshold, reconnectionBackoffRate } = this.constructor;
          const backoff = Math.pow(1 + reconnectionBackoffRate, Math.min(this.reconnectAttempts, 10));
          const jitterMax = this.reconnectAttempts === 0 ? 1 : reconnectionBackoffRate;
          const jitter = jitterMax * Math.random();
          return staleThreshold * 1e3 * backoff * (1 + jitter);
        }
        reconnectIfStale() {
          if (this.connectionIsStale()) {
            logger_default.log(`ConnectionMonitor detected stale connection. reconnectAttempts = ${this.reconnectAttempts}, time stale = ${secondsSince(this.refreshedAt)} s, stale threshold = ${this.constructor.staleThreshold} s`);
            this.reconnectAttempts++;
            if (this.disconnectedRecently()) {
              logger_default.log(`ConnectionMonitor skipping reopening recent disconnect. time disconnected = ${secondsSince(this.disconnectedAt)} s`);
            } else {
              logger_default.log("ConnectionMonitor reopening");
              this.connection.reopen();
            }
          }
        }
        get refreshedAt() {
          return this.pingedAt ? this.pingedAt : this.startedAt;
        }
        connectionIsStale() {
          return secondsSince(this.refreshedAt) > this.constructor.staleThreshold;
        }
        disconnectedRecently() {
          return this.disconnectedAt && secondsSince(this.disconnectedAt) < this.constructor.staleThreshold;
        }
        visibilityDidChange() {
          if (document.visibilityState === "visible") {
            setTimeout(
              () => {
                if (this.connectionIsStale() || !this.connection.isOpen()) {
                  logger_default.log(`ConnectionMonitor reopening stale connection on visibilitychange. visibilityState = ${document.visibilityState}`);
                  this.connection.reopen();
                }
              },
              200
            );
          }
        }
      };
      ConnectionMonitor.staleThreshold = 6;
      ConnectionMonitor.reconnectionBackoffRate = 0.15;
      connection_monitor_default = ConnectionMonitor;
    }
  });

  // node_modules/@rails/actioncable/src/internal.js
  var internal_default;
  var init_internal = __esm({
    "node_modules/@rails/actioncable/src/internal.js"() {
      internal_default = {
        "message_types": {
          "welcome": "welcome",
          "disconnect": "disconnect",
          "ping": "ping",
          "confirmation": "confirm_subscription",
          "rejection": "reject_subscription"
        },
        "disconnect_reasons": {
          "unauthorized": "unauthorized",
          "invalid_request": "invalid_request",
          "server_restart": "server_restart"
        },
        "default_mount_path": "/cable",
        "protocols": [
          "actioncable-v1-json",
          "actioncable-unsupported"
        ]
      };
    }
  });

  // node_modules/@rails/actioncable/src/connection.js
  var message_types, protocols, supportedProtocols, indexOf, Connection, connection_default;
  var init_connection = __esm({
    "node_modules/@rails/actioncable/src/connection.js"() {
      init_adapters();
      init_connection_monitor();
      init_internal();
      init_logger();
      ({ message_types, protocols } = internal_default);
      supportedProtocols = protocols.slice(0, protocols.length - 1);
      indexOf = [].indexOf;
      Connection = class {
        constructor(consumer2) {
          this.open = this.open.bind(this);
          this.consumer = consumer2;
          this.subscriptions = this.consumer.subscriptions;
          this.monitor = new connection_monitor_default(this);
          this.disconnected = true;
        }
        send(data) {
          if (this.isOpen()) {
            this.webSocket.send(JSON.stringify(data));
            return true;
          } else {
            return false;
          }
        }
        open() {
          if (this.isActive()) {
            logger_default.log(`Attempted to open WebSocket, but existing socket is ${this.getState()}`);
            return false;
          } else {
            logger_default.log(`Opening WebSocket, current state is ${this.getState()}, subprotocols: ${protocols}`);
            if (this.webSocket) {
              this.uninstallEventHandlers();
            }
            this.webSocket = new adapters_default.WebSocket(this.consumer.url, protocols);
            this.installEventHandlers();
            this.monitor.start();
            return true;
          }
        }
        close({ allowReconnect } = { allowReconnect: true }) {
          if (!allowReconnect) {
            this.monitor.stop();
          }
          if (this.isOpen()) {
            return this.webSocket.close();
          }
        }
        reopen() {
          logger_default.log(`Reopening WebSocket, current state is ${this.getState()}`);
          if (this.isActive()) {
            try {
              return this.close();
            } catch (error) {
              logger_default.log("Failed to reopen WebSocket", error);
            } finally {
              logger_default.log(`Reopening WebSocket in ${this.constructor.reopenDelay}ms`);
              setTimeout(this.open, this.constructor.reopenDelay);
            }
          } else {
            return this.open();
          }
        }
        getProtocol() {
          if (this.webSocket) {
            return this.webSocket.protocol;
          }
        }
        isOpen() {
          return this.isState("open");
        }
        isActive() {
          return this.isState("open", "connecting");
        }
        // Private
        isProtocolSupported() {
          return indexOf.call(supportedProtocols, this.getProtocol()) >= 0;
        }
        isState(...states) {
          return indexOf.call(states, this.getState()) >= 0;
        }
        getState() {
          if (this.webSocket) {
            for (let state in adapters_default.WebSocket) {
              if (adapters_default.WebSocket[state] === this.webSocket.readyState) {
                return state.toLowerCase();
              }
            }
          }
          return null;
        }
        installEventHandlers() {
          for (let eventName in this.events) {
            const handler = this.events[eventName].bind(this);
            this.webSocket[`on${eventName}`] = handler;
          }
        }
        uninstallEventHandlers() {
          for (let eventName in this.events) {
            this.webSocket[`on${eventName}`] = function() {
            };
          }
        }
      };
      Connection.reopenDelay = 500;
      Connection.prototype.events = {
        message(event) {
          if (!this.isProtocolSupported()) {
            return;
          }
          const { identifier, message, reason, reconnect, type } = JSON.parse(event.data);
          switch (type) {
            case message_types.welcome:
              this.monitor.recordConnect();
              return this.subscriptions.reload();
            case message_types.disconnect:
              logger_default.log(`Disconnecting. Reason: ${reason}`);
              return this.close({ allowReconnect: reconnect });
            case message_types.ping:
              return this.monitor.recordPing();
            case message_types.confirmation:
              this.subscriptions.confirmSubscription(identifier);
              return this.subscriptions.notify(identifier, "connected");
            case message_types.rejection:
              return this.subscriptions.reject(identifier);
            default:
              return this.subscriptions.notify(identifier, "received", message);
          }
        },
        open() {
          logger_default.log(`WebSocket onopen event, using '${this.getProtocol()}' subprotocol`);
          this.disconnected = false;
          if (!this.isProtocolSupported()) {
            logger_default.log("Protocol is unsupported. Stopping monitor and disconnecting.");
            return this.close({ allowReconnect: false });
          }
        },
        close(event) {
          logger_default.log("WebSocket onclose event");
          if (this.disconnected) {
            return;
          }
          this.disconnected = true;
          this.monitor.recordDisconnect();
          return this.subscriptions.notifyAll("disconnected", { willAttemptReconnect: this.monitor.isRunning() });
        },
        error() {
          logger_default.log("WebSocket onerror event");
        }
      };
      connection_default = Connection;
    }
  });

  // node_modules/@rails/actioncable/src/subscription.js
  var extend, Subscription;
  var init_subscription = __esm({
    "node_modules/@rails/actioncable/src/subscription.js"() {
      extend = function(object, properties) {
        if (properties != null) {
          for (let key in properties) {
            const value = properties[key];
            object[key] = value;
          }
        }
        return object;
      };
      Subscription = class {
        constructor(consumer2, params = {}, mixin) {
          this.consumer = consumer2;
          this.identifier = JSON.stringify(params);
          extend(this, mixin);
        }
        // Perform a channel action with the optional data passed as an attribute
        perform(action, data = {}) {
          data.action = action;
          return this.send(data);
        }
        send(data) {
          return this.consumer.send({ command: "message", identifier: this.identifier, data: JSON.stringify(data) });
        }
        unsubscribe() {
          return this.consumer.subscriptions.remove(this);
        }
      };
    }
  });

  // node_modules/@rails/actioncable/src/subscription_guarantor.js
  var SubscriptionGuarantor, subscription_guarantor_default;
  var init_subscription_guarantor = __esm({
    "node_modules/@rails/actioncable/src/subscription_guarantor.js"() {
      init_logger();
      SubscriptionGuarantor = class {
        constructor(subscriptions) {
          this.subscriptions = subscriptions;
          this.pendingSubscriptions = [];
        }
        guarantee(subscription) {
          if (this.pendingSubscriptions.indexOf(subscription) == -1) {
            logger_default.log(`SubscriptionGuarantor guaranteeing ${subscription.identifier}`);
            this.pendingSubscriptions.push(subscription);
          } else {
            logger_default.log(`SubscriptionGuarantor already guaranteeing ${subscription.identifier}`);
          }
          this.startGuaranteeing();
        }
        forget(subscription) {
          logger_default.log(`SubscriptionGuarantor forgetting ${subscription.identifier}`);
          this.pendingSubscriptions = this.pendingSubscriptions.filter((s) => s !== subscription);
        }
        startGuaranteeing() {
          this.stopGuaranteeing();
          this.retrySubscribing();
        }
        stopGuaranteeing() {
          clearTimeout(this.retryTimeout);
        }
        retrySubscribing() {
          this.retryTimeout = setTimeout(
            () => {
              if (this.subscriptions && typeof this.subscriptions.subscribe === "function") {
                this.pendingSubscriptions.map((subscription) => {
                  logger_default.log(`SubscriptionGuarantor resubscribing ${subscription.identifier}`);
                  this.subscriptions.subscribe(subscription);
                });
              }
            },
            500
          );
        }
      };
      subscription_guarantor_default = SubscriptionGuarantor;
    }
  });

  // node_modules/@rails/actioncable/src/subscriptions.js
  var Subscriptions;
  var init_subscriptions = __esm({
    "node_modules/@rails/actioncable/src/subscriptions.js"() {
      init_subscription();
      init_subscription_guarantor();
      init_logger();
      Subscriptions = class {
        constructor(consumer2) {
          this.consumer = consumer2;
          this.guarantor = new subscription_guarantor_default(this);
          this.subscriptions = [];
        }
        create(channelName, mixin) {
          const channel = channelName;
          const params = typeof channel === "object" ? channel : { channel };
          const subscription = new Subscription(this.consumer, params, mixin);
          return this.add(subscription);
        }
        // Private
        add(subscription) {
          this.subscriptions.push(subscription);
          this.consumer.ensureActiveConnection();
          this.notify(subscription, "initialized");
          this.subscribe(subscription);
          return subscription;
        }
        remove(subscription) {
          this.forget(subscription);
          if (!this.findAll(subscription.identifier).length) {
            this.sendCommand(subscription, "unsubscribe");
          }
          return subscription;
        }
        reject(identifier) {
          return this.findAll(identifier).map((subscription) => {
            this.forget(subscription);
            this.notify(subscription, "rejected");
            return subscription;
          });
        }
        forget(subscription) {
          this.guarantor.forget(subscription);
          this.subscriptions = this.subscriptions.filter((s) => s !== subscription);
          return subscription;
        }
        findAll(identifier) {
          return this.subscriptions.filter((s) => s.identifier === identifier);
        }
        reload() {
          return this.subscriptions.map((subscription) => this.subscribe(subscription));
        }
        notifyAll(callbackName, ...args) {
          return this.subscriptions.map((subscription) => this.notify(subscription, callbackName, ...args));
        }
        notify(subscription, callbackName, ...args) {
          let subscriptions;
          if (typeof subscription === "string") {
            subscriptions = this.findAll(subscription);
          } else {
            subscriptions = [subscription];
          }
          return subscriptions.map((subscription2) => typeof subscription2[callbackName] === "function" ? subscription2[callbackName](...args) : void 0);
        }
        subscribe(subscription) {
          if (this.sendCommand(subscription, "subscribe")) {
            this.guarantor.guarantee(subscription);
          }
        }
        confirmSubscription(identifier) {
          logger_default.log(`Subscription confirmed ${identifier}`);
          this.findAll(identifier).map((subscription) => this.guarantor.forget(subscription));
        }
        sendCommand(subscription, command) {
          const { identifier } = subscription;
          return this.consumer.send({ command, identifier });
        }
      };
    }
  });

  // node_modules/@rails/actioncable/src/consumer.js
  function createWebSocketURL(url) {
    if (typeof url === "function") {
      url = url();
    }
    if (url && !/^wss?:/i.test(url)) {
      const a = document.createElement("a");
      a.href = url;
      a.href = a.href;
      a.protocol = a.protocol.replace("http", "ws");
      return a.href;
    } else {
      return url;
    }
  }
  var Consumer;
  var init_consumer = __esm({
    "node_modules/@rails/actioncable/src/consumer.js"() {
      init_connection();
      init_subscriptions();
      Consumer = class {
        constructor(url) {
          this._url = url;
          this.subscriptions = new Subscriptions(this);
          this.connection = new connection_default(this);
        }
        get url() {
          return createWebSocketURL(this._url);
        }
        send(data) {
          return this.connection.send(data);
        }
        connect() {
          return this.connection.open();
        }
        disconnect() {
          return this.connection.close({ allowReconnect: false });
        }
        ensureActiveConnection() {
          if (!this.connection.isActive()) {
            return this.connection.open();
          }
        }
      };
    }
  });

  // node_modules/@rails/actioncable/src/index.js
  var src_exports = {};
  __export(src_exports, {
    Connection: () => connection_default,
    ConnectionMonitor: () => connection_monitor_default,
    Consumer: () => Consumer,
    INTERNAL: () => internal_default,
    Subscription: () => Subscription,
    SubscriptionGuarantor: () => subscription_guarantor_default,
    Subscriptions: () => Subscriptions,
    adapters: () => adapters_default,
    createConsumer: () => createConsumer,
    createWebSocketURL: () => createWebSocketURL,
    getConfig: () => getConfig,
    logger: () => logger_default
  });
  function createConsumer(url = getConfig("url") || internal_default.default_mount_path) {
    return new Consumer(url);
  }
  function getConfig(name) {
    const element = document.head.querySelector(`meta[name='action-cable-${name}']`);
    if (element) {
      return element.getAttribute("content");
    }
  }
  var init_src = __esm({
    "node_modules/@rails/actioncable/src/index.js"() {
      init_connection();
      init_connection_monitor();
      init_consumer();
      init_internal();
      init_subscription();
      init_subscriptions();
      init_subscription_guarantor();
      init_adapters();
      init_logger();
    }
  });

  // node_modules/jquery/dist/jquery.js
  var require_jquery = __commonJS({
    "node_modules/jquery/dist/jquery.js"(exports, module) {
      (function(global, factory) {
        "use strict";
        if (typeof module === "object" && typeof module.exports === "object") {
          module.exports = global.document ? factory(global, true) : function(w) {
            if (!w.document) {
              throw new Error("jQuery requires a window with a document");
            }
            return factory(w);
          };
        } else {
          factory(global);
        }
      })(typeof window !== "undefined" ? window : exports, function(window2, noGlobal) {
        "use strict";
        var arr = [];
        var getProto = Object.getPrototypeOf;
        var slice = arr.slice;
        var flat = arr.flat ? function(array) {
          return arr.flat.call(array);
        } : function(array) {
          return arr.concat.apply([], array);
        };
        var push = arr.push;
        var indexOf2 = arr.indexOf;
        var class2type = {};
        var toString = class2type.toString;
        var hasOwn = class2type.hasOwnProperty;
        var fnToString = hasOwn.toString;
        var ObjectFunctionString = fnToString.call(Object);
        var support = {};
        var isFunction = function isFunction2(obj) {
          return typeof obj === "function" && typeof obj.nodeType !== "number" && typeof obj.item !== "function";
        };
        var isWindow = function isWindow2(obj) {
          return obj != null && obj === obj.window;
        };
        var document2 = window2.document;
        var preservedScriptAttributes = {
          type: true,
          src: true,
          nonce: true,
          noModule: true
        };
        function DOMEval(code, node, doc) {
          doc = doc || document2;
          var i, val, script = doc.createElement("script");
          script.text = code;
          if (node) {
            for (i in preservedScriptAttributes) {
              val = node[i] || node.getAttribute && node.getAttribute(i);
              if (val) {
                script.setAttribute(i, val);
              }
            }
          }
          doc.head.appendChild(script).parentNode.removeChild(script);
        }
        function toType2(obj) {
          if (obj == null) {
            return obj + "";
          }
          return typeof obj === "object" || typeof obj === "function" ? class2type[toString.call(obj)] || "object" : typeof obj;
        }
        var version = "3.7.1", rhtmlSuffix = /HTML$/i, jQuery12 = function(selector, context) {
          return new jQuery12.fn.init(selector, context);
        };
        jQuery12.fn = jQuery12.prototype = {
          // The current version of jQuery being used
          jquery: version,
          constructor: jQuery12,
          // The default length of a jQuery object is 0
          length: 0,
          toArray: function() {
            return slice.call(this);
          },
          // Get the Nth element in the matched element set OR
          // Get the whole matched element set as a clean array
          get: function(num) {
            if (num == null) {
              return slice.call(this);
            }
            return num < 0 ? this[num + this.length] : this[num];
          },
          // Take an array of elements and push it onto the stack
          // (returning the new matched element set)
          pushStack: function(elems) {
            var ret = jQuery12.merge(this.constructor(), elems);
            ret.prevObject = this;
            return ret;
          },
          // Execute a callback for every element in the matched set.
          each: function(callback) {
            return jQuery12.each(this, callback);
          },
          map: function(callback) {
            return this.pushStack(jQuery12.map(this, function(elem, i) {
              return callback.call(elem, i, elem);
            }));
          },
          slice: function() {
            return this.pushStack(slice.apply(this, arguments));
          },
          first: function() {
            return this.eq(0);
          },
          last: function() {
            return this.eq(-1);
          },
          even: function() {
            return this.pushStack(jQuery12.grep(this, function(_elem, i) {
              return (i + 1) % 2;
            }));
          },
          odd: function() {
            return this.pushStack(jQuery12.grep(this, function(_elem, i) {
              return i % 2;
            }));
          },
          eq: function(i) {
            var len = this.length, j = +i + (i < 0 ? len : 0);
            return this.pushStack(j >= 0 && j < len ? [this[j]] : []);
          },
          end: function() {
            return this.prevObject || this.constructor();
          },
          // For internal use only.
          // Behaves like an Array's method, not like a jQuery method.
          push,
          sort: arr.sort,
          splice: arr.splice
        };
        jQuery12.extend = jQuery12.fn.extend = function() {
          var options, name, src, copy, copyIsArray, clone, target = arguments[0] || {}, i = 1, length = arguments.length, deep = false;
          if (typeof target === "boolean") {
            deep = target;
            target = arguments[i] || {};
            i++;
          }
          if (typeof target !== "object" && !isFunction(target)) {
            target = {};
          }
          if (i === length) {
            target = this;
            i--;
          }
          for (; i < length; i++) {
            if ((options = arguments[i]) != null) {
              for (name in options) {
                copy = options[name];
                if (name === "__proto__" || target === copy) {
                  continue;
                }
                if (deep && copy && (jQuery12.isPlainObject(copy) || (copyIsArray = Array.isArray(copy)))) {
                  src = target[name];
                  if (copyIsArray && !Array.isArray(src)) {
                    clone = [];
                  } else if (!copyIsArray && !jQuery12.isPlainObject(src)) {
                    clone = {};
                  } else {
                    clone = src;
                  }
                  copyIsArray = false;
                  target[name] = jQuery12.extend(deep, clone, copy);
                } else if (copy !== void 0) {
                  target[name] = copy;
                }
              }
            }
          }
          return target;
        };
        jQuery12.extend({
          // Unique for each copy of jQuery on the page
          expando: "jQuery" + (version + Math.random()).replace(/\D/g, ""),
          // Assume jQuery is ready without the ready module
          isReady: true,
          error: function(msg) {
            throw new Error(msg);
          },
          noop: function() {
          },
          isPlainObject: function(obj) {
            var proto, Ctor;
            if (!obj || toString.call(obj) !== "[object Object]") {
              return false;
            }
            proto = getProto(obj);
            if (!proto) {
              return true;
            }
            Ctor = hasOwn.call(proto, "constructor") && proto.constructor;
            return typeof Ctor === "function" && fnToString.call(Ctor) === ObjectFunctionString;
          },
          isEmptyObject: function(obj) {
            var name;
            for (name in obj) {
              return false;
            }
            return true;
          },
          // Evaluates a script in a provided context; falls back to the global one
          // if not specified.
          globalEval: function(code, options, doc) {
            DOMEval(code, { nonce: options && options.nonce }, doc);
          },
          each: function(obj, callback) {
            var length, i = 0;
            if (isArrayLike(obj)) {
              length = obj.length;
              for (; i < length; i++) {
                if (callback.call(obj[i], i, obj[i]) === false) {
                  break;
                }
              }
            } else {
              for (i in obj) {
                if (callback.call(obj[i], i, obj[i]) === false) {
                  break;
                }
              }
            }
            return obj;
          },
          // Retrieve the text value of an array of DOM nodes
          text: function(elem) {
            var node, ret = "", i = 0, nodeType = elem.nodeType;
            if (!nodeType) {
              while (node = elem[i++]) {
                ret += jQuery12.text(node);
              }
            }
            if (nodeType === 1 || nodeType === 11) {
              return elem.textContent;
            }
            if (nodeType === 9) {
              return elem.documentElement.textContent;
            }
            if (nodeType === 3 || nodeType === 4) {
              return elem.nodeValue;
            }
            return ret;
          },
          // results is for internal usage only
          makeArray: function(arr2, results) {
            var ret = results || [];
            if (arr2 != null) {
              if (isArrayLike(Object(arr2))) {
                jQuery12.merge(
                  ret,
                  typeof arr2 === "string" ? [arr2] : arr2
                );
              } else {
                push.call(ret, arr2);
              }
            }
            return ret;
          },
          inArray: function(elem, arr2, i) {
            return arr2 == null ? -1 : indexOf2.call(arr2, elem, i);
          },
          isXMLDoc: function(elem) {
            var namespace = elem && elem.namespaceURI, docElem = elem && (elem.ownerDocument || elem).documentElement;
            return !rhtmlSuffix.test(namespace || docElem && docElem.nodeName || "HTML");
          },
          // Support: Android <=4.0 only, PhantomJS 1 only
          // push.apply(_, arraylike) throws on ancient WebKit
          merge: function(first, second) {
            var len = +second.length, j = 0, i = first.length;
            for (; j < len; j++) {
              first[i++] = second[j];
            }
            first.length = i;
            return first;
          },
          grep: function(elems, callback, invert) {
            var callbackInverse, matches = [], i = 0, length = elems.length, callbackExpect = !invert;
            for (; i < length; i++) {
              callbackInverse = !callback(elems[i], i);
              if (callbackInverse !== callbackExpect) {
                matches.push(elems[i]);
              }
            }
            return matches;
          },
          // arg is for internal usage only
          map: function(elems, callback, arg) {
            var length, value, i = 0, ret = [];
            if (isArrayLike(elems)) {
              length = elems.length;
              for (; i < length; i++) {
                value = callback(elems[i], i, arg);
                if (value != null) {
                  ret.push(value);
                }
              }
            } else {
              for (i in elems) {
                value = callback(elems[i], i, arg);
                if (value != null) {
                  ret.push(value);
                }
              }
            }
            return flat(ret);
          },
          // A global GUID counter for objects
          guid: 1,
          // jQuery.support is not used in Core but other projects attach their
          // properties to it so it needs to exist.
          support
        });
        if (typeof Symbol === "function") {
          jQuery12.fn[Symbol.iterator] = arr[Symbol.iterator];
        }
        jQuery12.each(
          "Boolean Number String Function Array Date RegExp Object Error Symbol".split(" "),
          function(_i, name) {
            class2type["[object " + name + "]"] = name.toLowerCase();
          }
        );
        function isArrayLike(obj) {
          var length = !!obj && "length" in obj && obj.length, type = toType2(obj);
          if (isFunction(obj) || isWindow(obj)) {
            return false;
          }
          return type === "array" || length === 0 || typeof length === "number" && length > 0 && length - 1 in obj;
        }
        function nodeName(elem, name) {
          return elem.nodeName && elem.nodeName.toLowerCase() === name.toLowerCase();
        }
        var pop = arr.pop;
        var sort = arr.sort;
        var splice = arr.splice;
        var whitespace = "[\\x20\\t\\r\\n\\f]";
        var rtrimCSS = new RegExp(
          "^" + whitespace + "+|((?:^|[^\\\\])(?:\\\\.)*)" + whitespace + "+$",
          "g"
        );
        jQuery12.contains = function(a, b) {
          var bup = b && b.parentNode;
          return a === bup || !!(bup && bup.nodeType === 1 && // Support: IE 9 - 11+
          // IE doesn't have `contains` on SVG.
          (a.contains ? a.contains(bup) : a.compareDocumentPosition && a.compareDocumentPosition(bup) & 16));
        };
        var rcssescape = /([\0-\x1f\x7f]|^-?\d)|^-$|[^\x80-\uFFFF\w-]/g;
        function fcssescape(ch, asCodePoint) {
          if (asCodePoint) {
            if (ch === "\0") {
              return "\uFFFD";
            }
            return ch.slice(0, -1) + "\\" + ch.charCodeAt(ch.length - 1).toString(16) + " ";
          }
          return "\\" + ch;
        }
        jQuery12.escapeSelector = function(sel) {
          return (sel + "").replace(rcssescape, fcssescape);
        };
        var preferredDoc = document2, pushNative = push;
        (function() {
          var i, Expr, outermostContext, sortInput, hasDuplicate, push2 = pushNative, document3, documentElement2, documentIsHTML, rbuggyQSA, matches, expando = jQuery12.expando, dirruns = 0, done = 0, classCache = createCache(), tokenCache = createCache(), compilerCache = createCache(), nonnativeSelectorCache = createCache(), sortOrder = function(a, b) {
            if (a === b) {
              hasDuplicate = true;
            }
            return 0;
          }, booleans = "checked|selected|async|autofocus|autoplay|controls|defer|disabled|hidden|ismap|loop|multiple|open|readonly|required|scoped", identifier = "(?:\\\\[\\da-fA-F]{1,6}" + whitespace + "?|\\\\[^\\r\\n\\f]|[\\w-]|[^\0-\\x7f])+", attributes = "\\[" + whitespace + "*(" + identifier + ")(?:" + whitespace + // Operator (capture 2)
          "*([*^$|!~]?=)" + whitespace + // "Attribute values must be CSS identifiers [capture 5] or strings [capture 3 or capture 4]"
          `*(?:'((?:\\\\.|[^\\\\'])*)'|"((?:\\\\.|[^\\\\"])*)"|(` + identifier + "))|)" + whitespace + "*\\]", pseudos = ":(" + identifier + `)(?:\\((('((?:\\\\.|[^\\\\'])*)'|"((?:\\\\.|[^\\\\"])*)")|((?:\\\\.|[^\\\\()[\\]]|` + attributes + ")*)|.*)\\)|)", rwhitespace = new RegExp(whitespace + "+", "g"), rcomma = new RegExp("^" + whitespace + "*," + whitespace + "*"), rleadingCombinator = new RegExp("^" + whitespace + "*([>+~]|" + whitespace + ")" + whitespace + "*"), rdescend = new RegExp(whitespace + "|>"), rpseudo = new RegExp(pseudos), ridentifier = new RegExp("^" + identifier + "$"), matchExpr = {
            ID: new RegExp("^#(" + identifier + ")"),
            CLASS: new RegExp("^\\.(" + identifier + ")"),
            TAG: new RegExp("^(" + identifier + "|[*])"),
            ATTR: new RegExp("^" + attributes),
            PSEUDO: new RegExp("^" + pseudos),
            CHILD: new RegExp(
              "^:(only|first|last|nth|nth-last)-(child|of-type)(?:\\(" + whitespace + "*(even|odd|(([+-]|)(\\d*)n|)" + whitespace + "*(?:([+-]|)" + whitespace + "*(\\d+)|))" + whitespace + "*\\)|)",
              "i"
            ),
            bool: new RegExp("^(?:" + booleans + ")$", "i"),
            // For use in libraries implementing .is()
            // We use this for POS matching in `select`
            needsContext: new RegExp("^" + whitespace + "*[>+~]|:(even|odd|eq|gt|lt|nth|first|last)(?:\\(" + whitespace + "*((?:-\\d)?\\d*)" + whitespace + "*\\)|)(?=[^-]|$)", "i")
          }, rinputs = /^(?:input|select|textarea|button)$/i, rheader = /^h\d$/i, rquickExpr2 = /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/, rsibling = /[+~]/, runescape = new RegExp("\\\\[\\da-fA-F]{1,6}" + whitespace + "?|\\\\([^\\r\\n\\f])", "g"), funescape = function(escape, nonHex) {
            var high = "0x" + escape.slice(1) - 65536;
            if (nonHex) {
              return nonHex;
            }
            return high < 0 ? String.fromCharCode(high + 65536) : String.fromCharCode(high >> 10 | 55296, high & 1023 | 56320);
          }, unloadHandler = function() {
            setDocument();
          }, inDisabledFieldset = addCombinator(
            function(elem) {
              return elem.disabled === true && nodeName(elem, "fieldset");
            },
            { dir: "parentNode", next: "legend" }
          );
          function safeActiveElement() {
            try {
              return document3.activeElement;
            } catch (err) {
            }
          }
          try {
            push2.apply(
              arr = slice.call(preferredDoc.childNodes),
              preferredDoc.childNodes
            );
            arr[preferredDoc.childNodes.length].nodeType;
          } catch (e) {
            push2 = {
              apply: function(target, els) {
                pushNative.apply(target, slice.call(els));
              },
              call: function(target) {
                pushNative.apply(target, slice.call(arguments, 1));
              }
            };
          }
          function find(selector, context, results, seed) {
            var m, i2, elem, nid, match, groups, newSelector, newContext = context && context.ownerDocument, nodeType = context ? context.nodeType : 9;
            results = results || [];
            if (typeof selector !== "string" || !selector || nodeType !== 1 && nodeType !== 9 && nodeType !== 11) {
              return results;
            }
            if (!seed) {
              setDocument(context);
              context = context || document3;
              if (documentIsHTML) {
                if (nodeType !== 11 && (match = rquickExpr2.exec(selector))) {
                  if (m = match[1]) {
                    if (nodeType === 9) {
                      if (elem = context.getElementById(m)) {
                        if (elem.id === m) {
                          push2.call(results, elem);
                          return results;
                        }
                      } else {
                        return results;
                      }
                    } else {
                      if (newContext && (elem = newContext.getElementById(m)) && find.contains(context, elem) && elem.id === m) {
                        push2.call(results, elem);
                        return results;
                      }
                    }
                  } else if (match[2]) {
                    push2.apply(results, context.getElementsByTagName(selector));
                    return results;
                  } else if ((m = match[3]) && context.getElementsByClassName) {
                    push2.apply(results, context.getElementsByClassName(m));
                    return results;
                  }
                }
                if (!nonnativeSelectorCache[selector + " "] && (!rbuggyQSA || !rbuggyQSA.test(selector))) {
                  newSelector = selector;
                  newContext = context;
                  if (nodeType === 1 && (rdescend.test(selector) || rleadingCombinator.test(selector))) {
                    newContext = rsibling.test(selector) && testContext(context.parentNode) || context;
                    if (newContext != context || !support.scope) {
                      if (nid = context.getAttribute("id")) {
                        nid = jQuery12.escapeSelector(nid);
                      } else {
                        context.setAttribute("id", nid = expando);
                      }
                    }
                    groups = tokenize(selector);
                    i2 = groups.length;
                    while (i2--) {
                      groups[i2] = (nid ? "#" + nid : ":scope") + " " + toSelector(groups[i2]);
                    }
                    newSelector = groups.join(",");
                  }
                  try {
                    push2.apply(
                      results,
                      newContext.querySelectorAll(newSelector)
                    );
                    return results;
                  } catch (qsaError) {
                    nonnativeSelectorCache(selector, true);
                  } finally {
                    if (nid === expando) {
                      context.removeAttribute("id");
                    }
                  }
                }
              }
            }
            return select(selector.replace(rtrimCSS, "$1"), context, results, seed);
          }
          function createCache() {
            var keys = [];
            function cache2(key, value) {
              if (keys.push(key + " ") > Expr.cacheLength) {
                delete cache2[keys.shift()];
              }
              return cache2[key + " "] = value;
            }
            return cache2;
          }
          function markFunction(fn2) {
            fn2[expando] = true;
            return fn2;
          }
          function assert(fn2) {
            var el = document3.createElement("fieldset");
            try {
              return !!fn2(el);
            } catch (e) {
              return false;
            } finally {
              if (el.parentNode) {
                el.parentNode.removeChild(el);
              }
              el = null;
            }
          }
          function createInputPseudo(type) {
            return function(elem) {
              return nodeName(elem, "input") && elem.type === type;
            };
          }
          function createButtonPseudo(type) {
            return function(elem) {
              return (nodeName(elem, "input") || nodeName(elem, "button")) && elem.type === type;
            };
          }
          function createDisabledPseudo(disabled) {
            return function(elem) {
              if ("form" in elem) {
                if (elem.parentNode && elem.disabled === false) {
                  if ("label" in elem) {
                    if ("label" in elem.parentNode) {
                      return elem.parentNode.disabled === disabled;
                    } else {
                      return elem.disabled === disabled;
                    }
                  }
                  return elem.isDisabled === disabled || // Where there is no isDisabled, check manually
                  elem.isDisabled !== !disabled && inDisabledFieldset(elem) === disabled;
                }
                return elem.disabled === disabled;
              } else if ("label" in elem) {
                return elem.disabled === disabled;
              }
              return false;
            };
          }
          function createPositionalPseudo(fn2) {
            return markFunction(function(argument) {
              argument = +argument;
              return markFunction(function(seed, matches2) {
                var j, matchIndexes = fn2([], seed.length, argument), i2 = matchIndexes.length;
                while (i2--) {
                  if (seed[j = matchIndexes[i2]]) {
                    seed[j] = !(matches2[j] = seed[j]);
                  }
                }
              });
            });
          }
          function testContext(context) {
            return context && typeof context.getElementsByTagName !== "undefined" && context;
          }
          function setDocument(node) {
            var subWindow, doc = node ? node.ownerDocument || node : preferredDoc;
            if (doc == document3 || doc.nodeType !== 9 || !doc.documentElement) {
              return document3;
            }
            document3 = doc;
            documentElement2 = document3.documentElement;
            documentIsHTML = !jQuery12.isXMLDoc(document3);
            matches = documentElement2.matches || documentElement2.webkitMatchesSelector || documentElement2.msMatchesSelector;
            if (documentElement2.msMatchesSelector && // Support: IE 11+, Edge 17 - 18+
            // IE/Edge sometimes throw a "Permission denied" error when strict-comparing
            // two documents; shallow comparisons work.
            // eslint-disable-next-line eqeqeq
            preferredDoc != document3 && (subWindow = document3.defaultView) && subWindow.top !== subWindow) {
              subWindow.addEventListener("unload", unloadHandler);
            }
            support.getById = assert(function(el) {
              documentElement2.appendChild(el).id = jQuery12.expando;
              return !document3.getElementsByName || !document3.getElementsByName(jQuery12.expando).length;
            });
            support.disconnectedMatch = assert(function(el) {
              return matches.call(el, "*");
            });
            support.scope = assert(function() {
              return document3.querySelectorAll(":scope");
            });
            support.cssHas = assert(function() {
              try {
                document3.querySelector(":has(*,:jqfake)");
                return false;
              } catch (e) {
                return true;
              }
            });
            if (support.getById) {
              Expr.filter.ID = function(id) {
                var attrId = id.replace(runescape, funescape);
                return function(elem) {
                  return elem.getAttribute("id") === attrId;
                };
              };
              Expr.find.ID = function(id, context) {
                if (typeof context.getElementById !== "undefined" && documentIsHTML) {
                  var elem = context.getElementById(id);
                  return elem ? [elem] : [];
                }
              };
            } else {
              Expr.filter.ID = function(id) {
                var attrId = id.replace(runescape, funescape);
                return function(elem) {
                  var node2 = typeof elem.getAttributeNode !== "undefined" && elem.getAttributeNode("id");
                  return node2 && node2.value === attrId;
                };
              };
              Expr.find.ID = function(id, context) {
                if (typeof context.getElementById !== "undefined" && documentIsHTML) {
                  var node2, i2, elems, elem = context.getElementById(id);
                  if (elem) {
                    node2 = elem.getAttributeNode("id");
                    if (node2 && node2.value === id) {
                      return [elem];
                    }
                    elems = context.getElementsByName(id);
                    i2 = 0;
                    while (elem = elems[i2++]) {
                      node2 = elem.getAttributeNode("id");
                      if (node2 && node2.value === id) {
                        return [elem];
                      }
                    }
                  }
                  return [];
                }
              };
            }
            Expr.find.TAG = function(tag, context) {
              if (typeof context.getElementsByTagName !== "undefined") {
                return context.getElementsByTagName(tag);
              } else {
                return context.querySelectorAll(tag);
              }
            };
            Expr.find.CLASS = function(className, context) {
              if (typeof context.getElementsByClassName !== "undefined" && documentIsHTML) {
                return context.getElementsByClassName(className);
              }
            };
            rbuggyQSA = [];
            assert(function(el) {
              var input;
              documentElement2.appendChild(el).innerHTML = "<a id='" + expando + "' href='' disabled='disabled'></a><select id='" + expando + "-\r\\' disabled='disabled'><option selected=''></option></select>";
              if (!el.querySelectorAll("[selected]").length) {
                rbuggyQSA.push("\\[" + whitespace + "*(?:value|" + booleans + ")");
              }
              if (!el.querySelectorAll("[id~=" + expando + "-]").length) {
                rbuggyQSA.push("~=");
              }
              if (!el.querySelectorAll("a#" + expando + "+*").length) {
                rbuggyQSA.push(".#.+[+~]");
              }
              if (!el.querySelectorAll(":checked").length) {
                rbuggyQSA.push(":checked");
              }
              input = document3.createElement("input");
              input.setAttribute("type", "hidden");
              el.appendChild(input).setAttribute("name", "D");
              documentElement2.appendChild(el).disabled = true;
              if (el.querySelectorAll(":disabled").length !== 2) {
                rbuggyQSA.push(":enabled", ":disabled");
              }
              input = document3.createElement("input");
              input.setAttribute("name", "");
              el.appendChild(input);
              if (!el.querySelectorAll("[name='']").length) {
                rbuggyQSA.push("\\[" + whitespace + "*name" + whitespace + "*=" + whitespace + `*(?:''|"")`);
              }
            });
            if (!support.cssHas) {
              rbuggyQSA.push(":has");
            }
            rbuggyQSA = rbuggyQSA.length && new RegExp(rbuggyQSA.join("|"));
            sortOrder = function(a, b) {
              if (a === b) {
                hasDuplicate = true;
                return 0;
              }
              var compare = !a.compareDocumentPosition - !b.compareDocumentPosition;
              if (compare) {
                return compare;
              }
              compare = (a.ownerDocument || a) == (b.ownerDocument || b) ? a.compareDocumentPosition(b) : (
                // Otherwise we know they are disconnected
                1
              );
              if (compare & 1 || !support.sortDetached && b.compareDocumentPosition(a) === compare) {
                if (a === document3 || a.ownerDocument == preferredDoc && find.contains(preferredDoc, a)) {
                  return -1;
                }
                if (b === document3 || b.ownerDocument == preferredDoc && find.contains(preferredDoc, b)) {
                  return 1;
                }
                return sortInput ? indexOf2.call(sortInput, a) - indexOf2.call(sortInput, b) : 0;
              }
              return compare & 4 ? -1 : 1;
            };
            return document3;
          }
          find.matches = function(expr, elements) {
            return find(expr, null, null, elements);
          };
          find.matchesSelector = function(elem, expr) {
            setDocument(elem);
            if (documentIsHTML && !nonnativeSelectorCache[expr + " "] && (!rbuggyQSA || !rbuggyQSA.test(expr))) {
              try {
                var ret = matches.call(elem, expr);
                if (ret || support.disconnectedMatch || // As well, disconnected nodes are said to be in a document
                // fragment in IE 9
                elem.document && elem.document.nodeType !== 11) {
                  return ret;
                }
              } catch (e) {
                nonnativeSelectorCache(expr, true);
              }
            }
            return find(expr, document3, null, [elem]).length > 0;
          };
          find.contains = function(context, elem) {
            if ((context.ownerDocument || context) != document3) {
              setDocument(context);
            }
            return jQuery12.contains(context, elem);
          };
          find.attr = function(elem, name) {
            if ((elem.ownerDocument || elem) != document3) {
              setDocument(elem);
            }
            var fn2 = Expr.attrHandle[name.toLowerCase()], val = fn2 && hasOwn.call(Expr.attrHandle, name.toLowerCase()) ? fn2(elem, name, !documentIsHTML) : void 0;
            if (val !== void 0) {
              return val;
            }
            return elem.getAttribute(name);
          };
          find.error = function(msg) {
            throw new Error("Syntax error, unrecognized expression: " + msg);
          };
          jQuery12.uniqueSort = function(results) {
            var elem, duplicates = [], j = 0, i2 = 0;
            hasDuplicate = !support.sortStable;
            sortInput = !support.sortStable && slice.call(results, 0);
            sort.call(results, sortOrder);
            if (hasDuplicate) {
              while (elem = results[i2++]) {
                if (elem === results[i2]) {
                  j = duplicates.push(i2);
                }
              }
              while (j--) {
                splice.call(results, duplicates[j], 1);
              }
            }
            sortInput = null;
            return results;
          };
          jQuery12.fn.uniqueSort = function() {
            return this.pushStack(jQuery12.uniqueSort(slice.apply(this)));
          };
          Expr = jQuery12.expr = {
            // Can be adjusted by the user
            cacheLength: 50,
            createPseudo: markFunction,
            match: matchExpr,
            attrHandle: {},
            find: {},
            relative: {
              ">": { dir: "parentNode", first: true },
              " ": { dir: "parentNode" },
              "+": { dir: "previousSibling", first: true },
              "~": { dir: "previousSibling" }
            },
            preFilter: {
              ATTR: function(match) {
                match[1] = match[1].replace(runescape, funescape);
                match[3] = (match[3] || match[4] || match[5] || "").replace(runescape, funescape);
                if (match[2] === "~=") {
                  match[3] = " " + match[3] + " ";
                }
                return match.slice(0, 4);
              },
              CHILD: function(match) {
                match[1] = match[1].toLowerCase();
                if (match[1].slice(0, 3) === "nth") {
                  if (!match[3]) {
                    find.error(match[0]);
                  }
                  match[4] = +(match[4] ? match[5] + (match[6] || 1) : 2 * (match[3] === "even" || match[3] === "odd"));
                  match[5] = +(match[7] + match[8] || match[3] === "odd");
                } else if (match[3]) {
                  find.error(match[0]);
                }
                return match;
              },
              PSEUDO: function(match) {
                var excess, unquoted = !match[6] && match[2];
                if (matchExpr.CHILD.test(match[0])) {
                  return null;
                }
                if (match[3]) {
                  match[2] = match[4] || match[5] || "";
                } else if (unquoted && rpseudo.test(unquoted) && // Get excess from tokenize (recursively)
                (excess = tokenize(unquoted, true)) && // advance to the next closing parenthesis
                (excess = unquoted.indexOf(")", unquoted.length - excess) - unquoted.length)) {
                  match[0] = match[0].slice(0, excess);
                  match[2] = unquoted.slice(0, excess);
                }
                return match.slice(0, 3);
              }
            },
            filter: {
              TAG: function(nodeNameSelector) {
                var expectedNodeName = nodeNameSelector.replace(runescape, funescape).toLowerCase();
                return nodeNameSelector === "*" ? function() {
                  return true;
                } : function(elem) {
                  return nodeName(elem, expectedNodeName);
                };
              },
              CLASS: function(className) {
                var pattern = classCache[className + " "];
                return pattern || (pattern = new RegExp("(^|" + whitespace + ")" + className + "(" + whitespace + "|$)")) && classCache(className, function(elem) {
                  return pattern.test(
                    typeof elem.className === "string" && elem.className || typeof elem.getAttribute !== "undefined" && elem.getAttribute("class") || ""
                  );
                });
              },
              ATTR: function(name, operator, check) {
                return function(elem) {
                  var result = find.attr(elem, name);
                  if (result == null) {
                    return operator === "!=";
                  }
                  if (!operator) {
                    return true;
                  }
                  result += "";
                  if (operator === "=") {
                    return result === check;
                  }
                  if (operator === "!=") {
                    return result !== check;
                  }
                  if (operator === "^=") {
                    return check && result.indexOf(check) === 0;
                  }
                  if (operator === "*=") {
                    return check && result.indexOf(check) > -1;
                  }
                  if (operator === "$=") {
                    return check && result.slice(-check.length) === check;
                  }
                  if (operator === "~=") {
                    return (" " + result.replace(rwhitespace, " ") + " ").indexOf(check) > -1;
                  }
                  if (operator === "|=") {
                    return result === check || result.slice(0, check.length + 1) === check + "-";
                  }
                  return false;
                };
              },
              CHILD: function(type, what, _argument, first, last) {
                var simple = type.slice(0, 3) !== "nth", forward = type.slice(-4) !== "last", ofType = what === "of-type";
                return first === 1 && last === 0 ? (
                  // Shortcut for :nth-*(n)
                  function(elem) {
                    return !!elem.parentNode;
                  }
                ) : function(elem, _context, xml) {
                  var cache2, outerCache, node, nodeIndex, start3, dir2 = simple !== forward ? "nextSibling" : "previousSibling", parent = elem.parentNode, name = ofType && elem.nodeName.toLowerCase(), useCache = !xml && !ofType, diff = false;
                  if (parent) {
                    if (simple) {
                      while (dir2) {
                        node = elem;
                        while (node = node[dir2]) {
                          if (ofType ? nodeName(node, name) : node.nodeType === 1) {
                            return false;
                          }
                        }
                        start3 = dir2 = type === "only" && !start3 && "nextSibling";
                      }
                      return true;
                    }
                    start3 = [forward ? parent.firstChild : parent.lastChild];
                    if (forward && useCache) {
                      outerCache = parent[expando] || (parent[expando] = {});
                      cache2 = outerCache[type] || [];
                      nodeIndex = cache2[0] === dirruns && cache2[1];
                      diff = nodeIndex && cache2[2];
                      node = nodeIndex && parent.childNodes[nodeIndex];
                      while (node = ++nodeIndex && node && node[dir2] || // Fallback to seeking `elem` from the start
                      (diff = nodeIndex = 0) || start3.pop()) {
                        if (node.nodeType === 1 && ++diff && node === elem) {
                          outerCache[type] = [dirruns, nodeIndex, diff];
                          break;
                        }
                      }
                    } else {
                      if (useCache) {
                        outerCache = elem[expando] || (elem[expando] = {});
                        cache2 = outerCache[type] || [];
                        nodeIndex = cache2[0] === dirruns && cache2[1];
                        diff = nodeIndex;
                      }
                      if (diff === false) {
                        while (node = ++nodeIndex && node && node[dir2] || (diff = nodeIndex = 0) || start3.pop()) {
                          if ((ofType ? nodeName(node, name) : node.nodeType === 1) && ++diff) {
                            if (useCache) {
                              outerCache = node[expando] || (node[expando] = {});
                              outerCache[type] = [dirruns, diff];
                            }
                            if (node === elem) {
                              break;
                            }
                          }
                        }
                      }
                    }
                    diff -= last;
                    return diff === first || diff % first === 0 && diff / first >= 0;
                  }
                };
              },
              PSEUDO: function(pseudo, argument) {
                var args, fn2 = Expr.pseudos[pseudo] || Expr.setFilters[pseudo.toLowerCase()] || find.error("unsupported pseudo: " + pseudo);
                if (fn2[expando]) {
                  return fn2(argument);
                }
                if (fn2.length > 1) {
                  args = [pseudo, pseudo, "", argument];
                  return Expr.setFilters.hasOwnProperty(pseudo.toLowerCase()) ? markFunction(function(seed, matches2) {
                    var idx, matched = fn2(seed, argument), i2 = matched.length;
                    while (i2--) {
                      idx = indexOf2.call(seed, matched[i2]);
                      seed[idx] = !(matches2[idx] = matched[i2]);
                    }
                  }) : function(elem) {
                    return fn2(elem, 0, args);
                  };
                }
                return fn2;
              }
            },
            pseudos: {
              // Potentially complex pseudos
              not: markFunction(function(selector) {
                var input = [], results = [], matcher = compile(selector.replace(rtrimCSS, "$1"));
                return matcher[expando] ? markFunction(function(seed, matches2, _context, xml) {
                  var elem, unmatched = matcher(seed, null, xml, []), i2 = seed.length;
                  while (i2--) {
                    if (elem = unmatched[i2]) {
                      seed[i2] = !(matches2[i2] = elem);
                    }
                  }
                }) : function(elem, _context, xml) {
                  input[0] = elem;
                  matcher(input, null, xml, results);
                  input[0] = null;
                  return !results.pop();
                };
              }),
              has: markFunction(function(selector) {
                return function(elem) {
                  return find(selector, elem).length > 0;
                };
              }),
              contains: markFunction(function(text) {
                text = text.replace(runescape, funescape);
                return function(elem) {
                  return (elem.textContent || jQuery12.text(elem)).indexOf(text) > -1;
                };
              }),
              // "Whether an element is represented by a :lang() selector
              // is based solely on the element's language value
              // being equal to the identifier C,
              // or beginning with the identifier C immediately followed by "-".
              // The matching of C against the element's language value is performed case-insensitively.
              // The identifier C does not have to be a valid language name."
              // https://www.w3.org/TR/selectors/#lang-pseudo
              lang: markFunction(function(lang) {
                if (!ridentifier.test(lang || "")) {
                  find.error("unsupported lang: " + lang);
                }
                lang = lang.replace(runescape, funescape).toLowerCase();
                return function(elem) {
                  var elemLang;
                  do {
                    if (elemLang = documentIsHTML ? elem.lang : elem.getAttribute("xml:lang") || elem.getAttribute("lang")) {
                      elemLang = elemLang.toLowerCase();
                      return elemLang === lang || elemLang.indexOf(lang + "-") === 0;
                    }
                  } while ((elem = elem.parentNode) && elem.nodeType === 1);
                  return false;
                };
              }),
              // Miscellaneous
              target: function(elem) {
                var hash3 = window2.location && window2.location.hash;
                return hash3 && hash3.slice(1) === elem.id;
              },
              root: function(elem) {
                return elem === documentElement2;
              },
              focus: function(elem) {
                return elem === safeActiveElement() && document3.hasFocus() && !!(elem.type || elem.href || ~elem.tabIndex);
              },
              // Boolean properties
              enabled: createDisabledPseudo(false),
              disabled: createDisabledPseudo(true),
              checked: function(elem) {
                return nodeName(elem, "input") && !!elem.checked || nodeName(elem, "option") && !!elem.selected;
              },
              selected: function(elem) {
                if (elem.parentNode) {
                  elem.parentNode.selectedIndex;
                }
                return elem.selected === true;
              },
              // Contents
              empty: function(elem) {
                for (elem = elem.firstChild; elem; elem = elem.nextSibling) {
                  if (elem.nodeType < 6) {
                    return false;
                  }
                }
                return true;
              },
              parent: function(elem) {
                return !Expr.pseudos.empty(elem);
              },
              // Element/input types
              header: function(elem) {
                return rheader.test(elem.nodeName);
              },
              input: function(elem) {
                return rinputs.test(elem.nodeName);
              },
              button: function(elem) {
                return nodeName(elem, "input") && elem.type === "button" || nodeName(elem, "button");
              },
              text: function(elem) {
                var attr;
                return nodeName(elem, "input") && elem.type === "text" && // Support: IE <10 only
                // New HTML5 attribute values (e.g., "search") appear
                // with elem.type === "text"
                ((attr = elem.getAttribute("type")) == null || attr.toLowerCase() === "text");
              },
              // Position-in-collection
              first: createPositionalPseudo(function() {
                return [0];
              }),
              last: createPositionalPseudo(function(_matchIndexes, length) {
                return [length - 1];
              }),
              eq: createPositionalPseudo(function(_matchIndexes, length, argument) {
                return [argument < 0 ? argument + length : argument];
              }),
              even: createPositionalPseudo(function(matchIndexes, length) {
                var i2 = 0;
                for (; i2 < length; i2 += 2) {
                  matchIndexes.push(i2);
                }
                return matchIndexes;
              }),
              odd: createPositionalPseudo(function(matchIndexes, length) {
                var i2 = 1;
                for (; i2 < length; i2 += 2) {
                  matchIndexes.push(i2);
                }
                return matchIndexes;
              }),
              lt: createPositionalPseudo(function(matchIndexes, length, argument) {
                var i2;
                if (argument < 0) {
                  i2 = argument + length;
                } else if (argument > length) {
                  i2 = length;
                } else {
                  i2 = argument;
                }
                for (; --i2 >= 0; ) {
                  matchIndexes.push(i2);
                }
                return matchIndexes;
              }),
              gt: createPositionalPseudo(function(matchIndexes, length, argument) {
                var i2 = argument < 0 ? argument + length : argument;
                for (; ++i2 < length; ) {
                  matchIndexes.push(i2);
                }
                return matchIndexes;
              })
            }
          };
          Expr.pseudos.nth = Expr.pseudos.eq;
          for (i in { radio: true, checkbox: true, file: true, password: true, image: true }) {
            Expr.pseudos[i] = createInputPseudo(i);
          }
          for (i in { submit: true, reset: true }) {
            Expr.pseudos[i] = createButtonPseudo(i);
          }
          function setFilters() {
          }
          setFilters.prototype = Expr.filters = Expr.pseudos;
          Expr.setFilters = new setFilters();
          function tokenize(selector, parseOnly) {
            var matched, match, tokens, type, soFar, groups, preFilters, cached = tokenCache[selector + " "];
            if (cached) {
              return parseOnly ? 0 : cached.slice(0);
            }
            soFar = selector;
            groups = [];
            preFilters = Expr.preFilter;
            while (soFar) {
              if (!matched || (match = rcomma.exec(soFar))) {
                if (match) {
                  soFar = soFar.slice(match[0].length) || soFar;
                }
                groups.push(tokens = []);
              }
              matched = false;
              if (match = rleadingCombinator.exec(soFar)) {
                matched = match.shift();
                tokens.push({
                  value: matched,
                  // Cast descendant combinators to space
                  type: match[0].replace(rtrimCSS, " ")
                });
                soFar = soFar.slice(matched.length);
              }
              for (type in Expr.filter) {
                if ((match = matchExpr[type].exec(soFar)) && (!preFilters[type] || (match = preFilters[type](match)))) {
                  matched = match.shift();
                  tokens.push({
                    value: matched,
                    type,
                    matches: match
                  });
                  soFar = soFar.slice(matched.length);
                }
              }
              if (!matched) {
                break;
              }
            }
            if (parseOnly) {
              return soFar.length;
            }
            return soFar ? find.error(selector) : (
              // Cache the tokens
              tokenCache(selector, groups).slice(0)
            );
          }
          function toSelector(tokens) {
            var i2 = 0, len = tokens.length, selector = "";
            for (; i2 < len; i2++) {
              selector += tokens[i2].value;
            }
            return selector;
          }
          function addCombinator(matcher, combinator, base) {
            var dir2 = combinator.dir, skip = combinator.next, key = skip || dir2, checkNonElements = base && key === "parentNode", doneName = done++;
            return combinator.first ? (
              // Check against closest ancestor/preceding element
              function(elem, context, xml) {
                while (elem = elem[dir2]) {
                  if (elem.nodeType === 1 || checkNonElements) {
                    return matcher(elem, context, xml);
                  }
                }
                return false;
              }
            ) : (
              // Check against all ancestor/preceding elements
              function(elem, context, xml) {
                var oldCache, outerCache, newCache = [dirruns, doneName];
                if (xml) {
                  while (elem = elem[dir2]) {
                    if (elem.nodeType === 1 || checkNonElements) {
                      if (matcher(elem, context, xml)) {
                        return true;
                      }
                    }
                  }
                } else {
                  while (elem = elem[dir2]) {
                    if (elem.nodeType === 1 || checkNonElements) {
                      outerCache = elem[expando] || (elem[expando] = {});
                      if (skip && nodeName(elem, skip)) {
                        elem = elem[dir2] || elem;
                      } else if ((oldCache = outerCache[key]) && oldCache[0] === dirruns && oldCache[1] === doneName) {
                        return newCache[2] = oldCache[2];
                      } else {
                        outerCache[key] = newCache;
                        if (newCache[2] = matcher(elem, context, xml)) {
                          return true;
                        }
                      }
                    }
                  }
                }
                return false;
              }
            );
          }
          function elementMatcher(matchers) {
            return matchers.length > 1 ? function(elem, context, xml) {
              var i2 = matchers.length;
              while (i2--) {
                if (!matchers[i2](elem, context, xml)) {
                  return false;
                }
              }
              return true;
            } : matchers[0];
          }
          function multipleContexts(selector, contexts, results) {
            var i2 = 0, len = contexts.length;
            for (; i2 < len; i2++) {
              find(selector, contexts[i2], results);
            }
            return results;
          }
          function condense(unmatched, map, filter, context, xml) {
            var elem, newUnmatched = [], i2 = 0, len = unmatched.length, mapped = map != null;
            for (; i2 < len; i2++) {
              if (elem = unmatched[i2]) {
                if (!filter || filter(elem, context, xml)) {
                  newUnmatched.push(elem);
                  if (mapped) {
                    map.push(i2);
                  }
                }
              }
            }
            return newUnmatched;
          }
          function setMatcher(preFilter, selector, matcher, postFilter, postFinder, postSelector) {
            if (postFilter && !postFilter[expando]) {
              postFilter = setMatcher(postFilter);
            }
            if (postFinder && !postFinder[expando]) {
              postFinder = setMatcher(postFinder, postSelector);
            }
            return markFunction(function(seed, results, context, xml) {
              var temp, i2, elem, matcherOut, preMap = [], postMap = [], preexisting = results.length, elems = seed || multipleContexts(
                selector || "*",
                context.nodeType ? [context] : context,
                []
              ), matcherIn = preFilter && (seed || !selector) ? condense(elems, preMap, preFilter, context, xml) : elems;
              if (matcher) {
                matcherOut = postFinder || (seed ? preFilter : preexisting || postFilter) ? (
                  // ...intermediate processing is necessary
                  []
                ) : (
                  // ...otherwise use results directly
                  results
                );
                matcher(matcherIn, matcherOut, context, xml);
              } else {
                matcherOut = matcherIn;
              }
              if (postFilter) {
                temp = condense(matcherOut, postMap);
                postFilter(temp, [], context, xml);
                i2 = temp.length;
                while (i2--) {
                  if (elem = temp[i2]) {
                    matcherOut[postMap[i2]] = !(matcherIn[postMap[i2]] = elem);
                  }
                }
              }
              if (seed) {
                if (postFinder || preFilter) {
                  if (postFinder) {
                    temp = [];
                    i2 = matcherOut.length;
                    while (i2--) {
                      if (elem = matcherOut[i2]) {
                        temp.push(matcherIn[i2] = elem);
                      }
                    }
                    postFinder(null, matcherOut = [], temp, xml);
                  }
                  i2 = matcherOut.length;
                  while (i2--) {
                    if ((elem = matcherOut[i2]) && (temp = postFinder ? indexOf2.call(seed, elem) : preMap[i2]) > -1) {
                      seed[temp] = !(results[temp] = elem);
                    }
                  }
                }
              } else {
                matcherOut = condense(
                  matcherOut === results ? matcherOut.splice(preexisting, matcherOut.length) : matcherOut
                );
                if (postFinder) {
                  postFinder(null, results, matcherOut, xml);
                } else {
                  push2.apply(results, matcherOut);
                }
              }
            });
          }
          function matcherFromTokens(tokens) {
            var checkContext, matcher, j, len = tokens.length, leadingRelative = Expr.relative[tokens[0].type], implicitRelative = leadingRelative || Expr.relative[" "], i2 = leadingRelative ? 1 : 0, matchContext = addCombinator(function(elem) {
              return elem === checkContext;
            }, implicitRelative, true), matchAnyContext = addCombinator(function(elem) {
              return indexOf2.call(checkContext, elem) > -1;
            }, implicitRelative, true), matchers = [function(elem, context, xml) {
              var ret = !leadingRelative && (xml || context != outermostContext) || ((checkContext = context).nodeType ? matchContext(elem, context, xml) : matchAnyContext(elem, context, xml));
              checkContext = null;
              return ret;
            }];
            for (; i2 < len; i2++) {
              if (matcher = Expr.relative[tokens[i2].type]) {
                matchers = [addCombinator(elementMatcher(matchers), matcher)];
              } else {
                matcher = Expr.filter[tokens[i2].type].apply(null, tokens[i2].matches);
                if (matcher[expando]) {
                  j = ++i2;
                  for (; j < len; j++) {
                    if (Expr.relative[tokens[j].type]) {
                      break;
                    }
                  }
                  return setMatcher(
                    i2 > 1 && elementMatcher(matchers),
                    i2 > 1 && toSelector(
                      // If the preceding token was a descendant combinator, insert an implicit any-element `*`
                      tokens.slice(0, i2 - 1).concat({ value: tokens[i2 - 2].type === " " ? "*" : "" })
                    ).replace(rtrimCSS, "$1"),
                    matcher,
                    i2 < j && matcherFromTokens(tokens.slice(i2, j)),
                    j < len && matcherFromTokens(tokens = tokens.slice(j)),
                    j < len && toSelector(tokens)
                  );
                }
                matchers.push(matcher);
              }
            }
            return elementMatcher(matchers);
          }
          function matcherFromGroupMatchers(elementMatchers, setMatchers) {
            var bySet = setMatchers.length > 0, byElement = elementMatchers.length > 0, superMatcher = function(seed, context, xml, results, outermost) {
              var elem, j, matcher, matchedCount = 0, i2 = "0", unmatched = seed && [], setMatched = [], contextBackup = outermostContext, elems = seed || byElement && Expr.find.TAG("*", outermost), dirrunsUnique = dirruns += contextBackup == null ? 1 : Math.random() || 0.1, len = elems.length;
              if (outermost) {
                outermostContext = context == document3 || context || outermost;
              }
              for (; i2 !== len && (elem = elems[i2]) != null; i2++) {
                if (byElement && elem) {
                  j = 0;
                  if (!context && elem.ownerDocument != document3) {
                    setDocument(elem);
                    xml = !documentIsHTML;
                  }
                  while (matcher = elementMatchers[j++]) {
                    if (matcher(elem, context || document3, xml)) {
                      push2.call(results, elem);
                      break;
                    }
                  }
                  if (outermost) {
                    dirruns = dirrunsUnique;
                  }
                }
                if (bySet) {
                  if (elem = !matcher && elem) {
                    matchedCount--;
                  }
                  if (seed) {
                    unmatched.push(elem);
                  }
                }
              }
              matchedCount += i2;
              if (bySet && i2 !== matchedCount) {
                j = 0;
                while (matcher = setMatchers[j++]) {
                  matcher(unmatched, setMatched, context, xml);
                }
                if (seed) {
                  if (matchedCount > 0) {
                    while (i2--) {
                      if (!(unmatched[i2] || setMatched[i2])) {
                        setMatched[i2] = pop.call(results);
                      }
                    }
                  }
                  setMatched = condense(setMatched);
                }
                push2.apply(results, setMatched);
                if (outermost && !seed && setMatched.length > 0 && matchedCount + setMatchers.length > 1) {
                  jQuery12.uniqueSort(results);
                }
              }
              if (outermost) {
                dirruns = dirrunsUnique;
                outermostContext = contextBackup;
              }
              return unmatched;
            };
            return bySet ? markFunction(superMatcher) : superMatcher;
          }
          function compile(selector, match) {
            var i2, setMatchers = [], elementMatchers = [], cached = compilerCache[selector + " "];
            if (!cached) {
              if (!match) {
                match = tokenize(selector);
              }
              i2 = match.length;
              while (i2--) {
                cached = matcherFromTokens(match[i2]);
                if (cached[expando]) {
                  setMatchers.push(cached);
                } else {
                  elementMatchers.push(cached);
                }
              }
              cached = compilerCache(
                selector,
                matcherFromGroupMatchers(elementMatchers, setMatchers)
              );
              cached.selector = selector;
            }
            return cached;
          }
          function select(selector, context, results, seed) {
            var i2, tokens, token, type, find2, compiled = typeof selector === "function" && selector, match = !seed && tokenize(selector = compiled.selector || selector);
            results = results || [];
            if (match.length === 1) {
              tokens = match[0] = match[0].slice(0);
              if (tokens.length > 2 && (token = tokens[0]).type === "ID" && context.nodeType === 9 && documentIsHTML && Expr.relative[tokens[1].type]) {
                context = (Expr.find.ID(
                  token.matches[0].replace(runescape, funescape),
                  context
                ) || [])[0];
                if (!context) {
                  return results;
                } else if (compiled) {
                  context = context.parentNode;
                }
                selector = selector.slice(tokens.shift().value.length);
              }
              i2 = matchExpr.needsContext.test(selector) ? 0 : tokens.length;
              while (i2--) {
                token = tokens[i2];
                if (Expr.relative[type = token.type]) {
                  break;
                }
                if (find2 = Expr.find[type]) {
                  if (seed = find2(
                    token.matches[0].replace(runescape, funescape),
                    rsibling.test(tokens[0].type) && testContext(context.parentNode) || context
                  )) {
                    tokens.splice(i2, 1);
                    selector = seed.length && toSelector(tokens);
                    if (!selector) {
                      push2.apply(results, seed);
                      return results;
                    }
                    break;
                  }
                }
              }
            }
            (compiled || compile(selector, match))(
              seed,
              context,
              !documentIsHTML,
              results,
              !context || rsibling.test(selector) && testContext(context.parentNode) || context
            );
            return results;
          }
          support.sortStable = expando.split("").sort(sortOrder).join("") === expando;
          setDocument();
          support.sortDetached = assert(function(el) {
            return el.compareDocumentPosition(document3.createElement("fieldset")) & 1;
          });
          jQuery12.find = find;
          jQuery12.expr[":"] = jQuery12.expr.pseudos;
          jQuery12.unique = jQuery12.uniqueSort;
          find.compile = compile;
          find.select = select;
          find.setDocument = setDocument;
          find.tokenize = tokenize;
          find.escape = jQuery12.escapeSelector;
          find.getText = jQuery12.text;
          find.isXML = jQuery12.isXMLDoc;
          find.selectors = jQuery12.expr;
          find.support = jQuery12.support;
          find.uniqueSort = jQuery12.uniqueSort;
        })();
        var dir = function(elem, dir2, until) {
          var matched = [], truncate = until !== void 0;
          while ((elem = elem[dir2]) && elem.nodeType !== 9) {
            if (elem.nodeType === 1) {
              if (truncate && jQuery12(elem).is(until)) {
                break;
              }
              matched.push(elem);
            }
          }
          return matched;
        };
        var siblings = function(n, elem) {
          var matched = [];
          for (; n; n = n.nextSibling) {
            if (n.nodeType === 1 && n !== elem) {
              matched.push(n);
            }
          }
          return matched;
        };
        var rneedsContext = jQuery12.expr.match.needsContext;
        var rsingleTag = /^<([a-z][^\/\0>:\x20\t\r\n\f]*)[\x20\t\r\n\f]*\/?>(?:<\/\1>|)$/i;
        function winnow(elements, qualifier, not) {
          if (isFunction(qualifier)) {
            return jQuery12.grep(elements, function(elem, i) {
              return !!qualifier.call(elem, i, elem) !== not;
            });
          }
          if (qualifier.nodeType) {
            return jQuery12.grep(elements, function(elem) {
              return elem === qualifier !== not;
            });
          }
          if (typeof qualifier !== "string") {
            return jQuery12.grep(elements, function(elem) {
              return indexOf2.call(qualifier, elem) > -1 !== not;
            });
          }
          return jQuery12.filter(qualifier, elements, not);
        }
        jQuery12.filter = function(expr, elems, not) {
          var elem = elems[0];
          if (not) {
            expr = ":not(" + expr + ")";
          }
          if (elems.length === 1 && elem.nodeType === 1) {
            return jQuery12.find.matchesSelector(elem, expr) ? [elem] : [];
          }
          return jQuery12.find.matches(expr, jQuery12.grep(elems, function(elem2) {
            return elem2.nodeType === 1;
          }));
        };
        jQuery12.fn.extend({
          find: function(selector) {
            var i, ret, len = this.length, self2 = this;
            if (typeof selector !== "string") {
              return this.pushStack(jQuery12(selector).filter(function() {
                for (i = 0; i < len; i++) {
                  if (jQuery12.contains(self2[i], this)) {
                    return true;
                  }
                }
              }));
            }
            ret = this.pushStack([]);
            for (i = 0; i < len; i++) {
              jQuery12.find(selector, self2[i], ret);
            }
            return len > 1 ? jQuery12.uniqueSort(ret) : ret;
          },
          filter: function(selector) {
            return this.pushStack(winnow(this, selector || [], false));
          },
          not: function(selector) {
            return this.pushStack(winnow(this, selector || [], true));
          },
          is: function(selector) {
            return !!winnow(
              this,
              // If this is a positional/relative selector, check membership in the returned set
              // so $("p:first").is("p:last") won't return true for a doc with two "p".
              typeof selector === "string" && rneedsContext.test(selector) ? jQuery12(selector) : selector || [],
              false
            ).length;
          }
        });
        var rootjQuery, rquickExpr = /^(?:\s*(<[\w\W]+>)[^>]*|#([\w-]+))$/, init = jQuery12.fn.init = function(selector, context, root) {
          var match, elem;
          if (!selector) {
            return this;
          }
          root = root || rootjQuery;
          if (typeof selector === "string") {
            if (selector[0] === "<" && selector[selector.length - 1] === ">" && selector.length >= 3) {
              match = [null, selector, null];
            } else {
              match = rquickExpr.exec(selector);
            }
            if (match && (match[1] || !context)) {
              if (match[1]) {
                context = context instanceof jQuery12 ? context[0] : context;
                jQuery12.merge(this, jQuery12.parseHTML(
                  match[1],
                  context && context.nodeType ? context.ownerDocument || context : document2,
                  true
                ));
                if (rsingleTag.test(match[1]) && jQuery12.isPlainObject(context)) {
                  for (match in context) {
                    if (isFunction(this[match])) {
                      this[match](context[match]);
                    } else {
                      this.attr(match, context[match]);
                    }
                  }
                }
                return this;
              } else {
                elem = document2.getElementById(match[2]);
                if (elem) {
                  this[0] = elem;
                  this.length = 1;
                }
                return this;
              }
            } else if (!context || context.jquery) {
              return (context || root).find(selector);
            } else {
              return this.constructor(context).find(selector);
            }
          } else if (selector.nodeType) {
            this[0] = selector;
            this.length = 1;
            return this;
          } else if (isFunction(selector)) {
            return root.ready !== void 0 ? root.ready(selector) : (
              // Execute immediately if ready is not present
              selector(jQuery12)
            );
          }
          return jQuery12.makeArray(selector, this);
        };
        init.prototype = jQuery12.fn;
        rootjQuery = jQuery12(document2);
        var rparentsprev = /^(?:parents|prev(?:Until|All))/, guaranteedUnique = {
          children: true,
          contents: true,
          next: true,
          prev: true
        };
        jQuery12.fn.extend({
          has: function(target) {
            var targets = jQuery12(target, this), l = targets.length;
            return this.filter(function() {
              var i = 0;
              for (; i < l; i++) {
                if (jQuery12.contains(this, targets[i])) {
                  return true;
                }
              }
            });
          },
          closest: function(selectors, context) {
            var cur, i = 0, l = this.length, matched = [], targets = typeof selectors !== "string" && jQuery12(selectors);
            if (!rneedsContext.test(selectors)) {
              for (; i < l; i++) {
                for (cur = this[i]; cur && cur !== context; cur = cur.parentNode) {
                  if (cur.nodeType < 11 && (targets ? targets.index(cur) > -1 : (
                    // Don't pass non-elements to jQuery#find
                    cur.nodeType === 1 && jQuery12.find.matchesSelector(cur, selectors)
                  ))) {
                    matched.push(cur);
                    break;
                  }
                }
              }
            }
            return this.pushStack(matched.length > 1 ? jQuery12.uniqueSort(matched) : matched);
          },
          // Determine the position of an element within the set
          index: function(elem) {
            if (!elem) {
              return this[0] && this[0].parentNode ? this.first().prevAll().length : -1;
            }
            if (typeof elem === "string") {
              return indexOf2.call(jQuery12(elem), this[0]);
            }
            return indexOf2.call(
              this,
              // If it receives a jQuery object, the first element is used
              elem.jquery ? elem[0] : elem
            );
          },
          add: function(selector, context) {
            return this.pushStack(
              jQuery12.uniqueSort(
                jQuery12.merge(this.get(), jQuery12(selector, context))
              )
            );
          },
          addBack: function(selector) {
            return this.add(
              selector == null ? this.prevObject : this.prevObject.filter(selector)
            );
          }
        });
        function sibling(cur, dir2) {
          while ((cur = cur[dir2]) && cur.nodeType !== 1) {
          }
          return cur;
        }
        jQuery12.each({
          parent: function(elem) {
            var parent = elem.parentNode;
            return parent && parent.nodeType !== 11 ? parent : null;
          },
          parents: function(elem) {
            return dir(elem, "parentNode");
          },
          parentsUntil: function(elem, _i, until) {
            return dir(elem, "parentNode", until);
          },
          next: function(elem) {
            return sibling(elem, "nextSibling");
          },
          prev: function(elem) {
            return sibling(elem, "previousSibling");
          },
          nextAll: function(elem) {
            return dir(elem, "nextSibling");
          },
          prevAll: function(elem) {
            return dir(elem, "previousSibling");
          },
          nextUntil: function(elem, _i, until) {
            return dir(elem, "nextSibling", until);
          },
          prevUntil: function(elem, _i, until) {
            return dir(elem, "previousSibling", until);
          },
          siblings: function(elem) {
            return siblings((elem.parentNode || {}).firstChild, elem);
          },
          children: function(elem) {
            return siblings(elem.firstChild);
          },
          contents: function(elem) {
            if (elem.contentDocument != null && // Support: IE 11+
            // <object> elements with no `data` attribute has an object
            // `contentDocument` with a `null` prototype.
            getProto(elem.contentDocument)) {
              return elem.contentDocument;
            }
            if (nodeName(elem, "template")) {
              elem = elem.content || elem;
            }
            return jQuery12.merge([], elem.childNodes);
          }
        }, function(name, fn2) {
          jQuery12.fn[name] = function(until, selector) {
            var matched = jQuery12.map(this, fn2, until);
            if (name.slice(-5) !== "Until") {
              selector = until;
            }
            if (selector && typeof selector === "string") {
              matched = jQuery12.filter(selector, matched);
            }
            if (this.length > 1) {
              if (!guaranteedUnique[name]) {
                jQuery12.uniqueSort(matched);
              }
              if (rparentsprev.test(name)) {
                matched.reverse();
              }
            }
            return this.pushStack(matched);
          };
        });
        var rnothtmlwhite = /[^\x20\t\r\n\f]+/g;
        function createOptions(options) {
          var object = {};
          jQuery12.each(options.match(rnothtmlwhite) || [], function(_, flag) {
            object[flag] = true;
          });
          return object;
        }
        jQuery12.Callbacks = function(options) {
          options = typeof options === "string" ? createOptions(options) : jQuery12.extend({}, options);
          var firing, memory, fired, locked, list = [], queue = [], firingIndex = -1, fire = function() {
            locked = locked || options.once;
            fired = firing = true;
            for (; queue.length; firingIndex = -1) {
              memory = queue.shift();
              while (++firingIndex < list.length) {
                if (list[firingIndex].apply(memory[0], memory[1]) === false && options.stopOnFalse) {
                  firingIndex = list.length;
                  memory = false;
                }
              }
            }
            if (!options.memory) {
              memory = false;
            }
            firing = false;
            if (locked) {
              if (memory) {
                list = [];
              } else {
                list = "";
              }
            }
          }, self2 = {
            // Add a callback or a collection of callbacks to the list
            add: function() {
              if (list) {
                if (memory && !firing) {
                  firingIndex = list.length - 1;
                  queue.push(memory);
                }
                (function add(args) {
                  jQuery12.each(args, function(_, arg) {
                    if (isFunction(arg)) {
                      if (!options.unique || !self2.has(arg)) {
                        list.push(arg);
                      }
                    } else if (arg && arg.length && toType2(arg) !== "string") {
                      add(arg);
                    }
                  });
                })(arguments);
                if (memory && !firing) {
                  fire();
                }
              }
              return this;
            },
            // Remove a callback from the list
            remove: function() {
              jQuery12.each(arguments, function(_, arg) {
                var index;
                while ((index = jQuery12.inArray(arg, list, index)) > -1) {
                  list.splice(index, 1);
                  if (index <= firingIndex) {
                    firingIndex--;
                  }
                }
              });
              return this;
            },
            // Check if a given callback is in the list.
            // If no argument is given, return whether or not list has callbacks attached.
            has: function(fn2) {
              return fn2 ? jQuery12.inArray(fn2, list) > -1 : list.length > 0;
            },
            // Remove all callbacks from the list
            empty: function() {
              if (list) {
                list = [];
              }
              return this;
            },
            // Disable .fire and .add
            // Abort any current/pending executions
            // Clear all callbacks and values
            disable: function() {
              locked = queue = [];
              list = memory = "";
              return this;
            },
            disabled: function() {
              return !list;
            },
            // Disable .fire
            // Also disable .add unless we have memory (since it would have no effect)
            // Abort any pending executions
            lock: function() {
              locked = queue = [];
              if (!memory && !firing) {
                list = memory = "";
              }
              return this;
            },
            locked: function() {
              return !!locked;
            },
            // Call all callbacks with the given context and arguments
            fireWith: function(context, args) {
              if (!locked) {
                args = args || [];
                args = [context, args.slice ? args.slice() : args];
                queue.push(args);
                if (!firing) {
                  fire();
                }
              }
              return this;
            },
            // Call all the callbacks with the given arguments
            fire: function() {
              self2.fireWith(this, arguments);
              return this;
            },
            // To know if the callbacks have already been called at least once
            fired: function() {
              return !!fired;
            }
          };
          return self2;
        };
        function Identity(v) {
          return v;
        }
        function Thrower(ex) {
          throw ex;
        }
        function adoptValue(value, resolve, reject, noValue) {
          var method;
          try {
            if (value && isFunction(method = value.promise)) {
              method.call(value).done(resolve).fail(reject);
            } else if (value && isFunction(method = value.then)) {
              method.call(value, resolve, reject);
            } else {
              resolve.apply(void 0, [value].slice(noValue));
            }
          } catch (value2) {
            reject.apply(void 0, [value2]);
          }
        }
        jQuery12.extend({
          Deferred: function(func) {
            var tuples = [
              // action, add listener, callbacks,
              // ... .then handlers, argument index, [final state]
              [
                "notify",
                "progress",
                jQuery12.Callbacks("memory"),
                jQuery12.Callbacks("memory"),
                2
              ],
              [
                "resolve",
                "done",
                jQuery12.Callbacks("once memory"),
                jQuery12.Callbacks("once memory"),
                0,
                "resolved"
              ],
              [
                "reject",
                "fail",
                jQuery12.Callbacks("once memory"),
                jQuery12.Callbacks("once memory"),
                1,
                "rejected"
              ]
            ], state = "pending", promise = {
              state: function() {
                return state;
              },
              always: function() {
                deferred.done(arguments).fail(arguments);
                return this;
              },
              "catch": function(fn2) {
                return promise.then(null, fn2);
              },
              // Keep pipe for back-compat
              pipe: function() {
                var fns = arguments;
                return jQuery12.Deferred(function(newDefer) {
                  jQuery12.each(tuples, function(_i, tuple) {
                    var fn2 = isFunction(fns[tuple[4]]) && fns[tuple[4]];
                    deferred[tuple[1]](function() {
                      var returned = fn2 && fn2.apply(this, arguments);
                      if (returned && isFunction(returned.promise)) {
                        returned.promise().progress(newDefer.notify).done(newDefer.resolve).fail(newDefer.reject);
                      } else {
                        newDefer[tuple[0] + "With"](
                          this,
                          fn2 ? [returned] : arguments
                        );
                      }
                    });
                  });
                  fns = null;
                }).promise();
              },
              then: function(onFulfilled, onRejected, onProgress) {
                var maxDepth = 0;
                function resolve(depth, deferred2, handler, special) {
                  return function() {
                    var that = this, args = arguments, mightThrow = function() {
                      var returned, then;
                      if (depth < maxDepth) {
                        return;
                      }
                      returned = handler.apply(that, args);
                      if (returned === deferred2.promise()) {
                        throw new TypeError("Thenable self-resolution");
                      }
                      then = returned && // Support: Promises/A+ section 2.3.4
                      // https://promisesaplus.com/#point-64
                      // Only check objects and functions for thenability
                      (typeof returned === "object" || typeof returned === "function") && returned.then;
                      if (isFunction(then)) {
                        if (special) {
                          then.call(
                            returned,
                            resolve(maxDepth, deferred2, Identity, special),
                            resolve(maxDepth, deferred2, Thrower, special)
                          );
                        } else {
                          maxDepth++;
                          then.call(
                            returned,
                            resolve(maxDepth, deferred2, Identity, special),
                            resolve(maxDepth, deferred2, Thrower, special),
                            resolve(
                              maxDepth,
                              deferred2,
                              Identity,
                              deferred2.notifyWith
                            )
                          );
                        }
                      } else {
                        if (handler !== Identity) {
                          that = void 0;
                          args = [returned];
                        }
                        (special || deferred2.resolveWith)(that, args);
                      }
                    }, process = special ? mightThrow : function() {
                      try {
                        mightThrow();
                      } catch (e) {
                        if (jQuery12.Deferred.exceptionHook) {
                          jQuery12.Deferred.exceptionHook(
                            e,
                            process.error
                          );
                        }
                        if (depth + 1 >= maxDepth) {
                          if (handler !== Thrower) {
                            that = void 0;
                            args = [e];
                          }
                          deferred2.rejectWith(that, args);
                        }
                      }
                    };
                    if (depth) {
                      process();
                    } else {
                      if (jQuery12.Deferred.getErrorHook) {
                        process.error = jQuery12.Deferred.getErrorHook();
                      } else if (jQuery12.Deferred.getStackHook) {
                        process.error = jQuery12.Deferred.getStackHook();
                      }
                      window2.setTimeout(process);
                    }
                  };
                }
                return jQuery12.Deferred(function(newDefer) {
                  tuples[0][3].add(
                    resolve(
                      0,
                      newDefer,
                      isFunction(onProgress) ? onProgress : Identity,
                      newDefer.notifyWith
                    )
                  );
                  tuples[1][3].add(
                    resolve(
                      0,
                      newDefer,
                      isFunction(onFulfilled) ? onFulfilled : Identity
                    )
                  );
                  tuples[2][3].add(
                    resolve(
                      0,
                      newDefer,
                      isFunction(onRejected) ? onRejected : Thrower
                    )
                  );
                }).promise();
              },
              // Get a promise for this deferred
              // If obj is provided, the promise aspect is added to the object
              promise: function(obj) {
                return obj != null ? jQuery12.extend(obj, promise) : promise;
              }
            }, deferred = {};
            jQuery12.each(tuples, function(i, tuple) {
              var list = tuple[2], stateString = tuple[5];
              promise[tuple[1]] = list.add;
              if (stateString) {
                list.add(
                  function() {
                    state = stateString;
                  },
                  // rejected_callbacks.disable
                  // fulfilled_callbacks.disable
                  tuples[3 - i][2].disable,
                  // rejected_handlers.disable
                  // fulfilled_handlers.disable
                  tuples[3 - i][3].disable,
                  // progress_callbacks.lock
                  tuples[0][2].lock,
                  // progress_handlers.lock
                  tuples[0][3].lock
                );
              }
              list.add(tuple[3].fire);
              deferred[tuple[0]] = function() {
                deferred[tuple[0] + "With"](this === deferred ? void 0 : this, arguments);
                return this;
              };
              deferred[tuple[0] + "With"] = list.fireWith;
            });
            promise.promise(deferred);
            if (func) {
              func.call(deferred, deferred);
            }
            return deferred;
          },
          // Deferred helper
          when: function(singleValue) {
            var remaining = arguments.length, i = remaining, resolveContexts = Array(i), resolveValues = slice.call(arguments), primary = jQuery12.Deferred(), updateFunc = function(i2) {
              return function(value) {
                resolveContexts[i2] = this;
                resolveValues[i2] = arguments.length > 1 ? slice.call(arguments) : value;
                if (!--remaining) {
                  primary.resolveWith(resolveContexts, resolveValues);
                }
              };
            };
            if (remaining <= 1) {
              adoptValue(
                singleValue,
                primary.done(updateFunc(i)).resolve,
                primary.reject,
                !remaining
              );
              if (primary.state() === "pending" || isFunction(resolveValues[i] && resolveValues[i].then)) {
                return primary.then();
              }
            }
            while (i--) {
              adoptValue(resolveValues[i], updateFunc(i), primary.reject);
            }
            return primary.promise();
          }
        });
        var rerrorNames = /^(Eval|Internal|Range|Reference|Syntax|Type|URI)Error$/;
        jQuery12.Deferred.exceptionHook = function(error, asyncError) {
          if (window2.console && window2.console.warn && error && rerrorNames.test(error.name)) {
            window2.console.warn(
              "jQuery.Deferred exception: " + error.message,
              error.stack,
              asyncError
            );
          }
        };
        jQuery12.readyException = function(error) {
          window2.setTimeout(function() {
            throw error;
          });
        };
        var readyList = jQuery12.Deferred();
        jQuery12.fn.ready = function(fn2) {
          readyList.then(fn2).catch(function(error) {
            jQuery12.readyException(error);
          });
          return this;
        };
        jQuery12.extend({
          // Is the DOM ready to be used? Set to true once it occurs.
          isReady: false,
          // A counter to track how many items to wait for before
          // the ready event fires. See trac-6781
          readyWait: 1,
          // Handle when the DOM is ready
          ready: function(wait) {
            if (wait === true ? --jQuery12.readyWait : jQuery12.isReady) {
              return;
            }
            jQuery12.isReady = true;
            if (wait !== true && --jQuery12.readyWait > 0) {
              return;
            }
            readyList.resolveWith(document2, [jQuery12]);
          }
        });
        jQuery12.ready.then = readyList.then;
        function completed() {
          document2.removeEventListener("DOMContentLoaded", completed);
          window2.removeEventListener("load", completed);
          jQuery12.ready();
        }
        if (document2.readyState === "complete" || document2.readyState !== "loading" && !document2.documentElement.doScroll) {
          window2.setTimeout(jQuery12.ready);
        } else {
          document2.addEventListener("DOMContentLoaded", completed);
          window2.addEventListener("load", completed);
        }
        var access = function(elems, fn2, key, value, chainable, emptyGet, raw) {
          var i = 0, len = elems.length, bulk = key == null;
          if (toType2(key) === "object") {
            chainable = true;
            for (i in key) {
              access(elems, fn2, i, key[i], true, emptyGet, raw);
            }
          } else if (value !== void 0) {
            chainable = true;
            if (!isFunction(value)) {
              raw = true;
            }
            if (bulk) {
              if (raw) {
                fn2.call(elems, value);
                fn2 = null;
              } else {
                bulk = fn2;
                fn2 = function(elem, _key, value2) {
                  return bulk.call(jQuery12(elem), value2);
                };
              }
            }
            if (fn2) {
              for (; i < len; i++) {
                fn2(
                  elems[i],
                  key,
                  raw ? value : value.call(elems[i], i, fn2(elems[i], key))
                );
              }
            }
          }
          if (chainable) {
            return elems;
          }
          if (bulk) {
            return fn2.call(elems);
          }
          return len ? fn2(elems[0], key) : emptyGet;
        };
        var rmsPrefix = /^-ms-/, rdashAlpha = /-([a-z])/g;
        function fcamelCase(_all, letter) {
          return letter.toUpperCase();
        }
        function camelCase(string) {
          return string.replace(rmsPrefix, "ms-").replace(rdashAlpha, fcamelCase);
        }
        var acceptData = function(owner) {
          return owner.nodeType === 1 || owner.nodeType === 9 || !+owner.nodeType;
        };
        function Data2() {
          this.expando = jQuery12.expando + Data2.uid++;
        }
        Data2.uid = 1;
        Data2.prototype = {
          cache: function(owner) {
            var value = owner[this.expando];
            if (!value) {
              value = {};
              if (acceptData(owner)) {
                if (owner.nodeType) {
                  owner[this.expando] = value;
                } else {
                  Object.defineProperty(owner, this.expando, {
                    value,
                    configurable: true
                  });
                }
              }
            }
            return value;
          },
          set: function(owner, data, value) {
            var prop, cache2 = this.cache(owner);
            if (typeof data === "string") {
              cache2[camelCase(data)] = value;
            } else {
              for (prop in data) {
                cache2[camelCase(prop)] = data[prop];
              }
            }
            return cache2;
          },
          get: function(owner, key) {
            return key === void 0 ? this.cache(owner) : (
              // Always use camelCase key (gh-2257)
              owner[this.expando] && owner[this.expando][camelCase(key)]
            );
          },
          access: function(owner, key, value) {
            if (key === void 0 || key && typeof key === "string" && value === void 0) {
              return this.get(owner, key);
            }
            this.set(owner, key, value);
            return value !== void 0 ? value : key;
          },
          remove: function(owner, key) {
            var i, cache2 = owner[this.expando];
            if (cache2 === void 0) {
              return;
            }
            if (key !== void 0) {
              if (Array.isArray(key)) {
                key = key.map(camelCase);
              } else {
                key = camelCase(key);
                key = key in cache2 ? [key] : key.match(rnothtmlwhite) || [];
              }
              i = key.length;
              while (i--) {
                delete cache2[key[i]];
              }
            }
            if (key === void 0 || jQuery12.isEmptyObject(cache2)) {
              if (owner.nodeType) {
                owner[this.expando] = void 0;
              } else {
                delete owner[this.expando];
              }
            }
          },
          hasData: function(owner) {
            var cache2 = owner[this.expando];
            return cache2 !== void 0 && !jQuery12.isEmptyObject(cache2);
          }
        };
        var dataPriv = new Data2();
        var dataUser = new Data2();
        var rbrace = /^(?:\{[\w\W]*\}|\[[\w\W]*\])$/, rmultiDash = /[A-Z]/g;
        function getData(data) {
          if (data === "true") {
            return true;
          }
          if (data === "false") {
            return false;
          }
          if (data === "null") {
            return null;
          }
          if (data === +data + "") {
            return +data;
          }
          if (rbrace.test(data)) {
            return JSON.parse(data);
          }
          return data;
        }
        function dataAttr(elem, key, data) {
          var name;
          if (data === void 0 && elem.nodeType === 1) {
            name = "data-" + key.replace(rmultiDash, "-$&").toLowerCase();
            data = elem.getAttribute(name);
            if (typeof data === "string") {
              try {
                data = getData(data);
              } catch (e) {
              }
              dataUser.set(elem, key, data);
            } else {
              data = void 0;
            }
          }
          return data;
        }
        jQuery12.extend({
          hasData: function(elem) {
            return dataUser.hasData(elem) || dataPriv.hasData(elem);
          },
          data: function(elem, name, data) {
            return dataUser.access(elem, name, data);
          },
          removeData: function(elem, name) {
            dataUser.remove(elem, name);
          },
          // TODO: Now that all calls to _data and _removeData have been replaced
          // with direct calls to dataPriv methods, these can be deprecated.
          _data: function(elem, name, data) {
            return dataPriv.access(elem, name, data);
          },
          _removeData: function(elem, name) {
            dataPriv.remove(elem, name);
          }
        });
        jQuery12.fn.extend({
          data: function(key, value) {
            var i, name, data, elem = this[0], attrs = elem && elem.attributes;
            if (key === void 0) {
              if (this.length) {
                data = dataUser.get(elem);
                if (elem.nodeType === 1 && !dataPriv.get(elem, "hasDataAttrs")) {
                  i = attrs.length;
                  while (i--) {
                    if (attrs[i]) {
                      name = attrs[i].name;
                      if (name.indexOf("data-") === 0) {
                        name = camelCase(name.slice(5));
                        dataAttr(elem, name, data[name]);
                      }
                    }
                  }
                  dataPriv.set(elem, "hasDataAttrs", true);
                }
              }
              return data;
            }
            if (typeof key === "object") {
              return this.each(function() {
                dataUser.set(this, key);
              });
            }
            return access(this, function(value2) {
              var data2;
              if (elem && value2 === void 0) {
                data2 = dataUser.get(elem, key);
                if (data2 !== void 0) {
                  return data2;
                }
                data2 = dataAttr(elem, key);
                if (data2 !== void 0) {
                  return data2;
                }
                return;
              }
              this.each(function() {
                dataUser.set(this, key, value2);
              });
            }, null, value, arguments.length > 1, null, true);
          },
          removeData: function(key) {
            return this.each(function() {
              dataUser.remove(this, key);
            });
          }
        });
        jQuery12.extend({
          queue: function(elem, type, data) {
            var queue;
            if (elem) {
              type = (type || "fx") + "queue";
              queue = dataPriv.get(elem, type);
              if (data) {
                if (!queue || Array.isArray(data)) {
                  queue = dataPriv.access(elem, type, jQuery12.makeArray(data));
                } else {
                  queue.push(data);
                }
              }
              return queue || [];
            }
          },
          dequeue: function(elem, type) {
            type = type || "fx";
            var queue = jQuery12.queue(elem, type), startLength = queue.length, fn2 = queue.shift(), hooks = jQuery12._queueHooks(elem, type), next = function() {
              jQuery12.dequeue(elem, type);
            };
            if (fn2 === "inprogress") {
              fn2 = queue.shift();
              startLength--;
            }
            if (fn2) {
              if (type === "fx") {
                queue.unshift("inprogress");
              }
              delete hooks.stop;
              fn2.call(elem, next, hooks);
            }
            if (!startLength && hooks) {
              hooks.empty.fire();
            }
          },
          // Not public - generate a queueHooks object, or return the current one
          _queueHooks: function(elem, type) {
            var key = type + "queueHooks";
            return dataPriv.get(elem, key) || dataPriv.access(elem, key, {
              empty: jQuery12.Callbacks("once memory").add(function() {
                dataPriv.remove(elem, [type + "queue", key]);
              })
            });
          }
        });
        jQuery12.fn.extend({
          queue: function(type, data) {
            var setter = 2;
            if (typeof type !== "string") {
              data = type;
              type = "fx";
              setter--;
            }
            if (arguments.length < setter) {
              return jQuery12.queue(this[0], type);
            }
            return data === void 0 ? this : this.each(function() {
              var queue = jQuery12.queue(this, type, data);
              jQuery12._queueHooks(this, type);
              if (type === "fx" && queue[0] !== "inprogress") {
                jQuery12.dequeue(this, type);
              }
            });
          },
          dequeue: function(type) {
            return this.each(function() {
              jQuery12.dequeue(this, type);
            });
          },
          clearQueue: function(type) {
            return this.queue(type || "fx", []);
          },
          // Get a promise resolved when queues of a certain type
          // are emptied (fx is the type by default)
          promise: function(type, obj) {
            var tmp, count = 1, defer = jQuery12.Deferred(), elements = this, i = this.length, resolve = function() {
              if (!--count) {
                defer.resolveWith(elements, [elements]);
              }
            };
            if (typeof type !== "string") {
              obj = type;
              type = void 0;
            }
            type = type || "fx";
            while (i--) {
              tmp = dataPriv.get(elements[i], type + "queueHooks");
              if (tmp && tmp.empty) {
                count++;
                tmp.empty.add(resolve);
              }
            }
            resolve();
            return defer.promise(obj);
          }
        });
        var pnum = /[+-]?(?:\d*\.|)\d+(?:[eE][+-]?\d+|)/.source;
        var rcssNum = new RegExp("^(?:([+-])=|)(" + pnum + ")([a-z%]*)$", "i");
        var cssExpand = ["Top", "Right", "Bottom", "Left"];
        var documentElement = document2.documentElement;
        var isAttached = function(elem) {
          return jQuery12.contains(elem.ownerDocument, elem);
        }, composed = { composed: true };
        if (documentElement.getRootNode) {
          isAttached = function(elem) {
            return jQuery12.contains(elem.ownerDocument, elem) || elem.getRootNode(composed) === elem.ownerDocument;
          };
        }
        var isHiddenWithinTree = function(elem, el) {
          elem = el || elem;
          return elem.style.display === "none" || elem.style.display === "" && // Otherwise, check computed style
          // Support: Firefox <=43 - 45
          // Disconnected elements can have computed display: none, so first confirm that elem is
          // in the document.
          isAttached(elem) && jQuery12.css(elem, "display") === "none";
        };
        function adjustCSS(elem, prop, valueParts, tween) {
          var adjusted, scale, maxIterations = 20, currentValue = tween ? function() {
            return tween.cur();
          } : function() {
            return jQuery12.css(elem, prop, "");
          }, initial = currentValue(), unit = valueParts && valueParts[3] || (jQuery12.cssNumber[prop] ? "" : "px"), initialInUnit = elem.nodeType && (jQuery12.cssNumber[prop] || unit !== "px" && +initial) && rcssNum.exec(jQuery12.css(elem, prop));
          if (initialInUnit && initialInUnit[3] !== unit) {
            initial = initial / 2;
            unit = unit || initialInUnit[3];
            initialInUnit = +initial || 1;
            while (maxIterations--) {
              jQuery12.style(elem, prop, initialInUnit + unit);
              if ((1 - scale) * (1 - (scale = currentValue() / initial || 0.5)) <= 0) {
                maxIterations = 0;
              }
              initialInUnit = initialInUnit / scale;
            }
            initialInUnit = initialInUnit * 2;
            jQuery12.style(elem, prop, initialInUnit + unit);
            valueParts = valueParts || [];
          }
          if (valueParts) {
            initialInUnit = +initialInUnit || +initial || 0;
            adjusted = valueParts[1] ? initialInUnit + (valueParts[1] + 1) * valueParts[2] : +valueParts[2];
            if (tween) {
              tween.unit = unit;
              tween.start = initialInUnit;
              tween.end = adjusted;
            }
          }
          return adjusted;
        }
        var defaultDisplayMap = {};
        function getDefaultDisplay(elem) {
          var temp, doc = elem.ownerDocument, nodeName2 = elem.nodeName, display = defaultDisplayMap[nodeName2];
          if (display) {
            return display;
          }
          temp = doc.body.appendChild(doc.createElement(nodeName2));
          display = jQuery12.css(temp, "display");
          temp.parentNode.removeChild(temp);
          if (display === "none") {
            display = "block";
          }
          defaultDisplayMap[nodeName2] = display;
          return display;
        }
        function showHide(elements, show) {
          var display, elem, values = [], index = 0, length = elements.length;
          for (; index < length; index++) {
            elem = elements[index];
            if (!elem.style) {
              continue;
            }
            display = elem.style.display;
            if (show) {
              if (display === "none") {
                values[index] = dataPriv.get(elem, "display") || null;
                if (!values[index]) {
                  elem.style.display = "";
                }
              }
              if (elem.style.display === "" && isHiddenWithinTree(elem)) {
                values[index] = getDefaultDisplay(elem);
              }
            } else {
              if (display !== "none") {
                values[index] = "none";
                dataPriv.set(elem, "display", display);
              }
            }
          }
          for (index = 0; index < length; index++) {
            if (values[index] != null) {
              elements[index].style.display = values[index];
            }
          }
          return elements;
        }
        jQuery12.fn.extend({
          show: function() {
            return showHide(this, true);
          },
          hide: function() {
            return showHide(this);
          },
          toggle: function(state) {
            if (typeof state === "boolean") {
              return state ? this.show() : this.hide();
            }
            return this.each(function() {
              if (isHiddenWithinTree(this)) {
                jQuery12(this).show();
              } else {
                jQuery12(this).hide();
              }
            });
          }
        });
        var rcheckableType = /^(?:checkbox|radio)$/i;
        var rtagName = /<([a-z][^\/\0>\x20\t\r\n\f]*)/i;
        var rscriptType = /^$|^module$|\/(?:java|ecma)script/i;
        (function() {
          var fragment = document2.createDocumentFragment(), div = fragment.appendChild(document2.createElement("div")), input = document2.createElement("input");
          input.setAttribute("type", "radio");
          input.setAttribute("checked", "checked");
          input.setAttribute("name", "t");
          div.appendChild(input);
          support.checkClone = div.cloneNode(true).cloneNode(true).lastChild.checked;
          div.innerHTML = "<textarea>x</textarea>";
          support.noCloneChecked = !!div.cloneNode(true).lastChild.defaultValue;
          div.innerHTML = "<option></option>";
          support.option = !!div.lastChild;
        })();
        var wrapMap = {
          // XHTML parsers do not magically insert elements in the
          // same way that tag soup parsers do. So we cannot shorten
          // this by omitting <tbody> or other required elements.
          thead: [1, "<table>", "</table>"],
          col: [2, "<table><colgroup>", "</colgroup></table>"],
          tr: [2, "<table><tbody>", "</tbody></table>"],
          td: [3, "<table><tbody><tr>", "</tr></tbody></table>"],
          _default: [0, "", ""]
        };
        wrapMap.tbody = wrapMap.tfoot = wrapMap.colgroup = wrapMap.caption = wrapMap.thead;
        wrapMap.th = wrapMap.td;
        if (!support.option) {
          wrapMap.optgroup = wrapMap.option = [1, "<select multiple='multiple'>", "</select>"];
        }
        function getAll(context, tag) {
          var ret;
          if (typeof context.getElementsByTagName !== "undefined") {
            ret = context.getElementsByTagName(tag || "*");
          } else if (typeof context.querySelectorAll !== "undefined") {
            ret = context.querySelectorAll(tag || "*");
          } else {
            ret = [];
          }
          if (tag === void 0 || tag && nodeName(context, tag)) {
            return jQuery12.merge([context], ret);
          }
          return ret;
        }
        function setGlobalEval(elems, refElements) {
          var i = 0, l = elems.length;
          for (; i < l; i++) {
            dataPriv.set(
              elems[i],
              "globalEval",
              !refElements || dataPriv.get(refElements[i], "globalEval")
            );
          }
        }
        var rhtml = /<|&#?\w+;/;
        function buildFragment(elems, context, scripts, selection, ignored) {
          var elem, tmp, tag, wrap, attached, j, fragment = context.createDocumentFragment(), nodes = [], i = 0, l = elems.length;
          for (; i < l; i++) {
            elem = elems[i];
            if (elem || elem === 0) {
              if (toType2(elem) === "object") {
                jQuery12.merge(nodes, elem.nodeType ? [elem] : elem);
              } else if (!rhtml.test(elem)) {
                nodes.push(context.createTextNode(elem));
              } else {
                tmp = tmp || fragment.appendChild(context.createElement("div"));
                tag = (rtagName.exec(elem) || ["", ""])[1].toLowerCase();
                wrap = wrapMap[tag] || wrapMap._default;
                tmp.innerHTML = wrap[1] + jQuery12.htmlPrefilter(elem) + wrap[2];
                j = wrap[0];
                while (j--) {
                  tmp = tmp.lastChild;
                }
                jQuery12.merge(nodes, tmp.childNodes);
                tmp = fragment.firstChild;
                tmp.textContent = "";
              }
            }
          }
          fragment.textContent = "";
          i = 0;
          while (elem = nodes[i++]) {
            if (selection && jQuery12.inArray(elem, selection) > -1) {
              if (ignored) {
                ignored.push(elem);
              }
              continue;
            }
            attached = isAttached(elem);
            tmp = getAll(fragment.appendChild(elem), "script");
            if (attached) {
              setGlobalEval(tmp);
            }
            if (scripts) {
              j = 0;
              while (elem = tmp[j++]) {
                if (rscriptType.test(elem.type || "")) {
                  scripts.push(elem);
                }
              }
            }
          }
          return fragment;
        }
        var rtypenamespace = /^([^.]*)(?:\.(.+)|)/;
        function returnTrue() {
          return true;
        }
        function returnFalse() {
          return false;
        }
        function on(elem, types, selector, data, fn2, one) {
          var origFn, type;
          if (typeof types === "object") {
            if (typeof selector !== "string") {
              data = data || selector;
              selector = void 0;
            }
            for (type in types) {
              on(elem, type, selector, data, types[type], one);
            }
            return elem;
          }
          if (data == null && fn2 == null) {
            fn2 = selector;
            data = selector = void 0;
          } else if (fn2 == null) {
            if (typeof selector === "string") {
              fn2 = data;
              data = void 0;
            } else {
              fn2 = data;
              data = selector;
              selector = void 0;
            }
          }
          if (fn2 === false) {
            fn2 = returnFalse;
          } else if (!fn2) {
            return elem;
          }
          if (one === 1) {
            origFn = fn2;
            fn2 = function(event) {
              jQuery12().off(event);
              return origFn.apply(this, arguments);
            };
            fn2.guid = origFn.guid || (origFn.guid = jQuery12.guid++);
          }
          return elem.each(function() {
            jQuery12.event.add(this, types, fn2, data, selector);
          });
        }
        jQuery12.event = {
          global: {},
          add: function(elem, types, handler, data, selector) {
            var handleObjIn, eventHandle, tmp, events, t, handleObj, special, handlers, type, namespaces, origType, elemData = dataPriv.get(elem);
            if (!acceptData(elem)) {
              return;
            }
            if (handler.handler) {
              handleObjIn = handler;
              handler = handleObjIn.handler;
              selector = handleObjIn.selector;
            }
            if (selector) {
              jQuery12.find.matchesSelector(documentElement, selector);
            }
            if (!handler.guid) {
              handler.guid = jQuery12.guid++;
            }
            if (!(events = elemData.events)) {
              events = elemData.events = /* @__PURE__ */ Object.create(null);
            }
            if (!(eventHandle = elemData.handle)) {
              eventHandle = elemData.handle = function(e) {
                return typeof jQuery12 !== "undefined" && jQuery12.event.triggered !== e.type ? jQuery12.event.dispatch.apply(elem, arguments) : void 0;
              };
            }
            types = (types || "").match(rnothtmlwhite) || [""];
            t = types.length;
            while (t--) {
              tmp = rtypenamespace.exec(types[t]) || [];
              type = origType = tmp[1];
              namespaces = (tmp[2] || "").split(".").sort();
              if (!type) {
                continue;
              }
              special = jQuery12.event.special[type] || {};
              type = (selector ? special.delegateType : special.bindType) || type;
              special = jQuery12.event.special[type] || {};
              handleObj = jQuery12.extend({
                type,
                origType,
                data,
                handler,
                guid: handler.guid,
                selector,
                needsContext: selector && jQuery12.expr.match.needsContext.test(selector),
                namespace: namespaces.join(".")
              }, handleObjIn);
              if (!(handlers = events[type])) {
                handlers = events[type] = [];
                handlers.delegateCount = 0;
                if (!special.setup || special.setup.call(elem, data, namespaces, eventHandle) === false) {
                  if (elem.addEventListener) {
                    elem.addEventListener(type, eventHandle);
                  }
                }
              }
              if (special.add) {
                special.add.call(elem, handleObj);
                if (!handleObj.handler.guid) {
                  handleObj.handler.guid = handler.guid;
                }
              }
              if (selector) {
                handlers.splice(handlers.delegateCount++, 0, handleObj);
              } else {
                handlers.push(handleObj);
              }
              jQuery12.event.global[type] = true;
            }
          },
          // Detach an event or set of events from an element
          remove: function(elem, types, handler, selector, mappedTypes) {
            var j, origCount, tmp, events, t, handleObj, special, handlers, type, namespaces, origType, elemData = dataPriv.hasData(elem) && dataPriv.get(elem);
            if (!elemData || !(events = elemData.events)) {
              return;
            }
            types = (types || "").match(rnothtmlwhite) || [""];
            t = types.length;
            while (t--) {
              tmp = rtypenamespace.exec(types[t]) || [];
              type = origType = tmp[1];
              namespaces = (tmp[2] || "").split(".").sort();
              if (!type) {
                for (type in events) {
                  jQuery12.event.remove(elem, type + types[t], handler, selector, true);
                }
                continue;
              }
              special = jQuery12.event.special[type] || {};
              type = (selector ? special.delegateType : special.bindType) || type;
              handlers = events[type] || [];
              tmp = tmp[2] && new RegExp("(^|\\.)" + namespaces.join("\\.(?:.*\\.|)") + "(\\.|$)");
              origCount = j = handlers.length;
              while (j--) {
                handleObj = handlers[j];
                if ((mappedTypes || origType === handleObj.origType) && (!handler || handler.guid === handleObj.guid) && (!tmp || tmp.test(handleObj.namespace)) && (!selector || selector === handleObj.selector || selector === "**" && handleObj.selector)) {
                  handlers.splice(j, 1);
                  if (handleObj.selector) {
                    handlers.delegateCount--;
                  }
                  if (special.remove) {
                    special.remove.call(elem, handleObj);
                  }
                }
              }
              if (origCount && !handlers.length) {
                if (!special.teardown || special.teardown.call(elem, namespaces, elemData.handle) === false) {
                  jQuery12.removeEvent(elem, type, elemData.handle);
                }
                delete events[type];
              }
            }
            if (jQuery12.isEmptyObject(events)) {
              dataPriv.remove(elem, "handle events");
            }
          },
          dispatch: function(nativeEvent) {
            var i, j, ret, matched, handleObj, handlerQueue, args = new Array(arguments.length), event = jQuery12.event.fix(nativeEvent), handlers = (dataPriv.get(this, "events") || /* @__PURE__ */ Object.create(null))[event.type] || [], special = jQuery12.event.special[event.type] || {};
            args[0] = event;
            for (i = 1; i < arguments.length; i++) {
              args[i] = arguments[i];
            }
            event.delegateTarget = this;
            if (special.preDispatch && special.preDispatch.call(this, event) === false) {
              return;
            }
            handlerQueue = jQuery12.event.handlers.call(this, event, handlers);
            i = 0;
            while ((matched = handlerQueue[i++]) && !event.isPropagationStopped()) {
              event.currentTarget = matched.elem;
              j = 0;
              while ((handleObj = matched.handlers[j++]) && !event.isImmediatePropagationStopped()) {
                if (!event.rnamespace || handleObj.namespace === false || event.rnamespace.test(handleObj.namespace)) {
                  event.handleObj = handleObj;
                  event.data = handleObj.data;
                  ret = ((jQuery12.event.special[handleObj.origType] || {}).handle || handleObj.handler).apply(matched.elem, args);
                  if (ret !== void 0) {
                    if ((event.result = ret) === false) {
                      event.preventDefault();
                      event.stopPropagation();
                    }
                  }
                }
              }
            }
            if (special.postDispatch) {
              special.postDispatch.call(this, event);
            }
            return event.result;
          },
          handlers: function(event, handlers) {
            var i, handleObj, sel, matchedHandlers, matchedSelectors, handlerQueue = [], delegateCount = handlers.delegateCount, cur = event.target;
            if (delegateCount && // Support: IE <=9
            // Black-hole SVG <use> instance trees (trac-13180)
            cur.nodeType && // Support: Firefox <=42
            // Suppress spec-violating clicks indicating a non-primary pointer button (trac-3861)
            // https://www.w3.org/TR/DOM-Level-3-Events/#event-type-click
            // Support: IE 11 only
            // ...but not arrow key "clicks" of radio inputs, which can have `button` -1 (gh-2343)
            !(event.type === "click" && event.button >= 1)) {
              for (; cur !== this; cur = cur.parentNode || this) {
                if (cur.nodeType === 1 && !(event.type === "click" && cur.disabled === true)) {
                  matchedHandlers = [];
                  matchedSelectors = {};
                  for (i = 0; i < delegateCount; i++) {
                    handleObj = handlers[i];
                    sel = handleObj.selector + " ";
                    if (matchedSelectors[sel] === void 0) {
                      matchedSelectors[sel] = handleObj.needsContext ? jQuery12(sel, this).index(cur) > -1 : jQuery12.find(sel, this, null, [cur]).length;
                    }
                    if (matchedSelectors[sel]) {
                      matchedHandlers.push(handleObj);
                    }
                  }
                  if (matchedHandlers.length) {
                    handlerQueue.push({ elem: cur, handlers: matchedHandlers });
                  }
                }
              }
            }
            cur = this;
            if (delegateCount < handlers.length) {
              handlerQueue.push({ elem: cur, handlers: handlers.slice(delegateCount) });
            }
            return handlerQueue;
          },
          addProp: function(name, hook) {
            Object.defineProperty(jQuery12.Event.prototype, name, {
              enumerable: true,
              configurable: true,
              get: isFunction(hook) ? function() {
                if (this.originalEvent) {
                  return hook(this.originalEvent);
                }
              } : function() {
                if (this.originalEvent) {
                  return this.originalEvent[name];
                }
              },
              set: function(value) {
                Object.defineProperty(this, name, {
                  enumerable: true,
                  configurable: true,
                  writable: true,
                  value
                });
              }
            });
          },
          fix: function(originalEvent) {
            return originalEvent[jQuery12.expando] ? originalEvent : new jQuery12.Event(originalEvent);
          },
          special: {
            load: {
              // Prevent triggered image.load events from bubbling to window.load
              noBubble: true
            },
            click: {
              // Utilize native event to ensure correct state for checkable inputs
              setup: function(data) {
                var el = this || data;
                if (rcheckableType.test(el.type) && el.click && nodeName(el, "input")) {
                  leverageNative(el, "click", true);
                }
                return false;
              },
              trigger: function(data) {
                var el = this || data;
                if (rcheckableType.test(el.type) && el.click && nodeName(el, "input")) {
                  leverageNative(el, "click");
                }
                return true;
              },
              // For cross-browser consistency, suppress native .click() on links
              // Also prevent it if we're currently inside a leveraged native-event stack
              _default: function(event) {
                var target = event.target;
                return rcheckableType.test(target.type) && target.click && nodeName(target, "input") && dataPriv.get(target, "click") || nodeName(target, "a");
              }
            },
            beforeunload: {
              postDispatch: function(event) {
                if (event.result !== void 0 && event.originalEvent) {
                  event.originalEvent.returnValue = event.result;
                }
              }
            }
          }
        };
        function leverageNative(el, type, isSetup) {
          if (!isSetup) {
            if (dataPriv.get(el, type) === void 0) {
              jQuery12.event.add(el, type, returnTrue);
            }
            return;
          }
          dataPriv.set(el, type, false);
          jQuery12.event.add(el, type, {
            namespace: false,
            handler: function(event) {
              var result, saved = dataPriv.get(this, type);
              if (event.isTrigger & 1 && this[type]) {
                if (!saved) {
                  saved = slice.call(arguments);
                  dataPriv.set(this, type, saved);
                  this[type]();
                  result = dataPriv.get(this, type);
                  dataPriv.set(this, type, false);
                  if (saved !== result) {
                    event.stopImmediatePropagation();
                    event.preventDefault();
                    return result;
                  }
                } else if ((jQuery12.event.special[type] || {}).delegateType) {
                  event.stopPropagation();
                }
              } else if (saved) {
                dataPriv.set(this, type, jQuery12.event.trigger(
                  saved[0],
                  saved.slice(1),
                  this
                ));
                event.stopPropagation();
                event.isImmediatePropagationStopped = returnTrue;
              }
            }
          });
        }
        jQuery12.removeEvent = function(elem, type, handle) {
          if (elem.removeEventListener) {
            elem.removeEventListener(type, handle);
          }
        };
        jQuery12.Event = function(src, props) {
          if (!(this instanceof jQuery12.Event)) {
            return new jQuery12.Event(src, props);
          }
          if (src && src.type) {
            this.originalEvent = src;
            this.type = src.type;
            this.isDefaultPrevented = src.defaultPrevented || src.defaultPrevented === void 0 && // Support: Android <=2.3 only
            src.returnValue === false ? returnTrue : returnFalse;
            this.target = src.target && src.target.nodeType === 3 ? src.target.parentNode : src.target;
            this.currentTarget = src.currentTarget;
            this.relatedTarget = src.relatedTarget;
          } else {
            this.type = src;
          }
          if (props) {
            jQuery12.extend(this, props);
          }
          this.timeStamp = src && src.timeStamp || Date.now();
          this[jQuery12.expando] = true;
        };
        jQuery12.Event.prototype = {
          constructor: jQuery12.Event,
          isDefaultPrevented: returnFalse,
          isPropagationStopped: returnFalse,
          isImmediatePropagationStopped: returnFalse,
          isSimulated: false,
          preventDefault: function() {
            var e = this.originalEvent;
            this.isDefaultPrevented = returnTrue;
            if (e && !this.isSimulated) {
              e.preventDefault();
            }
          },
          stopPropagation: function() {
            var e = this.originalEvent;
            this.isPropagationStopped = returnTrue;
            if (e && !this.isSimulated) {
              e.stopPropagation();
            }
          },
          stopImmediatePropagation: function() {
            var e = this.originalEvent;
            this.isImmediatePropagationStopped = returnTrue;
            if (e && !this.isSimulated) {
              e.stopImmediatePropagation();
            }
            this.stopPropagation();
          }
        };
        jQuery12.each({
          altKey: true,
          bubbles: true,
          cancelable: true,
          changedTouches: true,
          ctrlKey: true,
          detail: true,
          eventPhase: true,
          metaKey: true,
          pageX: true,
          pageY: true,
          shiftKey: true,
          view: true,
          "char": true,
          code: true,
          charCode: true,
          key: true,
          keyCode: true,
          button: true,
          buttons: true,
          clientX: true,
          clientY: true,
          offsetX: true,
          offsetY: true,
          pointerId: true,
          pointerType: true,
          screenX: true,
          screenY: true,
          targetTouches: true,
          toElement: true,
          touches: true,
          which: true
        }, jQuery12.event.addProp);
        jQuery12.each({ focus: "focusin", blur: "focusout" }, function(type, delegateType) {
          function focusMappedHandler(nativeEvent) {
            if (document2.documentMode) {
              var handle = dataPriv.get(this, "handle"), event = jQuery12.event.fix(nativeEvent);
              event.type = nativeEvent.type === "focusin" ? "focus" : "blur";
              event.isSimulated = true;
              handle(nativeEvent);
              if (event.target === event.currentTarget) {
                handle(event);
              }
            } else {
              jQuery12.event.simulate(
                delegateType,
                nativeEvent.target,
                jQuery12.event.fix(nativeEvent)
              );
            }
          }
          jQuery12.event.special[type] = {
            // Utilize native event if possible so blur/focus sequence is correct
            setup: function() {
              var attaches;
              leverageNative(this, type, true);
              if (document2.documentMode) {
                attaches = dataPriv.get(this, delegateType);
                if (!attaches) {
                  this.addEventListener(delegateType, focusMappedHandler);
                }
                dataPriv.set(this, delegateType, (attaches || 0) + 1);
              } else {
                return false;
              }
            },
            trigger: function() {
              leverageNative(this, type);
              return true;
            },
            teardown: function() {
              var attaches;
              if (document2.documentMode) {
                attaches = dataPriv.get(this, delegateType) - 1;
                if (!attaches) {
                  this.removeEventListener(delegateType, focusMappedHandler);
                  dataPriv.remove(this, delegateType);
                } else {
                  dataPriv.set(this, delegateType, attaches);
                }
              } else {
                return false;
              }
            },
            // Suppress native focus or blur if we're currently inside
            // a leveraged native-event stack
            _default: function(event) {
              return dataPriv.get(event.target, type);
            },
            delegateType
          };
          jQuery12.event.special[delegateType] = {
            setup: function() {
              var doc = this.ownerDocument || this.document || this, dataHolder = document2.documentMode ? this : doc, attaches = dataPriv.get(dataHolder, delegateType);
              if (!attaches) {
                if (document2.documentMode) {
                  this.addEventListener(delegateType, focusMappedHandler);
                } else {
                  doc.addEventListener(type, focusMappedHandler, true);
                }
              }
              dataPriv.set(dataHolder, delegateType, (attaches || 0) + 1);
            },
            teardown: function() {
              var doc = this.ownerDocument || this.document || this, dataHolder = document2.documentMode ? this : doc, attaches = dataPriv.get(dataHolder, delegateType) - 1;
              if (!attaches) {
                if (document2.documentMode) {
                  this.removeEventListener(delegateType, focusMappedHandler);
                } else {
                  doc.removeEventListener(type, focusMappedHandler, true);
                }
                dataPriv.remove(dataHolder, delegateType);
              } else {
                dataPriv.set(dataHolder, delegateType, attaches);
              }
            }
          };
        });
        jQuery12.each({
          mouseenter: "mouseover",
          mouseleave: "mouseout",
          pointerenter: "pointerover",
          pointerleave: "pointerout"
        }, function(orig, fix) {
          jQuery12.event.special[orig] = {
            delegateType: fix,
            bindType: fix,
            handle: function(event) {
              var ret, target = this, related = event.relatedTarget, handleObj = event.handleObj;
              if (!related || related !== target && !jQuery12.contains(target, related)) {
                event.type = handleObj.origType;
                ret = handleObj.handler.apply(this, arguments);
                event.type = fix;
              }
              return ret;
            }
          };
        });
        jQuery12.fn.extend({
          on: function(types, selector, data, fn2) {
            return on(this, types, selector, data, fn2);
          },
          one: function(types, selector, data, fn2) {
            return on(this, types, selector, data, fn2, 1);
          },
          off: function(types, selector, fn2) {
            var handleObj, type;
            if (types && types.preventDefault && types.handleObj) {
              handleObj = types.handleObj;
              jQuery12(types.delegateTarget).off(
                handleObj.namespace ? handleObj.origType + "." + handleObj.namespace : handleObj.origType,
                handleObj.selector,
                handleObj.handler
              );
              return this;
            }
            if (typeof types === "object") {
              for (type in types) {
                this.off(type, selector, types[type]);
              }
              return this;
            }
            if (selector === false || typeof selector === "function") {
              fn2 = selector;
              selector = void 0;
            }
            if (fn2 === false) {
              fn2 = returnFalse;
            }
            return this.each(function() {
              jQuery12.event.remove(this, types, fn2, selector);
            });
          }
        });
        var rnoInnerhtml = /<script|<style|<link/i, rchecked = /checked\s*(?:[^=]|=\s*.checked.)/i, rcleanScript = /^\s*<!\[CDATA\[|\]\]>\s*$/g;
        function manipulationTarget(elem, content) {
          if (nodeName(elem, "table") && nodeName(content.nodeType !== 11 ? content : content.firstChild, "tr")) {
            return jQuery12(elem).children("tbody")[0] || elem;
          }
          return elem;
        }
        function disableScript(elem) {
          elem.type = (elem.getAttribute("type") !== null) + "/" + elem.type;
          return elem;
        }
        function restoreScript(elem) {
          if ((elem.type || "").slice(0, 5) === "true/") {
            elem.type = elem.type.slice(5);
          } else {
            elem.removeAttribute("type");
          }
          return elem;
        }
        function cloneCopyEvent(src, dest) {
          var i, l, type, pdataOld, udataOld, udataCur, events;
          if (dest.nodeType !== 1) {
            return;
          }
          if (dataPriv.hasData(src)) {
            pdataOld = dataPriv.get(src);
            events = pdataOld.events;
            if (events) {
              dataPriv.remove(dest, "handle events");
              for (type in events) {
                for (i = 0, l = events[type].length; i < l; i++) {
                  jQuery12.event.add(dest, type, events[type][i]);
                }
              }
            }
          }
          if (dataUser.hasData(src)) {
            udataOld = dataUser.access(src);
            udataCur = jQuery12.extend({}, udataOld);
            dataUser.set(dest, udataCur);
          }
        }
        function fixInput(src, dest) {
          var nodeName2 = dest.nodeName.toLowerCase();
          if (nodeName2 === "input" && rcheckableType.test(src.type)) {
            dest.checked = src.checked;
          } else if (nodeName2 === "input" || nodeName2 === "textarea") {
            dest.defaultValue = src.defaultValue;
          }
        }
        function domManip(collection, args, callback, ignored) {
          args = flat(args);
          var fragment, first, scripts, hasScripts, node, doc, i = 0, l = collection.length, iNoClone = l - 1, value = args[0], valueIsFunction = isFunction(value);
          if (valueIsFunction || l > 1 && typeof value === "string" && !support.checkClone && rchecked.test(value)) {
            return collection.each(function(index) {
              var self2 = collection.eq(index);
              if (valueIsFunction) {
                args[0] = value.call(this, index, self2.html());
              }
              domManip(self2, args, callback, ignored);
            });
          }
          if (l) {
            fragment = buildFragment(args, collection[0].ownerDocument, false, collection, ignored);
            first = fragment.firstChild;
            if (fragment.childNodes.length === 1) {
              fragment = first;
            }
            if (first || ignored) {
              scripts = jQuery12.map(getAll(fragment, "script"), disableScript);
              hasScripts = scripts.length;
              for (; i < l; i++) {
                node = fragment;
                if (i !== iNoClone) {
                  node = jQuery12.clone(node, true, true);
                  if (hasScripts) {
                    jQuery12.merge(scripts, getAll(node, "script"));
                  }
                }
                callback.call(collection[i], node, i);
              }
              if (hasScripts) {
                doc = scripts[scripts.length - 1].ownerDocument;
                jQuery12.map(scripts, restoreScript);
                for (i = 0; i < hasScripts; i++) {
                  node = scripts[i];
                  if (rscriptType.test(node.type || "") && !dataPriv.access(node, "globalEval") && jQuery12.contains(doc, node)) {
                    if (node.src && (node.type || "").toLowerCase() !== "module") {
                      if (jQuery12._evalUrl && !node.noModule) {
                        jQuery12._evalUrl(node.src, {
                          nonce: node.nonce || node.getAttribute("nonce")
                        }, doc);
                      }
                    } else {
                      DOMEval(node.textContent.replace(rcleanScript, ""), node, doc);
                    }
                  }
                }
              }
            }
          }
          return collection;
        }
        function remove(elem, selector, keepData) {
          var node, nodes = selector ? jQuery12.filter(selector, elem) : elem, i = 0;
          for (; (node = nodes[i]) != null; i++) {
            if (!keepData && node.nodeType === 1) {
              jQuery12.cleanData(getAll(node));
            }
            if (node.parentNode) {
              if (keepData && isAttached(node)) {
                setGlobalEval(getAll(node, "script"));
              }
              node.parentNode.removeChild(node);
            }
          }
          return elem;
        }
        jQuery12.extend({
          htmlPrefilter: function(html) {
            return html;
          },
          clone: function(elem, dataAndEvents, deepDataAndEvents) {
            var i, l, srcElements, destElements, clone = elem.cloneNode(true), inPage = isAttached(elem);
            if (!support.noCloneChecked && (elem.nodeType === 1 || elem.nodeType === 11) && !jQuery12.isXMLDoc(elem)) {
              destElements = getAll(clone);
              srcElements = getAll(elem);
              for (i = 0, l = srcElements.length; i < l; i++) {
                fixInput(srcElements[i], destElements[i]);
              }
            }
            if (dataAndEvents) {
              if (deepDataAndEvents) {
                srcElements = srcElements || getAll(elem);
                destElements = destElements || getAll(clone);
                for (i = 0, l = srcElements.length; i < l; i++) {
                  cloneCopyEvent(srcElements[i], destElements[i]);
                }
              } else {
                cloneCopyEvent(elem, clone);
              }
            }
            destElements = getAll(clone, "script");
            if (destElements.length > 0) {
              setGlobalEval(destElements, !inPage && getAll(elem, "script"));
            }
            return clone;
          },
          cleanData: function(elems) {
            var data, elem, type, special = jQuery12.event.special, i = 0;
            for (; (elem = elems[i]) !== void 0; i++) {
              if (acceptData(elem)) {
                if (data = elem[dataPriv.expando]) {
                  if (data.events) {
                    for (type in data.events) {
                      if (special[type]) {
                        jQuery12.event.remove(elem, type);
                      } else {
                        jQuery12.removeEvent(elem, type, data.handle);
                      }
                    }
                  }
                  elem[dataPriv.expando] = void 0;
                }
                if (elem[dataUser.expando]) {
                  elem[dataUser.expando] = void 0;
                }
              }
            }
          }
        });
        jQuery12.fn.extend({
          detach: function(selector) {
            return remove(this, selector, true);
          },
          remove: function(selector) {
            return remove(this, selector);
          },
          text: function(value) {
            return access(this, function(value2) {
              return value2 === void 0 ? jQuery12.text(this) : this.empty().each(function() {
                if (this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9) {
                  this.textContent = value2;
                }
              });
            }, null, value, arguments.length);
          },
          append: function() {
            return domManip(this, arguments, function(elem) {
              if (this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9) {
                var target = manipulationTarget(this, elem);
                target.appendChild(elem);
              }
            });
          },
          prepend: function() {
            return domManip(this, arguments, function(elem) {
              if (this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9) {
                var target = manipulationTarget(this, elem);
                target.insertBefore(elem, target.firstChild);
              }
            });
          },
          before: function() {
            return domManip(this, arguments, function(elem) {
              if (this.parentNode) {
                this.parentNode.insertBefore(elem, this);
              }
            });
          },
          after: function() {
            return domManip(this, arguments, function(elem) {
              if (this.parentNode) {
                this.parentNode.insertBefore(elem, this.nextSibling);
              }
            });
          },
          empty: function() {
            var elem, i = 0;
            for (; (elem = this[i]) != null; i++) {
              if (elem.nodeType === 1) {
                jQuery12.cleanData(getAll(elem, false));
                elem.textContent = "";
              }
            }
            return this;
          },
          clone: function(dataAndEvents, deepDataAndEvents) {
            dataAndEvents = dataAndEvents == null ? false : dataAndEvents;
            deepDataAndEvents = deepDataAndEvents == null ? dataAndEvents : deepDataAndEvents;
            return this.map(function() {
              return jQuery12.clone(this, dataAndEvents, deepDataAndEvents);
            });
          },
          html: function(value) {
            return access(this, function(value2) {
              var elem = this[0] || {}, i = 0, l = this.length;
              if (value2 === void 0 && elem.nodeType === 1) {
                return elem.innerHTML;
              }
              if (typeof value2 === "string" && !rnoInnerhtml.test(value2) && !wrapMap[(rtagName.exec(value2) || ["", ""])[1].toLowerCase()]) {
                value2 = jQuery12.htmlPrefilter(value2);
                try {
                  for (; i < l; i++) {
                    elem = this[i] || {};
                    if (elem.nodeType === 1) {
                      jQuery12.cleanData(getAll(elem, false));
                      elem.innerHTML = value2;
                    }
                  }
                  elem = 0;
                } catch (e) {
                }
              }
              if (elem) {
                this.empty().append(value2);
              }
            }, null, value, arguments.length);
          },
          replaceWith: function() {
            var ignored = [];
            return domManip(this, arguments, function(elem) {
              var parent = this.parentNode;
              if (jQuery12.inArray(this, ignored) < 0) {
                jQuery12.cleanData(getAll(this));
                if (parent) {
                  parent.replaceChild(elem, this);
                }
              }
            }, ignored);
          }
        });
        jQuery12.each({
          appendTo: "append",
          prependTo: "prepend",
          insertBefore: "before",
          insertAfter: "after",
          replaceAll: "replaceWith"
        }, function(name, original) {
          jQuery12.fn[name] = function(selector) {
            var elems, ret = [], insert = jQuery12(selector), last = insert.length - 1, i = 0;
            for (; i <= last; i++) {
              elems = i === last ? this : this.clone(true);
              jQuery12(insert[i])[original](elems);
              push.apply(ret, elems.get());
            }
            return this.pushStack(ret);
          };
        });
        var rnumnonpx = new RegExp("^(" + pnum + ")(?!px)[a-z%]+$", "i");
        var rcustomProp = /^--/;
        var getStyles = function(elem) {
          var view = elem.ownerDocument.defaultView;
          if (!view || !view.opener) {
            view = window2;
          }
          return view.getComputedStyle(elem);
        };
        var swap = function(elem, options, callback) {
          var ret, name, old = {};
          for (name in options) {
            old[name] = elem.style[name];
            elem.style[name] = options[name];
          }
          ret = callback.call(elem);
          for (name in options) {
            elem.style[name] = old[name];
          }
          return ret;
        };
        var rboxStyle = new RegExp(cssExpand.join("|"), "i");
        (function() {
          function computeStyleTests() {
            if (!div) {
              return;
            }
            container.style.cssText = "position:absolute;left:-11111px;width:60px;margin-top:1px;padding:0;border:0";
            div.style.cssText = "position:relative;display:block;box-sizing:border-box;overflow:scroll;margin:auto;border:1px;padding:1px;width:60%;top:1%";
            documentElement.appendChild(container).appendChild(div);
            var divStyle = window2.getComputedStyle(div);
            pixelPositionVal = divStyle.top !== "1%";
            reliableMarginLeftVal = roundPixelMeasures(divStyle.marginLeft) === 12;
            div.style.right = "60%";
            pixelBoxStylesVal = roundPixelMeasures(divStyle.right) === 36;
            boxSizingReliableVal = roundPixelMeasures(divStyle.width) === 36;
            div.style.position = "absolute";
            scrollboxSizeVal = roundPixelMeasures(div.offsetWidth / 3) === 12;
            documentElement.removeChild(container);
            div = null;
          }
          function roundPixelMeasures(measure) {
            return Math.round(parseFloat(measure));
          }
          var pixelPositionVal, boxSizingReliableVal, scrollboxSizeVal, pixelBoxStylesVal, reliableTrDimensionsVal, reliableMarginLeftVal, container = document2.createElement("div"), div = document2.createElement("div");
          if (!div.style) {
            return;
          }
          div.style.backgroundClip = "content-box";
          div.cloneNode(true).style.backgroundClip = "";
          support.clearCloneStyle = div.style.backgroundClip === "content-box";
          jQuery12.extend(support, {
            boxSizingReliable: function() {
              computeStyleTests();
              return boxSizingReliableVal;
            },
            pixelBoxStyles: function() {
              computeStyleTests();
              return pixelBoxStylesVal;
            },
            pixelPosition: function() {
              computeStyleTests();
              return pixelPositionVal;
            },
            reliableMarginLeft: function() {
              computeStyleTests();
              return reliableMarginLeftVal;
            },
            scrollboxSize: function() {
              computeStyleTests();
              return scrollboxSizeVal;
            },
            // Support: IE 9 - 11+, Edge 15 - 18+
            // IE/Edge misreport `getComputedStyle` of table rows with width/height
            // set in CSS while `offset*` properties report correct values.
            // Behavior in IE 9 is more subtle than in newer versions & it passes
            // some versions of this test; make sure not to make it pass there!
            //
            // Support: Firefox 70+
            // Only Firefox includes border widths
            // in computed dimensions. (gh-4529)
            reliableTrDimensions: function() {
              var table, tr, trChild, trStyle;
              if (reliableTrDimensionsVal == null) {
                table = document2.createElement("table");
                tr = document2.createElement("tr");
                trChild = document2.createElement("div");
                table.style.cssText = "position:absolute;left:-11111px;border-collapse:separate";
                tr.style.cssText = "box-sizing:content-box;border:1px solid";
                tr.style.height = "1px";
                trChild.style.height = "9px";
                trChild.style.display = "block";
                documentElement.appendChild(table).appendChild(tr).appendChild(trChild);
                trStyle = window2.getComputedStyle(tr);
                reliableTrDimensionsVal = parseInt(trStyle.height, 10) + parseInt(trStyle.borderTopWidth, 10) + parseInt(trStyle.borderBottomWidth, 10) === tr.offsetHeight;
                documentElement.removeChild(table);
              }
              return reliableTrDimensionsVal;
            }
          });
        })();
        function curCSS(elem, name, computed) {
          var width, minWidth, maxWidth, ret, isCustomProp = rcustomProp.test(name), style = elem.style;
          computed = computed || getStyles(elem);
          if (computed) {
            ret = computed.getPropertyValue(name) || computed[name];
            if (isCustomProp && ret) {
              ret = ret.replace(rtrimCSS, "$1") || void 0;
            }
            if (ret === "" && !isAttached(elem)) {
              ret = jQuery12.style(elem, name);
            }
            if (!support.pixelBoxStyles() && rnumnonpx.test(ret) && rboxStyle.test(name)) {
              width = style.width;
              minWidth = style.minWidth;
              maxWidth = style.maxWidth;
              style.minWidth = style.maxWidth = style.width = ret;
              ret = computed.width;
              style.width = width;
              style.minWidth = minWidth;
              style.maxWidth = maxWidth;
            }
          }
          return ret !== void 0 ? (
            // Support: IE <=9 - 11 only
            // IE returns zIndex value as an integer.
            ret + ""
          ) : ret;
        }
        function addGetHookIf(conditionFn, hookFn) {
          return {
            get: function() {
              if (conditionFn()) {
                delete this.get;
                return;
              }
              return (this.get = hookFn).apply(this, arguments);
            }
          };
        }
        var cssPrefixes = ["Webkit", "Moz", "ms"], emptyStyle = document2.createElement("div").style, vendorProps = {};
        function vendorPropName(name) {
          var capName = name[0].toUpperCase() + name.slice(1), i = cssPrefixes.length;
          while (i--) {
            name = cssPrefixes[i] + capName;
            if (name in emptyStyle) {
              return name;
            }
          }
        }
        function finalPropName(name) {
          var final = jQuery12.cssProps[name] || vendorProps[name];
          if (final) {
            return final;
          }
          if (name in emptyStyle) {
            return name;
          }
          return vendorProps[name] = vendorPropName(name) || name;
        }
        var rdisplayswap = /^(none|table(?!-c[ea]).+)/, cssShow = { position: "absolute", visibility: "hidden", display: "block" }, cssNormalTransform = {
          letterSpacing: "0",
          fontWeight: "400"
        };
        function setPositiveNumber(_elem, value, subtract) {
          var matches = rcssNum.exec(value);
          return matches ? (
            // Guard against undefined "subtract", e.g., when used as in cssHooks
            Math.max(0, matches[2] - (subtract || 0)) + (matches[3] || "px")
          ) : value;
        }
        function boxModelAdjustment(elem, dimension, box, isBorderBox, styles, computedVal) {
          var i = dimension === "width" ? 1 : 0, extra = 0, delta = 0, marginDelta = 0;
          if (box === (isBorderBox ? "border" : "content")) {
            return 0;
          }
          for (; i < 4; i += 2) {
            if (box === "margin") {
              marginDelta += jQuery12.css(elem, box + cssExpand[i], true, styles);
            }
            if (!isBorderBox) {
              delta += jQuery12.css(elem, "padding" + cssExpand[i], true, styles);
              if (box !== "padding") {
                delta += jQuery12.css(elem, "border" + cssExpand[i] + "Width", true, styles);
              } else {
                extra += jQuery12.css(elem, "border" + cssExpand[i] + "Width", true, styles);
              }
            } else {
              if (box === "content") {
                delta -= jQuery12.css(elem, "padding" + cssExpand[i], true, styles);
              }
              if (box !== "margin") {
                delta -= jQuery12.css(elem, "border" + cssExpand[i] + "Width", true, styles);
              }
            }
          }
          if (!isBorderBox && computedVal >= 0) {
            delta += Math.max(0, Math.ceil(
              elem["offset" + dimension[0].toUpperCase() + dimension.slice(1)] - computedVal - delta - extra - 0.5
              // If offsetWidth/offsetHeight is unknown, then we can't determine content-box scroll gutter
              // Use an explicit zero to avoid NaN (gh-3964)
            )) || 0;
          }
          return delta + marginDelta;
        }
        function getWidthOrHeight(elem, dimension, extra) {
          var styles = getStyles(elem), boxSizingNeeded = !support.boxSizingReliable() || extra, isBorderBox = boxSizingNeeded && jQuery12.css(elem, "boxSizing", false, styles) === "border-box", valueIsBorderBox = isBorderBox, val = curCSS(elem, dimension, styles), offsetProp = "offset" + dimension[0].toUpperCase() + dimension.slice(1);
          if (rnumnonpx.test(val)) {
            if (!extra) {
              return val;
            }
            val = "auto";
          }
          if ((!support.boxSizingReliable() && isBorderBox || // Support: IE 10 - 11+, Edge 15 - 18+
          // IE/Edge misreport `getComputedStyle` of table rows with width/height
          // set in CSS while `offset*` properties report correct values.
          // Interestingly, in some cases IE 9 doesn't suffer from this issue.
          !support.reliableTrDimensions() && nodeName(elem, "tr") || // Fall back to offsetWidth/offsetHeight when value is "auto"
          // This happens for inline elements with no explicit setting (gh-3571)
          val === "auto" || // Support: Android <=4.1 - 4.3 only
          // Also use offsetWidth/offsetHeight for misreported inline dimensions (gh-3602)
          !parseFloat(val) && jQuery12.css(elem, "display", false, styles) === "inline") && // Make sure the element is visible & connected
          elem.getClientRects().length) {
            isBorderBox = jQuery12.css(elem, "boxSizing", false, styles) === "border-box";
            valueIsBorderBox = offsetProp in elem;
            if (valueIsBorderBox) {
              val = elem[offsetProp];
            }
          }
          val = parseFloat(val) || 0;
          return val + boxModelAdjustment(
            elem,
            dimension,
            extra || (isBorderBox ? "border" : "content"),
            valueIsBorderBox,
            styles,
            // Provide the current computed size to request scroll gutter calculation (gh-3589)
            val
          ) + "px";
        }
        jQuery12.extend({
          // Add in style property hooks for overriding the default
          // behavior of getting and setting a style property
          cssHooks: {
            opacity: {
              get: function(elem, computed) {
                if (computed) {
                  var ret = curCSS(elem, "opacity");
                  return ret === "" ? "1" : ret;
                }
              }
            }
          },
          // Don't automatically add "px" to these possibly-unitless properties
          cssNumber: {
            animationIterationCount: true,
            aspectRatio: true,
            borderImageSlice: true,
            columnCount: true,
            flexGrow: true,
            flexShrink: true,
            fontWeight: true,
            gridArea: true,
            gridColumn: true,
            gridColumnEnd: true,
            gridColumnStart: true,
            gridRow: true,
            gridRowEnd: true,
            gridRowStart: true,
            lineHeight: true,
            opacity: true,
            order: true,
            orphans: true,
            scale: true,
            widows: true,
            zIndex: true,
            zoom: true,
            // SVG-related
            fillOpacity: true,
            floodOpacity: true,
            stopOpacity: true,
            strokeMiterlimit: true,
            strokeOpacity: true
          },
          // Add in properties whose names you wish to fix before
          // setting or getting the value
          cssProps: {},
          // Get and set the style property on a DOM Node
          style: function(elem, name, value, extra) {
            if (!elem || elem.nodeType === 3 || elem.nodeType === 8 || !elem.style) {
              return;
            }
            var ret, type, hooks, origName = camelCase(name), isCustomProp = rcustomProp.test(name), style = elem.style;
            if (!isCustomProp) {
              name = finalPropName(origName);
            }
            hooks = jQuery12.cssHooks[name] || jQuery12.cssHooks[origName];
            if (value !== void 0) {
              type = typeof value;
              if (type === "string" && (ret = rcssNum.exec(value)) && ret[1]) {
                value = adjustCSS(elem, name, ret);
                type = "number";
              }
              if (value == null || value !== value) {
                return;
              }
              if (type === "number" && !isCustomProp) {
                value += ret && ret[3] || (jQuery12.cssNumber[origName] ? "" : "px");
              }
              if (!support.clearCloneStyle && value === "" && name.indexOf("background") === 0) {
                style[name] = "inherit";
              }
              if (!hooks || !("set" in hooks) || (value = hooks.set(elem, value, extra)) !== void 0) {
                if (isCustomProp) {
                  style.setProperty(name, value);
                } else {
                  style[name] = value;
                }
              }
            } else {
              if (hooks && "get" in hooks && (ret = hooks.get(elem, false, extra)) !== void 0) {
                return ret;
              }
              return style[name];
            }
          },
          css: function(elem, name, extra, styles) {
            var val, num, hooks, origName = camelCase(name), isCustomProp = rcustomProp.test(name);
            if (!isCustomProp) {
              name = finalPropName(origName);
            }
            hooks = jQuery12.cssHooks[name] || jQuery12.cssHooks[origName];
            if (hooks && "get" in hooks) {
              val = hooks.get(elem, true, extra);
            }
            if (val === void 0) {
              val = curCSS(elem, name, styles);
            }
            if (val === "normal" && name in cssNormalTransform) {
              val = cssNormalTransform[name];
            }
            if (extra === "" || extra) {
              num = parseFloat(val);
              return extra === true || isFinite(num) ? num || 0 : val;
            }
            return val;
          }
        });
        jQuery12.each(["height", "width"], function(_i, dimension) {
          jQuery12.cssHooks[dimension] = {
            get: function(elem, computed, extra) {
              if (computed) {
                return rdisplayswap.test(jQuery12.css(elem, "display")) && // Support: Safari 8+
                // Table columns in Safari have non-zero offsetWidth & zero
                // getBoundingClientRect().width unless display is changed.
                // Support: IE <=11 only
                // Running getBoundingClientRect on a disconnected node
                // in IE throws an error.
                (!elem.getClientRects().length || !elem.getBoundingClientRect().width) ? swap(elem, cssShow, function() {
                  return getWidthOrHeight(elem, dimension, extra);
                }) : getWidthOrHeight(elem, dimension, extra);
              }
            },
            set: function(elem, value, extra) {
              var matches, styles = getStyles(elem), scrollboxSizeBuggy = !support.scrollboxSize() && styles.position === "absolute", boxSizingNeeded = scrollboxSizeBuggy || extra, isBorderBox = boxSizingNeeded && jQuery12.css(elem, "boxSizing", false, styles) === "border-box", subtract = extra ? boxModelAdjustment(
                elem,
                dimension,
                extra,
                isBorderBox,
                styles
              ) : 0;
              if (isBorderBox && scrollboxSizeBuggy) {
                subtract -= Math.ceil(
                  elem["offset" + dimension[0].toUpperCase() + dimension.slice(1)] - parseFloat(styles[dimension]) - boxModelAdjustment(elem, dimension, "border", false, styles) - 0.5
                );
              }
              if (subtract && (matches = rcssNum.exec(value)) && (matches[3] || "px") !== "px") {
                elem.style[dimension] = value;
                value = jQuery12.css(elem, dimension);
              }
              return setPositiveNumber(elem, value, subtract);
            }
          };
        });
        jQuery12.cssHooks.marginLeft = addGetHookIf(
          support.reliableMarginLeft,
          function(elem, computed) {
            if (computed) {
              return (parseFloat(curCSS(elem, "marginLeft")) || elem.getBoundingClientRect().left - swap(elem, { marginLeft: 0 }, function() {
                return elem.getBoundingClientRect().left;
              })) + "px";
            }
          }
        );
        jQuery12.each({
          margin: "",
          padding: "",
          border: "Width"
        }, function(prefix, suffix) {
          jQuery12.cssHooks[prefix + suffix] = {
            expand: function(value) {
              var i = 0, expanded = {}, parts = typeof value === "string" ? value.split(" ") : [value];
              for (; i < 4; i++) {
                expanded[prefix + cssExpand[i] + suffix] = parts[i] || parts[i - 2] || parts[0];
              }
              return expanded;
            }
          };
          if (prefix !== "margin") {
            jQuery12.cssHooks[prefix + suffix].set = setPositiveNumber;
          }
        });
        jQuery12.fn.extend({
          css: function(name, value) {
            return access(this, function(elem, name2, value2) {
              var styles, len, map = {}, i = 0;
              if (Array.isArray(name2)) {
                styles = getStyles(elem);
                len = name2.length;
                for (; i < len; i++) {
                  map[name2[i]] = jQuery12.css(elem, name2[i], false, styles);
                }
                return map;
              }
              return value2 !== void 0 ? jQuery12.style(elem, name2, value2) : jQuery12.css(elem, name2);
            }, name, value, arguments.length > 1);
          }
        });
        function Tween(elem, options, prop, end2, easing) {
          return new Tween.prototype.init(elem, options, prop, end2, easing);
        }
        jQuery12.Tween = Tween;
        Tween.prototype = {
          constructor: Tween,
          init: function(elem, options, prop, end2, easing, unit) {
            this.elem = elem;
            this.prop = prop;
            this.easing = easing || jQuery12.easing._default;
            this.options = options;
            this.start = this.now = this.cur();
            this.end = end2;
            this.unit = unit || (jQuery12.cssNumber[prop] ? "" : "px");
          },
          cur: function() {
            var hooks = Tween.propHooks[this.prop];
            return hooks && hooks.get ? hooks.get(this) : Tween.propHooks._default.get(this);
          },
          run: function(percent) {
            var eased, hooks = Tween.propHooks[this.prop];
            if (this.options.duration) {
              this.pos = eased = jQuery12.easing[this.easing](
                percent,
                this.options.duration * percent,
                0,
                1,
                this.options.duration
              );
            } else {
              this.pos = eased = percent;
            }
            this.now = (this.end - this.start) * eased + this.start;
            if (this.options.step) {
              this.options.step.call(this.elem, this.now, this);
            }
            if (hooks && hooks.set) {
              hooks.set(this);
            } else {
              Tween.propHooks._default.set(this);
            }
            return this;
          }
        };
        Tween.prototype.init.prototype = Tween.prototype;
        Tween.propHooks = {
          _default: {
            get: function(tween) {
              var result;
              if (tween.elem.nodeType !== 1 || tween.elem[tween.prop] != null && tween.elem.style[tween.prop] == null) {
                return tween.elem[tween.prop];
              }
              result = jQuery12.css(tween.elem, tween.prop, "");
              return !result || result === "auto" ? 0 : result;
            },
            set: function(tween) {
              if (jQuery12.fx.step[tween.prop]) {
                jQuery12.fx.step[tween.prop](tween);
              } else if (tween.elem.nodeType === 1 && (jQuery12.cssHooks[tween.prop] || tween.elem.style[finalPropName(tween.prop)] != null)) {
                jQuery12.style(tween.elem, tween.prop, tween.now + tween.unit);
              } else {
                tween.elem[tween.prop] = tween.now;
              }
            }
          }
        };
        Tween.propHooks.scrollTop = Tween.propHooks.scrollLeft = {
          set: function(tween) {
            if (tween.elem.nodeType && tween.elem.parentNode) {
              tween.elem[tween.prop] = tween.now;
            }
          }
        };
        jQuery12.easing = {
          linear: function(p) {
            return p;
          },
          swing: function(p) {
            return 0.5 - Math.cos(p * Math.PI) / 2;
          },
          _default: "swing"
        };
        jQuery12.fx = Tween.prototype.init;
        jQuery12.fx.step = {};
        var fxNow, inProgress, rfxtypes = /^(?:toggle|show|hide)$/, rrun = /queueHooks$/;
        function schedule() {
          if (inProgress) {
            if (document2.hidden === false && window2.requestAnimationFrame) {
              window2.requestAnimationFrame(schedule);
            } else {
              window2.setTimeout(schedule, jQuery12.fx.interval);
            }
            jQuery12.fx.tick();
          }
        }
        function createFxNow() {
          window2.setTimeout(function() {
            fxNow = void 0;
          });
          return fxNow = Date.now();
        }
        function genFx(type, includeWidth) {
          var which, i = 0, attrs = { height: type };
          includeWidth = includeWidth ? 1 : 0;
          for (; i < 4; i += 2 - includeWidth) {
            which = cssExpand[i];
            attrs["margin" + which] = attrs["padding" + which] = type;
          }
          if (includeWidth) {
            attrs.opacity = attrs.width = type;
          }
          return attrs;
        }
        function createTween(value, prop, animation) {
          var tween, collection = (Animation.tweeners[prop] || []).concat(Animation.tweeners["*"]), index = 0, length = collection.length;
          for (; index < length; index++) {
            if (tween = collection[index].call(animation, prop, value)) {
              return tween;
            }
          }
        }
        function defaultPrefilter(elem, props, opts) {
          var prop, value, toggle, hooks, oldfire, propTween, restoreDisplay, display, isBox = "width" in props || "height" in props, anim = this, orig = {}, style = elem.style, hidden = elem.nodeType && isHiddenWithinTree(elem), dataShow = dataPriv.get(elem, "fxshow");
          if (!opts.queue) {
            hooks = jQuery12._queueHooks(elem, "fx");
            if (hooks.unqueued == null) {
              hooks.unqueued = 0;
              oldfire = hooks.empty.fire;
              hooks.empty.fire = function() {
                if (!hooks.unqueued) {
                  oldfire();
                }
              };
            }
            hooks.unqueued++;
            anim.always(function() {
              anim.always(function() {
                hooks.unqueued--;
                if (!jQuery12.queue(elem, "fx").length) {
                  hooks.empty.fire();
                }
              });
            });
          }
          for (prop in props) {
            value = props[prop];
            if (rfxtypes.test(value)) {
              delete props[prop];
              toggle = toggle || value === "toggle";
              if (value === (hidden ? "hide" : "show")) {
                if (value === "show" && dataShow && dataShow[prop] !== void 0) {
                  hidden = true;
                } else {
                  continue;
                }
              }
              orig[prop] = dataShow && dataShow[prop] || jQuery12.style(elem, prop);
            }
          }
          propTween = !jQuery12.isEmptyObject(props);
          if (!propTween && jQuery12.isEmptyObject(orig)) {
            return;
          }
          if (isBox && elem.nodeType === 1) {
            opts.overflow = [style.overflow, style.overflowX, style.overflowY];
            restoreDisplay = dataShow && dataShow.display;
            if (restoreDisplay == null) {
              restoreDisplay = dataPriv.get(elem, "display");
            }
            display = jQuery12.css(elem, "display");
            if (display === "none") {
              if (restoreDisplay) {
                display = restoreDisplay;
              } else {
                showHide([elem], true);
                restoreDisplay = elem.style.display || restoreDisplay;
                display = jQuery12.css(elem, "display");
                showHide([elem]);
              }
            }
            if (display === "inline" || display === "inline-block" && restoreDisplay != null) {
              if (jQuery12.css(elem, "float") === "none") {
                if (!propTween) {
                  anim.done(function() {
                    style.display = restoreDisplay;
                  });
                  if (restoreDisplay == null) {
                    display = style.display;
                    restoreDisplay = display === "none" ? "" : display;
                  }
                }
                style.display = "inline-block";
              }
            }
          }
          if (opts.overflow) {
            style.overflow = "hidden";
            anim.always(function() {
              style.overflow = opts.overflow[0];
              style.overflowX = opts.overflow[1];
              style.overflowY = opts.overflow[2];
            });
          }
          propTween = false;
          for (prop in orig) {
            if (!propTween) {
              if (dataShow) {
                if ("hidden" in dataShow) {
                  hidden = dataShow.hidden;
                }
              } else {
                dataShow = dataPriv.access(elem, "fxshow", { display: restoreDisplay });
              }
              if (toggle) {
                dataShow.hidden = !hidden;
              }
              if (hidden) {
                showHide([elem], true);
              }
              anim.done(function() {
                if (!hidden) {
                  showHide([elem]);
                }
                dataPriv.remove(elem, "fxshow");
                for (prop in orig) {
                  jQuery12.style(elem, prop, orig[prop]);
                }
              });
            }
            propTween = createTween(hidden ? dataShow[prop] : 0, prop, anim);
            if (!(prop in dataShow)) {
              dataShow[prop] = propTween.start;
              if (hidden) {
                propTween.end = propTween.start;
                propTween.start = 0;
              }
            }
          }
        }
        function propFilter(props, specialEasing) {
          var index, name, easing, value, hooks;
          for (index in props) {
            name = camelCase(index);
            easing = specialEasing[name];
            value = props[index];
            if (Array.isArray(value)) {
              easing = value[1];
              value = props[index] = value[0];
            }
            if (index !== name) {
              props[name] = value;
              delete props[index];
            }
            hooks = jQuery12.cssHooks[name];
            if (hooks && "expand" in hooks) {
              value = hooks.expand(value);
              delete props[name];
              for (index in value) {
                if (!(index in props)) {
                  props[index] = value[index];
                  specialEasing[index] = easing;
                }
              }
            } else {
              specialEasing[name] = easing;
            }
          }
        }
        function Animation(elem, properties, options) {
          var result, stopped, index = 0, length = Animation.prefilters.length, deferred = jQuery12.Deferred().always(function() {
            delete tick.elem;
          }), tick = function() {
            if (stopped) {
              return false;
            }
            var currentTime = fxNow || createFxNow(), remaining = Math.max(0, animation.startTime + animation.duration - currentTime), temp = remaining / animation.duration || 0, percent = 1 - temp, index2 = 0, length2 = animation.tweens.length;
            for (; index2 < length2; index2++) {
              animation.tweens[index2].run(percent);
            }
            deferred.notifyWith(elem, [animation, percent, remaining]);
            if (percent < 1 && length2) {
              return remaining;
            }
            if (!length2) {
              deferred.notifyWith(elem, [animation, 1, 0]);
            }
            deferred.resolveWith(elem, [animation]);
            return false;
          }, animation = deferred.promise({
            elem,
            props: jQuery12.extend({}, properties),
            opts: jQuery12.extend(true, {
              specialEasing: {},
              easing: jQuery12.easing._default
            }, options),
            originalProperties: properties,
            originalOptions: options,
            startTime: fxNow || createFxNow(),
            duration: options.duration,
            tweens: [],
            createTween: function(prop, end2) {
              var tween = jQuery12.Tween(
                elem,
                animation.opts,
                prop,
                end2,
                animation.opts.specialEasing[prop] || animation.opts.easing
              );
              animation.tweens.push(tween);
              return tween;
            },
            stop: function(gotoEnd) {
              var index2 = 0, length2 = gotoEnd ? animation.tweens.length : 0;
              if (stopped) {
                return this;
              }
              stopped = true;
              for (; index2 < length2; index2++) {
                animation.tweens[index2].run(1);
              }
              if (gotoEnd) {
                deferred.notifyWith(elem, [animation, 1, 0]);
                deferred.resolveWith(elem, [animation, gotoEnd]);
              } else {
                deferred.rejectWith(elem, [animation, gotoEnd]);
              }
              return this;
            }
          }), props = animation.props;
          propFilter(props, animation.opts.specialEasing);
          for (; index < length; index++) {
            result = Animation.prefilters[index].call(animation, elem, props, animation.opts);
            if (result) {
              if (isFunction(result.stop)) {
                jQuery12._queueHooks(animation.elem, animation.opts.queue).stop = result.stop.bind(result);
              }
              return result;
            }
          }
          jQuery12.map(props, createTween, animation);
          if (isFunction(animation.opts.start)) {
            animation.opts.start.call(elem, animation);
          }
          animation.progress(animation.opts.progress).done(animation.opts.done, animation.opts.complete).fail(animation.opts.fail).always(animation.opts.always);
          jQuery12.fx.timer(
            jQuery12.extend(tick, {
              elem,
              anim: animation,
              queue: animation.opts.queue
            })
          );
          return animation;
        }
        jQuery12.Animation = jQuery12.extend(Animation, {
          tweeners: {
            "*": [function(prop, value) {
              var tween = this.createTween(prop, value);
              adjustCSS(tween.elem, prop, rcssNum.exec(value), tween);
              return tween;
            }]
          },
          tweener: function(props, callback) {
            if (isFunction(props)) {
              callback = props;
              props = ["*"];
            } else {
              props = props.match(rnothtmlwhite);
            }
            var prop, index = 0, length = props.length;
            for (; index < length; index++) {
              prop = props[index];
              Animation.tweeners[prop] = Animation.tweeners[prop] || [];
              Animation.tweeners[prop].unshift(callback);
            }
          },
          prefilters: [defaultPrefilter],
          prefilter: function(callback, prepend) {
            if (prepend) {
              Animation.prefilters.unshift(callback);
            } else {
              Animation.prefilters.push(callback);
            }
          }
        });
        jQuery12.speed = function(speed, easing, fn2) {
          var opt = speed && typeof speed === "object" ? jQuery12.extend({}, speed) : {
            complete: fn2 || !fn2 && easing || isFunction(speed) && speed,
            duration: speed,
            easing: fn2 && easing || easing && !isFunction(easing) && easing
          };
          if (jQuery12.fx.off) {
            opt.duration = 0;
          } else {
            if (typeof opt.duration !== "number") {
              if (opt.duration in jQuery12.fx.speeds) {
                opt.duration = jQuery12.fx.speeds[opt.duration];
              } else {
                opt.duration = jQuery12.fx.speeds._default;
              }
            }
          }
          if (opt.queue == null || opt.queue === true) {
            opt.queue = "fx";
          }
          opt.old = opt.complete;
          opt.complete = function() {
            if (isFunction(opt.old)) {
              opt.old.call(this);
            }
            if (opt.queue) {
              jQuery12.dequeue(this, opt.queue);
            }
          };
          return opt;
        };
        jQuery12.fn.extend({
          fadeTo: function(speed, to, easing, callback) {
            return this.filter(isHiddenWithinTree).css("opacity", 0).show().end().animate({ opacity: to }, speed, easing, callback);
          },
          animate: function(prop, speed, easing, callback) {
            var empty = jQuery12.isEmptyObject(prop), optall = jQuery12.speed(speed, easing, callback), doAnimation = function() {
              var anim = Animation(this, jQuery12.extend({}, prop), optall);
              if (empty || dataPriv.get(this, "finish")) {
                anim.stop(true);
              }
            };
            doAnimation.finish = doAnimation;
            return empty || optall.queue === false ? this.each(doAnimation) : this.queue(optall.queue, doAnimation);
          },
          stop: function(type, clearQueue, gotoEnd) {
            var stopQueue = function(hooks) {
              var stop = hooks.stop;
              delete hooks.stop;
              stop(gotoEnd);
            };
            if (typeof type !== "string") {
              gotoEnd = clearQueue;
              clearQueue = type;
              type = void 0;
            }
            if (clearQueue) {
              this.queue(type || "fx", []);
            }
            return this.each(function() {
              var dequeue = true, index = type != null && type + "queueHooks", timers = jQuery12.timers, data = dataPriv.get(this);
              if (index) {
                if (data[index] && data[index].stop) {
                  stopQueue(data[index]);
                }
              } else {
                for (index in data) {
                  if (data[index] && data[index].stop && rrun.test(index)) {
                    stopQueue(data[index]);
                  }
                }
              }
              for (index = timers.length; index--; ) {
                if (timers[index].elem === this && (type == null || timers[index].queue === type)) {
                  timers[index].anim.stop(gotoEnd);
                  dequeue = false;
                  timers.splice(index, 1);
                }
              }
              if (dequeue || !gotoEnd) {
                jQuery12.dequeue(this, type);
              }
            });
          },
          finish: function(type) {
            if (type !== false) {
              type = type || "fx";
            }
            return this.each(function() {
              var index, data = dataPriv.get(this), queue = data[type + "queue"], hooks = data[type + "queueHooks"], timers = jQuery12.timers, length = queue ? queue.length : 0;
              data.finish = true;
              jQuery12.queue(this, type, []);
              if (hooks && hooks.stop) {
                hooks.stop.call(this, true);
              }
              for (index = timers.length; index--; ) {
                if (timers[index].elem === this && timers[index].queue === type) {
                  timers[index].anim.stop(true);
                  timers.splice(index, 1);
                }
              }
              for (index = 0; index < length; index++) {
                if (queue[index] && queue[index].finish) {
                  queue[index].finish.call(this);
                }
              }
              delete data.finish;
            });
          }
        });
        jQuery12.each(["toggle", "show", "hide"], function(_i, name) {
          var cssFn = jQuery12.fn[name];
          jQuery12.fn[name] = function(speed, easing, callback) {
            return speed == null || typeof speed === "boolean" ? cssFn.apply(this, arguments) : this.animate(genFx(name, true), speed, easing, callback);
          };
        });
        jQuery12.each({
          slideDown: genFx("show"),
          slideUp: genFx("hide"),
          slideToggle: genFx("toggle"),
          fadeIn: { opacity: "show" },
          fadeOut: { opacity: "hide" },
          fadeToggle: { opacity: "toggle" }
        }, function(name, props) {
          jQuery12.fn[name] = function(speed, easing, callback) {
            return this.animate(props, speed, easing, callback);
          };
        });
        jQuery12.timers = [];
        jQuery12.fx.tick = function() {
          var timer, i = 0, timers = jQuery12.timers;
          fxNow = Date.now();
          for (; i < timers.length; i++) {
            timer = timers[i];
            if (!timer() && timers[i] === timer) {
              timers.splice(i--, 1);
            }
          }
          if (!timers.length) {
            jQuery12.fx.stop();
          }
          fxNow = void 0;
        };
        jQuery12.fx.timer = function(timer) {
          jQuery12.timers.push(timer);
          jQuery12.fx.start();
        };
        jQuery12.fx.interval = 13;
        jQuery12.fx.start = function() {
          if (inProgress) {
            return;
          }
          inProgress = true;
          schedule();
        };
        jQuery12.fx.stop = function() {
          inProgress = null;
        };
        jQuery12.fx.speeds = {
          slow: 600,
          fast: 200,
          // Default speed
          _default: 400
        };
        jQuery12.fn.delay = function(time, type) {
          time = jQuery12.fx ? jQuery12.fx.speeds[time] || time : time;
          type = type || "fx";
          return this.queue(type, function(next, hooks) {
            var timeout = window2.setTimeout(next, time);
            hooks.stop = function() {
              window2.clearTimeout(timeout);
            };
          });
        };
        (function() {
          var input = document2.createElement("input"), select = document2.createElement("select"), opt = select.appendChild(document2.createElement("option"));
          input.type = "checkbox";
          support.checkOn = input.value !== "";
          support.optSelected = opt.selected;
          input = document2.createElement("input");
          input.value = "t";
          input.type = "radio";
          support.radioValue = input.value === "t";
        })();
        var boolHook, attrHandle = jQuery12.expr.attrHandle;
        jQuery12.fn.extend({
          attr: function(name, value) {
            return access(this, jQuery12.attr, name, value, arguments.length > 1);
          },
          removeAttr: function(name) {
            return this.each(function() {
              jQuery12.removeAttr(this, name);
            });
          }
        });
        jQuery12.extend({
          attr: function(elem, name, value) {
            var ret, hooks, nType = elem.nodeType;
            if (nType === 3 || nType === 8 || nType === 2) {
              return;
            }
            if (typeof elem.getAttribute === "undefined") {
              return jQuery12.prop(elem, name, value);
            }
            if (nType !== 1 || !jQuery12.isXMLDoc(elem)) {
              hooks = jQuery12.attrHooks[name.toLowerCase()] || (jQuery12.expr.match.bool.test(name) ? boolHook : void 0);
            }
            if (value !== void 0) {
              if (value === null) {
                jQuery12.removeAttr(elem, name);
                return;
              }
              if (hooks && "set" in hooks && (ret = hooks.set(elem, value, name)) !== void 0) {
                return ret;
              }
              elem.setAttribute(name, value + "");
              return value;
            }
            if (hooks && "get" in hooks && (ret = hooks.get(elem, name)) !== null) {
              return ret;
            }
            ret = jQuery12.find.attr(elem, name);
            return ret == null ? void 0 : ret;
          },
          attrHooks: {
            type: {
              set: function(elem, value) {
                if (!support.radioValue && value === "radio" && nodeName(elem, "input")) {
                  var val = elem.value;
                  elem.setAttribute("type", value);
                  if (val) {
                    elem.value = val;
                  }
                  return value;
                }
              }
            }
          },
          removeAttr: function(elem, value) {
            var name, i = 0, attrNames = value && value.match(rnothtmlwhite);
            if (attrNames && elem.nodeType === 1) {
              while (name = attrNames[i++]) {
                elem.removeAttribute(name);
              }
            }
          }
        });
        boolHook = {
          set: function(elem, value, name) {
            if (value === false) {
              jQuery12.removeAttr(elem, name);
            } else {
              elem.setAttribute(name, name);
            }
            return name;
          }
        };
        jQuery12.each(jQuery12.expr.match.bool.source.match(/\w+/g), function(_i, name) {
          var getter = attrHandle[name] || jQuery12.find.attr;
          attrHandle[name] = function(elem, name2, isXML) {
            var ret, handle, lowercaseName = name2.toLowerCase();
            if (!isXML) {
              handle = attrHandle[lowercaseName];
              attrHandle[lowercaseName] = ret;
              ret = getter(elem, name2, isXML) != null ? lowercaseName : null;
              attrHandle[lowercaseName] = handle;
            }
            return ret;
          };
        });
        var rfocusable = /^(?:input|select|textarea|button)$/i, rclickable = /^(?:a|area)$/i;
        jQuery12.fn.extend({
          prop: function(name, value) {
            return access(this, jQuery12.prop, name, value, arguments.length > 1);
          },
          removeProp: function(name) {
            return this.each(function() {
              delete this[jQuery12.propFix[name] || name];
            });
          }
        });
        jQuery12.extend({
          prop: function(elem, name, value) {
            var ret, hooks, nType = elem.nodeType;
            if (nType === 3 || nType === 8 || nType === 2) {
              return;
            }
            if (nType !== 1 || !jQuery12.isXMLDoc(elem)) {
              name = jQuery12.propFix[name] || name;
              hooks = jQuery12.propHooks[name];
            }
            if (value !== void 0) {
              if (hooks && "set" in hooks && (ret = hooks.set(elem, value, name)) !== void 0) {
                return ret;
              }
              return elem[name] = value;
            }
            if (hooks && "get" in hooks && (ret = hooks.get(elem, name)) !== null) {
              return ret;
            }
            return elem[name];
          },
          propHooks: {
            tabIndex: {
              get: function(elem) {
                var tabindex = jQuery12.find.attr(elem, "tabindex");
                if (tabindex) {
                  return parseInt(tabindex, 10);
                }
                if (rfocusable.test(elem.nodeName) || rclickable.test(elem.nodeName) && elem.href) {
                  return 0;
                }
                return -1;
              }
            }
          },
          propFix: {
            "for": "htmlFor",
            "class": "className"
          }
        });
        if (!support.optSelected) {
          jQuery12.propHooks.selected = {
            get: function(elem) {
              var parent = elem.parentNode;
              if (parent && parent.parentNode) {
                parent.parentNode.selectedIndex;
              }
              return null;
            },
            set: function(elem) {
              var parent = elem.parentNode;
              if (parent) {
                parent.selectedIndex;
                if (parent.parentNode) {
                  parent.parentNode.selectedIndex;
                }
              }
            }
          };
        }
        jQuery12.each([
          "tabIndex",
          "readOnly",
          "maxLength",
          "cellSpacing",
          "cellPadding",
          "rowSpan",
          "colSpan",
          "useMap",
          "frameBorder",
          "contentEditable"
        ], function() {
          jQuery12.propFix[this.toLowerCase()] = this;
        });
        function stripAndCollapse(value) {
          var tokens = value.match(rnothtmlwhite) || [];
          return tokens.join(" ");
        }
        function getClass(elem) {
          return elem.getAttribute && elem.getAttribute("class") || "";
        }
        function classesToArray(value) {
          if (Array.isArray(value)) {
            return value;
          }
          if (typeof value === "string") {
            return value.match(rnothtmlwhite) || [];
          }
          return [];
        }
        jQuery12.fn.extend({
          addClass: function(value) {
            var classNames, cur, curValue, className, i, finalValue;
            if (isFunction(value)) {
              return this.each(function(j) {
                jQuery12(this).addClass(value.call(this, j, getClass(this)));
              });
            }
            classNames = classesToArray(value);
            if (classNames.length) {
              return this.each(function() {
                curValue = getClass(this);
                cur = this.nodeType === 1 && " " + stripAndCollapse(curValue) + " ";
                if (cur) {
                  for (i = 0; i < classNames.length; i++) {
                    className = classNames[i];
                    if (cur.indexOf(" " + className + " ") < 0) {
                      cur += className + " ";
                    }
                  }
                  finalValue = stripAndCollapse(cur);
                  if (curValue !== finalValue) {
                    this.setAttribute("class", finalValue);
                  }
                }
              });
            }
            return this;
          },
          removeClass: function(value) {
            var classNames, cur, curValue, className, i, finalValue;
            if (isFunction(value)) {
              return this.each(function(j) {
                jQuery12(this).removeClass(value.call(this, j, getClass(this)));
              });
            }
            if (!arguments.length) {
              return this.attr("class", "");
            }
            classNames = classesToArray(value);
            if (classNames.length) {
              return this.each(function() {
                curValue = getClass(this);
                cur = this.nodeType === 1 && " " + stripAndCollapse(curValue) + " ";
                if (cur) {
                  for (i = 0; i < classNames.length; i++) {
                    className = classNames[i];
                    while (cur.indexOf(" " + className + " ") > -1) {
                      cur = cur.replace(" " + className + " ", " ");
                    }
                  }
                  finalValue = stripAndCollapse(cur);
                  if (curValue !== finalValue) {
                    this.setAttribute("class", finalValue);
                  }
                }
              });
            }
            return this;
          },
          toggleClass: function(value, stateVal) {
            var classNames, className, i, self2, type = typeof value, isValidValue = type === "string" || Array.isArray(value);
            if (isFunction(value)) {
              return this.each(function(i2) {
                jQuery12(this).toggleClass(
                  value.call(this, i2, getClass(this), stateVal),
                  stateVal
                );
              });
            }
            if (typeof stateVal === "boolean" && isValidValue) {
              return stateVal ? this.addClass(value) : this.removeClass(value);
            }
            classNames = classesToArray(value);
            return this.each(function() {
              if (isValidValue) {
                self2 = jQuery12(this);
                for (i = 0; i < classNames.length; i++) {
                  className = classNames[i];
                  if (self2.hasClass(className)) {
                    self2.removeClass(className);
                  } else {
                    self2.addClass(className);
                  }
                }
              } else if (value === void 0 || type === "boolean") {
                className = getClass(this);
                if (className) {
                  dataPriv.set(this, "__className__", className);
                }
                if (this.setAttribute) {
                  this.setAttribute(
                    "class",
                    className || value === false ? "" : dataPriv.get(this, "__className__") || ""
                  );
                }
              }
            });
          },
          hasClass: function(selector) {
            var className, elem, i = 0;
            className = " " + selector + " ";
            while (elem = this[i++]) {
              if (elem.nodeType === 1 && (" " + stripAndCollapse(getClass(elem)) + " ").indexOf(className) > -1) {
                return true;
              }
            }
            return false;
          }
        });
        var rreturn = /\r/g;
        jQuery12.fn.extend({
          val: function(value) {
            var hooks, ret, valueIsFunction, elem = this[0];
            if (!arguments.length) {
              if (elem) {
                hooks = jQuery12.valHooks[elem.type] || jQuery12.valHooks[elem.nodeName.toLowerCase()];
                if (hooks && "get" in hooks && (ret = hooks.get(elem, "value")) !== void 0) {
                  return ret;
                }
                ret = elem.value;
                if (typeof ret === "string") {
                  return ret.replace(rreturn, "");
                }
                return ret == null ? "" : ret;
              }
              return;
            }
            valueIsFunction = isFunction(value);
            return this.each(function(i) {
              var val;
              if (this.nodeType !== 1) {
                return;
              }
              if (valueIsFunction) {
                val = value.call(this, i, jQuery12(this).val());
              } else {
                val = value;
              }
              if (val == null) {
                val = "";
              } else if (typeof val === "number") {
                val += "";
              } else if (Array.isArray(val)) {
                val = jQuery12.map(val, function(value2) {
                  return value2 == null ? "" : value2 + "";
                });
              }
              hooks = jQuery12.valHooks[this.type] || jQuery12.valHooks[this.nodeName.toLowerCase()];
              if (!hooks || !("set" in hooks) || hooks.set(this, val, "value") === void 0) {
                this.value = val;
              }
            });
          }
        });
        jQuery12.extend({
          valHooks: {
            option: {
              get: function(elem) {
                var val = jQuery12.find.attr(elem, "value");
                return val != null ? val : (
                  // Support: IE <=10 - 11 only
                  // option.text throws exceptions (trac-14686, trac-14858)
                  // Strip and collapse whitespace
                  // https://html.spec.whatwg.org/#strip-and-collapse-whitespace
                  stripAndCollapse(jQuery12.text(elem))
                );
              }
            },
            select: {
              get: function(elem) {
                var value, option, i, options = elem.options, index = elem.selectedIndex, one = elem.type === "select-one", values = one ? null : [], max2 = one ? index + 1 : options.length;
                if (index < 0) {
                  i = max2;
                } else {
                  i = one ? index : 0;
                }
                for (; i < max2; i++) {
                  option = options[i];
                  if ((option.selected || i === index) && // Don't return options that are disabled or in a disabled optgroup
                  !option.disabled && (!option.parentNode.disabled || !nodeName(option.parentNode, "optgroup"))) {
                    value = jQuery12(option).val();
                    if (one) {
                      return value;
                    }
                    values.push(value);
                  }
                }
                return values;
              },
              set: function(elem, value) {
                var optionSet, option, options = elem.options, values = jQuery12.makeArray(value), i = options.length;
                while (i--) {
                  option = options[i];
                  if (option.selected = jQuery12.inArray(jQuery12.valHooks.option.get(option), values) > -1) {
                    optionSet = true;
                  }
                }
                if (!optionSet) {
                  elem.selectedIndex = -1;
                }
                return values;
              }
            }
          }
        });
        jQuery12.each(["radio", "checkbox"], function() {
          jQuery12.valHooks[this] = {
            set: function(elem, value) {
              if (Array.isArray(value)) {
                return elem.checked = jQuery12.inArray(jQuery12(elem).val(), value) > -1;
              }
            }
          };
          if (!support.checkOn) {
            jQuery12.valHooks[this].get = function(elem) {
              return elem.getAttribute("value") === null ? "on" : elem.value;
            };
          }
        });
        var location2 = window2.location;
        var nonce = { guid: Date.now() };
        var rquery = /\?/;
        jQuery12.parseXML = function(data) {
          var xml, parserErrorElem;
          if (!data || typeof data !== "string") {
            return null;
          }
          try {
            xml = new window2.DOMParser().parseFromString(data, "text/xml");
          } catch (e) {
          }
          parserErrorElem = xml && xml.getElementsByTagName("parsererror")[0];
          if (!xml || parserErrorElem) {
            jQuery12.error("Invalid XML: " + (parserErrorElem ? jQuery12.map(parserErrorElem.childNodes, function(el) {
              return el.textContent;
            }).join("\n") : data));
          }
          return xml;
        };
        var rfocusMorph = /^(?:focusinfocus|focusoutblur)$/, stopPropagationCallback = function(e) {
          e.stopPropagation();
        };
        jQuery12.extend(jQuery12.event, {
          trigger: function(event, data, elem, onlyHandlers) {
            var i, cur, tmp, bubbleType, ontype, handle, special, lastElement, eventPath = [elem || document2], type = hasOwn.call(event, "type") ? event.type : event, namespaces = hasOwn.call(event, "namespace") ? event.namespace.split(".") : [];
            cur = lastElement = tmp = elem = elem || document2;
            if (elem.nodeType === 3 || elem.nodeType === 8) {
              return;
            }
            if (rfocusMorph.test(type + jQuery12.event.triggered)) {
              return;
            }
            if (type.indexOf(".") > -1) {
              namespaces = type.split(".");
              type = namespaces.shift();
              namespaces.sort();
            }
            ontype = type.indexOf(":") < 0 && "on" + type;
            event = event[jQuery12.expando] ? event : new jQuery12.Event(type, typeof event === "object" && event);
            event.isTrigger = onlyHandlers ? 2 : 3;
            event.namespace = namespaces.join(".");
            event.rnamespace = event.namespace ? new RegExp("(^|\\.)" + namespaces.join("\\.(?:.*\\.|)") + "(\\.|$)") : null;
            event.result = void 0;
            if (!event.target) {
              event.target = elem;
            }
            data = data == null ? [event] : jQuery12.makeArray(data, [event]);
            special = jQuery12.event.special[type] || {};
            if (!onlyHandlers && special.trigger && special.trigger.apply(elem, data) === false) {
              return;
            }
            if (!onlyHandlers && !special.noBubble && !isWindow(elem)) {
              bubbleType = special.delegateType || type;
              if (!rfocusMorph.test(bubbleType + type)) {
                cur = cur.parentNode;
              }
              for (; cur; cur = cur.parentNode) {
                eventPath.push(cur);
                tmp = cur;
              }
              if (tmp === (elem.ownerDocument || document2)) {
                eventPath.push(tmp.defaultView || tmp.parentWindow || window2);
              }
            }
            i = 0;
            while ((cur = eventPath[i++]) && !event.isPropagationStopped()) {
              lastElement = cur;
              event.type = i > 1 ? bubbleType : special.bindType || type;
              handle = (dataPriv.get(cur, "events") || /* @__PURE__ */ Object.create(null))[event.type] && dataPriv.get(cur, "handle");
              if (handle) {
                handle.apply(cur, data);
              }
              handle = ontype && cur[ontype];
              if (handle && handle.apply && acceptData(cur)) {
                event.result = handle.apply(cur, data);
                if (event.result === false) {
                  event.preventDefault();
                }
              }
            }
            event.type = type;
            if (!onlyHandlers && !event.isDefaultPrevented()) {
              if ((!special._default || special._default.apply(eventPath.pop(), data) === false) && acceptData(elem)) {
                if (ontype && isFunction(elem[type]) && !isWindow(elem)) {
                  tmp = elem[ontype];
                  if (tmp) {
                    elem[ontype] = null;
                  }
                  jQuery12.event.triggered = type;
                  if (event.isPropagationStopped()) {
                    lastElement.addEventListener(type, stopPropagationCallback);
                  }
                  elem[type]();
                  if (event.isPropagationStopped()) {
                    lastElement.removeEventListener(type, stopPropagationCallback);
                  }
                  jQuery12.event.triggered = void 0;
                  if (tmp) {
                    elem[ontype] = tmp;
                  }
                }
              }
            }
            return event.result;
          },
          // Piggyback on a donor event to simulate a different one
          // Used only for `focus(in | out)` events
          simulate: function(type, elem, event) {
            var e = jQuery12.extend(
              new jQuery12.Event(),
              event,
              {
                type,
                isSimulated: true
              }
            );
            jQuery12.event.trigger(e, null, elem);
          }
        });
        jQuery12.fn.extend({
          trigger: function(type, data) {
            return this.each(function() {
              jQuery12.event.trigger(type, data, this);
            });
          },
          triggerHandler: function(type, data) {
            var elem = this[0];
            if (elem) {
              return jQuery12.event.trigger(type, data, elem, true);
            }
          }
        });
        var rbracket = /\[\]$/, rCRLF = /\r?\n/g, rsubmitterTypes = /^(?:submit|button|image|reset|file)$/i, rsubmittable = /^(?:input|select|textarea|keygen)/i;
        function buildParams(prefix, obj, traditional, add) {
          var name;
          if (Array.isArray(obj)) {
            jQuery12.each(obj, function(i, v) {
              if (traditional || rbracket.test(prefix)) {
                add(prefix, v);
              } else {
                buildParams(
                  prefix + "[" + (typeof v === "object" && v != null ? i : "") + "]",
                  v,
                  traditional,
                  add
                );
              }
            });
          } else if (!traditional && toType2(obj) === "object") {
            for (name in obj) {
              buildParams(prefix + "[" + name + "]", obj[name], traditional, add);
            }
          } else {
            add(prefix, obj);
          }
        }
        jQuery12.param = function(a, traditional) {
          var prefix, s = [], add = function(key, valueOrFunction) {
            var value = isFunction(valueOrFunction) ? valueOrFunction() : valueOrFunction;
            s[s.length] = encodeURIComponent(key) + "=" + encodeURIComponent(value == null ? "" : value);
          };
          if (a == null) {
            return "";
          }
          if (Array.isArray(a) || a.jquery && !jQuery12.isPlainObject(a)) {
            jQuery12.each(a, function() {
              add(this.name, this.value);
            });
          } else {
            for (prefix in a) {
              buildParams(prefix, a[prefix], traditional, add);
            }
          }
          return s.join("&");
        };
        jQuery12.fn.extend({
          serialize: function() {
            return jQuery12.param(this.serializeArray());
          },
          serializeArray: function() {
            return this.map(function() {
              var elements = jQuery12.prop(this, "elements");
              return elements ? jQuery12.makeArray(elements) : this;
            }).filter(function() {
              var type = this.type;
              return this.name && !jQuery12(this).is(":disabled") && rsubmittable.test(this.nodeName) && !rsubmitterTypes.test(type) && (this.checked || !rcheckableType.test(type));
            }).map(function(_i, elem) {
              var val = jQuery12(this).val();
              if (val == null) {
                return null;
              }
              if (Array.isArray(val)) {
                return jQuery12.map(val, function(val2) {
                  return { name: elem.name, value: val2.replace(rCRLF, "\r\n") };
                });
              }
              return { name: elem.name, value: val.replace(rCRLF, "\r\n") };
            }).get();
          }
        });
        var r20 = /%20/g, rhash = /#.*$/, rantiCache = /([?&])_=[^&]*/, rheaders = /^(.*?):[ \t]*([^\r\n]*)$/mg, rlocalProtocol = /^(?:about|app|app-storage|.+-extension|file|res|widget):$/, rnoContent = /^(?:GET|HEAD)$/, rprotocol = /^\/\//, prefilters = {}, transports = {}, allTypes = "*/".concat("*"), originAnchor = document2.createElement("a");
        originAnchor.href = location2.href;
        function addToPrefiltersOrTransports(structure) {
          return function(dataTypeExpression, func) {
            if (typeof dataTypeExpression !== "string") {
              func = dataTypeExpression;
              dataTypeExpression = "*";
            }
            var dataType, i = 0, dataTypes = dataTypeExpression.toLowerCase().match(rnothtmlwhite) || [];
            if (isFunction(func)) {
              while (dataType = dataTypes[i++]) {
                if (dataType[0] === "+") {
                  dataType = dataType.slice(1) || "*";
                  (structure[dataType] = structure[dataType] || []).unshift(func);
                } else {
                  (structure[dataType] = structure[dataType] || []).push(func);
                }
              }
            }
          };
        }
        function inspectPrefiltersOrTransports(structure, options, originalOptions, jqXHR) {
          var inspected = {}, seekingTransport = structure === transports;
          function inspect(dataType) {
            var selected;
            inspected[dataType] = true;
            jQuery12.each(structure[dataType] || [], function(_, prefilterOrFactory) {
              var dataTypeOrTransport = prefilterOrFactory(options, originalOptions, jqXHR);
              if (typeof dataTypeOrTransport === "string" && !seekingTransport && !inspected[dataTypeOrTransport]) {
                options.dataTypes.unshift(dataTypeOrTransport);
                inspect(dataTypeOrTransport);
                return false;
              } else if (seekingTransport) {
                return !(selected = dataTypeOrTransport);
              }
            });
            return selected;
          }
          return inspect(options.dataTypes[0]) || !inspected["*"] && inspect("*");
        }
        function ajaxExtend(target, src) {
          var key, deep, flatOptions = jQuery12.ajaxSettings.flatOptions || {};
          for (key in src) {
            if (src[key] !== void 0) {
              (flatOptions[key] ? target : deep || (deep = {}))[key] = src[key];
            }
          }
          if (deep) {
            jQuery12.extend(true, target, deep);
          }
          return target;
        }
        function ajaxHandleResponses(s, jqXHR, responses) {
          var ct, type, finalDataType, firstDataType, contents = s.contents, dataTypes = s.dataTypes;
          while (dataTypes[0] === "*") {
            dataTypes.shift();
            if (ct === void 0) {
              ct = s.mimeType || jqXHR.getResponseHeader("Content-Type");
            }
          }
          if (ct) {
            for (type in contents) {
              if (contents[type] && contents[type].test(ct)) {
                dataTypes.unshift(type);
                break;
              }
            }
          }
          if (dataTypes[0] in responses) {
            finalDataType = dataTypes[0];
          } else {
            for (type in responses) {
              if (!dataTypes[0] || s.converters[type + " " + dataTypes[0]]) {
                finalDataType = type;
                break;
              }
              if (!firstDataType) {
                firstDataType = type;
              }
            }
            finalDataType = finalDataType || firstDataType;
          }
          if (finalDataType) {
            if (finalDataType !== dataTypes[0]) {
              dataTypes.unshift(finalDataType);
            }
            return responses[finalDataType];
          }
        }
        function ajaxConvert(s, response, jqXHR, isSuccess) {
          var conv2, current, conv, tmp, prev, converters = {}, dataTypes = s.dataTypes.slice();
          if (dataTypes[1]) {
            for (conv in s.converters) {
              converters[conv.toLowerCase()] = s.converters[conv];
            }
          }
          current = dataTypes.shift();
          while (current) {
            if (s.responseFields[current]) {
              jqXHR[s.responseFields[current]] = response;
            }
            if (!prev && isSuccess && s.dataFilter) {
              response = s.dataFilter(response, s.dataType);
            }
            prev = current;
            current = dataTypes.shift();
            if (current) {
              if (current === "*") {
                current = prev;
              } else if (prev !== "*" && prev !== current) {
                conv = converters[prev + " " + current] || converters["* " + current];
                if (!conv) {
                  for (conv2 in converters) {
                    tmp = conv2.split(" ");
                    if (tmp[1] === current) {
                      conv = converters[prev + " " + tmp[0]] || converters["* " + tmp[0]];
                      if (conv) {
                        if (conv === true) {
                          conv = converters[conv2];
                        } else if (converters[conv2] !== true) {
                          current = tmp[0];
                          dataTypes.unshift(tmp[1]);
                        }
                        break;
                      }
                    }
                  }
                }
                if (conv !== true) {
                  if (conv && s.throws) {
                    response = conv(response);
                  } else {
                    try {
                      response = conv(response);
                    } catch (e) {
                      return {
                        state: "parsererror",
                        error: conv ? e : "No conversion from " + prev + " to " + current
                      };
                    }
                  }
                }
              }
            }
          }
          return { state: "success", data: response };
        }
        jQuery12.extend({
          // Counter for holding the number of active queries
          active: 0,
          // Last-Modified header cache for next request
          lastModified: {},
          etag: {},
          ajaxSettings: {
            url: location2.href,
            type: "GET",
            isLocal: rlocalProtocol.test(location2.protocol),
            global: true,
            processData: true,
            async: true,
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            /*
            timeout: 0,
            data: null,
            dataType: null,
            username: null,
            password: null,
            cache: null,
            throws: false,
            traditional: false,
            headers: {},
            */
            accepts: {
              "*": allTypes,
              text: "text/plain",
              html: "text/html",
              xml: "application/xml, text/xml",
              json: "application/json, text/javascript"
            },
            contents: {
              xml: /\bxml\b/,
              html: /\bhtml/,
              json: /\bjson\b/
            },
            responseFields: {
              xml: "responseXML",
              text: "responseText",
              json: "responseJSON"
            },
            // Data converters
            // Keys separate source (or catchall "*") and destination types with a single space
            converters: {
              // Convert anything to text
              "* text": String,
              // Text to html (true = no transformation)
              "text html": true,
              // Evaluate text as a json expression
              "text json": JSON.parse,
              // Parse text as xml
              "text xml": jQuery12.parseXML
            },
            // For options that shouldn't be deep extended:
            // you can add your own custom options here if
            // and when you create one that shouldn't be
            // deep extended (see ajaxExtend)
            flatOptions: {
              url: true,
              context: true
            }
          },
          // Creates a full fledged settings object into target
          // with both ajaxSettings and settings fields.
          // If target is omitted, writes into ajaxSettings.
          ajaxSetup: function(target, settings) {
            return settings ? (
              // Building a settings object
              ajaxExtend(ajaxExtend(target, jQuery12.ajaxSettings), settings)
            ) : (
              // Extending ajaxSettings
              ajaxExtend(jQuery12.ajaxSettings, target)
            );
          },
          ajaxPrefilter: addToPrefiltersOrTransports(prefilters),
          ajaxTransport: addToPrefiltersOrTransports(transports),
          // Main method
          ajax: function(url, options) {
            if (typeof url === "object") {
              options = url;
              url = void 0;
            }
            options = options || {};
            var transport, cacheURL, responseHeadersString, responseHeaders, timeoutTimer, urlAnchor, completed2, fireGlobals, i, uncached, s = jQuery12.ajaxSetup({}, options), callbackContext = s.context || s, globalEventContext = s.context && (callbackContext.nodeType || callbackContext.jquery) ? jQuery12(callbackContext) : jQuery12.event, deferred = jQuery12.Deferred(), completeDeferred = jQuery12.Callbacks("once memory"), statusCode = s.statusCode || {}, requestHeaders = {}, requestHeadersNames = {}, strAbort = "canceled", jqXHR = {
              readyState: 0,
              // Builds headers hashtable if needed
              getResponseHeader: function(key) {
                var match;
                if (completed2) {
                  if (!responseHeaders) {
                    responseHeaders = {};
                    while (match = rheaders.exec(responseHeadersString)) {
                      responseHeaders[match[1].toLowerCase() + " "] = (responseHeaders[match[1].toLowerCase() + " "] || []).concat(match[2]);
                    }
                  }
                  match = responseHeaders[key.toLowerCase() + " "];
                }
                return match == null ? null : match.join(", ");
              },
              // Raw string
              getAllResponseHeaders: function() {
                return completed2 ? responseHeadersString : null;
              },
              // Caches the header
              setRequestHeader: function(name, value) {
                if (completed2 == null) {
                  name = requestHeadersNames[name.toLowerCase()] = requestHeadersNames[name.toLowerCase()] || name;
                  requestHeaders[name] = value;
                }
                return this;
              },
              // Overrides response content-type header
              overrideMimeType: function(type) {
                if (completed2 == null) {
                  s.mimeType = type;
                }
                return this;
              },
              // Status-dependent callbacks
              statusCode: function(map) {
                var code;
                if (map) {
                  if (completed2) {
                    jqXHR.always(map[jqXHR.status]);
                  } else {
                    for (code in map) {
                      statusCode[code] = [statusCode[code], map[code]];
                    }
                  }
                }
                return this;
              },
              // Cancel the request
              abort: function(statusText) {
                var finalText = statusText || strAbort;
                if (transport) {
                  transport.abort(finalText);
                }
                done(0, finalText);
                return this;
              }
            };
            deferred.promise(jqXHR);
            s.url = ((url || s.url || location2.href) + "").replace(rprotocol, location2.protocol + "//");
            s.type = options.method || options.type || s.method || s.type;
            s.dataTypes = (s.dataType || "*").toLowerCase().match(rnothtmlwhite) || [""];
            if (s.crossDomain == null) {
              urlAnchor = document2.createElement("a");
              try {
                urlAnchor.href = s.url;
                urlAnchor.href = urlAnchor.href;
                s.crossDomain = originAnchor.protocol + "//" + originAnchor.host !== urlAnchor.protocol + "//" + urlAnchor.host;
              } catch (e) {
                s.crossDomain = true;
              }
            }
            if (s.data && s.processData && typeof s.data !== "string") {
              s.data = jQuery12.param(s.data, s.traditional);
            }
            inspectPrefiltersOrTransports(prefilters, s, options, jqXHR);
            if (completed2) {
              return jqXHR;
            }
            fireGlobals = jQuery12.event && s.global;
            if (fireGlobals && jQuery12.active++ === 0) {
              jQuery12.event.trigger("ajaxStart");
            }
            s.type = s.type.toUpperCase();
            s.hasContent = !rnoContent.test(s.type);
            cacheURL = s.url.replace(rhash, "");
            if (!s.hasContent) {
              uncached = s.url.slice(cacheURL.length);
              if (s.data && (s.processData || typeof s.data === "string")) {
                cacheURL += (rquery.test(cacheURL) ? "&" : "?") + s.data;
                delete s.data;
              }
              if (s.cache === false) {
                cacheURL = cacheURL.replace(rantiCache, "$1");
                uncached = (rquery.test(cacheURL) ? "&" : "?") + "_=" + nonce.guid++ + uncached;
              }
              s.url = cacheURL + uncached;
            } else if (s.data && s.processData && (s.contentType || "").indexOf("application/x-www-form-urlencoded") === 0) {
              s.data = s.data.replace(r20, "+");
            }
            if (s.ifModified) {
              if (jQuery12.lastModified[cacheURL]) {
                jqXHR.setRequestHeader("If-Modified-Since", jQuery12.lastModified[cacheURL]);
              }
              if (jQuery12.etag[cacheURL]) {
                jqXHR.setRequestHeader("If-None-Match", jQuery12.etag[cacheURL]);
              }
            }
            if (s.data && s.hasContent && s.contentType !== false || options.contentType) {
              jqXHR.setRequestHeader("Content-Type", s.contentType);
            }
            jqXHR.setRequestHeader(
              "Accept",
              s.dataTypes[0] && s.accepts[s.dataTypes[0]] ? s.accepts[s.dataTypes[0]] + (s.dataTypes[0] !== "*" ? ", " + allTypes + "; q=0.01" : "") : s.accepts["*"]
            );
            for (i in s.headers) {
              jqXHR.setRequestHeader(i, s.headers[i]);
            }
            if (s.beforeSend && (s.beforeSend.call(callbackContext, jqXHR, s) === false || completed2)) {
              return jqXHR.abort();
            }
            strAbort = "abort";
            completeDeferred.add(s.complete);
            jqXHR.done(s.success);
            jqXHR.fail(s.error);
            transport = inspectPrefiltersOrTransports(transports, s, options, jqXHR);
            if (!transport) {
              done(-1, "No Transport");
            } else {
              jqXHR.readyState = 1;
              if (fireGlobals) {
                globalEventContext.trigger("ajaxSend", [jqXHR, s]);
              }
              if (completed2) {
                return jqXHR;
              }
              if (s.async && s.timeout > 0) {
                timeoutTimer = window2.setTimeout(function() {
                  jqXHR.abort("timeout");
                }, s.timeout);
              }
              try {
                completed2 = false;
                transport.send(requestHeaders, done);
              } catch (e) {
                if (completed2) {
                  throw e;
                }
                done(-1, e);
              }
            }
            function done(status, nativeStatusText, responses, headers) {
              var isSuccess, success, error, response, modified, statusText = nativeStatusText;
              if (completed2) {
                return;
              }
              completed2 = true;
              if (timeoutTimer) {
                window2.clearTimeout(timeoutTimer);
              }
              transport = void 0;
              responseHeadersString = headers || "";
              jqXHR.readyState = status > 0 ? 4 : 0;
              isSuccess = status >= 200 && status < 300 || status === 304;
              if (responses) {
                response = ajaxHandleResponses(s, jqXHR, responses);
              }
              if (!isSuccess && jQuery12.inArray("script", s.dataTypes) > -1 && jQuery12.inArray("json", s.dataTypes) < 0) {
                s.converters["text script"] = function() {
                };
              }
              response = ajaxConvert(s, response, jqXHR, isSuccess);
              if (isSuccess) {
                if (s.ifModified) {
                  modified = jqXHR.getResponseHeader("Last-Modified");
                  if (modified) {
                    jQuery12.lastModified[cacheURL] = modified;
                  }
                  modified = jqXHR.getResponseHeader("etag");
                  if (modified) {
                    jQuery12.etag[cacheURL] = modified;
                  }
                }
                if (status === 204 || s.type === "HEAD") {
                  statusText = "nocontent";
                } else if (status === 304) {
                  statusText = "notmodified";
                } else {
                  statusText = response.state;
                  success = response.data;
                  error = response.error;
                  isSuccess = !error;
                }
              } else {
                error = statusText;
                if (status || !statusText) {
                  statusText = "error";
                  if (status < 0) {
                    status = 0;
                  }
                }
              }
              jqXHR.status = status;
              jqXHR.statusText = (nativeStatusText || statusText) + "";
              if (isSuccess) {
                deferred.resolveWith(callbackContext, [success, statusText, jqXHR]);
              } else {
                deferred.rejectWith(callbackContext, [jqXHR, statusText, error]);
              }
              jqXHR.statusCode(statusCode);
              statusCode = void 0;
              if (fireGlobals) {
                globalEventContext.trigger(
                  isSuccess ? "ajaxSuccess" : "ajaxError",
                  [jqXHR, s, isSuccess ? success : error]
                );
              }
              completeDeferred.fireWith(callbackContext, [jqXHR, statusText]);
              if (fireGlobals) {
                globalEventContext.trigger("ajaxComplete", [jqXHR, s]);
                if (!--jQuery12.active) {
                  jQuery12.event.trigger("ajaxStop");
                }
              }
            }
            return jqXHR;
          },
          getJSON: function(url, data, callback) {
            return jQuery12.get(url, data, callback, "json");
          },
          getScript: function(url, callback) {
            return jQuery12.get(url, void 0, callback, "script");
          }
        });
        jQuery12.each(["get", "post"], function(_i, method) {
          jQuery12[method] = function(url, data, callback, type) {
            if (isFunction(data)) {
              type = type || callback;
              callback = data;
              data = void 0;
            }
            return jQuery12.ajax(jQuery12.extend({
              url,
              type: method,
              dataType: type,
              data,
              success: callback
            }, jQuery12.isPlainObject(url) && url));
          };
        });
        jQuery12.ajaxPrefilter(function(s) {
          var i;
          for (i in s.headers) {
            if (i.toLowerCase() === "content-type") {
              s.contentType = s.headers[i] || "";
            }
          }
        });
        jQuery12._evalUrl = function(url, options, doc) {
          return jQuery12.ajax({
            url,
            // Make this explicit, since user can override this through ajaxSetup (trac-11264)
            type: "GET",
            dataType: "script",
            cache: true,
            async: false,
            global: false,
            // Only evaluate the response if it is successful (gh-4126)
            // dataFilter is not invoked for failure responses, so using it instead
            // of the default converter is kludgy but it works.
            converters: {
              "text script": function() {
              }
            },
            dataFilter: function(response) {
              jQuery12.globalEval(response, options, doc);
            }
          });
        };
        jQuery12.fn.extend({
          wrapAll: function(html) {
            var wrap;
            if (this[0]) {
              if (isFunction(html)) {
                html = html.call(this[0]);
              }
              wrap = jQuery12(html, this[0].ownerDocument).eq(0).clone(true);
              if (this[0].parentNode) {
                wrap.insertBefore(this[0]);
              }
              wrap.map(function() {
                var elem = this;
                while (elem.firstElementChild) {
                  elem = elem.firstElementChild;
                }
                return elem;
              }).append(this);
            }
            return this;
          },
          wrapInner: function(html) {
            if (isFunction(html)) {
              return this.each(function(i) {
                jQuery12(this).wrapInner(html.call(this, i));
              });
            }
            return this.each(function() {
              var self2 = jQuery12(this), contents = self2.contents();
              if (contents.length) {
                contents.wrapAll(html);
              } else {
                self2.append(html);
              }
            });
          },
          wrap: function(html) {
            var htmlIsFunction = isFunction(html);
            return this.each(function(i) {
              jQuery12(this).wrapAll(htmlIsFunction ? html.call(this, i) : html);
            });
          },
          unwrap: function(selector) {
            this.parent(selector).not("body").each(function() {
              jQuery12(this).replaceWith(this.childNodes);
            });
            return this;
          }
        });
        jQuery12.expr.pseudos.hidden = function(elem) {
          return !jQuery12.expr.pseudos.visible(elem);
        };
        jQuery12.expr.pseudos.visible = function(elem) {
          return !!(elem.offsetWidth || elem.offsetHeight || elem.getClientRects().length);
        };
        jQuery12.ajaxSettings.xhr = function() {
          try {
            return new window2.XMLHttpRequest();
          } catch (e) {
          }
        };
        var xhrSuccessStatus = {
          // File protocol always yields status code 0, assume 200
          0: 200,
          // Support: IE <=9 only
          // trac-1450: sometimes IE returns 1223 when it should be 204
          1223: 204
        }, xhrSupported = jQuery12.ajaxSettings.xhr();
        support.cors = !!xhrSupported && "withCredentials" in xhrSupported;
        support.ajax = xhrSupported = !!xhrSupported;
        jQuery12.ajaxTransport(function(options) {
          var callback, errorCallback;
          if (support.cors || xhrSupported && !options.crossDomain) {
            return {
              send: function(headers, complete) {
                var i, xhr = options.xhr();
                xhr.open(
                  options.type,
                  options.url,
                  options.async,
                  options.username,
                  options.password
                );
                if (options.xhrFields) {
                  for (i in options.xhrFields) {
                    xhr[i] = options.xhrFields[i];
                  }
                }
                if (options.mimeType && xhr.overrideMimeType) {
                  xhr.overrideMimeType(options.mimeType);
                }
                if (!options.crossDomain && !headers["X-Requested-With"]) {
                  headers["X-Requested-With"] = "XMLHttpRequest";
                }
                for (i in headers) {
                  xhr.setRequestHeader(i, headers[i]);
                }
                callback = function(type) {
                  return function() {
                    if (callback) {
                      callback = errorCallback = xhr.onload = xhr.onerror = xhr.onabort = xhr.ontimeout = xhr.onreadystatechange = null;
                      if (type === "abort") {
                        xhr.abort();
                      } else if (type === "error") {
                        if (typeof xhr.status !== "number") {
                          complete(0, "error");
                        } else {
                          complete(
                            // File: protocol always yields status 0; see trac-8605, trac-14207
                            xhr.status,
                            xhr.statusText
                          );
                        }
                      } else {
                        complete(
                          xhrSuccessStatus[xhr.status] || xhr.status,
                          xhr.statusText,
                          // Support: IE <=9 only
                          // IE9 has no XHR2 but throws on binary (trac-11426)
                          // For XHR2 non-text, let the caller handle it (gh-2498)
                          (xhr.responseType || "text") !== "text" || typeof xhr.responseText !== "string" ? { binary: xhr.response } : { text: xhr.responseText },
                          xhr.getAllResponseHeaders()
                        );
                      }
                    }
                  };
                };
                xhr.onload = callback();
                errorCallback = xhr.onerror = xhr.ontimeout = callback("error");
                if (xhr.onabort !== void 0) {
                  xhr.onabort = errorCallback;
                } else {
                  xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                      window2.setTimeout(function() {
                        if (callback) {
                          errorCallback();
                        }
                      });
                    }
                  };
                }
                callback = callback("abort");
                try {
                  xhr.send(options.hasContent && options.data || null);
                } catch (e) {
                  if (callback) {
                    throw e;
                  }
                }
              },
              abort: function() {
                if (callback) {
                  callback();
                }
              }
            };
          }
        });
        jQuery12.ajaxPrefilter(function(s) {
          if (s.crossDomain) {
            s.contents.script = false;
          }
        });
        jQuery12.ajaxSetup({
          accepts: {
            script: "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
          },
          contents: {
            script: /\b(?:java|ecma)script\b/
          },
          converters: {
            "text script": function(text) {
              jQuery12.globalEval(text);
              return text;
            }
          }
        });
        jQuery12.ajaxPrefilter("script", function(s) {
          if (s.cache === void 0) {
            s.cache = false;
          }
          if (s.crossDomain) {
            s.type = "GET";
          }
        });
        jQuery12.ajaxTransport("script", function(s) {
          if (s.crossDomain || s.scriptAttrs) {
            var script, callback;
            return {
              send: function(_, complete) {
                script = jQuery12("<script>").attr(s.scriptAttrs || {}).prop({ charset: s.scriptCharset, src: s.url }).on("load error", callback = function(evt) {
                  script.remove();
                  callback = null;
                  if (evt) {
                    complete(evt.type === "error" ? 404 : 200, evt.type);
                  }
                });
                document2.head.appendChild(script[0]);
              },
              abort: function() {
                if (callback) {
                  callback();
                }
              }
            };
          }
        });
        var oldCallbacks = [], rjsonp = /(=)\?(?=&|$)|\?\?/;
        jQuery12.ajaxSetup({
          jsonp: "callback",
          jsonpCallback: function() {
            var callback = oldCallbacks.pop() || jQuery12.expando + "_" + nonce.guid++;
            this[callback] = true;
            return callback;
          }
        });
        jQuery12.ajaxPrefilter("json jsonp", function(s, originalSettings, jqXHR) {
          var callbackName, overwritten, responseContainer, jsonProp = s.jsonp !== false && (rjsonp.test(s.url) ? "url" : typeof s.data === "string" && (s.contentType || "").indexOf("application/x-www-form-urlencoded") === 0 && rjsonp.test(s.data) && "data");
          if (jsonProp || s.dataTypes[0] === "jsonp") {
            callbackName = s.jsonpCallback = isFunction(s.jsonpCallback) ? s.jsonpCallback() : s.jsonpCallback;
            if (jsonProp) {
              s[jsonProp] = s[jsonProp].replace(rjsonp, "$1" + callbackName);
            } else if (s.jsonp !== false) {
              s.url += (rquery.test(s.url) ? "&" : "?") + s.jsonp + "=" + callbackName;
            }
            s.converters["script json"] = function() {
              if (!responseContainer) {
                jQuery12.error(callbackName + " was not called");
              }
              return responseContainer[0];
            };
            s.dataTypes[0] = "json";
            overwritten = window2[callbackName];
            window2[callbackName] = function() {
              responseContainer = arguments;
            };
            jqXHR.always(function() {
              if (overwritten === void 0) {
                jQuery12(window2).removeProp(callbackName);
              } else {
                window2[callbackName] = overwritten;
              }
              if (s[callbackName]) {
                s.jsonpCallback = originalSettings.jsonpCallback;
                oldCallbacks.push(callbackName);
              }
              if (responseContainer && isFunction(overwritten)) {
                overwritten(responseContainer[0]);
              }
              responseContainer = overwritten = void 0;
            });
            return "script";
          }
        });
        support.createHTMLDocument = function() {
          var body = document2.implementation.createHTMLDocument("").body;
          body.innerHTML = "<form></form><form></form>";
          return body.childNodes.length === 2;
        }();
        jQuery12.parseHTML = function(data, context, keepScripts) {
          if (typeof data !== "string") {
            return [];
          }
          if (typeof context === "boolean") {
            keepScripts = context;
            context = false;
          }
          var base, parsed, scripts;
          if (!context) {
            if (support.createHTMLDocument) {
              context = document2.implementation.createHTMLDocument("");
              base = context.createElement("base");
              base.href = document2.location.href;
              context.head.appendChild(base);
            } else {
              context = document2;
            }
          }
          parsed = rsingleTag.exec(data);
          scripts = !keepScripts && [];
          if (parsed) {
            return [context.createElement(parsed[1])];
          }
          parsed = buildFragment([data], context, scripts);
          if (scripts && scripts.length) {
            jQuery12(scripts).remove();
          }
          return jQuery12.merge([], parsed.childNodes);
        };
        jQuery12.fn.load = function(url, params, callback) {
          var selector, type, response, self2 = this, off = url.indexOf(" ");
          if (off > -1) {
            selector = stripAndCollapse(url.slice(off));
            url = url.slice(0, off);
          }
          if (isFunction(params)) {
            callback = params;
            params = void 0;
          } else if (params && typeof params === "object") {
            type = "POST";
          }
          if (self2.length > 0) {
            jQuery12.ajax({
              url,
              // If "type" variable is undefined, then "GET" method will be used.
              // Make value of this field explicit since
              // user can override it through ajaxSetup method
              type: type || "GET",
              dataType: "html",
              data: params
            }).done(function(responseText) {
              response = arguments;
              self2.html(selector ? (
                // If a selector was specified, locate the right elements in a dummy div
                // Exclude scripts to avoid IE 'Permission Denied' errors
                jQuery12("<div>").append(jQuery12.parseHTML(responseText)).find(selector)
              ) : (
                // Otherwise use the full result
                responseText
              ));
            }).always(callback && function(jqXHR, status) {
              self2.each(function() {
                callback.apply(this, response || [jqXHR.responseText, status, jqXHR]);
              });
            });
          }
          return this;
        };
        jQuery12.expr.pseudos.animated = function(elem) {
          return jQuery12.grep(jQuery12.timers, function(fn2) {
            return elem === fn2.elem;
          }).length;
        };
        jQuery12.offset = {
          setOffset: function(elem, options, i) {
            var curPosition, curLeft, curCSSTop, curTop, curOffset, curCSSLeft, calculatePosition, position = jQuery12.css(elem, "position"), curElem = jQuery12(elem), props = {};
            if (position === "static") {
              elem.style.position = "relative";
            }
            curOffset = curElem.offset();
            curCSSTop = jQuery12.css(elem, "top");
            curCSSLeft = jQuery12.css(elem, "left");
            calculatePosition = (position === "absolute" || position === "fixed") && (curCSSTop + curCSSLeft).indexOf("auto") > -1;
            if (calculatePosition) {
              curPosition = curElem.position();
              curTop = curPosition.top;
              curLeft = curPosition.left;
            } else {
              curTop = parseFloat(curCSSTop) || 0;
              curLeft = parseFloat(curCSSLeft) || 0;
            }
            if (isFunction(options)) {
              options = options.call(elem, i, jQuery12.extend({}, curOffset));
            }
            if (options.top != null) {
              props.top = options.top - curOffset.top + curTop;
            }
            if (options.left != null) {
              props.left = options.left - curOffset.left + curLeft;
            }
            if ("using" in options) {
              options.using.call(elem, props);
            } else {
              curElem.css(props);
            }
          }
        };
        jQuery12.fn.extend({
          // offset() relates an element's border box to the document origin
          offset: function(options) {
            if (arguments.length) {
              return options === void 0 ? this : this.each(function(i) {
                jQuery12.offset.setOffset(this, options, i);
              });
            }
            var rect, win, elem = this[0];
            if (!elem) {
              return;
            }
            if (!elem.getClientRects().length) {
              return { top: 0, left: 0 };
            }
            rect = elem.getBoundingClientRect();
            win = elem.ownerDocument.defaultView;
            return {
              top: rect.top + win.pageYOffset,
              left: rect.left + win.pageXOffset
            };
          },
          // position() relates an element's margin box to its offset parent's padding box
          // This corresponds to the behavior of CSS absolute positioning
          position: function() {
            if (!this[0]) {
              return;
            }
            var offsetParent, offset2, doc, elem = this[0], parentOffset = { top: 0, left: 0 };
            if (jQuery12.css(elem, "position") === "fixed") {
              offset2 = elem.getBoundingClientRect();
            } else {
              offset2 = this.offset();
              doc = elem.ownerDocument;
              offsetParent = elem.offsetParent || doc.documentElement;
              while (offsetParent && (offsetParent === doc.body || offsetParent === doc.documentElement) && jQuery12.css(offsetParent, "position") === "static") {
                offsetParent = offsetParent.parentNode;
              }
              if (offsetParent && offsetParent !== elem && offsetParent.nodeType === 1) {
                parentOffset = jQuery12(offsetParent).offset();
                parentOffset.top += jQuery12.css(offsetParent, "borderTopWidth", true);
                parentOffset.left += jQuery12.css(offsetParent, "borderLeftWidth", true);
              }
            }
            return {
              top: offset2.top - parentOffset.top - jQuery12.css(elem, "marginTop", true),
              left: offset2.left - parentOffset.left - jQuery12.css(elem, "marginLeft", true)
            };
          },
          // This method will return documentElement in the following cases:
          // 1) For the element inside the iframe without offsetParent, this method will return
          //    documentElement of the parent window
          // 2) For the hidden or detached element
          // 3) For body or html element, i.e. in case of the html node - it will return itself
          //
          // but those exceptions were never presented as a real life use-cases
          // and might be considered as more preferable results.
          //
          // This logic, however, is not guaranteed and can change at any point in the future
          offsetParent: function() {
            return this.map(function() {
              var offsetParent = this.offsetParent;
              while (offsetParent && jQuery12.css(offsetParent, "position") === "static") {
                offsetParent = offsetParent.offsetParent;
              }
              return offsetParent || documentElement;
            });
          }
        });
        jQuery12.each({ scrollLeft: "pageXOffset", scrollTop: "pageYOffset" }, function(method, prop) {
          var top2 = "pageYOffset" === prop;
          jQuery12.fn[method] = function(val) {
            return access(this, function(elem, method2, val2) {
              var win;
              if (isWindow(elem)) {
                win = elem;
              } else if (elem.nodeType === 9) {
                win = elem.defaultView;
              }
              if (val2 === void 0) {
                return win ? win[prop] : elem[method2];
              }
              if (win) {
                win.scrollTo(
                  !top2 ? val2 : win.pageXOffset,
                  top2 ? val2 : win.pageYOffset
                );
              } else {
                elem[method2] = val2;
              }
            }, method, val, arguments.length);
          };
        });
        jQuery12.each(["top", "left"], function(_i, prop) {
          jQuery12.cssHooks[prop] = addGetHookIf(
            support.pixelPosition,
            function(elem, computed) {
              if (computed) {
                computed = curCSS(elem, prop);
                return rnumnonpx.test(computed) ? jQuery12(elem).position()[prop] + "px" : computed;
              }
            }
          );
        });
        jQuery12.each({ Height: "height", Width: "width" }, function(name, type) {
          jQuery12.each({
            padding: "inner" + name,
            content: type,
            "": "outer" + name
          }, function(defaultExtra, funcName) {
            jQuery12.fn[funcName] = function(margin, value) {
              var chainable = arguments.length && (defaultExtra || typeof margin !== "boolean"), extra = defaultExtra || (margin === true || value === true ? "margin" : "border");
              return access(this, function(elem, type2, value2) {
                var doc;
                if (isWindow(elem)) {
                  return funcName.indexOf("outer") === 0 ? elem["inner" + name] : elem.document.documentElement["client" + name];
                }
                if (elem.nodeType === 9) {
                  doc = elem.documentElement;
                  return Math.max(
                    elem.body["scroll" + name],
                    doc["scroll" + name],
                    elem.body["offset" + name],
                    doc["offset" + name],
                    doc["client" + name]
                  );
                }
                return value2 === void 0 ? (
                  // Get width or height on the element, requesting but not forcing parseFloat
                  jQuery12.css(elem, type2, extra)
                ) : (
                  // Set width or height on the element
                  jQuery12.style(elem, type2, value2, extra)
                );
              }, type, chainable ? margin : void 0, chainable);
            };
          });
        });
        jQuery12.each([
          "ajaxStart",
          "ajaxStop",
          "ajaxComplete",
          "ajaxError",
          "ajaxSuccess",
          "ajaxSend"
        ], function(_i, type) {
          jQuery12.fn[type] = function(fn2) {
            return this.on(type, fn2);
          };
        });
        jQuery12.fn.extend({
          bind: function(types, data, fn2) {
            return this.on(types, null, data, fn2);
          },
          unbind: function(types, fn2) {
            return this.off(types, null, fn2);
          },
          delegate: function(selector, types, data, fn2) {
            return this.on(types, selector, data, fn2);
          },
          undelegate: function(selector, types, fn2) {
            return arguments.length === 1 ? this.off(selector, "**") : this.off(types, selector || "**", fn2);
          },
          hover: function(fnOver, fnOut) {
            return this.on("mouseenter", fnOver).on("mouseleave", fnOut || fnOver);
          }
        });
        jQuery12.each(
          "blur focus focusin focusout resize scroll click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup contextmenu".split(" "),
          function(_i, name) {
            jQuery12.fn[name] = function(data, fn2) {
              return arguments.length > 0 ? this.on(name, null, data, fn2) : this.trigger(name);
            };
          }
        );
        var rtrim = /^[\s\uFEFF\xA0]+|([^\s\uFEFF\xA0])[\s\uFEFF\xA0]+$/g;
        jQuery12.proxy = function(fn2, context) {
          var tmp, args, proxy;
          if (typeof context === "string") {
            tmp = fn2[context];
            context = fn2;
            fn2 = tmp;
          }
          if (!isFunction(fn2)) {
            return void 0;
          }
          args = slice.call(arguments, 2);
          proxy = function() {
            return fn2.apply(context || this, args.concat(slice.call(arguments)));
          };
          proxy.guid = fn2.guid = fn2.guid || jQuery12.guid++;
          return proxy;
        };
        jQuery12.holdReady = function(hold) {
          if (hold) {
            jQuery12.readyWait++;
          } else {
            jQuery12.ready(true);
          }
        };
        jQuery12.isArray = Array.isArray;
        jQuery12.parseJSON = JSON.parse;
        jQuery12.nodeName = nodeName;
        jQuery12.isFunction = isFunction;
        jQuery12.isWindow = isWindow;
        jQuery12.camelCase = camelCase;
        jQuery12.type = toType2;
        jQuery12.now = Date.now;
        jQuery12.isNumeric = function(obj) {
          var type = jQuery12.type(obj);
          return (type === "number" || type === "string") && // parseFloat NaNs numeric-cast false positives ("")
          // ...but misinterprets leading-number strings, particularly hex literals ("0x...")
          // subtraction forces infinities to NaN
          !isNaN(obj - parseFloat(obj));
        };
        jQuery12.trim = function(text) {
          return text == null ? "" : (text + "").replace(rtrim, "$1");
        };
        if (typeof define === "function" && define.amd) {
          define("jquery", [], function() {
            return jQuery12;
          });
        }
        var _jQuery = window2.jQuery, _$ = window2.$;
        jQuery12.noConflict = function(deep) {
          if (window2.$ === jQuery12) {
            window2.$ = _$;
          }
          if (deep && window2.jQuery === jQuery12) {
            window2.jQuery = _jQuery;
          }
          return jQuery12;
        };
        if (typeof noGlobal === "undefined") {
          window2.jQuery = window2.$ = jQuery12;
        }
        return jQuery12;
      });
    }
  });

  // node_modules/rails_admin/src/rails_admin/base.js
  var import_ujs2 = __toESM(require_rails_ujs());

  // node_modules/@hotwired/turbo/dist/turbo.es2017-esm.js
  (function() {
    if (window.Reflect === void 0 || window.customElements === void 0 || window.customElements.polyfillWrapFlushCallback) {
      return;
    }
    const BuiltInHTMLElement = HTMLElement;
    const wrapperForTheName = {
      HTMLElement: function HTMLElement2() {
        return Reflect.construct(BuiltInHTMLElement, [], this.constructor);
      }
    };
    window.HTMLElement = wrapperForTheName["HTMLElement"];
    HTMLElement.prototype = BuiltInHTMLElement.prototype;
    HTMLElement.prototype.constructor = HTMLElement;
    Object.setPrototypeOf(HTMLElement, BuiltInHTMLElement);
  })();
  (function(prototype) {
    if (typeof prototype.requestSubmit == "function") return;
    prototype.requestSubmit = function(submitter) {
      if (submitter) {
        validateSubmitter(submitter, this);
        submitter.click();
      } else {
        submitter = document.createElement("input");
        submitter.type = "submit";
        submitter.hidden = true;
        this.appendChild(submitter);
        submitter.click();
        this.removeChild(submitter);
      }
    };
    function validateSubmitter(submitter, form) {
      submitter instanceof HTMLElement || raise(TypeError, "parameter 1 is not of type 'HTMLElement'");
      submitter.type == "submit" || raise(TypeError, "The specified element is not a submit button");
      submitter.form == form || raise(DOMException, "The specified element is not owned by this form element", "NotFoundError");
    }
    function raise(errorConstructor, message, name) {
      throw new errorConstructor("Failed to execute 'requestSubmit' on 'HTMLFormElement': " + message + ".", name);
    }
  })(HTMLFormElement.prototype);
  var submittersByForm = /* @__PURE__ */ new WeakMap();
  function findSubmitterFromClickTarget(target) {
    const element = target instanceof Element ? target : target instanceof Node ? target.parentElement : null;
    const candidate = element ? element.closest("input, button") : null;
    return (candidate === null || candidate === void 0 ? void 0 : candidate.type) == "submit" ? candidate : null;
  }
  function clickCaptured(event) {
    const submitter = findSubmitterFromClickTarget(event.target);
    if (submitter && submitter.form) {
      submittersByForm.set(submitter.form, submitter);
    }
  }
  (function() {
    if ("submitter" in Event.prototype)
      return;
    let prototype = window.Event.prototype;
    if ("SubmitEvent" in window && /Apple Computer/.test(navigator.vendor)) {
      prototype = window.SubmitEvent.prototype;
    } else if ("SubmitEvent" in window) {
      return;
    }
    addEventListener("click", clickCaptured, true);
    Object.defineProperty(prototype, "submitter", {
      get() {
        if (this.type == "submit" && this.target instanceof HTMLFormElement) {
          return submittersByForm.get(this.target);
        }
      }
    });
  })();
  var FrameLoadingStyle;
  (function(FrameLoadingStyle2) {
    FrameLoadingStyle2["eager"] = "eager";
    FrameLoadingStyle2["lazy"] = "lazy";
  })(FrameLoadingStyle || (FrameLoadingStyle = {}));
  var FrameElement = class _FrameElement extends HTMLElement {
    static get observedAttributes() {
      return ["disabled", "complete", "loading", "src"];
    }
    constructor() {
      super();
      this.loaded = Promise.resolve();
      this.delegate = new _FrameElement.delegateConstructor(this);
    }
    connectedCallback() {
      this.delegate.connect();
    }
    disconnectedCallback() {
      this.delegate.disconnect();
    }
    reload() {
      return this.delegate.sourceURLReloaded();
    }
    attributeChangedCallback(name) {
      if (name == "loading") {
        this.delegate.loadingStyleChanged();
      } else if (name == "complete") {
        this.delegate.completeChanged();
      } else if (name == "src") {
        this.delegate.sourceURLChanged();
      } else {
        this.delegate.disabledChanged();
      }
    }
    get src() {
      return this.getAttribute("src");
    }
    set src(value) {
      if (value) {
        this.setAttribute("src", value);
      } else {
        this.removeAttribute("src");
      }
    }
    get loading() {
      return frameLoadingStyleFromString(this.getAttribute("loading") || "");
    }
    set loading(value) {
      if (value) {
        this.setAttribute("loading", value);
      } else {
        this.removeAttribute("loading");
      }
    }
    get disabled() {
      return this.hasAttribute("disabled");
    }
    set disabled(value) {
      if (value) {
        this.setAttribute("disabled", "");
      } else {
        this.removeAttribute("disabled");
      }
    }
    get autoscroll() {
      return this.hasAttribute("autoscroll");
    }
    set autoscroll(value) {
      if (value) {
        this.setAttribute("autoscroll", "");
      } else {
        this.removeAttribute("autoscroll");
      }
    }
    get complete() {
      return !this.delegate.isLoading;
    }
    get isActive() {
      return this.ownerDocument === document && !this.isPreview;
    }
    get isPreview() {
      var _a, _b;
      return (_b = (_a = this.ownerDocument) === null || _a === void 0 ? void 0 : _a.documentElement) === null || _b === void 0 ? void 0 : _b.hasAttribute("data-turbo-preview");
    }
  };
  function frameLoadingStyleFromString(style) {
    switch (style.toLowerCase()) {
      case "lazy":
        return FrameLoadingStyle.lazy;
      default:
        return FrameLoadingStyle.eager;
    }
  }
  function expandURL(locatable) {
    return new URL(locatable.toString(), document.baseURI);
  }
  function getAnchor(url) {
    let anchorMatch;
    if (url.hash) {
      return url.hash.slice(1);
    } else if (anchorMatch = url.href.match(/#(.*)$/)) {
      return anchorMatch[1];
    }
  }
  function getAction(form, submitter) {
    const action = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("formaction")) || form.getAttribute("action") || form.action;
    return expandURL(action);
  }
  function getExtension(url) {
    return (getLastPathComponent(url).match(/\.[^.]*$/) || [])[0] || "";
  }
  function isHTML(url) {
    return !!getExtension(url).match(/^(?:|\.(?:htm|html|xhtml|php))$/);
  }
  function isPrefixedBy(baseURL, url) {
    const prefix = getPrefix(url);
    return baseURL.href === expandURL(prefix).href || baseURL.href.startsWith(prefix);
  }
  function locationIsVisitable(location2, rootLocation) {
    return isPrefixedBy(location2, rootLocation) && isHTML(location2);
  }
  function getRequestURL(url) {
    const anchor = getAnchor(url);
    return anchor != null ? url.href.slice(0, -(anchor.length + 1)) : url.href;
  }
  function toCacheKey(url) {
    return getRequestURL(url);
  }
  function urlsAreEqual(left2, right2) {
    return expandURL(left2).href == expandURL(right2).href;
  }
  function getPathComponents(url) {
    return url.pathname.split("/").slice(1);
  }
  function getLastPathComponent(url) {
    return getPathComponents(url).slice(-1)[0];
  }
  function getPrefix(url) {
    return addTrailingSlash(url.origin + url.pathname);
  }
  function addTrailingSlash(value) {
    return value.endsWith("/") ? value : value + "/";
  }
  var FetchResponse = class {
    constructor(response) {
      this.response = response;
    }
    get succeeded() {
      return this.response.ok;
    }
    get failed() {
      return !this.succeeded;
    }
    get clientError() {
      return this.statusCode >= 400 && this.statusCode <= 499;
    }
    get serverError() {
      return this.statusCode >= 500 && this.statusCode <= 599;
    }
    get redirected() {
      return this.response.redirected;
    }
    get location() {
      return expandURL(this.response.url);
    }
    get isHTML() {
      return this.contentType && this.contentType.match(/^(?:text\/([^\s;,]+\b)?html|application\/xhtml\+xml)\b/);
    }
    get statusCode() {
      return this.response.status;
    }
    get contentType() {
      return this.header("Content-Type");
    }
    get responseText() {
      return this.response.clone().text();
    }
    get responseHTML() {
      if (this.isHTML) {
        return this.response.clone().text();
      } else {
        return Promise.resolve(void 0);
      }
    }
    header(name) {
      return this.response.headers.get(name);
    }
  };
  function activateScriptElement(element) {
    if (element.getAttribute("data-turbo-eval") == "false") {
      return element;
    } else {
      const createdScriptElement = document.createElement("script");
      const cspNonce = getMetaContent("csp-nonce");
      if (cspNonce) {
        createdScriptElement.nonce = cspNonce;
      }
      createdScriptElement.textContent = element.textContent;
      createdScriptElement.async = false;
      copyElementAttributes(createdScriptElement, element);
      return createdScriptElement;
    }
  }
  function copyElementAttributes(destinationElement, sourceElement) {
    for (const { name, value } of sourceElement.attributes) {
      destinationElement.setAttribute(name, value);
    }
  }
  function createDocumentFragment(html) {
    const template = document.createElement("template");
    template.innerHTML = html;
    return template.content;
  }
  function dispatch(eventName, { target, cancelable, detail } = {}) {
    const event = new CustomEvent(eventName, {
      cancelable,
      bubbles: true,
      composed: true,
      detail
    });
    if (target && target.isConnected) {
      target.dispatchEvent(event);
    } else {
      document.documentElement.dispatchEvent(event);
    }
    return event;
  }
  function nextAnimationFrame() {
    return new Promise((resolve) => requestAnimationFrame(() => resolve()));
  }
  function nextEventLoopTick() {
    return new Promise((resolve) => setTimeout(() => resolve(), 0));
  }
  function nextMicrotask() {
    return Promise.resolve();
  }
  function parseHTMLDocument(html = "") {
    return new DOMParser().parseFromString(html, "text/html");
  }
  function unindent(strings, ...values) {
    const lines = interpolate(strings, values).replace(/^\n/, "").split("\n");
    const match = lines[0].match(/^\s+/);
    const indent = match ? match[0].length : 0;
    return lines.map((line) => line.slice(indent)).join("\n");
  }
  function interpolate(strings, values) {
    return strings.reduce((result, string, i) => {
      const value = values[i] == void 0 ? "" : values[i];
      return result + string + value;
    }, "");
  }
  function uuid() {
    return Array.from({ length: 36 }).map((_, i) => {
      if (i == 8 || i == 13 || i == 18 || i == 23) {
        return "-";
      } else if (i == 14) {
        return "4";
      } else if (i == 19) {
        return (Math.floor(Math.random() * 4) + 8).toString(16);
      } else {
        return Math.floor(Math.random() * 15).toString(16);
      }
    }).join("");
  }
  function getAttribute(attributeName, ...elements) {
    for (const value of elements.map((element) => element === null || element === void 0 ? void 0 : element.getAttribute(attributeName))) {
      if (typeof value == "string")
        return value;
    }
    return null;
  }
  function hasAttribute(attributeName, ...elements) {
    return elements.some((element) => element && element.hasAttribute(attributeName));
  }
  function markAsBusy(...elements) {
    for (const element of elements) {
      if (element.localName == "turbo-frame") {
        element.setAttribute("busy", "");
      }
      element.setAttribute("aria-busy", "true");
    }
  }
  function clearBusyState(...elements) {
    for (const element of elements) {
      if (element.localName == "turbo-frame") {
        element.removeAttribute("busy");
      }
      element.removeAttribute("aria-busy");
    }
  }
  function waitForLoad(element, timeoutInMilliseconds = 2e3) {
    return new Promise((resolve) => {
      const onComplete = () => {
        element.removeEventListener("error", onComplete);
        element.removeEventListener("load", onComplete);
        resolve();
      };
      element.addEventListener("load", onComplete, { once: true });
      element.addEventListener("error", onComplete, { once: true });
      setTimeout(resolve, timeoutInMilliseconds);
    });
  }
  function getHistoryMethodForAction(action) {
    switch (action) {
      case "replace":
        return history.replaceState;
      case "advance":
      case "restore":
        return history.pushState;
    }
  }
  function isAction(action) {
    return action == "advance" || action == "replace" || action == "restore";
  }
  function getVisitAction(...elements) {
    const action = getAttribute("data-turbo-action", ...elements);
    return isAction(action) ? action : null;
  }
  function getMetaElement(name) {
    return document.querySelector(`meta[name="${name}"]`);
  }
  function getMetaContent(name) {
    const element = getMetaElement(name);
    return element && element.content;
  }
  function setMetaContent(name, content) {
    let element = getMetaElement(name);
    if (!element) {
      element = document.createElement("meta");
      element.setAttribute("name", name);
      document.head.appendChild(element);
    }
    element.setAttribute("content", content);
    return element;
  }
  function findClosestRecursively(element, selector) {
    var _a;
    if (element instanceof Element) {
      return element.closest(selector) || findClosestRecursively(element.assignedSlot || ((_a = element.getRootNode()) === null || _a === void 0 ? void 0 : _a.host), selector);
    }
  }
  var FetchMethod;
  (function(FetchMethod2) {
    FetchMethod2[FetchMethod2["get"] = 0] = "get";
    FetchMethod2[FetchMethod2["post"] = 1] = "post";
    FetchMethod2[FetchMethod2["put"] = 2] = "put";
    FetchMethod2[FetchMethod2["patch"] = 3] = "patch";
    FetchMethod2[FetchMethod2["delete"] = 4] = "delete";
  })(FetchMethod || (FetchMethod = {}));
  function fetchMethodFromString(method) {
    switch (method.toLowerCase()) {
      case "get":
        return FetchMethod.get;
      case "post":
        return FetchMethod.post;
      case "put":
        return FetchMethod.put;
      case "patch":
        return FetchMethod.patch;
      case "delete":
        return FetchMethod.delete;
    }
  }
  var FetchRequest = class {
    constructor(delegate, method, location2, body = new URLSearchParams(), target = null) {
      this.abortController = new AbortController();
      this.resolveRequestPromise = (_value) => {
      };
      this.delegate = delegate;
      this.method = method;
      this.headers = this.defaultHeaders;
      this.body = body;
      this.url = location2;
      this.target = target;
    }
    get location() {
      return this.url;
    }
    get params() {
      return this.url.searchParams;
    }
    get entries() {
      return this.body ? Array.from(this.body.entries()) : [];
    }
    cancel() {
      this.abortController.abort();
    }
    async perform() {
      const { fetchOptions } = this;
      this.delegate.prepareRequest(this);
      await this.allowRequestToBeIntercepted(fetchOptions);
      try {
        this.delegate.requestStarted(this);
        const response = await fetch(this.url.href, fetchOptions);
        return await this.receive(response);
      } catch (error) {
        if (error.name !== "AbortError") {
          if (this.willDelegateErrorHandling(error)) {
            this.delegate.requestErrored(this, error);
          }
          throw error;
        }
      } finally {
        this.delegate.requestFinished(this);
      }
    }
    async receive(response) {
      const fetchResponse = new FetchResponse(response);
      const event = dispatch("turbo:before-fetch-response", {
        cancelable: true,
        detail: { fetchResponse },
        target: this.target
      });
      if (event.defaultPrevented) {
        this.delegate.requestPreventedHandlingResponse(this, fetchResponse);
      } else if (fetchResponse.succeeded) {
        this.delegate.requestSucceededWithResponse(this, fetchResponse);
      } else {
        this.delegate.requestFailedWithResponse(this, fetchResponse);
      }
      return fetchResponse;
    }
    get fetchOptions() {
      var _a;
      return {
        method: FetchMethod[this.method].toUpperCase(),
        credentials: "same-origin",
        headers: this.headers,
        redirect: "follow",
        body: this.isSafe ? null : this.body,
        signal: this.abortSignal,
        referrer: (_a = this.delegate.referrer) === null || _a === void 0 ? void 0 : _a.href
      };
    }
    get defaultHeaders() {
      return {
        Accept: "text/html, application/xhtml+xml"
      };
    }
    get isSafe() {
      return this.method === FetchMethod.get;
    }
    get abortSignal() {
      return this.abortController.signal;
    }
    acceptResponseType(mimeType) {
      this.headers["Accept"] = [mimeType, this.headers["Accept"]].join(", ");
    }
    async allowRequestToBeIntercepted(fetchOptions) {
      const requestInterception = new Promise((resolve) => this.resolveRequestPromise = resolve);
      const event = dispatch("turbo:before-fetch-request", {
        cancelable: true,
        detail: {
          fetchOptions,
          url: this.url,
          resume: this.resolveRequestPromise
        },
        target: this.target
      });
      if (event.defaultPrevented)
        await requestInterception;
    }
    willDelegateErrorHandling(error) {
      const event = dispatch("turbo:fetch-request-error", {
        target: this.target,
        cancelable: true,
        detail: { request: this, error }
      });
      return !event.defaultPrevented;
    }
  };
  var AppearanceObserver = class {
    constructor(delegate, element) {
      this.started = false;
      this.intersect = (entries) => {
        const lastEntry = entries.slice(-1)[0];
        if (lastEntry === null || lastEntry === void 0 ? void 0 : lastEntry.isIntersecting) {
          this.delegate.elementAppearedInViewport(this.element);
        }
      };
      this.delegate = delegate;
      this.element = element;
      this.intersectionObserver = new IntersectionObserver(this.intersect);
    }
    start() {
      if (!this.started) {
        this.started = true;
        this.intersectionObserver.observe(this.element);
      }
    }
    stop() {
      if (this.started) {
        this.started = false;
        this.intersectionObserver.unobserve(this.element);
      }
    }
  };
  var StreamMessage = class {
    static wrap(message) {
      if (typeof message == "string") {
        return new this(createDocumentFragment(message));
      } else {
        return message;
      }
    }
    constructor(fragment) {
      this.fragment = importStreamElements(fragment);
    }
  };
  StreamMessage.contentType = "text/vnd.turbo-stream.html";
  function importStreamElements(fragment) {
    for (const element of fragment.querySelectorAll("turbo-stream")) {
      const streamElement = document.importNode(element, true);
      for (const inertScriptElement of streamElement.templateElement.content.querySelectorAll("script")) {
        inertScriptElement.replaceWith(activateScriptElement(inertScriptElement));
      }
      element.replaceWith(streamElement);
    }
    return fragment;
  }
  var FormSubmissionState;
  (function(FormSubmissionState2) {
    FormSubmissionState2[FormSubmissionState2["initialized"] = 0] = "initialized";
    FormSubmissionState2[FormSubmissionState2["requesting"] = 1] = "requesting";
    FormSubmissionState2[FormSubmissionState2["waiting"] = 2] = "waiting";
    FormSubmissionState2[FormSubmissionState2["receiving"] = 3] = "receiving";
    FormSubmissionState2[FormSubmissionState2["stopping"] = 4] = "stopping";
    FormSubmissionState2[FormSubmissionState2["stopped"] = 5] = "stopped";
  })(FormSubmissionState || (FormSubmissionState = {}));
  var FormEnctype;
  (function(FormEnctype2) {
    FormEnctype2["urlEncoded"] = "application/x-www-form-urlencoded";
    FormEnctype2["multipart"] = "multipart/form-data";
    FormEnctype2["plain"] = "text/plain";
  })(FormEnctype || (FormEnctype = {}));
  function formEnctypeFromString(encoding) {
    switch (encoding.toLowerCase()) {
      case FormEnctype.multipart:
        return FormEnctype.multipart;
      case FormEnctype.plain:
        return FormEnctype.plain;
      default:
        return FormEnctype.urlEncoded;
    }
  }
  var FormSubmission = class _FormSubmission {
    static confirmMethod(message, _element, _submitter) {
      return Promise.resolve(confirm(message));
    }
    constructor(delegate, formElement, submitter, mustRedirect = false) {
      this.state = FormSubmissionState.initialized;
      this.delegate = delegate;
      this.formElement = formElement;
      this.submitter = submitter;
      this.formData = buildFormData(formElement, submitter);
      this.location = expandURL(this.action);
      if (this.method == FetchMethod.get) {
        mergeFormDataEntries(this.location, [...this.body.entries()]);
      }
      this.fetchRequest = new FetchRequest(this, this.method, this.location, this.body, this.formElement);
      this.mustRedirect = mustRedirect;
    }
    get method() {
      var _a;
      const method = ((_a = this.submitter) === null || _a === void 0 ? void 0 : _a.getAttribute("formmethod")) || this.formElement.getAttribute("method") || "";
      return fetchMethodFromString(method.toLowerCase()) || FetchMethod.get;
    }
    get action() {
      var _a;
      const formElementAction = typeof this.formElement.action === "string" ? this.formElement.action : null;
      if ((_a = this.submitter) === null || _a === void 0 ? void 0 : _a.hasAttribute("formaction")) {
        return this.submitter.getAttribute("formaction") || "";
      } else {
        return this.formElement.getAttribute("action") || formElementAction || "";
      }
    }
    get body() {
      if (this.enctype == FormEnctype.urlEncoded || this.method == FetchMethod.get) {
        return new URLSearchParams(this.stringFormData);
      } else {
        return this.formData;
      }
    }
    get enctype() {
      var _a;
      return formEnctypeFromString(((_a = this.submitter) === null || _a === void 0 ? void 0 : _a.getAttribute("formenctype")) || this.formElement.enctype);
    }
    get isSafe() {
      return this.fetchRequest.isSafe;
    }
    get stringFormData() {
      return [...this.formData].reduce((entries, [name, value]) => {
        return entries.concat(typeof value == "string" ? [[name, value]] : []);
      }, []);
    }
    async start() {
      const { initialized, requesting } = FormSubmissionState;
      const confirmationMessage = getAttribute("data-turbo-confirm", this.submitter, this.formElement);
      if (typeof confirmationMessage === "string") {
        const answer = await _FormSubmission.confirmMethod(confirmationMessage, this.formElement, this.submitter);
        if (!answer) {
          return;
        }
      }
      if (this.state == initialized) {
        this.state = requesting;
        return this.fetchRequest.perform();
      }
    }
    stop() {
      const { stopping, stopped } = FormSubmissionState;
      if (this.state != stopping && this.state != stopped) {
        this.state = stopping;
        this.fetchRequest.cancel();
        return true;
      }
    }
    prepareRequest(request) {
      if (!request.isSafe) {
        const token = getCookieValue(getMetaContent("csrf-param")) || getMetaContent("csrf-token");
        if (token) {
          request.headers["X-CSRF-Token"] = token;
        }
      }
      if (this.requestAcceptsTurboStreamResponse(request)) {
        request.acceptResponseType(StreamMessage.contentType);
      }
    }
    requestStarted(_request) {
      var _a;
      this.state = FormSubmissionState.waiting;
      (_a = this.submitter) === null || _a === void 0 ? void 0 : _a.setAttribute("disabled", "");
      this.setSubmitsWith();
      dispatch("turbo:submit-start", {
        target: this.formElement,
        detail: { formSubmission: this }
      });
      this.delegate.formSubmissionStarted(this);
    }
    requestPreventedHandlingResponse(request, response) {
      this.result = { success: response.succeeded, fetchResponse: response };
    }
    requestSucceededWithResponse(request, response) {
      if (response.clientError || response.serverError) {
        this.delegate.formSubmissionFailedWithResponse(this, response);
      } else if (this.requestMustRedirect(request) && responseSucceededWithoutRedirect(response)) {
        const error = new Error("Form responses must redirect to another location");
        this.delegate.formSubmissionErrored(this, error);
      } else {
        this.state = FormSubmissionState.receiving;
        this.result = { success: true, fetchResponse: response };
        this.delegate.formSubmissionSucceededWithResponse(this, response);
      }
    }
    requestFailedWithResponse(request, response) {
      this.result = { success: false, fetchResponse: response };
      this.delegate.formSubmissionFailedWithResponse(this, response);
    }
    requestErrored(request, error) {
      this.result = { success: false, error };
      this.delegate.formSubmissionErrored(this, error);
    }
    requestFinished(_request) {
      var _a;
      this.state = FormSubmissionState.stopped;
      (_a = this.submitter) === null || _a === void 0 ? void 0 : _a.removeAttribute("disabled");
      this.resetSubmitterText();
      dispatch("turbo:submit-end", {
        target: this.formElement,
        detail: Object.assign({ formSubmission: this }, this.result)
      });
      this.delegate.formSubmissionFinished(this);
    }
    setSubmitsWith() {
      if (!this.submitter || !this.submitsWith)
        return;
      if (this.submitter.matches("button")) {
        this.originalSubmitText = this.submitter.innerHTML;
        this.submitter.innerHTML = this.submitsWith;
      } else if (this.submitter.matches("input")) {
        const input = this.submitter;
        this.originalSubmitText = input.value;
        input.value = this.submitsWith;
      }
    }
    resetSubmitterText() {
      if (!this.submitter || !this.originalSubmitText)
        return;
      if (this.submitter.matches("button")) {
        this.submitter.innerHTML = this.originalSubmitText;
      } else if (this.submitter.matches("input")) {
        const input = this.submitter;
        input.value = this.originalSubmitText;
      }
    }
    requestMustRedirect(request) {
      return !request.isSafe && this.mustRedirect;
    }
    requestAcceptsTurboStreamResponse(request) {
      return !request.isSafe || hasAttribute("data-turbo-stream", this.submitter, this.formElement);
    }
    get submitsWith() {
      var _a;
      return (_a = this.submitter) === null || _a === void 0 ? void 0 : _a.getAttribute("data-turbo-submits-with");
    }
  };
  function buildFormData(formElement, submitter) {
    const formData = new FormData(formElement);
    const name = submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("name");
    const value = submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("value");
    if (name) {
      formData.append(name, value || "");
    }
    return formData;
  }
  function getCookieValue(cookieName) {
    if (cookieName != null) {
      const cookies = document.cookie ? document.cookie.split("; ") : [];
      const cookie = cookies.find((cookie2) => cookie2.startsWith(cookieName));
      if (cookie) {
        const value = cookie.split("=").slice(1).join("=");
        return value ? decodeURIComponent(value) : void 0;
      }
    }
  }
  function responseSucceededWithoutRedirect(response) {
    return response.statusCode == 200 && !response.redirected;
  }
  function mergeFormDataEntries(url, entries) {
    const searchParams = new URLSearchParams();
    for (const [name, value] of entries) {
      if (value instanceof File)
        continue;
      searchParams.append(name, value);
    }
    url.search = searchParams.toString();
    return url;
  }
  var Snapshot = class {
    constructor(element) {
      this.element = element;
    }
    get activeElement() {
      return this.element.ownerDocument.activeElement;
    }
    get children() {
      return [...this.element.children];
    }
    hasAnchor(anchor) {
      return this.getElementForAnchor(anchor) != null;
    }
    getElementForAnchor(anchor) {
      return anchor ? this.element.querySelector(`[id='${anchor}'], a[name='${anchor}']`) : null;
    }
    get isConnected() {
      return this.element.isConnected;
    }
    get firstAutofocusableElement() {
      const inertDisabledOrHidden = "[inert], :disabled, [hidden], details:not([open]), dialog:not([open])";
      for (const element of this.element.querySelectorAll("[autofocus]")) {
        if (element.closest(inertDisabledOrHidden) == null)
          return element;
        else
          continue;
      }
      return null;
    }
    get permanentElements() {
      return queryPermanentElementsAll(this.element);
    }
    getPermanentElementById(id) {
      return getPermanentElementById(this.element, id);
    }
    getPermanentElementMapForSnapshot(snapshot) {
      const permanentElementMap = {};
      for (const currentPermanentElement of this.permanentElements) {
        const { id } = currentPermanentElement;
        const newPermanentElement = snapshot.getPermanentElementById(id);
        if (newPermanentElement) {
          permanentElementMap[id] = [currentPermanentElement, newPermanentElement];
        }
      }
      return permanentElementMap;
    }
  };
  function getPermanentElementById(node, id) {
    return node.querySelector(`#${id}[data-turbo-permanent]`);
  }
  function queryPermanentElementsAll(node) {
    return node.querySelectorAll("[id][data-turbo-permanent]");
  }
  var FormSubmitObserver = class {
    constructor(delegate, eventTarget) {
      this.started = false;
      this.submitCaptured = () => {
        this.eventTarget.removeEventListener("submit", this.submitBubbled, false);
        this.eventTarget.addEventListener("submit", this.submitBubbled, false);
      };
      this.submitBubbled = (event) => {
        if (!event.defaultPrevented) {
          const form = event.target instanceof HTMLFormElement ? event.target : void 0;
          const submitter = event.submitter || void 0;
          if (form && submissionDoesNotDismissDialog(form, submitter) && submissionDoesNotTargetIFrame(form, submitter) && this.delegate.willSubmitForm(form, submitter)) {
            event.preventDefault();
            event.stopImmediatePropagation();
            this.delegate.formSubmitted(form, submitter);
          }
        }
      };
      this.delegate = delegate;
      this.eventTarget = eventTarget;
    }
    start() {
      if (!this.started) {
        this.eventTarget.addEventListener("submit", this.submitCaptured, true);
        this.started = true;
      }
    }
    stop() {
      if (this.started) {
        this.eventTarget.removeEventListener("submit", this.submitCaptured, true);
        this.started = false;
      }
    }
  };
  function submissionDoesNotDismissDialog(form, submitter) {
    const method = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("formmethod")) || form.getAttribute("method");
    return method != "dialog";
  }
  function submissionDoesNotTargetIFrame(form, submitter) {
    if ((submitter === null || submitter === void 0 ? void 0 : submitter.hasAttribute("formtarget")) || form.hasAttribute("target")) {
      const target = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("formtarget")) || form.target;
      for (const element of document.getElementsByName(target)) {
        if (element instanceof HTMLIFrameElement)
          return false;
      }
      return true;
    } else {
      return true;
    }
  }
  var View = class {
    constructor(delegate, element) {
      this.resolveRenderPromise = (_value) => {
      };
      this.resolveInterceptionPromise = (_value) => {
      };
      this.delegate = delegate;
      this.element = element;
    }
    scrollToAnchor(anchor) {
      const element = this.snapshot.getElementForAnchor(anchor);
      if (element) {
        this.scrollToElement(element);
        this.focusElement(element);
      } else {
        this.scrollToPosition({ x: 0, y: 0 });
      }
    }
    scrollToAnchorFromLocation(location2) {
      this.scrollToAnchor(getAnchor(location2));
    }
    scrollToElement(element) {
      element.scrollIntoView();
    }
    focusElement(element) {
      if (element instanceof HTMLElement) {
        if (element.hasAttribute("tabindex")) {
          element.focus();
        } else {
          element.setAttribute("tabindex", "-1");
          element.focus();
          element.removeAttribute("tabindex");
        }
      }
    }
    scrollToPosition({ x, y }) {
      this.scrollRoot.scrollTo(x, y);
    }
    scrollToTop() {
      this.scrollToPosition({ x: 0, y: 0 });
    }
    get scrollRoot() {
      return window;
    }
    async render(renderer) {
      const { isPreview, shouldRender, newSnapshot: snapshot } = renderer;
      if (shouldRender) {
        try {
          this.renderPromise = new Promise((resolve) => this.resolveRenderPromise = resolve);
          this.renderer = renderer;
          await this.prepareToRenderSnapshot(renderer);
          const renderInterception = new Promise((resolve) => this.resolveInterceptionPromise = resolve);
          const options = { resume: this.resolveInterceptionPromise, render: this.renderer.renderElement };
          const immediateRender = this.delegate.allowsImmediateRender(snapshot, options);
          if (!immediateRender)
            await renderInterception;
          await this.renderSnapshot(renderer);
          this.delegate.viewRenderedSnapshot(snapshot, isPreview);
          this.delegate.preloadOnLoadLinksForView(this.element);
          this.finishRenderingSnapshot(renderer);
        } finally {
          delete this.renderer;
          this.resolveRenderPromise(void 0);
          delete this.renderPromise;
        }
      } else {
        this.invalidate(renderer.reloadReason);
      }
    }
    invalidate(reason) {
      this.delegate.viewInvalidated(reason);
    }
    async prepareToRenderSnapshot(renderer) {
      this.markAsPreview(renderer.isPreview);
      await renderer.prepareToRender();
    }
    markAsPreview(isPreview) {
      if (isPreview) {
        this.element.setAttribute("data-turbo-preview", "");
      } else {
        this.element.removeAttribute("data-turbo-preview");
      }
    }
    async renderSnapshot(renderer) {
      await renderer.render();
    }
    finishRenderingSnapshot(renderer) {
      renderer.finishRendering();
    }
  };
  var FrameView = class extends View {
    missing() {
      this.element.innerHTML = `<strong class="turbo-frame-error">Content missing</strong>`;
    }
    get snapshot() {
      return new Snapshot(this.element);
    }
  };
  var LinkInterceptor = class {
    constructor(delegate, element) {
      this.clickBubbled = (event) => {
        if (this.respondsToEventTarget(event.target)) {
          this.clickEvent = event;
        } else {
          delete this.clickEvent;
        }
      };
      this.linkClicked = (event) => {
        if (this.clickEvent && this.respondsToEventTarget(event.target) && event.target instanceof Element) {
          if (this.delegate.shouldInterceptLinkClick(event.target, event.detail.url, event.detail.originalEvent)) {
            this.clickEvent.preventDefault();
            event.preventDefault();
            this.delegate.linkClickIntercepted(event.target, event.detail.url, event.detail.originalEvent);
          }
        }
        delete this.clickEvent;
      };
      this.willVisit = (_event) => {
        delete this.clickEvent;
      };
      this.delegate = delegate;
      this.element = element;
    }
    start() {
      this.element.addEventListener("click", this.clickBubbled);
      document.addEventListener("turbo:click", this.linkClicked);
      document.addEventListener("turbo:before-visit", this.willVisit);
    }
    stop() {
      this.element.removeEventListener("click", this.clickBubbled);
      document.removeEventListener("turbo:click", this.linkClicked);
      document.removeEventListener("turbo:before-visit", this.willVisit);
    }
    respondsToEventTarget(target) {
      const element = target instanceof Element ? target : target instanceof Node ? target.parentElement : null;
      return element && element.closest("turbo-frame, html") == this.element;
    }
  };
  var LinkClickObserver = class {
    constructor(delegate, eventTarget) {
      this.started = false;
      this.clickCaptured = () => {
        this.eventTarget.removeEventListener("click", this.clickBubbled, false);
        this.eventTarget.addEventListener("click", this.clickBubbled, false);
      };
      this.clickBubbled = (event) => {
        if (event instanceof MouseEvent && this.clickEventIsSignificant(event)) {
          const target = event.composedPath && event.composedPath()[0] || event.target;
          const link = this.findLinkFromClickTarget(target);
          if (link && doesNotTargetIFrame(link)) {
            const location2 = this.getLocationForLink(link);
            if (this.delegate.willFollowLinkToLocation(link, location2, event)) {
              event.preventDefault();
              this.delegate.followedLinkToLocation(link, location2);
            }
          }
        }
      };
      this.delegate = delegate;
      this.eventTarget = eventTarget;
    }
    start() {
      if (!this.started) {
        this.eventTarget.addEventListener("click", this.clickCaptured, true);
        this.started = true;
      }
    }
    stop() {
      if (this.started) {
        this.eventTarget.removeEventListener("click", this.clickCaptured, true);
        this.started = false;
      }
    }
    clickEventIsSignificant(event) {
      return !(event.target && event.target.isContentEditable || event.defaultPrevented || event.which > 1 || event.altKey || event.ctrlKey || event.metaKey || event.shiftKey);
    }
    findLinkFromClickTarget(target) {
      return findClosestRecursively(target, "a[href]:not([target^=_]):not([download])");
    }
    getLocationForLink(link) {
      return expandURL(link.getAttribute("href") || "");
    }
  };
  function doesNotTargetIFrame(anchor) {
    if (anchor.hasAttribute("target")) {
      for (const element of document.getElementsByName(anchor.target)) {
        if (element instanceof HTMLIFrameElement)
          return false;
      }
      return true;
    } else {
      return true;
    }
  }
  var FormLinkClickObserver = class {
    constructor(delegate, element) {
      this.delegate = delegate;
      this.linkInterceptor = new LinkClickObserver(this, element);
    }
    start() {
      this.linkInterceptor.start();
    }
    stop() {
      this.linkInterceptor.stop();
    }
    willFollowLinkToLocation(link, location2, originalEvent) {
      return this.delegate.willSubmitFormLinkToLocation(link, location2, originalEvent) && link.hasAttribute("data-turbo-method");
    }
    followedLinkToLocation(link, location2) {
      const form = document.createElement("form");
      const type = "hidden";
      for (const [name, value] of location2.searchParams) {
        form.append(Object.assign(document.createElement("input"), { type, name, value }));
      }
      const action = Object.assign(location2, { search: "" });
      form.setAttribute("data-turbo", "true");
      form.setAttribute("action", action.href);
      form.setAttribute("hidden", "");
      const method = link.getAttribute("data-turbo-method");
      if (method)
        form.setAttribute("method", method);
      const turboFrame = link.getAttribute("data-turbo-frame");
      if (turboFrame)
        form.setAttribute("data-turbo-frame", turboFrame);
      const turboAction = getVisitAction(link);
      if (turboAction)
        form.setAttribute("data-turbo-action", turboAction);
      const turboConfirm = link.getAttribute("data-turbo-confirm");
      if (turboConfirm)
        form.setAttribute("data-turbo-confirm", turboConfirm);
      const turboStream = link.hasAttribute("data-turbo-stream");
      if (turboStream)
        form.setAttribute("data-turbo-stream", "");
      this.delegate.submittedFormLinkToLocation(link, location2, form);
      document.body.appendChild(form);
      form.addEventListener("turbo:submit-end", () => form.remove(), { once: true });
      requestAnimationFrame(() => form.requestSubmit());
    }
  };
  var Bardo = class {
    static async preservingPermanentElements(delegate, permanentElementMap, callback) {
      const bardo = new this(delegate, permanentElementMap);
      bardo.enter();
      await callback();
      bardo.leave();
    }
    constructor(delegate, permanentElementMap) {
      this.delegate = delegate;
      this.permanentElementMap = permanentElementMap;
    }
    enter() {
      for (const id in this.permanentElementMap) {
        const [currentPermanentElement, newPermanentElement] = this.permanentElementMap[id];
        this.delegate.enteringBardo(currentPermanentElement, newPermanentElement);
        this.replaceNewPermanentElementWithPlaceholder(newPermanentElement);
      }
    }
    leave() {
      for (const id in this.permanentElementMap) {
        const [currentPermanentElement] = this.permanentElementMap[id];
        this.replaceCurrentPermanentElementWithClone(currentPermanentElement);
        this.replacePlaceholderWithPermanentElement(currentPermanentElement);
        this.delegate.leavingBardo(currentPermanentElement);
      }
    }
    replaceNewPermanentElementWithPlaceholder(permanentElement) {
      const placeholder = createPlaceholderForPermanentElement(permanentElement);
      permanentElement.replaceWith(placeholder);
    }
    replaceCurrentPermanentElementWithClone(permanentElement) {
      const clone = permanentElement.cloneNode(true);
      permanentElement.replaceWith(clone);
    }
    replacePlaceholderWithPermanentElement(permanentElement) {
      const placeholder = this.getPlaceholderById(permanentElement.id);
      placeholder === null || placeholder === void 0 ? void 0 : placeholder.replaceWith(permanentElement);
    }
    getPlaceholderById(id) {
      return this.placeholders.find((element) => element.content == id);
    }
    get placeholders() {
      return [...document.querySelectorAll("meta[name=turbo-permanent-placeholder][content]")];
    }
  };
  function createPlaceholderForPermanentElement(permanentElement) {
    const element = document.createElement("meta");
    element.setAttribute("name", "turbo-permanent-placeholder");
    element.setAttribute("content", permanentElement.id);
    return element;
  }
  var Renderer = class {
    constructor(currentSnapshot, newSnapshot, renderElement, isPreview, willRender = true) {
      this.activeElement = null;
      this.currentSnapshot = currentSnapshot;
      this.newSnapshot = newSnapshot;
      this.isPreview = isPreview;
      this.willRender = willRender;
      this.renderElement = renderElement;
      this.promise = new Promise((resolve, reject) => this.resolvingFunctions = { resolve, reject });
    }
    get shouldRender() {
      return true;
    }
    get reloadReason() {
      return;
    }
    prepareToRender() {
      return;
    }
    finishRendering() {
      if (this.resolvingFunctions) {
        this.resolvingFunctions.resolve();
        delete this.resolvingFunctions;
      }
    }
    async preservingPermanentElements(callback) {
      await Bardo.preservingPermanentElements(this, this.permanentElementMap, callback);
    }
    focusFirstAutofocusableElement() {
      const element = this.connectedSnapshot.firstAutofocusableElement;
      if (elementIsFocusable(element)) {
        element.focus();
      }
    }
    enteringBardo(currentPermanentElement) {
      if (this.activeElement)
        return;
      if (currentPermanentElement.contains(this.currentSnapshot.activeElement)) {
        this.activeElement = this.currentSnapshot.activeElement;
      }
    }
    leavingBardo(currentPermanentElement) {
      if (currentPermanentElement.contains(this.activeElement) && this.activeElement instanceof HTMLElement) {
        this.activeElement.focus();
        this.activeElement = null;
      }
    }
    get connectedSnapshot() {
      return this.newSnapshot.isConnected ? this.newSnapshot : this.currentSnapshot;
    }
    get currentElement() {
      return this.currentSnapshot.element;
    }
    get newElement() {
      return this.newSnapshot.element;
    }
    get permanentElementMap() {
      return this.currentSnapshot.getPermanentElementMapForSnapshot(this.newSnapshot);
    }
  };
  function elementIsFocusable(element) {
    return element && typeof element.focus == "function";
  }
  var FrameRenderer = class extends Renderer {
    static renderElement(currentElement, newElement) {
      var _a;
      const destinationRange = document.createRange();
      destinationRange.selectNodeContents(currentElement);
      destinationRange.deleteContents();
      const frameElement = newElement;
      const sourceRange = (_a = frameElement.ownerDocument) === null || _a === void 0 ? void 0 : _a.createRange();
      if (sourceRange) {
        sourceRange.selectNodeContents(frameElement);
        currentElement.appendChild(sourceRange.extractContents());
      }
    }
    constructor(delegate, currentSnapshot, newSnapshot, renderElement, isPreview, willRender = true) {
      super(currentSnapshot, newSnapshot, renderElement, isPreview, willRender);
      this.delegate = delegate;
    }
    get shouldRender() {
      return true;
    }
    async render() {
      await nextAnimationFrame();
      this.preservingPermanentElements(() => {
        this.loadFrameElement();
      });
      this.scrollFrameIntoView();
      await nextAnimationFrame();
      this.focusFirstAutofocusableElement();
      await nextAnimationFrame();
      this.activateScriptElements();
    }
    loadFrameElement() {
      this.delegate.willRenderFrame(this.currentElement, this.newElement);
      this.renderElement(this.currentElement, this.newElement);
    }
    scrollFrameIntoView() {
      if (this.currentElement.autoscroll || this.newElement.autoscroll) {
        const element = this.currentElement.firstElementChild;
        const block = readScrollLogicalPosition(this.currentElement.getAttribute("data-autoscroll-block"), "end");
        const behavior = readScrollBehavior(this.currentElement.getAttribute("data-autoscroll-behavior"), "auto");
        if (element) {
          element.scrollIntoView({ block, behavior });
          return true;
        }
      }
      return false;
    }
    activateScriptElements() {
      for (const inertScriptElement of this.newScriptElements) {
        const activatedScriptElement = activateScriptElement(inertScriptElement);
        inertScriptElement.replaceWith(activatedScriptElement);
      }
    }
    get newScriptElements() {
      return this.currentElement.querySelectorAll("script");
    }
  };
  function readScrollLogicalPosition(value, defaultValue) {
    if (value == "end" || value == "start" || value == "center" || value == "nearest") {
      return value;
    } else {
      return defaultValue;
    }
  }
  function readScrollBehavior(value, defaultValue) {
    if (value == "auto" || value == "smooth") {
      return value;
    } else {
      return defaultValue;
    }
  }
  var ProgressBar = class _ProgressBar {
    static get defaultCSS() {
      return unindent`
      .turbo-progress-bar {
        position: fixed;
        display: block;
        top: 0;
        left: 0;
        height: 3px;
        background: #0076ff;
        z-index: 2147483647;
        transition:
          width ${_ProgressBar.animationDuration}ms ease-out,
          opacity ${_ProgressBar.animationDuration / 2}ms ${_ProgressBar.animationDuration / 2}ms ease-in;
        transform: translate3d(0, 0, 0);
      }
    `;
    }
    constructor() {
      this.hiding = false;
      this.value = 0;
      this.visible = false;
      this.trickle = () => {
        this.setValue(this.value + Math.random() / 100);
      };
      this.stylesheetElement = this.createStylesheetElement();
      this.progressElement = this.createProgressElement();
      this.installStylesheetElement();
      this.setValue(0);
    }
    show() {
      if (!this.visible) {
        this.visible = true;
        this.installProgressElement();
        this.startTrickling();
      }
    }
    hide() {
      if (this.visible && !this.hiding) {
        this.hiding = true;
        this.fadeProgressElement(() => {
          this.uninstallProgressElement();
          this.stopTrickling();
          this.visible = false;
          this.hiding = false;
        });
      }
    }
    setValue(value) {
      this.value = value;
      this.refresh();
    }
    installStylesheetElement() {
      document.head.insertBefore(this.stylesheetElement, document.head.firstChild);
    }
    installProgressElement() {
      this.progressElement.style.width = "0";
      this.progressElement.style.opacity = "1";
      document.documentElement.insertBefore(this.progressElement, document.body);
      this.refresh();
    }
    fadeProgressElement(callback) {
      this.progressElement.style.opacity = "0";
      setTimeout(callback, _ProgressBar.animationDuration * 1.5);
    }
    uninstallProgressElement() {
      if (this.progressElement.parentNode) {
        document.documentElement.removeChild(this.progressElement);
      }
    }
    startTrickling() {
      if (!this.trickleInterval) {
        this.trickleInterval = window.setInterval(this.trickle, _ProgressBar.animationDuration);
      }
    }
    stopTrickling() {
      window.clearInterval(this.trickleInterval);
      delete this.trickleInterval;
    }
    refresh() {
      requestAnimationFrame(() => {
        this.progressElement.style.width = `${10 + this.value * 90}%`;
      });
    }
    createStylesheetElement() {
      const element = document.createElement("style");
      element.type = "text/css";
      element.textContent = _ProgressBar.defaultCSS;
      if (this.cspNonce) {
        element.nonce = this.cspNonce;
      }
      return element;
    }
    createProgressElement() {
      const element = document.createElement("div");
      element.className = "turbo-progress-bar";
      return element;
    }
    get cspNonce() {
      return getMetaContent("csp-nonce");
    }
  };
  ProgressBar.animationDuration = 300;
  var HeadSnapshot = class extends Snapshot {
    constructor() {
      super(...arguments);
      this.detailsByOuterHTML = this.children.filter((element) => !elementIsNoscript(element)).map((element) => elementWithoutNonce(element)).reduce((result, element) => {
        const { outerHTML } = element;
        const details = outerHTML in result ? result[outerHTML] : {
          type: elementType(element),
          tracked: elementIsTracked(element),
          elements: []
        };
        return Object.assign(Object.assign({}, result), { [outerHTML]: Object.assign(Object.assign({}, details), { elements: [...details.elements, element] }) });
      }, {});
    }
    get trackedElementSignature() {
      return Object.keys(this.detailsByOuterHTML).filter((outerHTML) => this.detailsByOuterHTML[outerHTML].tracked).join("");
    }
    getScriptElementsNotInSnapshot(snapshot) {
      return this.getElementsMatchingTypeNotInSnapshot("script", snapshot);
    }
    getStylesheetElementsNotInSnapshot(snapshot) {
      return this.getElementsMatchingTypeNotInSnapshot("stylesheet", snapshot);
    }
    getElementsMatchingTypeNotInSnapshot(matchedType, snapshot) {
      return Object.keys(this.detailsByOuterHTML).filter((outerHTML) => !(outerHTML in snapshot.detailsByOuterHTML)).map((outerHTML) => this.detailsByOuterHTML[outerHTML]).filter(({ type }) => type == matchedType).map(({ elements: [element] }) => element);
    }
    get provisionalElements() {
      return Object.keys(this.detailsByOuterHTML).reduce((result, outerHTML) => {
        const { type, tracked, elements } = this.detailsByOuterHTML[outerHTML];
        if (type == null && !tracked) {
          return [...result, ...elements];
        } else if (elements.length > 1) {
          return [...result, ...elements.slice(1)];
        } else {
          return result;
        }
      }, []);
    }
    getMetaValue(name) {
      const element = this.findMetaElementByName(name);
      return element ? element.getAttribute("content") : null;
    }
    findMetaElementByName(name) {
      return Object.keys(this.detailsByOuterHTML).reduce((result, outerHTML) => {
        const { elements: [element] } = this.detailsByOuterHTML[outerHTML];
        return elementIsMetaElementWithName(element, name) ? element : result;
      }, void 0);
    }
  };
  function elementType(element) {
    if (elementIsScript(element)) {
      return "script";
    } else if (elementIsStylesheet(element)) {
      return "stylesheet";
    }
  }
  function elementIsTracked(element) {
    return element.getAttribute("data-turbo-track") == "reload";
  }
  function elementIsScript(element) {
    const tagName = element.localName;
    return tagName == "script";
  }
  function elementIsNoscript(element) {
    const tagName = element.localName;
    return tagName == "noscript";
  }
  function elementIsStylesheet(element) {
    const tagName = element.localName;
    return tagName == "style" || tagName == "link" && element.getAttribute("rel") == "stylesheet";
  }
  function elementIsMetaElementWithName(element, name) {
    const tagName = element.localName;
    return tagName == "meta" && element.getAttribute("name") == name;
  }
  function elementWithoutNonce(element) {
    if (element.hasAttribute("nonce")) {
      element.setAttribute("nonce", "");
    }
    return element;
  }
  var PageSnapshot = class _PageSnapshot extends Snapshot {
    static fromHTMLString(html = "") {
      return this.fromDocument(parseHTMLDocument(html));
    }
    static fromElement(element) {
      return this.fromDocument(element.ownerDocument);
    }
    static fromDocument({ head, body }) {
      return new this(body, new HeadSnapshot(head));
    }
    constructor(element, headSnapshot) {
      super(element);
      this.headSnapshot = headSnapshot;
    }
    clone() {
      const clonedElement = this.element.cloneNode(true);
      const selectElements = this.element.querySelectorAll("select");
      const clonedSelectElements = clonedElement.querySelectorAll("select");
      for (const [index, source] of selectElements.entries()) {
        const clone = clonedSelectElements[index];
        for (const option of clone.selectedOptions)
          option.selected = false;
        for (const option of source.selectedOptions)
          clone.options[option.index].selected = true;
      }
      for (const clonedPasswordInput of clonedElement.querySelectorAll('input[type="password"]')) {
        clonedPasswordInput.value = "";
      }
      return new _PageSnapshot(clonedElement, this.headSnapshot);
    }
    get headElement() {
      return this.headSnapshot.element;
    }
    get rootLocation() {
      var _a;
      const root = (_a = this.getSetting("root")) !== null && _a !== void 0 ? _a : "/";
      return expandURL(root);
    }
    get cacheControlValue() {
      return this.getSetting("cache-control");
    }
    get isPreviewable() {
      return this.cacheControlValue != "no-preview";
    }
    get isCacheable() {
      return this.cacheControlValue != "no-cache";
    }
    get isVisitable() {
      return this.getSetting("visit-control") != "reload";
    }
    getSetting(name) {
      return this.headSnapshot.getMetaValue(`turbo-${name}`);
    }
  };
  var TimingMetric;
  (function(TimingMetric2) {
    TimingMetric2["visitStart"] = "visitStart";
    TimingMetric2["requestStart"] = "requestStart";
    TimingMetric2["requestEnd"] = "requestEnd";
    TimingMetric2["visitEnd"] = "visitEnd";
  })(TimingMetric || (TimingMetric = {}));
  var VisitState;
  (function(VisitState2) {
    VisitState2["initialized"] = "initialized";
    VisitState2["started"] = "started";
    VisitState2["canceled"] = "canceled";
    VisitState2["failed"] = "failed";
    VisitState2["completed"] = "completed";
  })(VisitState || (VisitState = {}));
  var defaultOptions = {
    action: "advance",
    historyChanged: false,
    visitCachedSnapshot: () => {
    },
    willRender: true,
    updateHistory: true,
    shouldCacheSnapshot: true,
    acceptsStreamResponse: false
  };
  var SystemStatusCode;
  (function(SystemStatusCode2) {
    SystemStatusCode2[SystemStatusCode2["networkFailure"] = 0] = "networkFailure";
    SystemStatusCode2[SystemStatusCode2["timeoutFailure"] = -1] = "timeoutFailure";
    SystemStatusCode2[SystemStatusCode2["contentTypeMismatch"] = -2] = "contentTypeMismatch";
  })(SystemStatusCode || (SystemStatusCode = {}));
  var Visit = class {
    constructor(delegate, location2, restorationIdentifier, options = {}) {
      this.identifier = uuid();
      this.timingMetrics = {};
      this.followedRedirect = false;
      this.historyChanged = false;
      this.scrolled = false;
      this.shouldCacheSnapshot = true;
      this.acceptsStreamResponse = false;
      this.snapshotCached = false;
      this.state = VisitState.initialized;
      this.delegate = delegate;
      this.location = location2;
      this.restorationIdentifier = restorationIdentifier || uuid();
      const { action, historyChanged, referrer, snapshot, snapshotHTML, response, visitCachedSnapshot, willRender, updateHistory, shouldCacheSnapshot, acceptsStreamResponse } = Object.assign(Object.assign({}, defaultOptions), options);
      this.action = action;
      this.historyChanged = historyChanged;
      this.referrer = referrer;
      this.snapshot = snapshot;
      this.snapshotHTML = snapshotHTML;
      this.response = response;
      this.isSamePage = this.delegate.locationWithActionIsSamePage(this.location, this.action);
      this.visitCachedSnapshot = visitCachedSnapshot;
      this.willRender = willRender;
      this.updateHistory = updateHistory;
      this.scrolled = !willRender;
      this.shouldCacheSnapshot = shouldCacheSnapshot;
      this.acceptsStreamResponse = acceptsStreamResponse;
    }
    get adapter() {
      return this.delegate.adapter;
    }
    get view() {
      return this.delegate.view;
    }
    get history() {
      return this.delegate.history;
    }
    get restorationData() {
      return this.history.getRestorationDataForIdentifier(this.restorationIdentifier);
    }
    get silent() {
      return this.isSamePage;
    }
    start() {
      if (this.state == VisitState.initialized) {
        this.recordTimingMetric(TimingMetric.visitStart);
        this.state = VisitState.started;
        this.adapter.visitStarted(this);
        this.delegate.visitStarted(this);
      }
    }
    cancel() {
      if (this.state == VisitState.started) {
        if (this.request) {
          this.request.cancel();
        }
        this.cancelRender();
        this.state = VisitState.canceled;
      }
    }
    complete() {
      if (this.state == VisitState.started) {
        this.recordTimingMetric(TimingMetric.visitEnd);
        this.state = VisitState.completed;
        this.followRedirect();
        if (!this.followedRedirect) {
          this.adapter.visitCompleted(this);
          this.delegate.visitCompleted(this);
        }
      }
    }
    fail() {
      if (this.state == VisitState.started) {
        this.state = VisitState.failed;
        this.adapter.visitFailed(this);
      }
    }
    changeHistory() {
      var _a;
      if (!this.historyChanged && this.updateHistory) {
        const actionForHistory = this.location.href === ((_a = this.referrer) === null || _a === void 0 ? void 0 : _a.href) ? "replace" : this.action;
        const method = getHistoryMethodForAction(actionForHistory);
        this.history.update(method, this.location, this.restorationIdentifier);
        this.historyChanged = true;
      }
    }
    issueRequest() {
      if (this.hasPreloadedResponse()) {
        this.simulateRequest();
      } else if (this.shouldIssueRequest() && !this.request) {
        this.request = new FetchRequest(this, FetchMethod.get, this.location);
        this.request.perform();
      }
    }
    simulateRequest() {
      if (this.response) {
        this.startRequest();
        this.recordResponse();
        this.finishRequest();
      }
    }
    startRequest() {
      this.recordTimingMetric(TimingMetric.requestStart);
      this.adapter.visitRequestStarted(this);
    }
    recordResponse(response = this.response) {
      this.response = response;
      if (response) {
        const { statusCode } = response;
        if (isSuccessful(statusCode)) {
          this.adapter.visitRequestCompleted(this);
        } else {
          this.adapter.visitRequestFailedWithStatusCode(this, statusCode);
        }
      }
    }
    finishRequest() {
      this.recordTimingMetric(TimingMetric.requestEnd);
      this.adapter.visitRequestFinished(this);
    }
    loadResponse() {
      if (this.response) {
        const { statusCode, responseHTML } = this.response;
        this.render(async () => {
          if (this.shouldCacheSnapshot)
            this.cacheSnapshot();
          if (this.view.renderPromise)
            await this.view.renderPromise;
          if (isSuccessful(statusCode) && responseHTML != null) {
            await this.view.renderPage(PageSnapshot.fromHTMLString(responseHTML), false, this.willRender, this);
            this.performScroll();
            this.adapter.visitRendered(this);
            this.complete();
          } else {
            await this.view.renderError(PageSnapshot.fromHTMLString(responseHTML), this);
            this.adapter.visitRendered(this);
            this.fail();
          }
        });
      }
    }
    getCachedSnapshot() {
      const snapshot = this.view.getCachedSnapshotForLocation(this.location) || this.getPreloadedSnapshot();
      if (snapshot && (!getAnchor(this.location) || snapshot.hasAnchor(getAnchor(this.location)))) {
        if (this.action == "restore" || snapshot.isPreviewable) {
          return snapshot;
        }
      }
    }
    getPreloadedSnapshot() {
      if (this.snapshotHTML) {
        return PageSnapshot.fromHTMLString(this.snapshotHTML);
      }
    }
    hasCachedSnapshot() {
      return this.getCachedSnapshot() != null;
    }
    loadCachedSnapshot() {
      const snapshot = this.getCachedSnapshot();
      if (snapshot) {
        const isPreview = this.shouldIssueRequest();
        this.render(async () => {
          this.cacheSnapshot();
          if (this.isSamePage) {
            this.adapter.visitRendered(this);
          } else {
            if (this.view.renderPromise)
              await this.view.renderPromise;
            await this.view.renderPage(snapshot, isPreview, this.willRender, this);
            this.performScroll();
            this.adapter.visitRendered(this);
            if (!isPreview) {
              this.complete();
            }
          }
        });
      }
    }
    followRedirect() {
      var _a;
      if (this.redirectedToLocation && !this.followedRedirect && ((_a = this.response) === null || _a === void 0 ? void 0 : _a.redirected)) {
        this.adapter.visitProposedToLocation(this.redirectedToLocation, {
          action: "replace",
          response: this.response,
          shouldCacheSnapshot: false,
          willRender: false
        });
        this.followedRedirect = true;
      }
    }
    goToSamePageAnchor() {
      if (this.isSamePage) {
        this.render(async () => {
          this.cacheSnapshot();
          this.performScroll();
          this.changeHistory();
          this.adapter.visitRendered(this);
        });
      }
    }
    prepareRequest(request) {
      if (this.acceptsStreamResponse) {
        request.acceptResponseType(StreamMessage.contentType);
      }
    }
    requestStarted() {
      this.startRequest();
    }
    requestPreventedHandlingResponse(_request, _response) {
    }
    async requestSucceededWithResponse(request, response) {
      const responseHTML = await response.responseHTML;
      const { redirected, statusCode } = response;
      if (responseHTML == void 0) {
        this.recordResponse({
          statusCode: SystemStatusCode.contentTypeMismatch,
          redirected
        });
      } else {
        this.redirectedToLocation = response.redirected ? response.location : void 0;
        this.recordResponse({ statusCode, responseHTML, redirected });
      }
    }
    async requestFailedWithResponse(request, response) {
      const responseHTML = await response.responseHTML;
      const { redirected, statusCode } = response;
      if (responseHTML == void 0) {
        this.recordResponse({
          statusCode: SystemStatusCode.contentTypeMismatch,
          redirected
        });
      } else {
        this.recordResponse({ statusCode, responseHTML, redirected });
      }
    }
    requestErrored(_request, _error) {
      this.recordResponse({
        statusCode: SystemStatusCode.networkFailure,
        redirected: false
      });
    }
    requestFinished() {
      this.finishRequest();
    }
    performScroll() {
      if (!this.scrolled && !this.view.forceReloaded) {
        if (this.action == "restore") {
          this.scrollToRestoredPosition() || this.scrollToAnchor() || this.view.scrollToTop();
        } else {
          this.scrollToAnchor() || this.view.scrollToTop();
        }
        if (this.isSamePage) {
          this.delegate.visitScrolledToSamePageLocation(this.view.lastRenderedLocation, this.location);
        }
        this.scrolled = true;
      }
    }
    scrollToRestoredPosition() {
      const { scrollPosition } = this.restorationData;
      if (scrollPosition) {
        this.view.scrollToPosition(scrollPosition);
        return true;
      }
    }
    scrollToAnchor() {
      const anchor = getAnchor(this.location);
      if (anchor != null) {
        this.view.scrollToAnchor(anchor);
        return true;
      }
    }
    recordTimingMetric(metric) {
      this.timingMetrics[metric] = (/* @__PURE__ */ new Date()).getTime();
    }
    getTimingMetrics() {
      return Object.assign({}, this.timingMetrics);
    }
    getHistoryMethodForAction(action) {
      switch (action) {
        case "replace":
          return history.replaceState;
        case "advance":
        case "restore":
          return history.pushState;
      }
    }
    hasPreloadedResponse() {
      return typeof this.response == "object";
    }
    shouldIssueRequest() {
      if (this.isSamePage) {
        return false;
      } else if (this.action == "restore") {
        return !this.hasCachedSnapshot();
      } else {
        return this.willRender;
      }
    }
    cacheSnapshot() {
      if (!this.snapshotCached) {
        this.view.cacheSnapshot(this.snapshot).then((snapshot) => snapshot && this.visitCachedSnapshot(snapshot));
        this.snapshotCached = true;
      }
    }
    async render(callback) {
      this.cancelRender();
      await new Promise((resolve) => {
        this.frame = requestAnimationFrame(() => resolve());
      });
      await callback();
      delete this.frame;
    }
    cancelRender() {
      if (this.frame) {
        cancelAnimationFrame(this.frame);
        delete this.frame;
      }
    }
  };
  function isSuccessful(statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }
  var BrowserAdapter = class {
    constructor(session2) {
      this.progressBar = new ProgressBar();
      this.showProgressBar = () => {
        this.progressBar.show();
      };
      this.session = session2;
    }
    visitProposedToLocation(location2, options) {
      this.navigator.startVisit(location2, (options === null || options === void 0 ? void 0 : options.restorationIdentifier) || uuid(), options);
    }
    visitStarted(visit2) {
      this.location = visit2.location;
      visit2.loadCachedSnapshot();
      visit2.issueRequest();
      visit2.goToSamePageAnchor();
    }
    visitRequestStarted(visit2) {
      this.progressBar.setValue(0);
      if (visit2.hasCachedSnapshot() || visit2.action != "restore") {
        this.showVisitProgressBarAfterDelay();
      } else {
        this.showProgressBar();
      }
    }
    visitRequestCompleted(visit2) {
      visit2.loadResponse();
    }
    visitRequestFailedWithStatusCode(visit2, statusCode) {
      switch (statusCode) {
        case SystemStatusCode.networkFailure:
        case SystemStatusCode.timeoutFailure:
        case SystemStatusCode.contentTypeMismatch:
          return this.reload({
            reason: "request_failed",
            context: {
              statusCode
            }
          });
        default:
          return visit2.loadResponse();
      }
    }
    visitRequestFinished(_visit) {
      this.progressBar.setValue(1);
      this.hideVisitProgressBar();
    }
    visitCompleted(_visit) {
    }
    pageInvalidated(reason) {
      this.reload(reason);
    }
    visitFailed(_visit) {
    }
    visitRendered(_visit) {
    }
    formSubmissionStarted(_formSubmission) {
      this.progressBar.setValue(0);
      this.showFormProgressBarAfterDelay();
    }
    formSubmissionFinished(_formSubmission) {
      this.progressBar.setValue(1);
      this.hideFormProgressBar();
    }
    showVisitProgressBarAfterDelay() {
      this.visitProgressBarTimeout = window.setTimeout(this.showProgressBar, this.session.progressBarDelay);
    }
    hideVisitProgressBar() {
      this.progressBar.hide();
      if (this.visitProgressBarTimeout != null) {
        window.clearTimeout(this.visitProgressBarTimeout);
        delete this.visitProgressBarTimeout;
      }
    }
    showFormProgressBarAfterDelay() {
      if (this.formProgressBarTimeout == null) {
        this.formProgressBarTimeout = window.setTimeout(this.showProgressBar, this.session.progressBarDelay);
      }
    }
    hideFormProgressBar() {
      this.progressBar.hide();
      if (this.formProgressBarTimeout != null) {
        window.clearTimeout(this.formProgressBarTimeout);
        delete this.formProgressBarTimeout;
      }
    }
    reload(reason) {
      var _a;
      dispatch("turbo:reload", { detail: reason });
      window.location.href = ((_a = this.location) === null || _a === void 0 ? void 0 : _a.toString()) || window.location.href;
    }
    get navigator() {
      return this.session.navigator;
    }
  };
  var CacheObserver = class {
    constructor() {
      this.selector = "[data-turbo-temporary]";
      this.deprecatedSelector = "[data-turbo-cache=false]";
      this.started = false;
      this.removeTemporaryElements = (_event) => {
        for (const element of this.temporaryElements) {
          element.remove();
        }
      };
    }
    start() {
      if (!this.started) {
        this.started = true;
        addEventListener("turbo:before-cache", this.removeTemporaryElements, false);
      }
    }
    stop() {
      if (this.started) {
        this.started = false;
        removeEventListener("turbo:before-cache", this.removeTemporaryElements, false);
      }
    }
    get temporaryElements() {
      return [...document.querySelectorAll(this.selector), ...this.temporaryElementsWithDeprecation];
    }
    get temporaryElementsWithDeprecation() {
      const elements = document.querySelectorAll(this.deprecatedSelector);
      if (elements.length) {
        console.warn(`The ${this.deprecatedSelector} selector is deprecated and will be removed in a future version. Use ${this.selector} instead.`);
      }
      return [...elements];
    }
  };
  var FrameRedirector = class {
    constructor(session2, element) {
      this.session = session2;
      this.element = element;
      this.linkInterceptor = new LinkInterceptor(this, element);
      this.formSubmitObserver = new FormSubmitObserver(this, element);
    }
    start() {
      this.linkInterceptor.start();
      this.formSubmitObserver.start();
    }
    stop() {
      this.linkInterceptor.stop();
      this.formSubmitObserver.stop();
    }
    shouldInterceptLinkClick(element, _location, _event) {
      return this.shouldRedirect(element);
    }
    linkClickIntercepted(element, url, event) {
      const frame = this.findFrameElement(element);
      if (frame) {
        frame.delegate.linkClickIntercepted(element, url, event);
      }
    }
    willSubmitForm(element, submitter) {
      return element.closest("turbo-frame") == null && this.shouldSubmit(element, submitter) && this.shouldRedirect(element, submitter);
    }
    formSubmitted(element, submitter) {
      const frame = this.findFrameElement(element, submitter);
      if (frame) {
        frame.delegate.formSubmitted(element, submitter);
      }
    }
    shouldSubmit(form, submitter) {
      var _a;
      const action = getAction(form, submitter);
      const meta = this.element.ownerDocument.querySelector(`meta[name="turbo-root"]`);
      const rootLocation = expandURL((_a = meta === null || meta === void 0 ? void 0 : meta.content) !== null && _a !== void 0 ? _a : "/");
      return this.shouldRedirect(form, submitter) && locationIsVisitable(action, rootLocation);
    }
    shouldRedirect(element, submitter) {
      const isNavigatable = element instanceof HTMLFormElement ? this.session.submissionIsNavigatable(element, submitter) : this.session.elementIsNavigatable(element);
      if (isNavigatable) {
        const frame = this.findFrameElement(element, submitter);
        return frame ? frame != element.closest("turbo-frame") : false;
      } else {
        return false;
      }
    }
    findFrameElement(element, submitter) {
      const id = (submitter === null || submitter === void 0 ? void 0 : submitter.getAttribute("data-turbo-frame")) || element.getAttribute("data-turbo-frame");
      if (id && id != "_top") {
        const frame = this.element.querySelector(`#${id}:not([disabled])`);
        if (frame instanceof FrameElement) {
          return frame;
        }
      }
    }
  };
  var History = class {
    constructor(delegate) {
      this.restorationIdentifier = uuid();
      this.restorationData = {};
      this.started = false;
      this.pageLoaded = false;
      this.onPopState = (event) => {
        if (this.shouldHandlePopState()) {
          const { turbo } = event.state || {};
          if (turbo) {
            this.location = new URL(window.location.href);
            const { restorationIdentifier } = turbo;
            this.restorationIdentifier = restorationIdentifier;
            this.delegate.historyPoppedToLocationWithRestorationIdentifier(this.location, restorationIdentifier);
          }
        }
      };
      this.onPageLoad = async (_event) => {
        await nextMicrotask();
        this.pageLoaded = true;
      };
      this.delegate = delegate;
    }
    start() {
      if (!this.started) {
        addEventListener("popstate", this.onPopState, false);
        addEventListener("load", this.onPageLoad, false);
        this.started = true;
        this.replace(new URL(window.location.href));
      }
    }
    stop() {
      if (this.started) {
        removeEventListener("popstate", this.onPopState, false);
        removeEventListener("load", this.onPageLoad, false);
        this.started = false;
      }
    }
    push(location2, restorationIdentifier) {
      this.update(history.pushState, location2, restorationIdentifier);
    }
    replace(location2, restorationIdentifier) {
      this.update(history.replaceState, location2, restorationIdentifier);
    }
    update(method, location2, restorationIdentifier = uuid()) {
      const state = { turbo: { restorationIdentifier } };
      method.call(history, state, "", location2.href);
      this.location = location2;
      this.restorationIdentifier = restorationIdentifier;
    }
    getRestorationDataForIdentifier(restorationIdentifier) {
      return this.restorationData[restorationIdentifier] || {};
    }
    updateRestorationData(additionalData) {
      const { restorationIdentifier } = this;
      const restorationData = this.restorationData[restorationIdentifier];
      this.restorationData[restorationIdentifier] = Object.assign(Object.assign({}, restorationData), additionalData);
    }
    assumeControlOfScrollRestoration() {
      var _a;
      if (!this.previousScrollRestoration) {
        this.previousScrollRestoration = (_a = history.scrollRestoration) !== null && _a !== void 0 ? _a : "auto";
        history.scrollRestoration = "manual";
      }
    }
    relinquishControlOfScrollRestoration() {
      if (this.previousScrollRestoration) {
        history.scrollRestoration = this.previousScrollRestoration;
        delete this.previousScrollRestoration;
      }
    }
    shouldHandlePopState() {
      return this.pageIsLoaded();
    }
    pageIsLoaded() {
      return this.pageLoaded || document.readyState == "complete";
    }
  };
  var Navigator = class {
    constructor(delegate) {
      this.delegate = delegate;
    }
    proposeVisit(location2, options = {}) {
      if (this.delegate.allowsVisitingLocationWithAction(location2, options.action)) {
        if (locationIsVisitable(location2, this.view.snapshot.rootLocation)) {
          this.delegate.visitProposedToLocation(location2, options);
        } else {
          window.location.href = location2.toString();
        }
      }
    }
    startVisit(locatable, restorationIdentifier, options = {}) {
      this.stop();
      this.currentVisit = new Visit(this, expandURL(locatable), restorationIdentifier, Object.assign({ referrer: this.location }, options));
      this.currentVisit.start();
    }
    submitForm(form, submitter) {
      this.stop();
      this.formSubmission = new FormSubmission(this, form, submitter, true);
      this.formSubmission.start();
    }
    stop() {
      if (this.formSubmission) {
        this.formSubmission.stop();
        delete this.formSubmission;
      }
      if (this.currentVisit) {
        this.currentVisit.cancel();
        delete this.currentVisit;
      }
    }
    get adapter() {
      return this.delegate.adapter;
    }
    get view() {
      return this.delegate.view;
    }
    get history() {
      return this.delegate.history;
    }
    formSubmissionStarted(formSubmission) {
      if (typeof this.adapter.formSubmissionStarted === "function") {
        this.adapter.formSubmissionStarted(formSubmission);
      }
    }
    async formSubmissionSucceededWithResponse(formSubmission, fetchResponse) {
      if (formSubmission == this.formSubmission) {
        const responseHTML = await fetchResponse.responseHTML;
        if (responseHTML) {
          const shouldCacheSnapshot = formSubmission.isSafe;
          if (!shouldCacheSnapshot) {
            this.view.clearSnapshotCache();
          }
          const { statusCode, redirected } = fetchResponse;
          const action = this.getActionForFormSubmission(formSubmission);
          const visitOptions = {
            action,
            shouldCacheSnapshot,
            response: { statusCode, responseHTML, redirected }
          };
          this.proposeVisit(fetchResponse.location, visitOptions);
        }
      }
    }
    async formSubmissionFailedWithResponse(formSubmission, fetchResponse) {
      const responseHTML = await fetchResponse.responseHTML;
      if (responseHTML) {
        const snapshot = PageSnapshot.fromHTMLString(responseHTML);
        if (fetchResponse.serverError) {
          await this.view.renderError(snapshot, this.currentVisit);
        } else {
          await this.view.renderPage(snapshot, false, true, this.currentVisit);
        }
        this.view.scrollToTop();
        this.view.clearSnapshotCache();
      }
    }
    formSubmissionErrored(formSubmission, error) {
      console.error(error);
    }
    formSubmissionFinished(formSubmission) {
      if (typeof this.adapter.formSubmissionFinished === "function") {
        this.adapter.formSubmissionFinished(formSubmission);
      }
    }
    visitStarted(visit2) {
      this.delegate.visitStarted(visit2);
    }
    visitCompleted(visit2) {
      this.delegate.visitCompleted(visit2);
    }
    locationWithActionIsSamePage(location2, action) {
      const anchor = getAnchor(location2);
      const currentAnchor = getAnchor(this.view.lastRenderedLocation);
      const isRestorationToTop = action === "restore" && typeof anchor === "undefined";
      return action !== "replace" && getRequestURL(location2) === getRequestURL(this.view.lastRenderedLocation) && (isRestorationToTop || anchor != null && anchor !== currentAnchor);
    }
    visitScrolledToSamePageLocation(oldURL, newURL) {
      this.delegate.visitScrolledToSamePageLocation(oldURL, newURL);
    }
    get location() {
      return this.history.location;
    }
    get restorationIdentifier() {
      return this.history.restorationIdentifier;
    }
    getActionForFormSubmission({ submitter, formElement }) {
      return getVisitAction(submitter, formElement) || "advance";
    }
  };
  var PageStage;
  (function(PageStage2) {
    PageStage2[PageStage2["initial"] = 0] = "initial";
    PageStage2[PageStage2["loading"] = 1] = "loading";
    PageStage2[PageStage2["interactive"] = 2] = "interactive";
    PageStage2[PageStage2["complete"] = 3] = "complete";
  })(PageStage || (PageStage = {}));
  var PageObserver = class {
    constructor(delegate) {
      this.stage = PageStage.initial;
      this.started = false;
      this.interpretReadyState = () => {
        const { readyState } = this;
        if (readyState == "interactive") {
          this.pageIsInteractive();
        } else if (readyState == "complete") {
          this.pageIsComplete();
        }
      };
      this.pageWillUnload = () => {
        this.delegate.pageWillUnload();
      };
      this.delegate = delegate;
    }
    start() {
      if (!this.started) {
        if (this.stage == PageStage.initial) {
          this.stage = PageStage.loading;
        }
        document.addEventListener("readystatechange", this.interpretReadyState, false);
        addEventListener("pagehide", this.pageWillUnload, false);
        this.started = true;
      }
    }
    stop() {
      if (this.started) {
        document.removeEventListener("readystatechange", this.interpretReadyState, false);
        removeEventListener("pagehide", this.pageWillUnload, false);
        this.started = false;
      }
    }
    pageIsInteractive() {
      if (this.stage == PageStage.loading) {
        this.stage = PageStage.interactive;
        this.delegate.pageBecameInteractive();
      }
    }
    pageIsComplete() {
      this.pageIsInteractive();
      if (this.stage == PageStage.interactive) {
        this.stage = PageStage.complete;
        this.delegate.pageLoaded();
      }
    }
    get readyState() {
      return document.readyState;
    }
  };
  var ScrollObserver = class {
    constructor(delegate) {
      this.started = false;
      this.onScroll = () => {
        this.updatePosition({ x: window.pageXOffset, y: window.pageYOffset });
      };
      this.delegate = delegate;
    }
    start() {
      if (!this.started) {
        addEventListener("scroll", this.onScroll, false);
        this.onScroll();
        this.started = true;
      }
    }
    stop() {
      if (this.started) {
        removeEventListener("scroll", this.onScroll, false);
        this.started = false;
      }
    }
    updatePosition(position) {
      this.delegate.scrollPositionChanged(position);
    }
  };
  var StreamMessageRenderer = class {
    render({ fragment }) {
      Bardo.preservingPermanentElements(this, getPermanentElementMapForFragment(fragment), () => document.documentElement.appendChild(fragment));
    }
    enteringBardo(currentPermanentElement, newPermanentElement) {
      newPermanentElement.replaceWith(currentPermanentElement.cloneNode(true));
    }
    leavingBardo() {
    }
  };
  function getPermanentElementMapForFragment(fragment) {
    const permanentElementsInDocument = queryPermanentElementsAll(document.documentElement);
    const permanentElementMap = {};
    for (const permanentElementInDocument of permanentElementsInDocument) {
      const { id } = permanentElementInDocument;
      for (const streamElement of fragment.querySelectorAll("turbo-stream")) {
        const elementInStream = getPermanentElementById(streamElement.templateElement.content, id);
        if (elementInStream) {
          permanentElementMap[id] = [permanentElementInDocument, elementInStream];
        }
      }
    }
    return permanentElementMap;
  }
  var StreamObserver = class {
    constructor(delegate) {
      this.sources = /* @__PURE__ */ new Set();
      this.started = false;
      this.inspectFetchResponse = (event) => {
        const response = fetchResponseFromEvent(event);
        if (response && fetchResponseIsStream(response)) {
          event.preventDefault();
          this.receiveMessageResponse(response);
        }
      };
      this.receiveMessageEvent = (event) => {
        if (this.started && typeof event.data == "string") {
          this.receiveMessageHTML(event.data);
        }
      };
      this.delegate = delegate;
    }
    start() {
      if (!this.started) {
        this.started = true;
        addEventListener("turbo:before-fetch-response", this.inspectFetchResponse, false);
      }
    }
    stop() {
      if (this.started) {
        this.started = false;
        removeEventListener("turbo:before-fetch-response", this.inspectFetchResponse, false);
      }
    }
    connectStreamSource(source) {
      if (!this.streamSourceIsConnected(source)) {
        this.sources.add(source);
        source.addEventListener("message", this.receiveMessageEvent, false);
      }
    }
    disconnectStreamSource(source) {
      if (this.streamSourceIsConnected(source)) {
        this.sources.delete(source);
        source.removeEventListener("message", this.receiveMessageEvent, false);
      }
    }
    streamSourceIsConnected(source) {
      return this.sources.has(source);
    }
    async receiveMessageResponse(response) {
      const html = await response.responseHTML;
      if (html) {
        this.receiveMessageHTML(html);
      }
    }
    receiveMessageHTML(html) {
      this.delegate.receivedMessageFromStream(StreamMessage.wrap(html));
    }
  };
  function fetchResponseFromEvent(event) {
    var _a;
    const fetchResponse = (_a = event.detail) === null || _a === void 0 ? void 0 : _a.fetchResponse;
    if (fetchResponse instanceof FetchResponse) {
      return fetchResponse;
    }
  }
  function fetchResponseIsStream(response) {
    var _a;
    const contentType = (_a = response.contentType) !== null && _a !== void 0 ? _a : "";
    return contentType.startsWith(StreamMessage.contentType);
  }
  var ErrorRenderer = class extends Renderer {
    static renderElement(currentElement, newElement) {
      const { documentElement, body } = document;
      documentElement.replaceChild(newElement, body);
    }
    async render() {
      this.replaceHeadAndBody();
      this.activateScriptElements();
    }
    replaceHeadAndBody() {
      const { documentElement, head } = document;
      documentElement.replaceChild(this.newHead, head);
      this.renderElement(this.currentElement, this.newElement);
    }
    activateScriptElements() {
      for (const replaceableElement of this.scriptElements) {
        const parentNode = replaceableElement.parentNode;
        if (parentNode) {
          const element = activateScriptElement(replaceableElement);
          parentNode.replaceChild(element, replaceableElement);
        }
      }
    }
    get newHead() {
      return this.newSnapshot.headSnapshot.element;
    }
    get scriptElements() {
      return document.documentElement.querySelectorAll("script");
    }
  };
  var PageRenderer = class extends Renderer {
    static renderElement(currentElement, newElement) {
      if (document.body && newElement instanceof HTMLBodyElement) {
        document.body.replaceWith(newElement);
      } else {
        document.documentElement.appendChild(newElement);
      }
    }
    get shouldRender() {
      return this.newSnapshot.isVisitable && this.trackedElementsAreIdentical;
    }
    get reloadReason() {
      if (!this.newSnapshot.isVisitable) {
        return {
          reason: "turbo_visit_control_is_reload"
        };
      }
      if (!this.trackedElementsAreIdentical) {
        return {
          reason: "tracked_element_mismatch"
        };
      }
    }
    async prepareToRender() {
      await this.mergeHead();
    }
    async render() {
      if (this.willRender) {
        await this.replaceBody();
      }
    }
    finishRendering() {
      super.finishRendering();
      if (!this.isPreview) {
        this.focusFirstAutofocusableElement();
      }
    }
    get currentHeadSnapshot() {
      return this.currentSnapshot.headSnapshot;
    }
    get newHeadSnapshot() {
      return this.newSnapshot.headSnapshot;
    }
    get newElement() {
      return this.newSnapshot.element;
    }
    async mergeHead() {
      const mergedHeadElements = this.mergeProvisionalElements();
      const newStylesheetElements = this.copyNewHeadStylesheetElements();
      this.copyNewHeadScriptElements();
      await mergedHeadElements;
      await newStylesheetElements;
    }
    async replaceBody() {
      await this.preservingPermanentElements(async () => {
        this.activateNewBody();
        await this.assignNewBody();
      });
    }
    get trackedElementsAreIdentical() {
      return this.currentHeadSnapshot.trackedElementSignature == this.newHeadSnapshot.trackedElementSignature;
    }
    async copyNewHeadStylesheetElements() {
      const loadingElements = [];
      for (const element of this.newHeadStylesheetElements) {
        loadingElements.push(waitForLoad(element));
        document.head.appendChild(element);
      }
      await Promise.all(loadingElements);
    }
    copyNewHeadScriptElements() {
      for (const element of this.newHeadScriptElements) {
        document.head.appendChild(activateScriptElement(element));
      }
    }
    async mergeProvisionalElements() {
      const newHeadElements = [...this.newHeadProvisionalElements];
      for (const element of this.currentHeadProvisionalElements) {
        if (!this.isCurrentElementInElementList(element, newHeadElements)) {
          document.head.removeChild(element);
        }
      }
      for (const element of newHeadElements) {
        document.head.appendChild(element);
      }
    }
    isCurrentElementInElementList(element, elementList) {
      for (const [index, newElement] of elementList.entries()) {
        if (element.tagName == "TITLE") {
          if (newElement.tagName != "TITLE") {
            continue;
          }
          if (element.innerHTML == newElement.innerHTML) {
            elementList.splice(index, 1);
            return true;
          }
        }
        if (newElement.isEqualNode(element)) {
          elementList.splice(index, 1);
          return true;
        }
      }
      return false;
    }
    removeCurrentHeadProvisionalElements() {
      for (const element of this.currentHeadProvisionalElements) {
        document.head.removeChild(element);
      }
    }
    copyNewHeadProvisionalElements() {
      for (const element of this.newHeadProvisionalElements) {
        document.head.appendChild(element);
      }
    }
    activateNewBody() {
      document.adoptNode(this.newElement);
      this.activateNewBodyScriptElements();
    }
    activateNewBodyScriptElements() {
      for (const inertScriptElement of this.newBodyScriptElements) {
        const activatedScriptElement = activateScriptElement(inertScriptElement);
        inertScriptElement.replaceWith(activatedScriptElement);
      }
    }
    async assignNewBody() {
      await this.renderElement(this.currentElement, this.newElement);
    }
    get newHeadStylesheetElements() {
      return this.newHeadSnapshot.getStylesheetElementsNotInSnapshot(this.currentHeadSnapshot);
    }
    get newHeadScriptElements() {
      return this.newHeadSnapshot.getScriptElementsNotInSnapshot(this.currentHeadSnapshot);
    }
    get currentHeadProvisionalElements() {
      return this.currentHeadSnapshot.provisionalElements;
    }
    get newHeadProvisionalElements() {
      return this.newHeadSnapshot.provisionalElements;
    }
    get newBodyScriptElements() {
      return this.newElement.querySelectorAll("script");
    }
  };
  var SnapshotCache = class {
    constructor(size) {
      this.keys = [];
      this.snapshots = {};
      this.size = size;
    }
    has(location2) {
      return toCacheKey(location2) in this.snapshots;
    }
    get(location2) {
      if (this.has(location2)) {
        const snapshot = this.read(location2);
        this.touch(location2);
        return snapshot;
      }
    }
    put(location2, snapshot) {
      this.write(location2, snapshot);
      this.touch(location2);
      return snapshot;
    }
    clear() {
      this.snapshots = {};
    }
    read(location2) {
      return this.snapshots[toCacheKey(location2)];
    }
    write(location2, snapshot) {
      this.snapshots[toCacheKey(location2)] = snapshot;
    }
    touch(location2) {
      const key = toCacheKey(location2);
      const index = this.keys.indexOf(key);
      if (index > -1)
        this.keys.splice(index, 1);
      this.keys.unshift(key);
      this.trim();
    }
    trim() {
      for (const key of this.keys.splice(this.size)) {
        delete this.snapshots[key];
      }
    }
  };
  var PageView = class extends View {
    constructor() {
      super(...arguments);
      this.snapshotCache = new SnapshotCache(10);
      this.lastRenderedLocation = new URL(location.href);
      this.forceReloaded = false;
    }
    renderPage(snapshot, isPreview = false, willRender = true, visit2) {
      const renderer = new PageRenderer(this.snapshot, snapshot, PageRenderer.renderElement, isPreview, willRender);
      if (!renderer.shouldRender) {
        this.forceReloaded = true;
      } else {
        visit2 === null || visit2 === void 0 ? void 0 : visit2.changeHistory();
      }
      return this.render(renderer);
    }
    renderError(snapshot, visit2) {
      visit2 === null || visit2 === void 0 ? void 0 : visit2.changeHistory();
      const renderer = new ErrorRenderer(this.snapshot, snapshot, ErrorRenderer.renderElement, false);
      return this.render(renderer);
    }
    clearSnapshotCache() {
      this.snapshotCache.clear();
    }
    async cacheSnapshot(snapshot = this.snapshot) {
      if (snapshot.isCacheable) {
        this.delegate.viewWillCacheSnapshot();
        const { lastRenderedLocation: location2 } = this;
        await nextEventLoopTick();
        const cachedSnapshot = snapshot.clone();
        this.snapshotCache.put(location2, cachedSnapshot);
        return cachedSnapshot;
      }
    }
    getCachedSnapshotForLocation(location2) {
      return this.snapshotCache.get(location2);
    }
    get snapshot() {
      return PageSnapshot.fromElement(this.element);
    }
  };
  var Preloader = class {
    constructor(delegate) {
      this.selector = "a[data-turbo-preload]";
      this.delegate = delegate;
    }
    get snapshotCache() {
      return this.delegate.navigator.view.snapshotCache;
    }
    start() {
      if (document.readyState === "loading") {
        return document.addEventListener("DOMContentLoaded", () => {
          this.preloadOnLoadLinksForView(document.body);
        });
      } else {
        this.preloadOnLoadLinksForView(document.body);
      }
    }
    preloadOnLoadLinksForView(element) {
      for (const link of element.querySelectorAll(this.selector)) {
        this.preloadURL(link);
      }
    }
    async preloadURL(link) {
      const location2 = new URL(link.href);
      if (this.snapshotCache.has(location2)) {
        return;
      }
      try {
        const response = await fetch(location2.toString(), { headers: { "VND.PREFETCH": "true", Accept: "text/html" } });
        const responseText = await response.text();
        const snapshot = PageSnapshot.fromHTMLString(responseText);
        this.snapshotCache.put(location2, snapshot);
      } catch (_) {
      }
    }
  };
  var Session = class {
    constructor() {
      this.navigator = new Navigator(this);
      this.history = new History(this);
      this.preloader = new Preloader(this);
      this.view = new PageView(this, document.documentElement);
      this.adapter = new BrowserAdapter(this);
      this.pageObserver = new PageObserver(this);
      this.cacheObserver = new CacheObserver();
      this.linkClickObserver = new LinkClickObserver(this, window);
      this.formSubmitObserver = new FormSubmitObserver(this, document);
      this.scrollObserver = new ScrollObserver(this);
      this.streamObserver = new StreamObserver(this);
      this.formLinkClickObserver = new FormLinkClickObserver(this, document.documentElement);
      this.frameRedirector = new FrameRedirector(this, document.documentElement);
      this.streamMessageRenderer = new StreamMessageRenderer();
      this.drive = true;
      this.enabled = true;
      this.progressBarDelay = 500;
      this.started = false;
      this.formMode = "on";
    }
    start() {
      if (!this.started) {
        this.pageObserver.start();
        this.cacheObserver.start();
        this.formLinkClickObserver.start();
        this.linkClickObserver.start();
        this.formSubmitObserver.start();
        this.scrollObserver.start();
        this.streamObserver.start();
        this.frameRedirector.start();
        this.history.start();
        this.preloader.start();
        this.started = true;
        this.enabled = true;
      }
    }
    disable() {
      this.enabled = false;
    }
    stop() {
      if (this.started) {
        this.pageObserver.stop();
        this.cacheObserver.stop();
        this.formLinkClickObserver.stop();
        this.linkClickObserver.stop();
        this.formSubmitObserver.stop();
        this.scrollObserver.stop();
        this.streamObserver.stop();
        this.frameRedirector.stop();
        this.history.stop();
        this.started = false;
      }
    }
    registerAdapter(adapter) {
      this.adapter = adapter;
    }
    visit(location2, options = {}) {
      const frameElement = options.frame ? document.getElementById(options.frame) : null;
      if (frameElement instanceof FrameElement) {
        frameElement.src = location2.toString();
        frameElement.loaded;
      } else {
        this.navigator.proposeVisit(expandURL(location2), options);
      }
    }
    connectStreamSource(source) {
      this.streamObserver.connectStreamSource(source);
    }
    disconnectStreamSource(source) {
      this.streamObserver.disconnectStreamSource(source);
    }
    renderStreamMessage(message) {
      this.streamMessageRenderer.render(StreamMessage.wrap(message));
    }
    clearCache() {
      this.view.clearSnapshotCache();
    }
    setProgressBarDelay(delay) {
      this.progressBarDelay = delay;
    }
    setFormMode(mode) {
      this.formMode = mode;
    }
    get location() {
      return this.history.location;
    }
    get restorationIdentifier() {
      return this.history.restorationIdentifier;
    }
    historyPoppedToLocationWithRestorationIdentifier(location2, restorationIdentifier) {
      if (this.enabled) {
        this.navigator.startVisit(location2, restorationIdentifier, {
          action: "restore",
          historyChanged: true
        });
      } else {
        this.adapter.pageInvalidated({
          reason: "turbo_disabled"
        });
      }
    }
    scrollPositionChanged(position) {
      this.history.updateRestorationData({ scrollPosition: position });
    }
    willSubmitFormLinkToLocation(link, location2) {
      return this.elementIsNavigatable(link) && locationIsVisitable(location2, this.snapshot.rootLocation);
    }
    submittedFormLinkToLocation() {
    }
    willFollowLinkToLocation(link, location2, event) {
      return this.elementIsNavigatable(link) && locationIsVisitable(location2, this.snapshot.rootLocation) && this.applicationAllowsFollowingLinkToLocation(link, location2, event);
    }
    followedLinkToLocation(link, location2) {
      const action = this.getActionForLink(link);
      const acceptsStreamResponse = link.hasAttribute("data-turbo-stream");
      this.visit(location2.href, { action, acceptsStreamResponse });
    }
    allowsVisitingLocationWithAction(location2, action) {
      return this.locationWithActionIsSamePage(location2, action) || this.applicationAllowsVisitingLocation(location2);
    }
    visitProposedToLocation(location2, options) {
      extendURLWithDeprecatedProperties(location2);
      this.adapter.visitProposedToLocation(location2, options);
    }
    visitStarted(visit2) {
      if (!visit2.acceptsStreamResponse) {
        markAsBusy(document.documentElement);
      }
      extendURLWithDeprecatedProperties(visit2.location);
      if (!visit2.silent) {
        this.notifyApplicationAfterVisitingLocation(visit2.location, visit2.action);
      }
    }
    visitCompleted(visit2) {
      clearBusyState(document.documentElement);
      this.notifyApplicationAfterPageLoad(visit2.getTimingMetrics());
    }
    locationWithActionIsSamePage(location2, action) {
      return this.navigator.locationWithActionIsSamePage(location2, action);
    }
    visitScrolledToSamePageLocation(oldURL, newURL) {
      this.notifyApplicationAfterVisitingSamePageLocation(oldURL, newURL);
    }
    willSubmitForm(form, submitter) {
      const action = getAction(form, submitter);
      return this.submissionIsNavigatable(form, submitter) && locationIsVisitable(expandURL(action), this.snapshot.rootLocation);
    }
    formSubmitted(form, submitter) {
      this.navigator.submitForm(form, submitter);
    }
    pageBecameInteractive() {
      this.view.lastRenderedLocation = this.location;
      this.notifyApplicationAfterPageLoad();
    }
    pageLoaded() {
      this.history.assumeControlOfScrollRestoration();
    }
    pageWillUnload() {
      this.history.relinquishControlOfScrollRestoration();
    }
    receivedMessageFromStream(message) {
      this.renderStreamMessage(message);
    }
    viewWillCacheSnapshot() {
      var _a;
      if (!((_a = this.navigator.currentVisit) === null || _a === void 0 ? void 0 : _a.silent)) {
        this.notifyApplicationBeforeCachingSnapshot();
      }
    }
    allowsImmediateRender({ element }, options) {
      const event = this.notifyApplicationBeforeRender(element, options);
      const { defaultPrevented, detail: { render } } = event;
      if (this.view.renderer && render) {
        this.view.renderer.renderElement = render;
      }
      return !defaultPrevented;
    }
    viewRenderedSnapshot(_snapshot, _isPreview) {
      this.view.lastRenderedLocation = this.history.location;
      this.notifyApplicationAfterRender();
    }
    preloadOnLoadLinksForView(element) {
      this.preloader.preloadOnLoadLinksForView(element);
    }
    viewInvalidated(reason) {
      this.adapter.pageInvalidated(reason);
    }
    frameLoaded(frame) {
      this.notifyApplicationAfterFrameLoad(frame);
    }
    frameRendered(fetchResponse, frame) {
      this.notifyApplicationAfterFrameRender(fetchResponse, frame);
    }
    applicationAllowsFollowingLinkToLocation(link, location2, ev) {
      const event = this.notifyApplicationAfterClickingLinkToLocation(link, location2, ev);
      return !event.defaultPrevented;
    }
    applicationAllowsVisitingLocation(location2) {
      const event = this.notifyApplicationBeforeVisitingLocation(location2);
      return !event.defaultPrevented;
    }
    notifyApplicationAfterClickingLinkToLocation(link, location2, event) {
      return dispatch("turbo:click", {
        target: link,
        detail: { url: location2.href, originalEvent: event },
        cancelable: true
      });
    }
    notifyApplicationBeforeVisitingLocation(location2) {
      return dispatch("turbo:before-visit", {
        detail: { url: location2.href },
        cancelable: true
      });
    }
    notifyApplicationAfterVisitingLocation(location2, action) {
      return dispatch("turbo:visit", { detail: { url: location2.href, action } });
    }
    notifyApplicationBeforeCachingSnapshot() {
      return dispatch("turbo:before-cache");
    }
    notifyApplicationBeforeRender(newBody, options) {
      return dispatch("turbo:before-render", {
        detail: Object.assign({ newBody }, options),
        cancelable: true
      });
    }
    notifyApplicationAfterRender() {
      return dispatch("turbo:render");
    }
    notifyApplicationAfterPageLoad(timing = {}) {
      return dispatch("turbo:load", {
        detail: { url: this.location.href, timing }
      });
    }
    notifyApplicationAfterVisitingSamePageLocation(oldURL, newURL) {
      dispatchEvent(new HashChangeEvent("hashchange", {
        oldURL: oldURL.toString(),
        newURL: newURL.toString()
      }));
    }
    notifyApplicationAfterFrameLoad(frame) {
      return dispatch("turbo:frame-load", { target: frame });
    }
    notifyApplicationAfterFrameRender(fetchResponse, frame) {
      return dispatch("turbo:frame-render", {
        detail: { fetchResponse },
        target: frame,
        cancelable: true
      });
    }
    submissionIsNavigatable(form, submitter) {
      if (this.formMode == "off") {
        return false;
      } else {
        const submitterIsNavigatable = submitter ? this.elementIsNavigatable(submitter) : true;
        if (this.formMode == "optin") {
          return submitterIsNavigatable && form.closest('[data-turbo="true"]') != null;
        } else {
          return submitterIsNavigatable && this.elementIsNavigatable(form);
        }
      }
    }
    elementIsNavigatable(element) {
      const container = findClosestRecursively(element, "[data-turbo]");
      const withinFrame = findClosestRecursively(element, "turbo-frame");
      if (this.drive || withinFrame) {
        if (container) {
          return container.getAttribute("data-turbo") != "false";
        } else {
          return true;
        }
      } else {
        if (container) {
          return container.getAttribute("data-turbo") == "true";
        } else {
          return false;
        }
      }
    }
    getActionForLink(link) {
      return getVisitAction(link) || "advance";
    }
    get snapshot() {
      return this.view.snapshot;
    }
  };
  function extendURLWithDeprecatedProperties(url) {
    Object.defineProperties(url, deprecatedLocationPropertyDescriptors);
  }
  var deprecatedLocationPropertyDescriptors = {
    absoluteURL: {
      get() {
        return this.toString();
      }
    }
  };
  var Cache = class {
    constructor(session2) {
      this.session = session2;
    }
    clear() {
      this.session.clearCache();
    }
    resetCacheControl() {
      this.setCacheControl("");
    }
    exemptPageFromCache() {
      this.setCacheControl("no-cache");
    }
    exemptPageFromPreview() {
      this.setCacheControl("no-preview");
    }
    setCacheControl(value) {
      setMetaContent("turbo-cache-control", value);
    }
  };
  var StreamActions = {
    after() {
      this.targetElements.forEach((e) => {
        var _a;
        return (_a = e.parentElement) === null || _a === void 0 ? void 0 : _a.insertBefore(this.templateContent, e.nextSibling);
      });
    },
    append() {
      this.removeDuplicateTargetChildren();
      this.targetElements.forEach((e) => e.append(this.templateContent));
    },
    before() {
      this.targetElements.forEach((e) => {
        var _a;
        return (_a = e.parentElement) === null || _a === void 0 ? void 0 : _a.insertBefore(this.templateContent, e);
      });
    },
    prepend() {
      this.removeDuplicateTargetChildren();
      this.targetElements.forEach((e) => e.prepend(this.templateContent));
    },
    remove() {
      this.targetElements.forEach((e) => e.remove());
    },
    replace() {
      this.targetElements.forEach((e) => e.replaceWith(this.templateContent));
    },
    update() {
      this.targetElements.forEach((targetElement) => {
        targetElement.innerHTML = "";
        targetElement.append(this.templateContent);
      });
    }
  };
  var session = new Session();
  var cache = new Cache(session);
  var { navigator: navigator$1 } = session;
  function start() {
    session.start();
  }
  function registerAdapter(adapter) {
    session.registerAdapter(adapter);
  }
  function visit(location2, options) {
    session.visit(location2, options);
  }
  function connectStreamSource(source) {
    session.connectStreamSource(source);
  }
  function disconnectStreamSource(source) {
    session.disconnectStreamSource(source);
  }
  function renderStreamMessage(message) {
    session.renderStreamMessage(message);
  }
  function clearCache() {
    console.warn("Please replace `Turbo.clearCache()` with `Turbo.cache.clear()`. The top-level function is deprecated and will be removed in a future version of Turbo.`");
    session.clearCache();
  }
  function setProgressBarDelay(delay) {
    session.setProgressBarDelay(delay);
  }
  function setConfirmMethod(confirmMethod) {
    FormSubmission.confirmMethod = confirmMethod;
  }
  function setFormMode(mode) {
    session.setFormMode(mode);
  }
  var Turbo = /* @__PURE__ */ Object.freeze({
    __proto__: null,
    navigator: navigator$1,
    session,
    cache,
    PageRenderer,
    PageSnapshot,
    FrameRenderer,
    start,
    registerAdapter,
    visit,
    connectStreamSource,
    disconnectStreamSource,
    renderStreamMessage,
    clearCache,
    setProgressBarDelay,
    setConfirmMethod,
    setFormMode,
    StreamActions
  });
  var TurboFrameMissingError = class extends Error {
  };
  var FrameController = class {
    constructor(element) {
      this.fetchResponseLoaded = (_fetchResponse) => {
      };
      this.currentFetchRequest = null;
      this.resolveVisitPromise = () => {
      };
      this.connected = false;
      this.hasBeenLoaded = false;
      this.ignoredAttributes = /* @__PURE__ */ new Set();
      this.action = null;
      this.visitCachedSnapshot = ({ element: element2 }) => {
        const frame = element2.querySelector("#" + this.element.id);
        if (frame && this.previousFrameElement) {
          frame.replaceChildren(...this.previousFrameElement.children);
        }
        delete this.previousFrameElement;
      };
      this.element = element;
      this.view = new FrameView(this, this.element);
      this.appearanceObserver = new AppearanceObserver(this, this.element);
      this.formLinkClickObserver = new FormLinkClickObserver(this, this.element);
      this.linkInterceptor = new LinkInterceptor(this, this.element);
      this.restorationIdentifier = uuid();
      this.formSubmitObserver = new FormSubmitObserver(this, this.element);
    }
    connect() {
      if (!this.connected) {
        this.connected = true;
        if (this.loadingStyle == FrameLoadingStyle.lazy) {
          this.appearanceObserver.start();
        } else {
          this.loadSourceURL();
        }
        this.formLinkClickObserver.start();
        this.linkInterceptor.start();
        this.formSubmitObserver.start();
      }
    }
    disconnect() {
      if (this.connected) {
        this.connected = false;
        this.appearanceObserver.stop();
        this.formLinkClickObserver.stop();
        this.linkInterceptor.stop();
        this.formSubmitObserver.stop();
      }
    }
    disabledChanged() {
      if (this.loadingStyle == FrameLoadingStyle.eager) {
        this.loadSourceURL();
      }
    }
    sourceURLChanged() {
      if (this.isIgnoringChangesTo("src"))
        return;
      if (this.element.isConnected) {
        this.complete = false;
      }
      if (this.loadingStyle == FrameLoadingStyle.eager || this.hasBeenLoaded) {
        this.loadSourceURL();
      }
    }
    sourceURLReloaded() {
      const { src } = this.element;
      this.ignoringChangesToAttribute("complete", () => {
        this.element.removeAttribute("complete");
      });
      this.element.src = null;
      this.element.src = src;
      return this.element.loaded;
    }
    completeChanged() {
      if (this.isIgnoringChangesTo("complete"))
        return;
      this.loadSourceURL();
    }
    loadingStyleChanged() {
      if (this.loadingStyle == FrameLoadingStyle.lazy) {
        this.appearanceObserver.start();
      } else {
        this.appearanceObserver.stop();
        this.loadSourceURL();
      }
    }
    async loadSourceURL() {
      if (this.enabled && this.isActive && !this.complete && this.sourceURL) {
        this.element.loaded = this.visit(expandURL(this.sourceURL));
        this.appearanceObserver.stop();
        await this.element.loaded;
        this.hasBeenLoaded = true;
      }
    }
    async loadResponse(fetchResponse) {
      if (fetchResponse.redirected || fetchResponse.succeeded && fetchResponse.isHTML) {
        this.sourceURL = fetchResponse.response.url;
      }
      try {
        const html = await fetchResponse.responseHTML;
        if (html) {
          const document2 = parseHTMLDocument(html);
          const pageSnapshot = PageSnapshot.fromDocument(document2);
          if (pageSnapshot.isVisitable) {
            await this.loadFrameResponse(fetchResponse, document2);
          } else {
            await this.handleUnvisitableFrameResponse(fetchResponse);
          }
        }
      } finally {
        this.fetchResponseLoaded = () => {
        };
      }
    }
    elementAppearedInViewport(element) {
      this.proposeVisitIfNavigatedWithAction(element, element);
      this.loadSourceURL();
    }
    willSubmitFormLinkToLocation(link) {
      return this.shouldInterceptNavigation(link);
    }
    submittedFormLinkToLocation(link, _location, form) {
      const frame = this.findFrameElement(link);
      if (frame)
        form.setAttribute("data-turbo-frame", frame.id);
    }
    shouldInterceptLinkClick(element, _location, _event) {
      return this.shouldInterceptNavigation(element);
    }
    linkClickIntercepted(element, location2) {
      this.navigateFrame(element, location2);
    }
    willSubmitForm(element, submitter) {
      return element.closest("turbo-frame") == this.element && this.shouldInterceptNavigation(element, submitter);
    }
    formSubmitted(element, submitter) {
      if (this.formSubmission) {
        this.formSubmission.stop();
      }
      this.formSubmission = new FormSubmission(this, element, submitter);
      const { fetchRequest } = this.formSubmission;
      this.prepareRequest(fetchRequest);
      this.formSubmission.start();
    }
    prepareRequest(request) {
      var _a;
      request.headers["Turbo-Frame"] = this.id;
      if ((_a = this.currentNavigationElement) === null || _a === void 0 ? void 0 : _a.hasAttribute("data-turbo-stream")) {
        request.acceptResponseType(StreamMessage.contentType);
      }
    }
    requestStarted(_request) {
      markAsBusy(this.element);
    }
    requestPreventedHandlingResponse(_request, _response) {
      this.resolveVisitPromise();
    }
    async requestSucceededWithResponse(request, response) {
      await this.loadResponse(response);
      this.resolveVisitPromise();
    }
    async requestFailedWithResponse(request, response) {
      await this.loadResponse(response);
      this.resolveVisitPromise();
    }
    requestErrored(request, error) {
      console.error(error);
      this.resolveVisitPromise();
    }
    requestFinished(_request) {
      clearBusyState(this.element);
    }
    formSubmissionStarted({ formElement }) {
      markAsBusy(formElement, this.findFrameElement(formElement));
    }
    formSubmissionSucceededWithResponse(formSubmission, response) {
      const frame = this.findFrameElement(formSubmission.formElement, formSubmission.submitter);
      frame.delegate.proposeVisitIfNavigatedWithAction(frame, formSubmission.formElement, formSubmission.submitter);
      frame.delegate.loadResponse(response);
      if (!formSubmission.isSafe) {
        session.clearCache();
      }
    }
    formSubmissionFailedWithResponse(formSubmission, fetchResponse) {
      this.element.delegate.loadResponse(fetchResponse);
      session.clearCache();
    }
    formSubmissionErrored(formSubmission, error) {
      console.error(error);
    }
    formSubmissionFinished({ formElement }) {
      clearBusyState(formElement, this.findFrameElement(formElement));
    }
    allowsImmediateRender({ element: newFrame }, options) {
      const event = dispatch("turbo:before-frame-render", {
        target: this.element,
        detail: Object.assign({ newFrame }, options),
        cancelable: true
      });
      const { defaultPrevented, detail: { render } } = event;
      if (this.view.renderer && render) {
        this.view.renderer.renderElement = render;
      }
      return !defaultPrevented;
    }
    viewRenderedSnapshot(_snapshot, _isPreview) {
    }
    preloadOnLoadLinksForView(element) {
      session.preloadOnLoadLinksForView(element);
    }
    viewInvalidated() {
    }
    willRenderFrame(currentElement, _newElement) {
      this.previousFrameElement = currentElement.cloneNode(true);
    }
    async loadFrameResponse(fetchResponse, document2) {
      const newFrameElement = await this.extractForeignFrameElement(document2.body);
      if (newFrameElement) {
        const snapshot = new Snapshot(newFrameElement);
        const renderer = new FrameRenderer(this, this.view.snapshot, snapshot, FrameRenderer.renderElement, false, false);
        if (this.view.renderPromise)
          await this.view.renderPromise;
        this.changeHistory();
        await this.view.render(renderer);
        this.complete = true;
        session.frameRendered(fetchResponse, this.element);
        session.frameLoaded(this.element);
        this.fetchResponseLoaded(fetchResponse);
      } else if (this.willHandleFrameMissingFromResponse(fetchResponse)) {
        this.handleFrameMissingFromResponse(fetchResponse);
      }
    }
    async visit(url) {
      var _a;
      const request = new FetchRequest(this, FetchMethod.get, url, new URLSearchParams(), this.element);
      (_a = this.currentFetchRequest) === null || _a === void 0 ? void 0 : _a.cancel();
      this.currentFetchRequest = request;
      return new Promise((resolve) => {
        this.resolveVisitPromise = () => {
          this.resolveVisitPromise = () => {
          };
          this.currentFetchRequest = null;
          resolve();
        };
        request.perform();
      });
    }
    navigateFrame(element, url, submitter) {
      const frame = this.findFrameElement(element, submitter);
      frame.delegate.proposeVisitIfNavigatedWithAction(frame, element, submitter);
      this.withCurrentNavigationElement(element, () => {
        frame.src = url;
      });
    }
    proposeVisitIfNavigatedWithAction(frame, element, submitter) {
      this.action = getVisitAction(submitter, element, frame);
      if (this.action) {
        const pageSnapshot = PageSnapshot.fromElement(frame).clone();
        const { visitCachedSnapshot } = frame.delegate;
        frame.delegate.fetchResponseLoaded = (fetchResponse) => {
          if (frame.src) {
            const { statusCode, redirected } = fetchResponse;
            const responseHTML = frame.ownerDocument.documentElement.outerHTML;
            const response = { statusCode, redirected, responseHTML };
            const options = {
              response,
              visitCachedSnapshot,
              willRender: false,
              updateHistory: false,
              restorationIdentifier: this.restorationIdentifier,
              snapshot: pageSnapshot
            };
            if (this.action)
              options.action = this.action;
            session.visit(frame.src, options);
          }
        };
      }
    }
    changeHistory() {
      if (this.action) {
        const method = getHistoryMethodForAction(this.action);
        session.history.update(method, expandURL(this.element.src || ""), this.restorationIdentifier);
      }
    }
    async handleUnvisitableFrameResponse(fetchResponse) {
      console.warn(`The response (${fetchResponse.statusCode}) from <turbo-frame id="${this.element.id}"> is performing a full page visit due to turbo-visit-control.`);
      await this.visitResponse(fetchResponse.response);
    }
    willHandleFrameMissingFromResponse(fetchResponse) {
      this.element.setAttribute("complete", "");
      const response = fetchResponse.response;
      const visit2 = async (url, options = {}) => {
        if (url instanceof Response) {
          this.visitResponse(url);
        } else {
          session.visit(url, options);
        }
      };
      const event = dispatch("turbo:frame-missing", {
        target: this.element,
        detail: { response, visit: visit2 },
        cancelable: true
      });
      return !event.defaultPrevented;
    }
    handleFrameMissingFromResponse(fetchResponse) {
      this.view.missing();
      this.throwFrameMissingError(fetchResponse);
    }
    throwFrameMissingError(fetchResponse) {
      const message = `The response (${fetchResponse.statusCode}) did not contain the expected <turbo-frame id="${this.element.id}"> and will be ignored. To perform a full page visit instead, set turbo-visit-control to reload.`;
      throw new TurboFrameMissingError(message);
    }
    async visitResponse(response) {
      const wrapped = new FetchResponse(response);
      const responseHTML = await wrapped.responseHTML;
      const { location: location2, redirected, statusCode } = wrapped;
      return session.visit(location2, { response: { redirected, statusCode, responseHTML } });
    }
    findFrameElement(element, submitter) {
      var _a;
      const id = getAttribute("data-turbo-frame", submitter, element) || this.element.getAttribute("target");
      return (_a = getFrameElementById(id)) !== null && _a !== void 0 ? _a : this.element;
    }
    async extractForeignFrameElement(container) {
      let element;
      const id = CSS.escape(this.id);
      try {
        element = activateElement(container.querySelector(`turbo-frame#${id}`), this.sourceURL);
        if (element) {
          return element;
        }
        element = activateElement(container.querySelector(`turbo-frame[src][recurse~=${id}]`), this.sourceURL);
        if (element) {
          await element.loaded;
          return await this.extractForeignFrameElement(element);
        }
      } catch (error) {
        console.error(error);
        return new FrameElement();
      }
      return null;
    }
    formActionIsVisitable(form, submitter) {
      const action = getAction(form, submitter);
      return locationIsVisitable(expandURL(action), this.rootLocation);
    }
    shouldInterceptNavigation(element, submitter) {
      const id = getAttribute("data-turbo-frame", submitter, element) || this.element.getAttribute("target");
      if (element instanceof HTMLFormElement && !this.formActionIsVisitable(element, submitter)) {
        return false;
      }
      if (!this.enabled || id == "_top") {
        return false;
      }
      if (id) {
        const frameElement = getFrameElementById(id);
        if (frameElement) {
          return !frameElement.disabled;
        }
      }
      if (!session.elementIsNavigatable(element)) {
        return false;
      }
      if (submitter && !session.elementIsNavigatable(submitter)) {
        return false;
      }
      return true;
    }
    get id() {
      return this.element.id;
    }
    get enabled() {
      return !this.element.disabled;
    }
    get sourceURL() {
      if (this.element.src) {
        return this.element.src;
      }
    }
    set sourceURL(sourceURL) {
      this.ignoringChangesToAttribute("src", () => {
        this.element.src = sourceURL !== null && sourceURL !== void 0 ? sourceURL : null;
      });
    }
    get loadingStyle() {
      return this.element.loading;
    }
    get isLoading() {
      return this.formSubmission !== void 0 || this.resolveVisitPromise() !== void 0;
    }
    get complete() {
      return this.element.hasAttribute("complete");
    }
    set complete(value) {
      this.ignoringChangesToAttribute("complete", () => {
        if (value) {
          this.element.setAttribute("complete", "");
        } else {
          this.element.removeAttribute("complete");
        }
      });
    }
    get isActive() {
      return this.element.isActive && this.connected;
    }
    get rootLocation() {
      var _a;
      const meta = this.element.ownerDocument.querySelector(`meta[name="turbo-root"]`);
      const root = (_a = meta === null || meta === void 0 ? void 0 : meta.content) !== null && _a !== void 0 ? _a : "/";
      return expandURL(root);
    }
    isIgnoringChangesTo(attributeName) {
      return this.ignoredAttributes.has(attributeName);
    }
    ignoringChangesToAttribute(attributeName, callback) {
      this.ignoredAttributes.add(attributeName);
      callback();
      this.ignoredAttributes.delete(attributeName);
    }
    withCurrentNavigationElement(element, callback) {
      this.currentNavigationElement = element;
      callback();
      delete this.currentNavigationElement;
    }
  };
  function getFrameElementById(id) {
    if (id != null) {
      const element = document.getElementById(id);
      if (element instanceof FrameElement) {
        return element;
      }
    }
  }
  function activateElement(element, currentURL) {
    if (element) {
      const src = element.getAttribute("src");
      if (src != null && currentURL != null && urlsAreEqual(src, currentURL)) {
        throw new Error(`Matching <turbo-frame id="${element.id}"> element has a source URL which references itself`);
      }
      if (element.ownerDocument !== document) {
        element = document.importNode(element, true);
      }
      if (element instanceof FrameElement) {
        element.connectedCallback();
        element.disconnectedCallback();
        return element;
      }
    }
  }
  var StreamElement = class _StreamElement extends HTMLElement {
    static async renderElement(newElement) {
      await newElement.performAction();
    }
    async connectedCallback() {
      try {
        await this.render();
      } catch (error) {
        console.error(error);
      } finally {
        this.disconnect();
      }
    }
    async render() {
      var _a;
      return (_a = this.renderPromise) !== null && _a !== void 0 ? _a : this.renderPromise = (async () => {
        const event = this.beforeRenderEvent;
        if (this.dispatchEvent(event)) {
          await nextAnimationFrame();
          await event.detail.render(this);
        }
      })();
    }
    disconnect() {
      try {
        this.remove();
      } catch (_a) {
      }
    }
    removeDuplicateTargetChildren() {
      this.duplicateChildren.forEach((c) => c.remove());
    }
    get duplicateChildren() {
      var _a;
      const existingChildren = this.targetElements.flatMap((e) => [...e.children]).filter((c) => !!c.id);
      const newChildrenIds = [...((_a = this.templateContent) === null || _a === void 0 ? void 0 : _a.children) || []].filter((c) => !!c.id).map((c) => c.id);
      return existingChildren.filter((c) => newChildrenIds.includes(c.id));
    }
    get performAction() {
      if (this.action) {
        const actionFunction = StreamActions[this.action];
        if (actionFunction) {
          return actionFunction;
        }
        this.raise("unknown action");
      }
      this.raise("action attribute is missing");
    }
    get targetElements() {
      if (this.target) {
        return this.targetElementsById;
      } else if (this.targets) {
        return this.targetElementsByQuery;
      } else {
        this.raise("target or targets attribute is missing");
      }
    }
    get templateContent() {
      return this.templateElement.content.cloneNode(true);
    }
    get templateElement() {
      if (this.firstElementChild === null) {
        const template = this.ownerDocument.createElement("template");
        this.appendChild(template);
        return template;
      } else if (this.firstElementChild instanceof HTMLTemplateElement) {
        return this.firstElementChild;
      }
      this.raise("first child element must be a <template> element");
    }
    get action() {
      return this.getAttribute("action");
    }
    get target() {
      return this.getAttribute("target");
    }
    get targets() {
      return this.getAttribute("targets");
    }
    raise(message) {
      throw new Error(`${this.description}: ${message}`);
    }
    get description() {
      var _a, _b;
      return (_b = ((_a = this.outerHTML.match(/<[^>]+>/)) !== null && _a !== void 0 ? _a : [])[0]) !== null && _b !== void 0 ? _b : "<turbo-stream>";
    }
    get beforeRenderEvent() {
      return new CustomEvent("turbo:before-stream-render", {
        bubbles: true,
        cancelable: true,
        detail: { newStream: this, render: _StreamElement.renderElement }
      });
    }
    get targetElementsById() {
      var _a;
      const element = (_a = this.ownerDocument) === null || _a === void 0 ? void 0 : _a.getElementById(this.target);
      if (element !== null) {
        return [element];
      } else {
        return [];
      }
    }
    get targetElementsByQuery() {
      var _a;
      const elements = (_a = this.ownerDocument) === null || _a === void 0 ? void 0 : _a.querySelectorAll(this.targets);
      if (elements.length !== 0) {
        return Array.prototype.slice.call(elements);
      } else {
        return [];
      }
    }
  };
  var StreamSourceElement = class extends HTMLElement {
    constructor() {
      super(...arguments);
      this.streamSource = null;
    }
    connectedCallback() {
      this.streamSource = this.src.match(/^ws{1,2}:/) ? new WebSocket(this.src) : new EventSource(this.src);
      connectStreamSource(this.streamSource);
    }
    disconnectedCallback() {
      if (this.streamSource) {
        disconnectStreamSource(this.streamSource);
      }
    }
    get src() {
      return this.getAttribute("src") || "";
    }
  };
  FrameElement.delegateConstructor = FrameController;
  if (customElements.get("turbo-frame") === void 0) {
    customElements.define("turbo-frame", FrameElement);
  }
  if (customElements.get("turbo-stream") === void 0) {
    customElements.define("turbo-stream", StreamElement);
  }
  if (customElements.get("turbo-stream-source") === void 0) {
    customElements.define("turbo-stream-source", StreamSourceElement);
  }
  (() => {
    let element = document.currentScript;
    if (!element)
      return;
    if (element.hasAttribute("data-turbo-suppress-warning"))
      return;
    element = element.parentElement;
    while (element) {
      if (element == document.body) {
        return console.warn(unindent`
        You are loading Turbo from a <script> element inside the <body> element. This is probably not what you meant to do!

        Load your application’s JavaScript bundle inside the <head> element instead. <script> elements in <body> are evaluated with each page change.

        For more information, see: https://turbo.hotwired.dev/handbook/building#working-with-script-elements

        ——
        Suppress this warning by adding a "data-turbo-suppress-warning" attribute to: %s
      `, element.outerHTML);
      }
      element = element.parentElement;
    }
  })();
  window.Turbo = Turbo;
  start();

  // node_modules/@hotwired/turbo-rails/app/javascript/turbo/cable.js
  var consumer;
  async function getConsumer() {
    return consumer || setConsumer(createConsumer2().then(setConsumer));
  }
  function setConsumer(newConsumer) {
    return consumer = newConsumer;
  }
  async function createConsumer2() {
    const { createConsumer: createConsumer3 } = await Promise.resolve().then(() => (init_src(), src_exports));
    return createConsumer3();
  }
  async function subscribeTo(channel, mixin) {
    const { subscriptions } = await getConsumer();
    return subscriptions.create(channel, mixin);
  }

  // node_modules/@hotwired/turbo-rails/app/javascript/turbo/snakeize.js
  function walk(obj) {
    if (!obj || typeof obj !== "object") return obj;
    if (obj instanceof Date || obj instanceof RegExp) return obj;
    if (Array.isArray(obj)) return obj.map(walk);
    return Object.keys(obj).reduce(function(acc, key) {
      var camel = key[0].toLowerCase() + key.slice(1).replace(/([A-Z]+)/g, function(m, x) {
        return "_" + x.toLowerCase();
      });
      acc[camel] = walk(obj[key]);
      return acc;
    }, {});
  }

  // node_modules/@hotwired/turbo-rails/app/javascript/turbo/cable_stream_source_element.js
  var TurboCableStreamSourceElement = class extends HTMLElement {
    async connectedCallback() {
      connectStreamSource(this);
      this.subscription = await subscribeTo(this.channel, {
        received: this.dispatchMessageEvent.bind(this),
        connected: this.subscriptionConnected.bind(this),
        disconnected: this.subscriptionDisconnected.bind(this)
      });
    }
    disconnectedCallback() {
      disconnectStreamSource(this);
      if (this.subscription) this.subscription.unsubscribe();
    }
    dispatchMessageEvent(data) {
      const event = new MessageEvent("message", { data });
      return this.dispatchEvent(event);
    }
    subscriptionConnected() {
      this.setAttribute("connected", "");
    }
    subscriptionDisconnected() {
      this.removeAttribute("connected");
    }
    get channel() {
      const channel = this.getAttribute("channel");
      const signed_stream_name = this.getAttribute("signed-stream-name");
      return { channel, signed_stream_name, ...walk({ ...this.dataset }) };
    }
  };
  if (customElements.get("turbo-cable-stream-source") === void 0) {
    customElements.define("turbo-cable-stream-source", TurboCableStreamSourceElement);
  }

  // node_modules/@hotwired/turbo-rails/app/javascript/turbo/fetch_requests.js
  function encodeMethodIntoRequestBody(event) {
    if (event.target instanceof HTMLFormElement) {
      const { target: form, detail: { fetchOptions } } = event;
      form.addEventListener("turbo:submit-start", ({ detail: { formSubmission: { submitter } } }) => {
        const body = isBodyInit(fetchOptions.body) ? fetchOptions.body : new URLSearchParams();
        const method = determineFetchMethod(submitter, body, form);
        if (!/get/i.test(method)) {
          if (/post/i.test(method)) {
            body.delete("_method");
          } else {
            body.set("_method", method);
          }
          fetchOptions.method = "post";
        }
      }, { once: true });
    }
  }
  function determineFetchMethod(submitter, body, form) {
    const formMethod = determineFormMethod(submitter);
    const overrideMethod = body.get("_method");
    const method = form.getAttribute("method") || "get";
    if (typeof formMethod == "string") {
      return formMethod;
    } else if (typeof overrideMethod == "string") {
      return overrideMethod;
    } else {
      return method;
    }
  }
  function determineFormMethod(submitter) {
    if (submitter instanceof HTMLButtonElement || submitter instanceof HTMLInputElement) {
      if (submitter.hasAttribute("formmethod")) {
        return submitter.formMethod;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
  function isBodyInit(body) {
    return body instanceof FormData || body instanceof URLSearchParams;
  }

  // node_modules/@hotwired/turbo-rails/app/javascript/turbo/index.js
  addEventListener("turbo:before-fetch-request", encodeMethodIntoRequestBody);

  // node_modules/rails_admin/src/rails_admin/jquery.js
  var import_jquery = __toESM(require_jquery());
  window.$ = window.jQuery = import_jquery.default;

  // node_modules/rails_admin/src/rails_admin/vendor/jquery_nested_form.js
  var import_jquery2 = __toESM(require_jquery());
  (function($) {
    window.NestedFormEvents = function() {
      this.addFields = $.proxy(this.addFields, this);
      this.removeFields = $.proxy(this.removeFields, this);
    };
    NestedFormEvents.prototype = {
      addFields: function(e) {
        var link = e.currentTarget;
        var assoc = $(link).data("association");
        var blueprint = $("#" + $(link).data("blueprint-id"));
        var content = blueprint.data("blueprint");
        var context = ($(link).closest(".fields").closestChild("input, textarea, select").eq(0).attr("name") || "").replace(/\[[a-z_]+\]$/, "");
        var current = content.match(new RegExp("\\[([a-z_]+)\\]\\[new_" + assoc + "\\]"));
        if (current) {
          context = context.replace(new RegExp("\\[" + current[1] + "\\]\\[(new_)?\\d+\\]$"), "");
        }
        if (context) {
          var parentNames = context.match(/[a-z_]+_attributes(?=\]\[(new_)?\d+\])/g) || [];
          var parentIds = context.match(/[0-9]+/g) || [];
          for (var i = 0; i < parentNames.length; i++) {
            if (parentIds[i]) {
              content = content.replace(
                new RegExp("(_" + parentNames[i] + ")_.+?_", "g"),
                "$1_" + parentIds[i] + "_"
              );
              content = content.replace(
                new RegExp("(\\[" + parentNames[i] + "\\])\\[.+?\\]", "g"),
                "$1[" + parentIds[i] + "]"
              );
            }
          }
        }
        var regexp = new RegExp("new_" + assoc, "g");
        var new_id = this.newId();
        content = $.trim(content.replace(regexp, new_id));
        var field = this.insertFields(content, assoc, link);
        field.trigger({ type: "nested:fieldAdded", field }).trigger({ type: "nested:fieldAdded:" + assoc, field });
        return false;
      },
      newId: function() {
        return (/* @__PURE__ */ new Date()).getTime();
      },
      insertFields: function(content, assoc, link) {
        var target = $(link).data("target");
        if (target) {
          return $(content).appendTo($(target));
        } else {
          return $(content).insertBefore(link);
        }
      },
      removeFields: function(e) {
        var $link = $(e.currentTarget), assoc = $link.data("association");
        var hiddenField = $link.prev("input[type=hidden]");
        hiddenField.val("1");
        var field = $link.closest(".fields");
        field.hide();
        field.trigger({ type: "nested:fieldRemoved", field }).trigger({ type: "nested:fieldRemoved:" + assoc, field });
        return false;
      }
    };
    window.nestedFormEvents = new NestedFormEvents();
    $(document).delegate("form a.add_nested_fields", "click", nestedFormEvents.addFields).delegate("form a.remove_nested_fields", "click", nestedFormEvents.removeFields);
  })(import_jquery2.default);
  (function($) {
    $.fn.closestChild = function(selector) {
      if (selector && selector != "") {
        var queue = [];
        queue.push(this);
        while (queue.length > 0) {
          var node = queue.shift();
          var children = node.children();
          for (var i = 0; i < children.length; ++i) {
            var child = $(children[i]);
            if (child.is(selector)) {
              return child;
            }
            queue.push(child);
          }
        }
      }
      return $();
    };
  })(import_jquery2.default);

  // node_modules/@popperjs/core/lib/index.js
  var lib_exports = {};
  __export(lib_exports, {
    afterMain: () => afterMain,
    afterRead: () => afterRead,
    afterWrite: () => afterWrite,
    applyStyles: () => applyStyles_default,
    arrow: () => arrow_default,
    auto: () => auto,
    basePlacements: () => basePlacements,
    beforeMain: () => beforeMain,
    beforeRead: () => beforeRead,
    beforeWrite: () => beforeWrite,
    bottom: () => bottom,
    clippingParents: () => clippingParents,
    computeStyles: () => computeStyles_default,
    createPopper: () => createPopper3,
    createPopperBase: () => createPopper,
    createPopperLite: () => createPopper2,
    detectOverflow: () => detectOverflow,
    end: () => end,
    eventListeners: () => eventListeners_default,
    flip: () => flip_default,
    hide: () => hide_default,
    left: () => left,
    main: () => main,
    modifierPhases: () => modifierPhases,
    offset: () => offset_default,
    placements: () => placements,
    popper: () => popper,
    popperGenerator: () => popperGenerator,
    popperOffsets: () => popperOffsets_default,
    preventOverflow: () => preventOverflow_default,
    read: () => read,
    reference: () => reference,
    right: () => right,
    start: () => start2,
    top: () => top,
    variationPlacements: () => variationPlacements,
    viewport: () => viewport,
    write: () => write
  });

  // node_modules/@popperjs/core/lib/enums.js
  var top = "top";
  var bottom = "bottom";
  var right = "right";
  var left = "left";
  var auto = "auto";
  var basePlacements = [top, bottom, right, left];
  var start2 = "start";
  var end = "end";
  var clippingParents = "clippingParents";
  var viewport = "viewport";
  var popper = "popper";
  var reference = "reference";
  var variationPlacements = /* @__PURE__ */ basePlacements.reduce(function(acc, placement) {
    return acc.concat([placement + "-" + start2, placement + "-" + end]);
  }, []);
  var placements = /* @__PURE__ */ [].concat(basePlacements, [auto]).reduce(function(acc, placement) {
    return acc.concat([placement, placement + "-" + start2, placement + "-" + end]);
  }, []);
  var beforeRead = "beforeRead";
  var read = "read";
  var afterRead = "afterRead";
  var beforeMain = "beforeMain";
  var main = "main";
  var afterMain = "afterMain";
  var beforeWrite = "beforeWrite";
  var write = "write";
  var afterWrite = "afterWrite";
  var modifierPhases = [beforeRead, read, afterRead, beforeMain, main, afterMain, beforeWrite, write, afterWrite];

  // node_modules/@popperjs/core/lib/dom-utils/getNodeName.js
  function getNodeName(element) {
    return element ? (element.nodeName || "").toLowerCase() : null;
  }

  // node_modules/@popperjs/core/lib/dom-utils/getWindow.js
  function getWindow(node) {
    if (node == null) {
      return window;
    }
    if (node.toString() !== "[object Window]") {
      var ownerDocument = node.ownerDocument;
      return ownerDocument ? ownerDocument.defaultView || window : window;
    }
    return node;
  }

  // node_modules/@popperjs/core/lib/dom-utils/instanceOf.js
  function isElement(node) {
    var OwnElement = getWindow(node).Element;
    return node instanceof OwnElement || node instanceof Element;
  }
  function isHTMLElement(node) {
    var OwnElement = getWindow(node).HTMLElement;
    return node instanceof OwnElement || node instanceof HTMLElement;
  }
  function isShadowRoot(node) {
    if (typeof ShadowRoot === "undefined") {
      return false;
    }
    var OwnElement = getWindow(node).ShadowRoot;
    return node instanceof OwnElement || node instanceof ShadowRoot;
  }

  // node_modules/@popperjs/core/lib/modifiers/applyStyles.js
  function applyStyles(_ref) {
    var state = _ref.state;
    Object.keys(state.elements).forEach(function(name) {
      var style = state.styles[name] || {};
      var attributes = state.attributes[name] || {};
      var element = state.elements[name];
      if (!isHTMLElement(element) || !getNodeName(element)) {
        return;
      }
      Object.assign(element.style, style);
      Object.keys(attributes).forEach(function(name2) {
        var value = attributes[name2];
        if (value === false) {
          element.removeAttribute(name2);
        } else {
          element.setAttribute(name2, value === true ? "" : value);
        }
      });
    });
  }
  function effect(_ref2) {
    var state = _ref2.state;
    var initialStyles = {
      popper: {
        position: state.options.strategy,
        left: "0",
        top: "0",
        margin: "0"
      },
      arrow: {
        position: "absolute"
      },
      reference: {}
    };
    Object.assign(state.elements.popper.style, initialStyles.popper);
    state.styles = initialStyles;
    if (state.elements.arrow) {
      Object.assign(state.elements.arrow.style, initialStyles.arrow);
    }
    return function() {
      Object.keys(state.elements).forEach(function(name) {
        var element = state.elements[name];
        var attributes = state.attributes[name] || {};
        var styleProperties = Object.keys(state.styles.hasOwnProperty(name) ? state.styles[name] : initialStyles[name]);
        var style = styleProperties.reduce(function(style2, property) {
          style2[property] = "";
          return style2;
        }, {});
        if (!isHTMLElement(element) || !getNodeName(element)) {
          return;
        }
        Object.assign(element.style, style);
        Object.keys(attributes).forEach(function(attribute) {
          element.removeAttribute(attribute);
        });
      });
    };
  }
  var applyStyles_default = {
    name: "applyStyles",
    enabled: true,
    phase: "write",
    fn: applyStyles,
    effect,
    requires: ["computeStyles"]
  };

  // node_modules/@popperjs/core/lib/utils/getBasePlacement.js
  function getBasePlacement(placement) {
    return placement.split("-")[0];
  }

  // node_modules/@popperjs/core/lib/utils/math.js
  var max = Math.max;
  var min = Math.min;
  var round = Math.round;

  // node_modules/@popperjs/core/lib/utils/userAgent.js
  function getUAString() {
    var uaData = navigator.userAgentData;
    if (uaData != null && uaData.brands && Array.isArray(uaData.brands)) {
      return uaData.brands.map(function(item) {
        return item.brand + "/" + item.version;
      }).join(" ");
    }
    return navigator.userAgent;
  }

  // node_modules/@popperjs/core/lib/dom-utils/isLayoutViewport.js
  function isLayoutViewport() {
    return !/^((?!chrome|android).)*safari/i.test(getUAString());
  }

  // node_modules/@popperjs/core/lib/dom-utils/getBoundingClientRect.js
  function getBoundingClientRect(element, includeScale, isFixedStrategy) {
    if (includeScale === void 0) {
      includeScale = false;
    }
    if (isFixedStrategy === void 0) {
      isFixedStrategy = false;
    }
    var clientRect = element.getBoundingClientRect();
    var scaleX = 1;
    var scaleY = 1;
    if (includeScale && isHTMLElement(element)) {
      scaleX = element.offsetWidth > 0 ? round(clientRect.width) / element.offsetWidth || 1 : 1;
      scaleY = element.offsetHeight > 0 ? round(clientRect.height) / element.offsetHeight || 1 : 1;
    }
    var _ref = isElement(element) ? getWindow(element) : window, visualViewport = _ref.visualViewport;
    var addVisualOffsets = !isLayoutViewport() && isFixedStrategy;
    var x = (clientRect.left + (addVisualOffsets && visualViewport ? visualViewport.offsetLeft : 0)) / scaleX;
    var y = (clientRect.top + (addVisualOffsets && visualViewport ? visualViewport.offsetTop : 0)) / scaleY;
    var width = clientRect.width / scaleX;
    var height = clientRect.height / scaleY;
    return {
      width,
      height,
      top: y,
      right: x + width,
      bottom: y + height,
      left: x,
      x,
      y
    };
  }

  // node_modules/@popperjs/core/lib/dom-utils/getLayoutRect.js
  function getLayoutRect(element) {
    var clientRect = getBoundingClientRect(element);
    var width = element.offsetWidth;
    var height = element.offsetHeight;
    if (Math.abs(clientRect.width - width) <= 1) {
      width = clientRect.width;
    }
    if (Math.abs(clientRect.height - height) <= 1) {
      height = clientRect.height;
    }
    return {
      x: element.offsetLeft,
      y: element.offsetTop,
      width,
      height
    };
  }

  // node_modules/@popperjs/core/lib/dom-utils/contains.js
  function contains(parent, child) {
    var rootNode = child.getRootNode && child.getRootNode();
    if (parent.contains(child)) {
      return true;
    } else if (rootNode && isShadowRoot(rootNode)) {
      var next = child;
      do {
        if (next && parent.isSameNode(next)) {
          return true;
        }
        next = next.parentNode || next.host;
      } while (next);
    }
    return false;
  }

  // node_modules/@popperjs/core/lib/dom-utils/getComputedStyle.js
  function getComputedStyle2(element) {
    return getWindow(element).getComputedStyle(element);
  }

  // node_modules/@popperjs/core/lib/dom-utils/isTableElement.js
  function isTableElement(element) {
    return ["table", "td", "th"].indexOf(getNodeName(element)) >= 0;
  }

  // node_modules/@popperjs/core/lib/dom-utils/getDocumentElement.js
  function getDocumentElement(element) {
    return ((isElement(element) ? element.ownerDocument : (
      // $FlowFixMe[prop-missing]
      element.document
    )) || window.document).documentElement;
  }

  // node_modules/@popperjs/core/lib/dom-utils/getParentNode.js
  function getParentNode(element) {
    if (getNodeName(element) === "html") {
      return element;
    }
    return (
      // this is a quicker (but less type safe) way to save quite some bytes from the bundle
      // $FlowFixMe[incompatible-return]
      // $FlowFixMe[prop-missing]
      element.assignedSlot || // step into the shadow DOM of the parent of a slotted node
      element.parentNode || // DOM Element detected
      (isShadowRoot(element) ? element.host : null) || // ShadowRoot detected
      // $FlowFixMe[incompatible-call]: HTMLElement is a Node
      getDocumentElement(element)
    );
  }

  // node_modules/@popperjs/core/lib/dom-utils/getOffsetParent.js
  function getTrueOffsetParent(element) {
    if (!isHTMLElement(element) || // https://github.com/popperjs/popper-core/issues/837
    getComputedStyle2(element).position === "fixed") {
      return null;
    }
    return element.offsetParent;
  }
  function getContainingBlock(element) {
    var isFirefox = /firefox/i.test(getUAString());
    var isIE = /Trident/i.test(getUAString());
    if (isIE && isHTMLElement(element)) {
      var elementCss = getComputedStyle2(element);
      if (elementCss.position === "fixed") {
        return null;
      }
    }
    var currentNode = getParentNode(element);
    if (isShadowRoot(currentNode)) {
      currentNode = currentNode.host;
    }
    while (isHTMLElement(currentNode) && ["html", "body"].indexOf(getNodeName(currentNode)) < 0) {
      var css = getComputedStyle2(currentNode);
      if (css.transform !== "none" || css.perspective !== "none" || css.contain === "paint" || ["transform", "perspective"].indexOf(css.willChange) !== -1 || isFirefox && css.willChange === "filter" || isFirefox && css.filter && css.filter !== "none") {
        return currentNode;
      } else {
        currentNode = currentNode.parentNode;
      }
    }
    return null;
  }
  function getOffsetParent(element) {
    var window2 = getWindow(element);
    var offsetParent = getTrueOffsetParent(element);
    while (offsetParent && isTableElement(offsetParent) && getComputedStyle2(offsetParent).position === "static") {
      offsetParent = getTrueOffsetParent(offsetParent);
    }
    if (offsetParent && (getNodeName(offsetParent) === "html" || getNodeName(offsetParent) === "body" && getComputedStyle2(offsetParent).position === "static")) {
      return window2;
    }
    return offsetParent || getContainingBlock(element) || window2;
  }

  // node_modules/@popperjs/core/lib/utils/getMainAxisFromPlacement.js
  function getMainAxisFromPlacement(placement) {
    return ["top", "bottom"].indexOf(placement) >= 0 ? "x" : "y";
  }

  // node_modules/@popperjs/core/lib/utils/within.js
  function within(min2, value, max2) {
    return max(min2, min(value, max2));
  }
  function withinMaxClamp(min2, value, max2) {
    var v = within(min2, value, max2);
    return v > max2 ? max2 : v;
  }

  // node_modules/@popperjs/core/lib/utils/getFreshSideObject.js
  function getFreshSideObject() {
    return {
      top: 0,
      right: 0,
      bottom: 0,
      left: 0
    };
  }

  // node_modules/@popperjs/core/lib/utils/mergePaddingObject.js
  function mergePaddingObject(paddingObject) {
    return Object.assign({}, getFreshSideObject(), paddingObject);
  }

  // node_modules/@popperjs/core/lib/utils/expandToHashMap.js
  function expandToHashMap(value, keys) {
    return keys.reduce(function(hashMap, key) {
      hashMap[key] = value;
      return hashMap;
    }, {});
  }

  // node_modules/@popperjs/core/lib/modifiers/arrow.js
  var toPaddingObject = function toPaddingObject2(padding, state) {
    padding = typeof padding === "function" ? padding(Object.assign({}, state.rects, {
      placement: state.placement
    })) : padding;
    return mergePaddingObject(typeof padding !== "number" ? padding : expandToHashMap(padding, basePlacements));
  };
  function arrow(_ref) {
    var _state$modifiersData$;
    var state = _ref.state, name = _ref.name, options = _ref.options;
    var arrowElement = state.elements.arrow;
    var popperOffsets2 = state.modifiersData.popperOffsets;
    var basePlacement = getBasePlacement(state.placement);
    var axis = getMainAxisFromPlacement(basePlacement);
    var isVertical = [left, right].indexOf(basePlacement) >= 0;
    var len = isVertical ? "height" : "width";
    if (!arrowElement || !popperOffsets2) {
      return;
    }
    var paddingObject = toPaddingObject(options.padding, state);
    var arrowRect = getLayoutRect(arrowElement);
    var minProp = axis === "y" ? top : left;
    var maxProp = axis === "y" ? bottom : right;
    var endDiff = state.rects.reference[len] + state.rects.reference[axis] - popperOffsets2[axis] - state.rects.popper[len];
    var startDiff = popperOffsets2[axis] - state.rects.reference[axis];
    var arrowOffsetParent = getOffsetParent(arrowElement);
    var clientSize = arrowOffsetParent ? axis === "y" ? arrowOffsetParent.clientHeight || 0 : arrowOffsetParent.clientWidth || 0 : 0;
    var centerToReference = endDiff / 2 - startDiff / 2;
    var min2 = paddingObject[minProp];
    var max2 = clientSize - arrowRect[len] - paddingObject[maxProp];
    var center = clientSize / 2 - arrowRect[len] / 2 + centerToReference;
    var offset2 = within(min2, center, max2);
    var axisProp = axis;
    state.modifiersData[name] = (_state$modifiersData$ = {}, _state$modifiersData$[axisProp] = offset2, _state$modifiersData$.centerOffset = offset2 - center, _state$modifiersData$);
  }
  function effect2(_ref2) {
    var state = _ref2.state, options = _ref2.options;
    var _options$element = options.element, arrowElement = _options$element === void 0 ? "[data-popper-arrow]" : _options$element;
    if (arrowElement == null) {
      return;
    }
    if (typeof arrowElement === "string") {
      arrowElement = state.elements.popper.querySelector(arrowElement);
      if (!arrowElement) {
        return;
      }
    }
    if (!contains(state.elements.popper, arrowElement)) {
      return;
    }
    state.elements.arrow = arrowElement;
  }
  var arrow_default = {
    name: "arrow",
    enabled: true,
    phase: "main",
    fn: arrow,
    effect: effect2,
    requires: ["popperOffsets"],
    requiresIfExists: ["preventOverflow"]
  };

  // node_modules/@popperjs/core/lib/utils/getVariation.js
  function getVariation(placement) {
    return placement.split("-")[1];
  }

  // node_modules/@popperjs/core/lib/modifiers/computeStyles.js
  var unsetSides = {
    top: "auto",
    right: "auto",
    bottom: "auto",
    left: "auto"
  };
  function roundOffsetsByDPR(_ref, win) {
    var x = _ref.x, y = _ref.y;
    var dpr = win.devicePixelRatio || 1;
    return {
      x: round(x * dpr) / dpr || 0,
      y: round(y * dpr) / dpr || 0
    };
  }
  function mapToStyles(_ref2) {
    var _Object$assign2;
    var popper2 = _ref2.popper, popperRect = _ref2.popperRect, placement = _ref2.placement, variation = _ref2.variation, offsets = _ref2.offsets, position = _ref2.position, gpuAcceleration = _ref2.gpuAcceleration, adaptive = _ref2.adaptive, roundOffsets = _ref2.roundOffsets, isFixed = _ref2.isFixed;
    var _offsets$x = offsets.x, x = _offsets$x === void 0 ? 0 : _offsets$x, _offsets$y = offsets.y, y = _offsets$y === void 0 ? 0 : _offsets$y;
    var _ref3 = typeof roundOffsets === "function" ? roundOffsets({
      x,
      y
    }) : {
      x,
      y
    };
    x = _ref3.x;
    y = _ref3.y;
    var hasX = offsets.hasOwnProperty("x");
    var hasY = offsets.hasOwnProperty("y");
    var sideX = left;
    var sideY = top;
    var win = window;
    if (adaptive) {
      var offsetParent = getOffsetParent(popper2);
      var heightProp = "clientHeight";
      var widthProp = "clientWidth";
      if (offsetParent === getWindow(popper2)) {
        offsetParent = getDocumentElement(popper2);
        if (getComputedStyle2(offsetParent).position !== "static" && position === "absolute") {
          heightProp = "scrollHeight";
          widthProp = "scrollWidth";
        }
      }
      offsetParent = offsetParent;
      if (placement === top || (placement === left || placement === right) && variation === end) {
        sideY = bottom;
        var offsetY = isFixed && offsetParent === win && win.visualViewport ? win.visualViewport.height : (
          // $FlowFixMe[prop-missing]
          offsetParent[heightProp]
        );
        y -= offsetY - popperRect.height;
        y *= gpuAcceleration ? 1 : -1;
      }
      if (placement === left || (placement === top || placement === bottom) && variation === end) {
        sideX = right;
        var offsetX = isFixed && offsetParent === win && win.visualViewport ? win.visualViewport.width : (
          // $FlowFixMe[prop-missing]
          offsetParent[widthProp]
        );
        x -= offsetX - popperRect.width;
        x *= gpuAcceleration ? 1 : -1;
      }
    }
    var commonStyles = Object.assign({
      position
    }, adaptive && unsetSides);
    var _ref4 = roundOffsets === true ? roundOffsetsByDPR({
      x,
      y
    }, getWindow(popper2)) : {
      x,
      y
    };
    x = _ref4.x;
    y = _ref4.y;
    if (gpuAcceleration) {
      var _Object$assign;
      return Object.assign({}, commonStyles, (_Object$assign = {}, _Object$assign[sideY] = hasY ? "0" : "", _Object$assign[sideX] = hasX ? "0" : "", _Object$assign.transform = (win.devicePixelRatio || 1) <= 1 ? "translate(" + x + "px, " + y + "px)" : "translate3d(" + x + "px, " + y + "px, 0)", _Object$assign));
    }
    return Object.assign({}, commonStyles, (_Object$assign2 = {}, _Object$assign2[sideY] = hasY ? y + "px" : "", _Object$assign2[sideX] = hasX ? x + "px" : "", _Object$assign2.transform = "", _Object$assign2));
  }
  function computeStyles(_ref5) {
    var state = _ref5.state, options = _ref5.options;
    var _options$gpuAccelerat = options.gpuAcceleration, gpuAcceleration = _options$gpuAccelerat === void 0 ? true : _options$gpuAccelerat, _options$adaptive = options.adaptive, adaptive = _options$adaptive === void 0 ? true : _options$adaptive, _options$roundOffsets = options.roundOffsets, roundOffsets = _options$roundOffsets === void 0 ? true : _options$roundOffsets;
    var commonStyles = {
      placement: getBasePlacement(state.placement),
      variation: getVariation(state.placement),
      popper: state.elements.popper,
      popperRect: state.rects.popper,
      gpuAcceleration,
      isFixed: state.options.strategy === "fixed"
    };
    if (state.modifiersData.popperOffsets != null) {
      state.styles.popper = Object.assign({}, state.styles.popper, mapToStyles(Object.assign({}, commonStyles, {
        offsets: state.modifiersData.popperOffsets,
        position: state.options.strategy,
        adaptive,
        roundOffsets
      })));
    }
    if (state.modifiersData.arrow != null) {
      state.styles.arrow = Object.assign({}, state.styles.arrow, mapToStyles(Object.assign({}, commonStyles, {
        offsets: state.modifiersData.arrow,
        position: "absolute",
        adaptive: false,
        roundOffsets
      })));
    }
    state.attributes.popper = Object.assign({}, state.attributes.popper, {
      "data-popper-placement": state.placement
    });
  }
  var computeStyles_default = {
    name: "computeStyles",
    enabled: true,
    phase: "beforeWrite",
    fn: computeStyles,
    data: {}
  };

  // node_modules/@popperjs/core/lib/modifiers/eventListeners.js
  var passive = {
    passive: true
  };
  function effect3(_ref) {
    var state = _ref.state, instance = _ref.instance, options = _ref.options;
    var _options$scroll = options.scroll, scroll = _options$scroll === void 0 ? true : _options$scroll, _options$resize = options.resize, resize = _options$resize === void 0 ? true : _options$resize;
    var window2 = getWindow(state.elements.popper);
    var scrollParents = [].concat(state.scrollParents.reference, state.scrollParents.popper);
    if (scroll) {
      scrollParents.forEach(function(scrollParent) {
        scrollParent.addEventListener("scroll", instance.update, passive);
      });
    }
    if (resize) {
      window2.addEventListener("resize", instance.update, passive);
    }
    return function() {
      if (scroll) {
        scrollParents.forEach(function(scrollParent) {
          scrollParent.removeEventListener("scroll", instance.update, passive);
        });
      }
      if (resize) {
        window2.removeEventListener("resize", instance.update, passive);
      }
    };
  }
  var eventListeners_default = {
    name: "eventListeners",
    enabled: true,
    phase: "write",
    fn: function fn() {
    },
    effect: effect3,
    data: {}
  };

  // node_modules/@popperjs/core/lib/utils/getOppositePlacement.js
  var hash = {
    left: "right",
    right: "left",
    bottom: "top",
    top: "bottom"
  };
  function getOppositePlacement(placement) {
    return placement.replace(/left|right|bottom|top/g, function(matched) {
      return hash[matched];
    });
  }

  // node_modules/@popperjs/core/lib/utils/getOppositeVariationPlacement.js
  var hash2 = {
    start: "end",
    end: "start"
  };
  function getOppositeVariationPlacement(placement) {
    return placement.replace(/start|end/g, function(matched) {
      return hash2[matched];
    });
  }

  // node_modules/@popperjs/core/lib/dom-utils/getWindowScroll.js
  function getWindowScroll(node) {
    var win = getWindow(node);
    var scrollLeft = win.pageXOffset;
    var scrollTop = win.pageYOffset;
    return {
      scrollLeft,
      scrollTop
    };
  }

  // node_modules/@popperjs/core/lib/dom-utils/getWindowScrollBarX.js
  function getWindowScrollBarX(element) {
    return getBoundingClientRect(getDocumentElement(element)).left + getWindowScroll(element).scrollLeft;
  }

  // node_modules/@popperjs/core/lib/dom-utils/getViewportRect.js
  function getViewportRect(element, strategy) {
    var win = getWindow(element);
    var html = getDocumentElement(element);
    var visualViewport = win.visualViewport;
    var width = html.clientWidth;
    var height = html.clientHeight;
    var x = 0;
    var y = 0;
    if (visualViewport) {
      width = visualViewport.width;
      height = visualViewport.height;
      var layoutViewport = isLayoutViewport();
      if (layoutViewport || !layoutViewport && strategy === "fixed") {
        x = visualViewport.offsetLeft;
        y = visualViewport.offsetTop;
      }
    }
    return {
      width,
      height,
      x: x + getWindowScrollBarX(element),
      y
    };
  }

  // node_modules/@popperjs/core/lib/dom-utils/getDocumentRect.js
  function getDocumentRect(element) {
    var _element$ownerDocumen;
    var html = getDocumentElement(element);
    var winScroll = getWindowScroll(element);
    var body = (_element$ownerDocumen = element.ownerDocument) == null ? void 0 : _element$ownerDocumen.body;
    var width = max(html.scrollWidth, html.clientWidth, body ? body.scrollWidth : 0, body ? body.clientWidth : 0);
    var height = max(html.scrollHeight, html.clientHeight, body ? body.scrollHeight : 0, body ? body.clientHeight : 0);
    var x = -winScroll.scrollLeft + getWindowScrollBarX(element);
    var y = -winScroll.scrollTop;
    if (getComputedStyle2(body || html).direction === "rtl") {
      x += max(html.clientWidth, body ? body.clientWidth : 0) - width;
    }
    return {
      width,
      height,
      x,
      y
    };
  }

  // node_modules/@popperjs/core/lib/dom-utils/isScrollParent.js
  function isScrollParent(element) {
    var _getComputedStyle = getComputedStyle2(element), overflow = _getComputedStyle.overflow, overflowX = _getComputedStyle.overflowX, overflowY = _getComputedStyle.overflowY;
    return /auto|scroll|overlay|hidden/.test(overflow + overflowY + overflowX);
  }

  // node_modules/@popperjs/core/lib/dom-utils/getScrollParent.js
  function getScrollParent(node) {
    if (["html", "body", "#document"].indexOf(getNodeName(node)) >= 0) {
      return node.ownerDocument.body;
    }
    if (isHTMLElement(node) && isScrollParent(node)) {
      return node;
    }
    return getScrollParent(getParentNode(node));
  }

  // node_modules/@popperjs/core/lib/dom-utils/listScrollParents.js
  function listScrollParents(element, list) {
    var _element$ownerDocumen;
    if (list === void 0) {
      list = [];
    }
    var scrollParent = getScrollParent(element);
    var isBody = scrollParent === ((_element$ownerDocumen = element.ownerDocument) == null ? void 0 : _element$ownerDocumen.body);
    var win = getWindow(scrollParent);
    var target = isBody ? [win].concat(win.visualViewport || [], isScrollParent(scrollParent) ? scrollParent : []) : scrollParent;
    var updatedList = list.concat(target);
    return isBody ? updatedList : (
      // $FlowFixMe[incompatible-call]: isBody tells us target will be an HTMLElement here
      updatedList.concat(listScrollParents(getParentNode(target)))
    );
  }

  // node_modules/@popperjs/core/lib/utils/rectToClientRect.js
  function rectToClientRect(rect) {
    return Object.assign({}, rect, {
      left: rect.x,
      top: rect.y,
      right: rect.x + rect.width,
      bottom: rect.y + rect.height
    });
  }

  // node_modules/@popperjs/core/lib/dom-utils/getClippingRect.js
  function getInnerBoundingClientRect(element, strategy) {
    var rect = getBoundingClientRect(element, false, strategy === "fixed");
    rect.top = rect.top + element.clientTop;
    rect.left = rect.left + element.clientLeft;
    rect.bottom = rect.top + element.clientHeight;
    rect.right = rect.left + element.clientWidth;
    rect.width = element.clientWidth;
    rect.height = element.clientHeight;
    rect.x = rect.left;
    rect.y = rect.top;
    return rect;
  }
  function getClientRectFromMixedType(element, clippingParent, strategy) {
    return clippingParent === viewport ? rectToClientRect(getViewportRect(element, strategy)) : isElement(clippingParent) ? getInnerBoundingClientRect(clippingParent, strategy) : rectToClientRect(getDocumentRect(getDocumentElement(element)));
  }
  function getClippingParents(element) {
    var clippingParents2 = listScrollParents(getParentNode(element));
    var canEscapeClipping = ["absolute", "fixed"].indexOf(getComputedStyle2(element).position) >= 0;
    var clipperElement = canEscapeClipping && isHTMLElement(element) ? getOffsetParent(element) : element;
    if (!isElement(clipperElement)) {
      return [];
    }
    return clippingParents2.filter(function(clippingParent) {
      return isElement(clippingParent) && contains(clippingParent, clipperElement) && getNodeName(clippingParent) !== "body";
    });
  }
  function getClippingRect(element, boundary, rootBoundary, strategy) {
    var mainClippingParents = boundary === "clippingParents" ? getClippingParents(element) : [].concat(boundary);
    var clippingParents2 = [].concat(mainClippingParents, [rootBoundary]);
    var firstClippingParent = clippingParents2[0];
    var clippingRect = clippingParents2.reduce(function(accRect, clippingParent) {
      var rect = getClientRectFromMixedType(element, clippingParent, strategy);
      accRect.top = max(rect.top, accRect.top);
      accRect.right = min(rect.right, accRect.right);
      accRect.bottom = min(rect.bottom, accRect.bottom);
      accRect.left = max(rect.left, accRect.left);
      return accRect;
    }, getClientRectFromMixedType(element, firstClippingParent, strategy));
    clippingRect.width = clippingRect.right - clippingRect.left;
    clippingRect.height = clippingRect.bottom - clippingRect.top;
    clippingRect.x = clippingRect.left;
    clippingRect.y = clippingRect.top;
    return clippingRect;
  }

  // node_modules/@popperjs/core/lib/utils/computeOffsets.js
  function computeOffsets(_ref) {
    var reference2 = _ref.reference, element = _ref.element, placement = _ref.placement;
    var basePlacement = placement ? getBasePlacement(placement) : null;
    var variation = placement ? getVariation(placement) : null;
    var commonX = reference2.x + reference2.width / 2 - element.width / 2;
    var commonY = reference2.y + reference2.height / 2 - element.height / 2;
    var offsets;
    switch (basePlacement) {
      case top:
        offsets = {
          x: commonX,
          y: reference2.y - element.height
        };
        break;
      case bottom:
        offsets = {
          x: commonX,
          y: reference2.y + reference2.height
        };
        break;
      case right:
        offsets = {
          x: reference2.x + reference2.width,
          y: commonY
        };
        break;
      case left:
        offsets = {
          x: reference2.x - element.width,
          y: commonY
        };
        break;
      default:
        offsets = {
          x: reference2.x,
          y: reference2.y
        };
    }
    var mainAxis = basePlacement ? getMainAxisFromPlacement(basePlacement) : null;
    if (mainAxis != null) {
      var len = mainAxis === "y" ? "height" : "width";
      switch (variation) {
        case start2:
          offsets[mainAxis] = offsets[mainAxis] - (reference2[len] / 2 - element[len] / 2);
          break;
        case end:
          offsets[mainAxis] = offsets[mainAxis] + (reference2[len] / 2 - element[len] / 2);
          break;
        default:
      }
    }
    return offsets;
  }

  // node_modules/@popperjs/core/lib/utils/detectOverflow.js
  function detectOverflow(state, options) {
    if (options === void 0) {
      options = {};
    }
    var _options = options, _options$placement = _options.placement, placement = _options$placement === void 0 ? state.placement : _options$placement, _options$strategy = _options.strategy, strategy = _options$strategy === void 0 ? state.strategy : _options$strategy, _options$boundary = _options.boundary, boundary = _options$boundary === void 0 ? clippingParents : _options$boundary, _options$rootBoundary = _options.rootBoundary, rootBoundary = _options$rootBoundary === void 0 ? viewport : _options$rootBoundary, _options$elementConte = _options.elementContext, elementContext = _options$elementConte === void 0 ? popper : _options$elementConte, _options$altBoundary = _options.altBoundary, altBoundary = _options$altBoundary === void 0 ? false : _options$altBoundary, _options$padding = _options.padding, padding = _options$padding === void 0 ? 0 : _options$padding;
    var paddingObject = mergePaddingObject(typeof padding !== "number" ? padding : expandToHashMap(padding, basePlacements));
    var altContext = elementContext === popper ? reference : popper;
    var popperRect = state.rects.popper;
    var element = state.elements[altBoundary ? altContext : elementContext];
    var clippingClientRect = getClippingRect(isElement(element) ? element : element.contextElement || getDocumentElement(state.elements.popper), boundary, rootBoundary, strategy);
    var referenceClientRect = getBoundingClientRect(state.elements.reference);
    var popperOffsets2 = computeOffsets({
      reference: referenceClientRect,
      element: popperRect,
      strategy: "absolute",
      placement
    });
    var popperClientRect = rectToClientRect(Object.assign({}, popperRect, popperOffsets2));
    var elementClientRect = elementContext === popper ? popperClientRect : referenceClientRect;
    var overflowOffsets = {
      top: clippingClientRect.top - elementClientRect.top + paddingObject.top,
      bottom: elementClientRect.bottom - clippingClientRect.bottom + paddingObject.bottom,
      left: clippingClientRect.left - elementClientRect.left + paddingObject.left,
      right: elementClientRect.right - clippingClientRect.right + paddingObject.right
    };
    var offsetData = state.modifiersData.offset;
    if (elementContext === popper && offsetData) {
      var offset2 = offsetData[placement];
      Object.keys(overflowOffsets).forEach(function(key) {
        var multiply = [right, bottom].indexOf(key) >= 0 ? 1 : -1;
        var axis = [top, bottom].indexOf(key) >= 0 ? "y" : "x";
        overflowOffsets[key] += offset2[axis] * multiply;
      });
    }
    return overflowOffsets;
  }

  // node_modules/@popperjs/core/lib/utils/computeAutoPlacement.js
  function computeAutoPlacement(state, options) {
    if (options === void 0) {
      options = {};
    }
    var _options = options, placement = _options.placement, boundary = _options.boundary, rootBoundary = _options.rootBoundary, padding = _options.padding, flipVariations = _options.flipVariations, _options$allowedAutoP = _options.allowedAutoPlacements, allowedAutoPlacements = _options$allowedAutoP === void 0 ? placements : _options$allowedAutoP;
    var variation = getVariation(placement);
    var placements2 = variation ? flipVariations ? variationPlacements : variationPlacements.filter(function(placement2) {
      return getVariation(placement2) === variation;
    }) : basePlacements;
    var allowedPlacements = placements2.filter(function(placement2) {
      return allowedAutoPlacements.indexOf(placement2) >= 0;
    });
    if (allowedPlacements.length === 0) {
      allowedPlacements = placements2;
    }
    var overflows = allowedPlacements.reduce(function(acc, placement2) {
      acc[placement2] = detectOverflow(state, {
        placement: placement2,
        boundary,
        rootBoundary,
        padding
      })[getBasePlacement(placement2)];
      return acc;
    }, {});
    return Object.keys(overflows).sort(function(a, b) {
      return overflows[a] - overflows[b];
    });
  }

  // node_modules/@popperjs/core/lib/modifiers/flip.js
  function getExpandedFallbackPlacements(placement) {
    if (getBasePlacement(placement) === auto) {
      return [];
    }
    var oppositePlacement = getOppositePlacement(placement);
    return [getOppositeVariationPlacement(placement), oppositePlacement, getOppositeVariationPlacement(oppositePlacement)];
  }
  function flip(_ref) {
    var state = _ref.state, options = _ref.options, name = _ref.name;
    if (state.modifiersData[name]._skip) {
      return;
    }
    var _options$mainAxis = options.mainAxis, checkMainAxis = _options$mainAxis === void 0 ? true : _options$mainAxis, _options$altAxis = options.altAxis, checkAltAxis = _options$altAxis === void 0 ? true : _options$altAxis, specifiedFallbackPlacements = options.fallbackPlacements, padding = options.padding, boundary = options.boundary, rootBoundary = options.rootBoundary, altBoundary = options.altBoundary, _options$flipVariatio = options.flipVariations, flipVariations = _options$flipVariatio === void 0 ? true : _options$flipVariatio, allowedAutoPlacements = options.allowedAutoPlacements;
    var preferredPlacement = state.options.placement;
    var basePlacement = getBasePlacement(preferredPlacement);
    var isBasePlacement = basePlacement === preferredPlacement;
    var fallbackPlacements = specifiedFallbackPlacements || (isBasePlacement || !flipVariations ? [getOppositePlacement(preferredPlacement)] : getExpandedFallbackPlacements(preferredPlacement));
    var placements2 = [preferredPlacement].concat(fallbackPlacements).reduce(function(acc, placement2) {
      return acc.concat(getBasePlacement(placement2) === auto ? computeAutoPlacement(state, {
        placement: placement2,
        boundary,
        rootBoundary,
        padding,
        flipVariations,
        allowedAutoPlacements
      }) : placement2);
    }, []);
    var referenceRect = state.rects.reference;
    var popperRect = state.rects.popper;
    var checksMap = /* @__PURE__ */ new Map();
    var makeFallbackChecks = true;
    var firstFittingPlacement = placements2[0];
    for (var i = 0; i < placements2.length; i++) {
      var placement = placements2[i];
      var _basePlacement = getBasePlacement(placement);
      var isStartVariation = getVariation(placement) === start2;
      var isVertical = [top, bottom].indexOf(_basePlacement) >= 0;
      var len = isVertical ? "width" : "height";
      var overflow = detectOverflow(state, {
        placement,
        boundary,
        rootBoundary,
        altBoundary,
        padding
      });
      var mainVariationSide = isVertical ? isStartVariation ? right : left : isStartVariation ? bottom : top;
      if (referenceRect[len] > popperRect[len]) {
        mainVariationSide = getOppositePlacement(mainVariationSide);
      }
      var altVariationSide = getOppositePlacement(mainVariationSide);
      var checks = [];
      if (checkMainAxis) {
        checks.push(overflow[_basePlacement] <= 0);
      }
      if (checkAltAxis) {
        checks.push(overflow[mainVariationSide] <= 0, overflow[altVariationSide] <= 0);
      }
      if (checks.every(function(check) {
        return check;
      })) {
        firstFittingPlacement = placement;
        makeFallbackChecks = false;
        break;
      }
      checksMap.set(placement, checks);
    }
    if (makeFallbackChecks) {
      var numberOfChecks = flipVariations ? 3 : 1;
      var _loop = function _loop2(_i2) {
        var fittingPlacement = placements2.find(function(placement2) {
          var checks2 = checksMap.get(placement2);
          if (checks2) {
            return checks2.slice(0, _i2).every(function(check) {
              return check;
            });
          }
        });
        if (fittingPlacement) {
          firstFittingPlacement = fittingPlacement;
          return "break";
        }
      };
      for (var _i = numberOfChecks; _i > 0; _i--) {
        var _ret = _loop(_i);
        if (_ret === "break") break;
      }
    }
    if (state.placement !== firstFittingPlacement) {
      state.modifiersData[name]._skip = true;
      state.placement = firstFittingPlacement;
      state.reset = true;
    }
  }
  var flip_default = {
    name: "flip",
    enabled: true,
    phase: "main",
    fn: flip,
    requiresIfExists: ["offset"],
    data: {
      _skip: false
    }
  };

  // node_modules/@popperjs/core/lib/modifiers/hide.js
  function getSideOffsets(overflow, rect, preventedOffsets) {
    if (preventedOffsets === void 0) {
      preventedOffsets = {
        x: 0,
        y: 0
      };
    }
    return {
      top: overflow.top - rect.height - preventedOffsets.y,
      right: overflow.right - rect.width + preventedOffsets.x,
      bottom: overflow.bottom - rect.height + preventedOffsets.y,
      left: overflow.left - rect.width - preventedOffsets.x
    };
  }
  function isAnySideFullyClipped(overflow) {
    return [top, right, bottom, left].some(function(side) {
      return overflow[side] >= 0;
    });
  }
  function hide(_ref) {
    var state = _ref.state, name = _ref.name;
    var referenceRect = state.rects.reference;
    var popperRect = state.rects.popper;
    var preventedOffsets = state.modifiersData.preventOverflow;
    var referenceOverflow = detectOverflow(state, {
      elementContext: "reference"
    });
    var popperAltOverflow = detectOverflow(state, {
      altBoundary: true
    });
    var referenceClippingOffsets = getSideOffsets(referenceOverflow, referenceRect);
    var popperEscapeOffsets = getSideOffsets(popperAltOverflow, popperRect, preventedOffsets);
    var isReferenceHidden = isAnySideFullyClipped(referenceClippingOffsets);
    var hasPopperEscaped = isAnySideFullyClipped(popperEscapeOffsets);
    state.modifiersData[name] = {
      referenceClippingOffsets,
      popperEscapeOffsets,
      isReferenceHidden,
      hasPopperEscaped
    };
    state.attributes.popper = Object.assign({}, state.attributes.popper, {
      "data-popper-reference-hidden": isReferenceHidden,
      "data-popper-escaped": hasPopperEscaped
    });
  }
  var hide_default = {
    name: "hide",
    enabled: true,
    phase: "main",
    requiresIfExists: ["preventOverflow"],
    fn: hide
  };

  // node_modules/@popperjs/core/lib/modifiers/offset.js
  function distanceAndSkiddingToXY(placement, rects, offset2) {
    var basePlacement = getBasePlacement(placement);
    var invertDistance = [left, top].indexOf(basePlacement) >= 0 ? -1 : 1;
    var _ref = typeof offset2 === "function" ? offset2(Object.assign({}, rects, {
      placement
    })) : offset2, skidding = _ref[0], distance = _ref[1];
    skidding = skidding || 0;
    distance = (distance || 0) * invertDistance;
    return [left, right].indexOf(basePlacement) >= 0 ? {
      x: distance,
      y: skidding
    } : {
      x: skidding,
      y: distance
    };
  }
  function offset(_ref2) {
    var state = _ref2.state, options = _ref2.options, name = _ref2.name;
    var _options$offset = options.offset, offset2 = _options$offset === void 0 ? [0, 0] : _options$offset;
    var data = placements.reduce(function(acc, placement) {
      acc[placement] = distanceAndSkiddingToXY(placement, state.rects, offset2);
      return acc;
    }, {});
    var _data$state$placement = data[state.placement], x = _data$state$placement.x, y = _data$state$placement.y;
    if (state.modifiersData.popperOffsets != null) {
      state.modifiersData.popperOffsets.x += x;
      state.modifiersData.popperOffsets.y += y;
    }
    state.modifiersData[name] = data;
  }
  var offset_default = {
    name: "offset",
    enabled: true,
    phase: "main",
    requires: ["popperOffsets"],
    fn: offset
  };

  // node_modules/@popperjs/core/lib/modifiers/popperOffsets.js
  function popperOffsets(_ref) {
    var state = _ref.state, name = _ref.name;
    state.modifiersData[name] = computeOffsets({
      reference: state.rects.reference,
      element: state.rects.popper,
      strategy: "absolute",
      placement: state.placement
    });
  }
  var popperOffsets_default = {
    name: "popperOffsets",
    enabled: true,
    phase: "read",
    fn: popperOffsets,
    data: {}
  };

  // node_modules/@popperjs/core/lib/utils/getAltAxis.js
  function getAltAxis(axis) {
    return axis === "x" ? "y" : "x";
  }

  // node_modules/@popperjs/core/lib/modifiers/preventOverflow.js
  function preventOverflow(_ref) {
    var state = _ref.state, options = _ref.options, name = _ref.name;
    var _options$mainAxis = options.mainAxis, checkMainAxis = _options$mainAxis === void 0 ? true : _options$mainAxis, _options$altAxis = options.altAxis, checkAltAxis = _options$altAxis === void 0 ? false : _options$altAxis, boundary = options.boundary, rootBoundary = options.rootBoundary, altBoundary = options.altBoundary, padding = options.padding, _options$tether = options.tether, tether = _options$tether === void 0 ? true : _options$tether, _options$tetherOffset = options.tetherOffset, tetherOffset = _options$tetherOffset === void 0 ? 0 : _options$tetherOffset;
    var overflow = detectOverflow(state, {
      boundary,
      rootBoundary,
      padding,
      altBoundary
    });
    var basePlacement = getBasePlacement(state.placement);
    var variation = getVariation(state.placement);
    var isBasePlacement = !variation;
    var mainAxis = getMainAxisFromPlacement(basePlacement);
    var altAxis = getAltAxis(mainAxis);
    var popperOffsets2 = state.modifiersData.popperOffsets;
    var referenceRect = state.rects.reference;
    var popperRect = state.rects.popper;
    var tetherOffsetValue = typeof tetherOffset === "function" ? tetherOffset(Object.assign({}, state.rects, {
      placement: state.placement
    })) : tetherOffset;
    var normalizedTetherOffsetValue = typeof tetherOffsetValue === "number" ? {
      mainAxis: tetherOffsetValue,
      altAxis: tetherOffsetValue
    } : Object.assign({
      mainAxis: 0,
      altAxis: 0
    }, tetherOffsetValue);
    var offsetModifierState = state.modifiersData.offset ? state.modifiersData.offset[state.placement] : null;
    var data = {
      x: 0,
      y: 0
    };
    if (!popperOffsets2) {
      return;
    }
    if (checkMainAxis) {
      var _offsetModifierState$;
      var mainSide = mainAxis === "y" ? top : left;
      var altSide = mainAxis === "y" ? bottom : right;
      var len = mainAxis === "y" ? "height" : "width";
      var offset2 = popperOffsets2[mainAxis];
      var min2 = offset2 + overflow[mainSide];
      var max2 = offset2 - overflow[altSide];
      var additive = tether ? -popperRect[len] / 2 : 0;
      var minLen = variation === start2 ? referenceRect[len] : popperRect[len];
      var maxLen = variation === start2 ? -popperRect[len] : -referenceRect[len];
      var arrowElement = state.elements.arrow;
      var arrowRect = tether && arrowElement ? getLayoutRect(arrowElement) : {
        width: 0,
        height: 0
      };
      var arrowPaddingObject = state.modifiersData["arrow#persistent"] ? state.modifiersData["arrow#persistent"].padding : getFreshSideObject();
      var arrowPaddingMin = arrowPaddingObject[mainSide];
      var arrowPaddingMax = arrowPaddingObject[altSide];
      var arrowLen = within(0, referenceRect[len], arrowRect[len]);
      var minOffset = isBasePlacement ? referenceRect[len] / 2 - additive - arrowLen - arrowPaddingMin - normalizedTetherOffsetValue.mainAxis : minLen - arrowLen - arrowPaddingMin - normalizedTetherOffsetValue.mainAxis;
      var maxOffset = isBasePlacement ? -referenceRect[len] / 2 + additive + arrowLen + arrowPaddingMax + normalizedTetherOffsetValue.mainAxis : maxLen + arrowLen + arrowPaddingMax + normalizedTetherOffsetValue.mainAxis;
      var arrowOffsetParent = state.elements.arrow && getOffsetParent(state.elements.arrow);
      var clientOffset = arrowOffsetParent ? mainAxis === "y" ? arrowOffsetParent.clientTop || 0 : arrowOffsetParent.clientLeft || 0 : 0;
      var offsetModifierValue = (_offsetModifierState$ = offsetModifierState == null ? void 0 : offsetModifierState[mainAxis]) != null ? _offsetModifierState$ : 0;
      var tetherMin = offset2 + minOffset - offsetModifierValue - clientOffset;
      var tetherMax = offset2 + maxOffset - offsetModifierValue;
      var preventedOffset = within(tether ? min(min2, tetherMin) : min2, offset2, tether ? max(max2, tetherMax) : max2);
      popperOffsets2[mainAxis] = preventedOffset;
      data[mainAxis] = preventedOffset - offset2;
    }
    if (checkAltAxis) {
      var _offsetModifierState$2;
      var _mainSide = mainAxis === "x" ? top : left;
      var _altSide = mainAxis === "x" ? bottom : right;
      var _offset = popperOffsets2[altAxis];
      var _len = altAxis === "y" ? "height" : "width";
      var _min = _offset + overflow[_mainSide];
      var _max = _offset - overflow[_altSide];
      var isOriginSide = [top, left].indexOf(basePlacement) !== -1;
      var _offsetModifierValue = (_offsetModifierState$2 = offsetModifierState == null ? void 0 : offsetModifierState[altAxis]) != null ? _offsetModifierState$2 : 0;
      var _tetherMin = isOriginSide ? _min : _offset - referenceRect[_len] - popperRect[_len] - _offsetModifierValue + normalizedTetherOffsetValue.altAxis;
      var _tetherMax = isOriginSide ? _offset + referenceRect[_len] + popperRect[_len] - _offsetModifierValue - normalizedTetherOffsetValue.altAxis : _max;
      var _preventedOffset = tether && isOriginSide ? withinMaxClamp(_tetherMin, _offset, _tetherMax) : within(tether ? _tetherMin : _min, _offset, tether ? _tetherMax : _max);
      popperOffsets2[altAxis] = _preventedOffset;
      data[altAxis] = _preventedOffset - _offset;
    }
    state.modifiersData[name] = data;
  }
  var preventOverflow_default = {
    name: "preventOverflow",
    enabled: true,
    phase: "main",
    fn: preventOverflow,
    requiresIfExists: ["offset"]
  };

  // node_modules/@popperjs/core/lib/dom-utils/getHTMLElementScroll.js
  function getHTMLElementScroll(element) {
    return {
      scrollLeft: element.scrollLeft,
      scrollTop: element.scrollTop
    };
  }

  // node_modules/@popperjs/core/lib/dom-utils/getNodeScroll.js
  function getNodeScroll(node) {
    if (node === getWindow(node) || !isHTMLElement(node)) {
      return getWindowScroll(node);
    } else {
      return getHTMLElementScroll(node);
    }
  }

  // node_modules/@popperjs/core/lib/dom-utils/getCompositeRect.js
  function isElementScaled(element) {
    var rect = element.getBoundingClientRect();
    var scaleX = round(rect.width) / element.offsetWidth || 1;
    var scaleY = round(rect.height) / element.offsetHeight || 1;
    return scaleX !== 1 || scaleY !== 1;
  }
  function getCompositeRect(elementOrVirtualElement, offsetParent, isFixed) {
    if (isFixed === void 0) {
      isFixed = false;
    }
    var isOffsetParentAnElement = isHTMLElement(offsetParent);
    var offsetParentIsScaled = isHTMLElement(offsetParent) && isElementScaled(offsetParent);
    var documentElement = getDocumentElement(offsetParent);
    var rect = getBoundingClientRect(elementOrVirtualElement, offsetParentIsScaled, isFixed);
    var scroll = {
      scrollLeft: 0,
      scrollTop: 0
    };
    var offsets = {
      x: 0,
      y: 0
    };
    if (isOffsetParentAnElement || !isOffsetParentAnElement && !isFixed) {
      if (getNodeName(offsetParent) !== "body" || // https://github.com/popperjs/popper-core/issues/1078
      isScrollParent(documentElement)) {
        scroll = getNodeScroll(offsetParent);
      }
      if (isHTMLElement(offsetParent)) {
        offsets = getBoundingClientRect(offsetParent, true);
        offsets.x += offsetParent.clientLeft;
        offsets.y += offsetParent.clientTop;
      } else if (documentElement) {
        offsets.x = getWindowScrollBarX(documentElement);
      }
    }
    return {
      x: rect.left + scroll.scrollLeft - offsets.x,
      y: rect.top + scroll.scrollTop - offsets.y,
      width: rect.width,
      height: rect.height
    };
  }

  // node_modules/@popperjs/core/lib/utils/orderModifiers.js
  function order(modifiers) {
    var map = /* @__PURE__ */ new Map();
    var visited = /* @__PURE__ */ new Set();
    var result = [];
    modifiers.forEach(function(modifier) {
      map.set(modifier.name, modifier);
    });
    function sort(modifier) {
      visited.add(modifier.name);
      var requires = [].concat(modifier.requires || [], modifier.requiresIfExists || []);
      requires.forEach(function(dep) {
        if (!visited.has(dep)) {
          var depModifier = map.get(dep);
          if (depModifier) {
            sort(depModifier);
          }
        }
      });
      result.push(modifier);
    }
    modifiers.forEach(function(modifier) {
      if (!visited.has(modifier.name)) {
        sort(modifier);
      }
    });
    return result;
  }
  function orderModifiers(modifiers) {
    var orderedModifiers = order(modifiers);
    return modifierPhases.reduce(function(acc, phase) {
      return acc.concat(orderedModifiers.filter(function(modifier) {
        return modifier.phase === phase;
      }));
    }, []);
  }

  // node_modules/@popperjs/core/lib/utils/debounce.js
  function debounce(fn2) {
    var pending;
    return function() {
      if (!pending) {
        pending = new Promise(function(resolve) {
          Promise.resolve().then(function() {
            pending = void 0;
            resolve(fn2());
          });
        });
      }
      return pending;
    };
  }

  // node_modules/@popperjs/core/lib/utils/mergeByName.js
  function mergeByName(modifiers) {
    var merged = modifiers.reduce(function(merged2, current) {
      var existing = merged2[current.name];
      merged2[current.name] = existing ? Object.assign({}, existing, current, {
        options: Object.assign({}, existing.options, current.options),
        data: Object.assign({}, existing.data, current.data)
      }) : current;
      return merged2;
    }, {});
    return Object.keys(merged).map(function(key) {
      return merged[key];
    });
  }

  // node_modules/@popperjs/core/lib/createPopper.js
  var DEFAULT_OPTIONS = {
    placement: "bottom",
    modifiers: [],
    strategy: "absolute"
  };
  function areValidElements() {
    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }
    return !args.some(function(element) {
      return !(element && typeof element.getBoundingClientRect === "function");
    });
  }
  function popperGenerator(generatorOptions) {
    if (generatorOptions === void 0) {
      generatorOptions = {};
    }
    var _generatorOptions = generatorOptions, _generatorOptions$def = _generatorOptions.defaultModifiers, defaultModifiers3 = _generatorOptions$def === void 0 ? [] : _generatorOptions$def, _generatorOptions$def2 = _generatorOptions.defaultOptions, defaultOptions2 = _generatorOptions$def2 === void 0 ? DEFAULT_OPTIONS : _generatorOptions$def2;
    return function createPopper4(reference2, popper2, options) {
      if (options === void 0) {
        options = defaultOptions2;
      }
      var state = {
        placement: "bottom",
        orderedModifiers: [],
        options: Object.assign({}, DEFAULT_OPTIONS, defaultOptions2),
        modifiersData: {},
        elements: {
          reference: reference2,
          popper: popper2
        },
        attributes: {},
        styles: {}
      };
      var effectCleanupFns = [];
      var isDestroyed = false;
      var instance = {
        state,
        setOptions: function setOptions(setOptionsAction) {
          var options2 = typeof setOptionsAction === "function" ? setOptionsAction(state.options) : setOptionsAction;
          cleanupModifierEffects();
          state.options = Object.assign({}, defaultOptions2, state.options, options2);
          state.scrollParents = {
            reference: isElement(reference2) ? listScrollParents(reference2) : reference2.contextElement ? listScrollParents(reference2.contextElement) : [],
            popper: listScrollParents(popper2)
          };
          var orderedModifiers = orderModifiers(mergeByName([].concat(defaultModifiers3, state.options.modifiers)));
          state.orderedModifiers = orderedModifiers.filter(function(m) {
            return m.enabled;
          });
          runModifierEffects();
          return instance.update();
        },
        // Sync update – it will always be executed, even if not necessary. This
        // is useful for low frequency updates where sync behavior simplifies the
        // logic.
        // For high frequency updates (e.g. `resize` and `scroll` events), always
        // prefer the async Popper#update method
        forceUpdate: function forceUpdate() {
          if (isDestroyed) {
            return;
          }
          var _state$elements = state.elements, reference3 = _state$elements.reference, popper3 = _state$elements.popper;
          if (!areValidElements(reference3, popper3)) {
            return;
          }
          state.rects = {
            reference: getCompositeRect(reference3, getOffsetParent(popper3), state.options.strategy === "fixed"),
            popper: getLayoutRect(popper3)
          };
          state.reset = false;
          state.placement = state.options.placement;
          state.orderedModifiers.forEach(function(modifier) {
            return state.modifiersData[modifier.name] = Object.assign({}, modifier.data);
          });
          for (var index = 0; index < state.orderedModifiers.length; index++) {
            if (state.reset === true) {
              state.reset = false;
              index = -1;
              continue;
            }
            var _state$orderedModifie = state.orderedModifiers[index], fn2 = _state$orderedModifie.fn, _state$orderedModifie2 = _state$orderedModifie.options, _options = _state$orderedModifie2 === void 0 ? {} : _state$orderedModifie2, name = _state$orderedModifie.name;
            if (typeof fn2 === "function") {
              state = fn2({
                state,
                options: _options,
                name,
                instance
              }) || state;
            }
          }
        },
        // Async and optimistically optimized update – it will not be executed if
        // not necessary (debounced to run at most once-per-tick)
        update: debounce(function() {
          return new Promise(function(resolve) {
            instance.forceUpdate();
            resolve(state);
          });
        }),
        destroy: function destroy() {
          cleanupModifierEffects();
          isDestroyed = true;
        }
      };
      if (!areValidElements(reference2, popper2)) {
        return instance;
      }
      instance.setOptions(options).then(function(state2) {
        if (!isDestroyed && options.onFirstUpdate) {
          options.onFirstUpdate(state2);
        }
      });
      function runModifierEffects() {
        state.orderedModifiers.forEach(function(_ref) {
          var name = _ref.name, _ref$options = _ref.options, options2 = _ref$options === void 0 ? {} : _ref$options, effect4 = _ref.effect;
          if (typeof effect4 === "function") {
            var cleanupFn = effect4({
              state,
              name,
              instance,
              options: options2
            });
            var noopFn = function noopFn2() {
            };
            effectCleanupFns.push(cleanupFn || noopFn);
          }
        });
      }
      function cleanupModifierEffects() {
        effectCleanupFns.forEach(function(fn2) {
          return fn2();
        });
        effectCleanupFns = [];
      }
      return instance;
    };
  }
  var createPopper = /* @__PURE__ */ popperGenerator();

  // node_modules/@popperjs/core/lib/popper-lite.js
  var defaultModifiers = [eventListeners_default, popperOffsets_default, computeStyles_default, applyStyles_default];
  var createPopper2 = /* @__PURE__ */ popperGenerator({
    defaultModifiers
  });

  // node_modules/@popperjs/core/lib/popper.js
  var defaultModifiers2 = [eventListeners_default, popperOffsets_default, computeStyles_default, applyStyles_default, offset_default, flip_default, preventOverflow_default, arrow_default, hide_default];
  var createPopper3 = /* @__PURE__ */ popperGenerator({
    defaultModifiers: defaultModifiers2
  });

  // node_modules/bootstrap/dist/js/bootstrap.esm.js
  var elementMap = /* @__PURE__ */ new Map();
  var Data = {
    set(element, key, instance) {
      if (!elementMap.has(element)) {
        elementMap.set(element, /* @__PURE__ */ new Map());
      }
      const instanceMap = elementMap.get(element);
      if (!instanceMap.has(key) && instanceMap.size !== 0) {
        console.error(`Bootstrap doesn't allow more than one instance per element. Bound instance: ${Array.from(instanceMap.keys())[0]}.`);
        return;
      }
      instanceMap.set(key, instance);
    },
    get(element, key) {
      if (elementMap.has(element)) {
        return elementMap.get(element).get(key) || null;
      }
      return null;
    },
    remove(element, key) {
      if (!elementMap.has(element)) {
        return;
      }
      const instanceMap = elementMap.get(element);
      instanceMap.delete(key);
      if (instanceMap.size === 0) {
        elementMap.delete(element);
      }
    }
  };
  var MAX_UID = 1e6;
  var MILLISECONDS_MULTIPLIER = 1e3;
  var TRANSITION_END = "transitionend";
  var parseSelector = (selector) => {
    if (selector && window.CSS && window.CSS.escape) {
      selector = selector.replace(/#([^\s"#']+)/g, (match, id) => `#${CSS.escape(id)}`);
    }
    return selector;
  };
  var toType = (object) => {
    if (object === null || object === void 0) {
      return `${object}`;
    }
    return Object.prototype.toString.call(object).match(/\s([a-z]+)/i)[1].toLowerCase();
  };
  var getUID = (prefix) => {
    do {
      prefix += Math.floor(Math.random() * MAX_UID);
    } while (document.getElementById(prefix));
    return prefix;
  };
  var getTransitionDurationFromElement = (element) => {
    if (!element) {
      return 0;
    }
    let {
      transitionDuration,
      transitionDelay
    } = window.getComputedStyle(element);
    const floatTransitionDuration = Number.parseFloat(transitionDuration);
    const floatTransitionDelay = Number.parseFloat(transitionDelay);
    if (!floatTransitionDuration && !floatTransitionDelay) {
      return 0;
    }
    transitionDuration = transitionDuration.split(",")[0];
    transitionDelay = transitionDelay.split(",")[0];
    return (Number.parseFloat(transitionDuration) + Number.parseFloat(transitionDelay)) * MILLISECONDS_MULTIPLIER;
  };
  var triggerTransitionEnd = (element) => {
    element.dispatchEvent(new Event(TRANSITION_END));
  };
  var isElement2 = (object) => {
    if (!object || typeof object !== "object") {
      return false;
    }
    if (typeof object.jquery !== "undefined") {
      object = object[0];
    }
    return typeof object.nodeType !== "undefined";
  };
  var getElement = (object) => {
    if (isElement2(object)) {
      return object.jquery ? object[0] : object;
    }
    if (typeof object === "string" && object.length > 0) {
      return document.querySelector(parseSelector(object));
    }
    return null;
  };
  var isVisible = (element) => {
    if (!isElement2(element) || element.getClientRects().length === 0) {
      return false;
    }
    const elementIsVisible = getComputedStyle(element).getPropertyValue("visibility") === "visible";
    const closedDetails = element.closest("details:not([open])");
    if (!closedDetails) {
      return elementIsVisible;
    }
    if (closedDetails !== element) {
      const summary = element.closest("summary");
      if (summary && summary.parentNode !== closedDetails) {
        return false;
      }
      if (summary === null) {
        return false;
      }
    }
    return elementIsVisible;
  };
  var isDisabled = (element) => {
    if (!element || element.nodeType !== Node.ELEMENT_NODE) {
      return true;
    }
    if (element.classList.contains("disabled")) {
      return true;
    }
    if (typeof element.disabled !== "undefined") {
      return element.disabled;
    }
    return element.hasAttribute("disabled") && element.getAttribute("disabled") !== "false";
  };
  var findShadowRoot = (element) => {
    if (!document.documentElement.attachShadow) {
      return null;
    }
    if (typeof element.getRootNode === "function") {
      const root = element.getRootNode();
      return root instanceof ShadowRoot ? root : null;
    }
    if (element instanceof ShadowRoot) {
      return element;
    }
    if (!element.parentNode) {
      return null;
    }
    return findShadowRoot(element.parentNode);
  };
  var noop = () => {
  };
  var reflow = (element) => {
    element.offsetHeight;
  };
  var getjQuery = () => {
    if (window.jQuery && !document.body.hasAttribute("data-bs-no-jquery")) {
      return window.jQuery;
    }
    return null;
  };
  var DOMContentLoadedCallbacks = [];
  var onDOMContentLoaded = (callback) => {
    if (document.readyState === "loading") {
      if (!DOMContentLoadedCallbacks.length) {
        document.addEventListener("DOMContentLoaded", () => {
          for (const callback2 of DOMContentLoadedCallbacks) {
            callback2();
          }
        });
      }
      DOMContentLoadedCallbacks.push(callback);
    } else {
      callback();
    }
  };
  var isRTL = () => document.documentElement.dir === "rtl";
  var defineJQueryPlugin = (plugin) => {
    onDOMContentLoaded(() => {
      const $ = getjQuery();
      if ($) {
        const name = plugin.NAME;
        const JQUERY_NO_CONFLICT = $.fn[name];
        $.fn[name] = plugin.jQueryInterface;
        $.fn[name].Constructor = plugin;
        $.fn[name].noConflict = () => {
          $.fn[name] = JQUERY_NO_CONFLICT;
          return plugin.jQueryInterface;
        };
      }
    });
  };
  var execute = (possibleCallback, args = [], defaultValue = possibleCallback) => {
    return typeof possibleCallback === "function" ? possibleCallback(...args) : defaultValue;
  };
  var executeAfterTransition = (callback, transitionElement, waitForTransition = true) => {
    if (!waitForTransition) {
      execute(callback);
      return;
    }
    const durationPadding = 5;
    const emulatedDuration = getTransitionDurationFromElement(transitionElement) + durationPadding;
    let called = false;
    const handler = ({
      target
    }) => {
      if (target !== transitionElement) {
        return;
      }
      called = true;
      transitionElement.removeEventListener(TRANSITION_END, handler);
      execute(callback);
    };
    transitionElement.addEventListener(TRANSITION_END, handler);
    setTimeout(() => {
      if (!called) {
        triggerTransitionEnd(transitionElement);
      }
    }, emulatedDuration);
  };
  var getNextActiveElement = (list, activeElement, shouldGetNext, isCycleAllowed) => {
    const listLength = list.length;
    let index = list.indexOf(activeElement);
    if (index === -1) {
      return !shouldGetNext && isCycleAllowed ? list[listLength - 1] : list[0];
    }
    index += shouldGetNext ? 1 : -1;
    if (isCycleAllowed) {
      index = (index + listLength) % listLength;
    }
    return list[Math.max(0, Math.min(index, listLength - 1))];
  };
  var namespaceRegex = /[^.]*(?=\..*)\.|.*/;
  var stripNameRegex = /\..*/;
  var stripUidRegex = /::\d+$/;
  var eventRegistry = {};
  var uidEvent = 1;
  var customEvents = {
    mouseenter: "mouseover",
    mouseleave: "mouseout"
  };
  var nativeEvents = /* @__PURE__ */ new Set(["click", "dblclick", "mouseup", "mousedown", "contextmenu", "mousewheel", "DOMMouseScroll", "mouseover", "mouseout", "mousemove", "selectstart", "selectend", "keydown", "keypress", "keyup", "orientationchange", "touchstart", "touchmove", "touchend", "touchcancel", "pointerdown", "pointermove", "pointerup", "pointerleave", "pointercancel", "gesturestart", "gesturechange", "gestureend", "focus", "blur", "change", "reset", "select", "submit", "focusin", "focusout", "load", "unload", "beforeunload", "resize", "move", "DOMContentLoaded", "readystatechange", "error", "abort", "scroll"]);
  function makeEventUid(element, uid) {
    return uid && `${uid}::${uidEvent++}` || element.uidEvent || uidEvent++;
  }
  function getElementEvents(element) {
    const uid = makeEventUid(element);
    element.uidEvent = uid;
    eventRegistry[uid] = eventRegistry[uid] || {};
    return eventRegistry[uid];
  }
  function bootstrapHandler(element, fn2) {
    return function handler(event) {
      hydrateObj(event, {
        delegateTarget: element
      });
      if (handler.oneOff) {
        EventHandler.off(element, event.type, fn2);
      }
      return fn2.apply(element, [event]);
    };
  }
  function bootstrapDelegationHandler(element, selector, fn2) {
    return function handler(event) {
      const domElements = element.querySelectorAll(selector);
      for (let {
        target
      } = event; target && target !== this; target = target.parentNode) {
        for (const domElement of domElements) {
          if (domElement !== target) {
            continue;
          }
          hydrateObj(event, {
            delegateTarget: target
          });
          if (handler.oneOff) {
            EventHandler.off(element, event.type, selector, fn2);
          }
          return fn2.apply(target, [event]);
        }
      }
    };
  }
  function findHandler(events, callable, delegationSelector = null) {
    return Object.values(events).find((event) => event.callable === callable && event.delegationSelector === delegationSelector);
  }
  function normalizeParameters(originalTypeEvent, handler, delegationFunction) {
    const isDelegated = typeof handler === "string";
    const callable = isDelegated ? delegationFunction : handler || delegationFunction;
    let typeEvent = getTypeEvent(originalTypeEvent);
    if (!nativeEvents.has(typeEvent)) {
      typeEvent = originalTypeEvent;
    }
    return [isDelegated, callable, typeEvent];
  }
  function addHandler(element, originalTypeEvent, handler, delegationFunction, oneOff) {
    if (typeof originalTypeEvent !== "string" || !element) {
      return;
    }
    let [isDelegated, callable, typeEvent] = normalizeParameters(originalTypeEvent, handler, delegationFunction);
    if (originalTypeEvent in customEvents) {
      const wrapFunction = (fn3) => {
        return function(event) {
          if (!event.relatedTarget || event.relatedTarget !== event.delegateTarget && !event.delegateTarget.contains(event.relatedTarget)) {
            return fn3.call(this, event);
          }
        };
      };
      callable = wrapFunction(callable);
    }
    const events = getElementEvents(element);
    const handlers = events[typeEvent] || (events[typeEvent] = {});
    const previousFunction = findHandler(handlers, callable, isDelegated ? handler : null);
    if (previousFunction) {
      previousFunction.oneOff = previousFunction.oneOff && oneOff;
      return;
    }
    const uid = makeEventUid(callable, originalTypeEvent.replace(namespaceRegex, ""));
    const fn2 = isDelegated ? bootstrapDelegationHandler(element, handler, callable) : bootstrapHandler(element, callable);
    fn2.delegationSelector = isDelegated ? handler : null;
    fn2.callable = callable;
    fn2.oneOff = oneOff;
    fn2.uidEvent = uid;
    handlers[uid] = fn2;
    element.addEventListener(typeEvent, fn2, isDelegated);
  }
  function removeHandler(element, events, typeEvent, handler, delegationSelector) {
    const fn2 = findHandler(events[typeEvent], handler, delegationSelector);
    if (!fn2) {
      return;
    }
    element.removeEventListener(typeEvent, fn2, Boolean(delegationSelector));
    delete events[typeEvent][fn2.uidEvent];
  }
  function removeNamespacedHandlers(element, events, typeEvent, namespace) {
    const storeElementEvent = events[typeEvent] || {};
    for (const [handlerKey, event] of Object.entries(storeElementEvent)) {
      if (handlerKey.includes(namespace)) {
        removeHandler(element, events, typeEvent, event.callable, event.delegationSelector);
      }
    }
  }
  function getTypeEvent(event) {
    event = event.replace(stripNameRegex, "");
    return customEvents[event] || event;
  }
  var EventHandler = {
    on(element, event, handler, delegationFunction) {
      addHandler(element, event, handler, delegationFunction, false);
    },
    one(element, event, handler, delegationFunction) {
      addHandler(element, event, handler, delegationFunction, true);
    },
    off(element, originalTypeEvent, handler, delegationFunction) {
      if (typeof originalTypeEvent !== "string" || !element) {
        return;
      }
      const [isDelegated, callable, typeEvent] = normalizeParameters(originalTypeEvent, handler, delegationFunction);
      const inNamespace = typeEvent !== originalTypeEvent;
      const events = getElementEvents(element);
      const storeElementEvent = events[typeEvent] || {};
      const isNamespace = originalTypeEvent.startsWith(".");
      if (typeof callable !== "undefined") {
        if (!Object.keys(storeElementEvent).length) {
          return;
        }
        removeHandler(element, events, typeEvent, callable, isDelegated ? handler : null);
        return;
      }
      if (isNamespace) {
        for (const elementEvent of Object.keys(events)) {
          removeNamespacedHandlers(element, events, elementEvent, originalTypeEvent.slice(1));
        }
      }
      for (const [keyHandlers, event] of Object.entries(storeElementEvent)) {
        const handlerKey = keyHandlers.replace(stripUidRegex, "");
        if (!inNamespace || originalTypeEvent.includes(handlerKey)) {
          removeHandler(element, events, typeEvent, event.callable, event.delegationSelector);
        }
      }
    },
    trigger(element, event, args) {
      if (typeof event !== "string" || !element) {
        return null;
      }
      const $ = getjQuery();
      const typeEvent = getTypeEvent(event);
      const inNamespace = event !== typeEvent;
      let jQueryEvent = null;
      let bubbles = true;
      let nativeDispatch = true;
      let defaultPrevented = false;
      if (inNamespace && $) {
        jQueryEvent = $.Event(event, args);
        $(element).trigger(jQueryEvent);
        bubbles = !jQueryEvent.isPropagationStopped();
        nativeDispatch = !jQueryEvent.isImmediatePropagationStopped();
        defaultPrevented = jQueryEvent.isDefaultPrevented();
      }
      const evt = hydrateObj(new Event(event, {
        bubbles,
        cancelable: true
      }), args);
      if (defaultPrevented) {
        evt.preventDefault();
      }
      if (nativeDispatch) {
        element.dispatchEvent(evt);
      }
      if (evt.defaultPrevented && jQueryEvent) {
        jQueryEvent.preventDefault();
      }
      return evt;
    }
  };
  function hydrateObj(obj, meta = {}) {
    for (const [key, value] of Object.entries(meta)) {
      try {
        obj[key] = value;
      } catch (_unused) {
        Object.defineProperty(obj, key, {
          configurable: true,
          get() {
            return value;
          }
        });
      }
    }
    return obj;
  }
  function normalizeData(value) {
    if (value === "true") {
      return true;
    }
    if (value === "false") {
      return false;
    }
    if (value === Number(value).toString()) {
      return Number(value);
    }
    if (value === "" || value === "null") {
      return null;
    }
    if (typeof value !== "string") {
      return value;
    }
    try {
      return JSON.parse(decodeURIComponent(value));
    } catch (_unused) {
      return value;
    }
  }
  function normalizeDataKey(key) {
    return key.replace(/[A-Z]/g, (chr) => `-${chr.toLowerCase()}`);
  }
  var Manipulator = {
    setDataAttribute(element, key, value) {
      element.setAttribute(`data-bs-${normalizeDataKey(key)}`, value);
    },
    removeDataAttribute(element, key) {
      element.removeAttribute(`data-bs-${normalizeDataKey(key)}`);
    },
    getDataAttributes(element) {
      if (!element) {
        return {};
      }
      const attributes = {};
      const bsKeys = Object.keys(element.dataset).filter((key) => key.startsWith("bs") && !key.startsWith("bsConfig"));
      for (const key of bsKeys) {
        let pureKey = key.replace(/^bs/, "");
        pureKey = pureKey.charAt(0).toLowerCase() + pureKey.slice(1, pureKey.length);
        attributes[pureKey] = normalizeData(element.dataset[key]);
      }
      return attributes;
    },
    getDataAttribute(element, key) {
      return normalizeData(element.getAttribute(`data-bs-${normalizeDataKey(key)}`));
    }
  };
  var Config = class {
    // Getters
    static get Default() {
      return {};
    }
    static get DefaultType() {
      return {};
    }
    static get NAME() {
      throw new Error('You have to implement the static method "NAME", for each component!');
    }
    _getConfig(config) {
      config = this._mergeConfigObj(config);
      config = this._configAfterMerge(config);
      this._typeCheckConfig(config);
      return config;
    }
    _configAfterMerge(config) {
      return config;
    }
    _mergeConfigObj(config, element) {
      const jsonConfig = isElement2(element) ? Manipulator.getDataAttribute(element, "config") : {};
      return {
        ...this.constructor.Default,
        ...typeof jsonConfig === "object" ? jsonConfig : {},
        ...isElement2(element) ? Manipulator.getDataAttributes(element) : {},
        ...typeof config === "object" ? config : {}
      };
    }
    _typeCheckConfig(config, configTypes = this.constructor.DefaultType) {
      for (const [property, expectedTypes] of Object.entries(configTypes)) {
        const value = config[property];
        const valueType = isElement2(value) ? "element" : toType(value);
        if (!new RegExp(expectedTypes).test(valueType)) {
          throw new TypeError(`${this.constructor.NAME.toUpperCase()}: Option "${property}" provided type "${valueType}" but expected type "${expectedTypes}".`);
        }
      }
    }
  };
  var VERSION = "5.3.1";
  var BaseComponent = class extends Config {
    constructor(element, config) {
      super();
      element = getElement(element);
      if (!element) {
        return;
      }
      this._element = element;
      this._config = this._getConfig(config);
      Data.set(this._element, this.constructor.DATA_KEY, this);
    }
    // Public
    dispose() {
      Data.remove(this._element, this.constructor.DATA_KEY);
      EventHandler.off(this._element, this.constructor.EVENT_KEY);
      for (const propertyName of Object.getOwnPropertyNames(this)) {
        this[propertyName] = null;
      }
    }
    _queueCallback(callback, element, isAnimated = true) {
      executeAfterTransition(callback, element, isAnimated);
    }
    _getConfig(config) {
      config = this._mergeConfigObj(config, this._element);
      config = this._configAfterMerge(config);
      this._typeCheckConfig(config);
      return config;
    }
    // Static
    static getInstance(element) {
      return Data.get(getElement(element), this.DATA_KEY);
    }
    static getOrCreateInstance(element, config = {}) {
      return this.getInstance(element) || new this(element, typeof config === "object" ? config : null);
    }
    static get VERSION() {
      return VERSION;
    }
    static get DATA_KEY() {
      return `bs.${this.NAME}`;
    }
    static get EVENT_KEY() {
      return `.${this.DATA_KEY}`;
    }
    static eventName(name) {
      return `${name}${this.EVENT_KEY}`;
    }
  };
  var getSelector = (element) => {
    let selector = element.getAttribute("data-bs-target");
    if (!selector || selector === "#") {
      let hrefAttribute = element.getAttribute("href");
      if (!hrefAttribute || !hrefAttribute.includes("#") && !hrefAttribute.startsWith(".")) {
        return null;
      }
      if (hrefAttribute.includes("#") && !hrefAttribute.startsWith("#")) {
        hrefAttribute = `#${hrefAttribute.split("#")[1]}`;
      }
      selector = hrefAttribute && hrefAttribute !== "#" ? hrefAttribute.trim() : null;
    }
    return parseSelector(selector);
  };
  var SelectorEngine = {
    find(selector, element = document.documentElement) {
      return [].concat(...Element.prototype.querySelectorAll.call(element, selector));
    },
    findOne(selector, element = document.documentElement) {
      return Element.prototype.querySelector.call(element, selector);
    },
    children(element, selector) {
      return [].concat(...element.children).filter((child) => child.matches(selector));
    },
    parents(element, selector) {
      const parents = [];
      let ancestor = element.parentNode.closest(selector);
      while (ancestor) {
        parents.push(ancestor);
        ancestor = ancestor.parentNode.closest(selector);
      }
      return parents;
    },
    prev(element, selector) {
      let previous = element.previousElementSibling;
      while (previous) {
        if (previous.matches(selector)) {
          return [previous];
        }
        previous = previous.previousElementSibling;
      }
      return [];
    },
    // TODO: this is now unused; remove later along with prev()
    next(element, selector) {
      let next = element.nextElementSibling;
      while (next) {
        if (next.matches(selector)) {
          return [next];
        }
        next = next.nextElementSibling;
      }
      return [];
    },
    focusableChildren(element) {
      const focusables = ["a", "button", "input", "textarea", "select", "details", "[tabindex]", '[contenteditable="true"]'].map((selector) => `${selector}:not([tabindex^="-"])`).join(",");
      return this.find(focusables, element).filter((el) => !isDisabled(el) && isVisible(el));
    },
    getSelectorFromElement(element) {
      const selector = getSelector(element);
      if (selector) {
        return SelectorEngine.findOne(selector) ? selector : null;
      }
      return null;
    },
    getElementFromSelector(element) {
      const selector = getSelector(element);
      return selector ? SelectorEngine.findOne(selector) : null;
    },
    getMultipleElementsFromSelector(element) {
      const selector = getSelector(element);
      return selector ? SelectorEngine.find(selector) : [];
    }
  };
  var enableDismissTrigger = (component, method = "hide") => {
    const clickEvent = `click.dismiss${component.EVENT_KEY}`;
    const name = component.NAME;
    EventHandler.on(document, clickEvent, `[data-bs-dismiss="${name}"]`, function(event) {
      if (["A", "AREA"].includes(this.tagName)) {
        event.preventDefault();
      }
      if (isDisabled(this)) {
        return;
      }
      const target = SelectorEngine.getElementFromSelector(this) || this.closest(`.${name}`);
      const instance = component.getOrCreateInstance(target);
      instance[method]();
    });
  };
  var NAME$f = "alert";
  var DATA_KEY$a = "bs.alert";
  var EVENT_KEY$b = `.${DATA_KEY$a}`;
  var EVENT_CLOSE = `close${EVENT_KEY$b}`;
  var EVENT_CLOSED = `closed${EVENT_KEY$b}`;
  var CLASS_NAME_FADE$5 = "fade";
  var CLASS_NAME_SHOW$8 = "show";
  var Alert = class _Alert extends BaseComponent {
    // Getters
    static get NAME() {
      return NAME$f;
    }
    // Public
    close() {
      const closeEvent = EventHandler.trigger(this._element, EVENT_CLOSE);
      if (closeEvent.defaultPrevented) {
        return;
      }
      this._element.classList.remove(CLASS_NAME_SHOW$8);
      const isAnimated = this._element.classList.contains(CLASS_NAME_FADE$5);
      this._queueCallback(() => this._destroyElement(), this._element, isAnimated);
    }
    // Private
    _destroyElement() {
      this._element.remove();
      EventHandler.trigger(this._element, EVENT_CLOSED);
      this.dispose();
    }
    // Static
    static jQueryInterface(config) {
      return this.each(function() {
        const data = _Alert.getOrCreateInstance(this);
        if (typeof config !== "string") {
          return;
        }
        if (data[config] === void 0 || config.startsWith("_") || config === "constructor") {
          throw new TypeError(`No method named "${config}"`);
        }
        data[config](this);
      });
    }
  };
  enableDismissTrigger(Alert, "close");
  defineJQueryPlugin(Alert);
  var NAME$e = "button";
  var DATA_KEY$9 = "bs.button";
  var EVENT_KEY$a = `.${DATA_KEY$9}`;
  var DATA_API_KEY$6 = ".data-api";
  var CLASS_NAME_ACTIVE$3 = "active";
  var SELECTOR_DATA_TOGGLE$5 = '[data-bs-toggle="button"]';
  var EVENT_CLICK_DATA_API$6 = `click${EVENT_KEY$a}${DATA_API_KEY$6}`;
  var Button = class _Button extends BaseComponent {
    // Getters
    static get NAME() {
      return NAME$e;
    }
    // Public
    toggle() {
      this._element.setAttribute("aria-pressed", this._element.classList.toggle(CLASS_NAME_ACTIVE$3));
    }
    // Static
    static jQueryInterface(config) {
      return this.each(function() {
        const data = _Button.getOrCreateInstance(this);
        if (config === "toggle") {
          data[config]();
        }
      });
    }
  };
  EventHandler.on(document, EVENT_CLICK_DATA_API$6, SELECTOR_DATA_TOGGLE$5, (event) => {
    event.preventDefault();
    const button = event.target.closest(SELECTOR_DATA_TOGGLE$5);
    const data = Button.getOrCreateInstance(button);
    data.toggle();
  });
  defineJQueryPlugin(Button);
  var NAME$d = "swipe";
  var EVENT_KEY$9 = ".bs.swipe";
  var EVENT_TOUCHSTART = `touchstart${EVENT_KEY$9}`;
  var EVENT_TOUCHMOVE = `touchmove${EVENT_KEY$9}`;
  var EVENT_TOUCHEND = `touchend${EVENT_KEY$9}`;
  var EVENT_POINTERDOWN = `pointerdown${EVENT_KEY$9}`;
  var EVENT_POINTERUP = `pointerup${EVENT_KEY$9}`;
  var POINTER_TYPE_TOUCH = "touch";
  var POINTER_TYPE_PEN = "pen";
  var CLASS_NAME_POINTER_EVENT = "pointer-event";
  var SWIPE_THRESHOLD = 40;
  var Default$c = {
    endCallback: null,
    leftCallback: null,
    rightCallback: null
  };
  var DefaultType$c = {
    endCallback: "(function|null)",
    leftCallback: "(function|null)",
    rightCallback: "(function|null)"
  };
  var Swipe = class _Swipe extends Config {
    constructor(element, config) {
      super();
      this._element = element;
      if (!element || !_Swipe.isSupported()) {
        return;
      }
      this._config = this._getConfig(config);
      this._deltaX = 0;
      this._supportPointerEvents = Boolean(window.PointerEvent);
      this._initEvents();
    }
    // Getters
    static get Default() {
      return Default$c;
    }
    static get DefaultType() {
      return DefaultType$c;
    }
    static get NAME() {
      return NAME$d;
    }
    // Public
    dispose() {
      EventHandler.off(this._element, EVENT_KEY$9);
    }
    // Private
    _start(event) {
      if (!this._supportPointerEvents) {
        this._deltaX = event.touches[0].clientX;
        return;
      }
      if (this._eventIsPointerPenTouch(event)) {
        this._deltaX = event.clientX;
      }
    }
    _end(event) {
      if (this._eventIsPointerPenTouch(event)) {
        this._deltaX = event.clientX - this._deltaX;
      }
      this._handleSwipe();
      execute(this._config.endCallback);
    }
    _move(event) {
      this._deltaX = event.touches && event.touches.length > 1 ? 0 : event.touches[0].clientX - this._deltaX;
    }
    _handleSwipe() {
      const absDeltaX = Math.abs(this._deltaX);
      if (absDeltaX <= SWIPE_THRESHOLD) {
        return;
      }
      const direction = absDeltaX / this._deltaX;
      this._deltaX = 0;
      if (!direction) {
        return;
      }
      execute(direction > 0 ? this._config.rightCallback : this._config.leftCallback);
    }
    _initEvents() {
      if (this._supportPointerEvents) {
        EventHandler.on(this._element, EVENT_POINTERDOWN, (event) => this._start(event));
        EventHandler.on(this._element, EVENT_POINTERUP, (event) => this._end(event));
        this._element.classList.add(CLASS_NAME_POINTER_EVENT);
      } else {
        EventHandler.on(this._element, EVENT_TOUCHSTART, (event) => this._start(event));
        EventHandler.on(this._element, EVENT_TOUCHMOVE, (event) => this._move(event));
        EventHandler.on(this._element, EVENT_TOUCHEND, (event) => this._end(event));
      }
    }
    _eventIsPointerPenTouch(event) {
      return this._supportPointerEvents && (event.pointerType === POINTER_TYPE_PEN || event.pointerType === POINTER_TYPE_TOUCH);
    }
    // Static
    static isSupported() {
      return "ontouchstart" in document.documentElement || navigator.maxTouchPoints > 0;
    }
  };
  var NAME$c = "carousel";
  var DATA_KEY$8 = "bs.carousel";
  var EVENT_KEY$8 = `.${DATA_KEY$8}`;
  var DATA_API_KEY$5 = ".data-api";
  var ARROW_LEFT_KEY$1 = "ArrowLeft";
  var ARROW_RIGHT_KEY$1 = "ArrowRight";
  var TOUCHEVENT_COMPAT_WAIT = 500;
  var ORDER_NEXT = "next";
  var ORDER_PREV = "prev";
  var DIRECTION_LEFT = "left";
  var DIRECTION_RIGHT = "right";
  var EVENT_SLIDE = `slide${EVENT_KEY$8}`;
  var EVENT_SLID = `slid${EVENT_KEY$8}`;
  var EVENT_KEYDOWN$1 = `keydown${EVENT_KEY$8}`;
  var EVENT_MOUSEENTER$1 = `mouseenter${EVENT_KEY$8}`;
  var EVENT_MOUSELEAVE$1 = `mouseleave${EVENT_KEY$8}`;
  var EVENT_DRAG_START = `dragstart${EVENT_KEY$8}`;
  var EVENT_LOAD_DATA_API$3 = `load${EVENT_KEY$8}${DATA_API_KEY$5}`;
  var EVENT_CLICK_DATA_API$5 = `click${EVENT_KEY$8}${DATA_API_KEY$5}`;
  var CLASS_NAME_CAROUSEL = "carousel";
  var CLASS_NAME_ACTIVE$2 = "active";
  var CLASS_NAME_SLIDE = "slide";
  var CLASS_NAME_END = "carousel-item-end";
  var CLASS_NAME_START = "carousel-item-start";
  var CLASS_NAME_NEXT = "carousel-item-next";
  var CLASS_NAME_PREV = "carousel-item-prev";
  var SELECTOR_ACTIVE = ".active";
  var SELECTOR_ITEM = ".carousel-item";
  var SELECTOR_ACTIVE_ITEM = SELECTOR_ACTIVE + SELECTOR_ITEM;
  var SELECTOR_ITEM_IMG = ".carousel-item img";
  var SELECTOR_INDICATORS = ".carousel-indicators";
  var SELECTOR_DATA_SLIDE = "[data-bs-slide], [data-bs-slide-to]";
  var SELECTOR_DATA_RIDE = '[data-bs-ride="carousel"]';
  var KEY_TO_DIRECTION = {
    [ARROW_LEFT_KEY$1]: DIRECTION_RIGHT,
    [ARROW_RIGHT_KEY$1]: DIRECTION_LEFT
  };
  var Default$b = {
    interval: 5e3,
    keyboard: true,
    pause: "hover",
    ride: false,
    touch: true,
    wrap: true
  };
  var DefaultType$b = {
    interval: "(number|boolean)",
    // TODO:v6 remove boolean support
    keyboard: "boolean",
    pause: "(string|boolean)",
    ride: "(boolean|string)",
    touch: "boolean",
    wrap: "boolean"
  };
  var Carousel = class _Carousel extends BaseComponent {
    constructor(element, config) {
      super(element, config);
      this._interval = null;
      this._activeElement = null;
      this._isSliding = false;
      this.touchTimeout = null;
      this._swipeHelper = null;
      this._indicatorsElement = SelectorEngine.findOne(SELECTOR_INDICATORS, this._element);
      this._addEventListeners();
      if (this._config.ride === CLASS_NAME_CAROUSEL) {
        this.cycle();
      }
    }
    // Getters
    static get Default() {
      return Default$b;
    }
    static get DefaultType() {
      return DefaultType$b;
    }
    static get NAME() {
      return NAME$c;
    }
    // Public
    next() {
      this._slide(ORDER_NEXT);
    }
    nextWhenVisible() {
      if (!document.hidden && isVisible(this._element)) {
        this.next();
      }
    }
    prev() {
      this._slide(ORDER_PREV);
    }
    pause() {
      if (this._isSliding) {
        triggerTransitionEnd(this._element);
      }
      this._clearInterval();
    }
    cycle() {
      this._clearInterval();
      this._updateInterval();
      this._interval = setInterval(() => this.nextWhenVisible(), this._config.interval);
    }
    _maybeEnableCycle() {
      if (!this._config.ride) {
        return;
      }
      if (this._isSliding) {
        EventHandler.one(this._element, EVENT_SLID, () => this.cycle());
        return;
      }
      this.cycle();
    }
    to(index) {
      const items = this._getItems();
      if (index > items.length - 1 || index < 0) {
        return;
      }
      if (this._isSliding) {
        EventHandler.one(this._element, EVENT_SLID, () => this.to(index));
        return;
      }
      const activeIndex = this._getItemIndex(this._getActive());
      if (activeIndex === index) {
        return;
      }
      const order2 = index > activeIndex ? ORDER_NEXT : ORDER_PREV;
      this._slide(order2, items[index]);
    }
    dispose() {
      if (this._swipeHelper) {
        this._swipeHelper.dispose();
      }
      super.dispose();
    }
    // Private
    _configAfterMerge(config) {
      config.defaultInterval = config.interval;
      return config;
    }
    _addEventListeners() {
      if (this._config.keyboard) {
        EventHandler.on(this._element, EVENT_KEYDOWN$1, (event) => this._keydown(event));
      }
      if (this._config.pause === "hover") {
        EventHandler.on(this._element, EVENT_MOUSEENTER$1, () => this.pause());
        EventHandler.on(this._element, EVENT_MOUSELEAVE$1, () => this._maybeEnableCycle());
      }
      if (this._config.touch && Swipe.isSupported()) {
        this._addTouchEventListeners();
      }
    }
    _addTouchEventListeners() {
      for (const img of SelectorEngine.find(SELECTOR_ITEM_IMG, this._element)) {
        EventHandler.on(img, EVENT_DRAG_START, (event) => event.preventDefault());
      }
      const endCallBack = () => {
        if (this._config.pause !== "hover") {
          return;
        }
        this.pause();
        if (this.touchTimeout) {
          clearTimeout(this.touchTimeout);
        }
        this.touchTimeout = setTimeout(() => this._maybeEnableCycle(), TOUCHEVENT_COMPAT_WAIT + this._config.interval);
      };
      const swipeConfig = {
        leftCallback: () => this._slide(this._directionToOrder(DIRECTION_LEFT)),
        rightCallback: () => this._slide(this._directionToOrder(DIRECTION_RIGHT)),
        endCallback: endCallBack
      };
      this._swipeHelper = new Swipe(this._element, swipeConfig);
    }
    _keydown(event) {
      if (/input|textarea/i.test(event.target.tagName)) {
        return;
      }
      const direction = KEY_TO_DIRECTION[event.key];
      if (direction) {
        event.preventDefault();
        this._slide(this._directionToOrder(direction));
      }
    }
    _getItemIndex(element) {
      return this._getItems().indexOf(element);
    }
    _setActiveIndicatorElement(index) {
      if (!this._indicatorsElement) {
        return;
      }
      const activeIndicator = SelectorEngine.findOne(SELECTOR_ACTIVE, this._indicatorsElement);
      activeIndicator.classList.remove(CLASS_NAME_ACTIVE$2);
      activeIndicator.removeAttribute("aria-current");
      const newActiveIndicator = SelectorEngine.findOne(`[data-bs-slide-to="${index}"]`, this._indicatorsElement);
      if (newActiveIndicator) {
        newActiveIndicator.classList.add(CLASS_NAME_ACTIVE$2);
        newActiveIndicator.setAttribute("aria-current", "true");
      }
    }
    _updateInterval() {
      const element = this._activeElement || this._getActive();
      if (!element) {
        return;
      }
      const elementInterval = Number.parseInt(element.getAttribute("data-bs-interval"), 10);
      this._config.interval = elementInterval || this._config.defaultInterval;
    }
    _slide(order2, element = null) {
      if (this._isSliding) {
        return;
      }
      const activeElement = this._getActive();
      const isNext = order2 === ORDER_NEXT;
      const nextElement = element || getNextActiveElement(this._getItems(), activeElement, isNext, this._config.wrap);
      if (nextElement === activeElement) {
        return;
      }
      const nextElementIndex = this._getItemIndex(nextElement);
      const triggerEvent = (eventName) => {
        return EventHandler.trigger(this._element, eventName, {
          relatedTarget: nextElement,
          direction: this._orderToDirection(order2),
          from: this._getItemIndex(activeElement),
          to: nextElementIndex
        });
      };
      const slideEvent = triggerEvent(EVENT_SLIDE);
      if (slideEvent.defaultPrevented) {
        return;
      }
      if (!activeElement || !nextElement) {
        return;
      }
      const isCycling = Boolean(this._interval);
      this.pause();
      this._isSliding = true;
      this._setActiveIndicatorElement(nextElementIndex);
      this._activeElement = nextElement;
      const directionalClassName = isNext ? CLASS_NAME_START : CLASS_NAME_END;
      const orderClassName = isNext ? CLASS_NAME_NEXT : CLASS_NAME_PREV;
      nextElement.classList.add(orderClassName);
      reflow(nextElement);
      activeElement.classList.add(directionalClassName);
      nextElement.classList.add(directionalClassName);
      const completeCallBack = () => {
        nextElement.classList.remove(directionalClassName, orderClassName);
        nextElement.classList.add(CLASS_NAME_ACTIVE$2);
        activeElement.classList.remove(CLASS_NAME_ACTIVE$2, orderClassName, directionalClassName);
        this._isSliding = false;
        triggerEvent(EVENT_SLID);
      };
      this._queueCallback(completeCallBack, activeElement, this._isAnimated());
      if (isCycling) {
        this.cycle();
      }
    }
    _isAnimated() {
      return this._element.classList.contains(CLASS_NAME_SLIDE);
    }
    _getActive() {
      return SelectorEngine.findOne(SELECTOR_ACTIVE_ITEM, this._element);
    }
    _getItems() {
      return SelectorEngine.find(SELECTOR_ITEM, this._element);
    }
    _clearInterval() {
      if (this._interval) {
        clearInterval(this._interval);
        this._interval = null;
      }
    }
    _directionToOrder(direction) {
      if (isRTL()) {
        return direction === DIRECTION_LEFT ? ORDER_PREV : ORDER_NEXT;
      }
      return direction === DIRECTION_LEFT ? ORDER_NEXT : ORDER_PREV;
    }
    _orderToDirection(order2) {
      if (isRTL()) {
        return order2 === ORDER_PREV ? DIRECTION_LEFT : DIRECTION_RIGHT;
      }
      return order2 === ORDER_PREV ? DIRECTION_RIGHT : DIRECTION_LEFT;
    }
    // Static
    static jQueryInterface(config) {
      return this.each(function() {
        const data = _Carousel.getOrCreateInstance(this, config);
        if (typeof config === "number") {
          data.to(config);
          return;
        }
        if (typeof config === "string") {
          if (data[config] === void 0 || config.startsWith("_") || config === "constructor") {
            throw new TypeError(`No method named "${config}"`);
          }
          data[config]();
        }
      });
    }
  };
  EventHandler.on(document, EVENT_CLICK_DATA_API$5, SELECTOR_DATA_SLIDE, function(event) {
    const target = SelectorEngine.getElementFromSelector(this);
    if (!target || !target.classList.contains(CLASS_NAME_CAROUSEL)) {
      return;
    }
    event.preventDefault();
    const carousel = Carousel.getOrCreateInstance(target);
    const slideIndex = this.getAttribute("data-bs-slide-to");
    if (slideIndex) {
      carousel.to(slideIndex);
      carousel._maybeEnableCycle();
      return;
    }
    if (Manipulator.getDataAttribute(this, "slide") === "next") {
      carousel.next();
      carousel._maybeEnableCycle();
      return;
    }
    carousel.prev();
    carousel._maybeEnableCycle();
  });
  EventHandler.on(window, EVENT_LOAD_DATA_API$3, () => {
    const carousels = SelectorEngine.find(SELECTOR_DATA_RIDE);
    for (const carousel of carousels) {
      Carousel.getOrCreateInstance(carousel);
    }
  });
  defineJQueryPlugin(Carousel);
  var NAME$b = "collapse";
  var DATA_KEY$7 = "bs.collapse";
  var EVENT_KEY$7 = `.${DATA_KEY$7}`;
  var DATA_API_KEY$4 = ".data-api";
  var EVENT_SHOW$6 = `show${EVENT_KEY$7}`;
  var EVENT_SHOWN$6 = `shown${EVENT_KEY$7}`;
  var EVENT_HIDE$6 = `hide${EVENT_KEY$7}`;
  var EVENT_HIDDEN$6 = `hidden${EVENT_KEY$7}`;
  var EVENT_CLICK_DATA_API$4 = `click${EVENT_KEY$7}${DATA_API_KEY$4}`;
  var CLASS_NAME_SHOW$7 = "show";
  var CLASS_NAME_COLLAPSE = "collapse";
  var CLASS_NAME_COLLAPSING = "collapsing";
  var CLASS_NAME_COLLAPSED = "collapsed";
  var CLASS_NAME_DEEPER_CHILDREN = `:scope .${CLASS_NAME_COLLAPSE} .${CLASS_NAME_COLLAPSE}`;
  var CLASS_NAME_HORIZONTAL = "collapse-horizontal";
  var WIDTH = "width";
  var HEIGHT = "height";
  var SELECTOR_ACTIVES = ".collapse.show, .collapse.collapsing";
  var SELECTOR_DATA_TOGGLE$4 = '[data-bs-toggle="collapse"]';
  var Default$a = {
    parent: null,
    toggle: true
  };
  var DefaultType$a = {
    parent: "(null|element)",
    toggle: "boolean"
  };
  var Collapse = class _Collapse extends BaseComponent {
    constructor(element, config) {
      super(element, config);
      this._isTransitioning = false;
      this._triggerArray = [];
      const toggleList = SelectorEngine.find(SELECTOR_DATA_TOGGLE$4);
      for (const elem of toggleList) {
        const selector = SelectorEngine.getSelectorFromElement(elem);
        const filterElement = SelectorEngine.find(selector).filter((foundElement) => foundElement === this._element);
        if (selector !== null && filterElement.length) {
          this._triggerArray.push(elem);
        }
      }
      this._initializeChildren();
      if (!this._config.parent) {
        this._addAriaAndCollapsedClass(this._triggerArray, this._isShown());
      }
      if (this._config.toggle) {
        this.toggle();
      }
    }
    // Getters
    static get Default() {
      return Default$a;
    }
    static get DefaultType() {
      return DefaultType$a;
    }
    static get NAME() {
      return NAME$b;
    }
    // Public
    toggle() {
      if (this._isShown()) {
        this.hide();
      } else {
        this.show();
      }
    }
    show() {
      if (this._isTransitioning || this._isShown()) {
        return;
      }
      let activeChildren = [];
      if (this._config.parent) {
        activeChildren = this._getFirstLevelChildren(SELECTOR_ACTIVES).filter((element) => element !== this._element).map((element) => _Collapse.getOrCreateInstance(element, {
          toggle: false
        }));
      }
      if (activeChildren.length && activeChildren[0]._isTransitioning) {
        return;
      }
      const startEvent = EventHandler.trigger(this._element, EVENT_SHOW$6);
      if (startEvent.defaultPrevented) {
        return;
      }
      for (const activeInstance of activeChildren) {
        activeInstance.hide();
      }
      const dimension = this._getDimension();
      this._element.classList.remove(CLASS_NAME_COLLAPSE);
      this._element.classList.add(CLASS_NAME_COLLAPSING);
      this._element.style[dimension] = 0;
      this._addAriaAndCollapsedClass(this._triggerArray, true);
      this._isTransitioning = true;
      const complete = () => {
        this._isTransitioning = false;
        this._element.classList.remove(CLASS_NAME_COLLAPSING);
        this._element.classList.add(CLASS_NAME_COLLAPSE, CLASS_NAME_SHOW$7);
        this._element.style[dimension] = "";
        EventHandler.trigger(this._element, EVENT_SHOWN$6);
      };
      const capitalizedDimension = dimension[0].toUpperCase() + dimension.slice(1);
      const scrollSize = `scroll${capitalizedDimension}`;
      this._queueCallback(complete, this._element, true);
      this._element.style[dimension] = `${this._element[scrollSize]}px`;
    }
    hide() {
      if (this._isTransitioning || !this._isShown()) {
        return;
      }
      const startEvent = EventHandler.trigger(this._element, EVENT_HIDE$6);
      if (startEvent.defaultPrevented) {
        return;
      }
      const dimension = this._getDimension();
      this._element.style[dimension] = `${this._element.getBoundingClientRect()[dimension]}px`;
      reflow(this._element);
      this._element.classList.add(CLASS_NAME_COLLAPSING);
      this._element.classList.remove(CLASS_NAME_COLLAPSE, CLASS_NAME_SHOW$7);
      for (const trigger of this._triggerArray) {
        const element = SelectorEngine.getElementFromSelector(trigger);
        if (element && !this._isShown(element)) {
          this._addAriaAndCollapsedClass([trigger], false);
        }
      }
      this._isTransitioning = true;
      const complete = () => {
        this._isTransitioning = false;
        this._element.classList.remove(CLASS_NAME_COLLAPSING);
        this._element.classList.add(CLASS_NAME_COLLAPSE);
        EventHandler.trigger(this._element, EVENT_HIDDEN$6);
      };
      this._element.style[dimension] = "";
      this._queueCallback(complete, this._element, true);
    }
    _isShown(element = this._element) {
      return element.classList.contains(CLASS_NAME_SHOW$7);
    }
    // Private
    _configAfterMerge(config) {
      config.toggle = Boolean(config.toggle);
      config.parent = getElement(config.parent);
      return config;
    }
    _getDimension() {
      return this._element.classList.contains(CLASS_NAME_HORIZONTAL) ? WIDTH : HEIGHT;
    }
    _initializeChildren() {
      if (!this._config.parent) {
        return;
      }
      const children = this._getFirstLevelChildren(SELECTOR_DATA_TOGGLE$4);
      for (const element of children) {
        const selected = SelectorEngine.getElementFromSelector(element);
        if (selected) {
          this._addAriaAndCollapsedClass([element], this._isShown(selected));
        }
      }
    }
    _getFirstLevelChildren(selector) {
      const children = SelectorEngine.find(CLASS_NAME_DEEPER_CHILDREN, this._config.parent);
      return SelectorEngine.find(selector, this._config.parent).filter((element) => !children.includes(element));
    }
    _addAriaAndCollapsedClass(triggerArray, isOpen) {
      if (!triggerArray.length) {
        return;
      }
      for (const element of triggerArray) {
        element.classList.toggle(CLASS_NAME_COLLAPSED, !isOpen);
        element.setAttribute("aria-expanded", isOpen);
      }
    }
    // Static
    static jQueryInterface(config) {
      const _config = {};
      if (typeof config === "string" && /show|hide/.test(config)) {
        _config.toggle = false;
      }
      return this.each(function() {
        const data = _Collapse.getOrCreateInstance(this, _config);
        if (typeof config === "string") {
          if (typeof data[config] === "undefined") {
            throw new TypeError(`No method named "${config}"`);
          }
          data[config]();
        }
      });
    }
  };
  EventHandler.on(document, EVENT_CLICK_DATA_API$4, SELECTOR_DATA_TOGGLE$4, function(event) {
    if (event.target.tagName === "A" || event.delegateTarget && event.delegateTarget.tagName === "A") {
      event.preventDefault();
    }
    for (const element of SelectorEngine.getMultipleElementsFromSelector(this)) {
      Collapse.getOrCreateInstance(element, {
        toggle: false
      }).toggle();
    }
  });
  defineJQueryPlugin(Collapse);
  var NAME$a = "dropdown";
  var DATA_KEY$6 = "bs.dropdown";
  var EVENT_KEY$6 = `.${DATA_KEY$6}`;
  var DATA_API_KEY$3 = ".data-api";
  var ESCAPE_KEY$2 = "Escape";
  var TAB_KEY$1 = "Tab";
  var ARROW_UP_KEY$1 = "ArrowUp";
  var ARROW_DOWN_KEY$1 = "ArrowDown";
  var RIGHT_MOUSE_BUTTON = 2;
  var EVENT_HIDE$5 = `hide${EVENT_KEY$6}`;
  var EVENT_HIDDEN$5 = `hidden${EVENT_KEY$6}`;
  var EVENT_SHOW$5 = `show${EVENT_KEY$6}`;
  var EVENT_SHOWN$5 = `shown${EVENT_KEY$6}`;
  var EVENT_CLICK_DATA_API$3 = `click${EVENT_KEY$6}${DATA_API_KEY$3}`;
  var EVENT_KEYDOWN_DATA_API = `keydown${EVENT_KEY$6}${DATA_API_KEY$3}`;
  var EVENT_KEYUP_DATA_API = `keyup${EVENT_KEY$6}${DATA_API_KEY$3}`;
  var CLASS_NAME_SHOW$6 = "show";
  var CLASS_NAME_DROPUP = "dropup";
  var CLASS_NAME_DROPEND = "dropend";
  var CLASS_NAME_DROPSTART = "dropstart";
  var CLASS_NAME_DROPUP_CENTER = "dropup-center";
  var CLASS_NAME_DROPDOWN_CENTER = "dropdown-center";
  var SELECTOR_DATA_TOGGLE$3 = '[data-bs-toggle="dropdown"]:not(.disabled):not(:disabled)';
  var SELECTOR_DATA_TOGGLE_SHOWN = `${SELECTOR_DATA_TOGGLE$3}.${CLASS_NAME_SHOW$6}`;
  var SELECTOR_MENU = ".dropdown-menu";
  var SELECTOR_NAVBAR = ".navbar";
  var SELECTOR_NAVBAR_NAV = ".navbar-nav";
  var SELECTOR_VISIBLE_ITEMS = ".dropdown-menu .dropdown-item:not(.disabled):not(:disabled)";
  var PLACEMENT_TOP = isRTL() ? "top-end" : "top-start";
  var PLACEMENT_TOPEND = isRTL() ? "top-start" : "top-end";
  var PLACEMENT_BOTTOM = isRTL() ? "bottom-end" : "bottom-start";
  var PLACEMENT_BOTTOMEND = isRTL() ? "bottom-start" : "bottom-end";
  var PLACEMENT_RIGHT = isRTL() ? "left-start" : "right-start";
  var PLACEMENT_LEFT = isRTL() ? "right-start" : "left-start";
  var PLACEMENT_TOPCENTER = "top";
  var PLACEMENT_BOTTOMCENTER = "bottom";
  var Default$9 = {
    autoClose: true,
    boundary: "clippingParents",
    display: "dynamic",
    offset: [0, 2],
    popperConfig: null,
    reference: "toggle"
  };
  var DefaultType$9 = {
    autoClose: "(boolean|string)",
    boundary: "(string|element)",
    display: "string",
    offset: "(array|string|function)",
    popperConfig: "(null|object|function)",
    reference: "(string|element|object)"
  };
  var Dropdown = class _Dropdown extends BaseComponent {
    constructor(element, config) {
      super(element, config);
      this._popper = null;
      this._parent = this._element.parentNode;
      this._menu = SelectorEngine.next(this._element, SELECTOR_MENU)[0] || SelectorEngine.prev(this._element, SELECTOR_MENU)[0] || SelectorEngine.findOne(SELECTOR_MENU, this._parent);
      this._inNavbar = this._detectNavbar();
    }
    // Getters
    static get Default() {
      return Default$9;
    }
    static get DefaultType() {
      return DefaultType$9;
    }
    static get NAME() {
      return NAME$a;
    }
    // Public
    toggle() {
      return this._isShown() ? this.hide() : this.show();
    }
    show() {
      if (isDisabled(this._element) || this._isShown()) {
        return;
      }
      const relatedTarget = {
        relatedTarget: this._element
      };
      const showEvent = EventHandler.trigger(this._element, EVENT_SHOW$5, relatedTarget);
      if (showEvent.defaultPrevented) {
        return;
      }
      this._createPopper();
      if ("ontouchstart" in document.documentElement && !this._parent.closest(SELECTOR_NAVBAR_NAV)) {
        for (const element of [].concat(...document.body.children)) {
          EventHandler.on(element, "mouseover", noop);
        }
      }
      this._element.focus();
      this._element.setAttribute("aria-expanded", true);
      this._menu.classList.add(CLASS_NAME_SHOW$6);
      this._element.classList.add(CLASS_NAME_SHOW$6);
      EventHandler.trigger(this._element, EVENT_SHOWN$5, relatedTarget);
    }
    hide() {
      if (isDisabled(this._element) || !this._isShown()) {
        return;
      }
      const relatedTarget = {
        relatedTarget: this._element
      };
      this._completeHide(relatedTarget);
    }
    dispose() {
      if (this._popper) {
        this._popper.destroy();
      }
      super.dispose();
    }
    update() {
      this._inNavbar = this._detectNavbar();
      if (this._popper) {
        this._popper.update();
      }
    }
    // Private
    _completeHide(relatedTarget) {
      const hideEvent = EventHandler.trigger(this._element, EVENT_HIDE$5, relatedTarget);
      if (hideEvent.defaultPrevented) {
        return;
      }
      if ("ontouchstart" in document.documentElement) {
        for (const element of [].concat(...document.body.children)) {
          EventHandler.off(element, "mouseover", noop);
        }
      }
      if (this._popper) {
        this._popper.destroy();
      }
      this._menu.classList.remove(CLASS_NAME_SHOW$6);
      this._element.classList.remove(CLASS_NAME_SHOW$6);
      this._element.setAttribute("aria-expanded", "false");
      Manipulator.removeDataAttribute(this._menu, "popper");
      EventHandler.trigger(this._element, EVENT_HIDDEN$5, relatedTarget);
    }
    _getConfig(config) {
      config = super._getConfig(config);
      if (typeof config.reference === "object" && !isElement2(config.reference) && typeof config.reference.getBoundingClientRect !== "function") {
        throw new TypeError(`${NAME$a.toUpperCase()}: Option "reference" provided type "object" without a required "getBoundingClientRect" method.`);
      }
      return config;
    }
    _createPopper() {
      if (typeof lib_exports === "undefined") {
        throw new TypeError("Bootstrap's dropdowns require Popper (https://popper.js.org)");
      }
      let referenceElement = this._element;
      if (this._config.reference === "parent") {
        referenceElement = this._parent;
      } else if (isElement2(this._config.reference)) {
        referenceElement = getElement(this._config.reference);
      } else if (typeof this._config.reference === "object") {
        referenceElement = this._config.reference;
      }
      const popperConfig = this._getPopperConfig();
      this._popper = createPopper3(referenceElement, this._menu, popperConfig);
    }
    _isShown() {
      return this._menu.classList.contains(CLASS_NAME_SHOW$6);
    }
    _getPlacement() {
      const parentDropdown = this._parent;
      if (parentDropdown.classList.contains(CLASS_NAME_DROPEND)) {
        return PLACEMENT_RIGHT;
      }
      if (parentDropdown.classList.contains(CLASS_NAME_DROPSTART)) {
        return PLACEMENT_LEFT;
      }
      if (parentDropdown.classList.contains(CLASS_NAME_DROPUP_CENTER)) {
        return PLACEMENT_TOPCENTER;
      }
      if (parentDropdown.classList.contains(CLASS_NAME_DROPDOWN_CENTER)) {
        return PLACEMENT_BOTTOMCENTER;
      }
      const isEnd = getComputedStyle(this._menu).getPropertyValue("--bs-position").trim() === "end";
      if (parentDropdown.classList.contains(CLASS_NAME_DROPUP)) {
        return isEnd ? PLACEMENT_TOPEND : PLACEMENT_TOP;
      }
      return isEnd ? PLACEMENT_BOTTOMEND : PLACEMENT_BOTTOM;
    }
    _detectNavbar() {
      return this._element.closest(SELECTOR_NAVBAR) !== null;
    }
    _getOffset() {
      const {
        offset: offset2
      } = this._config;
      if (typeof offset2 === "string") {
        return offset2.split(",").map((value) => Number.parseInt(value, 10));
      }
      if (typeof offset2 === "function") {
        return (popperData) => offset2(popperData, this._element);
      }
      return offset2;
    }
    _getPopperConfig() {
      const defaultBsPopperConfig = {
        placement: this._getPlacement(),
        modifiers: [{
          name: "preventOverflow",
          options: {
            boundary: this._config.boundary
          }
        }, {
          name: "offset",
          options: {
            offset: this._getOffset()
          }
        }]
      };
      if (this._inNavbar || this._config.display === "static") {
        Manipulator.setDataAttribute(this._menu, "popper", "static");
        defaultBsPopperConfig.modifiers = [{
          name: "applyStyles",
          enabled: false
        }];
      }
      return {
        ...defaultBsPopperConfig,
        ...execute(this._config.popperConfig, [defaultBsPopperConfig])
      };
    }
    _selectMenuItem({
      key,
      target
    }) {
      const items = SelectorEngine.find(SELECTOR_VISIBLE_ITEMS, this._menu).filter((element) => isVisible(element));
      if (!items.length) {
        return;
      }
      getNextActiveElement(items, target, key === ARROW_DOWN_KEY$1, !items.includes(target)).focus();
    }
    // Static
    static jQueryInterface(config) {
      return this.each(function() {
        const data = _Dropdown.getOrCreateInstance(this, config);
        if (typeof config !== "string") {
          return;
        }
        if (typeof data[config] === "undefined") {
          throw new TypeError(`No method named "${config}"`);
        }
        data[config]();
      });
    }
    static clearMenus(event) {
      if (event.button === RIGHT_MOUSE_BUTTON || event.type === "keyup" && event.key !== TAB_KEY$1) {
        return;
      }
      const openToggles = SelectorEngine.find(SELECTOR_DATA_TOGGLE_SHOWN);
      for (const toggle of openToggles) {
        const context = _Dropdown.getInstance(toggle);
        if (!context || context._config.autoClose === false) {
          continue;
        }
        const composedPath = event.composedPath();
        const isMenuTarget = composedPath.includes(context._menu);
        if (composedPath.includes(context._element) || context._config.autoClose === "inside" && !isMenuTarget || context._config.autoClose === "outside" && isMenuTarget) {
          continue;
        }
        if (context._menu.contains(event.target) && (event.type === "keyup" && event.key === TAB_KEY$1 || /input|select|option|textarea|form/i.test(event.target.tagName))) {
          continue;
        }
        const relatedTarget = {
          relatedTarget: context._element
        };
        if (event.type === "click") {
          relatedTarget.clickEvent = event;
        }
        context._completeHide(relatedTarget);
      }
    }
    static dataApiKeydownHandler(event) {
      const isInput = /input|textarea/i.test(event.target.tagName);
      const isEscapeEvent = event.key === ESCAPE_KEY$2;
      const isUpOrDownEvent = [ARROW_UP_KEY$1, ARROW_DOWN_KEY$1].includes(event.key);
      if (!isUpOrDownEvent && !isEscapeEvent) {
        return;
      }
      if (isInput && !isEscapeEvent) {
        return;
      }
      event.preventDefault();
      const getToggleButton = this.matches(SELECTOR_DATA_TOGGLE$3) ? this : SelectorEngine.prev(this, SELECTOR_DATA_TOGGLE$3)[0] || SelectorEngine.next(this, SELECTOR_DATA_TOGGLE$3)[0] || SelectorEngine.findOne(SELECTOR_DATA_TOGGLE$3, event.delegateTarget.parentNode);
      const instance = _Dropdown.getOrCreateInstance(getToggleButton);
      if (isUpOrDownEvent) {
        event.stopPropagation();
        instance.show();
        instance._selectMenuItem(event);
        return;
      }
      if (instance._isShown()) {
        event.stopPropagation();
        instance.hide();
        getToggleButton.focus();
      }
    }
  };
  EventHandler.on(document, EVENT_KEYDOWN_DATA_API, SELECTOR_DATA_TOGGLE$3, Dropdown.dataApiKeydownHandler);
  EventHandler.on(document, EVENT_KEYDOWN_DATA_API, SELECTOR_MENU, Dropdown.dataApiKeydownHandler);
  EventHandler.on(document, EVENT_CLICK_DATA_API$3, Dropdown.clearMenus);
  EventHandler.on(document, EVENT_KEYUP_DATA_API, Dropdown.clearMenus);
  EventHandler.on(document, EVENT_CLICK_DATA_API$3, SELECTOR_DATA_TOGGLE$3, function(event) {
    event.preventDefault();
    Dropdown.getOrCreateInstance(this).toggle();
  });
  defineJQueryPlugin(Dropdown);
  var NAME$9 = "backdrop";
  var CLASS_NAME_FADE$4 = "fade";
  var CLASS_NAME_SHOW$5 = "show";
  var EVENT_MOUSEDOWN = `mousedown.bs.${NAME$9}`;
  var Default$8 = {
    className: "modal-backdrop",
    clickCallback: null,
    isAnimated: false,
    isVisible: true,
    // if false, we use the backdrop helper without adding any element to the dom
    rootElement: "body"
    // give the choice to place backdrop under different elements
  };
  var DefaultType$8 = {
    className: "string",
    clickCallback: "(function|null)",
    isAnimated: "boolean",
    isVisible: "boolean",
    rootElement: "(element|string)"
  };
  var Backdrop = class extends Config {
    constructor(config) {
      super();
      this._config = this._getConfig(config);
      this._isAppended = false;
      this._element = null;
    }
    // Getters
    static get Default() {
      return Default$8;
    }
    static get DefaultType() {
      return DefaultType$8;
    }
    static get NAME() {
      return NAME$9;
    }
    // Public
    show(callback) {
      if (!this._config.isVisible) {
        execute(callback);
        return;
      }
      this._append();
      const element = this._getElement();
      if (this._config.isAnimated) {
        reflow(element);
      }
      element.classList.add(CLASS_NAME_SHOW$5);
      this._emulateAnimation(() => {
        execute(callback);
      });
    }
    hide(callback) {
      if (!this._config.isVisible) {
        execute(callback);
        return;
      }
      this._getElement().classList.remove(CLASS_NAME_SHOW$5);
      this._emulateAnimation(() => {
        this.dispose();
        execute(callback);
      });
    }
    dispose() {
      if (!this._isAppended) {
        return;
      }
      EventHandler.off(this._element, EVENT_MOUSEDOWN);
      this._element.remove();
      this._isAppended = false;
    }
    // Private
    _getElement() {
      if (!this._element) {
        const backdrop = document.createElement("div");
        backdrop.className = this._config.className;
        if (this._config.isAnimated) {
          backdrop.classList.add(CLASS_NAME_FADE$4);
        }
        this._element = backdrop;
      }
      return this._element;
    }
    _configAfterMerge(config) {
      config.rootElement = getElement(config.rootElement);
      return config;
    }
    _append() {
      if (this._isAppended) {
        return;
      }
      const element = this._getElement();
      this._config.rootElement.append(element);
      EventHandler.on(element, EVENT_MOUSEDOWN, () => {
        execute(this._config.clickCallback);
      });
      this._isAppended = true;
    }
    _emulateAnimation(callback) {
      executeAfterTransition(callback, this._getElement(), this._config.isAnimated);
    }
  };
  var NAME$8 = "focustrap";
  var DATA_KEY$5 = "bs.focustrap";
  var EVENT_KEY$5 = `.${DATA_KEY$5}`;
  var EVENT_FOCUSIN$2 = `focusin${EVENT_KEY$5}`;
  var EVENT_KEYDOWN_TAB = `keydown.tab${EVENT_KEY$5}`;
  var TAB_KEY = "Tab";
  var TAB_NAV_FORWARD = "forward";
  var TAB_NAV_BACKWARD = "backward";
  var Default$7 = {
    autofocus: true,
    trapElement: null
    // The element to trap focus inside of
  };
  var DefaultType$7 = {
    autofocus: "boolean",
    trapElement: "element"
  };
  var FocusTrap = class extends Config {
    constructor(config) {
      super();
      this._config = this._getConfig(config);
      this._isActive = false;
      this._lastTabNavDirection = null;
    }
    // Getters
    static get Default() {
      return Default$7;
    }
    static get DefaultType() {
      return DefaultType$7;
    }
    static get NAME() {
      return NAME$8;
    }
    // Public
    activate() {
      if (this._isActive) {
        return;
      }
      if (this._config.autofocus) {
        this._config.trapElement.focus();
      }
      EventHandler.off(document, EVENT_KEY$5);
      EventHandler.on(document, EVENT_FOCUSIN$2, (event) => this._handleFocusin(event));
      EventHandler.on(document, EVENT_KEYDOWN_TAB, (event) => this._handleKeydown(event));
      this._isActive = true;
    }
    deactivate() {
      if (!this._isActive) {
        return;
      }
      this._isActive = false;
      EventHandler.off(document, EVENT_KEY$5);
    }
    // Private
    _handleFocusin(event) {
      const {
        trapElement
      } = this._config;
      if (event.target === document || event.target === trapElement || trapElement.contains(event.target)) {
        return;
      }
      const elements = SelectorEngine.focusableChildren(trapElement);
      if (elements.length === 0) {
        trapElement.focus();
      } else if (this._lastTabNavDirection === TAB_NAV_BACKWARD) {
        elements[elements.length - 1].focus();
      } else {
        elements[0].focus();
      }
    }
    _handleKeydown(event) {
      if (event.key !== TAB_KEY) {
        return;
      }
      this._lastTabNavDirection = event.shiftKey ? TAB_NAV_BACKWARD : TAB_NAV_FORWARD;
    }
  };
  var SELECTOR_FIXED_CONTENT = ".fixed-top, .fixed-bottom, .is-fixed, .sticky-top";
  var SELECTOR_STICKY_CONTENT = ".sticky-top";
  var PROPERTY_PADDING = "padding-right";
  var PROPERTY_MARGIN = "margin-right";
  var ScrollBarHelper = class {
    constructor() {
      this._element = document.body;
    }
    // Public
    getWidth() {
      const documentWidth = document.documentElement.clientWidth;
      return Math.abs(window.innerWidth - documentWidth);
    }
    hide() {
      const width = this.getWidth();
      this._disableOverFlow();
      this._setElementAttributes(this._element, PROPERTY_PADDING, (calculatedValue) => calculatedValue + width);
      this._setElementAttributes(SELECTOR_FIXED_CONTENT, PROPERTY_PADDING, (calculatedValue) => calculatedValue + width);
      this._setElementAttributes(SELECTOR_STICKY_CONTENT, PROPERTY_MARGIN, (calculatedValue) => calculatedValue - width);
    }
    reset() {
      this._resetElementAttributes(this._element, "overflow");
      this._resetElementAttributes(this._element, PROPERTY_PADDING);
      this._resetElementAttributes(SELECTOR_FIXED_CONTENT, PROPERTY_PADDING);
      this._resetElementAttributes(SELECTOR_STICKY_CONTENT, PROPERTY_MARGIN);
    }
    isOverflowing() {
      return this.getWidth() > 0;
    }
    // Private
    _disableOverFlow() {
      this._saveInitialAttribute(this._element, "overflow");
      this._element.style.overflow = "hidden";
    }
    _setElementAttributes(selector, styleProperty, callback) {
      const scrollbarWidth = this.getWidth();
      const manipulationCallBack = (element) => {
        if (element !== this._element && window.innerWidth > element.clientWidth + scrollbarWidth) {
          return;
        }
        this._saveInitialAttribute(element, styleProperty);
        const calculatedValue = window.getComputedStyle(element).getPropertyValue(styleProperty);
        element.style.setProperty(styleProperty, `${callback(Number.parseFloat(calculatedValue))}px`);
      };
      this._applyManipulationCallback(selector, manipulationCallBack);
    }
    _saveInitialAttribute(element, styleProperty) {
      const actualValue = element.style.getPropertyValue(styleProperty);
      if (actualValue) {
        Manipulator.setDataAttribute(element, styleProperty, actualValue);
      }
    }
    _resetElementAttributes(selector, styleProperty) {
      const manipulationCallBack = (element) => {
        const value = Manipulator.getDataAttribute(element, styleProperty);
        if (value === null) {
          element.style.removeProperty(styleProperty);
          return;
        }
        Manipulator.removeDataAttribute(element, styleProperty);
        element.style.setProperty(styleProperty, value);
      };
      this._applyManipulationCallback(selector, manipulationCallBack);
    }
    _applyManipulationCallback(selector, callBack) {
      if (isElement2(selector)) {
        callBack(selector);
        return;
      }
      for (const sel of SelectorEngine.find(selector, this._element)) {
        callBack(sel);
      }
    }
  };
  var NAME$7 = "modal";
  var DATA_KEY$4 = "bs.modal";
  var EVENT_KEY$4 = `.${DATA_KEY$4}`;
  var DATA_API_KEY$2 = ".data-api";
  var ESCAPE_KEY$1 = "Escape";
  var EVENT_HIDE$4 = `hide${EVENT_KEY$4}`;
  var EVENT_HIDE_PREVENTED$1 = `hidePrevented${EVENT_KEY$4}`;
  var EVENT_HIDDEN$4 = `hidden${EVENT_KEY$4}`;
  var EVENT_SHOW$4 = `show${EVENT_KEY$4}`;
  var EVENT_SHOWN$4 = `shown${EVENT_KEY$4}`;
  var EVENT_RESIZE$1 = `resize${EVENT_KEY$4}`;
  var EVENT_CLICK_DISMISS = `click.dismiss${EVENT_KEY$4}`;
  var EVENT_MOUSEDOWN_DISMISS = `mousedown.dismiss${EVENT_KEY$4}`;
  var EVENT_KEYDOWN_DISMISS$1 = `keydown.dismiss${EVENT_KEY$4}`;
  var EVENT_CLICK_DATA_API$2 = `click${EVENT_KEY$4}${DATA_API_KEY$2}`;
  var CLASS_NAME_OPEN = "modal-open";
  var CLASS_NAME_FADE$3 = "fade";
  var CLASS_NAME_SHOW$4 = "show";
  var CLASS_NAME_STATIC = "modal-static";
  var OPEN_SELECTOR$1 = ".modal.show";
  var SELECTOR_DIALOG = ".modal-dialog";
  var SELECTOR_MODAL_BODY = ".modal-body";
  var SELECTOR_DATA_TOGGLE$2 = '[data-bs-toggle="modal"]';
  var Default$6 = {
    backdrop: true,
    focus: true,
    keyboard: true
  };
  var DefaultType$6 = {
    backdrop: "(boolean|string)",
    focus: "boolean",
    keyboard: "boolean"
  };
  var Modal = class _Modal extends BaseComponent {
    constructor(element, config) {
      super(element, config);
      this._dialog = SelectorEngine.findOne(SELECTOR_DIALOG, this._element);
      this._backdrop = this._initializeBackDrop();
      this._focustrap = this._initializeFocusTrap();
      this._isShown = false;
      this._isTransitioning = false;
      this._scrollBar = new ScrollBarHelper();
      this._addEventListeners();
    }
    // Getters
    static get Default() {
      return Default$6;
    }
    static get DefaultType() {
      return DefaultType$6;
    }
    static get NAME() {
      return NAME$7;
    }
    // Public
    toggle(relatedTarget) {
      return this._isShown ? this.hide() : this.show(relatedTarget);
    }
    show(relatedTarget) {
      if (this._isShown || this._isTransitioning) {
        return;
      }
      const showEvent = EventHandler.trigger(this._element, EVENT_SHOW$4, {
        relatedTarget
      });
      if (showEvent.defaultPrevented) {
        return;
      }
      this._isShown = true;
      this._isTransitioning = true;
      this._scrollBar.hide();
      document.body.classList.add(CLASS_NAME_OPEN);
      this._adjustDialog();
      this._backdrop.show(() => this._showElement(relatedTarget));
    }
    hide() {
      if (!this._isShown || this._isTransitioning) {
        return;
      }
      const hideEvent = EventHandler.trigger(this._element, EVENT_HIDE$4);
      if (hideEvent.defaultPrevented) {
        return;
      }
      this._isShown = false;
      this._isTransitioning = true;
      this._focustrap.deactivate();
      this._element.classList.remove(CLASS_NAME_SHOW$4);
      this._queueCallback(() => this._hideModal(), this._element, this._isAnimated());
    }
    dispose() {
      EventHandler.off(window, EVENT_KEY$4);
      EventHandler.off(this._dialog, EVENT_KEY$4);
      this._backdrop.dispose();
      this._focustrap.deactivate();
      super.dispose();
    }
    handleUpdate() {
      this._adjustDialog();
    }
    // Private
    _initializeBackDrop() {
      return new Backdrop({
        isVisible: Boolean(this._config.backdrop),
        // 'static' option will be translated to true, and booleans will keep their value,
        isAnimated: this._isAnimated()
      });
    }
    _initializeFocusTrap() {
      return new FocusTrap({
        trapElement: this._element
      });
    }
    _showElement(relatedTarget) {
      if (!document.body.contains(this._element)) {
        document.body.append(this._element);
      }
      this._element.style.display = "block";
      this._element.removeAttribute("aria-hidden");
      this._element.setAttribute("aria-modal", true);
      this._element.setAttribute("role", "dialog");
      this._element.scrollTop = 0;
      const modalBody = SelectorEngine.findOne(SELECTOR_MODAL_BODY, this._dialog);
      if (modalBody) {
        modalBody.scrollTop = 0;
      }
      reflow(this._element);
      this._element.classList.add(CLASS_NAME_SHOW$4);
      const transitionComplete = () => {
        if (this._config.focus) {
          this._focustrap.activate();
        }
        this._isTransitioning = false;
        EventHandler.trigger(this._element, EVENT_SHOWN$4, {
          relatedTarget
        });
      };
      this._queueCallback(transitionComplete, this._dialog, this._isAnimated());
    }
    _addEventListeners() {
      EventHandler.on(this._element, EVENT_KEYDOWN_DISMISS$1, (event) => {
        if (event.key !== ESCAPE_KEY$1) {
          return;
        }
        if (this._config.keyboard) {
          this.hide();
          return;
        }
        this._triggerBackdropTransition();
      });
      EventHandler.on(window, EVENT_RESIZE$1, () => {
        if (this._isShown && !this._isTransitioning) {
          this._adjustDialog();
        }
      });
      EventHandler.on(this._element, EVENT_MOUSEDOWN_DISMISS, (event) => {
        EventHandler.one(this._element, EVENT_CLICK_DISMISS, (event2) => {
          if (this._element !== event.target || this._element !== event2.target) {
            return;
          }
          if (this._config.backdrop === "static") {
            this._triggerBackdropTransition();
            return;
          }
          if (this._config.backdrop) {
            this.hide();
          }
        });
      });
    }
    _hideModal() {
      this._element.style.display = "none";
      this._element.setAttribute("aria-hidden", true);
      this._element.removeAttribute("aria-modal");
      this._element.removeAttribute("role");
      this._isTransitioning = false;
      this._backdrop.hide(() => {
        document.body.classList.remove(CLASS_NAME_OPEN);
        this._resetAdjustments();
        this._scrollBar.reset();
        EventHandler.trigger(this._element, EVENT_HIDDEN$4);
      });
    }
    _isAnimated() {
      return this._element.classList.contains(CLASS_NAME_FADE$3);
    }
    _triggerBackdropTransition() {
      const hideEvent = EventHandler.trigger(this._element, EVENT_HIDE_PREVENTED$1);
      if (hideEvent.defaultPrevented) {
        return;
      }
      const isModalOverflowing = this._element.scrollHeight > document.documentElement.clientHeight;
      const initialOverflowY = this._element.style.overflowY;
      if (initialOverflowY === "hidden" || this._element.classList.contains(CLASS_NAME_STATIC)) {
        return;
      }
      if (!isModalOverflowing) {
        this._element.style.overflowY = "hidden";
      }
      this._element.classList.add(CLASS_NAME_STATIC);
      this._queueCallback(() => {
        this._element.classList.remove(CLASS_NAME_STATIC);
        this._queueCallback(() => {
          this._element.style.overflowY = initialOverflowY;
        }, this._dialog);
      }, this._dialog);
      this._element.focus();
    }
    /**
     * The following methods are used to handle overflowing modals
     */
    _adjustDialog() {
      const isModalOverflowing = this._element.scrollHeight > document.documentElement.clientHeight;
      const scrollbarWidth = this._scrollBar.getWidth();
      const isBodyOverflowing = scrollbarWidth > 0;
      if (isBodyOverflowing && !isModalOverflowing) {
        const property = isRTL() ? "paddingLeft" : "paddingRight";
        this._element.style[property] = `${scrollbarWidth}px`;
      }
      if (!isBodyOverflowing && isModalOverflowing) {
        const property = isRTL() ? "paddingRight" : "paddingLeft";
        this._element.style[property] = `${scrollbarWidth}px`;
      }
    }
    _resetAdjustments() {
      this._element.style.paddingLeft = "";
      this._element.style.paddingRight = "";
    }
    // Static
    static jQueryInterface(config, relatedTarget) {
      return this.each(function() {
        const data = _Modal.getOrCreateInstance(this, config);
        if (typeof config !== "string") {
          return;
        }
        if (typeof data[config] === "undefined") {
          throw new TypeError(`No method named "${config}"`);
        }
        data[config](relatedTarget);
      });
    }
  };
  EventHandler.on(document, EVENT_CLICK_DATA_API$2, SELECTOR_DATA_TOGGLE$2, function(event) {
    const target = SelectorEngine.getElementFromSelector(this);
    if (["A", "AREA"].includes(this.tagName)) {
      event.preventDefault();
    }
    EventHandler.one(target, EVENT_SHOW$4, (showEvent) => {
      if (showEvent.defaultPrevented) {
        return;
      }
      EventHandler.one(target, EVENT_HIDDEN$4, () => {
        if (isVisible(this)) {
          this.focus();
        }
      });
    });
    const alreadyOpen = SelectorEngine.findOne(OPEN_SELECTOR$1);
    if (alreadyOpen) {
      Modal.getInstance(alreadyOpen).hide();
    }
    const data = Modal.getOrCreateInstance(target);
    data.toggle(this);
  });
  enableDismissTrigger(Modal);
  defineJQueryPlugin(Modal);
  var NAME$6 = "offcanvas";
  var DATA_KEY$3 = "bs.offcanvas";
  var EVENT_KEY$3 = `.${DATA_KEY$3}`;
  var DATA_API_KEY$1 = ".data-api";
  var EVENT_LOAD_DATA_API$2 = `load${EVENT_KEY$3}${DATA_API_KEY$1}`;
  var ESCAPE_KEY = "Escape";
  var CLASS_NAME_SHOW$3 = "show";
  var CLASS_NAME_SHOWING$1 = "showing";
  var CLASS_NAME_HIDING = "hiding";
  var CLASS_NAME_BACKDROP = "offcanvas-backdrop";
  var OPEN_SELECTOR = ".offcanvas.show";
  var EVENT_SHOW$3 = `show${EVENT_KEY$3}`;
  var EVENT_SHOWN$3 = `shown${EVENT_KEY$3}`;
  var EVENT_HIDE$3 = `hide${EVENT_KEY$3}`;
  var EVENT_HIDE_PREVENTED = `hidePrevented${EVENT_KEY$3}`;
  var EVENT_HIDDEN$3 = `hidden${EVENT_KEY$3}`;
  var EVENT_RESIZE = `resize${EVENT_KEY$3}`;
  var EVENT_CLICK_DATA_API$1 = `click${EVENT_KEY$3}${DATA_API_KEY$1}`;
  var EVENT_KEYDOWN_DISMISS = `keydown.dismiss${EVENT_KEY$3}`;
  var SELECTOR_DATA_TOGGLE$1 = '[data-bs-toggle="offcanvas"]';
  var Default$5 = {
    backdrop: true,
    keyboard: true,
    scroll: false
  };
  var DefaultType$5 = {
    backdrop: "(boolean|string)",
    keyboard: "boolean",
    scroll: "boolean"
  };
  var Offcanvas = class _Offcanvas extends BaseComponent {
    constructor(element, config) {
      super(element, config);
      this._isShown = false;
      this._backdrop = this._initializeBackDrop();
      this._focustrap = this._initializeFocusTrap();
      this._addEventListeners();
    }
    // Getters
    static get Default() {
      return Default$5;
    }
    static get DefaultType() {
      return DefaultType$5;
    }
    static get NAME() {
      return NAME$6;
    }
    // Public
    toggle(relatedTarget) {
      return this._isShown ? this.hide() : this.show(relatedTarget);
    }
    show(relatedTarget) {
      if (this._isShown) {
        return;
      }
      const showEvent = EventHandler.trigger(this._element, EVENT_SHOW$3, {
        relatedTarget
      });
      if (showEvent.defaultPrevented) {
        return;
      }
      this._isShown = true;
      this._backdrop.show();
      if (!this._config.scroll) {
        new ScrollBarHelper().hide();
      }
      this._element.setAttribute("aria-modal", true);
      this._element.setAttribute("role", "dialog");
      this._element.classList.add(CLASS_NAME_SHOWING$1);
      const completeCallBack = () => {
        if (!this._config.scroll || this._config.backdrop) {
          this._focustrap.activate();
        }
        this._element.classList.add(CLASS_NAME_SHOW$3);
        this._element.classList.remove(CLASS_NAME_SHOWING$1);
        EventHandler.trigger(this._element, EVENT_SHOWN$3, {
          relatedTarget
        });
      };
      this._queueCallback(completeCallBack, this._element, true);
    }
    hide() {
      if (!this._isShown) {
        return;
      }
      const hideEvent = EventHandler.trigger(this._element, EVENT_HIDE$3);
      if (hideEvent.defaultPrevented) {
        return;
      }
      this._focustrap.deactivate();
      this._element.blur();
      this._isShown = false;
      this._element.classList.add(CLASS_NAME_HIDING);
      this._backdrop.hide();
      const completeCallback = () => {
        this._element.classList.remove(CLASS_NAME_SHOW$3, CLASS_NAME_HIDING);
        this._element.removeAttribute("aria-modal");
        this._element.removeAttribute("role");
        if (!this._config.scroll) {
          new ScrollBarHelper().reset();
        }
        EventHandler.trigger(this._element, EVENT_HIDDEN$3);
      };
      this._queueCallback(completeCallback, this._element, true);
    }
    dispose() {
      this._backdrop.dispose();
      this._focustrap.deactivate();
      super.dispose();
    }
    // Private
    _initializeBackDrop() {
      const clickCallback = () => {
        if (this._config.backdrop === "static") {
          EventHandler.trigger(this._element, EVENT_HIDE_PREVENTED);
          return;
        }
        this.hide();
      };
      const isVisible2 = Boolean(this._config.backdrop);
      return new Backdrop({
        className: CLASS_NAME_BACKDROP,
        isVisible: isVisible2,
        isAnimated: true,
        rootElement: this._element.parentNode,
        clickCallback: isVisible2 ? clickCallback : null
      });
    }
    _initializeFocusTrap() {
      return new FocusTrap({
        trapElement: this._element
      });
    }
    _addEventListeners() {
      EventHandler.on(this._element, EVENT_KEYDOWN_DISMISS, (event) => {
        if (event.key !== ESCAPE_KEY) {
          return;
        }
        if (this._config.keyboard) {
          this.hide();
          return;
        }
        EventHandler.trigger(this._element, EVENT_HIDE_PREVENTED);
      });
    }
    // Static
    static jQueryInterface(config) {
      return this.each(function() {
        const data = _Offcanvas.getOrCreateInstance(this, config);
        if (typeof config !== "string") {
          return;
        }
        if (data[config] === void 0 || config.startsWith("_") || config === "constructor") {
          throw new TypeError(`No method named "${config}"`);
        }
        data[config](this);
      });
    }
  };
  EventHandler.on(document, EVENT_CLICK_DATA_API$1, SELECTOR_DATA_TOGGLE$1, function(event) {
    const target = SelectorEngine.getElementFromSelector(this);
    if (["A", "AREA"].includes(this.tagName)) {
      event.preventDefault();
    }
    if (isDisabled(this)) {
      return;
    }
    EventHandler.one(target, EVENT_HIDDEN$3, () => {
      if (isVisible(this)) {
        this.focus();
      }
    });
    const alreadyOpen = SelectorEngine.findOne(OPEN_SELECTOR);
    if (alreadyOpen && alreadyOpen !== target) {
      Offcanvas.getInstance(alreadyOpen).hide();
    }
    const data = Offcanvas.getOrCreateInstance(target);
    data.toggle(this);
  });
  EventHandler.on(window, EVENT_LOAD_DATA_API$2, () => {
    for (const selector of SelectorEngine.find(OPEN_SELECTOR)) {
      Offcanvas.getOrCreateInstance(selector).show();
    }
  });
  EventHandler.on(window, EVENT_RESIZE, () => {
    for (const element of SelectorEngine.find("[aria-modal][class*=show][class*=offcanvas-]")) {
      if (getComputedStyle(element).position !== "fixed") {
        Offcanvas.getOrCreateInstance(element).hide();
      }
    }
  });
  enableDismissTrigger(Offcanvas);
  defineJQueryPlugin(Offcanvas);
  var ARIA_ATTRIBUTE_PATTERN = /^aria-[\w-]*$/i;
  var DefaultAllowlist = {
    // Global attributes allowed on any supplied element below.
    "*": ["class", "dir", "id", "lang", "role", ARIA_ATTRIBUTE_PATTERN],
    a: ["target", "href", "title", "rel"],
    area: [],
    b: [],
    br: [],
    col: [],
    code: [],
    div: [],
    em: [],
    hr: [],
    h1: [],
    h2: [],
    h3: [],
    h4: [],
    h5: [],
    h6: [],
    i: [],
    img: ["src", "srcset", "alt", "title", "width", "height"],
    li: [],
    ol: [],
    p: [],
    pre: [],
    s: [],
    small: [],
    span: [],
    sub: [],
    sup: [],
    strong: [],
    u: [],
    ul: []
  };
  var uriAttributes = /* @__PURE__ */ new Set(["background", "cite", "href", "itemtype", "longdesc", "poster", "src", "xlink:href"]);
  var SAFE_URL_PATTERN = /^(?!javascript:)(?:[a-z0-9+.-]+:|[^&:/?#]*(?:[/?#]|$))/i;
  var allowedAttribute = (attribute, allowedAttributeList) => {
    const attributeName = attribute.nodeName.toLowerCase();
    if (allowedAttributeList.includes(attributeName)) {
      if (uriAttributes.has(attributeName)) {
        return Boolean(SAFE_URL_PATTERN.test(attribute.nodeValue));
      }
      return true;
    }
    return allowedAttributeList.filter((attributeRegex) => attributeRegex instanceof RegExp).some((regex) => regex.test(attributeName));
  };
  function sanitizeHtml(unsafeHtml, allowList, sanitizeFunction) {
    if (!unsafeHtml.length) {
      return unsafeHtml;
    }
    if (sanitizeFunction && typeof sanitizeFunction === "function") {
      return sanitizeFunction(unsafeHtml);
    }
    const domParser = new window.DOMParser();
    const createdDocument = domParser.parseFromString(unsafeHtml, "text/html");
    const elements = [].concat(...createdDocument.body.querySelectorAll("*"));
    for (const element of elements) {
      const elementName = element.nodeName.toLowerCase();
      if (!Object.keys(allowList).includes(elementName)) {
        element.remove();
        continue;
      }
      const attributeList = [].concat(...element.attributes);
      const allowedAttributes = [].concat(allowList["*"] || [], allowList[elementName] || []);
      for (const attribute of attributeList) {
        if (!allowedAttribute(attribute, allowedAttributes)) {
          element.removeAttribute(attribute.nodeName);
        }
      }
    }
    return createdDocument.body.innerHTML;
  }
  var NAME$5 = "TemplateFactory";
  var Default$4 = {
    allowList: DefaultAllowlist,
    content: {},
    // { selector : text ,  selector2 : text2 , }
    extraClass: "",
    html: false,
    sanitize: true,
    sanitizeFn: null,
    template: "<div></div>"
  };
  var DefaultType$4 = {
    allowList: "object",
    content: "object",
    extraClass: "(string|function)",
    html: "boolean",
    sanitize: "boolean",
    sanitizeFn: "(null|function)",
    template: "string"
  };
  var DefaultContentType = {
    entry: "(string|element|function|null)",
    selector: "(string|element)"
  };
  var TemplateFactory = class extends Config {
    constructor(config) {
      super();
      this._config = this._getConfig(config);
    }
    // Getters
    static get Default() {
      return Default$4;
    }
    static get DefaultType() {
      return DefaultType$4;
    }
    static get NAME() {
      return NAME$5;
    }
    // Public
    getContent() {
      return Object.values(this._config.content).map((config) => this._resolvePossibleFunction(config)).filter(Boolean);
    }
    hasContent() {
      return this.getContent().length > 0;
    }
    changeContent(content) {
      this._checkContent(content);
      this._config.content = {
        ...this._config.content,
        ...content
      };
      return this;
    }
    toHtml() {
      const templateWrapper = document.createElement("div");
      templateWrapper.innerHTML = this._maybeSanitize(this._config.template);
      for (const [selector, text] of Object.entries(this._config.content)) {
        this._setContent(templateWrapper, text, selector);
      }
      const template = templateWrapper.children[0];
      const extraClass = this._resolvePossibleFunction(this._config.extraClass);
      if (extraClass) {
        template.classList.add(...extraClass.split(" "));
      }
      return template;
    }
    // Private
    _typeCheckConfig(config) {
      super._typeCheckConfig(config);
      this._checkContent(config.content);
    }
    _checkContent(arg) {
      for (const [selector, content] of Object.entries(arg)) {
        super._typeCheckConfig({
          selector,
          entry: content
        }, DefaultContentType);
      }
    }
    _setContent(template, content, selector) {
      const templateElement = SelectorEngine.findOne(selector, template);
      if (!templateElement) {
        return;
      }
      content = this._resolvePossibleFunction(content);
      if (!content) {
        templateElement.remove();
        return;
      }
      if (isElement2(content)) {
        this._putElementInTemplate(getElement(content), templateElement);
        return;
      }
      if (this._config.html) {
        templateElement.innerHTML = this._maybeSanitize(content);
        return;
      }
      templateElement.textContent = content;
    }
    _maybeSanitize(arg) {
      return this._config.sanitize ? sanitizeHtml(arg, this._config.allowList, this._config.sanitizeFn) : arg;
    }
    _resolvePossibleFunction(arg) {
      return execute(arg, [this]);
    }
    _putElementInTemplate(element, templateElement) {
      if (this._config.html) {
        templateElement.innerHTML = "";
        templateElement.append(element);
        return;
      }
      templateElement.textContent = element.textContent;
    }
  };
  var NAME$4 = "tooltip";
  var DISALLOWED_ATTRIBUTES = /* @__PURE__ */ new Set(["sanitize", "allowList", "sanitizeFn"]);
  var CLASS_NAME_FADE$2 = "fade";
  var CLASS_NAME_MODAL = "modal";
  var CLASS_NAME_SHOW$2 = "show";
  var SELECTOR_TOOLTIP_INNER = ".tooltip-inner";
  var SELECTOR_MODAL = `.${CLASS_NAME_MODAL}`;
  var EVENT_MODAL_HIDE = "hide.bs.modal";
  var TRIGGER_HOVER = "hover";
  var TRIGGER_FOCUS = "focus";
  var TRIGGER_CLICK = "click";
  var TRIGGER_MANUAL = "manual";
  var EVENT_HIDE$2 = "hide";
  var EVENT_HIDDEN$2 = "hidden";
  var EVENT_SHOW$2 = "show";
  var EVENT_SHOWN$2 = "shown";
  var EVENT_INSERTED = "inserted";
  var EVENT_CLICK$1 = "click";
  var EVENT_FOCUSIN$1 = "focusin";
  var EVENT_FOCUSOUT$1 = "focusout";
  var EVENT_MOUSEENTER = "mouseenter";
  var EVENT_MOUSELEAVE = "mouseleave";
  var AttachmentMap = {
    AUTO: "auto",
    TOP: "top",
    RIGHT: isRTL() ? "left" : "right",
    BOTTOM: "bottom",
    LEFT: isRTL() ? "right" : "left"
  };
  var Default$3 = {
    allowList: DefaultAllowlist,
    animation: true,
    boundary: "clippingParents",
    container: false,
    customClass: "",
    delay: 0,
    fallbackPlacements: ["top", "right", "bottom", "left"],
    html: false,
    offset: [0, 6],
    placement: "top",
    popperConfig: null,
    sanitize: true,
    sanitizeFn: null,
    selector: false,
    template: '<div class="tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',
    title: "",
    trigger: "hover focus"
  };
  var DefaultType$3 = {
    allowList: "object",
    animation: "boolean",
    boundary: "(string|element)",
    container: "(string|element|boolean)",
    customClass: "(string|function)",
    delay: "(number|object)",
    fallbackPlacements: "array",
    html: "boolean",
    offset: "(array|string|function)",
    placement: "(string|function)",
    popperConfig: "(null|object|function)",
    sanitize: "boolean",
    sanitizeFn: "(null|function)",
    selector: "(string|boolean)",
    template: "string",
    title: "(string|element|function)",
    trigger: "string"
  };
  var Tooltip = class _Tooltip extends BaseComponent {
    constructor(element, config) {
      if (typeof lib_exports === "undefined") {
        throw new TypeError("Bootstrap's tooltips require Popper (https://popper.js.org)");
      }
      super(element, config);
      this._isEnabled = true;
      this._timeout = 0;
      this._isHovered = null;
      this._activeTrigger = {};
      this._popper = null;
      this._templateFactory = null;
      this._newContent = null;
      this.tip = null;
      this._setListeners();
      if (!this._config.selector) {
        this._fixTitle();
      }
    }
    // Getters
    static get Default() {
      return Default$3;
    }
    static get DefaultType() {
      return DefaultType$3;
    }
    static get NAME() {
      return NAME$4;
    }
    // Public
    enable() {
      this._isEnabled = true;
    }
    disable() {
      this._isEnabled = false;
    }
    toggleEnabled() {
      this._isEnabled = !this._isEnabled;
    }
    toggle() {
      if (!this._isEnabled) {
        return;
      }
      this._activeTrigger.click = !this._activeTrigger.click;
      if (this._isShown()) {
        this._leave();
        return;
      }
      this._enter();
    }
    dispose() {
      clearTimeout(this._timeout);
      EventHandler.off(this._element.closest(SELECTOR_MODAL), EVENT_MODAL_HIDE, this._hideModalHandler);
      if (this._element.getAttribute("data-bs-original-title")) {
        this._element.setAttribute("title", this._element.getAttribute("data-bs-original-title"));
      }
      this._disposePopper();
      super.dispose();
    }
    show() {
      if (this._element.style.display === "none") {
        throw new Error("Please use show on visible elements");
      }
      if (!(this._isWithContent() && this._isEnabled)) {
        return;
      }
      const showEvent = EventHandler.trigger(this._element, this.constructor.eventName(EVENT_SHOW$2));
      const shadowRoot = findShadowRoot(this._element);
      const isInTheDom = (shadowRoot || this._element.ownerDocument.documentElement).contains(this._element);
      if (showEvent.defaultPrevented || !isInTheDom) {
        return;
      }
      this._disposePopper();
      const tip = this._getTipElement();
      this._element.setAttribute("aria-describedby", tip.getAttribute("id"));
      const {
        container
      } = this._config;
      if (!this._element.ownerDocument.documentElement.contains(this.tip)) {
        container.append(tip);
        EventHandler.trigger(this._element, this.constructor.eventName(EVENT_INSERTED));
      }
      this._popper = this._createPopper(tip);
      tip.classList.add(CLASS_NAME_SHOW$2);
      if ("ontouchstart" in document.documentElement) {
        for (const element of [].concat(...document.body.children)) {
          EventHandler.on(element, "mouseover", noop);
        }
      }
      const complete = () => {
        EventHandler.trigger(this._element, this.constructor.eventName(EVENT_SHOWN$2));
        if (this._isHovered === false) {
          this._leave();
        }
        this._isHovered = false;
      };
      this._queueCallback(complete, this.tip, this._isAnimated());
    }
    hide() {
      if (!this._isShown()) {
        return;
      }
      const hideEvent = EventHandler.trigger(this._element, this.constructor.eventName(EVENT_HIDE$2));
      if (hideEvent.defaultPrevented) {
        return;
      }
      const tip = this._getTipElement();
      tip.classList.remove(CLASS_NAME_SHOW$2);
      if ("ontouchstart" in document.documentElement) {
        for (const element of [].concat(...document.body.children)) {
          EventHandler.off(element, "mouseover", noop);
        }
      }
      this._activeTrigger[TRIGGER_CLICK] = false;
      this._activeTrigger[TRIGGER_FOCUS] = false;
      this._activeTrigger[TRIGGER_HOVER] = false;
      this._isHovered = null;
      const complete = () => {
        if (this._isWithActiveTrigger()) {
          return;
        }
        if (!this._isHovered) {
          this._disposePopper();
        }
        this._element.removeAttribute("aria-describedby");
        EventHandler.trigger(this._element, this.constructor.eventName(EVENT_HIDDEN$2));
      };
      this._queueCallback(complete, this.tip, this._isAnimated());
    }
    update() {
      if (this._popper) {
        this._popper.update();
      }
    }
    // Protected
    _isWithContent() {
      return Boolean(this._getTitle());
    }
    _getTipElement() {
      if (!this.tip) {
        this.tip = this._createTipElement(this._newContent || this._getContentForTemplate());
      }
      return this.tip;
    }
    _createTipElement(content) {
      const tip = this._getTemplateFactory(content).toHtml();
      if (!tip) {
        return null;
      }
      tip.classList.remove(CLASS_NAME_FADE$2, CLASS_NAME_SHOW$2);
      tip.classList.add(`bs-${this.constructor.NAME}-auto`);
      const tipId = getUID(this.constructor.NAME).toString();
      tip.setAttribute("id", tipId);
      if (this._isAnimated()) {
        tip.classList.add(CLASS_NAME_FADE$2);
      }
      return tip;
    }
    setContent(content) {
      this._newContent = content;
      if (this._isShown()) {
        this._disposePopper();
        this.show();
      }
    }
    _getTemplateFactory(content) {
      if (this._templateFactory) {
        this._templateFactory.changeContent(content);
      } else {
        this._templateFactory = new TemplateFactory({
          ...this._config,
          // the `content` var has to be after `this._config`
          // to override config.content in case of popover
          content,
          extraClass: this._resolvePossibleFunction(this._config.customClass)
        });
      }
      return this._templateFactory;
    }
    _getContentForTemplate() {
      return {
        [SELECTOR_TOOLTIP_INNER]: this._getTitle()
      };
    }
    _getTitle() {
      return this._resolvePossibleFunction(this._config.title) || this._element.getAttribute("data-bs-original-title");
    }
    // Private
    _initializeOnDelegatedTarget(event) {
      return this.constructor.getOrCreateInstance(event.delegateTarget, this._getDelegateConfig());
    }
    _isAnimated() {
      return this._config.animation || this.tip && this.tip.classList.contains(CLASS_NAME_FADE$2);
    }
    _isShown() {
      return this.tip && this.tip.classList.contains(CLASS_NAME_SHOW$2);
    }
    _createPopper(tip) {
      const placement = execute(this._config.placement, [this, tip, this._element]);
      const attachment = AttachmentMap[placement.toUpperCase()];
      return createPopper3(this._element, tip, this._getPopperConfig(attachment));
    }
    _getOffset() {
      const {
        offset: offset2
      } = this._config;
      if (typeof offset2 === "string") {
        return offset2.split(",").map((value) => Number.parseInt(value, 10));
      }
      if (typeof offset2 === "function") {
        return (popperData) => offset2(popperData, this._element);
      }
      return offset2;
    }
    _resolvePossibleFunction(arg) {
      return execute(arg, [this._element]);
    }
    _getPopperConfig(attachment) {
      const defaultBsPopperConfig = {
        placement: attachment,
        modifiers: [{
          name: "flip",
          options: {
            fallbackPlacements: this._config.fallbackPlacements
          }
        }, {
          name: "offset",
          options: {
            offset: this._getOffset()
          }
        }, {
          name: "preventOverflow",
          options: {
            boundary: this._config.boundary
          }
        }, {
          name: "arrow",
          options: {
            element: `.${this.constructor.NAME}-arrow`
          }
        }, {
          name: "preSetPlacement",
          enabled: true,
          phase: "beforeMain",
          fn: (data) => {
            this._getTipElement().setAttribute("data-popper-placement", data.state.placement);
          }
        }]
      };
      return {
        ...defaultBsPopperConfig,
        ...execute(this._config.popperConfig, [defaultBsPopperConfig])
      };
    }
    _setListeners() {
      const triggers = this._config.trigger.split(" ");
      for (const trigger of triggers) {
        if (trigger === "click") {
          EventHandler.on(this._element, this.constructor.eventName(EVENT_CLICK$1), this._config.selector, (event) => {
            const context = this._initializeOnDelegatedTarget(event);
            context.toggle();
          });
        } else if (trigger !== TRIGGER_MANUAL) {
          const eventIn = trigger === TRIGGER_HOVER ? this.constructor.eventName(EVENT_MOUSEENTER) : this.constructor.eventName(EVENT_FOCUSIN$1);
          const eventOut = trigger === TRIGGER_HOVER ? this.constructor.eventName(EVENT_MOUSELEAVE) : this.constructor.eventName(EVENT_FOCUSOUT$1);
          EventHandler.on(this._element, eventIn, this._config.selector, (event) => {
            const context = this._initializeOnDelegatedTarget(event);
            context._activeTrigger[event.type === "focusin" ? TRIGGER_FOCUS : TRIGGER_HOVER] = true;
            context._enter();
          });
          EventHandler.on(this._element, eventOut, this._config.selector, (event) => {
            const context = this._initializeOnDelegatedTarget(event);
            context._activeTrigger[event.type === "focusout" ? TRIGGER_FOCUS : TRIGGER_HOVER] = context._element.contains(event.relatedTarget);
            context._leave();
          });
        }
      }
      this._hideModalHandler = () => {
        if (this._element) {
          this.hide();
        }
      };
      EventHandler.on(this._element.closest(SELECTOR_MODAL), EVENT_MODAL_HIDE, this._hideModalHandler);
    }
    _fixTitle() {
      const title = this._element.getAttribute("title");
      if (!title) {
        return;
      }
      if (!this._element.getAttribute("aria-label") && !this._element.textContent.trim()) {
        this._element.setAttribute("aria-label", title);
      }
      this._element.setAttribute("data-bs-original-title", title);
      this._element.removeAttribute("title");
    }
    _enter() {
      if (this._isShown() || this._isHovered) {
        this._isHovered = true;
        return;
      }
      this._isHovered = true;
      this._setTimeout(() => {
        if (this._isHovered) {
          this.show();
        }
      }, this._config.delay.show);
    }
    _leave() {
      if (this._isWithActiveTrigger()) {
        return;
      }
      this._isHovered = false;
      this._setTimeout(() => {
        if (!this._isHovered) {
          this.hide();
        }
      }, this._config.delay.hide);
    }
    _setTimeout(handler, timeout) {
      clearTimeout(this._timeout);
      this._timeout = setTimeout(handler, timeout);
    }
    _isWithActiveTrigger() {
      return Object.values(this._activeTrigger).includes(true);
    }
    _getConfig(config) {
      const dataAttributes = Manipulator.getDataAttributes(this._element);
      for (const dataAttribute of Object.keys(dataAttributes)) {
        if (DISALLOWED_ATTRIBUTES.has(dataAttribute)) {
          delete dataAttributes[dataAttribute];
        }
      }
      config = {
        ...dataAttributes,
        ...typeof config === "object" && config ? config : {}
      };
      config = this._mergeConfigObj(config);
      config = this._configAfterMerge(config);
      this._typeCheckConfig(config);
      return config;
    }
    _configAfterMerge(config) {
      config.container = config.container === false ? document.body : getElement(config.container);
      if (typeof config.delay === "number") {
        config.delay = {
          show: config.delay,
          hide: config.delay
        };
      }
      if (typeof config.title === "number") {
        config.title = config.title.toString();
      }
      if (typeof config.content === "number") {
        config.content = config.content.toString();
      }
      return config;
    }
    _getDelegateConfig() {
      const config = {};
      for (const [key, value] of Object.entries(this._config)) {
        if (this.constructor.Default[key] !== value) {
          config[key] = value;
        }
      }
      config.selector = false;
      config.trigger = "manual";
      return config;
    }
    _disposePopper() {
      if (this._popper) {
        this._popper.destroy();
        this._popper = null;
      }
      if (this.tip) {
        this.tip.remove();
        this.tip = null;
      }
    }
    // Static
    static jQueryInterface(config) {
      return this.each(function() {
        const data = _Tooltip.getOrCreateInstance(this, config);
        if (typeof config !== "string") {
          return;
        }
        if (typeof data[config] === "undefined") {
          throw new TypeError(`No method named "${config}"`);
        }
        data[config]();
      });
    }
  };
  defineJQueryPlugin(Tooltip);
  var NAME$3 = "popover";
  var SELECTOR_TITLE = ".popover-header";
  var SELECTOR_CONTENT = ".popover-body";
  var Default$2 = {
    ...Tooltip.Default,
    content: "",
    offset: [0, 8],
    placement: "right",
    template: '<div class="popover" role="tooltip"><div class="popover-arrow"></div><h3 class="popover-header"></h3><div class="popover-body"></div></div>',
    trigger: "click"
  };
  var DefaultType$2 = {
    ...Tooltip.DefaultType,
    content: "(null|string|element|function)"
  };
  var Popover = class _Popover extends Tooltip {
    // Getters
    static get Default() {
      return Default$2;
    }
    static get DefaultType() {
      return DefaultType$2;
    }
    static get NAME() {
      return NAME$3;
    }
    // Overrides
    _isWithContent() {
      return this._getTitle() || this._getContent();
    }
    // Private
    _getContentForTemplate() {
      return {
        [SELECTOR_TITLE]: this._getTitle(),
        [SELECTOR_CONTENT]: this._getContent()
      };
    }
    _getContent() {
      return this._resolvePossibleFunction(this._config.content);
    }
    // Static
    static jQueryInterface(config) {
      return this.each(function() {
        const data = _Popover.getOrCreateInstance(this, config);
        if (typeof config !== "string") {
          return;
        }
        if (typeof data[config] === "undefined") {
          throw new TypeError(`No method named "${config}"`);
        }
        data[config]();
      });
    }
  };
  defineJQueryPlugin(Popover);
  var NAME$2 = "scrollspy";
  var DATA_KEY$2 = "bs.scrollspy";
  var EVENT_KEY$2 = `.${DATA_KEY$2}`;
  var DATA_API_KEY = ".data-api";
  var EVENT_ACTIVATE = `activate${EVENT_KEY$2}`;
  var EVENT_CLICK = `click${EVENT_KEY$2}`;
  var EVENT_LOAD_DATA_API$1 = `load${EVENT_KEY$2}${DATA_API_KEY}`;
  var CLASS_NAME_DROPDOWN_ITEM = "dropdown-item";
  var CLASS_NAME_ACTIVE$1 = "active";
  var SELECTOR_DATA_SPY = '[data-bs-spy="scroll"]';
  var SELECTOR_TARGET_LINKS = "[href]";
  var SELECTOR_NAV_LIST_GROUP = ".nav, .list-group";
  var SELECTOR_NAV_LINKS = ".nav-link";
  var SELECTOR_NAV_ITEMS = ".nav-item";
  var SELECTOR_LIST_ITEMS = ".list-group-item";
  var SELECTOR_LINK_ITEMS = `${SELECTOR_NAV_LINKS}, ${SELECTOR_NAV_ITEMS} > ${SELECTOR_NAV_LINKS}, ${SELECTOR_LIST_ITEMS}`;
  var SELECTOR_DROPDOWN = ".dropdown";
  var SELECTOR_DROPDOWN_TOGGLE$1 = ".dropdown-toggle";
  var Default$1 = {
    offset: null,
    // TODO: v6 @deprecated, keep it for backwards compatibility reasons
    rootMargin: "0px 0px -25%",
    smoothScroll: false,
    target: null,
    threshold: [0.1, 0.5, 1]
  };
  var DefaultType$1 = {
    offset: "(number|null)",
    // TODO v6 @deprecated, keep it for backwards compatibility reasons
    rootMargin: "string",
    smoothScroll: "boolean",
    target: "element",
    threshold: "array"
  };
  var ScrollSpy = class _ScrollSpy extends BaseComponent {
    constructor(element, config) {
      super(element, config);
      this._targetLinks = /* @__PURE__ */ new Map();
      this._observableSections = /* @__PURE__ */ new Map();
      this._rootElement = getComputedStyle(this._element).overflowY === "visible" ? null : this._element;
      this._activeTarget = null;
      this._observer = null;
      this._previousScrollData = {
        visibleEntryTop: 0,
        parentScrollTop: 0
      };
      this.refresh();
    }
    // Getters
    static get Default() {
      return Default$1;
    }
    static get DefaultType() {
      return DefaultType$1;
    }
    static get NAME() {
      return NAME$2;
    }
    // Public
    refresh() {
      this._initializeTargetsAndObservables();
      this._maybeEnableSmoothScroll();
      if (this._observer) {
        this._observer.disconnect();
      } else {
        this._observer = this._getNewObserver();
      }
      for (const section of this._observableSections.values()) {
        this._observer.observe(section);
      }
    }
    dispose() {
      this._observer.disconnect();
      super.dispose();
    }
    // Private
    _configAfterMerge(config) {
      config.target = getElement(config.target) || document.body;
      config.rootMargin = config.offset ? `${config.offset}px 0px -30%` : config.rootMargin;
      if (typeof config.threshold === "string") {
        config.threshold = config.threshold.split(",").map((value) => Number.parseFloat(value));
      }
      return config;
    }
    _maybeEnableSmoothScroll() {
      if (!this._config.smoothScroll) {
        return;
      }
      EventHandler.off(this._config.target, EVENT_CLICK);
      EventHandler.on(this._config.target, EVENT_CLICK, SELECTOR_TARGET_LINKS, (event) => {
        const observableSection = this._observableSections.get(event.target.hash);
        if (observableSection) {
          event.preventDefault();
          const root = this._rootElement || window;
          const height = observableSection.offsetTop - this._element.offsetTop;
          if (root.scrollTo) {
            root.scrollTo({
              top: height,
              behavior: "smooth"
            });
            return;
          }
          root.scrollTop = height;
        }
      });
    }
    _getNewObserver() {
      const options = {
        root: this._rootElement,
        threshold: this._config.threshold,
        rootMargin: this._config.rootMargin
      };
      return new IntersectionObserver((entries) => this._observerCallback(entries), options);
    }
    // The logic of selection
    _observerCallback(entries) {
      const targetElement = (entry) => this._targetLinks.get(`#${entry.target.id}`);
      const activate = (entry) => {
        this._previousScrollData.visibleEntryTop = entry.target.offsetTop;
        this._process(targetElement(entry));
      };
      const parentScrollTop = (this._rootElement || document.documentElement).scrollTop;
      const userScrollsDown = parentScrollTop >= this._previousScrollData.parentScrollTop;
      this._previousScrollData.parentScrollTop = parentScrollTop;
      for (const entry of entries) {
        if (!entry.isIntersecting) {
          this._activeTarget = null;
          this._clearActiveClass(targetElement(entry));
          continue;
        }
        const entryIsLowerThanPrevious = entry.target.offsetTop >= this._previousScrollData.visibleEntryTop;
        if (userScrollsDown && entryIsLowerThanPrevious) {
          activate(entry);
          if (!parentScrollTop) {
            return;
          }
          continue;
        }
        if (!userScrollsDown && !entryIsLowerThanPrevious) {
          activate(entry);
        }
      }
    }
    _initializeTargetsAndObservables() {
      this._targetLinks = /* @__PURE__ */ new Map();
      this._observableSections = /* @__PURE__ */ new Map();
      const targetLinks = SelectorEngine.find(SELECTOR_TARGET_LINKS, this._config.target);
      for (const anchor of targetLinks) {
        if (!anchor.hash || isDisabled(anchor)) {
          continue;
        }
        const observableSection = SelectorEngine.findOne(decodeURI(anchor.hash), this._element);
        if (isVisible(observableSection)) {
          this._targetLinks.set(decodeURI(anchor.hash), anchor);
          this._observableSections.set(anchor.hash, observableSection);
        }
      }
    }
    _process(target) {
      if (this._activeTarget === target) {
        return;
      }
      this._clearActiveClass(this._config.target);
      this._activeTarget = target;
      target.classList.add(CLASS_NAME_ACTIVE$1);
      this._activateParents(target);
      EventHandler.trigger(this._element, EVENT_ACTIVATE, {
        relatedTarget: target
      });
    }
    _activateParents(target) {
      if (target.classList.contains(CLASS_NAME_DROPDOWN_ITEM)) {
        SelectorEngine.findOne(SELECTOR_DROPDOWN_TOGGLE$1, target.closest(SELECTOR_DROPDOWN)).classList.add(CLASS_NAME_ACTIVE$1);
        return;
      }
      for (const listGroup of SelectorEngine.parents(target, SELECTOR_NAV_LIST_GROUP)) {
        for (const item of SelectorEngine.prev(listGroup, SELECTOR_LINK_ITEMS)) {
          item.classList.add(CLASS_NAME_ACTIVE$1);
        }
      }
    }
    _clearActiveClass(parent) {
      parent.classList.remove(CLASS_NAME_ACTIVE$1);
      const activeNodes = SelectorEngine.find(`${SELECTOR_TARGET_LINKS}.${CLASS_NAME_ACTIVE$1}`, parent);
      for (const node of activeNodes) {
        node.classList.remove(CLASS_NAME_ACTIVE$1);
      }
    }
    // Static
    static jQueryInterface(config) {
      return this.each(function() {
        const data = _ScrollSpy.getOrCreateInstance(this, config);
        if (typeof config !== "string") {
          return;
        }
        if (data[config] === void 0 || config.startsWith("_") || config === "constructor") {
          throw new TypeError(`No method named "${config}"`);
        }
        data[config]();
      });
    }
  };
  EventHandler.on(window, EVENT_LOAD_DATA_API$1, () => {
    for (const spy of SelectorEngine.find(SELECTOR_DATA_SPY)) {
      ScrollSpy.getOrCreateInstance(spy);
    }
  });
  defineJQueryPlugin(ScrollSpy);
  var NAME$1 = "tab";
  var DATA_KEY$1 = "bs.tab";
  var EVENT_KEY$1 = `.${DATA_KEY$1}`;
  var EVENT_HIDE$1 = `hide${EVENT_KEY$1}`;
  var EVENT_HIDDEN$1 = `hidden${EVENT_KEY$1}`;
  var EVENT_SHOW$1 = `show${EVENT_KEY$1}`;
  var EVENT_SHOWN$1 = `shown${EVENT_KEY$1}`;
  var EVENT_CLICK_DATA_API = `click${EVENT_KEY$1}`;
  var EVENT_KEYDOWN = `keydown${EVENT_KEY$1}`;
  var EVENT_LOAD_DATA_API = `load${EVENT_KEY$1}`;
  var ARROW_LEFT_KEY = "ArrowLeft";
  var ARROW_RIGHT_KEY = "ArrowRight";
  var ARROW_UP_KEY = "ArrowUp";
  var ARROW_DOWN_KEY = "ArrowDown";
  var HOME_KEY = "Home";
  var END_KEY = "End";
  var CLASS_NAME_ACTIVE = "active";
  var CLASS_NAME_FADE$1 = "fade";
  var CLASS_NAME_SHOW$1 = "show";
  var CLASS_DROPDOWN = "dropdown";
  var SELECTOR_DROPDOWN_TOGGLE = ".dropdown-toggle";
  var SELECTOR_DROPDOWN_MENU = ".dropdown-menu";
  var NOT_SELECTOR_DROPDOWN_TOGGLE = ":not(.dropdown-toggle)";
  var SELECTOR_TAB_PANEL = '.list-group, .nav, [role="tablist"]';
  var SELECTOR_OUTER = ".nav-item, .list-group-item";
  var SELECTOR_INNER = `.nav-link${NOT_SELECTOR_DROPDOWN_TOGGLE}, .list-group-item${NOT_SELECTOR_DROPDOWN_TOGGLE}, [role="tab"]${NOT_SELECTOR_DROPDOWN_TOGGLE}`;
  var SELECTOR_DATA_TOGGLE = '[data-bs-toggle="tab"], [data-bs-toggle="pill"], [data-bs-toggle="list"]';
  var SELECTOR_INNER_ELEM = `${SELECTOR_INNER}, ${SELECTOR_DATA_TOGGLE}`;
  var SELECTOR_DATA_TOGGLE_ACTIVE = `.${CLASS_NAME_ACTIVE}[data-bs-toggle="tab"], .${CLASS_NAME_ACTIVE}[data-bs-toggle="pill"], .${CLASS_NAME_ACTIVE}[data-bs-toggle="list"]`;
  var Tab = class _Tab extends BaseComponent {
    constructor(element) {
      super(element);
      this._parent = this._element.closest(SELECTOR_TAB_PANEL);
      if (!this._parent) {
        return;
      }
      this._setInitialAttributes(this._parent, this._getChildren());
      EventHandler.on(this._element, EVENT_KEYDOWN, (event) => this._keydown(event));
    }
    // Getters
    static get NAME() {
      return NAME$1;
    }
    // Public
    show() {
      const innerElem = this._element;
      if (this._elemIsActive(innerElem)) {
        return;
      }
      const active = this._getActiveElem();
      const hideEvent = active ? EventHandler.trigger(active, EVENT_HIDE$1, {
        relatedTarget: innerElem
      }) : null;
      const showEvent = EventHandler.trigger(innerElem, EVENT_SHOW$1, {
        relatedTarget: active
      });
      if (showEvent.defaultPrevented || hideEvent && hideEvent.defaultPrevented) {
        return;
      }
      this._deactivate(active, innerElem);
      this._activate(innerElem, active);
    }
    // Private
    _activate(element, relatedElem) {
      if (!element) {
        return;
      }
      element.classList.add(CLASS_NAME_ACTIVE);
      this._activate(SelectorEngine.getElementFromSelector(element));
      const complete = () => {
        if (element.getAttribute("role") !== "tab") {
          element.classList.add(CLASS_NAME_SHOW$1);
          return;
        }
        element.removeAttribute("tabindex");
        element.setAttribute("aria-selected", true);
        this._toggleDropDown(element, true);
        EventHandler.trigger(element, EVENT_SHOWN$1, {
          relatedTarget: relatedElem
        });
      };
      this._queueCallback(complete, element, element.classList.contains(CLASS_NAME_FADE$1));
    }
    _deactivate(element, relatedElem) {
      if (!element) {
        return;
      }
      element.classList.remove(CLASS_NAME_ACTIVE);
      element.blur();
      this._deactivate(SelectorEngine.getElementFromSelector(element));
      const complete = () => {
        if (element.getAttribute("role") !== "tab") {
          element.classList.remove(CLASS_NAME_SHOW$1);
          return;
        }
        element.setAttribute("aria-selected", false);
        element.setAttribute("tabindex", "-1");
        this._toggleDropDown(element, false);
        EventHandler.trigger(element, EVENT_HIDDEN$1, {
          relatedTarget: relatedElem
        });
      };
      this._queueCallback(complete, element, element.classList.contains(CLASS_NAME_FADE$1));
    }
    _keydown(event) {
      if (![ARROW_LEFT_KEY, ARROW_RIGHT_KEY, ARROW_UP_KEY, ARROW_DOWN_KEY, HOME_KEY, END_KEY].includes(event.key)) {
        return;
      }
      event.stopPropagation();
      event.preventDefault();
      const children = this._getChildren().filter((element) => !isDisabled(element));
      let nextActiveElement;
      if ([HOME_KEY, END_KEY].includes(event.key)) {
        nextActiveElement = children[event.key === HOME_KEY ? 0 : children.length - 1];
      } else {
        const isNext = [ARROW_RIGHT_KEY, ARROW_DOWN_KEY].includes(event.key);
        nextActiveElement = getNextActiveElement(children, event.target, isNext, true);
      }
      if (nextActiveElement) {
        nextActiveElement.focus({
          preventScroll: true
        });
        _Tab.getOrCreateInstance(nextActiveElement).show();
      }
    }
    _getChildren() {
      return SelectorEngine.find(SELECTOR_INNER_ELEM, this._parent);
    }
    _getActiveElem() {
      return this._getChildren().find((child) => this._elemIsActive(child)) || null;
    }
    _setInitialAttributes(parent, children) {
      this._setAttributeIfNotExists(parent, "role", "tablist");
      for (const child of children) {
        this._setInitialAttributesOnChild(child);
      }
    }
    _setInitialAttributesOnChild(child) {
      child = this._getInnerElement(child);
      const isActive = this._elemIsActive(child);
      const outerElem = this._getOuterElement(child);
      child.setAttribute("aria-selected", isActive);
      if (outerElem !== child) {
        this._setAttributeIfNotExists(outerElem, "role", "presentation");
      }
      if (!isActive) {
        child.setAttribute("tabindex", "-1");
      }
      this._setAttributeIfNotExists(child, "role", "tab");
      this._setInitialAttributesOnTargetPanel(child);
    }
    _setInitialAttributesOnTargetPanel(child) {
      const target = SelectorEngine.getElementFromSelector(child);
      if (!target) {
        return;
      }
      this._setAttributeIfNotExists(target, "role", "tabpanel");
      if (child.id) {
        this._setAttributeIfNotExists(target, "aria-labelledby", `${child.id}`);
      }
    }
    _toggleDropDown(element, open) {
      const outerElem = this._getOuterElement(element);
      if (!outerElem.classList.contains(CLASS_DROPDOWN)) {
        return;
      }
      const toggle = (selector, className) => {
        const element2 = SelectorEngine.findOne(selector, outerElem);
        if (element2) {
          element2.classList.toggle(className, open);
        }
      };
      toggle(SELECTOR_DROPDOWN_TOGGLE, CLASS_NAME_ACTIVE);
      toggle(SELECTOR_DROPDOWN_MENU, CLASS_NAME_SHOW$1);
      outerElem.setAttribute("aria-expanded", open);
    }
    _setAttributeIfNotExists(element, attribute, value) {
      if (!element.hasAttribute(attribute)) {
        element.setAttribute(attribute, value);
      }
    }
    _elemIsActive(elem) {
      return elem.classList.contains(CLASS_NAME_ACTIVE);
    }
    // Try to get the inner element (usually the .nav-link)
    _getInnerElement(elem) {
      return elem.matches(SELECTOR_INNER_ELEM) ? elem : SelectorEngine.findOne(SELECTOR_INNER_ELEM, elem);
    }
    // Try to get the outer element (usually the .nav-item)
    _getOuterElement(elem) {
      return elem.closest(SELECTOR_OUTER) || elem;
    }
    // Static
    static jQueryInterface(config) {
      return this.each(function() {
        const data = _Tab.getOrCreateInstance(this);
        if (typeof config !== "string") {
          return;
        }
        if (data[config] === void 0 || config.startsWith("_") || config === "constructor") {
          throw new TypeError(`No method named "${config}"`);
        }
        data[config]();
      });
    }
  };
  EventHandler.on(document, EVENT_CLICK_DATA_API, SELECTOR_DATA_TOGGLE, function(event) {
    if (["A", "AREA"].includes(this.tagName)) {
      event.preventDefault();
    }
    if (isDisabled(this)) {
      return;
    }
    Tab.getOrCreateInstance(this).show();
  });
  EventHandler.on(window, EVENT_LOAD_DATA_API, () => {
    for (const element of SelectorEngine.find(SELECTOR_DATA_TOGGLE_ACTIVE)) {
      Tab.getOrCreateInstance(element);
    }
  });
  defineJQueryPlugin(Tab);
  var NAME = "toast";
  var DATA_KEY = "bs.toast";
  var EVENT_KEY = `.${DATA_KEY}`;
  var EVENT_MOUSEOVER = `mouseover${EVENT_KEY}`;
  var EVENT_MOUSEOUT = `mouseout${EVENT_KEY}`;
  var EVENT_FOCUSIN = `focusin${EVENT_KEY}`;
  var EVENT_FOCUSOUT = `focusout${EVENT_KEY}`;
  var EVENT_HIDE = `hide${EVENT_KEY}`;
  var EVENT_HIDDEN = `hidden${EVENT_KEY}`;
  var EVENT_SHOW = `show${EVENT_KEY}`;
  var EVENT_SHOWN = `shown${EVENT_KEY}`;
  var CLASS_NAME_FADE = "fade";
  var CLASS_NAME_HIDE = "hide";
  var CLASS_NAME_SHOW = "show";
  var CLASS_NAME_SHOWING = "showing";
  var DefaultType = {
    animation: "boolean",
    autohide: "boolean",
    delay: "number"
  };
  var Default = {
    animation: true,
    autohide: true,
    delay: 5e3
  };
  var Toast = class _Toast extends BaseComponent {
    constructor(element, config) {
      super(element, config);
      this._timeout = null;
      this._hasMouseInteraction = false;
      this._hasKeyboardInteraction = false;
      this._setListeners();
    }
    // Getters
    static get Default() {
      return Default;
    }
    static get DefaultType() {
      return DefaultType;
    }
    static get NAME() {
      return NAME;
    }
    // Public
    show() {
      const showEvent = EventHandler.trigger(this._element, EVENT_SHOW);
      if (showEvent.defaultPrevented) {
        return;
      }
      this._clearTimeout();
      if (this._config.animation) {
        this._element.classList.add(CLASS_NAME_FADE);
      }
      const complete = () => {
        this._element.classList.remove(CLASS_NAME_SHOWING);
        EventHandler.trigger(this._element, EVENT_SHOWN);
        this._maybeScheduleHide();
      };
      this._element.classList.remove(CLASS_NAME_HIDE);
      reflow(this._element);
      this._element.classList.add(CLASS_NAME_SHOW, CLASS_NAME_SHOWING);
      this._queueCallback(complete, this._element, this._config.animation);
    }
    hide() {
      if (!this.isShown()) {
        return;
      }
      const hideEvent = EventHandler.trigger(this._element, EVENT_HIDE);
      if (hideEvent.defaultPrevented) {
        return;
      }
      const complete = () => {
        this._element.classList.add(CLASS_NAME_HIDE);
        this._element.classList.remove(CLASS_NAME_SHOWING, CLASS_NAME_SHOW);
        EventHandler.trigger(this._element, EVENT_HIDDEN);
      };
      this._element.classList.add(CLASS_NAME_SHOWING);
      this._queueCallback(complete, this._element, this._config.animation);
    }
    dispose() {
      this._clearTimeout();
      if (this.isShown()) {
        this._element.classList.remove(CLASS_NAME_SHOW);
      }
      super.dispose();
    }
    isShown() {
      return this._element.classList.contains(CLASS_NAME_SHOW);
    }
    // Private
    _maybeScheduleHide() {
      if (!this._config.autohide) {
        return;
      }
      if (this._hasMouseInteraction || this._hasKeyboardInteraction) {
        return;
      }
      this._timeout = setTimeout(() => {
        this.hide();
      }, this._config.delay);
    }
    _onInteraction(event, isInteracting) {
      switch (event.type) {
        case "mouseover":
        case "mouseout": {
          this._hasMouseInteraction = isInteracting;
          break;
        }
        case "focusin":
        case "focusout": {
          this._hasKeyboardInteraction = isInteracting;
          break;
        }
      }
      if (isInteracting) {
        this._clearTimeout();
        return;
      }
      const nextElement = event.relatedTarget;
      if (this._element === nextElement || this._element.contains(nextElement)) {
        return;
      }
      this._maybeScheduleHide();
    }
    _setListeners() {
      EventHandler.on(this._element, EVENT_MOUSEOVER, (event) => this._onInteraction(event, true));
      EventHandler.on(this._element, EVENT_MOUSEOUT, (event) => this._onInteraction(event, false));
      EventHandler.on(this._element, EVENT_FOCUSIN, (event) => this._onInteraction(event, true));
      EventHandler.on(this._element, EVENT_FOCUSOUT, (event) => this._onInteraction(event, false));
    }
    _clearTimeout() {
      clearTimeout(this._timeout);
      this._timeout = null;
    }
    // Static
    static jQueryInterface(config) {
      return this.each(function() {
        const data = _Toast.getOrCreateInstance(this, config);
        if (typeof config === "string") {
          if (typeof data[config] === "undefined") {
            throw new TypeError(`No method named "${config}"`);
          }
          data[config](this);
        }
      });
    }
  };
  enableDismissTrigger(Toast);
  defineJQueryPlugin(Toast);

  // node_modules/jquery-ui/ui/version.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define(["jquery"], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    $.ui = $.ui || {};
    return $.ui.version = "1.13.3";
  });

  // node_modules/jquery-ui/ui/keycode.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define(["jquery", "./version"], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    return $.ui.keyCode = {
      BACKSPACE: 8,
      COMMA: 188,
      DELETE: 46,
      DOWN: 40,
      END: 35,
      ENTER: 13,
      ESCAPE: 27,
      HOME: 36,
      LEFT: 37,
      PAGE_DOWN: 34,
      PAGE_UP: 33,
      PERIOD: 190,
      RIGHT: 39,
      SPACE: 32,
      TAB: 9,
      UP: 38
    };
  });

  // node_modules/jquery-ui/ui/position.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define(["jquery", "./version"], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    (function() {
      var cachedScrollbarWidth, max2 = Math.max, abs = Math.abs, rhorizontal = /left|center|right/, rvertical = /top|center|bottom/, roffset = /[\+\-]\d+(\.[\d]+)?%?/, rposition = /^\w+/, rpercent = /%$/, _position = $.fn.position;
      function getOffsets(offsets, width, height) {
        return [
          parseFloat(offsets[0]) * (rpercent.test(offsets[0]) ? width / 100 : 1),
          parseFloat(offsets[1]) * (rpercent.test(offsets[1]) ? height / 100 : 1)
        ];
      }
      function parseCss(element, property) {
        return parseInt($.css(element, property), 10) || 0;
      }
      function isWindow(obj) {
        return obj != null && obj === obj.window;
      }
      function getDimensions(elem) {
        var raw = elem[0];
        if (raw.nodeType === 9) {
          return {
            width: elem.width(),
            height: elem.height(),
            offset: { top: 0, left: 0 }
          };
        }
        if (isWindow(raw)) {
          return {
            width: elem.width(),
            height: elem.height(),
            offset: { top: elem.scrollTop(), left: elem.scrollLeft() }
          };
        }
        if (raw.preventDefault) {
          return {
            width: 0,
            height: 0,
            offset: { top: raw.pageY, left: raw.pageX }
          };
        }
        return {
          width: elem.outerWidth(),
          height: elem.outerHeight(),
          offset: elem.offset()
        };
      }
      $.position = {
        scrollbarWidth: function() {
          if (cachedScrollbarWidth !== void 0) {
            return cachedScrollbarWidth;
          }
          var w1, w2, div = $("<div style='display:block;position:absolute;width:200px;height:200px;overflow:hidden;'><div style='height:300px;width:auto;'></div></div>"), innerDiv = div.children()[0];
          $("body").append(div);
          w1 = innerDiv.offsetWidth;
          div.css("overflow", "scroll");
          w2 = innerDiv.offsetWidth;
          if (w1 === w2) {
            w2 = div[0].clientWidth;
          }
          div.remove();
          return cachedScrollbarWidth = w1 - w2;
        },
        getScrollInfo: function(within2) {
          var overflowX = within2.isWindow || within2.isDocument ? "" : within2.element.css("overflow-x"), overflowY = within2.isWindow || within2.isDocument ? "" : within2.element.css("overflow-y"), hasOverflowX = overflowX === "scroll" || overflowX === "auto" && within2.width < within2.element[0].scrollWidth, hasOverflowY = overflowY === "scroll" || overflowY === "auto" && within2.height < within2.element[0].scrollHeight;
          return {
            width: hasOverflowY ? $.position.scrollbarWidth() : 0,
            height: hasOverflowX ? $.position.scrollbarWidth() : 0
          };
        },
        getWithinInfo: function(element) {
          var withinElement = $(element || window), isElemWindow = isWindow(withinElement[0]), isDocument = !!withinElement[0] && withinElement[0].nodeType === 9, hasOffset = !isElemWindow && !isDocument;
          return {
            element: withinElement,
            isWindow: isElemWindow,
            isDocument,
            offset: hasOffset ? $(element).offset() : { left: 0, top: 0 },
            scrollLeft: withinElement.scrollLeft(),
            scrollTop: withinElement.scrollTop(),
            width: withinElement.outerWidth(),
            height: withinElement.outerHeight()
          };
        }
      };
      $.fn.position = function(options) {
        if (!options || !options.of) {
          return _position.apply(this, arguments);
        }
        options = $.extend({}, options);
        var atOffset, targetWidth, targetHeight, targetOffset, basePosition, dimensions, target = typeof options.of === "string" ? $(document).find(options.of) : $(options.of), within2 = $.position.getWithinInfo(options.within), scrollInfo = $.position.getScrollInfo(within2), collision = (options.collision || "flip").split(" "), offsets = {};
        dimensions = getDimensions(target);
        if (target[0].preventDefault) {
          options.at = "left top";
        }
        targetWidth = dimensions.width;
        targetHeight = dimensions.height;
        targetOffset = dimensions.offset;
        basePosition = $.extend({}, targetOffset);
        $.each(["my", "at"], function() {
          var pos = (options[this] || "").split(" "), horizontalOffset, verticalOffset;
          if (pos.length === 1) {
            pos = rhorizontal.test(pos[0]) ? pos.concat(["center"]) : rvertical.test(pos[0]) ? ["center"].concat(pos) : ["center", "center"];
          }
          pos[0] = rhorizontal.test(pos[0]) ? pos[0] : "center";
          pos[1] = rvertical.test(pos[1]) ? pos[1] : "center";
          horizontalOffset = roffset.exec(pos[0]);
          verticalOffset = roffset.exec(pos[1]);
          offsets[this] = [
            horizontalOffset ? horizontalOffset[0] : 0,
            verticalOffset ? verticalOffset[0] : 0
          ];
          options[this] = [
            rposition.exec(pos[0])[0],
            rposition.exec(pos[1])[0]
          ];
        });
        if (collision.length === 1) {
          collision[1] = collision[0];
        }
        if (options.at[0] === "right") {
          basePosition.left += targetWidth;
        } else if (options.at[0] === "center") {
          basePosition.left += targetWidth / 2;
        }
        if (options.at[1] === "bottom") {
          basePosition.top += targetHeight;
        } else if (options.at[1] === "center") {
          basePosition.top += targetHeight / 2;
        }
        atOffset = getOffsets(offsets.at, targetWidth, targetHeight);
        basePosition.left += atOffset[0];
        basePosition.top += atOffset[1];
        return this.each(function() {
          var collisionPosition, using, elem = $(this), elemWidth = elem.outerWidth(), elemHeight = elem.outerHeight(), marginLeft = parseCss(this, "marginLeft"), marginTop = parseCss(this, "marginTop"), collisionWidth = elemWidth + marginLeft + parseCss(this, "marginRight") + scrollInfo.width, collisionHeight = elemHeight + marginTop + parseCss(this, "marginBottom") + scrollInfo.height, position = $.extend({}, basePosition), myOffset = getOffsets(offsets.my, elem.outerWidth(), elem.outerHeight());
          if (options.my[0] === "right") {
            position.left -= elemWidth;
          } else if (options.my[0] === "center") {
            position.left -= elemWidth / 2;
          }
          if (options.my[1] === "bottom") {
            position.top -= elemHeight;
          } else if (options.my[1] === "center") {
            position.top -= elemHeight / 2;
          }
          position.left += myOffset[0];
          position.top += myOffset[1];
          collisionPosition = {
            marginLeft,
            marginTop
          };
          $.each(["left", "top"], function(i, dir) {
            if ($.ui.position[collision[i]]) {
              $.ui.position[collision[i]][dir](position, {
                targetWidth,
                targetHeight,
                elemWidth,
                elemHeight,
                collisionPosition,
                collisionWidth,
                collisionHeight,
                offset: [atOffset[0] + myOffset[0], atOffset[1] + myOffset[1]],
                my: options.my,
                at: options.at,
                within: within2,
                elem
              });
            }
          });
          if (options.using) {
            using = function(props) {
              var left2 = targetOffset.left - position.left, right2 = left2 + targetWidth - elemWidth, top2 = targetOffset.top - position.top, bottom2 = top2 + targetHeight - elemHeight, feedback = {
                target: {
                  element: target,
                  left: targetOffset.left,
                  top: targetOffset.top,
                  width: targetWidth,
                  height: targetHeight
                },
                element: {
                  element: elem,
                  left: position.left,
                  top: position.top,
                  width: elemWidth,
                  height: elemHeight
                },
                horizontal: right2 < 0 ? "left" : left2 > 0 ? "right" : "center",
                vertical: bottom2 < 0 ? "top" : top2 > 0 ? "bottom" : "middle"
              };
              if (targetWidth < elemWidth && abs(left2 + right2) < targetWidth) {
                feedback.horizontal = "center";
              }
              if (targetHeight < elemHeight && abs(top2 + bottom2) < targetHeight) {
                feedback.vertical = "middle";
              }
              if (max2(abs(left2), abs(right2)) > max2(abs(top2), abs(bottom2))) {
                feedback.important = "horizontal";
              } else {
                feedback.important = "vertical";
              }
              options.using.call(this, props, feedback);
            };
          }
          elem.offset($.extend(position, { using }));
        });
      };
      $.ui.position = {
        fit: {
          left: function(position, data) {
            var within2 = data.within, withinOffset = within2.isWindow ? within2.scrollLeft : within2.offset.left, outerWidth = within2.width, collisionPosLeft = position.left - data.collisionPosition.marginLeft, overLeft = withinOffset - collisionPosLeft, overRight = collisionPosLeft + data.collisionWidth - outerWidth - withinOffset, newOverRight;
            if (data.collisionWidth > outerWidth) {
              if (overLeft > 0 && overRight <= 0) {
                newOverRight = position.left + overLeft + data.collisionWidth - outerWidth - withinOffset;
                position.left += overLeft - newOverRight;
              } else if (overRight > 0 && overLeft <= 0) {
                position.left = withinOffset;
              } else {
                if (overLeft > overRight) {
                  position.left = withinOffset + outerWidth - data.collisionWidth;
                } else {
                  position.left = withinOffset;
                }
              }
            } else if (overLeft > 0) {
              position.left += overLeft;
            } else if (overRight > 0) {
              position.left -= overRight;
            } else {
              position.left = max2(position.left - collisionPosLeft, position.left);
            }
          },
          top: function(position, data) {
            var within2 = data.within, withinOffset = within2.isWindow ? within2.scrollTop : within2.offset.top, outerHeight = data.within.height, collisionPosTop = position.top - data.collisionPosition.marginTop, overTop = withinOffset - collisionPosTop, overBottom = collisionPosTop + data.collisionHeight - outerHeight - withinOffset, newOverBottom;
            if (data.collisionHeight > outerHeight) {
              if (overTop > 0 && overBottom <= 0) {
                newOverBottom = position.top + overTop + data.collisionHeight - outerHeight - withinOffset;
                position.top += overTop - newOverBottom;
              } else if (overBottom > 0 && overTop <= 0) {
                position.top = withinOffset;
              } else {
                if (overTop > overBottom) {
                  position.top = withinOffset + outerHeight - data.collisionHeight;
                } else {
                  position.top = withinOffset;
                }
              }
            } else if (overTop > 0) {
              position.top += overTop;
            } else if (overBottom > 0) {
              position.top -= overBottom;
            } else {
              position.top = max2(position.top - collisionPosTop, position.top);
            }
          }
        },
        flip: {
          left: function(position, data) {
            var within2 = data.within, withinOffset = within2.offset.left + within2.scrollLeft, outerWidth = within2.width, offsetLeft = within2.isWindow ? within2.scrollLeft : within2.offset.left, collisionPosLeft = position.left - data.collisionPosition.marginLeft, overLeft = collisionPosLeft - offsetLeft, overRight = collisionPosLeft + data.collisionWidth - outerWidth - offsetLeft, myOffset = data.my[0] === "left" ? -data.elemWidth : data.my[0] === "right" ? data.elemWidth : 0, atOffset = data.at[0] === "left" ? data.targetWidth : data.at[0] === "right" ? -data.targetWidth : 0, offset2 = -2 * data.offset[0], newOverRight, newOverLeft;
            if (overLeft < 0) {
              newOverRight = position.left + myOffset + atOffset + offset2 + data.collisionWidth - outerWidth - withinOffset;
              if (newOverRight < 0 || newOverRight < abs(overLeft)) {
                position.left += myOffset + atOffset + offset2;
              }
            } else if (overRight > 0) {
              newOverLeft = position.left - data.collisionPosition.marginLeft + myOffset + atOffset + offset2 - offsetLeft;
              if (newOverLeft > 0 || abs(newOverLeft) < overRight) {
                position.left += myOffset + atOffset + offset2;
              }
            }
          },
          top: function(position, data) {
            var within2 = data.within, withinOffset = within2.offset.top + within2.scrollTop, outerHeight = within2.height, offsetTop = within2.isWindow ? within2.scrollTop : within2.offset.top, collisionPosTop = position.top - data.collisionPosition.marginTop, overTop = collisionPosTop - offsetTop, overBottom = collisionPosTop + data.collisionHeight - outerHeight - offsetTop, top2 = data.my[1] === "top", myOffset = top2 ? -data.elemHeight : data.my[1] === "bottom" ? data.elemHeight : 0, atOffset = data.at[1] === "top" ? data.targetHeight : data.at[1] === "bottom" ? -data.targetHeight : 0, offset2 = -2 * data.offset[1], newOverTop, newOverBottom;
            if (overTop < 0) {
              newOverBottom = position.top + myOffset + atOffset + offset2 + data.collisionHeight - outerHeight - withinOffset;
              if (newOverBottom < 0 || newOverBottom < abs(overTop)) {
                position.top += myOffset + atOffset + offset2;
              }
            } else if (overBottom > 0) {
              newOverTop = position.top - data.collisionPosition.marginTop + myOffset + atOffset + offset2 - offsetTop;
              if (newOverTop > 0 || abs(newOverTop) < overBottom) {
                position.top += myOffset + atOffset + offset2;
              }
            }
          }
        },
        flipfit: {
          left: function() {
            $.ui.position.flip.left.apply(this, arguments);
            $.ui.position.fit.left.apply(this, arguments);
          },
          top: function() {
            $.ui.position.flip.top.apply(this, arguments);
            $.ui.position.fit.top.apply(this, arguments);
          }
        }
      };
    })();
    return $.ui.position;
  });

  // node_modules/jquery-ui/ui/safe-active-element.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define(["jquery", "./version"], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    return $.ui.safeActiveElement = function(document2) {
      var activeElement;
      try {
        activeElement = document2.activeElement;
      } catch (error) {
        activeElement = document2.body;
      }
      if (!activeElement) {
        activeElement = document2.body;
      }
      if (!activeElement.nodeName) {
        activeElement = document2.body;
      }
      return activeElement;
    };
  });

  // node_modules/jquery-ui/ui/data.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define(["jquery", "./version"], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    return $.extend($.expr.pseudos, {
      data: $.expr.createPseudo ? $.expr.createPseudo(function(dataName) {
        return function(elem) {
          return !!$.data(elem, dataName);
        };
      }) : (
        // Support: jQuery <1.8
        function(elem, i, match) {
          return !!$.data(elem, match[3]);
        }
      )
    });
  });

  // node_modules/jquery-ui/ui/ie.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define(["jquery", "./version"], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    return $.ui.ie = !!/msie [\w.]+/.exec(navigator.userAgent.toLowerCase());
  });

  // node_modules/jquery-ui/ui/scroll-parent.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define(["jquery", "./version"], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    return $.fn.scrollParent = function(includeHidden) {
      var position = this.css("position"), excludeStaticParent = position === "absolute", overflowRegex = includeHidden ? /(auto|scroll|hidden)/ : /(auto|scroll)/, scrollParent = this.parents().filter(function() {
        var parent = $(this);
        if (excludeStaticParent && parent.css("position") === "static") {
          return false;
        }
        return overflowRegex.test(parent.css("overflow") + parent.css("overflow-y") + parent.css("overflow-x"));
      }).eq(0);
      return position === "fixed" || !scrollParent.length ? $(this[0].ownerDocument || document) : scrollParent;
    };
  });

  // node_modules/jquery-ui/ui/unique-id.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define(["jquery", "./version"], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    return $.fn.extend({
      uniqueId: /* @__PURE__ */ function() {
        var uuid2 = 0;
        return function() {
          return this.each(function() {
            if (!this.id) {
              this.id = "ui-id-" + ++uuid2;
            }
          });
        };
      }(),
      removeUniqueId: function() {
        return this.each(function() {
          if (/^ui-id-\d+$/.test(this.id)) {
            $(this).removeAttr("id");
          }
        });
      }
    });
  });

  // node_modules/jquery-ui/ui/widget.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define(["jquery", "./version"], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    var widgetUuid = 0;
    var widgetHasOwnProperty = Array.prototype.hasOwnProperty;
    var widgetSlice = Array.prototype.slice;
    $.cleanData = /* @__PURE__ */ function(orig) {
      return function(elems) {
        var events, elem, i;
        for (i = 0; (elem = elems[i]) != null; i++) {
          events = $._data(elem, "events");
          if (events && events.remove) {
            $(elem).triggerHandler("remove");
          }
        }
        orig(elems);
      };
    }($.cleanData);
    $.widget = function(name, base, prototype) {
      var existingConstructor, constructor, basePrototype;
      var proxiedPrototype = {};
      var namespace = name.split(".")[0];
      name = name.split(".")[1];
      var fullName = namespace + "-" + name;
      if (!prototype) {
        prototype = base;
        base = $.Widget;
      }
      if (Array.isArray(prototype)) {
        prototype = $.extend.apply(null, [{}].concat(prototype));
      }
      $.expr.pseudos[fullName.toLowerCase()] = function(elem) {
        return !!$.data(elem, fullName);
      };
      $[namespace] = $[namespace] || {};
      existingConstructor = $[namespace][name];
      constructor = $[namespace][name] = function(options, element) {
        if (!this || !this._createWidget) {
          return new constructor(options, element);
        }
        if (arguments.length) {
          this._createWidget(options, element);
        }
      };
      $.extend(constructor, existingConstructor, {
        version: prototype.version,
        // Copy the object used to create the prototype in case we need to
        // redefine the widget later
        _proto: $.extend({}, prototype),
        // Track widgets that inherit from this widget in case this widget is
        // redefined after a widget inherits from it
        _childConstructors: []
      });
      basePrototype = new base();
      basePrototype.options = $.widget.extend({}, basePrototype.options);
      $.each(prototype, function(prop, value) {
        if (typeof value !== "function") {
          proxiedPrototype[prop] = value;
          return;
        }
        proxiedPrototype[prop] = /* @__PURE__ */ function() {
          function _super() {
            return base.prototype[prop].apply(this, arguments);
          }
          function _superApply(args) {
            return base.prototype[prop].apply(this, args);
          }
          return function() {
            var __super = this._super;
            var __superApply = this._superApply;
            var returnValue;
            this._super = _super;
            this._superApply = _superApply;
            returnValue = value.apply(this, arguments);
            this._super = __super;
            this._superApply = __superApply;
            return returnValue;
          };
        }();
      });
      constructor.prototype = $.widget.extend(basePrototype, {
        // TODO: remove support for widgetEventPrefix
        // always use the name + a colon as the prefix, e.g., draggable:start
        // don't prefix for widgets that aren't DOM-based
        widgetEventPrefix: existingConstructor ? basePrototype.widgetEventPrefix || name : name
      }, proxiedPrototype, {
        constructor,
        namespace,
        widgetName: name,
        widgetFullName: fullName
      });
      if (existingConstructor) {
        $.each(existingConstructor._childConstructors, function(i, child) {
          var childPrototype = child.prototype;
          $.widget(
            childPrototype.namespace + "." + childPrototype.widgetName,
            constructor,
            child._proto
          );
        });
        delete existingConstructor._childConstructors;
      } else {
        base._childConstructors.push(constructor);
      }
      $.widget.bridge(name, constructor);
      return constructor;
    };
    $.widget.extend = function(target) {
      var input = widgetSlice.call(arguments, 1);
      var inputIndex = 0;
      var inputLength = input.length;
      var key;
      var value;
      for (; inputIndex < inputLength; inputIndex++) {
        for (key in input[inputIndex]) {
          value = input[inputIndex][key];
          if (widgetHasOwnProperty.call(input[inputIndex], key) && value !== void 0) {
            if ($.isPlainObject(value)) {
              target[key] = $.isPlainObject(target[key]) ? $.widget.extend({}, target[key], value) : (
                // Don't extend strings, arrays, etc. with objects
                $.widget.extend({}, value)
              );
            } else {
              target[key] = value;
            }
          }
        }
      }
      return target;
    };
    $.widget.bridge = function(name, object) {
      var fullName = object.prototype.widgetFullName || name;
      $.fn[name] = function(options) {
        var isMethodCall = typeof options === "string";
        var args = widgetSlice.call(arguments, 1);
        var returnValue = this;
        if (isMethodCall) {
          if (!this.length && options === "instance") {
            returnValue = void 0;
          } else {
            this.each(function() {
              var methodValue;
              var instance = $.data(this, fullName);
              if (options === "instance") {
                returnValue = instance;
                return false;
              }
              if (!instance) {
                return $.error("cannot call methods on " + name + " prior to initialization; attempted to call method '" + options + "'");
              }
              if (typeof instance[options] !== "function" || options.charAt(0) === "_") {
                return $.error("no such method '" + options + "' for " + name + " widget instance");
              }
              methodValue = instance[options].apply(instance, args);
              if (methodValue !== instance && methodValue !== void 0) {
                returnValue = methodValue && methodValue.jquery ? returnValue.pushStack(methodValue.get()) : methodValue;
                return false;
              }
            });
          }
        } else {
          if (args.length) {
            options = $.widget.extend.apply(null, [options].concat(args));
          }
          this.each(function() {
            var instance = $.data(this, fullName);
            if (instance) {
              instance.option(options || {});
              if (instance._init) {
                instance._init();
              }
            } else {
              $.data(this, fullName, new object(options, this));
            }
          });
        }
        return returnValue;
      };
    };
    $.Widget = function() {
    };
    $.Widget._childConstructors = [];
    $.Widget.prototype = {
      widgetName: "widget",
      widgetEventPrefix: "",
      defaultElement: "<div>",
      options: {
        classes: {},
        disabled: false,
        // Callbacks
        create: null
      },
      _createWidget: function(options, element) {
        element = $(element || this.defaultElement || this)[0];
        this.element = $(element);
        this.uuid = widgetUuid++;
        this.eventNamespace = "." + this.widgetName + this.uuid;
        this.bindings = $();
        this.hoverable = $();
        this.focusable = $();
        this.classesElementLookup = {};
        if (element !== this) {
          $.data(element, this.widgetFullName, this);
          this._on(true, this.element, {
            remove: function(event) {
              if (event.target === element) {
                this.destroy();
              }
            }
          });
          this.document = $(element.style ? (
            // Element within the document
            element.ownerDocument
          ) : (
            // Element is window or document
            element.document || element
          ));
          this.window = $(this.document[0].defaultView || this.document[0].parentWindow);
        }
        this.options = $.widget.extend(
          {},
          this.options,
          this._getCreateOptions(),
          options
        );
        this._create();
        if (this.options.disabled) {
          this._setOptionDisabled(this.options.disabled);
        }
        this._trigger("create", null, this._getCreateEventData());
        this._init();
      },
      _getCreateOptions: function() {
        return {};
      },
      _getCreateEventData: $.noop,
      _create: $.noop,
      _init: $.noop,
      destroy: function() {
        var that = this;
        this._destroy();
        $.each(this.classesElementLookup, function(key, value) {
          that._removeClass(value, key);
        });
        this.element.off(this.eventNamespace).removeData(this.widgetFullName);
        this.widget().off(this.eventNamespace).removeAttr("aria-disabled");
        this.bindings.off(this.eventNamespace);
      },
      _destroy: $.noop,
      widget: function() {
        return this.element;
      },
      option: function(key, value) {
        var options = key;
        var parts;
        var curOption;
        var i;
        if (arguments.length === 0) {
          return $.widget.extend({}, this.options);
        }
        if (typeof key === "string") {
          options = {};
          parts = key.split(".");
          key = parts.shift();
          if (parts.length) {
            curOption = options[key] = $.widget.extend({}, this.options[key]);
            for (i = 0; i < parts.length - 1; i++) {
              curOption[parts[i]] = curOption[parts[i]] || {};
              curOption = curOption[parts[i]];
            }
            key = parts.pop();
            if (arguments.length === 1) {
              return curOption[key] === void 0 ? null : curOption[key];
            }
            curOption[key] = value;
          } else {
            if (arguments.length === 1) {
              return this.options[key] === void 0 ? null : this.options[key];
            }
            options[key] = value;
          }
        }
        this._setOptions(options);
        return this;
      },
      _setOptions: function(options) {
        var key;
        for (key in options) {
          this._setOption(key, options[key]);
        }
        return this;
      },
      _setOption: function(key, value) {
        if (key === "classes") {
          this._setOptionClasses(value);
        }
        this.options[key] = value;
        if (key === "disabled") {
          this._setOptionDisabled(value);
        }
        return this;
      },
      _setOptionClasses: function(value) {
        var classKey, elements, currentElements;
        for (classKey in value) {
          currentElements = this.classesElementLookup[classKey];
          if (value[classKey] === this.options.classes[classKey] || !currentElements || !currentElements.length) {
            continue;
          }
          elements = $(currentElements.get());
          this._removeClass(currentElements, classKey);
          elements.addClass(this._classes({
            element: elements,
            keys: classKey,
            classes: value,
            add: true
          }));
        }
      },
      _setOptionDisabled: function(value) {
        this._toggleClass(this.widget(), this.widgetFullName + "-disabled", null, !!value);
        if (value) {
          this._removeClass(this.hoverable, null, "ui-state-hover");
          this._removeClass(this.focusable, null, "ui-state-focus");
        }
      },
      enable: function() {
        return this._setOptions({ disabled: false });
      },
      disable: function() {
        return this._setOptions({ disabled: true });
      },
      _classes: function(options) {
        var full = [];
        var that = this;
        options = $.extend({
          element: this.element,
          classes: this.options.classes || {}
        }, options);
        function bindRemoveEvent() {
          var nodesToBind = [];
          options.element.each(function(_, element) {
            var isTracked = $.map(that.classesElementLookup, function(elements) {
              return elements;
            }).some(function(elements) {
              return elements.is(element);
            });
            if (!isTracked) {
              nodesToBind.push(element);
            }
          });
          that._on($(nodesToBind), {
            remove: "_untrackClassesElement"
          });
        }
        function processClassString(classes, checkOption) {
          var current, i;
          for (i = 0; i < classes.length; i++) {
            current = that.classesElementLookup[classes[i]] || $();
            if (options.add) {
              bindRemoveEvent();
              current = $($.uniqueSort(current.get().concat(options.element.get())));
            } else {
              current = $(current.not(options.element).get());
            }
            that.classesElementLookup[classes[i]] = current;
            full.push(classes[i]);
            if (checkOption && options.classes[classes[i]]) {
              full.push(options.classes[classes[i]]);
            }
          }
        }
        if (options.keys) {
          processClassString(options.keys.match(/\S+/g) || [], true);
        }
        if (options.extra) {
          processClassString(options.extra.match(/\S+/g) || []);
        }
        return full.join(" ");
      },
      _untrackClassesElement: function(event) {
        var that = this;
        $.each(that.classesElementLookup, function(key, value) {
          if ($.inArray(event.target, value) !== -1) {
            that.classesElementLookup[key] = $(value.not(event.target).get());
          }
        });
        this._off($(event.target));
      },
      _removeClass: function(element, keys, extra) {
        return this._toggleClass(element, keys, extra, false);
      },
      _addClass: function(element, keys, extra) {
        return this._toggleClass(element, keys, extra, true);
      },
      _toggleClass: function(element, keys, extra, add) {
        add = typeof add === "boolean" ? add : extra;
        var shift = typeof element === "string" || element === null, options = {
          extra: shift ? keys : extra,
          keys: shift ? element : keys,
          element: shift ? this.element : element,
          add
        };
        options.element.toggleClass(this._classes(options), add);
        return this;
      },
      _on: function(suppressDisabledCheck, element, handlers) {
        var delegateElement;
        var instance = this;
        if (typeof suppressDisabledCheck !== "boolean") {
          handlers = element;
          element = suppressDisabledCheck;
          suppressDisabledCheck = false;
        }
        if (!handlers) {
          handlers = element;
          element = this.element;
          delegateElement = this.widget();
        } else {
          element = delegateElement = $(element);
          this.bindings = this.bindings.add(element);
        }
        $.each(handlers, function(event, handler) {
          function handlerProxy() {
            if (!suppressDisabledCheck && (instance.options.disabled === true || $(this).hasClass("ui-state-disabled"))) {
              return;
            }
            return (typeof handler === "string" ? instance[handler] : handler).apply(instance, arguments);
          }
          if (typeof handler !== "string") {
            handlerProxy.guid = handler.guid = handler.guid || handlerProxy.guid || $.guid++;
          }
          var match = event.match(/^([\w:-]*)\s*(.*)$/);
          var eventName = match[1] + instance.eventNamespace;
          var selector = match[2];
          if (selector) {
            delegateElement.on(eventName, selector, handlerProxy);
          } else {
            element.on(eventName, handlerProxy);
          }
        });
      },
      _off: function(element, eventName) {
        eventName = (eventName || "").split(" ").join(this.eventNamespace + " ") + this.eventNamespace;
        element.off(eventName);
        this.bindings = $(this.bindings.not(element).get());
        this.focusable = $(this.focusable.not(element).get());
        this.hoverable = $(this.hoverable.not(element).get());
      },
      _delay: function(handler, delay) {
        function handlerProxy() {
          return (typeof handler === "string" ? instance[handler] : handler).apply(instance, arguments);
        }
        var instance = this;
        return setTimeout(handlerProxy, delay || 0);
      },
      _hoverable: function(element) {
        this.hoverable = this.hoverable.add(element);
        this._on(element, {
          mouseenter: function(event) {
            this._addClass($(event.currentTarget), null, "ui-state-hover");
          },
          mouseleave: function(event) {
            this._removeClass($(event.currentTarget), null, "ui-state-hover");
          }
        });
      },
      _focusable: function(element) {
        this.focusable = this.focusable.add(element);
        this._on(element, {
          focusin: function(event) {
            this._addClass($(event.currentTarget), null, "ui-state-focus");
          },
          focusout: function(event) {
            this._removeClass($(event.currentTarget), null, "ui-state-focus");
          }
        });
      },
      _trigger: function(type, event, data) {
        var prop, orig;
        var callback = this.options[type];
        data = data || {};
        event = $.Event(event);
        event.type = (type === this.widgetEventPrefix ? type : this.widgetEventPrefix + type).toLowerCase();
        event.target = this.element[0];
        orig = event.originalEvent;
        if (orig) {
          for (prop in orig) {
            if (!(prop in event)) {
              event[prop] = orig[prop];
            }
          }
        }
        this.element.trigger(event, data);
        return !(typeof callback === "function" && callback.apply(this.element[0], [event].concat(data)) === false || event.isDefaultPrevented());
      }
    };
    $.each({ show: "fadeIn", hide: "fadeOut" }, function(method, defaultEffect) {
      $.Widget.prototype["_" + method] = function(element, options, callback) {
        if (typeof options === "string") {
          options = { effect: options };
        }
        var hasOptions;
        var effectName = !options ? method : options === true || typeof options === "number" ? defaultEffect : options.effect || defaultEffect;
        options = options || {};
        if (typeof options === "number") {
          options = { duration: options };
        } else if (options === true) {
          options = {};
        }
        hasOptions = !$.isEmptyObject(options);
        options.complete = callback;
        if (options.delay) {
          element.delay(options.delay);
        }
        if (hasOptions && $.effects && $.effects.effect[effectName]) {
          element[method](options);
        } else if (effectName !== method && element[effectName]) {
          element[effectName](options.duration, options.easing, callback);
        } else {
          element.queue(function(next) {
            $(this)[method]();
            if (callback) {
              callback.call(element[0]);
            }
            next();
          });
        }
      };
    });
    return $.widget;
  });

  // node_modules/jquery-ui/ui/widgets/menu.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define([
        "jquery",
        "../keycode",
        "../position",
        "../safe-active-element",
        "../unique-id",
        "../version",
        "../widget"
      ], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    return $.widget("ui.menu", {
      version: "1.13.3",
      defaultElement: "<ul>",
      delay: 300,
      options: {
        icons: {
          submenu: "ui-icon-caret-1-e"
        },
        items: "> *",
        menus: "ul",
        position: {
          my: "left top",
          at: "right top"
        },
        role: "menu",
        // Callbacks
        blur: null,
        focus: null,
        select: null
      },
      _create: function() {
        this.activeMenu = this.element;
        this.mouseHandled = false;
        this.lastMousePosition = { x: null, y: null };
        this.element.uniqueId().attr({
          role: this.options.role,
          tabIndex: 0
        });
        this._addClass("ui-menu", "ui-widget ui-widget-content");
        this._on({
          // Prevent focus from sticking to links inside menu after clicking
          // them (focus should always stay on UL during navigation).
          "mousedown .ui-menu-item": function(event) {
            event.preventDefault();
            this._activateItem(event);
          },
          "click .ui-menu-item": function(event) {
            var target = $(event.target);
            var active = $($.ui.safeActiveElement(this.document[0]));
            if (!this.mouseHandled && target.not(".ui-state-disabled").length) {
              this.select(event);
              if (!event.isPropagationStopped()) {
                this.mouseHandled = true;
              }
              if (target.has(".ui-menu").length) {
                this.expand(event);
              } else if (!this.element.is(":focus") && active.closest(".ui-menu").length) {
                this.element.trigger("focus", [true]);
                if (this.active && this.active.parents(".ui-menu").length === 1) {
                  clearTimeout(this.timer);
                }
              }
            }
          },
          "mouseenter .ui-menu-item": "_activateItem",
          "mousemove .ui-menu-item": "_activateItem",
          mouseleave: "collapseAll",
          "mouseleave .ui-menu": "collapseAll",
          focus: function(event, keepActiveItem) {
            var item = this.active || this._menuItems().first();
            if (!keepActiveItem) {
              this.focus(event, item);
            }
          },
          blur: function(event) {
            this._delay(function() {
              var notContained = !$.contains(
                this.element[0],
                $.ui.safeActiveElement(this.document[0])
              );
              if (notContained) {
                this.collapseAll(event);
              }
            });
          },
          keydown: "_keydown"
        });
        this.refresh();
        this._on(this.document, {
          click: function(event) {
            if (this._closeOnDocumentClick(event)) {
              this.collapseAll(event, true);
            }
            this.mouseHandled = false;
          }
        });
      },
      _activateItem: function(event) {
        if (this.previousFilter) {
          return;
        }
        if (event.clientX === this.lastMousePosition.x && event.clientY === this.lastMousePosition.y) {
          return;
        }
        this.lastMousePosition = {
          x: event.clientX,
          y: event.clientY
        };
        var actualTarget = $(event.target).closest(".ui-menu-item"), target = $(event.currentTarget);
        if (actualTarget[0] !== target[0]) {
          return;
        }
        if (target.is(".ui-state-active")) {
          return;
        }
        this._removeClass(
          target.siblings().children(".ui-state-active"),
          null,
          "ui-state-active"
        );
        this.focus(event, target);
      },
      _destroy: function() {
        var items = this.element.find(".ui-menu-item").removeAttr("role aria-disabled"), submenus = items.children(".ui-menu-item-wrapper").removeUniqueId().removeAttr("tabIndex role aria-haspopup");
        this.element.removeAttr("aria-activedescendant").find(".ui-menu").addBack().removeAttr("role aria-labelledby aria-expanded aria-hidden aria-disabled tabIndex").removeUniqueId().show();
        submenus.children().each(function() {
          var elem = $(this);
          if (elem.data("ui-menu-submenu-caret")) {
            elem.remove();
          }
        });
      },
      _keydown: function(event) {
        var match, prev, character, skip, preventDefault = true;
        switch (event.keyCode) {
          case $.ui.keyCode.PAGE_UP:
            this.previousPage(event);
            break;
          case $.ui.keyCode.PAGE_DOWN:
            this.nextPage(event);
            break;
          case $.ui.keyCode.HOME:
            this._move("first", "first", event);
            break;
          case $.ui.keyCode.END:
            this._move("last", "last", event);
            break;
          case $.ui.keyCode.UP:
            this.previous(event);
            break;
          case $.ui.keyCode.DOWN:
            this.next(event);
            break;
          case $.ui.keyCode.LEFT:
            this.collapse(event);
            break;
          case $.ui.keyCode.RIGHT:
            if (this.active && !this.active.is(".ui-state-disabled")) {
              this.expand(event);
            }
            break;
          case $.ui.keyCode.ENTER:
          case $.ui.keyCode.SPACE:
            this._activate(event);
            break;
          case $.ui.keyCode.ESCAPE:
            this.collapse(event);
            break;
          default:
            preventDefault = false;
            prev = this.previousFilter || "";
            skip = false;
            character = event.keyCode >= 96 && event.keyCode <= 105 ? (event.keyCode - 96).toString() : String.fromCharCode(event.keyCode);
            clearTimeout(this.filterTimer);
            if (character === prev) {
              skip = true;
            } else {
              character = prev + character;
            }
            match = this._filterMenuItems(character);
            match = skip && match.index(this.active.next()) !== -1 ? this.active.nextAll(".ui-menu-item") : match;
            if (!match.length) {
              character = String.fromCharCode(event.keyCode);
              match = this._filterMenuItems(character);
            }
            if (match.length) {
              this.focus(event, match);
              this.previousFilter = character;
              this.filterTimer = this._delay(function() {
                delete this.previousFilter;
              }, 1e3);
            } else {
              delete this.previousFilter;
            }
        }
        if (preventDefault) {
          event.preventDefault();
        }
      },
      _activate: function(event) {
        if (this.active && !this.active.is(".ui-state-disabled")) {
          if (this.active.children("[aria-haspopup='true']").length) {
            this.expand(event);
          } else {
            this.select(event);
          }
        }
      },
      refresh: function() {
        var menus, items, newSubmenus, newItems, newWrappers, that = this, icon = this.options.icons.submenu, submenus = this.element.find(this.options.menus);
        this._toggleClass("ui-menu-icons", null, !!this.element.find(".ui-icon").length);
        newSubmenus = submenus.filter(":not(.ui-menu)").hide().attr({
          role: this.options.role,
          "aria-hidden": "true",
          "aria-expanded": "false"
        }).each(function() {
          var menu = $(this), item = menu.prev(), submenuCaret = $("<span>").data("ui-menu-submenu-caret", true);
          that._addClass(submenuCaret, "ui-menu-icon", "ui-icon " + icon);
          item.attr("aria-haspopup", "true").prepend(submenuCaret);
          menu.attr("aria-labelledby", item.attr("id"));
        });
        this._addClass(newSubmenus, "ui-menu", "ui-widget ui-widget-content ui-front");
        menus = submenus.add(this.element);
        items = menus.find(this.options.items);
        items.not(".ui-menu-item").each(function() {
          var item = $(this);
          if (that._isDivider(item)) {
            that._addClass(item, "ui-menu-divider", "ui-widget-content");
          }
        });
        newItems = items.not(".ui-menu-item, .ui-menu-divider");
        newWrappers = newItems.children().not(".ui-menu").uniqueId().attr({
          tabIndex: -1,
          role: this._itemRole()
        });
        this._addClass(newItems, "ui-menu-item")._addClass(newWrappers, "ui-menu-item-wrapper");
        items.filter(".ui-state-disabled").attr("aria-disabled", "true");
        if (this.active && !$.contains(this.element[0], this.active[0])) {
          this.blur();
        }
      },
      _itemRole: function() {
        return {
          menu: "menuitem",
          listbox: "option"
        }[this.options.role];
      },
      _setOption: function(key, value) {
        if (key === "icons") {
          var icons = this.element.find(".ui-menu-icon");
          this._removeClass(icons, null, this.options.icons.submenu)._addClass(icons, null, value.submenu);
        }
        this._super(key, value);
      },
      _setOptionDisabled: function(value) {
        this._super(value);
        this.element.attr("aria-disabled", String(value));
        this._toggleClass(null, "ui-state-disabled", !!value);
      },
      focus: function(event, item) {
        var nested, focused, activeParent;
        this.blur(event, event && event.type === "focus");
        this._scrollIntoView(item);
        this.active = item.first();
        focused = this.active.children(".ui-menu-item-wrapper");
        this._addClass(focused, null, "ui-state-active");
        if (this.options.role) {
          this.element.attr("aria-activedescendant", focused.attr("id"));
        }
        activeParent = this.active.parent().closest(".ui-menu-item").children(".ui-menu-item-wrapper");
        this._addClass(activeParent, null, "ui-state-active");
        if (event && event.type === "keydown") {
          this._close();
        } else {
          this.timer = this._delay(function() {
            this._close();
          }, this.delay);
        }
        nested = item.children(".ui-menu");
        if (nested.length && event && /^mouse/.test(event.type)) {
          this._startOpening(nested);
        }
        this.activeMenu = item.parent();
        this._trigger("focus", event, { item });
      },
      _scrollIntoView: function(item) {
        var borderTop, paddingTop, offset2, scroll, elementHeight, itemHeight;
        if (this._hasScroll()) {
          borderTop = parseFloat($.css(this.activeMenu[0], "borderTopWidth")) || 0;
          paddingTop = parseFloat($.css(this.activeMenu[0], "paddingTop")) || 0;
          offset2 = item.offset().top - this.activeMenu.offset().top - borderTop - paddingTop;
          scroll = this.activeMenu.scrollTop();
          elementHeight = this.activeMenu.height();
          itemHeight = item.outerHeight();
          if (offset2 < 0) {
            this.activeMenu.scrollTop(scroll + offset2);
          } else if (offset2 + itemHeight > elementHeight) {
            this.activeMenu.scrollTop(scroll + offset2 - elementHeight + itemHeight);
          }
        }
      },
      blur: function(event, fromFocus) {
        if (!fromFocus) {
          clearTimeout(this.timer);
        }
        if (!this.active) {
          return;
        }
        this._removeClass(
          this.active.children(".ui-menu-item-wrapper"),
          null,
          "ui-state-active"
        );
        this._trigger("blur", event, { item: this.active });
        this.active = null;
      },
      _startOpening: function(submenu) {
        clearTimeout(this.timer);
        if (submenu.attr("aria-hidden") !== "true") {
          return;
        }
        this.timer = this._delay(function() {
          this._close();
          this._open(submenu);
        }, this.delay);
      },
      _open: function(submenu) {
        var position = $.extend({
          of: this.active
        }, this.options.position);
        clearTimeout(this.timer);
        this.element.find(".ui-menu").not(submenu.parents(".ui-menu")).hide().attr("aria-hidden", "true");
        submenu.show().removeAttr("aria-hidden").attr("aria-expanded", "true").position(position);
      },
      collapseAll: function(event, all) {
        clearTimeout(this.timer);
        this.timer = this._delay(function() {
          var currentMenu = all ? this.element : $(event && event.target).closest(this.element.find(".ui-menu"));
          if (!currentMenu.length) {
            currentMenu = this.element;
          }
          this._close(currentMenu);
          this.blur(event);
          this._removeClass(currentMenu.find(".ui-state-active"), null, "ui-state-active");
          this.activeMenu = currentMenu;
        }, all ? 0 : this.delay);
      },
      // With no arguments, closes the currently active menu - if nothing is active
      // it closes all menus.  If passed an argument, it will search for menus BELOW
      _close: function(startMenu) {
        if (!startMenu) {
          startMenu = this.active ? this.active.parent() : this.element;
        }
        startMenu.find(".ui-menu").hide().attr("aria-hidden", "true").attr("aria-expanded", "false");
      },
      _closeOnDocumentClick: function(event) {
        return !$(event.target).closest(".ui-menu").length;
      },
      _isDivider: function(item) {
        return !/[^\-\u2014\u2013\s]/.test(item.text());
      },
      collapse: function(event) {
        var newItem = this.active && this.active.parent().closest(".ui-menu-item", this.element);
        if (newItem && newItem.length) {
          this._close();
          this.focus(event, newItem);
        }
      },
      expand: function(event) {
        var newItem = this.active && this._menuItems(this.active.children(".ui-menu")).first();
        if (newItem && newItem.length) {
          this._open(newItem.parent());
          this._delay(function() {
            this.focus(event, newItem);
          });
        }
      },
      next: function(event) {
        this._move("next", "first", event);
      },
      previous: function(event) {
        this._move("prev", "last", event);
      },
      isFirstItem: function() {
        return this.active && !this.active.prevAll(".ui-menu-item").length;
      },
      isLastItem: function() {
        return this.active && !this.active.nextAll(".ui-menu-item").length;
      },
      _menuItems: function(menu) {
        return (menu || this.element).find(this.options.items).filter(".ui-menu-item");
      },
      _move: function(direction, filter, event) {
        var next;
        if (this.active) {
          if (direction === "first" || direction === "last") {
            next = this.active[direction === "first" ? "prevAll" : "nextAll"](".ui-menu-item").last();
          } else {
            next = this.active[direction + "All"](".ui-menu-item").first();
          }
        }
        if (!next || !next.length || !this.active) {
          next = this._menuItems(this.activeMenu)[filter]();
        }
        this.focus(event, next);
      },
      nextPage: function(event) {
        var item, base, height;
        if (!this.active) {
          this.next(event);
          return;
        }
        if (this.isLastItem()) {
          return;
        }
        if (this._hasScroll()) {
          base = this.active.offset().top;
          height = this.element.innerHeight();
          if ($.fn.jquery.indexOf("3.2.") === 0) {
            height += this.element[0].offsetHeight - this.element.outerHeight();
          }
          this.active.nextAll(".ui-menu-item").each(function() {
            item = $(this);
            return item.offset().top - base - height < 0;
          });
          this.focus(event, item);
        } else {
          this.focus(event, this._menuItems(this.activeMenu)[!this.active ? "first" : "last"]());
        }
      },
      previousPage: function(event) {
        var item, base, height;
        if (!this.active) {
          this.next(event);
          return;
        }
        if (this.isFirstItem()) {
          return;
        }
        if (this._hasScroll()) {
          base = this.active.offset().top;
          height = this.element.innerHeight();
          if ($.fn.jquery.indexOf("3.2.") === 0) {
            height += this.element[0].offsetHeight - this.element.outerHeight();
          }
          this.active.prevAll(".ui-menu-item").each(function() {
            item = $(this);
            return item.offset().top - base + height > 0;
          });
          this.focus(event, item);
        } else {
          this.focus(event, this._menuItems(this.activeMenu).first());
        }
      },
      _hasScroll: function() {
        return this.element.outerHeight() < this.element.prop("scrollHeight");
      },
      select: function(event) {
        this.active = this.active || $(event.target).closest(".ui-menu-item");
        var ui = { item: this.active };
        if (!this.active.has(".ui-menu").length) {
          this.collapseAll(event, true);
        }
        this._trigger("select", event, ui);
      },
      _filterMenuItems: function(character) {
        var escapedCharacter = character.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&"), regex = new RegExp("^" + escapedCharacter, "i");
        return this.activeMenu.find(this.options.items).filter(".ui-menu-item").filter(function() {
          return regex.test(
            String.prototype.trim.call(
              $(this).children(".ui-menu-item-wrapper").text()
            )
          );
        });
      }
    });
  });

  // node_modules/jquery-ui/ui/widgets/mouse.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define([
        "jquery",
        "../ie",
        "../version",
        "../widget"
      ], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    var mouseHandled = false;
    $(document).on("mouseup", function() {
      mouseHandled = false;
    });
    return $.widget("ui.mouse", {
      version: "1.13.3",
      options: {
        cancel: "input, textarea, button, select, option",
        distance: 1,
        delay: 0
      },
      _mouseInit: function() {
        var that = this;
        this.element.on("mousedown." + this.widgetName, function(event) {
          return that._mouseDown(event);
        }).on("click." + this.widgetName, function(event) {
          if (true === $.data(event.target, that.widgetName + ".preventClickEvent")) {
            $.removeData(event.target, that.widgetName + ".preventClickEvent");
            event.stopImmediatePropagation();
            return false;
          }
        });
        this.started = false;
      },
      // TODO: make sure destroying one instance of mouse doesn't mess with
      // other instances of mouse
      _mouseDestroy: function() {
        this.element.off("." + this.widgetName);
        if (this._mouseMoveDelegate) {
          this.document.off("mousemove." + this.widgetName, this._mouseMoveDelegate).off("mouseup." + this.widgetName, this._mouseUpDelegate);
        }
      },
      _mouseDown: function(event) {
        if (mouseHandled) {
          return;
        }
        this._mouseMoved = false;
        if (this._mouseStarted) {
          this._mouseUp(event);
        }
        this._mouseDownEvent = event;
        var that = this, btnIsLeft = event.which === 1, elIsCancel = typeof this.options.cancel === "string" && event.target.nodeName ? $(event.target).closest(this.options.cancel).length : false;
        if (!btnIsLeft || elIsCancel || !this._mouseCapture(event)) {
          return true;
        }
        this.mouseDelayMet = !this.options.delay;
        if (!this.mouseDelayMet) {
          this._mouseDelayTimer = setTimeout(function() {
            that.mouseDelayMet = true;
          }, this.options.delay);
        }
        if (this._mouseDistanceMet(event) && this._mouseDelayMet(event)) {
          this._mouseStarted = this._mouseStart(event) !== false;
          if (!this._mouseStarted) {
            event.preventDefault();
            return true;
          }
        }
        if (true === $.data(event.target, this.widgetName + ".preventClickEvent")) {
          $.removeData(event.target, this.widgetName + ".preventClickEvent");
        }
        this._mouseMoveDelegate = function(event2) {
          return that._mouseMove(event2);
        };
        this._mouseUpDelegate = function(event2) {
          return that._mouseUp(event2);
        };
        this.document.on("mousemove." + this.widgetName, this._mouseMoveDelegate).on("mouseup." + this.widgetName, this._mouseUpDelegate);
        event.preventDefault();
        mouseHandled = true;
        return true;
      },
      _mouseMove: function(event) {
        if (this._mouseMoved) {
          if ($.ui.ie && (!document.documentMode || document.documentMode < 9) && !event.button) {
            return this._mouseUp(event);
          } else if (!event.which) {
            if (event.originalEvent.altKey || event.originalEvent.ctrlKey || event.originalEvent.metaKey || event.originalEvent.shiftKey) {
              this.ignoreMissingWhich = true;
            } else if (!this.ignoreMissingWhich) {
              return this._mouseUp(event);
            }
          }
        }
        if (event.which || event.button) {
          this._mouseMoved = true;
        }
        if (this._mouseStarted) {
          this._mouseDrag(event);
          return event.preventDefault();
        }
        if (this._mouseDistanceMet(event) && this._mouseDelayMet(event)) {
          this._mouseStarted = this._mouseStart(this._mouseDownEvent, event) !== false;
          if (this._mouseStarted) {
            this._mouseDrag(event);
          } else {
            this._mouseUp(event);
          }
        }
        return !this._mouseStarted;
      },
      _mouseUp: function(event) {
        this.document.off("mousemove." + this.widgetName, this._mouseMoveDelegate).off("mouseup." + this.widgetName, this._mouseUpDelegate);
        if (this._mouseStarted) {
          this._mouseStarted = false;
          if (event.target === this._mouseDownEvent.target) {
            $.data(event.target, this.widgetName + ".preventClickEvent", true);
          }
          this._mouseStop(event);
        }
        if (this._mouseDelayTimer) {
          clearTimeout(this._mouseDelayTimer);
          delete this._mouseDelayTimer;
        }
        this.ignoreMissingWhich = false;
        mouseHandled = false;
        event.preventDefault();
      },
      _mouseDistanceMet: function(event) {
        return Math.max(
          Math.abs(this._mouseDownEvent.pageX - event.pageX),
          Math.abs(this._mouseDownEvent.pageY - event.pageY)
        ) >= this.options.distance;
      },
      _mouseDelayMet: function() {
        return this.mouseDelayMet;
      },
      // These are placeholder methods, to be overriden by extending plugin
      _mouseStart: function() {
      },
      _mouseDrag: function() {
      },
      _mouseStop: function() {
      },
      _mouseCapture: function() {
        return true;
      }
    });
  });

  // node_modules/rails_admin/src/rails_admin/abstract-select.js
  var import_jquery3 = __toESM(require_jquery());
  (function($) {
    "use strict";
    $.widget("ra.abstractSelect", {
      options: {
        createQuery: function(query) {
          if ($.isEmptyObject(this.scopeBy)) {
            return { query };
          } else {
            const filterQuery = {};
            for (var field in this.scopeBy) {
              const targetField = this.scopeBy[field];
              const targetValue = $(`[name$="[${field}]"]`).val();
              if (!filterQuery[targetField]) {
                filterQuery[targetField] = [];
              }
              filterQuery[targetField].push(
                targetValue ? { o: "is", v: targetValue } : { o: "_blank" }
              );
            }
            return { query, f: filterQuery };
          }
        },
        scopeBy: {}
      }
    });
  })(import_jquery3.default);

  // node_modules/rails_admin/src/rails_admin/filter-box.js
  var import_jquery4 = __toESM(require_jquery());

  // node_modules/rails_admin/src/rails_admin/i18n.js
  var I18n = {
    locale: null,
    translations: null,
    init(locale, translations) {
      this.locale = locale;
      this.translations = translations;
      if (typeof this.translations === "string") {
        this.translations = JSON.parse(this.translations);
      }
    },
    t(key) {
      var humanize;
      humanize = key.charAt(0).toUpperCase() + key.replace(/_/g, " ").slice(1);
      return this.translations[key] || humanize;
    }
  };

  // node_modules/flatpickr/dist/esm/types/options.js
  var HOOKS = [
    "onChange",
    "onClose",
    "onDayCreate",
    "onDestroy",
    "onKeyDown",
    "onMonthChange",
    "onOpen",
    "onParseConfig",
    "onReady",
    "onValueUpdate",
    "onYearChange",
    "onPreCalendarPosition"
  ];
  var defaults = {
    _disable: [],
    allowInput: false,
    allowInvalidPreload: false,
    altFormat: "F j, Y",
    altInput: false,
    altInputClass: "form-control input",
    animate: typeof window === "object" && window.navigator.userAgent.indexOf("MSIE") === -1,
    ariaDateFormat: "F j, Y",
    autoFillDefaultTime: true,
    clickOpens: true,
    closeOnSelect: true,
    conjunction: ", ",
    dateFormat: "Y-m-d",
    defaultHour: 12,
    defaultMinute: 0,
    defaultSeconds: 0,
    disable: [],
    disableMobile: false,
    enableSeconds: false,
    enableTime: false,
    errorHandler: function(err) {
      return typeof console !== "undefined" && console.warn(err);
    },
    getWeek: function(givenDate) {
      var date = new Date(givenDate.getTime());
      date.setHours(0, 0, 0, 0);
      date.setDate(date.getDate() + 3 - (date.getDay() + 6) % 7);
      var week1 = new Date(date.getFullYear(), 0, 4);
      return 1 + Math.round(((date.getTime() - week1.getTime()) / 864e5 - 3 + (week1.getDay() + 6) % 7) / 7);
    },
    hourIncrement: 1,
    ignoredFocusElements: [],
    inline: false,
    locale: "default",
    minuteIncrement: 5,
    mode: "single",
    monthSelectorType: "dropdown",
    nextArrow: "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 17 17'><g></g><path d='M13.207 8.472l-7.854 7.854-0.707-0.707 7.146-7.146-7.146-7.148 0.707-0.707 7.854 7.854z' /></svg>",
    noCalendar: false,
    now: /* @__PURE__ */ new Date(),
    onChange: [],
    onClose: [],
    onDayCreate: [],
    onDestroy: [],
    onKeyDown: [],
    onMonthChange: [],
    onOpen: [],
    onParseConfig: [],
    onReady: [],
    onValueUpdate: [],
    onYearChange: [],
    onPreCalendarPosition: [],
    plugins: [],
    position: "auto",
    positionElement: void 0,
    prevArrow: "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 17 17'><g></g><path d='M5.207 8.471l7.146 7.147-0.707 0.707-7.853-7.854 7.854-7.853 0.707 0.707-7.147 7.146z' /></svg>",
    shorthandCurrentMonth: false,
    showMonths: 1,
    static: false,
    time_24hr: false,
    weekNumbers: false,
    wrap: false
  };

  // node_modules/flatpickr/dist/esm/l10n/default.js
  var english = {
    weekdays: {
      shorthand: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
      longhand: [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
      ]
    },
    months: {
      shorthand: [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ],
      longhand: [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ]
    },
    daysInMonth: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
    firstDayOfWeek: 0,
    ordinal: function(nth) {
      var s = nth % 100;
      if (s > 3 && s < 21)
        return "th";
      switch (s % 10) {
        case 1:
          return "st";
        case 2:
          return "nd";
        case 3:
          return "rd";
        default:
          return "th";
      }
    },
    rangeSeparator: " to ",
    weekAbbreviation: "Wk",
    scrollTitle: "Scroll to increment",
    toggleTitle: "Click to toggle",
    amPM: ["AM", "PM"],
    yearAriaLabel: "Year",
    monthAriaLabel: "Month",
    hourAriaLabel: "Hour",
    minuteAriaLabel: "Minute",
    time_24hr: false
  };
  var default_default = english;

  // node_modules/flatpickr/dist/esm/utils/index.js
  var pad = function(number, length) {
    if (length === void 0) {
      length = 2;
    }
    return ("000" + number).slice(length * -1);
  };
  var int = function(bool) {
    return bool === true ? 1 : 0;
  };
  function debounce2(fn2, wait) {
    var t;
    return function() {
      var _this = this;
      var args = arguments;
      clearTimeout(t);
      t = setTimeout(function() {
        return fn2.apply(_this, args);
      }, wait);
    };
  }
  var arrayify = function(obj) {
    return obj instanceof Array ? obj : [obj];
  };

  // node_modules/flatpickr/dist/esm/utils/dom.js
  function toggleClass(elem, className, bool) {
    if (bool === true)
      return elem.classList.add(className);
    elem.classList.remove(className);
  }
  function createElement(tag, className, content) {
    var e = window.document.createElement(tag);
    className = className || "";
    content = content || "";
    e.className = className;
    if (content !== void 0)
      e.textContent = content;
    return e;
  }
  function clearNode(node) {
    while (node.firstChild)
      node.removeChild(node.firstChild);
  }
  function findParent(node, condition) {
    if (condition(node))
      return node;
    else if (node.parentNode)
      return findParent(node.parentNode, condition);
    return void 0;
  }
  function createNumberInput(inputClassName, opts) {
    var wrapper = createElement("div", "numInputWrapper"), numInput = createElement("input", "numInput " + inputClassName), arrowUp = createElement("span", "arrowUp"), arrowDown = createElement("span", "arrowDown");
    if (navigator.userAgent.indexOf("MSIE 9.0") === -1) {
      numInput.type = "number";
    } else {
      numInput.type = "text";
      numInput.pattern = "\\d*";
    }
    if (opts !== void 0)
      for (var key in opts)
        numInput.setAttribute(key, opts[key]);
    wrapper.appendChild(numInput);
    wrapper.appendChild(arrowUp);
    wrapper.appendChild(arrowDown);
    return wrapper;
  }
  function getEventTarget(event) {
    try {
      if (typeof event.composedPath === "function") {
        var path = event.composedPath();
        return path[0];
      }
      return event.target;
    } catch (error) {
      return event.target;
    }
  }

  // node_modules/flatpickr/dist/esm/utils/formatting.js
  var doNothing = function() {
    return void 0;
  };
  var monthToStr = function(monthNumber, shorthand, locale) {
    return locale.months[shorthand ? "shorthand" : "longhand"][monthNumber];
  };
  var revFormat = {
    D: doNothing,
    F: function(dateObj, monthName, locale) {
      dateObj.setMonth(locale.months.longhand.indexOf(monthName));
    },
    G: function(dateObj, hour) {
      dateObj.setHours((dateObj.getHours() >= 12 ? 12 : 0) + parseFloat(hour));
    },
    H: function(dateObj, hour) {
      dateObj.setHours(parseFloat(hour));
    },
    J: function(dateObj, day) {
      dateObj.setDate(parseFloat(day));
    },
    K: function(dateObj, amPM, locale) {
      dateObj.setHours(dateObj.getHours() % 12 + 12 * int(new RegExp(locale.amPM[1], "i").test(amPM)));
    },
    M: function(dateObj, shortMonth, locale) {
      dateObj.setMonth(locale.months.shorthand.indexOf(shortMonth));
    },
    S: function(dateObj, seconds) {
      dateObj.setSeconds(parseFloat(seconds));
    },
    U: function(_, unixSeconds) {
      return new Date(parseFloat(unixSeconds) * 1e3);
    },
    W: function(dateObj, weekNum, locale) {
      var weekNumber = parseInt(weekNum);
      var date = new Date(dateObj.getFullYear(), 0, 2 + (weekNumber - 1) * 7, 0, 0, 0, 0);
      date.setDate(date.getDate() - date.getDay() + locale.firstDayOfWeek);
      return date;
    },
    Y: function(dateObj, year) {
      dateObj.setFullYear(parseFloat(year));
    },
    Z: function(_, ISODate) {
      return new Date(ISODate);
    },
    d: function(dateObj, day) {
      dateObj.setDate(parseFloat(day));
    },
    h: function(dateObj, hour) {
      dateObj.setHours((dateObj.getHours() >= 12 ? 12 : 0) + parseFloat(hour));
    },
    i: function(dateObj, minutes) {
      dateObj.setMinutes(parseFloat(minutes));
    },
    j: function(dateObj, day) {
      dateObj.setDate(parseFloat(day));
    },
    l: doNothing,
    m: function(dateObj, month) {
      dateObj.setMonth(parseFloat(month) - 1);
    },
    n: function(dateObj, month) {
      dateObj.setMonth(parseFloat(month) - 1);
    },
    s: function(dateObj, seconds) {
      dateObj.setSeconds(parseFloat(seconds));
    },
    u: function(_, unixMillSeconds) {
      return new Date(parseFloat(unixMillSeconds));
    },
    w: doNothing,
    y: function(dateObj, year) {
      dateObj.setFullYear(2e3 + parseFloat(year));
    }
  };
  var tokenRegex = {
    D: "",
    F: "",
    G: "(\\d\\d|\\d)",
    H: "(\\d\\d|\\d)",
    J: "(\\d\\d|\\d)\\w+",
    K: "",
    M: "",
    S: "(\\d\\d|\\d)",
    U: "(.+)",
    W: "(\\d\\d|\\d)",
    Y: "(\\d{4})",
    Z: "(.+)",
    d: "(\\d\\d|\\d)",
    h: "(\\d\\d|\\d)",
    i: "(\\d\\d|\\d)",
    j: "(\\d\\d|\\d)",
    l: "",
    m: "(\\d\\d|\\d)",
    n: "(\\d\\d|\\d)",
    s: "(\\d\\d|\\d)",
    u: "(.+)",
    w: "(\\d\\d|\\d)",
    y: "(\\d{2})"
  };
  var formats = {
    Z: function(date) {
      return date.toISOString();
    },
    D: function(date, locale, options) {
      return locale.weekdays.shorthand[formats.w(date, locale, options)];
    },
    F: function(date, locale, options) {
      return monthToStr(formats.n(date, locale, options) - 1, false, locale);
    },
    G: function(date, locale, options) {
      return pad(formats.h(date, locale, options));
    },
    H: function(date) {
      return pad(date.getHours());
    },
    J: function(date, locale) {
      return locale.ordinal !== void 0 ? date.getDate() + locale.ordinal(date.getDate()) : date.getDate();
    },
    K: function(date, locale) {
      return locale.amPM[int(date.getHours() > 11)];
    },
    M: function(date, locale) {
      return monthToStr(date.getMonth(), true, locale);
    },
    S: function(date) {
      return pad(date.getSeconds());
    },
    U: function(date) {
      return date.getTime() / 1e3;
    },
    W: function(date, _, options) {
      return options.getWeek(date);
    },
    Y: function(date) {
      return pad(date.getFullYear(), 4);
    },
    d: function(date) {
      return pad(date.getDate());
    },
    h: function(date) {
      return date.getHours() % 12 ? date.getHours() % 12 : 12;
    },
    i: function(date) {
      return pad(date.getMinutes());
    },
    j: function(date) {
      return date.getDate();
    },
    l: function(date, locale) {
      return locale.weekdays.longhand[date.getDay()];
    },
    m: function(date) {
      return pad(date.getMonth() + 1);
    },
    n: function(date) {
      return date.getMonth() + 1;
    },
    s: function(date) {
      return date.getSeconds();
    },
    u: function(date) {
      return date.getTime();
    },
    w: function(date) {
      return date.getDay();
    },
    y: function(date) {
      return String(date.getFullYear()).substring(2);
    }
  };

  // node_modules/flatpickr/dist/esm/utils/dates.js
  var createDateFormatter = function(_a) {
    var _b = _a.config, config = _b === void 0 ? defaults : _b, _c = _a.l10n, l10n = _c === void 0 ? english : _c, _d = _a.isMobile, isMobile = _d === void 0 ? false : _d;
    return function(dateObj, frmt, overrideLocale) {
      var locale = overrideLocale || l10n;
      if (config.formatDate !== void 0 && !isMobile) {
        return config.formatDate(dateObj, frmt, locale);
      }
      return frmt.split("").map(function(c, i, arr) {
        return formats[c] && arr[i - 1] !== "\\" ? formats[c](dateObj, locale, config) : c !== "\\" ? c : "";
      }).join("");
    };
  };
  var createDateParser = function(_a) {
    var _b = _a.config, config = _b === void 0 ? defaults : _b, _c = _a.l10n, l10n = _c === void 0 ? english : _c;
    return function(date, givenFormat, timeless, customLocale) {
      if (date !== 0 && !date)
        return void 0;
      var locale = customLocale || l10n;
      var parsedDate;
      var dateOrig = date;
      if (date instanceof Date)
        parsedDate = new Date(date.getTime());
      else if (typeof date !== "string" && date.toFixed !== void 0)
        parsedDate = new Date(date);
      else if (typeof date === "string") {
        var format = givenFormat || (config || defaults).dateFormat;
        var datestr = String(date).trim();
        if (datestr === "today") {
          parsedDate = /* @__PURE__ */ new Date();
          timeless = true;
        } else if (config && config.parseDate) {
          parsedDate = config.parseDate(date, format);
        } else if (/Z$/.test(datestr) || /GMT$/.test(datestr)) {
          parsedDate = new Date(date);
        } else {
          var matched = void 0, ops = [];
          for (var i = 0, matchIndex = 0, regexStr = ""; i < format.length; i++) {
            var token = format[i];
            var isBackSlash = token === "\\";
            var escaped = format[i - 1] === "\\" || isBackSlash;
            if (tokenRegex[token] && !escaped) {
              regexStr += tokenRegex[token];
              var match = new RegExp(regexStr).exec(date);
              if (match && (matched = true)) {
                ops[token !== "Y" ? "push" : "unshift"]({
                  fn: revFormat[token],
                  val: match[++matchIndex]
                });
              }
            } else if (!isBackSlash)
              regexStr += ".";
          }
          parsedDate = !config || !config.noCalendar ? new Date((/* @__PURE__ */ new Date()).getFullYear(), 0, 1, 0, 0, 0, 0) : new Date((/* @__PURE__ */ new Date()).setHours(0, 0, 0, 0));
          ops.forEach(function(_a2) {
            var fn2 = _a2.fn, val = _a2.val;
            return parsedDate = fn2(parsedDate, val, locale) || parsedDate;
          });
          parsedDate = matched ? parsedDate : void 0;
        }
      }
      if (!(parsedDate instanceof Date && !isNaN(parsedDate.getTime()))) {
        config.errorHandler(new Error("Invalid date provided: " + dateOrig));
        return void 0;
      }
      if (timeless === true)
        parsedDate.setHours(0, 0, 0, 0);
      return parsedDate;
    };
  };
  function compareDates(date1, date2, timeless) {
    if (timeless === void 0) {
      timeless = true;
    }
    if (timeless !== false) {
      return new Date(date1.getTime()).setHours(0, 0, 0, 0) - new Date(date2.getTime()).setHours(0, 0, 0, 0);
    }
    return date1.getTime() - date2.getTime();
  }
  var isBetween = function(ts, ts1, ts2) {
    return ts > Math.min(ts1, ts2) && ts < Math.max(ts1, ts2);
  };
  var calculateSecondsSinceMidnight = function(hours, minutes, seconds) {
    return hours * 3600 + minutes * 60 + seconds;
  };
  var parseSeconds = function(secondsSinceMidnight) {
    var hours = Math.floor(secondsSinceMidnight / 3600), minutes = (secondsSinceMidnight - hours * 3600) / 60;
    return [hours, minutes, secondsSinceMidnight - hours * 3600 - minutes * 60];
  };
  var duration = {
    DAY: 864e5
  };
  function getDefaultHours(config) {
    var hours = config.defaultHour;
    var minutes = config.defaultMinute;
    var seconds = config.defaultSeconds;
    if (config.minDate !== void 0) {
      var minHour = config.minDate.getHours();
      var minMinutes = config.minDate.getMinutes();
      var minSeconds = config.minDate.getSeconds();
      if (hours < minHour) {
        hours = minHour;
      }
      if (hours === minHour && minutes < minMinutes) {
        minutes = minMinutes;
      }
      if (hours === minHour && minutes === minMinutes && seconds < minSeconds)
        seconds = config.minDate.getSeconds();
    }
    if (config.maxDate !== void 0) {
      var maxHr = config.maxDate.getHours();
      var maxMinutes = config.maxDate.getMinutes();
      hours = Math.min(hours, maxHr);
      if (hours === maxHr)
        minutes = Math.min(maxMinutes, minutes);
      if (hours === maxHr && minutes === maxMinutes)
        seconds = config.maxDate.getSeconds();
    }
    return { hours, minutes, seconds };
  }

  // node_modules/flatpickr/dist/esm/utils/polyfills.js
  if (typeof Object.assign !== "function") {
    Object.assign = function(target) {
      var args = [];
      for (var _i = 1; _i < arguments.length; _i++) {
        args[_i - 1] = arguments[_i];
      }
      if (!target) {
        throw TypeError("Cannot convert undefined or null to object");
      }
      var _loop_1 = function(source2) {
        if (source2) {
          Object.keys(source2).forEach(function(key) {
            return target[key] = source2[key];
          });
        }
      };
      for (var _a = 0, args_1 = args; _a < args_1.length; _a++) {
        var source = args_1[_a];
        _loop_1(source);
      }
      return target;
    };
  }

  // node_modules/flatpickr/dist/esm/index.js
  var __assign = function() {
    __assign = Object.assign || function(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
          t[p] = s[p];
      }
      return t;
    };
    return __assign.apply(this, arguments);
  };
  var __spreadArrays = function() {
    for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
    for (var r = Array(s), k = 0, i = 0; i < il; i++)
      for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++)
        r[k] = a[j];
    return r;
  };
  var DEBOUNCED_CHANGE_MS = 300;
  function FlatpickrInstance(element, instanceConfig) {
    var self2 = {
      config: __assign(__assign({}, defaults), flatpickr.defaultConfig),
      l10n: default_default
    };
    self2.parseDate = createDateParser({ config: self2.config, l10n: self2.l10n });
    self2._handlers = [];
    self2.pluginElements = [];
    self2.loadedPlugins = [];
    self2._bind = bind;
    self2._setHoursFromDate = setHoursFromDate;
    self2._positionCalendar = positionCalendar;
    self2.changeMonth = changeMonth;
    self2.changeYear = changeYear;
    self2.clear = clear;
    self2.close = close;
    self2.onMouseOver = onMouseOver;
    self2._createElement = createElement;
    self2.createDay = createDay;
    self2.destroy = destroy;
    self2.isEnabled = isEnabled;
    self2.jumpToDate = jumpToDate;
    self2.updateValue = updateValue;
    self2.open = open;
    self2.redraw = redraw;
    self2.set = set;
    self2.setDate = setDate;
    self2.toggle = toggle;
    function setupHelperFunctions() {
      self2.utils = {
        getDaysInMonth: function(month, yr) {
          if (month === void 0) {
            month = self2.currentMonth;
          }
          if (yr === void 0) {
            yr = self2.currentYear;
          }
          if (month === 1 && (yr % 4 === 0 && yr % 100 !== 0 || yr % 400 === 0))
            return 29;
          return self2.l10n.daysInMonth[month];
        }
      };
    }
    function init() {
      self2.element = self2.input = element;
      self2.isOpen = false;
      parseConfig();
      setupLocale();
      setupInputs();
      setupDates();
      setupHelperFunctions();
      if (!self2.isMobile)
        build();
      bindEvents();
      if (self2.selectedDates.length || self2.config.noCalendar) {
        if (self2.config.enableTime) {
          setHoursFromDate(self2.config.noCalendar ? self2.latestSelectedDateObj : void 0);
        }
        updateValue(false);
      }
      setCalendarWidth();
      var isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent);
      if (!self2.isMobile && isSafari) {
        positionCalendar();
      }
      triggerEvent("onReady");
    }
    function getClosestActiveElement() {
      var _a;
      return ((_a = self2.calendarContainer) === null || _a === void 0 ? void 0 : _a.getRootNode()).activeElement || document.activeElement;
    }
    function bindToInstance(fn2) {
      return fn2.bind(self2);
    }
    function setCalendarWidth() {
      var config = self2.config;
      if (config.weekNumbers === false && config.showMonths === 1) {
        return;
      } else if (config.noCalendar !== true) {
        window.requestAnimationFrame(function() {
          if (self2.calendarContainer !== void 0) {
            self2.calendarContainer.style.visibility = "hidden";
            self2.calendarContainer.style.display = "block";
          }
          if (self2.daysContainer !== void 0) {
            var daysWidth = (self2.days.offsetWidth + 1) * config.showMonths;
            self2.daysContainer.style.width = daysWidth + "px";
            self2.calendarContainer.style.width = daysWidth + (self2.weekWrapper !== void 0 ? self2.weekWrapper.offsetWidth : 0) + "px";
            self2.calendarContainer.style.removeProperty("visibility");
            self2.calendarContainer.style.removeProperty("display");
          }
        });
      }
    }
    function updateTime(e) {
      if (self2.selectedDates.length === 0) {
        var defaultDate = self2.config.minDate === void 0 || compareDates(/* @__PURE__ */ new Date(), self2.config.minDate) >= 0 ? /* @__PURE__ */ new Date() : new Date(self2.config.minDate.getTime());
        var defaults2 = getDefaultHours(self2.config);
        defaultDate.setHours(defaults2.hours, defaults2.minutes, defaults2.seconds, defaultDate.getMilliseconds());
        self2.selectedDates = [defaultDate];
        self2.latestSelectedDateObj = defaultDate;
      }
      if (e !== void 0 && e.type !== "blur") {
        timeWrapper(e);
      }
      var prevValue = self2._input.value;
      setHoursFromInputs();
      updateValue();
      if (self2._input.value !== prevValue) {
        self2._debouncedChange();
      }
    }
    function ampm2military(hour, amPM) {
      return hour % 12 + 12 * int(amPM === self2.l10n.amPM[1]);
    }
    function military2ampm(hour) {
      switch (hour % 24) {
        case 0:
        case 12:
          return 12;
        default:
          return hour % 12;
      }
    }
    function setHoursFromInputs() {
      if (self2.hourElement === void 0 || self2.minuteElement === void 0)
        return;
      var hours = (parseInt(self2.hourElement.value.slice(-2), 10) || 0) % 24, minutes = (parseInt(self2.minuteElement.value, 10) || 0) % 60, seconds = self2.secondElement !== void 0 ? (parseInt(self2.secondElement.value, 10) || 0) % 60 : 0;
      if (self2.amPM !== void 0) {
        hours = ampm2military(hours, self2.amPM.textContent);
      }
      var limitMinHours = self2.config.minTime !== void 0 || self2.config.minDate && self2.minDateHasTime && self2.latestSelectedDateObj && compareDates(self2.latestSelectedDateObj, self2.config.minDate, true) === 0;
      var limitMaxHours = self2.config.maxTime !== void 0 || self2.config.maxDate && self2.maxDateHasTime && self2.latestSelectedDateObj && compareDates(self2.latestSelectedDateObj, self2.config.maxDate, true) === 0;
      if (self2.config.maxTime !== void 0 && self2.config.minTime !== void 0 && self2.config.minTime > self2.config.maxTime) {
        var minBound = calculateSecondsSinceMidnight(self2.config.minTime.getHours(), self2.config.minTime.getMinutes(), self2.config.minTime.getSeconds());
        var maxBound = calculateSecondsSinceMidnight(self2.config.maxTime.getHours(), self2.config.maxTime.getMinutes(), self2.config.maxTime.getSeconds());
        var currentTime = calculateSecondsSinceMidnight(hours, minutes, seconds);
        if (currentTime > maxBound && currentTime < minBound) {
          var result = parseSeconds(minBound);
          hours = result[0];
          minutes = result[1];
          seconds = result[2];
        }
      } else {
        if (limitMaxHours) {
          var maxTime = self2.config.maxTime !== void 0 ? self2.config.maxTime : self2.config.maxDate;
          hours = Math.min(hours, maxTime.getHours());
          if (hours === maxTime.getHours())
            minutes = Math.min(minutes, maxTime.getMinutes());
          if (minutes === maxTime.getMinutes())
            seconds = Math.min(seconds, maxTime.getSeconds());
        }
        if (limitMinHours) {
          var minTime = self2.config.minTime !== void 0 ? self2.config.minTime : self2.config.minDate;
          hours = Math.max(hours, minTime.getHours());
          if (hours === minTime.getHours() && minutes < minTime.getMinutes())
            minutes = minTime.getMinutes();
          if (minutes === minTime.getMinutes())
            seconds = Math.max(seconds, minTime.getSeconds());
        }
      }
      setHours(hours, minutes, seconds);
    }
    function setHoursFromDate(dateObj) {
      var date = dateObj || self2.latestSelectedDateObj;
      if (date && date instanceof Date) {
        setHours(date.getHours(), date.getMinutes(), date.getSeconds());
      }
    }
    function setHours(hours, minutes, seconds) {
      if (self2.latestSelectedDateObj !== void 0) {
        self2.latestSelectedDateObj.setHours(hours % 24, minutes, seconds || 0, 0);
      }
      if (!self2.hourElement || !self2.minuteElement || self2.isMobile)
        return;
      self2.hourElement.value = pad(!self2.config.time_24hr ? (12 + hours) % 12 + 12 * int(hours % 12 === 0) : hours);
      self2.minuteElement.value = pad(minutes);
      if (self2.amPM !== void 0)
        self2.amPM.textContent = self2.l10n.amPM[int(hours >= 12)];
      if (self2.secondElement !== void 0)
        self2.secondElement.value = pad(seconds);
    }
    function onYearInput(event) {
      var eventTarget = getEventTarget(event);
      var year = parseInt(eventTarget.value) + (event.delta || 0);
      if (year / 1e3 > 1 || event.key === "Enter" && !/[^\d]/.test(year.toString())) {
        changeYear(year);
      }
    }
    function bind(element2, event, handler, options) {
      if (event instanceof Array)
        return event.forEach(function(ev) {
          return bind(element2, ev, handler, options);
        });
      if (element2 instanceof Array)
        return element2.forEach(function(el) {
          return bind(el, event, handler, options);
        });
      element2.addEventListener(event, handler, options);
      self2._handlers.push({
        remove: function() {
          return element2.removeEventListener(event, handler, options);
        }
      });
    }
    function triggerChange() {
      triggerEvent("onChange");
    }
    function bindEvents() {
      if (self2.config.wrap) {
        ["open", "close", "toggle", "clear"].forEach(function(evt) {
          Array.prototype.forEach.call(self2.element.querySelectorAll("[data-" + evt + "]"), function(el) {
            return bind(el, "click", self2[evt]);
          });
        });
      }
      if (self2.isMobile) {
        setupMobile();
        return;
      }
      var debouncedResize = debounce2(onResize, 50);
      self2._debouncedChange = debounce2(triggerChange, DEBOUNCED_CHANGE_MS);
      if (self2.daysContainer && !/iPhone|iPad|iPod/i.test(navigator.userAgent))
        bind(self2.daysContainer, "mouseover", function(e) {
          if (self2.config.mode === "range")
            onMouseOver(getEventTarget(e));
        });
      bind(self2._input, "keydown", onKeyDown);
      if (self2.calendarContainer !== void 0) {
        bind(self2.calendarContainer, "keydown", onKeyDown);
      }
      if (!self2.config.inline && !self2.config.static)
        bind(window, "resize", debouncedResize);
      if (window.ontouchstart !== void 0)
        bind(window.document, "touchstart", documentClick);
      else
        bind(window.document, "mousedown", documentClick);
      bind(window.document, "focus", documentClick, { capture: true });
      if (self2.config.clickOpens === true) {
        bind(self2._input, "focus", self2.open);
        bind(self2._input, "click", self2.open);
      }
      if (self2.daysContainer !== void 0) {
        bind(self2.monthNav, "click", onMonthNavClick);
        bind(self2.monthNav, ["keyup", "increment"], onYearInput);
        bind(self2.daysContainer, "click", selectDate);
      }
      if (self2.timeContainer !== void 0 && self2.minuteElement !== void 0 && self2.hourElement !== void 0) {
        var selText = function(e) {
          return getEventTarget(e).select();
        };
        bind(self2.timeContainer, ["increment"], updateTime);
        bind(self2.timeContainer, "blur", updateTime, { capture: true });
        bind(self2.timeContainer, "click", timeIncrement);
        bind([self2.hourElement, self2.minuteElement], ["focus", "click"], selText);
        if (self2.secondElement !== void 0)
          bind(self2.secondElement, "focus", function() {
            return self2.secondElement && self2.secondElement.select();
          });
        if (self2.amPM !== void 0) {
          bind(self2.amPM, "click", function(e) {
            updateTime(e);
          });
        }
      }
      if (self2.config.allowInput) {
        bind(self2._input, "blur", onBlur);
      }
    }
    function jumpToDate(jumpDate, triggerChange2) {
      var jumpTo = jumpDate !== void 0 ? self2.parseDate(jumpDate) : self2.latestSelectedDateObj || (self2.config.minDate && self2.config.minDate > self2.now ? self2.config.minDate : self2.config.maxDate && self2.config.maxDate < self2.now ? self2.config.maxDate : self2.now);
      var oldYear = self2.currentYear;
      var oldMonth = self2.currentMonth;
      try {
        if (jumpTo !== void 0) {
          self2.currentYear = jumpTo.getFullYear();
          self2.currentMonth = jumpTo.getMonth();
        }
      } catch (e) {
        e.message = "Invalid date supplied: " + jumpTo;
        self2.config.errorHandler(e);
      }
      if (triggerChange2 && self2.currentYear !== oldYear) {
        triggerEvent("onYearChange");
        buildMonthSwitch();
      }
      if (triggerChange2 && (self2.currentYear !== oldYear || self2.currentMonth !== oldMonth)) {
        triggerEvent("onMonthChange");
      }
      self2.redraw();
    }
    function timeIncrement(e) {
      var eventTarget = getEventTarget(e);
      if (~eventTarget.className.indexOf("arrow"))
        incrementNumInput(e, eventTarget.classList.contains("arrowUp") ? 1 : -1);
    }
    function incrementNumInput(e, delta, inputElem) {
      var target = e && getEventTarget(e);
      var input = inputElem || target && target.parentNode && target.parentNode.firstChild;
      var event = createEvent("increment");
      event.delta = delta;
      input && input.dispatchEvent(event);
    }
    function build() {
      var fragment = window.document.createDocumentFragment();
      self2.calendarContainer = createElement("div", "flatpickr-calendar");
      self2.calendarContainer.tabIndex = -1;
      if (!self2.config.noCalendar) {
        fragment.appendChild(buildMonthNav());
        self2.innerContainer = createElement("div", "flatpickr-innerContainer");
        if (self2.config.weekNumbers) {
          var _a = buildWeeks(), weekWrapper = _a.weekWrapper, weekNumbers = _a.weekNumbers;
          self2.innerContainer.appendChild(weekWrapper);
          self2.weekNumbers = weekNumbers;
          self2.weekWrapper = weekWrapper;
        }
        self2.rContainer = createElement("div", "flatpickr-rContainer");
        self2.rContainer.appendChild(buildWeekdays());
        if (!self2.daysContainer) {
          self2.daysContainer = createElement("div", "flatpickr-days");
          self2.daysContainer.tabIndex = -1;
        }
        buildDays();
        self2.rContainer.appendChild(self2.daysContainer);
        self2.innerContainer.appendChild(self2.rContainer);
        fragment.appendChild(self2.innerContainer);
      }
      if (self2.config.enableTime) {
        fragment.appendChild(buildTime());
      }
      toggleClass(self2.calendarContainer, "rangeMode", self2.config.mode === "range");
      toggleClass(self2.calendarContainer, "animate", self2.config.animate === true);
      toggleClass(self2.calendarContainer, "multiMonth", self2.config.showMonths > 1);
      self2.calendarContainer.appendChild(fragment);
      var customAppend = self2.config.appendTo !== void 0 && self2.config.appendTo.nodeType !== void 0;
      if (self2.config.inline || self2.config.static) {
        self2.calendarContainer.classList.add(self2.config.inline ? "inline" : "static");
        if (self2.config.inline) {
          if (!customAppend && self2.element.parentNode)
            self2.element.parentNode.insertBefore(self2.calendarContainer, self2._input.nextSibling);
          else if (self2.config.appendTo !== void 0)
            self2.config.appendTo.appendChild(self2.calendarContainer);
        }
        if (self2.config.static) {
          var wrapper = createElement("div", "flatpickr-wrapper");
          if (self2.element.parentNode)
            self2.element.parentNode.insertBefore(wrapper, self2.element);
          wrapper.appendChild(self2.element);
          if (self2.altInput)
            wrapper.appendChild(self2.altInput);
          wrapper.appendChild(self2.calendarContainer);
        }
      }
      if (!self2.config.static && !self2.config.inline)
        (self2.config.appendTo !== void 0 ? self2.config.appendTo : window.document.body).appendChild(self2.calendarContainer);
    }
    function createDay(className, date, _dayNumber, i) {
      var dateIsEnabled = isEnabled(date, true), dayElement = createElement("span", className, date.getDate().toString());
      dayElement.dateObj = date;
      dayElement.$i = i;
      dayElement.setAttribute("aria-label", self2.formatDate(date, self2.config.ariaDateFormat));
      if (className.indexOf("hidden") === -1 && compareDates(date, self2.now) === 0) {
        self2.todayDateElem = dayElement;
        dayElement.classList.add("today");
        dayElement.setAttribute("aria-current", "date");
      }
      if (dateIsEnabled) {
        dayElement.tabIndex = -1;
        if (isDateSelected(date)) {
          dayElement.classList.add("selected");
          self2.selectedDateElem = dayElement;
          if (self2.config.mode === "range") {
            toggleClass(dayElement, "startRange", self2.selectedDates[0] && compareDates(date, self2.selectedDates[0], true) === 0);
            toggleClass(dayElement, "endRange", self2.selectedDates[1] && compareDates(date, self2.selectedDates[1], true) === 0);
            if (className === "nextMonthDay")
              dayElement.classList.add("inRange");
          }
        }
      } else {
        dayElement.classList.add("flatpickr-disabled");
      }
      if (self2.config.mode === "range") {
        if (isDateInRange(date) && !isDateSelected(date))
          dayElement.classList.add("inRange");
      }
      if (self2.weekNumbers && self2.config.showMonths === 1 && className !== "prevMonthDay" && i % 7 === 6) {
        self2.weekNumbers.insertAdjacentHTML("beforeend", "<span class='flatpickr-day'>" + self2.config.getWeek(date) + "</span>");
      }
      triggerEvent("onDayCreate", dayElement);
      return dayElement;
    }
    function focusOnDayElem(targetNode) {
      targetNode.focus();
      if (self2.config.mode === "range")
        onMouseOver(targetNode);
    }
    function getFirstAvailableDay(delta) {
      var startMonth = delta > 0 ? 0 : self2.config.showMonths - 1;
      var endMonth = delta > 0 ? self2.config.showMonths : -1;
      for (var m = startMonth; m != endMonth; m += delta) {
        var month = self2.daysContainer.children[m];
        var startIndex = delta > 0 ? 0 : month.children.length - 1;
        var endIndex = delta > 0 ? month.children.length : -1;
        for (var i = startIndex; i != endIndex; i += delta) {
          var c = month.children[i];
          if (c.className.indexOf("hidden") === -1 && isEnabled(c.dateObj))
            return c;
        }
      }
      return void 0;
    }
    function getNextAvailableDay(current, delta) {
      var givenMonth = current.className.indexOf("Month") === -1 ? current.dateObj.getMonth() : self2.currentMonth;
      var endMonth = delta > 0 ? self2.config.showMonths : -1;
      var loopDelta = delta > 0 ? 1 : -1;
      for (var m = givenMonth - self2.currentMonth; m != endMonth; m += loopDelta) {
        var month = self2.daysContainer.children[m];
        var startIndex = givenMonth - self2.currentMonth === m ? current.$i + delta : delta < 0 ? month.children.length - 1 : 0;
        var numMonthDays = month.children.length;
        for (var i = startIndex; i >= 0 && i < numMonthDays && i != (delta > 0 ? numMonthDays : -1); i += loopDelta) {
          var c = month.children[i];
          if (c.className.indexOf("hidden") === -1 && isEnabled(c.dateObj) && Math.abs(current.$i - i) >= Math.abs(delta))
            return focusOnDayElem(c);
        }
      }
      self2.changeMonth(loopDelta);
      focusOnDay(getFirstAvailableDay(loopDelta), 0);
      return void 0;
    }
    function focusOnDay(current, offset2) {
      var activeElement = getClosestActiveElement();
      var dayFocused = isInView(activeElement || document.body);
      var startElem = current !== void 0 ? current : dayFocused ? activeElement : self2.selectedDateElem !== void 0 && isInView(self2.selectedDateElem) ? self2.selectedDateElem : self2.todayDateElem !== void 0 && isInView(self2.todayDateElem) ? self2.todayDateElem : getFirstAvailableDay(offset2 > 0 ? 1 : -1);
      if (startElem === void 0) {
        self2._input.focus();
      } else if (!dayFocused) {
        focusOnDayElem(startElem);
      } else {
        getNextAvailableDay(startElem, offset2);
      }
    }
    function buildMonthDays(year, month) {
      var firstOfMonth = (new Date(year, month, 1).getDay() - self2.l10n.firstDayOfWeek + 7) % 7;
      var prevMonthDays = self2.utils.getDaysInMonth((month - 1 + 12) % 12, year);
      var daysInMonth = self2.utils.getDaysInMonth(month, year), days = window.document.createDocumentFragment(), isMultiMonth = self2.config.showMonths > 1, prevMonthDayClass = isMultiMonth ? "prevMonthDay hidden" : "prevMonthDay", nextMonthDayClass = isMultiMonth ? "nextMonthDay hidden" : "nextMonthDay";
      var dayNumber = prevMonthDays + 1 - firstOfMonth, dayIndex = 0;
      for (; dayNumber <= prevMonthDays; dayNumber++, dayIndex++) {
        days.appendChild(createDay("flatpickr-day " + prevMonthDayClass, new Date(year, month - 1, dayNumber), dayNumber, dayIndex));
      }
      for (dayNumber = 1; dayNumber <= daysInMonth; dayNumber++, dayIndex++) {
        days.appendChild(createDay("flatpickr-day", new Date(year, month, dayNumber), dayNumber, dayIndex));
      }
      for (var dayNum = daysInMonth + 1; dayNum <= 42 - firstOfMonth && (self2.config.showMonths === 1 || dayIndex % 7 !== 0); dayNum++, dayIndex++) {
        days.appendChild(createDay("flatpickr-day " + nextMonthDayClass, new Date(year, month + 1, dayNum % daysInMonth), dayNum, dayIndex));
      }
      var dayContainer = createElement("div", "dayContainer");
      dayContainer.appendChild(days);
      return dayContainer;
    }
    function buildDays() {
      if (self2.daysContainer === void 0) {
        return;
      }
      clearNode(self2.daysContainer);
      if (self2.weekNumbers)
        clearNode(self2.weekNumbers);
      var frag = document.createDocumentFragment();
      for (var i = 0; i < self2.config.showMonths; i++) {
        var d = new Date(self2.currentYear, self2.currentMonth, 1);
        d.setMonth(self2.currentMonth + i);
        frag.appendChild(buildMonthDays(d.getFullYear(), d.getMonth()));
      }
      self2.daysContainer.appendChild(frag);
      self2.days = self2.daysContainer.firstChild;
      if (self2.config.mode === "range" && self2.selectedDates.length === 1) {
        onMouseOver();
      }
    }
    function buildMonthSwitch() {
      if (self2.config.showMonths > 1 || self2.config.monthSelectorType !== "dropdown")
        return;
      var shouldBuildMonth = function(month2) {
        if (self2.config.minDate !== void 0 && self2.currentYear === self2.config.minDate.getFullYear() && month2 < self2.config.minDate.getMonth()) {
          return false;
        }
        return !(self2.config.maxDate !== void 0 && self2.currentYear === self2.config.maxDate.getFullYear() && month2 > self2.config.maxDate.getMonth());
      };
      self2.monthsDropdownContainer.tabIndex = -1;
      self2.monthsDropdownContainer.innerHTML = "";
      for (var i = 0; i < 12; i++) {
        if (!shouldBuildMonth(i))
          continue;
        var month = createElement("option", "flatpickr-monthDropdown-month");
        month.value = new Date(self2.currentYear, i).getMonth().toString();
        month.textContent = monthToStr(i, self2.config.shorthandCurrentMonth, self2.l10n);
        month.tabIndex = -1;
        if (self2.currentMonth === i) {
          month.selected = true;
        }
        self2.monthsDropdownContainer.appendChild(month);
      }
    }
    function buildMonth() {
      var container = createElement("div", "flatpickr-month");
      var monthNavFragment = window.document.createDocumentFragment();
      var monthElement;
      if (self2.config.showMonths > 1 || self2.config.monthSelectorType === "static") {
        monthElement = createElement("span", "cur-month");
      } else {
        self2.monthsDropdownContainer = createElement("select", "flatpickr-monthDropdown-months");
        self2.monthsDropdownContainer.setAttribute("aria-label", self2.l10n.monthAriaLabel);
        bind(self2.monthsDropdownContainer, "change", function(e) {
          var target = getEventTarget(e);
          var selectedMonth = parseInt(target.value, 10);
          self2.changeMonth(selectedMonth - self2.currentMonth);
          triggerEvent("onMonthChange");
        });
        buildMonthSwitch();
        monthElement = self2.monthsDropdownContainer;
      }
      var yearInput = createNumberInput("cur-year", { tabindex: "-1" });
      var yearElement = yearInput.getElementsByTagName("input")[0];
      yearElement.setAttribute("aria-label", self2.l10n.yearAriaLabel);
      if (self2.config.minDate) {
        yearElement.setAttribute("min", self2.config.minDate.getFullYear().toString());
      }
      if (self2.config.maxDate) {
        yearElement.setAttribute("max", self2.config.maxDate.getFullYear().toString());
        yearElement.disabled = !!self2.config.minDate && self2.config.minDate.getFullYear() === self2.config.maxDate.getFullYear();
      }
      var currentMonth = createElement("div", "flatpickr-current-month");
      currentMonth.appendChild(monthElement);
      currentMonth.appendChild(yearInput);
      monthNavFragment.appendChild(currentMonth);
      container.appendChild(monthNavFragment);
      return {
        container,
        yearElement,
        monthElement
      };
    }
    function buildMonths() {
      clearNode(self2.monthNav);
      self2.monthNav.appendChild(self2.prevMonthNav);
      if (self2.config.showMonths) {
        self2.yearElements = [];
        self2.monthElements = [];
      }
      for (var m = self2.config.showMonths; m--; ) {
        var month = buildMonth();
        self2.yearElements.push(month.yearElement);
        self2.monthElements.push(month.monthElement);
        self2.monthNav.appendChild(month.container);
      }
      self2.monthNav.appendChild(self2.nextMonthNav);
    }
    function buildMonthNav() {
      self2.monthNav = createElement("div", "flatpickr-months");
      self2.yearElements = [];
      self2.monthElements = [];
      self2.prevMonthNav = createElement("span", "flatpickr-prev-month");
      self2.prevMonthNav.innerHTML = self2.config.prevArrow;
      self2.nextMonthNav = createElement("span", "flatpickr-next-month");
      self2.nextMonthNav.innerHTML = self2.config.nextArrow;
      buildMonths();
      Object.defineProperty(self2, "_hidePrevMonthArrow", {
        get: function() {
          return self2.__hidePrevMonthArrow;
        },
        set: function(bool) {
          if (self2.__hidePrevMonthArrow !== bool) {
            toggleClass(self2.prevMonthNav, "flatpickr-disabled", bool);
            self2.__hidePrevMonthArrow = bool;
          }
        }
      });
      Object.defineProperty(self2, "_hideNextMonthArrow", {
        get: function() {
          return self2.__hideNextMonthArrow;
        },
        set: function(bool) {
          if (self2.__hideNextMonthArrow !== bool) {
            toggleClass(self2.nextMonthNav, "flatpickr-disabled", bool);
            self2.__hideNextMonthArrow = bool;
          }
        }
      });
      self2.currentYearElement = self2.yearElements[0];
      updateNavigationCurrentMonth();
      return self2.monthNav;
    }
    function buildTime() {
      self2.calendarContainer.classList.add("hasTime");
      if (self2.config.noCalendar)
        self2.calendarContainer.classList.add("noCalendar");
      var defaults2 = getDefaultHours(self2.config);
      self2.timeContainer = createElement("div", "flatpickr-time");
      self2.timeContainer.tabIndex = -1;
      var separator = createElement("span", "flatpickr-time-separator", ":");
      var hourInput = createNumberInput("flatpickr-hour", {
        "aria-label": self2.l10n.hourAriaLabel
      });
      self2.hourElement = hourInput.getElementsByTagName("input")[0];
      var minuteInput = createNumberInput("flatpickr-minute", {
        "aria-label": self2.l10n.minuteAriaLabel
      });
      self2.minuteElement = minuteInput.getElementsByTagName("input")[0];
      self2.hourElement.tabIndex = self2.minuteElement.tabIndex = -1;
      self2.hourElement.value = pad(self2.latestSelectedDateObj ? self2.latestSelectedDateObj.getHours() : self2.config.time_24hr ? defaults2.hours : military2ampm(defaults2.hours));
      self2.minuteElement.value = pad(self2.latestSelectedDateObj ? self2.latestSelectedDateObj.getMinutes() : defaults2.minutes);
      self2.hourElement.setAttribute("step", self2.config.hourIncrement.toString());
      self2.minuteElement.setAttribute("step", self2.config.minuteIncrement.toString());
      self2.hourElement.setAttribute("min", self2.config.time_24hr ? "0" : "1");
      self2.hourElement.setAttribute("max", self2.config.time_24hr ? "23" : "12");
      self2.hourElement.setAttribute("maxlength", "2");
      self2.minuteElement.setAttribute("min", "0");
      self2.minuteElement.setAttribute("max", "59");
      self2.minuteElement.setAttribute("maxlength", "2");
      self2.timeContainer.appendChild(hourInput);
      self2.timeContainer.appendChild(separator);
      self2.timeContainer.appendChild(minuteInput);
      if (self2.config.time_24hr)
        self2.timeContainer.classList.add("time24hr");
      if (self2.config.enableSeconds) {
        self2.timeContainer.classList.add("hasSeconds");
        var secondInput = createNumberInput("flatpickr-second");
        self2.secondElement = secondInput.getElementsByTagName("input")[0];
        self2.secondElement.value = pad(self2.latestSelectedDateObj ? self2.latestSelectedDateObj.getSeconds() : defaults2.seconds);
        self2.secondElement.setAttribute("step", self2.minuteElement.getAttribute("step"));
        self2.secondElement.setAttribute("min", "0");
        self2.secondElement.setAttribute("max", "59");
        self2.secondElement.setAttribute("maxlength", "2");
        self2.timeContainer.appendChild(createElement("span", "flatpickr-time-separator", ":"));
        self2.timeContainer.appendChild(secondInput);
      }
      if (!self2.config.time_24hr) {
        self2.amPM = createElement("span", "flatpickr-am-pm", self2.l10n.amPM[int((self2.latestSelectedDateObj ? self2.hourElement.value : self2.config.defaultHour) > 11)]);
        self2.amPM.title = self2.l10n.toggleTitle;
        self2.amPM.tabIndex = -1;
        self2.timeContainer.appendChild(self2.amPM);
      }
      return self2.timeContainer;
    }
    function buildWeekdays() {
      if (!self2.weekdayContainer)
        self2.weekdayContainer = createElement("div", "flatpickr-weekdays");
      else
        clearNode(self2.weekdayContainer);
      for (var i = self2.config.showMonths; i--; ) {
        var container = createElement("div", "flatpickr-weekdaycontainer");
        self2.weekdayContainer.appendChild(container);
      }
      updateWeekdays();
      return self2.weekdayContainer;
    }
    function updateWeekdays() {
      if (!self2.weekdayContainer) {
        return;
      }
      var firstDayOfWeek = self2.l10n.firstDayOfWeek;
      var weekdays = __spreadArrays(self2.l10n.weekdays.shorthand);
      if (firstDayOfWeek > 0 && firstDayOfWeek < weekdays.length) {
        weekdays = __spreadArrays(weekdays.splice(firstDayOfWeek, weekdays.length), weekdays.splice(0, firstDayOfWeek));
      }
      for (var i = self2.config.showMonths; i--; ) {
        self2.weekdayContainer.children[i].innerHTML = "\n      <span class='flatpickr-weekday'>\n        " + weekdays.join("</span><span class='flatpickr-weekday'>") + "\n      </span>\n      ";
      }
    }
    function buildWeeks() {
      self2.calendarContainer.classList.add("hasWeeks");
      var weekWrapper = createElement("div", "flatpickr-weekwrapper");
      weekWrapper.appendChild(createElement("span", "flatpickr-weekday", self2.l10n.weekAbbreviation));
      var weekNumbers = createElement("div", "flatpickr-weeks");
      weekWrapper.appendChild(weekNumbers);
      return {
        weekWrapper,
        weekNumbers
      };
    }
    function changeMonth(value, isOffset) {
      if (isOffset === void 0) {
        isOffset = true;
      }
      var delta = isOffset ? value : value - self2.currentMonth;
      if (delta < 0 && self2._hidePrevMonthArrow === true || delta > 0 && self2._hideNextMonthArrow === true)
        return;
      self2.currentMonth += delta;
      if (self2.currentMonth < 0 || self2.currentMonth > 11) {
        self2.currentYear += self2.currentMonth > 11 ? 1 : -1;
        self2.currentMonth = (self2.currentMonth + 12) % 12;
        triggerEvent("onYearChange");
        buildMonthSwitch();
      }
      buildDays();
      triggerEvent("onMonthChange");
      updateNavigationCurrentMonth();
    }
    function clear(triggerChangeEvent, toInitial) {
      if (triggerChangeEvent === void 0) {
        triggerChangeEvent = true;
      }
      if (toInitial === void 0) {
        toInitial = true;
      }
      self2.input.value = "";
      if (self2.altInput !== void 0)
        self2.altInput.value = "";
      if (self2.mobileInput !== void 0)
        self2.mobileInput.value = "";
      self2.selectedDates = [];
      self2.latestSelectedDateObj = void 0;
      if (toInitial === true) {
        self2.currentYear = self2._initialDate.getFullYear();
        self2.currentMonth = self2._initialDate.getMonth();
      }
      if (self2.config.enableTime === true) {
        var _a = getDefaultHours(self2.config), hours = _a.hours, minutes = _a.minutes, seconds = _a.seconds;
        setHours(hours, minutes, seconds);
      }
      self2.redraw();
      if (triggerChangeEvent)
        triggerEvent("onChange");
    }
    function close() {
      self2.isOpen = false;
      if (!self2.isMobile) {
        if (self2.calendarContainer !== void 0) {
          self2.calendarContainer.classList.remove("open");
        }
        if (self2._input !== void 0) {
          self2._input.classList.remove("active");
        }
      }
      triggerEvent("onClose");
    }
    function destroy() {
      if (self2.config !== void 0)
        triggerEvent("onDestroy");
      for (var i = self2._handlers.length; i--; ) {
        self2._handlers[i].remove();
      }
      self2._handlers = [];
      if (self2.mobileInput) {
        if (self2.mobileInput.parentNode)
          self2.mobileInput.parentNode.removeChild(self2.mobileInput);
        self2.mobileInput = void 0;
      } else if (self2.calendarContainer && self2.calendarContainer.parentNode) {
        if (self2.config.static && self2.calendarContainer.parentNode) {
          var wrapper = self2.calendarContainer.parentNode;
          wrapper.lastChild && wrapper.removeChild(wrapper.lastChild);
          if (wrapper.parentNode) {
            while (wrapper.firstChild)
              wrapper.parentNode.insertBefore(wrapper.firstChild, wrapper);
            wrapper.parentNode.removeChild(wrapper);
          }
        } else
          self2.calendarContainer.parentNode.removeChild(self2.calendarContainer);
      }
      if (self2.altInput) {
        self2.input.type = "text";
        if (self2.altInput.parentNode)
          self2.altInput.parentNode.removeChild(self2.altInput);
        delete self2.altInput;
      }
      if (self2.input) {
        self2.input.type = self2.input._type;
        self2.input.classList.remove("flatpickr-input");
        self2.input.removeAttribute("readonly");
      }
      [
        "_showTimeInput",
        "latestSelectedDateObj",
        "_hideNextMonthArrow",
        "_hidePrevMonthArrow",
        "__hideNextMonthArrow",
        "__hidePrevMonthArrow",
        "isMobile",
        "isOpen",
        "selectedDateElem",
        "minDateHasTime",
        "maxDateHasTime",
        "days",
        "daysContainer",
        "_input",
        "_positionElement",
        "innerContainer",
        "rContainer",
        "monthNav",
        "todayDateElem",
        "calendarContainer",
        "weekdayContainer",
        "prevMonthNav",
        "nextMonthNav",
        "monthsDropdownContainer",
        "currentMonthElement",
        "currentYearElement",
        "navigationCurrentMonth",
        "selectedDateElem",
        "config"
      ].forEach(function(k) {
        try {
          delete self2[k];
        } catch (_) {
        }
      });
    }
    function isCalendarElem(elem) {
      return self2.calendarContainer.contains(elem);
    }
    function documentClick(e) {
      if (self2.isOpen && !self2.config.inline) {
        var eventTarget_1 = getEventTarget(e);
        var isCalendarElement = isCalendarElem(eventTarget_1);
        var isInput = eventTarget_1 === self2.input || eventTarget_1 === self2.altInput || self2.element.contains(eventTarget_1) || e.path && e.path.indexOf && (~e.path.indexOf(self2.input) || ~e.path.indexOf(self2.altInput));
        var lostFocus = !isInput && !isCalendarElement && !isCalendarElem(e.relatedTarget);
        var isIgnored = !self2.config.ignoredFocusElements.some(function(elem) {
          return elem.contains(eventTarget_1);
        });
        if (lostFocus && isIgnored) {
          if (self2.config.allowInput) {
            self2.setDate(self2._input.value, false, self2.config.altInput ? self2.config.altFormat : self2.config.dateFormat);
          }
          if (self2.timeContainer !== void 0 && self2.minuteElement !== void 0 && self2.hourElement !== void 0 && self2.input.value !== "" && self2.input.value !== void 0) {
            updateTime();
          }
          self2.close();
          if (self2.config && self2.config.mode === "range" && self2.selectedDates.length === 1)
            self2.clear(false);
        }
      }
    }
    function changeYear(newYear) {
      if (!newYear || self2.config.minDate && newYear < self2.config.minDate.getFullYear() || self2.config.maxDate && newYear > self2.config.maxDate.getFullYear())
        return;
      var newYearNum = newYear, isNewYear = self2.currentYear !== newYearNum;
      self2.currentYear = newYearNum || self2.currentYear;
      if (self2.config.maxDate && self2.currentYear === self2.config.maxDate.getFullYear()) {
        self2.currentMonth = Math.min(self2.config.maxDate.getMonth(), self2.currentMonth);
      } else if (self2.config.minDate && self2.currentYear === self2.config.minDate.getFullYear()) {
        self2.currentMonth = Math.max(self2.config.minDate.getMonth(), self2.currentMonth);
      }
      if (isNewYear) {
        self2.redraw();
        triggerEvent("onYearChange");
        buildMonthSwitch();
      }
    }
    function isEnabled(date, timeless) {
      var _a;
      if (timeless === void 0) {
        timeless = true;
      }
      var dateToCheck = self2.parseDate(date, void 0, timeless);
      if (self2.config.minDate && dateToCheck && compareDates(dateToCheck, self2.config.minDate, timeless !== void 0 ? timeless : !self2.minDateHasTime) < 0 || self2.config.maxDate && dateToCheck && compareDates(dateToCheck, self2.config.maxDate, timeless !== void 0 ? timeless : !self2.maxDateHasTime) > 0)
        return false;
      if (!self2.config.enable && self2.config.disable.length === 0)
        return true;
      if (dateToCheck === void 0)
        return false;
      var bool = !!self2.config.enable, array = (_a = self2.config.enable) !== null && _a !== void 0 ? _a : self2.config.disable;
      for (var i = 0, d = void 0; i < array.length; i++) {
        d = array[i];
        if (typeof d === "function" && d(dateToCheck))
          return bool;
        else if (d instanceof Date && dateToCheck !== void 0 && d.getTime() === dateToCheck.getTime())
          return bool;
        else if (typeof d === "string") {
          var parsed = self2.parseDate(d, void 0, true);
          return parsed && parsed.getTime() === dateToCheck.getTime() ? bool : !bool;
        } else if (typeof d === "object" && dateToCheck !== void 0 && d.from && d.to && dateToCheck.getTime() >= d.from.getTime() && dateToCheck.getTime() <= d.to.getTime())
          return bool;
      }
      return !bool;
    }
    function isInView(elem) {
      if (self2.daysContainer !== void 0)
        return elem.className.indexOf("hidden") === -1 && elem.className.indexOf("flatpickr-disabled") === -1 && self2.daysContainer.contains(elem);
      return false;
    }
    function onBlur(e) {
      var isInput = e.target === self2._input;
      var valueChanged = self2._input.value.trimEnd() !== getDateStr();
      if (isInput && valueChanged && !(e.relatedTarget && isCalendarElem(e.relatedTarget))) {
        self2.setDate(self2._input.value, true, e.target === self2.altInput ? self2.config.altFormat : self2.config.dateFormat);
      }
    }
    function onKeyDown(e) {
      var eventTarget = getEventTarget(e);
      var isInput = self2.config.wrap ? element.contains(eventTarget) : eventTarget === self2._input;
      var allowInput = self2.config.allowInput;
      var allowKeydown = self2.isOpen && (!allowInput || !isInput);
      var allowInlineKeydown = self2.config.inline && isInput && !allowInput;
      if (e.keyCode === 13 && isInput) {
        if (allowInput) {
          self2.setDate(self2._input.value, true, eventTarget === self2.altInput ? self2.config.altFormat : self2.config.dateFormat);
          self2.close();
          return eventTarget.blur();
        } else {
          self2.open();
        }
      } else if (isCalendarElem(eventTarget) || allowKeydown || allowInlineKeydown) {
        var isTimeObj = !!self2.timeContainer && self2.timeContainer.contains(eventTarget);
        switch (e.keyCode) {
          case 13:
            if (isTimeObj) {
              e.preventDefault();
              updateTime();
              focusAndClose();
            } else
              selectDate(e);
            break;
          case 27:
            e.preventDefault();
            focusAndClose();
            break;
          case 8:
          case 46:
            if (isInput && !self2.config.allowInput) {
              e.preventDefault();
              self2.clear();
            }
            break;
          case 37:
          case 39:
            if (!isTimeObj && !isInput) {
              e.preventDefault();
              var activeElement = getClosestActiveElement();
              if (self2.daysContainer !== void 0 && (allowInput === false || activeElement && isInView(activeElement))) {
                var delta_1 = e.keyCode === 39 ? 1 : -1;
                if (!e.ctrlKey)
                  focusOnDay(void 0, delta_1);
                else {
                  e.stopPropagation();
                  changeMonth(delta_1);
                  focusOnDay(getFirstAvailableDay(1), 0);
                }
              }
            } else if (self2.hourElement)
              self2.hourElement.focus();
            break;
          case 38:
          case 40:
            e.preventDefault();
            var delta = e.keyCode === 40 ? 1 : -1;
            if (self2.daysContainer && eventTarget.$i !== void 0 || eventTarget === self2.input || eventTarget === self2.altInput) {
              if (e.ctrlKey) {
                e.stopPropagation();
                changeYear(self2.currentYear - delta);
                focusOnDay(getFirstAvailableDay(1), 0);
              } else if (!isTimeObj)
                focusOnDay(void 0, delta * 7);
            } else if (eventTarget === self2.currentYearElement) {
              changeYear(self2.currentYear - delta);
            } else if (self2.config.enableTime) {
              if (!isTimeObj && self2.hourElement)
                self2.hourElement.focus();
              updateTime(e);
              self2._debouncedChange();
            }
            break;
          case 9:
            if (isTimeObj) {
              var elems = [
                self2.hourElement,
                self2.minuteElement,
                self2.secondElement,
                self2.amPM
              ].concat(self2.pluginElements).filter(function(x) {
                return x;
              });
              var i = elems.indexOf(eventTarget);
              if (i !== -1) {
                var target = elems[i + (e.shiftKey ? -1 : 1)];
                e.preventDefault();
                (target || self2._input).focus();
              }
            } else if (!self2.config.noCalendar && self2.daysContainer && self2.daysContainer.contains(eventTarget) && e.shiftKey) {
              e.preventDefault();
              self2._input.focus();
            }
            break;
          default:
            break;
        }
      }
      if (self2.amPM !== void 0 && eventTarget === self2.amPM) {
        switch (e.key) {
          case self2.l10n.amPM[0].charAt(0):
          case self2.l10n.amPM[0].charAt(0).toLowerCase():
            self2.amPM.textContent = self2.l10n.amPM[0];
            setHoursFromInputs();
            updateValue();
            break;
          case self2.l10n.amPM[1].charAt(0):
          case self2.l10n.amPM[1].charAt(0).toLowerCase():
            self2.amPM.textContent = self2.l10n.amPM[1];
            setHoursFromInputs();
            updateValue();
            break;
        }
      }
      if (isInput || isCalendarElem(eventTarget)) {
        triggerEvent("onKeyDown", e);
      }
    }
    function onMouseOver(elem, cellClass) {
      if (cellClass === void 0) {
        cellClass = "flatpickr-day";
      }
      if (self2.selectedDates.length !== 1 || elem && (!elem.classList.contains(cellClass) || elem.classList.contains("flatpickr-disabled")))
        return;
      var hoverDate = elem ? elem.dateObj.getTime() : self2.days.firstElementChild.dateObj.getTime(), initialDate = self2.parseDate(self2.selectedDates[0], void 0, true).getTime(), rangeStartDate = Math.min(hoverDate, self2.selectedDates[0].getTime()), rangeEndDate = Math.max(hoverDate, self2.selectedDates[0].getTime());
      var containsDisabled = false;
      var minRange = 0, maxRange = 0;
      for (var t = rangeStartDate; t < rangeEndDate; t += duration.DAY) {
        if (!isEnabled(new Date(t), true)) {
          containsDisabled = containsDisabled || t > rangeStartDate && t < rangeEndDate;
          if (t < initialDate && (!minRange || t > minRange))
            minRange = t;
          else if (t > initialDate && (!maxRange || t < maxRange))
            maxRange = t;
        }
      }
      var hoverableCells = Array.from(self2.rContainer.querySelectorAll("*:nth-child(-n+" + self2.config.showMonths + ") > ." + cellClass));
      hoverableCells.forEach(function(dayElem) {
        var date = dayElem.dateObj;
        var timestamp = date.getTime();
        var outOfRange = minRange > 0 && timestamp < minRange || maxRange > 0 && timestamp > maxRange;
        if (outOfRange) {
          dayElem.classList.add("notAllowed");
          ["inRange", "startRange", "endRange"].forEach(function(c) {
            dayElem.classList.remove(c);
          });
          return;
        } else if (containsDisabled && !outOfRange)
          return;
        ["startRange", "inRange", "endRange", "notAllowed"].forEach(function(c) {
          dayElem.classList.remove(c);
        });
        if (elem !== void 0) {
          elem.classList.add(hoverDate <= self2.selectedDates[0].getTime() ? "startRange" : "endRange");
          if (initialDate < hoverDate && timestamp === initialDate)
            dayElem.classList.add("startRange");
          else if (initialDate > hoverDate && timestamp === initialDate)
            dayElem.classList.add("endRange");
          if (timestamp >= minRange && (maxRange === 0 || timestamp <= maxRange) && isBetween(timestamp, initialDate, hoverDate))
            dayElem.classList.add("inRange");
        }
      });
    }
    function onResize() {
      if (self2.isOpen && !self2.config.static && !self2.config.inline)
        positionCalendar();
    }
    function open(e, positionElement) {
      if (positionElement === void 0) {
        positionElement = self2._positionElement;
      }
      if (self2.isMobile === true) {
        if (e) {
          e.preventDefault();
          var eventTarget = getEventTarget(e);
          if (eventTarget) {
            eventTarget.blur();
          }
        }
        if (self2.mobileInput !== void 0) {
          self2.mobileInput.focus();
          self2.mobileInput.click();
        }
        triggerEvent("onOpen");
        return;
      } else if (self2._input.disabled || self2.config.inline) {
        return;
      }
      var wasOpen = self2.isOpen;
      self2.isOpen = true;
      if (!wasOpen) {
        self2.calendarContainer.classList.add("open");
        self2._input.classList.add("active");
        triggerEvent("onOpen");
        positionCalendar(positionElement);
      }
      if (self2.config.enableTime === true && self2.config.noCalendar === true) {
        if (self2.config.allowInput === false && (e === void 0 || !self2.timeContainer.contains(e.relatedTarget))) {
          setTimeout(function() {
            return self2.hourElement.select();
          }, 50);
        }
      }
    }
    function minMaxDateSetter(type) {
      return function(date) {
        var dateObj = self2.config["_" + type + "Date"] = self2.parseDate(date, self2.config.dateFormat);
        var inverseDateObj = self2.config["_" + (type === "min" ? "max" : "min") + "Date"];
        if (dateObj !== void 0) {
          self2[type === "min" ? "minDateHasTime" : "maxDateHasTime"] = dateObj.getHours() > 0 || dateObj.getMinutes() > 0 || dateObj.getSeconds() > 0;
        }
        if (self2.selectedDates) {
          self2.selectedDates = self2.selectedDates.filter(function(d) {
            return isEnabled(d);
          });
          if (!self2.selectedDates.length && type === "min")
            setHoursFromDate(dateObj);
          updateValue();
        }
        if (self2.daysContainer) {
          redraw();
          if (dateObj !== void 0)
            self2.currentYearElement[type] = dateObj.getFullYear().toString();
          else
            self2.currentYearElement.removeAttribute(type);
          self2.currentYearElement.disabled = !!inverseDateObj && dateObj !== void 0 && inverseDateObj.getFullYear() === dateObj.getFullYear();
        }
      };
    }
    function parseConfig() {
      var boolOpts = [
        "wrap",
        "weekNumbers",
        "allowInput",
        "allowInvalidPreload",
        "clickOpens",
        "time_24hr",
        "enableTime",
        "noCalendar",
        "altInput",
        "shorthandCurrentMonth",
        "inline",
        "static",
        "enableSeconds",
        "disableMobile"
      ];
      var userConfig = __assign(__assign({}, JSON.parse(JSON.stringify(element.dataset || {}))), instanceConfig);
      var formats2 = {};
      self2.config.parseDate = userConfig.parseDate;
      self2.config.formatDate = userConfig.formatDate;
      Object.defineProperty(self2.config, "enable", {
        get: function() {
          return self2.config._enable;
        },
        set: function(dates) {
          self2.config._enable = parseDateRules(dates);
        }
      });
      Object.defineProperty(self2.config, "disable", {
        get: function() {
          return self2.config._disable;
        },
        set: function(dates) {
          self2.config._disable = parseDateRules(dates);
        }
      });
      var timeMode = userConfig.mode === "time";
      if (!userConfig.dateFormat && (userConfig.enableTime || timeMode)) {
        var defaultDateFormat = flatpickr.defaultConfig.dateFormat || defaults.dateFormat;
        formats2.dateFormat = userConfig.noCalendar || timeMode ? "H:i" + (userConfig.enableSeconds ? ":S" : "") : defaultDateFormat + " H:i" + (userConfig.enableSeconds ? ":S" : "");
      }
      if (userConfig.altInput && (userConfig.enableTime || timeMode) && !userConfig.altFormat) {
        var defaultAltFormat = flatpickr.defaultConfig.altFormat || defaults.altFormat;
        formats2.altFormat = userConfig.noCalendar || timeMode ? "h:i" + (userConfig.enableSeconds ? ":S K" : " K") : defaultAltFormat + (" h:i" + (userConfig.enableSeconds ? ":S" : "") + " K");
      }
      Object.defineProperty(self2.config, "minDate", {
        get: function() {
          return self2.config._minDate;
        },
        set: minMaxDateSetter("min")
      });
      Object.defineProperty(self2.config, "maxDate", {
        get: function() {
          return self2.config._maxDate;
        },
        set: minMaxDateSetter("max")
      });
      var minMaxTimeSetter = function(type) {
        return function(val) {
          self2.config[type === "min" ? "_minTime" : "_maxTime"] = self2.parseDate(val, "H:i:S");
        };
      };
      Object.defineProperty(self2.config, "minTime", {
        get: function() {
          return self2.config._minTime;
        },
        set: minMaxTimeSetter("min")
      });
      Object.defineProperty(self2.config, "maxTime", {
        get: function() {
          return self2.config._maxTime;
        },
        set: minMaxTimeSetter("max")
      });
      if (userConfig.mode === "time") {
        self2.config.noCalendar = true;
        self2.config.enableTime = true;
      }
      Object.assign(self2.config, formats2, userConfig);
      for (var i = 0; i < boolOpts.length; i++)
        self2.config[boolOpts[i]] = self2.config[boolOpts[i]] === true || self2.config[boolOpts[i]] === "true";
      HOOKS.filter(function(hook) {
        return self2.config[hook] !== void 0;
      }).forEach(function(hook) {
        self2.config[hook] = arrayify(self2.config[hook] || []).map(bindToInstance);
      });
      self2.isMobile = !self2.config.disableMobile && !self2.config.inline && self2.config.mode === "single" && !self2.config.disable.length && !self2.config.enable && !self2.config.weekNumbers && /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
      for (var i = 0; i < self2.config.plugins.length; i++) {
        var pluginConf = self2.config.plugins[i](self2) || {};
        for (var key in pluginConf) {
          if (HOOKS.indexOf(key) > -1) {
            self2.config[key] = arrayify(pluginConf[key]).map(bindToInstance).concat(self2.config[key]);
          } else if (typeof userConfig[key] === "undefined")
            self2.config[key] = pluginConf[key];
        }
      }
      if (!userConfig.altInputClass) {
        self2.config.altInputClass = getInputElem().className + " " + self2.config.altInputClass;
      }
      triggerEvent("onParseConfig");
    }
    function getInputElem() {
      return self2.config.wrap ? element.querySelector("[data-input]") : element;
    }
    function setupLocale() {
      if (typeof self2.config.locale !== "object" && typeof flatpickr.l10ns[self2.config.locale] === "undefined")
        self2.config.errorHandler(new Error("flatpickr: invalid locale " + self2.config.locale));
      self2.l10n = __assign(__assign({}, flatpickr.l10ns.default), typeof self2.config.locale === "object" ? self2.config.locale : self2.config.locale !== "default" ? flatpickr.l10ns[self2.config.locale] : void 0);
      tokenRegex.D = "(" + self2.l10n.weekdays.shorthand.join("|") + ")";
      tokenRegex.l = "(" + self2.l10n.weekdays.longhand.join("|") + ")";
      tokenRegex.M = "(" + self2.l10n.months.shorthand.join("|") + ")";
      tokenRegex.F = "(" + self2.l10n.months.longhand.join("|") + ")";
      tokenRegex.K = "(" + self2.l10n.amPM[0] + "|" + self2.l10n.amPM[1] + "|" + self2.l10n.amPM[0].toLowerCase() + "|" + self2.l10n.amPM[1].toLowerCase() + ")";
      var userConfig = __assign(__assign({}, instanceConfig), JSON.parse(JSON.stringify(element.dataset || {})));
      if (userConfig.time_24hr === void 0 && flatpickr.defaultConfig.time_24hr === void 0) {
        self2.config.time_24hr = self2.l10n.time_24hr;
      }
      self2.formatDate = createDateFormatter(self2);
      self2.parseDate = createDateParser({ config: self2.config, l10n: self2.l10n });
    }
    function positionCalendar(customPositionElement) {
      if (typeof self2.config.position === "function") {
        return void self2.config.position(self2, customPositionElement);
      }
      if (self2.calendarContainer === void 0)
        return;
      triggerEvent("onPreCalendarPosition");
      var positionElement = customPositionElement || self2._positionElement;
      var calendarHeight = Array.prototype.reduce.call(self2.calendarContainer.children, function(acc, child) {
        return acc + child.offsetHeight;
      }, 0), calendarWidth = self2.calendarContainer.offsetWidth, configPos = self2.config.position.split(" "), configPosVertical = configPos[0], configPosHorizontal = configPos.length > 1 ? configPos[1] : null, inputBounds = positionElement.getBoundingClientRect(), distanceFromBottom = window.innerHeight - inputBounds.bottom, showOnTop = configPosVertical === "above" || configPosVertical !== "below" && distanceFromBottom < calendarHeight && inputBounds.top > calendarHeight;
      var top2 = window.pageYOffset + inputBounds.top + (!showOnTop ? positionElement.offsetHeight + 2 : -calendarHeight - 2);
      toggleClass(self2.calendarContainer, "arrowTop", !showOnTop);
      toggleClass(self2.calendarContainer, "arrowBottom", showOnTop);
      if (self2.config.inline)
        return;
      var left2 = window.pageXOffset + inputBounds.left;
      var isCenter = false;
      var isRight = false;
      if (configPosHorizontal === "center") {
        left2 -= (calendarWidth - inputBounds.width) / 2;
        isCenter = true;
      } else if (configPosHorizontal === "right") {
        left2 -= calendarWidth - inputBounds.width;
        isRight = true;
      }
      toggleClass(self2.calendarContainer, "arrowLeft", !isCenter && !isRight);
      toggleClass(self2.calendarContainer, "arrowCenter", isCenter);
      toggleClass(self2.calendarContainer, "arrowRight", isRight);
      var right2 = window.document.body.offsetWidth - (window.pageXOffset + inputBounds.right);
      var rightMost = left2 + calendarWidth > window.document.body.offsetWidth;
      var centerMost = right2 + calendarWidth > window.document.body.offsetWidth;
      toggleClass(self2.calendarContainer, "rightMost", rightMost);
      if (self2.config.static)
        return;
      self2.calendarContainer.style.top = top2 + "px";
      if (!rightMost) {
        self2.calendarContainer.style.left = left2 + "px";
        self2.calendarContainer.style.right = "auto";
      } else if (!centerMost) {
        self2.calendarContainer.style.left = "auto";
        self2.calendarContainer.style.right = right2 + "px";
      } else {
        var doc = getDocumentStyleSheet();
        if (doc === void 0)
          return;
        var bodyWidth = window.document.body.offsetWidth;
        var centerLeft = Math.max(0, bodyWidth / 2 - calendarWidth / 2);
        var centerBefore = ".flatpickr-calendar.centerMost:before";
        var centerAfter = ".flatpickr-calendar.centerMost:after";
        var centerIndex = doc.cssRules.length;
        var centerStyle = "{left:" + inputBounds.left + "px;right:auto;}";
        toggleClass(self2.calendarContainer, "rightMost", false);
        toggleClass(self2.calendarContainer, "centerMost", true);
        doc.insertRule(centerBefore + "," + centerAfter + centerStyle, centerIndex);
        self2.calendarContainer.style.left = centerLeft + "px";
        self2.calendarContainer.style.right = "auto";
      }
    }
    function getDocumentStyleSheet() {
      var editableSheet = null;
      for (var i = 0; i < document.styleSheets.length; i++) {
        var sheet = document.styleSheets[i];
        if (!sheet.cssRules)
          continue;
        try {
          sheet.cssRules;
        } catch (err) {
          continue;
        }
        editableSheet = sheet;
        break;
      }
      return editableSheet != null ? editableSheet : createStyleSheet();
    }
    function createStyleSheet() {
      var style = document.createElement("style");
      document.head.appendChild(style);
      return style.sheet;
    }
    function redraw() {
      if (self2.config.noCalendar || self2.isMobile)
        return;
      buildMonthSwitch();
      updateNavigationCurrentMonth();
      buildDays();
    }
    function focusAndClose() {
      self2._input.focus();
      if (window.navigator.userAgent.indexOf("MSIE") !== -1 || navigator.msMaxTouchPoints !== void 0) {
        setTimeout(self2.close, 0);
      } else {
        self2.close();
      }
    }
    function selectDate(e) {
      e.preventDefault();
      e.stopPropagation();
      var isSelectable = function(day) {
        return day.classList && day.classList.contains("flatpickr-day") && !day.classList.contains("flatpickr-disabled") && !day.classList.contains("notAllowed");
      };
      var t = findParent(getEventTarget(e), isSelectable);
      if (t === void 0)
        return;
      var target = t;
      var selectedDate = self2.latestSelectedDateObj = new Date(target.dateObj.getTime());
      var shouldChangeMonth = (selectedDate.getMonth() < self2.currentMonth || selectedDate.getMonth() > self2.currentMonth + self2.config.showMonths - 1) && self2.config.mode !== "range";
      self2.selectedDateElem = target;
      if (self2.config.mode === "single")
        self2.selectedDates = [selectedDate];
      else if (self2.config.mode === "multiple") {
        var selectedIndex = isDateSelected(selectedDate);
        if (selectedIndex)
          self2.selectedDates.splice(parseInt(selectedIndex), 1);
        else
          self2.selectedDates.push(selectedDate);
      } else if (self2.config.mode === "range") {
        if (self2.selectedDates.length === 2) {
          self2.clear(false, false);
        }
        self2.latestSelectedDateObj = selectedDate;
        self2.selectedDates.push(selectedDate);
        if (compareDates(selectedDate, self2.selectedDates[0], true) !== 0)
          self2.selectedDates.sort(function(a, b) {
            return a.getTime() - b.getTime();
          });
      }
      setHoursFromInputs();
      if (shouldChangeMonth) {
        var isNewYear = self2.currentYear !== selectedDate.getFullYear();
        self2.currentYear = selectedDate.getFullYear();
        self2.currentMonth = selectedDate.getMonth();
        if (isNewYear) {
          triggerEvent("onYearChange");
          buildMonthSwitch();
        }
        triggerEvent("onMonthChange");
      }
      updateNavigationCurrentMonth();
      buildDays();
      updateValue();
      if (!shouldChangeMonth && self2.config.mode !== "range" && self2.config.showMonths === 1)
        focusOnDayElem(target);
      else if (self2.selectedDateElem !== void 0 && self2.hourElement === void 0) {
        self2.selectedDateElem && self2.selectedDateElem.focus();
      }
      if (self2.hourElement !== void 0)
        self2.hourElement !== void 0 && self2.hourElement.focus();
      if (self2.config.closeOnSelect) {
        var single = self2.config.mode === "single" && !self2.config.enableTime;
        var range = self2.config.mode === "range" && self2.selectedDates.length === 2 && !self2.config.enableTime;
        if (single || range) {
          focusAndClose();
        }
      }
      triggerChange();
    }
    var CALLBACKS = {
      locale: [setupLocale, updateWeekdays],
      showMonths: [buildMonths, setCalendarWidth, buildWeekdays],
      minDate: [jumpToDate],
      maxDate: [jumpToDate],
      positionElement: [updatePositionElement],
      clickOpens: [
        function() {
          if (self2.config.clickOpens === true) {
            bind(self2._input, "focus", self2.open);
            bind(self2._input, "click", self2.open);
          } else {
            self2._input.removeEventListener("focus", self2.open);
            self2._input.removeEventListener("click", self2.open);
          }
        }
      ]
    };
    function set(option, value) {
      if (option !== null && typeof option === "object") {
        Object.assign(self2.config, option);
        for (var key in option) {
          if (CALLBACKS[key] !== void 0)
            CALLBACKS[key].forEach(function(x) {
              return x();
            });
        }
      } else {
        self2.config[option] = value;
        if (CALLBACKS[option] !== void 0)
          CALLBACKS[option].forEach(function(x) {
            return x();
          });
        else if (HOOKS.indexOf(option) > -1)
          self2.config[option] = arrayify(value);
      }
      self2.redraw();
      updateValue(true);
    }
    function setSelectedDate(inputDate, format) {
      var dates = [];
      if (inputDate instanceof Array)
        dates = inputDate.map(function(d) {
          return self2.parseDate(d, format);
        });
      else if (inputDate instanceof Date || typeof inputDate === "number")
        dates = [self2.parseDate(inputDate, format)];
      else if (typeof inputDate === "string") {
        switch (self2.config.mode) {
          case "single":
          case "time":
            dates = [self2.parseDate(inputDate, format)];
            break;
          case "multiple":
            dates = inputDate.split(self2.config.conjunction).map(function(date) {
              return self2.parseDate(date, format);
            });
            break;
          case "range":
            dates = inputDate.split(self2.l10n.rangeSeparator).map(function(date) {
              return self2.parseDate(date, format);
            });
            break;
          default:
            break;
        }
      } else
        self2.config.errorHandler(new Error("Invalid date supplied: " + JSON.stringify(inputDate)));
      self2.selectedDates = self2.config.allowInvalidPreload ? dates : dates.filter(function(d) {
        return d instanceof Date && isEnabled(d, false);
      });
      if (self2.config.mode === "range")
        self2.selectedDates.sort(function(a, b) {
          return a.getTime() - b.getTime();
        });
    }
    function setDate(date, triggerChange2, format) {
      if (triggerChange2 === void 0) {
        triggerChange2 = false;
      }
      if (format === void 0) {
        format = self2.config.dateFormat;
      }
      if (date !== 0 && !date || date instanceof Array && date.length === 0)
        return self2.clear(triggerChange2);
      setSelectedDate(date, format);
      self2.latestSelectedDateObj = self2.selectedDates[self2.selectedDates.length - 1];
      self2.redraw();
      jumpToDate(void 0, triggerChange2);
      setHoursFromDate();
      if (self2.selectedDates.length === 0) {
        self2.clear(false);
      }
      updateValue(triggerChange2);
      if (triggerChange2)
        triggerEvent("onChange");
    }
    function parseDateRules(arr) {
      return arr.slice().map(function(rule) {
        if (typeof rule === "string" || typeof rule === "number" || rule instanceof Date) {
          return self2.parseDate(rule, void 0, true);
        } else if (rule && typeof rule === "object" && rule.from && rule.to)
          return {
            from: self2.parseDate(rule.from, void 0),
            to: self2.parseDate(rule.to, void 0)
          };
        return rule;
      }).filter(function(x) {
        return x;
      });
    }
    function setupDates() {
      self2.selectedDates = [];
      self2.now = self2.parseDate(self2.config.now) || /* @__PURE__ */ new Date();
      var preloadedDate = self2.config.defaultDate || ((self2.input.nodeName === "INPUT" || self2.input.nodeName === "TEXTAREA") && self2.input.placeholder && self2.input.value === self2.input.placeholder ? null : self2.input.value);
      if (preloadedDate)
        setSelectedDate(preloadedDate, self2.config.dateFormat);
      self2._initialDate = self2.selectedDates.length > 0 ? self2.selectedDates[0] : self2.config.minDate && self2.config.minDate.getTime() > self2.now.getTime() ? self2.config.minDate : self2.config.maxDate && self2.config.maxDate.getTime() < self2.now.getTime() ? self2.config.maxDate : self2.now;
      self2.currentYear = self2._initialDate.getFullYear();
      self2.currentMonth = self2._initialDate.getMonth();
      if (self2.selectedDates.length > 0)
        self2.latestSelectedDateObj = self2.selectedDates[0];
      if (self2.config.minTime !== void 0)
        self2.config.minTime = self2.parseDate(self2.config.minTime, "H:i");
      if (self2.config.maxTime !== void 0)
        self2.config.maxTime = self2.parseDate(self2.config.maxTime, "H:i");
      self2.minDateHasTime = !!self2.config.minDate && (self2.config.minDate.getHours() > 0 || self2.config.minDate.getMinutes() > 0 || self2.config.minDate.getSeconds() > 0);
      self2.maxDateHasTime = !!self2.config.maxDate && (self2.config.maxDate.getHours() > 0 || self2.config.maxDate.getMinutes() > 0 || self2.config.maxDate.getSeconds() > 0);
    }
    function setupInputs() {
      self2.input = getInputElem();
      if (!self2.input) {
        self2.config.errorHandler(new Error("Invalid input element specified"));
        return;
      }
      self2.input._type = self2.input.type;
      self2.input.type = "text";
      self2.input.classList.add("flatpickr-input");
      self2._input = self2.input;
      if (self2.config.altInput) {
        self2.altInput = createElement(self2.input.nodeName, self2.config.altInputClass);
        self2._input = self2.altInput;
        self2.altInput.placeholder = self2.input.placeholder;
        self2.altInput.disabled = self2.input.disabled;
        self2.altInput.required = self2.input.required;
        self2.altInput.tabIndex = self2.input.tabIndex;
        self2.altInput.type = "text";
        self2.input.setAttribute("type", "hidden");
        if (!self2.config.static && self2.input.parentNode)
          self2.input.parentNode.insertBefore(self2.altInput, self2.input.nextSibling);
      }
      if (!self2.config.allowInput)
        self2._input.setAttribute("readonly", "readonly");
      updatePositionElement();
    }
    function updatePositionElement() {
      self2._positionElement = self2.config.positionElement || self2._input;
    }
    function setupMobile() {
      var inputType = self2.config.enableTime ? self2.config.noCalendar ? "time" : "datetime-local" : "date";
      self2.mobileInput = createElement("input", self2.input.className + " flatpickr-mobile");
      self2.mobileInput.tabIndex = 1;
      self2.mobileInput.type = inputType;
      self2.mobileInput.disabled = self2.input.disabled;
      self2.mobileInput.required = self2.input.required;
      self2.mobileInput.placeholder = self2.input.placeholder;
      self2.mobileFormatStr = inputType === "datetime-local" ? "Y-m-d\\TH:i:S" : inputType === "date" ? "Y-m-d" : "H:i:S";
      if (self2.selectedDates.length > 0) {
        self2.mobileInput.defaultValue = self2.mobileInput.value = self2.formatDate(self2.selectedDates[0], self2.mobileFormatStr);
      }
      if (self2.config.minDate)
        self2.mobileInput.min = self2.formatDate(self2.config.minDate, "Y-m-d");
      if (self2.config.maxDate)
        self2.mobileInput.max = self2.formatDate(self2.config.maxDate, "Y-m-d");
      if (self2.input.getAttribute("step"))
        self2.mobileInput.step = String(self2.input.getAttribute("step"));
      self2.input.type = "hidden";
      if (self2.altInput !== void 0)
        self2.altInput.type = "hidden";
      try {
        if (self2.input.parentNode)
          self2.input.parentNode.insertBefore(self2.mobileInput, self2.input.nextSibling);
      } catch (_a) {
      }
      bind(self2.mobileInput, "change", function(e) {
        self2.setDate(getEventTarget(e).value, false, self2.mobileFormatStr);
        triggerEvent("onChange");
        triggerEvent("onClose");
      });
    }
    function toggle(e) {
      if (self2.isOpen === true)
        return self2.close();
      self2.open(e);
    }
    function triggerEvent(event, data) {
      if (self2.config === void 0)
        return;
      var hooks = self2.config[event];
      if (hooks !== void 0 && hooks.length > 0) {
        for (var i = 0; hooks[i] && i < hooks.length; i++)
          hooks[i](self2.selectedDates, self2.input.value, self2, data);
      }
      if (event === "onChange") {
        self2.input.dispatchEvent(createEvent("change"));
        self2.input.dispatchEvent(createEvent("input"));
      }
    }
    function createEvent(name) {
      var e = document.createEvent("Event");
      e.initEvent(name, true, true);
      return e;
    }
    function isDateSelected(date) {
      for (var i = 0; i < self2.selectedDates.length; i++) {
        var selectedDate = self2.selectedDates[i];
        if (selectedDate instanceof Date && compareDates(selectedDate, date) === 0)
          return "" + i;
      }
      return false;
    }
    function isDateInRange(date) {
      if (self2.config.mode !== "range" || self2.selectedDates.length < 2)
        return false;
      return compareDates(date, self2.selectedDates[0]) >= 0 && compareDates(date, self2.selectedDates[1]) <= 0;
    }
    function updateNavigationCurrentMonth() {
      if (self2.config.noCalendar || self2.isMobile || !self2.monthNav)
        return;
      self2.yearElements.forEach(function(yearElement, i) {
        var d = new Date(self2.currentYear, self2.currentMonth, 1);
        d.setMonth(self2.currentMonth + i);
        if (self2.config.showMonths > 1 || self2.config.monthSelectorType === "static") {
          self2.monthElements[i].textContent = monthToStr(d.getMonth(), self2.config.shorthandCurrentMonth, self2.l10n) + " ";
        } else {
          self2.monthsDropdownContainer.value = d.getMonth().toString();
        }
        yearElement.value = d.getFullYear().toString();
      });
      self2._hidePrevMonthArrow = self2.config.minDate !== void 0 && (self2.currentYear === self2.config.minDate.getFullYear() ? self2.currentMonth <= self2.config.minDate.getMonth() : self2.currentYear < self2.config.minDate.getFullYear());
      self2._hideNextMonthArrow = self2.config.maxDate !== void 0 && (self2.currentYear === self2.config.maxDate.getFullYear() ? self2.currentMonth + 1 > self2.config.maxDate.getMonth() : self2.currentYear > self2.config.maxDate.getFullYear());
    }
    function getDateStr(specificFormat) {
      var format = specificFormat || (self2.config.altInput ? self2.config.altFormat : self2.config.dateFormat);
      return self2.selectedDates.map(function(dObj) {
        return self2.formatDate(dObj, format);
      }).filter(function(d, i, arr) {
        return self2.config.mode !== "range" || self2.config.enableTime || arr.indexOf(d) === i;
      }).join(self2.config.mode !== "range" ? self2.config.conjunction : self2.l10n.rangeSeparator);
    }
    function updateValue(triggerChange2) {
      if (triggerChange2 === void 0) {
        triggerChange2 = true;
      }
      if (self2.mobileInput !== void 0 && self2.mobileFormatStr) {
        self2.mobileInput.value = self2.latestSelectedDateObj !== void 0 ? self2.formatDate(self2.latestSelectedDateObj, self2.mobileFormatStr) : "";
      }
      self2.input.value = getDateStr(self2.config.dateFormat);
      if (self2.altInput !== void 0) {
        self2.altInput.value = getDateStr(self2.config.altFormat);
      }
      if (triggerChange2 !== false)
        triggerEvent("onValueUpdate");
    }
    function onMonthNavClick(e) {
      var eventTarget = getEventTarget(e);
      var isPrevMonth = self2.prevMonthNav.contains(eventTarget);
      var isNextMonth = self2.nextMonthNav.contains(eventTarget);
      if (isPrevMonth || isNextMonth) {
        changeMonth(isPrevMonth ? -1 : 1);
      } else if (self2.yearElements.indexOf(eventTarget) >= 0) {
        eventTarget.select();
      } else if (eventTarget.classList.contains("arrowUp")) {
        self2.changeYear(self2.currentYear + 1);
      } else if (eventTarget.classList.contains("arrowDown")) {
        self2.changeYear(self2.currentYear - 1);
      }
    }
    function timeWrapper(e) {
      e.preventDefault();
      var isKeyDown = e.type === "keydown", eventTarget = getEventTarget(e), input = eventTarget;
      if (self2.amPM !== void 0 && eventTarget === self2.amPM) {
        self2.amPM.textContent = self2.l10n.amPM[int(self2.amPM.textContent === self2.l10n.amPM[0])];
      }
      var min2 = parseFloat(input.getAttribute("min")), max2 = parseFloat(input.getAttribute("max")), step = parseFloat(input.getAttribute("step")), curValue = parseInt(input.value, 10), delta = e.delta || (isKeyDown ? e.which === 38 ? 1 : -1 : 0);
      var newValue = curValue + step * delta;
      if (typeof input.value !== "undefined" && input.value.length === 2) {
        var isHourElem = input === self2.hourElement, isMinuteElem = input === self2.minuteElement;
        if (newValue < min2) {
          newValue = max2 + newValue + int(!isHourElem) + (int(isHourElem) && int(!self2.amPM));
          if (isMinuteElem)
            incrementNumInput(void 0, -1, self2.hourElement);
        } else if (newValue > max2) {
          newValue = input === self2.hourElement ? newValue - max2 - int(!self2.amPM) : min2;
          if (isMinuteElem)
            incrementNumInput(void 0, 1, self2.hourElement);
        }
        if (self2.amPM && isHourElem && (step === 1 ? newValue + curValue === 23 : Math.abs(newValue - curValue) > step)) {
          self2.amPM.textContent = self2.l10n.amPM[int(self2.amPM.textContent === self2.l10n.amPM[0])];
        }
        input.value = pad(newValue);
      }
    }
    init();
    return self2;
  }
  function _flatpickr(nodeList, config) {
    var nodes = Array.prototype.slice.call(nodeList).filter(function(x) {
      return x instanceof HTMLElement;
    });
    var instances = [];
    for (var i = 0; i < nodes.length; i++) {
      var node = nodes[i];
      try {
        if (node.getAttribute("data-fp-omit") !== null)
          continue;
        if (node._flatpickr !== void 0) {
          node._flatpickr.destroy();
          node._flatpickr = void 0;
        }
        node._flatpickr = FlatpickrInstance(node, config || {});
        instances.push(node._flatpickr);
      } catch (e) {
        console.error(e);
      }
    }
    return instances.length === 1 ? instances[0] : instances;
  }
  if (typeof HTMLElement !== "undefined" && typeof HTMLCollection !== "undefined" && typeof NodeList !== "undefined") {
    HTMLCollection.prototype.flatpickr = NodeList.prototype.flatpickr = function(config) {
      return _flatpickr(this, config);
    };
    HTMLElement.prototype.flatpickr = function(config) {
      return _flatpickr([this], config);
    };
  }
  var flatpickr = function(selector, config) {
    if (typeof selector === "string") {
      return _flatpickr(window.document.querySelectorAll(selector), config);
    } else if (selector instanceof Node) {
      return _flatpickr([selector], config);
    } else {
      return _flatpickr(selector, config);
    }
  };
  flatpickr.defaultConfig = {};
  flatpickr.l10ns = {
    en: __assign({}, default_default),
    default: __assign({}, default_default)
  };
  flatpickr.localize = function(l10n) {
    flatpickr.l10ns.default = __assign(__assign({}, flatpickr.l10ns.default), l10n);
  };
  flatpickr.setDefaults = function(config) {
    flatpickr.defaultConfig = __assign(__assign({}, flatpickr.defaultConfig), config);
  };
  flatpickr.parseDate = createDateParser({});
  flatpickr.formatDate = createDateFormatter({});
  flatpickr.compareDates = compareDates;
  if (typeof jQuery !== "undefined" && typeof jQuery.fn !== "undefined") {
    jQuery.fn.flatpickr = function(config) {
      return _flatpickr(this, config);
    };
  }
  Date.prototype.fp_incr = function(days) {
    return new Date(this.getFullYear(), this.getMonth(), this.getDate() + (typeof days === "string" ? parseInt(days, 10) : days));
  };
  if (typeof window !== "undefined") {
    window.flatpickr = flatpickr;
  }
  var esm_default = flatpickr;

  // node_modules/rails_admin/src/rails_admin/filter-box.js
  (function($) {
    var filters;
    $.filters = filters = {
      append: function(options) {
        var field_label = options["label"];
        var field_name = options["name"];
        var field_type = options["type"];
        var field_value = options["value"] || "";
        var field_operator = options["operator"];
        var operators = options["operators"];
        var index = options["index"];
        var value_name = "f[" + field_name + "][" + index + "][v]";
        var operator_name = "f[" + field_name + "][" + index + "][o]";
        var control = null;
        var additional_control = null;
        if (operators.length > 0) {
          control = $(
            '<select class="form-control form-select form-select-sm"></select>'
          ).prop("name", operator_name);
          operators.forEach((operator) => {
            var element = this.build_operator(operator, options);
            if (!element) {
              return;
            }
            if (element.prop("value") === field_operator) {
              element.prop("selected", true);
            }
            control.append(element);
          });
          if (control.find("[data-additional-fieldset]").length > 0) {
            control.addClass("switch-additional-fieldsets");
          }
        }
        switch (field_type) {
          case "boolean":
            control && control.prop("name", value_name).find("option").each(function() {
              if ($(this).attr("value") === field_value)
                $(this).attr("selected", true);
            });
            break;
          case "date":
          case "datetime":
          case "timestamp":
          case "time":
            additional_control = $.map(
              [void 0, "-\u221E", "\u221E"],
              function(placeholder, index2) {
                var visible = index2 == 0 ? !field_operator || field_operator == "default" : field_operator == "between";
                return $('<span class="additional-fieldset"></span>').addClass(index2 == 0 ? "default" : "between").css("display", visible ? "inline-block" : "none").html(
                  $(
                    '<input class="input-sm form-control form-control-sm" type="text" />'
                  ).addClass(field_type == "date" ? "date" : "datetime").prop("name", value_name + "[]").prop("value", field_value[index2] || "").prop(
                    "size",
                    field_type == "date" || field_type == "time" ? 20 : 25
                  ).prop("placeholder", placeholder)
                );
              }
            );
            break;
          case "enum":
            if (control) {
              var multiple = field_value instanceof Array;
              control = control.prop("name", multiple ? value_name + "[]" : value_name).prop("multiple", multiple).add(
                $('<a href="#" class="switch-select"></a>').append(
                  $("<i></i>").addClass(
                    "fas fa-" + (multiple ? "minus" : "plus")
                  )
                )
              );
              control.find("option").each(function() {
                const value = $(this).attr("value");
                if (multiple ? field_value.includes(value) : value === field_value)
                  $(this).attr("selected", true);
              });
              if (multiple)
                control.find("option[value^=_],option[disabled]").hide();
            }
            break;
          case "citext":
          case "string":
          case "text":
          case "belongs_to_association":
          case "has_one_association":
            additional_control = $(
              '<input class="additional-fieldset form-control form-control-sm" type="text" />'
            ).css(
              "display",
              field_operator == "_present" || field_operator == "_blank" ? "none" : "inline-block"
            ).prop("name", value_name).prop("value", field_value);
            break;
          case "integer":
          case "decimal":
          case "float":
            additional_control = $(
              '<input class="additional-fieldset default form-control form-control-sm" type="text" />'
            ).css(
              "display",
              !field_operator || field_operator == "default" ? "inline-block" : "none"
            ).prop("type", field_type).prop("name", value_name + "[]").prop("value", field_value[0] || "").add(
              $(
                '<input placeholder="-\u221E" class="additional-fieldset between form-control form-control-sm" />'
              ).css(
                "display",
                field_operator == "between" ? "inline-block" : "none"
              ).prop("type", field_type).prop("name", value_name + "[]").prop("value", field_value[1] || "")
            ).add(
              $(
                '<input placeholder="\u221E" class="additional-fieldset between form-control form-control-sm" />'
              ).css(
                "display",
                field_operator == "between" ? "inline-block" : "none"
              ).prop("type", field_type).prop("name", value_name + "[]").prop("value", field_value[2] || "")
            );
            break;
          default:
            control = $(
              '<input type="text" class="form-control form-control-sm" />'
            ).prop("name", value_name).prop("value", field_value);
            break;
        }
        var filterContainerId = field_name + "-" + index + "-filter-container";
        $("#" + filterContainerId).remove();
        var $content = $("<div>").attr("id", filterContainerId).addClass("filter d-inline-block my-1").append(
          $(
            '<button type="button" class="btn btn-info btn-sm delete"></button>'
          ).append('<i class="fas fa-trash"></i>').append(document.createTextNode(field_label))
        ).append("&nbsp;").append(control).append("&nbsp;").append(additional_control);
        $("#filters_box").append($content);
        $content.find(".date, .datetime").each(function() {
          esm_default(
            this,
            $.extend(
              {
                dateFormat: "Y-m-dTH:i:S",
                altInput: true,
                locale: I18n.locale
              },
              options["datetimepicker_options"]
            )
          );
        });
        $("hr.filters_box:hidden").show("slow");
      },
      build_operator: function(operator, options) {
        if (operator instanceof Object) {
          var element = $("<option></option>");
          element.text(operator.label);
          delete operator.label;
          for (const key in operator) {
            element.attr(key, operator[key]);
          }
          return element;
        }
        switch (operator) {
          case "_discard":
            return $('<option value="_discard">...</option>');
          case "_separator":
            return $('<option disabled="disabled">---------</option>');
          case "_present":
            return $('<option value="_present"></option>').text(
              I18n.t("is_present")
            );
          case "_blank":
            return $('<option value="_blank"></option>').text(I18n.t("is_blank"));
          case "_not_null":
            return $('<option value="_not_null"></option>').text(
              I18n.t("is_present")
            );
          case "_null":
            return $('<option value="_null"></option>').text(I18n.t("is_blank"));
          case "true":
            return $('<option value="true"></option>').text(I18n.t("true"));
          case "false":
            return $('<option value="false"></option>').text(I18n.t("false"));
          case "today":
            return $('<option value="today"></option>').text(I18n.t("today"));
          case "yesterday":
            return $('<option value="yesterday"></option>').text(
              I18n.t("yesterday")
            );
          case "this_week":
            return $('<option value="this_week"></option>').text(
              I18n.t("this_week")
            );
          case "last_week":
            return $('<option value="last_week"></option>').text(
              I18n.t("last_week")
            );
          case "like":
            return $(
              '<option data-additional-fieldset="additional-fieldset" value="like"></option>'
            ).text(I18n.t("contains"));
          case "not_like":
            return $(
              '<option data-additional-fieldset="additional-fieldset" value="not_like"></option>'
            ).text(I18n.t("does_not_contain"));
          case "is":
            return $(
              '<option data-additional-fieldset="additional-fieldset" value="is"></option>'
            ).text(I18n.t("is_exactly"));
          case "starts_with":
            return $(
              '<option data-additional-fieldset="additional-fieldset" value="starts_with"></option>'
            ).text(I18n.t("starts_with"));
          case "ends_with":
            return $(
              '<option data-additional-fieldset="additional-fieldset" value="ends_with"></option>'
            ).text(I18n.t("ends_with"));
          case "default":
            var label;
            switch (options.type) {
              case "date":
              case "datetime":
              case "timestamp":
                label = I18n.t("date");
                break;
              case "time":
                label = I18n.t("time");
                break;
              case "integer":
              case "decimal":
              case "float":
                label = I18n.t("number");
                break;
            }
            return $(
              '<option data-additional-fieldset="default" value="default"></option>'
            ).text(label);
          case "between":
            return $(
              '<option data-additional-fieldset="between" value="between"></option>'
            ).text(I18n.t("between_and_"));
          default:
            return null;
        }
      }
    };
    $(document).on("click", "#filters a", function(e) {
      e.preventDefault();
      $.filters.append(
        $.extend(
          { index: $.now().toString().slice(6, 11) },
          $(this).data("options")
        )
      );
    });
    $(document).on("click", "#filters_box .delete", function(e) {
      e.preventDefault();
      var form = $(this).parents("form");
      $(this).parents(".filter").remove();
      !$("#filters_box").children().length && $("hr.filters_box:visible").hide("slow");
    });
    $(document).on("click", "#filters_box .switch-select", function(e) {
      e.preventDefault();
      var select = $(this).siblings("select");
      select.attr("multiple", !select.attr("multiple"));
      select.attr(
        "name",
        select.attr("multiple") ? select.attr("name") + "[]" : select.attr("name").replace(/\[\]$/, "")
      );
      select.find("option[value^=_],option[disabled]").toggle();
      $(this).find("i").toggleClass("fa-plus fa-minus");
    });
    $(document).on(
      "change",
      "#filters_box .switch-additional-fieldsets",
      function(e) {
        var selected_option = $(this).find("option:selected");
        var klass = $(selected_option).data("additional-fieldset");
        if (klass) {
          $(this).siblings(".additional-fieldset:not(." + klass + ")").hide("slow");
          $(this).siblings("." + klass).show("slow");
        } else {
          $(this).siblings(".additional-fieldset").hide("slow");
        }
      }
    );
  })(import_jquery4.default);

  // node_modules/rails_admin/src/rails_admin/filtering-multiselect.js
  var import_jquery5 = __toESM(require_jquery());
  (function($) {
    $.widget("ra.filteringMultiselect", $.ra.abstractSelect, {
      _cache: {},
      options: {
        sortable: false,
        removable: true,
        regional: {
          add: "Add",
          chooseAll: "Choose all",
          clearAll: "Clear all",
          down: "Down",
          remove: "Remove",
          search: "Search",
          up: "Up"
        },
        searchDelay: 400,
        remote_source: null,
        xhr: false
      },
      wrapper: null,
      filter: null,
      collection: null,
      addAll: null,
      add: null,
      remove: null,
      up: null,
      down: null,
      selection: null,
      removeAll: null,
      _create: function() {
        this._cache = {};
        this._build();
        this._buildCache();
        this._bindEvents();
      },
      _build: function() {
        var i;
        this.wrapper = this.element.siblings(
          '.ra-multiselect[data-input-for="' + this.element.attr("id") + '"]'
        );
        if (this.wrapper.length > 0) {
          this.filter = this.wrapper.find("input.ra-multiselect-search");
          this.collection = this.wrapper.find("select.ra-multiselect-collection");
          this.addAll = this.wrapper.find("a.ra-multiselect-item-add-all");
          this.add = this.wrapper.find("a.ra-multiselect-item-add");
          this.remove = this.wrapper.find("a.ra-multiselect-item-remove");
          this.up = this.wrapper.find("a.ra-multiselect-item-up");
          this.down = this.wrapper.find("a.ra-multiselect-item-down");
          this.selection = this.wrapper.find("select.ra-multiselect-selection");
          this.removeAll = this.wrapper.find("a.ra-multiselect-item-remove-all");
          return;
        }
        this.wrapper = $('<div class="ra-multiselect">').attr(
          "data-input-for",
          this.element.attr("id")
        );
        this.wrapper.insertAfter(this.element);
        var header = $('<div class="ra-multiselect-header">');
        this.filter = $(
          '<input type="search" placeholder="' + this.options.regional.search + '" class="form-control ra-multiselect-search"/>'
        );
        header.append(this.filter);
        this.wrapper.append(header);
        var columns = {
          left: $('<div class="ra-multiselect-column ra-multiselect-left">'),
          center: $('<div class="ra-multiselect-column ra-multiselect-center">'),
          right: $('<div class="ra-multiselect-column ra-multiselect-right">')
        };
        for (i in columns) {
          if (columns.hasOwnProperty(i)) {
            this.wrapper.append(columns[i]);
          }
        }
        this.collection = $('<select multiple="multiple"></select>');
        this.collection.addClass("form-control ra-multiselect-collection");
        this.addAll = $(
          '<a href="#" class="ra-multiselect-item-add-all"><span class="fas fa-chevron-circle-right"></span>' + this.options.regional.chooseAll + "</a>"
        );
        columns.left.html(this.collection).append(this.addAll);
        this.collection.wrap('<div class="wrapper"/>');
        this.add = $(
          '<a href="#" class="fas fa-chevron-circle-right ra-multiselect-item-add"></a>'
        ).attr("title", this.options.regional.add);
        columns.center.append(this.add);
        if (this.options.removable) {
          this.remove = $(
            '<a href="#" class="fas fa-chevron-circle-left ra-multiselect-item-remove"></a>'
          ).attr("title", this.options.regional.remove);
          columns.center.append(this.remove);
        }
        if (this.options.sortable) {
          this.up = $(
            '<a href="#" class="fas fa-chevron-circle-up ra-multiselect-item-up"></a>'
          ).attr("title", this.options.regional.up);
          this.down = $(
            '<a href="#" class="fas fa-chevron-circle-down ra-multiselect-item-down"></a>'
          ).attr("title", this.options.regional.down);
          columns.center.append(this.up).append(this.down);
        }
        this.selection = $(
          '<select class="form-control ra-multiselect-selection" multiple="multiple"></select>'
        );
        columns.right.append(this.selection);
        if (this.options.removable) {
          this.removeAll = $(
            '<a href="#" class="ra-multiselect-item-remove-all"><span class="fas fa-chevron-circle-left"></span>' + this.options.regional.clearAll + "</a>"
          );
          columns.right.append(this.removeAll);
        }
        this.selection.wrap('<div class="wrapper"/>');
        this.element.css({ display: "none" });
        this.tooManyObjectsPlaceholder = $('<option disabled="disabled" />').text(
          I18n.t("too_many_objects")
        );
        this.noObjectsPlaceholder = $('<option disabled="disabled" />').text(
          I18n.t("no_objects")
        );
        if (this.options.xhr) {
          this.collection.append(this.tooManyObjectsPlaceholder);
        }
      },
      _bindEvents: function() {
        var widget = this;
        this.addAll.click(function(e) {
          widget._select($("option:not(:disabled)", widget.collection));
          e.preventDefault();
          widget.selection.trigger("change");
        });
        this.add.click(function(e) {
          widget._select($(":selected", widget.collection));
          e.preventDefault();
          widget.selection.trigger("change");
        });
        if (this.options.removable) {
          this.removeAll.click(function(e) {
            widget._deSelect($("option", widget.selection));
            e.preventDefault();
            widget.selection.trigger("change");
          });
          this.remove.click(function(e) {
            widget._deSelect($(":selected", widget.selection));
            e.preventDefault();
            widget.selection.trigger("change");
          });
        }
        var timeout = null;
        if (this.options.sortable) {
          this.up.click(function(e) {
            widget._move("up", $(":selected", widget.selection));
            e.preventDefault();
          });
          this.down.click(function(e) {
            widget._move("down", $(":selected", widget.selection));
            e.preventDefault();
          });
        }
        this.filter.bind("keyup click", function(e) {
          if (timeout) {
            clearTimeout(timeout);
          }
          timeout = setTimeout(function() {
            widget._queryFilter(widget.filter.val());
          }, widget.options.searchDelay);
        });
      },
      _queryFilter: function(val) {
        var widget = this;
        widget._query(val, function(matches) {
          var filtered = [];
          var i;
          for (i = 0; i < matches.length; i++) {
            if (!widget.selected(matches[i].id)) {
              filtered.push(i);
            }
          }
          if (filtered.length > 0) {
            widget.collection.html("");
            for (i = 0; i < filtered.length; i++) {
              var newOptions = $("<option></option>").prop("value", matches[filtered[i]].id).prop("title", matches[filtered[i]].label).text(matches[filtered[i]].label);
              widget.collection.append(newOptions);
            }
          } else {
            widget.collection.html(widget.noObjectsPlaceholder);
          }
        });
      },
      /*
       * Cache key is stored in the format `o_<option value>` to avoid JS
       * engine coercing string keys to int keys, and thereby preserving
       * the insertion order. The value for each key is in turn an object
       * that stores the option tag's HTML text and the value. Example:
       * cache = {
       *    'o_271': { id: 271, value: 'CartItem #271'},
       *    'o_270': { id: 270, value: 'CartItem #270'}
       * }
       */
      _buildCache: function(options) {
        var widget = this;
        this.element.find("option").each(function(i, option) {
          widget._cache["o_" + option.value] = {
            id: option.value,
            value: $(option).text()
          };
          if (option.selected) {
            $(option).clone().appendTo(widget.selection).prop("selected", false).prop("title", $(option).text());
          } else {
            $(option).clone().appendTo(widget.collection).prop("selected", false).prop("title", $(option).text());
          }
        });
      },
      _deSelect: function(options) {
        var widget = this;
        options.each(function(i, option) {
          widget.element.find('option[value="' + option.value + '"]').prop("selected", false);
        });
        $(options).appendTo(this.collection).prop("selected", false);
      },
      _query: function(query, success) {
        var i, matches = [];
        if (query === "") {
          if (!this.options.xhr) {
            for (i in this._cache) {
              if (this._cache.hasOwnProperty(i)) {
                var option = this._cache[i];
                matches.push({ id: option.id, label: option.value });
              }
            }
            success.apply(this, [matches]);
          } else {
            this.collection.html(this.tooManyObjectsPlaceholder);
          }
        } else {
          if (this.options.xhr) {
            $.ajax({
              beforeSend: function(xhr) {
                xhr.setRequestHeader("Accept", "application/json");
              },
              url: this.options.remote_source,
              data: this.options.createQuery(query),
              success
            });
          } else {
            query = new RegExp(query + ".*", "i");
            for (i in this._cache) {
              if (this._cache.hasOwnProperty(i) && query.test(this._cache[i]["value"])) {
                var option = this._cache[i];
                matches.push({ id: option.id, label: option.value });
              }
            }
            success.apply(this, [matches]);
          }
        }
      },
      _select: function(options) {
        var widget = this;
        options.each(function(i, option) {
          var el = widget.element.find('option[value="' + option.value + '"]');
          if (el.length) {
            el.prop("selected", true);
          } else {
            widget.element.append(
              $("<option></option>").prop("value", option.value).prop("selected", true)
            );
          }
        });
        $(options).appendTo(this.selection).prop("selected", false);
      },
      _move: function(direction, options) {
        var widget = this;
        if (direction == "up") {
          options.each(function(i, option) {
            var prev = $(option).prev();
            if (prev.length > 0) {
              var el = widget.element.find(
                'option[value="' + option.value + '"]'
              );
              var el_prev = widget.element.find(
                'option[value="' + prev[0].value + '"]'
              );
              el_prev.before(el);
              prev.before($(option));
            }
          });
        } else {
          $.fn.reverse = [].reverse;
          options.reverse().each(function(i, option) {
            var next = $(option).next();
            if (next.length > 0) {
              var el = widget.element.find(
                'option[value="' + option.value + '"]'
              );
              var el_next = widget.element.find(
                'option[value="' + next[0].value + '"]'
              );
              el_next.after(el);
              next.after($(option));
            }
          });
        }
      },
      selected: function(value) {
        if (this.selection[0].querySelectorAll('option[value="' + value + '"]')[0]) {
          return true;
        }
      },
      destroy: function() {
        this.wrapper.remove();
        this.element.css({ display: "inline" });
        $.Widget.prototype.destroy.apply(this, arguments);
      }
    });
  })(import_jquery5.default);

  // node_modules/rails_admin/src/rails_admin/filtering-select.js
  var import_jquery6 = __toESM(require_jquery());

  // node_modules/jquery-ui/ui/widgets/autocomplete.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define([
        "jquery",
        "./menu",
        "../keycode",
        "../position",
        "../safe-active-element",
        "../version",
        "../widget"
      ], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    $.widget("ui.autocomplete", {
      version: "1.13.3",
      defaultElement: "<input>",
      options: {
        appendTo: null,
        autoFocus: false,
        delay: 300,
        minLength: 1,
        position: {
          my: "left top",
          at: "left bottom",
          collision: "none"
        },
        source: null,
        // Callbacks
        change: null,
        close: null,
        focus: null,
        open: null,
        response: null,
        search: null,
        select: null
      },
      requestIndex: 0,
      pending: 0,
      liveRegionTimer: null,
      _create: function() {
        var suppressKeyPress, suppressKeyPressRepeat, suppressInput, nodeName = this.element[0].nodeName.toLowerCase(), isTextarea = nodeName === "textarea", isInput = nodeName === "input";
        this.isMultiLine = isTextarea || !isInput && this._isContentEditable(this.element);
        this.valueMethod = this.element[isTextarea || isInput ? "val" : "text"];
        this.isNewMenu = true;
        this._addClass("ui-autocomplete-input");
        this.element.attr("autocomplete", "off");
        this._on(this.element, {
          keydown: function(event) {
            if (this.element.prop("readOnly")) {
              suppressKeyPress = true;
              suppressInput = true;
              suppressKeyPressRepeat = true;
              return;
            }
            suppressKeyPress = false;
            suppressInput = false;
            suppressKeyPressRepeat = false;
            var keyCode = $.ui.keyCode;
            switch (event.keyCode) {
              case keyCode.PAGE_UP:
                suppressKeyPress = true;
                this._move("previousPage", event);
                break;
              case keyCode.PAGE_DOWN:
                suppressKeyPress = true;
                this._move("nextPage", event);
                break;
              case keyCode.UP:
                suppressKeyPress = true;
                this._keyEvent("previous", event);
                break;
              case keyCode.DOWN:
                suppressKeyPress = true;
                this._keyEvent("next", event);
                break;
              case keyCode.ENTER:
                if (this.menu.active) {
                  suppressKeyPress = true;
                  event.preventDefault();
                  this.menu.select(event);
                }
                break;
              case keyCode.TAB:
                if (this.menu.active) {
                  this.menu.select(event);
                }
                break;
              case keyCode.ESCAPE:
                if (this.menu.element.is(":visible")) {
                  if (!this.isMultiLine) {
                    this._value(this.term);
                  }
                  this.close(event);
                  event.preventDefault();
                }
                break;
              default:
                suppressKeyPressRepeat = true;
                this._searchTimeout(event);
                break;
            }
          },
          keypress: function(event) {
            if (suppressKeyPress) {
              suppressKeyPress = false;
              if (!this.isMultiLine || this.menu.element.is(":visible")) {
                event.preventDefault();
              }
              return;
            }
            if (suppressKeyPressRepeat) {
              return;
            }
            var keyCode = $.ui.keyCode;
            switch (event.keyCode) {
              case keyCode.PAGE_UP:
                this._move("previousPage", event);
                break;
              case keyCode.PAGE_DOWN:
                this._move("nextPage", event);
                break;
              case keyCode.UP:
                this._keyEvent("previous", event);
                break;
              case keyCode.DOWN:
                this._keyEvent("next", event);
                break;
            }
          },
          input: function(event) {
            if (suppressInput) {
              suppressInput = false;
              event.preventDefault();
              return;
            }
            this._searchTimeout(event);
          },
          focus: function() {
            this.selectedItem = null;
            this.previous = this._value();
          },
          blur: function(event) {
            clearTimeout(this.searching);
            this.close(event);
            this._change(event);
          }
        });
        this._initSource();
        this.menu = $("<ul>").appendTo(this._appendTo()).menu({
          // disable ARIA support, the live region takes care of that
          role: null
        }).hide().attr({
          "unselectable": "on"
        }).menu("instance");
        this._addClass(this.menu.element, "ui-autocomplete", "ui-front");
        this._on(this.menu.element, {
          mousedown: function(event) {
            event.preventDefault();
          },
          menufocus: function(event, ui) {
            var label, item;
            if (this.isNewMenu) {
              this.isNewMenu = false;
              if (event.originalEvent && /^mouse/.test(event.originalEvent.type)) {
                this.menu.blur();
                this.document.one("mousemove", function() {
                  $(event.target).trigger(event.originalEvent);
                });
                return;
              }
            }
            item = ui.item.data("ui-autocomplete-item");
            if (false !== this._trigger("focus", event, { item })) {
              if (event.originalEvent && /^key/.test(event.originalEvent.type)) {
                this._value(item.value);
              }
            }
            label = ui.item.attr("aria-label") || item.value;
            if (label && String.prototype.trim.call(label).length) {
              clearTimeout(this.liveRegionTimer);
              this.liveRegionTimer = this._delay(function() {
                this.liveRegion.html($("<div>").text(label));
              }, 100);
            }
          },
          menuselect: function(event, ui) {
            var item = ui.item.data("ui-autocomplete-item"), previous = this.previous;
            if (this.element[0] !== $.ui.safeActiveElement(this.document[0])) {
              this.element.trigger("focus");
              this.previous = previous;
              this._delay(function() {
                this.previous = previous;
                this.selectedItem = item;
              });
            }
            if (false !== this._trigger("select", event, { item })) {
              this._value(item.value);
            }
            this.term = this._value();
            this.close(event);
            this.selectedItem = item;
          }
        });
        this.liveRegion = $("<div>", {
          role: "status",
          "aria-live": "assertive",
          "aria-relevant": "additions"
        }).appendTo(this.document[0].body);
        this._addClass(this.liveRegion, null, "ui-helper-hidden-accessible");
        this._on(this.window, {
          beforeunload: function() {
            this.element.removeAttr("autocomplete");
          }
        });
      },
      _destroy: function() {
        clearTimeout(this.searching);
        this.element.removeAttr("autocomplete");
        this.menu.element.remove();
        this.liveRegion.remove();
      },
      _setOption: function(key, value) {
        this._super(key, value);
        if (key === "source") {
          this._initSource();
        }
        if (key === "appendTo") {
          this.menu.element.appendTo(this._appendTo());
        }
        if (key === "disabled" && value && this.xhr) {
          this.xhr.abort();
        }
      },
      _isEventTargetInWidget: function(event) {
        var menuElement = this.menu.element[0];
        return event.target === this.element[0] || event.target === menuElement || $.contains(menuElement, event.target);
      },
      _closeOnClickOutside: function(event) {
        if (!this._isEventTargetInWidget(event)) {
          this.close();
        }
      },
      _appendTo: function() {
        var element = this.options.appendTo;
        if (element) {
          element = element.jquery || element.nodeType ? $(element) : this.document.find(element).eq(0);
        }
        if (!element || !element[0]) {
          element = this.element.closest(".ui-front, dialog");
        }
        if (!element.length) {
          element = this.document[0].body;
        }
        return element;
      },
      _initSource: function() {
        var array, url, that = this;
        if (Array.isArray(this.options.source)) {
          array = this.options.source;
          this.source = function(request, response) {
            response($.ui.autocomplete.filter(array, request.term));
          };
        } else if (typeof this.options.source === "string") {
          url = this.options.source;
          this.source = function(request, response) {
            if (that.xhr) {
              that.xhr.abort();
            }
            that.xhr = $.ajax({
              url,
              data: request,
              dataType: "json",
              success: function(data) {
                response(data);
              },
              error: function() {
                response([]);
              }
            });
          };
        } else {
          this.source = this.options.source;
        }
      },
      _searchTimeout: function(event) {
        clearTimeout(this.searching);
        this.searching = this._delay(function() {
          var equalValues = this.term === this._value(), menuVisible = this.menu.element.is(":visible"), modifierKey = event.altKey || event.ctrlKey || event.metaKey || event.shiftKey;
          if (!equalValues || equalValues && !menuVisible && !modifierKey) {
            this.selectedItem = null;
            this.search(null, event);
          }
        }, this.options.delay);
      },
      search: function(value, event) {
        value = value != null ? value : this._value();
        this.term = this._value();
        if (value.length < this.options.minLength) {
          return this.close(event);
        }
        if (this._trigger("search", event) === false) {
          return;
        }
        return this._search(value);
      },
      _search: function(value) {
        this.pending++;
        this._addClass("ui-autocomplete-loading");
        this.cancelSearch = false;
        this.source({ term: value }, this._response());
      },
      _response: function() {
        var index = ++this.requestIndex;
        return function(content) {
          if (index === this.requestIndex) {
            this.__response(content);
          }
          this.pending--;
          if (!this.pending) {
            this._removeClass("ui-autocomplete-loading");
          }
        }.bind(this);
      },
      __response: function(content) {
        if (content) {
          content = this._normalize(content);
        }
        this._trigger("response", null, { content });
        if (!this.options.disabled && content && content.length && !this.cancelSearch) {
          this._suggest(content);
          this._trigger("open");
        } else {
          this._close();
        }
      },
      close: function(event) {
        this.cancelSearch = true;
        this._close(event);
      },
      _close: function(event) {
        this._off(this.document, "mousedown");
        if (this.menu.element.is(":visible")) {
          this.menu.element.hide();
          this.menu.blur();
          this.isNewMenu = true;
          this._trigger("close", event);
        }
      },
      _change: function(event) {
        if (this.previous !== this._value()) {
          this._trigger("change", event, { item: this.selectedItem });
        }
      },
      _normalize: function(items) {
        if (items.length && items[0].label && items[0].value) {
          return items;
        }
        return $.map(items, function(item) {
          if (typeof item === "string") {
            return {
              label: item,
              value: item
            };
          }
          return $.extend({}, item, {
            label: item.label || item.value,
            value: item.value || item.label
          });
        });
      },
      _suggest: function(items) {
        var ul = this.menu.element.empty();
        this._renderMenu(ul, items);
        this.isNewMenu = true;
        this.menu.refresh();
        ul.show();
        this._resizeMenu();
        ul.position($.extend({
          of: this.element
        }, this.options.position));
        if (this.options.autoFocus) {
          this.menu.next();
        }
        this._on(this.document, {
          mousedown: "_closeOnClickOutside"
        });
      },
      _resizeMenu: function() {
        var ul = this.menu.element;
        ul.outerWidth(Math.max(
          // Firefox wraps long text (possibly a rounding bug)
          // so we add 1px to avoid the wrapping (#7513)
          ul.width("").outerWidth() + 1,
          this.element.outerWidth()
        ));
      },
      _renderMenu: function(ul, items) {
        var that = this;
        $.each(items, function(index, item) {
          that._renderItemData(ul, item);
        });
      },
      _renderItemData: function(ul, item) {
        return this._renderItem(ul, item).data("ui-autocomplete-item", item);
      },
      _renderItem: function(ul, item) {
        return $("<li>").append($("<div>").text(item.label)).appendTo(ul);
      },
      _move: function(direction, event) {
        if (!this.menu.element.is(":visible")) {
          this.search(null, event);
          return;
        }
        if (this.menu.isFirstItem() && /^previous/.test(direction) || this.menu.isLastItem() && /^next/.test(direction)) {
          if (!this.isMultiLine) {
            this._value(this.term);
          }
          this.menu.blur();
          return;
        }
        this.menu[direction](event);
      },
      widget: function() {
        return this.menu.element;
      },
      _value: function() {
        return this.valueMethod.apply(this.element, arguments);
      },
      _keyEvent: function(keyEvent, event) {
        if (!this.isMultiLine || this.menu.element.is(":visible")) {
          this._move(keyEvent, event);
          event.preventDefault();
        }
      },
      // Support: Chrome <=50
      // We should be able to just use this.element.prop( "isContentEditable" )
      // but hidden elements always report false in Chrome.
      // https://code.google.com/p/chromium/issues/detail?id=313082
      _isContentEditable: function(element) {
        if (!element.length) {
          return false;
        }
        var editable = element.prop("contentEditable");
        if (editable === "inherit") {
          return this._isContentEditable(element.parent());
        }
        return editable === "true";
      }
    });
    $.extend($.ui.autocomplete, {
      escapeRegex: function(value) {
        return value.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&");
      },
      filter: function(array, term) {
        var matcher = new RegExp($.ui.autocomplete.escapeRegex(term), "i");
        return $.grep(array, function(value) {
          return matcher.test(value.label || value.value || value);
        });
      }
    });
    $.widget("ui.autocomplete", $.ui.autocomplete, {
      options: {
        messages: {
          noResults: "No search results.",
          results: function(amount) {
            return amount + (amount > 1 ? " results are" : " result is") + " available, use up and down arrow keys to navigate.";
          }
        }
      },
      __response: function(content) {
        var message;
        this._superApply(arguments);
        if (this.options.disabled || this.cancelSearch) {
          return;
        }
        if (content && content.length) {
          message = this.options.messages.results(content.length);
        } else {
          message = this.options.messages.noResults;
        }
        clearTimeout(this.liveRegionTimer);
        this.liveRegionTimer = this._delay(function() {
          this.liveRegion.html($("<div>").text(message));
        }, 100);
      }
    });
    return $.ui.autocomplete;
  });

  // node_modules/rails_admin/src/rails_admin/filtering-select.js
  (function($) {
    "use strict";
    $.widget("ra.filteringSelect", $.ra.abstractSelect, {
      options: {
        minLength: 0,
        searchDelay: 200,
        remote_source: null,
        source: null,
        xhr: false
      },
      button: null,
      input: null,
      select: null,
      filtering_select: null,
      _create: function() {
        this.filtering_select = this.element.siblings(
          '[data-input-for="' + this.element.attr("id") + '"]'
        );
        if (this.filtering_select.length > 0) {
          this.input = this.filtering_select.children("input");
          this.button = this.filtering_select.children(".input-group-btn");
        } else {
          this.element.hide();
          this.filtering_select = this._inputGroup(this.element.attr("id"));
          this.input = this._inputField();
          this.button = this._buttonField();
        }
        this.clearOption = $('<span style="color: #888"></span>').append(
          '<i class="fas fa-times"></i> ' + $("<span></span>").text(I18n.t("clear")).html()
        );
        this.noObjectsPlaceholder = $('<option disabled="disabled" />').text(
          I18n.t("no_objects")
        );
        this._setOptionsSource();
        this._initAutocomplete();
        this._initKeyEvent();
        this._overloadRenderItem();
        this._autocompleteDropdownEvent(this.button);
        return this.filtering_select.append(this.input).append(this.button).insertAfter(this.element);
      },
      _getResultSet: function(request, data, xhr) {
        var matcher = new RegExp(
          $.ui.autocomplete.escapeRegex(request.term),
          "i"
        );
        var spannedContent = function(content) {
          return $("<span>").text(content).html();
        };
        var highlighter = function(label, word) {
          if (word.length) {
            return $.map(label.split(word), function(el) {
              return spannedContent(el);
            }).join($("<strong>").text(word)[0].outerHTML);
          } else {
            return spannedContent(label);
          }
        };
        var matches = $.map(data, function(el) {
          var id = el.id || el.value;
          var value = el.label || el.id;
          if (id && (xhr || matcher.test(el.label))) {
            return {
              html: highlighter(value, request.term),
              value,
              id
            };
          }
        });
        if (request.term.length === 0 && !this.input.attr("required")) {
          return [{ html: this.clearOption, value: null, id: null }].concat(
            matches
          );
        } else if (matches.length === 0) {
          return [{ html: this.noObjectsPlaceholder, value: null, id: null }];
        } else {
          return matches;
        }
      },
      _getSourceFunction: function(source) {
        var self2 = this;
        var requestIndex = 0;
        if ($.isArray(source)) {
          return function(request, response) {
            response(self2._getResultSet(request, source, false));
          };
        } else if (typeof source === "string") {
          return function(request, response) {
            if (this.xhr) {
              this.xhr.abort();
            }
            this.xhr = $.ajax({
              url: source,
              data: self2.options.createQuery(request.term),
              dataType: "json",
              autocompleteRequest: ++requestIndex,
              success: function(data, status) {
                if (this.autocompleteRequest === requestIndex) {
                  response(self2._getResultSet(request, data, true));
                }
              },
              error: function() {
                if (this.autocompleteRequest === requestIndex) {
                  response([]);
                }
              }
            });
          };
        } else {
          return source;
        }
      },
      _setOptionsSource: function() {
        if (this.options.xhr) {
          this.options.source = this.options.remote_source;
        } else {
          this.options.source = this.element.children("option").map(function() {
            return { label: $(this).text(), value: this.value };
          }).toArray();
        }
      },
      _buttonField: function() {
        return $(
          '<span class="input-group-btn"><label class="btn btn-info dropdown-toggle" title="Show All Items" role="button"></label></span>'
        );
      },
      _autocompleteDropdownEvent: function(element) {
        var self2 = this;
        return element.click(function() {
          if (self2.input.autocomplete("widget").is(":visible")) {
            self2.input.autocomplete("close");
            return;
          }
          self2.input.autocomplete("search", "");
          self2.input.focus();
        });
      },
      _inputField: function() {
        var input;
        var selected = this.element.children(":selected");
        var value = selected.val() ? selected.text() : "";
        input = $('<input type="text">').val(value).addClass("form-control ra-filtering-select-input").attr("style", this.element.attr("style")).show();
        if (this.element.attr("placeholder")) {
          input.attr("placeholder", this.element.attr("placeholder"));
        }
        if (this.element.attr("required")) {
          input.attr("required", this.element.attr("required"));
          this.element.attr("required", false);
        }
        return input;
      },
      _inputGroup: function(inputFor) {
        return $("<div>").addClass("input-group filtering-select").attr("data-input-for", inputFor);
      },
      _initAutocomplete: function() {
        var self2 = this;
        return this.input.autocomplete({
          delay: this.options.searchDelay,
          minLength: this.options.minLength,
          source: this._getSourceFunction(this.options.source),
          select: function(event, ui) {
            var option = self2.element.find(
              `option[value="${CSS.escape(ui.item.id)}"]`
            );
            self2.element.find("option[selected]").attr("selected", false);
            if (option.length > 0) {
              option.attr("selected", "selected");
            } else {
              option = $("<option>").attr("value", ui.item.id).attr("selected", true).text(ui.item.value);
              self2.element.append(option);
            }
            self2.element.trigger("change", ui.item.id);
            self2._trigger("selected", event, {
              item: option
            });
            $(self2.element.parents(".controls")[0]).find(".update").removeClass("disabled");
          },
          change: function(event, ui) {
            if (ui.item) {
              return;
            }
            var matcher = new RegExp(
              "^" + $.ui.autocomplete.escapeRegex($(this).val()) + "$",
              "i"
            );
            var valid = false;
            self2.element.children("option").each(function() {
              if ($(this).text().match(matcher)) {
                valid = true;
                return false;
              }
            });
            if (valid || $(this).val() !== "") {
              return;
            }
            $(this).val(null);
            self2.element.html(
              $('<option value="" selected="selected"></option>')
            );
            self2.input.data("ui-autocomplete").term = "";
            $(self2.element.parents(".controls")[0]).find(".update").addClass("disabled");
            return false;
          }
        });
      },
      _initKeyEvent: function() {
        var self2 = this;
        return this.input.keyup(function() {
          if ($(this).val().length) {
            return;
          }
          return self2.element.html($('<option value="" selected="selected"></option>')).trigger("change");
        });
      },
      _overloadRenderItem: function() {
        this.input.data("ui-autocomplete")._renderItem = function(ul, item) {
          return $("<li></li>").data("ui-autocomplete-item", item).append($("<a></a>").html(item.html || item.id)).appendTo(ul);
        };
      },
      destroy: function() {
        this.input.remove();
        this.button.remove();
        this.element.html($('<option value="" selected="selected"></option>'));
        this.element.show();
        this.filtering_select.remove();
        $.Widget.prototype.destroy.call(this);
      }
    });
  })(import_jquery6.default);

  // node_modules/rails_admin/src/rails_admin/nested-form-hooks.js
  var import_jquery7 = __toESM(require_jquery());
  (function($) {
    $(document).ready(function() {
      return window.nestedFormEvents.insertFields = function(content, assoc, link) {
        var tab_content;
        tab_content = $(link).closest(".controls").siblings(".tab-content");
        tab_content.append(content);
        return tab_content.children().last();
      };
    });
    $(document).on("nested:fieldAdded", "form", function(content) {
      var controls, field, nav, new_tab, one_to_one, parent_group, toggler;
      field = content.field.addClass("tab-pane").attr("id", "unique-id-" + (/* @__PURE__ */ new Date()).getTime());
      new_tab = $("<li></li>").append(
        $("<a></a>").addClass("nav-link").attr("data-bs-toggle", "tab").attr("href", "#" + field.attr("id")).text(field.children(".object-infos").data("object-label"))
      ).addClass("nav-item");
      parent_group = field.closest(".control-group");
      controls = parent_group.children(".controls");
      one_to_one = controls.data("nestedone") !== void 0;
      nav = controls.children(".nav");
      content = parent_group.children(".tab-content");
      toggler = controls.find(".toggler");
      nav.append(new_tab);
      const event = new CustomEvent("rails_admin.dom_ready", { detail: field });
      document.dispatchEvent(event);
      new_tab.children("a").each(function(index, element) {
        Tab.getOrCreateInstance(element).show();
      });
      if (!one_to_one) {
        new Collapse(nav[0], { toggle: false }).show();
      }
      new Collapse(content[0], { toggle: false }).show();
      toggler.addClass("active").removeClass("disabled").children("i").addClass("fa-chevron-down").removeClass("fa-chevron-right");
      if (one_to_one) {
        controls.find(".add_nested_fields").removeClass("add_nested_fields").text(field.children(".object-infos").data("object-label"));
      }
    });
    $(document).on("nested:fieldRemoved", "form", function(content) {
      var add_button, controls, current_li, field, nav, one_to_one, parent_group, toggler;
      field = content.field;
      nav = field.closest(".control-group").children(".controls").children(".nav");
      current_li = nav.children("li").has('a[href="#' + field.attr("id") + '"]');
      parent_group = field.closest(".control-group");
      controls = parent_group.children(".controls");
      one_to_one = controls.data("nestedone") !== void 0;
      toggler = controls.find(".toggler");
      (current_li.next().length ? current_li.next() : current_li.prev()).children("a:first").each(function(index, element) {
        Tab.getOrCreateInstance(element).show();
      });
      current_li.remove();
      if (nav.children().length === 0) {
        new Collapse(controls.siblings(".tab-content")[0], {
          toggle: false
        }).hide();
        toggler.removeClass("active").addClass("disabled").children("i").removeClass("fa-chevron-down").addClass("fa-chevron-right");
      }
      if (one_to_one) {
        add_button = toggler.next();
        add_button.addClass("add_nested_fields").html(add_button.data("add-label"));
      }
      field.find("[required]").each(function() {
        $(this).prop("required", false);
      });
    });
  })(import_jquery7.default);

  // node_modules/rails_admin/src/rails_admin/remote-form.js
  var import_ujs = __toESM(require_rails_ujs());
  var import_jquery8 = __toESM(require_jquery());
  (function($) {
    $.widget("ra.remoteForm", {
      _create: function() {
        var widget = this;
        var dom_widget = widget.element;
        var edit_url = dom_widget.find("select").first().data("options") && dom_widget.find("select").first().data("options")["edit-url"];
        if (typeof edit_url != "undefined" && edit_url.length) {
          dom_widget.on(
            "dblclick",
            ".ra-multiselect option:not(:disabled)",
            function(e) {
              widget._bindModalOpening(e, edit_url.replace("__ID__", this.value));
            }
          );
        }
        dom_widget.find(".create").unbind().bind("click", function(e) {
          widget._bindModalOpening(e, $(this).data("link"));
        });
        dom_widget.find(".update").unbind().bind("click", function(e) {
          var value = dom_widget.find("select").val();
          if (value) {
            widget._bindModalOpening(
              e,
              $(this).data("link").replace("__ID__", value)
            );
          } else {
            e.preventDefault();
          }
        });
      },
      _bindModalOpening: function(e, url) {
        e.preventDefault();
        var widget = this;
        if ($("#modal").length) return false;
        var dialog = this._getModal();
        setTimeout(function() {
          $.ajax({
            url,
            beforeSend: function(xhr) {
              xhr.setRequestHeader("Accept", "text/javascript");
            },
            success: function(data, status, xhr) {
              dialog.find(".modal-body").html(data);
              widget._bindFormEvents();
            },
            error: function(xhr, status, error) {
              dialog.find(".modal-body").html(xhr.responseText);
            },
            dataType: "text"
          });
        }, 200);
      },
      _bindFormEvents: function() {
        var widget = this, dialog = this._getModal(), form = dialog.find("form"), saveButtonText = dialog.find(":submit[name=_save]").html(), cancelButtonText = dialog.find(":submit[name=_continue]").html();
        dialog.find(".form-actions").remove();
        form.attr("data-remote", true).attr("data-type", "json");
        dialog.find(".modal-header-title").text(form.data("title"));
        dialog.find(".cancel-action").unbind().click(function() {
          dialog.each(function(index, element) {
            Modal.getInstance(element).hide();
          });
          return false;
        }).html(cancelButtonText);
        dialog.find(".save-action").unbind().click(function() {
          import_ujs.default.fire(form[0], "submit");
          return false;
        }).html(saveButtonText);
        const event = new CustomEvent("rails_admin.dom_ready", { detail: form });
        document.dispatchEvent(event);
        form.bind("ajax:complete", function(event2) {
          var data = event2.detail[0];
          if (data.status == 200) {
            var json = $.parseJSON(data.responseText);
            var option = '<option value="' + json.id + '" selected>' + json.label + "</option>";
            var select = widget.element.find("select").filter(":hidden");
            if (widget.element.find(".filtering-select").length) {
              var input = widget.element.find(".filtering-select").children(".ra-filtering-select-input");
              input.val(json.label);
              if (!select.find("option[value=" + json.id + "]").length) {
                select.html(option).val(json.id);
                widget.element.find(".update").removeClass("disabled");
              }
            } else {
              var multiselect = widget.element.find(".ra-multiselect");
              if (multiselect.find("option[value=" + json.id + "]").length) {
                select.find("option[value=" + json.id + "]").text(json.label);
                multiselect.find("option[value= " + json.id + "]").text(json.label);
              } else {
                select.append(option);
                multiselect.find("select.ra-multiselect-selection").append(option);
              }
            }
            widget._trigger("success");
            dialog.each(function(index, element) {
              Modal.getInstance(element).hide();
            });
          } else {
            dialog.find(".modal-body").html(data.responseText);
            widget._bindFormEvents();
          }
        });
      },
      _getModal: function() {
        var widget = this;
        if (!widget.dialog) {
          widget.dialog = $(
            '<div id="modal" class="modal fade">            <div class="modal-dialog modal-lg">            <div class="modal-content">            <div class="modal-header">              <h3 class="modal-header-title">...</h3>              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>            </div>            <div class="modal-body">              ...            </div>            <div class="modal-footer">              <a href="#" class="btn cancel-action">...</a>              <a href="#" class="btn btn-primary save-action">...</a>            </div>            </div>            </div>          </div>'
          ).on("hidden.bs.modal", function() {
            widget.dialog.remove();
            widget.dialog = null;
          });
          new Modal(widget.dialog[0], {
            keyboard: true,
            backdrop: true,
            focus: false,
            show: true
          }).show();
        }
        return this.dialog;
      }
    });
  })(import_jquery8.default);

  // node_modules/rails_admin/src/rails_admin/sidescroll.js
  {
    document.addEventListener("rails_admin.dom_ready", () => {
      const scroller = document.getElementById("sidescroll");
      if (!scroller) {
        return;
      }
      scroller.querySelectorAll("tr").forEach((tr, index) => {
        let firstPosition;
        tr.querySelectorAll("th.sticky, td.sticky").forEach((td, idx) => {
          if (idx === 0) {
            firstPosition = td.offsetLeft;
          }
          td.style.left = `${td.offsetLeft - firstPosition}px`;
        });
      });
    });
  }

  // node_modules/rails_admin/src/rails_admin/ui.js
  var import_jquery9 = __toESM(require_jquery());

  // node_modules/jquery-ui/ui/effect.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define([
        "jquery",
        "./jquery-var-for-color",
        "./vendor/jquery-color/jquery.color",
        "./version"
      ], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    var dataSpace = "ui-effects-", dataSpaceStyle = "ui-effects-style", dataSpaceAnimated = "ui-effects-animated";
    $.effects = {
      effect: {}
    };
    (function() {
      var classAnimationActions = ["add", "remove", "toggle"], shorthandStyles = {
        border: 1,
        borderBottom: 1,
        borderColor: 1,
        borderLeft: 1,
        borderRight: 1,
        borderTop: 1,
        borderWidth: 1,
        margin: 1,
        padding: 1
      };
      $.each(
        ["borderLeftStyle", "borderRightStyle", "borderBottomStyle", "borderTopStyle"],
        function(_, prop) {
          $.fx.step[prop] = function(fx) {
            if (fx.end !== "none" && !fx.setAttr || fx.pos === 1 && !fx.setAttr) {
              jQuery.style(fx.elem, prop, fx.end);
              fx.setAttr = true;
            }
          };
        }
      );
      function camelCase(string) {
        return string.replace(/-([\da-z])/gi, function(all, letter) {
          return letter.toUpperCase();
        });
      }
      function getElementStyles(elem) {
        var key, len, style = elem.ownerDocument.defaultView ? elem.ownerDocument.defaultView.getComputedStyle(elem, null) : elem.currentStyle, styles = {};
        if (style && style.length && style[0] && style[style[0]]) {
          len = style.length;
          while (len--) {
            key = style[len];
            if (typeof style[key] === "string") {
              styles[camelCase(key)] = style[key];
            }
          }
        } else {
          for (key in style) {
            if (typeof style[key] === "string") {
              styles[key] = style[key];
            }
          }
        }
        return styles;
      }
      function styleDifference(oldStyle, newStyle) {
        var diff = {}, name, value;
        for (name in newStyle) {
          value = newStyle[name];
          if (oldStyle[name] !== value) {
            if (!shorthandStyles[name]) {
              if ($.fx.step[name] || !isNaN(parseFloat(value))) {
                diff[name] = value;
              }
            }
          }
        }
        return diff;
      }
      if (!$.fn.addBack) {
        $.fn.addBack = function(selector) {
          return this.add(
            selector == null ? this.prevObject : this.prevObject.filter(selector)
          );
        };
      }
      $.effects.animateClass = function(value, duration2, easing, callback) {
        var o = $.speed(duration2, easing, callback);
        return this.queue(function() {
          var animated = $(this), baseClass = animated.attr("class") || "", applyClassChange, allAnimations = o.children ? animated.find("*").addBack() : animated;
          allAnimations = allAnimations.map(function() {
            var el = $(this);
            return {
              el,
              start: getElementStyles(this)
            };
          });
          applyClassChange = function() {
            $.each(classAnimationActions, function(i, action) {
              if (value[action]) {
                animated[action + "Class"](value[action]);
              }
            });
          };
          applyClassChange();
          allAnimations = allAnimations.map(function() {
            this.end = getElementStyles(this.el[0]);
            this.diff = styleDifference(this.start, this.end);
            return this;
          });
          animated.attr("class", baseClass);
          allAnimations = allAnimations.map(function() {
            var styleInfo = this, dfd = $.Deferred(), opts = $.extend({}, o, {
              queue: false,
              complete: function() {
                dfd.resolve(styleInfo);
              }
            });
            this.el.animate(this.diff, opts);
            return dfd.promise();
          });
          $.when.apply($, allAnimations.get()).done(function() {
            applyClassChange();
            $.each(arguments, function() {
              var el = this.el;
              $.each(this.diff, function(key) {
                el.css(key, "");
              });
            });
            o.complete.call(animated[0]);
          });
        });
      };
      $.fn.extend({
        addClass: /* @__PURE__ */ function(orig) {
          return function(classNames, speed, easing, callback) {
            return speed ? $.effects.animateClass.call(
              this,
              { add: classNames },
              speed,
              easing,
              callback
            ) : orig.apply(this, arguments);
          };
        }($.fn.addClass),
        removeClass: /* @__PURE__ */ function(orig) {
          return function(classNames, speed, easing, callback) {
            return arguments.length > 1 ? $.effects.animateClass.call(
              this,
              { remove: classNames },
              speed,
              easing,
              callback
            ) : orig.apply(this, arguments);
          };
        }($.fn.removeClass),
        toggleClass: /* @__PURE__ */ function(orig) {
          return function(classNames, force, speed, easing, callback) {
            if (typeof force === "boolean" || force === void 0) {
              if (!speed) {
                return orig.apply(this, arguments);
              } else {
                return $.effects.animateClass.call(
                  this,
                  force ? { add: classNames } : { remove: classNames },
                  speed,
                  easing,
                  callback
                );
              }
            } else {
              return $.effects.animateClass.call(
                this,
                { toggle: classNames },
                force,
                speed,
                easing
              );
            }
          };
        }($.fn.toggleClass),
        switchClass: function(remove, add, speed, easing, callback) {
          return $.effects.animateClass.call(this, {
            add,
            remove
          }, speed, easing, callback);
        }
      });
    })();
    (function() {
      if ($.expr && $.expr.pseudos && $.expr.pseudos.animated) {
        $.expr.pseudos.animated = /* @__PURE__ */ function(orig) {
          return function(elem) {
            return !!$(elem).data(dataSpaceAnimated) || orig(elem);
          };
        }($.expr.pseudos.animated);
      }
      if ($.uiBackCompat !== false) {
        $.extend($.effects, {
          // Saves a set of properties in a data storage
          save: function(element, set) {
            var i = 0, length = set.length;
            for (; i < length; i++) {
              if (set[i] !== null) {
                element.data(dataSpace + set[i], element[0].style[set[i]]);
              }
            }
          },
          // Restores a set of previously saved properties from a data storage
          restore: function(element, set) {
            var val, i = 0, length = set.length;
            for (; i < length; i++) {
              if (set[i] !== null) {
                val = element.data(dataSpace + set[i]);
                element.css(set[i], val);
              }
            }
          },
          setMode: function(el, mode) {
            if (mode === "toggle") {
              mode = el.is(":hidden") ? "show" : "hide";
            }
            return mode;
          },
          // Wraps the element around a wrapper that copies position properties
          createWrapper: function(element) {
            if (element.parent().is(".ui-effects-wrapper")) {
              return element.parent();
            }
            var props = {
              width: element.outerWidth(true),
              height: element.outerHeight(true),
              "float": element.css("float")
            }, wrapper = $("<div></div>").addClass("ui-effects-wrapper").css({
              fontSize: "100%",
              background: "transparent",
              border: "none",
              margin: 0,
              padding: 0
            }), size = {
              width: element.width(),
              height: element.height()
            }, active = document.activeElement;
            try {
              active.id;
            } catch (e) {
              active = document.body;
            }
            element.wrap(wrapper);
            if (element[0] === active || $.contains(element[0], active)) {
              $(active).trigger("focus");
            }
            wrapper = element.parent();
            if (element.css("position") === "static") {
              wrapper.css({ position: "relative" });
              element.css({ position: "relative" });
            } else {
              $.extend(props, {
                position: element.css("position"),
                zIndex: element.css("z-index")
              });
              $.each(["top", "left", "bottom", "right"], function(i, pos) {
                props[pos] = element.css(pos);
                if (isNaN(parseInt(props[pos], 10))) {
                  props[pos] = "auto";
                }
              });
              element.css({
                position: "relative",
                top: 0,
                left: 0,
                right: "auto",
                bottom: "auto"
              });
            }
            element.css(size);
            return wrapper.css(props).show();
          },
          removeWrapper: function(element) {
            var active = document.activeElement;
            if (element.parent().is(".ui-effects-wrapper")) {
              element.parent().replaceWith(element);
              if (element[0] === active || $.contains(element[0], active)) {
                $(active).trigger("focus");
              }
            }
            return element;
          }
        });
      }
      $.extend($.effects, {
        version: "1.13.3",
        define: function(name, mode, effect4) {
          if (!effect4) {
            effect4 = mode;
            mode = "effect";
          }
          $.effects.effect[name] = effect4;
          $.effects.effect[name].mode = mode;
          return effect4;
        },
        scaledDimensions: function(element, percent, direction) {
          if (percent === 0) {
            return {
              height: 0,
              width: 0,
              outerHeight: 0,
              outerWidth: 0
            };
          }
          var x = direction !== "horizontal" ? (percent || 100) / 100 : 1, y = direction !== "vertical" ? (percent || 100) / 100 : 1;
          return {
            height: element.height() * y,
            width: element.width() * x,
            outerHeight: element.outerHeight() * y,
            outerWidth: element.outerWidth() * x
          };
        },
        clipToBox: function(animation) {
          return {
            width: animation.clip.right - animation.clip.left,
            height: animation.clip.bottom - animation.clip.top,
            left: animation.clip.left,
            top: animation.clip.top
          };
        },
        // Injects recently queued functions to be first in line (after "inprogress")
        unshift: function(element, queueLength, count) {
          var queue = element.queue();
          if (queueLength > 1) {
            queue.splice.apply(
              queue,
              [1, 0].concat(queue.splice(queueLength, count))
            );
          }
          element.dequeue();
        },
        saveStyle: function(element) {
          element.data(dataSpaceStyle, element[0].style.cssText);
        },
        restoreStyle: function(element) {
          element[0].style.cssText = element.data(dataSpaceStyle) || "";
          element.removeData(dataSpaceStyle);
        },
        mode: function(element, mode) {
          var hidden = element.is(":hidden");
          if (mode === "toggle") {
            mode = hidden ? "show" : "hide";
          }
          if (hidden ? mode === "hide" : mode === "show") {
            mode = "none";
          }
          return mode;
        },
        // Translates a [top,left] array into a baseline value
        getBaseline: function(origin, original) {
          var y, x;
          switch (origin[0]) {
            case "top":
              y = 0;
              break;
            case "middle":
              y = 0.5;
              break;
            case "bottom":
              y = 1;
              break;
            default:
              y = origin[0] / original.height;
          }
          switch (origin[1]) {
            case "left":
              x = 0;
              break;
            case "center":
              x = 0.5;
              break;
            case "right":
              x = 1;
              break;
            default:
              x = origin[1] / original.width;
          }
          return {
            x,
            y
          };
        },
        // Creates a placeholder element so that the original element can be made absolute
        createPlaceholder: function(element) {
          var placeholder, cssPosition = element.css("position"), position = element.position();
          element.css({
            marginTop: element.css("marginTop"),
            marginBottom: element.css("marginBottom"),
            marginLeft: element.css("marginLeft"),
            marginRight: element.css("marginRight")
          }).outerWidth(element.outerWidth()).outerHeight(element.outerHeight());
          if (/^(static|relative)/.test(cssPosition)) {
            cssPosition = "absolute";
            placeholder = $("<" + element[0].nodeName + ">").insertAfter(element).css({
              // Convert inline to inline block to account for inline elements
              // that turn to inline block based on content (like img)
              display: /^(inline|ruby)/.test(element.css("display")) ? "inline-block" : "block",
              visibility: "hidden",
              // Margins need to be set to account for margin collapse
              marginTop: element.css("marginTop"),
              marginBottom: element.css("marginBottom"),
              marginLeft: element.css("marginLeft"),
              marginRight: element.css("marginRight"),
              "float": element.css("float")
            }).outerWidth(element.outerWidth()).outerHeight(element.outerHeight()).addClass("ui-effects-placeholder");
            element.data(dataSpace + "placeholder", placeholder);
          }
          element.css({
            position: cssPosition,
            left: position.left,
            top: position.top
          });
          return placeholder;
        },
        removePlaceholder: function(element) {
          var dataKey = dataSpace + "placeholder", placeholder = element.data(dataKey);
          if (placeholder) {
            placeholder.remove();
            element.removeData(dataKey);
          }
        },
        // Removes a placeholder if it exists and restores
        // properties that were modified during placeholder creation
        cleanUp: function(element) {
          $.effects.restoreStyle(element);
          $.effects.removePlaceholder(element);
        },
        setTransition: function(element, list, factor, value) {
          value = value || {};
          $.each(list, function(i, x) {
            var unit = element.cssUnit(x);
            if (unit[0] > 0) {
              value[x] = unit[0] * factor + unit[1];
            }
          });
          return value;
        }
      });
      function _normalizeArguments(effect4, options, speed, callback) {
        if ($.isPlainObject(effect4)) {
          options = effect4;
          effect4 = effect4.effect;
        }
        effect4 = { effect: effect4 };
        if (options == null) {
          options = {};
        }
        if (typeof options === "function") {
          callback = options;
          speed = null;
          options = {};
        }
        if (typeof options === "number" || $.fx.speeds[options]) {
          callback = speed;
          speed = options;
          options = {};
        }
        if (typeof speed === "function") {
          callback = speed;
          speed = null;
        }
        if (options) {
          $.extend(effect4, options);
        }
        speed = speed || options.duration;
        effect4.duration = $.fx.off ? 0 : typeof speed === "number" ? speed : speed in $.fx.speeds ? $.fx.speeds[speed] : $.fx.speeds._default;
        effect4.complete = callback || options.complete;
        return effect4;
      }
      function standardAnimationOption(option) {
        if (!option || typeof option === "number" || $.fx.speeds[option]) {
          return true;
        }
        if (typeof option === "string" && !$.effects.effect[option]) {
          return true;
        }
        if (typeof option === "function") {
          return true;
        }
        if (typeof option === "object" && !option.effect) {
          return true;
        }
        return false;
      }
      $.fn.extend({
        effect: function() {
          var args = _normalizeArguments.apply(this, arguments), effectMethod = $.effects.effect[args.effect], defaultMode = effectMethod.mode, queue = args.queue, queueName = queue || "fx", complete = args.complete, mode = args.mode, modes = [], prefilter = function(next) {
            var el = $(this), normalizedMode = $.effects.mode(el, mode) || defaultMode;
            el.data(dataSpaceAnimated, true);
            modes.push(normalizedMode);
            if (defaultMode && (normalizedMode === "show" || normalizedMode === defaultMode && normalizedMode === "hide")) {
              el.show();
            }
            if (!defaultMode || normalizedMode !== "none") {
              $.effects.saveStyle(el);
            }
            if (typeof next === "function") {
              next();
            }
          };
          if ($.fx.off || !effectMethod) {
            if (mode) {
              return this[mode](args.duration, complete);
            } else {
              return this.each(function() {
                if (complete) {
                  complete.call(this);
                }
              });
            }
          }
          function run(next) {
            var elem = $(this);
            function cleanup() {
              elem.removeData(dataSpaceAnimated);
              $.effects.cleanUp(elem);
              if (args.mode === "hide") {
                elem.hide();
              }
              done();
            }
            function done() {
              if (typeof complete === "function") {
                complete.call(elem[0]);
              }
              if (typeof next === "function") {
                next();
              }
            }
            args.mode = modes.shift();
            if ($.uiBackCompat !== false && !defaultMode) {
              if (elem.is(":hidden") ? mode === "hide" : mode === "show") {
                elem[mode]();
                done();
              } else {
                effectMethod.call(elem[0], args, done);
              }
            } else {
              if (args.mode === "none") {
                elem[mode]();
                done();
              } else {
                effectMethod.call(elem[0], args, cleanup);
              }
            }
          }
          return queue === false ? this.each(prefilter).each(run) : this.queue(queueName, prefilter).queue(queueName, run);
        },
        show: /* @__PURE__ */ function(orig) {
          return function(option) {
            if (standardAnimationOption(option)) {
              return orig.apply(this, arguments);
            } else {
              var args = _normalizeArguments.apply(this, arguments);
              args.mode = "show";
              return this.effect.call(this, args);
            }
          };
        }($.fn.show),
        hide: /* @__PURE__ */ function(orig) {
          return function(option) {
            if (standardAnimationOption(option)) {
              return orig.apply(this, arguments);
            } else {
              var args = _normalizeArguments.apply(this, arguments);
              args.mode = "hide";
              return this.effect.call(this, args);
            }
          };
        }($.fn.hide),
        toggle: /* @__PURE__ */ function(orig) {
          return function(option) {
            if (standardAnimationOption(option) || typeof option === "boolean") {
              return orig.apply(this, arguments);
            } else {
              var args = _normalizeArguments.apply(this, arguments);
              args.mode = "toggle";
              return this.effect.call(this, args);
            }
          };
        }($.fn.toggle),
        cssUnit: function(key) {
          var style = this.css(key), val = [];
          $.each(["em", "px", "%", "pt"], function(i, unit) {
            if (style.indexOf(unit) > 0) {
              val = [parseFloat(style), unit];
            }
          });
          return val;
        },
        cssClip: function(clipObj) {
          if (clipObj) {
            return this.css("clip", "rect(" + clipObj.top + "px " + clipObj.right + "px " + clipObj.bottom + "px " + clipObj.left + "px)");
          }
          return parseClip(this.css("clip"), this);
        },
        transfer: function(options, done) {
          var element = $(this), target = $(options.to), targetFixed = target.css("position") === "fixed", body = $("body"), fixTop = targetFixed ? body.scrollTop() : 0, fixLeft = targetFixed ? body.scrollLeft() : 0, endPosition = target.offset(), animation = {
            top: endPosition.top - fixTop,
            left: endPosition.left - fixLeft,
            height: target.innerHeight(),
            width: target.innerWidth()
          }, startPosition = element.offset(), transfer = $("<div class='ui-effects-transfer'></div>");
          transfer.appendTo("body").addClass(options.className).css({
            top: startPosition.top - fixTop,
            left: startPosition.left - fixLeft,
            height: element.innerHeight(),
            width: element.innerWidth(),
            position: targetFixed ? "fixed" : "absolute"
          }).animate(animation, options.duration, options.easing, function() {
            transfer.remove();
            if (typeof done === "function") {
              done();
            }
          });
        }
      });
      function parseClip(str, element) {
        var outerWidth = element.outerWidth(), outerHeight = element.outerHeight(), clipRegex = /^rect\((-?\d*\.?\d*px|-?\d+%|auto),?\s*(-?\d*\.?\d*px|-?\d+%|auto),?\s*(-?\d*\.?\d*px|-?\d+%|auto),?\s*(-?\d*\.?\d*px|-?\d+%|auto)\)$/, values = clipRegex.exec(str) || ["", 0, outerWidth, outerHeight, 0];
        return {
          top: parseFloat(values[1]) || 0,
          right: values[2] === "auto" ? outerWidth : parseFloat(values[2]),
          bottom: values[3] === "auto" ? outerHeight : parseFloat(values[3]),
          left: parseFloat(values[4]) || 0
        };
      }
      $.fx.step.clip = function(fx) {
        if (!fx.clipInit) {
          fx.start = $(fx.elem).cssClip();
          if (typeof fx.end === "string") {
            fx.end = parseClip(fx.end, fx.elem);
          }
          fx.clipInit = true;
        }
        $(fx.elem).cssClip({
          top: fx.pos * (fx.end.top - fx.start.top) + fx.start.top,
          right: fx.pos * (fx.end.right - fx.start.right) + fx.start.right,
          bottom: fx.pos * (fx.end.bottom - fx.start.bottom) + fx.start.bottom,
          left: fx.pos * (fx.end.left - fx.start.left) + fx.start.left
        });
      };
    })();
    (function() {
      var baseEasings = {};
      $.each(["Quad", "Cubic", "Quart", "Quint", "Expo"], function(i, name) {
        baseEasings[name] = function(p) {
          return Math.pow(p, i + 2);
        };
      });
      $.extend(baseEasings, {
        Sine: function(p) {
          return 1 - Math.cos(p * Math.PI / 2);
        },
        Circ: function(p) {
          return 1 - Math.sqrt(1 - p * p);
        },
        Elastic: function(p) {
          return p === 0 || p === 1 ? p : -Math.pow(2, 8 * (p - 1)) * Math.sin(((p - 1) * 80 - 7.5) * Math.PI / 15);
        },
        Back: function(p) {
          return p * p * (3 * p - 2);
        },
        Bounce: function(p) {
          var pow2, bounce = 4;
          while (p < ((pow2 = Math.pow(2, --bounce)) - 1) / 11) {
          }
          return 1 / Math.pow(4, 3 - bounce) - 7.5625 * Math.pow((pow2 * 3 - 2) / 22 - p, 2);
        }
      });
      $.each(baseEasings, function(name, easeIn) {
        $.easing["easeIn" + name] = easeIn;
        $.easing["easeOut" + name] = function(p) {
          return 1 - easeIn(1 - p);
        };
        $.easing["easeInOut" + name] = function(p) {
          return p < 0.5 ? easeIn(p * 2) / 2 : 1 - easeIn(p * -2 + 2) / 2;
        };
      });
    })();
    return $.effects;
  });

  // node_modules/rails_admin/src/rails_admin/ui.js
  (function($) {
    $(document).on("click", "#list input.toggle", function() {
      $("#list [name='bulk_ids[]']").prop("checked", $(this).is(":checked"));
    });
    $(document).on("turbo:click", function() {
      $("#loading").show();
    }).on("turbo:before-render", function(event) {
      document.querySelectorAll('.sidebar .btn-toggle[aria-expanded="false"]').forEach((element) => {
        const newButton = event.detail.newBody.querySelector(
          `.sidebar [data-bs-target="${element.dataset.bsTarget}"]`
        );
        const newMenu = event.detail.newBody.querySelector(
          element.dataset.bsTarget
        );
        if (newButton) {
          newButton.parentNode.replaceChild(
            element.cloneNode(true),
            newButton
          );
        }
        if (newMenu) {
          newMenu.classList.remove("show");
        }
      });
      $("#loading").hide();
    });
    $(document).on("click", "[data-bs-target]", function() {
      if (!$(this).hasClass("disabled")) {
        if ($(this).has("i.fa-chevron-down").length) {
          $(this).removeClass("active").children("i").toggleClass("fa-chevron-down fa-chevron-right");
          $($(this).data("target")).filter(":visible").hide("slow");
        } else {
          if ($(this).has("i.fa-chevron-right").length) {
            $(this).addClass("active").children("i").toggleClass("fa-chevron-down fa-chevron-right");
            $($(this).data("target")).filter(":hidden").show("slow");
          }
        }
      }
    });
    $(document).on("click", "form legend", function() {
      if ($(this).has("i.fa-chevron-down").length) {
        $(this).siblings(".control-group:visible").hide("slow");
        $(this).children("i").toggleClass("fa-chevron-down fa-chevron-right");
      } else {
        if ($(this).has("i.fa-chevron-right").length) {
          $(this).siblings(".control-group:hidden").show("slow");
          $(this).children("i").toggleClass("fa-chevron-down fa-chevron-right");
        }
      }
    });
    $(document).on(
      "click",
      "form .tab-content .tab-pane a.remove_nested_one_fields",
      function() {
        $(this).children('input[type="hidden"]').val($(this).hasClass("active")).siblings("i").toggleClass("fa-check fa-trash");
      }
    );
    function triggerDomReady() {
      I18n.init($("html").attr("lang"), $("#admin-js").data("i18nOptions"));
      const event = new CustomEvent("rails_admin.dom_ready");
      document.dispatchEvent(event);
    }
    $(document).ready(triggerDomReady);
    document.addEventListener("turbo:render", triggerDomReady);
    document.addEventListener("rails_admin.dom_ready", function(event) {
      $(".nav.nav-pills li.active").removeClass("active");
      $(
        '.nav.nav-pills li[data-model="' + $(".page-header").data("model") + '"]'
      ).addClass("active");
      $(".animate-width-to").each(function() {
        var length, width;
        length = $(this).data("animate-length");
        width = $(this).data("animate-width-to");
        $(this).animate(
          {
            width
          },
          length,
          "easeOutQuad"
        );
      });
      $("form.main legend").has("i.fa-chevron-right").each(function() {
        $(this).siblings(".control-group").hide();
      });
      $('button[name][type="submit"]').on("click", function() {
        var form = $(this).closest("form");
        form.append(
          $("<input />").attr("type", "hidden").attr("name", $(this).attr("name")).attr("value", $(this).attr("value"))
        );
        if ($(this).is("[formnovalidate]")) {
          form.attr("novalidate", true);
        }
      });
      $.each($("#filters_box").data("options"), function() {
        $.filters.append(this);
      });
      $("a[data-method]").on("click", function(event2) {
        window.Turbo.session.drive = false;
      });
      $(document).trigger(
        "rails_admin.dom_ready",
        event.detail ? [event.detail] : null
      );
    });
    $(document).on("click", ".bulk-link", function(event) {
      event.preventDefault();
      $("#bulk_action").val($(this).data("action"));
      $("#bulk_form").submit();
    });
    $(document).on("click", "#remove_filter", function(event) {
      event.preventDefault();
      $("#filters_box").html("");
      $("hr.filters_box").hide();
      $(this).siblings("input[type='search']").val("");
      $(this).parents("form").submit();
    });
    $(document).on("click", "th.header", function(event) {
      event.preventDefault();
      window.Turbo.visit($(this).data("href"));
    });
    $(document).on(
      "click",
      "#fields_to_export label input#check_all",
      function() {
        var elems;
        elems = $("#fields_to_export label input");
        if ($("#fields_to_export label input#check_all").is(":checked")) {
          $(elems).prop("checked", true);
        } else {
          $(elems).prop("checked", false);
        }
      }
    );
    $(document).on("click", "#fields_to_export .reverse-selection", function() {
      $(this).closest(".control-group").find(".controls").find("input").click();
    });
  })(import_jquery9.default);

  // node_modules/rails_admin/src/rails_admin/widgets.js
  var import_jquery10 = __toESM(require_jquery());

  // node_modules/jquery-ui/ui/widgets/sortable.js
  (function(factory) {
    "use strict";
    if (typeof define === "function" && define.amd) {
      define([
        "jquery",
        "./mouse",
        "../data",
        "../ie",
        "../scroll-parent",
        "../version",
        "../widget"
      ], factory);
    } else {
      factory(jQuery);
    }
  })(function($) {
    "use strict";
    return $.widget("ui.sortable", $.ui.mouse, {
      version: "1.13.3",
      widgetEventPrefix: "sort",
      ready: false,
      options: {
        appendTo: "parent",
        axis: false,
        connectWith: false,
        containment: false,
        cursor: "auto",
        cursorAt: false,
        dropOnEmpty: true,
        forcePlaceholderSize: false,
        forceHelperSize: false,
        grid: false,
        handle: false,
        helper: "original",
        items: "> *",
        opacity: false,
        placeholder: false,
        revert: false,
        scroll: true,
        scrollSensitivity: 20,
        scrollSpeed: 20,
        scope: "default",
        tolerance: "intersect",
        zIndex: 1e3,
        // Callbacks
        activate: null,
        beforeStop: null,
        change: null,
        deactivate: null,
        out: null,
        over: null,
        receive: null,
        remove: null,
        sort: null,
        start: null,
        stop: null,
        update: null
      },
      _isOverAxis: function(x, reference2, size) {
        return x >= reference2 && x < reference2 + size;
      },
      _isFloating: function(item) {
        return /left|right/.test(item.css("float")) || /inline|table-cell/.test(item.css("display"));
      },
      _create: function() {
        this.containerCache = {};
        this._addClass("ui-sortable");
        this.refresh();
        this.offset = this.element.offset();
        this._mouseInit();
        this._setHandleClassName();
        this.ready = true;
      },
      _setOption: function(key, value) {
        this._super(key, value);
        if (key === "handle") {
          this._setHandleClassName();
        }
      },
      _setHandleClassName: function() {
        var that = this;
        this._removeClass(this.element.find(".ui-sortable-handle"), "ui-sortable-handle");
        $.each(this.items, function() {
          that._addClass(
            this.instance.options.handle ? this.item.find(this.instance.options.handle) : this.item,
            "ui-sortable-handle"
          );
        });
      },
      _destroy: function() {
        this._mouseDestroy();
        for (var i = this.items.length - 1; i >= 0; i--) {
          this.items[i].item.removeData(this.widgetName + "-item");
        }
        return this;
      },
      _mouseCapture: function(event, overrideHandle) {
        var currentItem = null, validHandle = false, that = this;
        if (this.reverting) {
          return false;
        }
        if (this.options.disabled || this.options.type === "static") {
          return false;
        }
        this._refreshItems(event);
        $(event.target).parents().each(function() {
          if ($.data(this, that.widgetName + "-item") === that) {
            currentItem = $(this);
            return false;
          }
        });
        if ($.data(event.target, that.widgetName + "-item") === that) {
          currentItem = $(event.target);
        }
        if (!currentItem) {
          return false;
        }
        if (this.options.handle && !overrideHandle) {
          $(this.options.handle, currentItem).find("*").addBack().each(function() {
            if (this === event.target) {
              validHandle = true;
            }
          });
          if (!validHandle) {
            return false;
          }
        }
        this.currentItem = currentItem;
        this._removeCurrentsFromItems();
        return true;
      },
      _mouseStart: function(event, overrideHandle, noActivation) {
        var i, body, o = this.options;
        this.currentContainer = this;
        this.refreshPositions();
        this.appendTo = $(o.appendTo !== "parent" ? o.appendTo : this.currentItem.parent());
        this.helper = this._createHelper(event);
        this._cacheHelperProportions();
        this._cacheMargins();
        this.offset = this.currentItem.offset();
        this.offset = {
          top: this.offset.top - this.margins.top,
          left: this.offset.left - this.margins.left
        };
        $.extend(this.offset, {
          click: {
            //Where the click happened, relative to the element
            left: event.pageX - this.offset.left,
            top: event.pageY - this.offset.top
          },
          // This is a relative to absolute position minus the actual position calculation -
          // only used for relative positioned helper
          relative: this._getRelativeOffset()
        });
        this.helper.css("position", "absolute");
        this.cssPosition = this.helper.css("position");
        if (o.cursorAt) {
          this._adjustOffsetFromHelper(o.cursorAt);
        }
        this.domPosition = {
          prev: this.currentItem.prev()[0],
          parent: this.currentItem.parent()[0]
        };
        if (this.helper[0] !== this.currentItem[0]) {
          this.currentItem.hide();
        }
        this._createPlaceholder();
        this.scrollParent = this.placeholder.scrollParent();
        $.extend(this.offset, {
          parent: this._getParentOffset()
        });
        if (o.containment) {
          this._setContainment();
        }
        if (o.cursor && o.cursor !== "auto") {
          body = this.document.find("body");
          this.storedCursor = body.css("cursor");
          body.css("cursor", o.cursor);
          this.storedStylesheet = $("<style>*{ cursor: " + o.cursor + " !important; }</style>").appendTo(body);
        }
        if (o.zIndex) {
          if (this.helper.css("zIndex")) {
            this._storedZIndex = this.helper.css("zIndex");
          }
          this.helper.css("zIndex", o.zIndex);
        }
        if (o.opacity) {
          if (this.helper.css("opacity")) {
            this._storedOpacity = this.helper.css("opacity");
          }
          this.helper.css("opacity", o.opacity);
        }
        if (this.scrollParent[0] !== this.document[0] && this.scrollParent[0].tagName !== "HTML") {
          this.overflowOffset = this.scrollParent.offset();
        }
        this._trigger("start", event, this._uiHash());
        if (!this._preserveHelperProportions) {
          this._cacheHelperProportions();
        }
        if (!noActivation) {
          for (i = this.containers.length - 1; i >= 0; i--) {
            this.containers[i]._trigger("activate", event, this._uiHash(this));
          }
        }
        if ($.ui.ddmanager) {
          $.ui.ddmanager.current = this;
        }
        if ($.ui.ddmanager && !o.dropBehaviour) {
          $.ui.ddmanager.prepareOffsets(this, event);
        }
        this.dragging = true;
        this._addClass(this.helper, "ui-sortable-helper");
        if (!this.helper.parent().is(this.appendTo)) {
          this.helper.detach().appendTo(this.appendTo);
          this.offset.parent = this._getParentOffset();
        }
        this.position = this.originalPosition = this._generatePosition(event);
        this.originalPageX = event.pageX;
        this.originalPageY = event.pageY;
        this.lastPositionAbs = this.positionAbs = this._convertPositionTo("absolute");
        this._mouseDrag(event);
        return true;
      },
      _scroll: function(event) {
        var o = this.options, scrolled = false;
        if (this.scrollParent[0] !== this.document[0] && this.scrollParent[0].tagName !== "HTML") {
          if (this.overflowOffset.top + this.scrollParent[0].offsetHeight - event.pageY < o.scrollSensitivity) {
            this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop + o.scrollSpeed;
          } else if (event.pageY - this.overflowOffset.top < o.scrollSensitivity) {
            this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop - o.scrollSpeed;
          }
          if (this.overflowOffset.left + this.scrollParent[0].offsetWidth - event.pageX < o.scrollSensitivity) {
            this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft + o.scrollSpeed;
          } else if (event.pageX - this.overflowOffset.left < o.scrollSensitivity) {
            this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft - o.scrollSpeed;
          }
        } else {
          if (event.pageY - this.document.scrollTop() < o.scrollSensitivity) {
            scrolled = this.document.scrollTop(this.document.scrollTop() - o.scrollSpeed);
          } else if (this.window.height() - (event.pageY - this.document.scrollTop()) < o.scrollSensitivity) {
            scrolled = this.document.scrollTop(this.document.scrollTop() + o.scrollSpeed);
          }
          if (event.pageX - this.document.scrollLeft() < o.scrollSensitivity) {
            scrolled = this.document.scrollLeft(
              this.document.scrollLeft() - o.scrollSpeed
            );
          } else if (this.window.width() - (event.pageX - this.document.scrollLeft()) < o.scrollSensitivity) {
            scrolled = this.document.scrollLeft(
              this.document.scrollLeft() + o.scrollSpeed
            );
          }
        }
        return scrolled;
      },
      _mouseDrag: function(event) {
        var i, item, itemElement, intersection, o = this.options;
        this.position = this._generatePosition(event);
        this.positionAbs = this._convertPositionTo("absolute");
        if (!this.options.axis || this.options.axis !== "y") {
          this.helper[0].style.left = this.position.left + "px";
        }
        if (!this.options.axis || this.options.axis !== "x") {
          this.helper[0].style.top = this.position.top + "px";
        }
        if (o.scroll) {
          if (this._scroll(event) !== false) {
            this._refreshItemPositions(true);
            if ($.ui.ddmanager && !o.dropBehaviour) {
              $.ui.ddmanager.prepareOffsets(this, event);
            }
          }
        }
        this.dragDirection = {
          vertical: this._getDragVerticalDirection(),
          horizontal: this._getDragHorizontalDirection()
        };
        for (i = this.items.length - 1; i >= 0; i--) {
          item = this.items[i];
          itemElement = item.item[0];
          intersection = this._intersectsWithPointer(item);
          if (!intersection) {
            continue;
          }
          if (item.instance !== this.currentContainer) {
            continue;
          }
          if (itemElement !== this.currentItem[0] && this.placeholder[intersection === 1 ? "next" : "prev"]()[0] !== itemElement && !$.contains(this.placeholder[0], itemElement) && (this.options.type === "semi-dynamic" ? !$.contains(this.element[0], itemElement) : true)) {
            this.direction = intersection === 1 ? "down" : "up";
            if (this.options.tolerance === "pointer" || this._intersectsWithSides(item)) {
              this._rearrange(event, item);
            } else {
              break;
            }
            this._trigger("change", event, this._uiHash());
            break;
          }
        }
        this._contactContainers(event);
        if ($.ui.ddmanager) {
          $.ui.ddmanager.drag(this, event);
        }
        this._trigger("sort", event, this._uiHash());
        this.lastPositionAbs = this.positionAbs;
        return false;
      },
      _mouseStop: function(event, noPropagation) {
        if (!event) {
          return;
        }
        if ($.ui.ddmanager && !this.options.dropBehaviour) {
          $.ui.ddmanager.drop(this, event);
        }
        if (this.options.revert) {
          var that = this, cur = this.placeholder.offset(), axis = this.options.axis, animation = {};
          if (!axis || axis === "x") {
            animation.left = cur.left - this.offset.parent.left - this.margins.left + (this.offsetParent[0] === this.document[0].body ? 0 : this.offsetParent[0].scrollLeft);
          }
          if (!axis || axis === "y") {
            animation.top = cur.top - this.offset.parent.top - this.margins.top + (this.offsetParent[0] === this.document[0].body ? 0 : this.offsetParent[0].scrollTop);
          }
          this.reverting = true;
          $(this.helper).animate(
            animation,
            parseInt(this.options.revert, 10) || 500,
            function() {
              that._clear(event);
            }
          );
        } else {
          this._clear(event, noPropagation);
        }
        return false;
      },
      cancel: function() {
        if (this.dragging) {
          this._mouseUp(new $.Event("mouseup", { target: null }));
          if (this.options.helper === "original") {
            this.currentItem.css(this._storedCSS);
            this._removeClass(this.currentItem, "ui-sortable-helper");
          } else {
            this.currentItem.show();
          }
          for (var i = this.containers.length - 1; i >= 0; i--) {
            this.containers[i]._trigger("deactivate", null, this._uiHash(this));
            if (this.containers[i].containerCache.over) {
              this.containers[i]._trigger("out", null, this._uiHash(this));
              this.containers[i].containerCache.over = 0;
            }
          }
        }
        if (this.placeholder) {
          if (this.placeholder[0].parentNode) {
            this.placeholder[0].parentNode.removeChild(this.placeholder[0]);
          }
          if (this.options.helper !== "original" && this.helper && this.helper[0].parentNode) {
            this.helper.remove();
          }
          $.extend(this, {
            helper: null,
            dragging: false,
            reverting: false,
            _noFinalSort: null
          });
          if (this.domPosition.prev) {
            $(this.domPosition.prev).after(this.currentItem);
          } else {
            $(this.domPosition.parent).prepend(this.currentItem);
          }
        }
        return this;
      },
      serialize: function(o) {
        var items = this._getItemsAsjQuery(o && o.connected), str = [];
        o = o || {};
        $(items).each(function() {
          var res = ($(o.item || this).attr(o.attribute || "id") || "").match(o.expression || /(.+)[\-=_](.+)/);
          if (res) {
            str.push(
              (o.key || res[1] + "[]") + "=" + (o.key && o.expression ? res[1] : res[2])
            );
          }
        });
        if (!str.length && o.key) {
          str.push(o.key + "=");
        }
        return str.join("&");
      },
      toArray: function(o) {
        var items = this._getItemsAsjQuery(o && o.connected), ret = [];
        o = o || {};
        items.each(function() {
          ret.push($(o.item || this).attr(o.attribute || "id") || "");
        });
        return ret;
      },
      /* Be careful with the following core functions */
      _intersectsWith: function(item) {
        var x1 = this.positionAbs.left, x2 = x1 + this.helperProportions.width, y1 = this.positionAbs.top, y2 = y1 + this.helperProportions.height, l = item.left, r = l + item.width, t = item.top, b = t + item.height, dyClick = this.offset.click.top, dxClick = this.offset.click.left, isOverElementHeight = this.options.axis === "x" || y1 + dyClick > t && y1 + dyClick < b, isOverElementWidth = this.options.axis === "y" || x1 + dxClick > l && x1 + dxClick < r, isOverElement = isOverElementHeight && isOverElementWidth;
        if (this.options.tolerance === "pointer" || this.options.forcePointerForContainers || this.options.tolerance !== "pointer" && this.helperProportions[this.floating ? "width" : "height"] > item[this.floating ? "width" : "height"]) {
          return isOverElement;
        } else {
          return l < x1 + this.helperProportions.width / 2 && // Right Half
          x2 - this.helperProportions.width / 2 < r && // Left Half
          t < y1 + this.helperProportions.height / 2 && // Bottom Half
          y2 - this.helperProportions.height / 2 < b;
        }
      },
      _intersectsWithPointer: function(item) {
        var verticalDirection, horizontalDirection, isOverElementHeight = this.options.axis === "x" || this._isOverAxis(
          this.positionAbs.top + this.offset.click.top,
          item.top,
          item.height
        ), isOverElementWidth = this.options.axis === "y" || this._isOverAxis(
          this.positionAbs.left + this.offset.click.left,
          item.left,
          item.width
        ), isOverElement = isOverElementHeight && isOverElementWidth;
        if (!isOverElement) {
          return false;
        }
        verticalDirection = this.dragDirection.vertical;
        horizontalDirection = this.dragDirection.horizontal;
        return this.floating ? horizontalDirection === "right" || verticalDirection === "down" ? 2 : 1 : verticalDirection && (verticalDirection === "down" ? 2 : 1);
      },
      _intersectsWithSides: function(item) {
        var isOverBottomHalf = this._isOverAxis(this.positionAbs.top + this.offset.click.top, item.top + item.height / 2, item.height), isOverRightHalf = this._isOverAxis(this.positionAbs.left + this.offset.click.left, item.left + item.width / 2, item.width), verticalDirection = this.dragDirection.vertical, horizontalDirection = this.dragDirection.horizontal;
        if (this.floating && horizontalDirection) {
          return horizontalDirection === "right" && isOverRightHalf || horizontalDirection === "left" && !isOverRightHalf;
        } else {
          return verticalDirection && (verticalDirection === "down" && isOverBottomHalf || verticalDirection === "up" && !isOverBottomHalf);
        }
      },
      _getDragVerticalDirection: function() {
        var delta = this.positionAbs.top - this.lastPositionAbs.top;
        return delta !== 0 && (delta > 0 ? "down" : "up");
      },
      _getDragHorizontalDirection: function() {
        var delta = this.positionAbs.left - this.lastPositionAbs.left;
        return delta !== 0 && (delta > 0 ? "right" : "left");
      },
      refresh: function(event) {
        this._refreshItems(event);
        this._setHandleClassName();
        this.refreshPositions();
        return this;
      },
      _connectWith: function() {
        var options = this.options;
        return options.connectWith.constructor === String ? [options.connectWith] : options.connectWith;
      },
      _getItemsAsjQuery: function(connected) {
        var i, j, cur, inst, items = [], queries = [], connectWith = this._connectWith();
        if (connectWith && connected) {
          for (i = connectWith.length - 1; i >= 0; i--) {
            cur = $(connectWith[i], this.document[0]);
            for (j = cur.length - 1; j >= 0; j--) {
              inst = $.data(cur[j], this.widgetFullName);
              if (inst && inst !== this && !inst.options.disabled) {
                queries.push([typeof inst.options.items === "function" ? inst.options.items.call(inst.element) : $(inst.options.items, inst.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"), inst]);
              }
            }
          }
        }
        queries.push([typeof this.options.items === "function" ? this.options.items.call(this.element, null, { options: this.options, item: this.currentItem }) : $(this.options.items, this.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"), this]);
        function addItems() {
          items.push(this);
        }
        for (i = queries.length - 1; i >= 0; i--) {
          queries[i][0].each(addItems);
        }
        return $(items);
      },
      _removeCurrentsFromItems: function() {
        var list = this.currentItem.find(":data(" + this.widgetName + "-item)");
        this.items = $.grep(this.items, function(item) {
          for (var j = 0; j < list.length; j++) {
            if (list[j] === item.item[0]) {
              return false;
            }
          }
          return true;
        });
      },
      _refreshItems: function(event) {
        this.items = [];
        this.containers = [this];
        var i, j, cur, inst, targetData, _queries, item, queriesLength, items = this.items, queries = [[typeof this.options.items === "function" ? this.options.items.call(this.element[0], event, { item: this.currentItem }) : $(this.options.items, this.element), this]], connectWith = this._connectWith();
        if (connectWith && this.ready) {
          for (i = connectWith.length - 1; i >= 0; i--) {
            cur = $(connectWith[i], this.document[0]);
            for (j = cur.length - 1; j >= 0; j--) {
              inst = $.data(cur[j], this.widgetFullName);
              if (inst && inst !== this && !inst.options.disabled) {
                queries.push([typeof inst.options.items === "function" ? inst.options.items.call(inst.element[0], event, { item: this.currentItem }) : $(inst.options.items, inst.element), inst]);
                this.containers.push(inst);
              }
            }
          }
        }
        for (i = queries.length - 1; i >= 0; i--) {
          targetData = queries[i][1];
          _queries = queries[i][0];
          for (j = 0, queriesLength = _queries.length; j < queriesLength; j++) {
            item = $(_queries[j]);
            item.data(this.widgetName + "-item", targetData);
            items.push({
              item,
              instance: targetData,
              width: 0,
              height: 0,
              left: 0,
              top: 0
            });
          }
        }
      },
      _refreshItemPositions: function(fast) {
        var i, item, t, p;
        for (i = this.items.length - 1; i >= 0; i--) {
          item = this.items[i];
          if (this.currentContainer && item.instance !== this.currentContainer && item.item[0] !== this.currentItem[0]) {
            continue;
          }
          t = this.options.toleranceElement ? $(this.options.toleranceElement, item.item) : item.item;
          if (!fast) {
            item.width = t.outerWidth();
            item.height = t.outerHeight();
          }
          p = t.offset();
          item.left = p.left;
          item.top = p.top;
        }
      },
      refreshPositions: function(fast) {
        this.floating = this.items.length ? this.options.axis === "x" || this._isFloating(this.items[0].item) : false;
        if (this.offsetParent && this.helper) {
          this.offset.parent = this._getParentOffset();
        }
        this._refreshItemPositions(fast);
        var i, p;
        if (this.options.custom && this.options.custom.refreshContainers) {
          this.options.custom.refreshContainers.call(this);
        } else {
          for (i = this.containers.length - 1; i >= 0; i--) {
            p = this.containers[i].element.offset();
            this.containers[i].containerCache.left = p.left;
            this.containers[i].containerCache.top = p.top;
            this.containers[i].containerCache.width = this.containers[i].element.outerWidth();
            this.containers[i].containerCache.height = this.containers[i].element.outerHeight();
          }
        }
        return this;
      },
      _createPlaceholder: function(that) {
        that = that || this;
        var className, nodeName, o = that.options;
        if (!o.placeholder || o.placeholder.constructor === String) {
          className = o.placeholder;
          nodeName = that.currentItem[0].nodeName.toLowerCase();
          o.placeholder = {
            element: function() {
              var element = $("<" + nodeName + ">", that.document[0]);
              that._addClass(
                element,
                "ui-sortable-placeholder",
                className || that.currentItem[0].className
              )._removeClass(element, "ui-sortable-helper");
              if (nodeName === "tbody") {
                that._createTrPlaceholder(
                  that.currentItem.find("tr").eq(0),
                  $("<tr>", that.document[0]).appendTo(element)
                );
              } else if (nodeName === "tr") {
                that._createTrPlaceholder(that.currentItem, element);
              } else if (nodeName === "img") {
                element.attr("src", that.currentItem.attr("src"));
              }
              if (!className) {
                element.css("visibility", "hidden");
              }
              return element;
            },
            update: function(container, p) {
              if (className && !o.forcePlaceholderSize) {
                return;
              }
              if (!p.height() || o.forcePlaceholderSize && (nodeName === "tbody" || nodeName === "tr")) {
                p.height(
                  that.currentItem.innerHeight() - parseInt(that.currentItem.css("paddingTop") || 0, 10) - parseInt(that.currentItem.css("paddingBottom") || 0, 10)
                );
              }
              if (!p.width()) {
                p.width(
                  that.currentItem.innerWidth() - parseInt(that.currentItem.css("paddingLeft") || 0, 10) - parseInt(that.currentItem.css("paddingRight") || 0, 10)
                );
              }
            }
          };
        }
        that.placeholder = $(o.placeholder.element.call(that.element, that.currentItem));
        that.currentItem.after(that.placeholder);
        o.placeholder.update(that, that.placeholder);
      },
      _createTrPlaceholder: function(sourceTr, targetTr) {
        var that = this;
        sourceTr.children().each(function() {
          $("<td>&#160;</td>", that.document[0]).attr("colspan", $(this).attr("colspan") || 1).appendTo(targetTr);
        });
      },
      _contactContainers: function(event) {
        var i, j, dist, itemWithLeastDistance, posProperty, sizeProperty, cur, nearBottom, floating, axis, innermostContainer = null, innermostIndex = null;
        for (i = this.containers.length - 1; i >= 0; i--) {
          if ($.contains(this.currentItem[0], this.containers[i].element[0])) {
            continue;
          }
          if (this._intersectsWith(this.containers[i].containerCache)) {
            if (innermostContainer && $.contains(
              this.containers[i].element[0],
              innermostContainer.element[0]
            )) {
              continue;
            }
            innermostContainer = this.containers[i];
            innermostIndex = i;
          } else {
            if (this.containers[i].containerCache.over) {
              this.containers[i]._trigger("out", event, this._uiHash(this));
              this.containers[i].containerCache.over = 0;
            }
          }
        }
        if (!innermostContainer) {
          return;
        }
        if (this.containers.length === 1) {
          if (!this.containers[innermostIndex].containerCache.over) {
            this.containers[innermostIndex]._trigger("over", event, this._uiHash(this));
            this.containers[innermostIndex].containerCache.over = 1;
          }
        } else {
          dist = 1e4;
          itemWithLeastDistance = null;
          floating = innermostContainer.floating || this._isFloating(this.currentItem);
          posProperty = floating ? "left" : "top";
          sizeProperty = floating ? "width" : "height";
          axis = floating ? "pageX" : "pageY";
          for (j = this.items.length - 1; j >= 0; j--) {
            if (!$.contains(
              this.containers[innermostIndex].element[0],
              this.items[j].item[0]
            )) {
              continue;
            }
            if (this.items[j].item[0] === this.currentItem[0]) {
              continue;
            }
            cur = this.items[j].item.offset()[posProperty];
            nearBottom = false;
            if (event[axis] - cur > this.items[j][sizeProperty] / 2) {
              nearBottom = true;
            }
            if (Math.abs(event[axis] - cur) < dist) {
              dist = Math.abs(event[axis] - cur);
              itemWithLeastDistance = this.items[j];
              this.direction = nearBottom ? "up" : "down";
            }
          }
          if (!itemWithLeastDistance && !this.options.dropOnEmpty) {
            return;
          }
          if (this.currentContainer === this.containers[innermostIndex]) {
            if (!this.currentContainer.containerCache.over) {
              this.containers[innermostIndex]._trigger("over", event, this._uiHash());
              this.currentContainer.containerCache.over = 1;
            }
            return;
          }
          if (itemWithLeastDistance) {
            this._rearrange(event, itemWithLeastDistance, null, true);
          } else {
            this._rearrange(event, null, this.containers[innermostIndex].element, true);
          }
          this._trigger("change", event, this._uiHash());
          this.containers[innermostIndex]._trigger("change", event, this._uiHash(this));
          this.currentContainer = this.containers[innermostIndex];
          this.options.placeholder.update(this.currentContainer, this.placeholder);
          this.scrollParent = this.placeholder.scrollParent();
          if (this.scrollParent[0] !== this.document[0] && this.scrollParent[0].tagName !== "HTML") {
            this.overflowOffset = this.scrollParent.offset();
          }
          this.containers[innermostIndex]._trigger("over", event, this._uiHash(this));
          this.containers[innermostIndex].containerCache.over = 1;
        }
      },
      _createHelper: function(event) {
        var o = this.options, helper = typeof o.helper === "function" ? $(o.helper.apply(this.element[0], [event, this.currentItem])) : o.helper === "clone" ? this.currentItem.clone() : this.currentItem;
        if (!helper.parents("body").length) {
          this.appendTo[0].appendChild(helper[0]);
        }
        if (helper[0] === this.currentItem[0]) {
          this._storedCSS = {
            width: this.currentItem[0].style.width,
            height: this.currentItem[0].style.height,
            position: this.currentItem.css("position"),
            top: this.currentItem.css("top"),
            left: this.currentItem.css("left")
          };
        }
        if (!helper[0].style.width || o.forceHelperSize) {
          helper.width(this.currentItem.width());
        }
        if (!helper[0].style.height || o.forceHelperSize) {
          helper.height(this.currentItem.height());
        }
        return helper;
      },
      _adjustOffsetFromHelper: function(obj) {
        if (typeof obj === "string") {
          obj = obj.split(" ");
        }
        if (Array.isArray(obj)) {
          obj = { left: +obj[0], top: +obj[1] || 0 };
        }
        if ("left" in obj) {
          this.offset.click.left = obj.left + this.margins.left;
        }
        if ("right" in obj) {
          this.offset.click.left = this.helperProportions.width - obj.right + this.margins.left;
        }
        if ("top" in obj) {
          this.offset.click.top = obj.top + this.margins.top;
        }
        if ("bottom" in obj) {
          this.offset.click.top = this.helperProportions.height - obj.bottom + this.margins.top;
        }
      },
      _getParentOffset: function() {
        this.offsetParent = this.helper.offsetParent();
        var po = this.offsetParent.offset();
        if (this.cssPosition === "absolute" && this.scrollParent[0] !== this.document[0] && $.contains(this.scrollParent[0], this.offsetParent[0])) {
          po.left += this.scrollParent.scrollLeft();
          po.top += this.scrollParent.scrollTop();
        }
        if (this.offsetParent[0] === this.document[0].body || this.offsetParent[0].tagName && this.offsetParent[0].tagName.toLowerCase() === "html" && $.ui.ie) {
          po = { top: 0, left: 0 };
        }
        return {
          top: po.top + (parseInt(this.offsetParent.css("borderTopWidth"), 10) || 0),
          left: po.left + (parseInt(this.offsetParent.css("borderLeftWidth"), 10) || 0)
        };
      },
      _getRelativeOffset: function() {
        if (this.cssPosition === "relative") {
          var p = this.currentItem.position();
          return {
            top: p.top - (parseInt(this.helper.css("top"), 10) || 0) + this.scrollParent.scrollTop(),
            left: p.left - (parseInt(this.helper.css("left"), 10) || 0) + this.scrollParent.scrollLeft()
          };
        } else {
          return { top: 0, left: 0 };
        }
      },
      _cacheMargins: function() {
        this.margins = {
          left: parseInt(this.currentItem.css("marginLeft"), 10) || 0,
          top: parseInt(this.currentItem.css("marginTop"), 10) || 0
        };
      },
      _cacheHelperProportions: function() {
        this.helperProportions = {
          width: this.helper.outerWidth(),
          height: this.helper.outerHeight()
        };
      },
      _setContainment: function() {
        var ce, co, over, o = this.options;
        if (o.containment === "parent") {
          o.containment = this.helper[0].parentNode;
        }
        if (o.containment === "document" || o.containment === "window") {
          this.containment = [
            0 - this.offset.relative.left - this.offset.parent.left,
            0 - this.offset.relative.top - this.offset.parent.top,
            o.containment === "document" ? this.document.width() : this.window.width() - this.helperProportions.width - this.margins.left,
            (o.containment === "document" ? this.document.height() || document.body.parentNode.scrollHeight : this.window.height() || this.document[0].body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top
          ];
        }
        if (!/^(document|window|parent)$/.test(o.containment)) {
          ce = $(o.containment)[0];
          co = $(o.containment).offset();
          over = $(ce).css("overflow") !== "hidden";
          this.containment = [
            co.left + (parseInt($(ce).css("borderLeftWidth"), 10) || 0) + (parseInt($(ce).css("paddingLeft"), 10) || 0) - this.margins.left,
            co.top + (parseInt($(ce).css("borderTopWidth"), 10) || 0) + (parseInt($(ce).css("paddingTop"), 10) || 0) - this.margins.top,
            co.left + (over ? Math.max(ce.scrollWidth, ce.offsetWidth) : ce.offsetWidth) - (parseInt($(ce).css("borderLeftWidth"), 10) || 0) - (parseInt($(ce).css("paddingRight"), 10) || 0) - this.helperProportions.width - this.margins.left,
            co.top + (over ? Math.max(ce.scrollHeight, ce.offsetHeight) : ce.offsetHeight) - (parseInt($(ce).css("borderTopWidth"), 10) || 0) - (parseInt($(ce).css("paddingBottom"), 10) || 0) - this.helperProportions.height - this.margins.top
          ];
        }
      },
      _convertPositionTo: function(d, pos) {
        if (!pos) {
          pos = this.position;
        }
        var mod = d === "absolute" ? 1 : -1, scroll = this.cssPosition === "absolute" && !(this.scrollParent[0] !== this.document[0] && $.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent, scrollIsRootNode = /(html|body)/i.test(scroll[0].tagName);
        return {
          top: (
            // The absolute mouse position
            pos.top + // Only for relative positioned nodes: Relative offset from element to offset parent
            this.offset.relative.top * mod + // The offsetParent's offset without borders (offset + border)
            this.offset.parent.top * mod - (this.cssPosition === "fixed" ? -this.scrollParent.scrollTop() : scrollIsRootNode ? 0 : scroll.scrollTop()) * mod
          ),
          left: (
            // The absolute mouse position
            pos.left + // Only for relative positioned nodes: Relative offset from element to offset parent
            this.offset.relative.left * mod + // The offsetParent's offset without borders (offset + border)
            this.offset.parent.left * mod - (this.cssPosition === "fixed" ? -this.scrollParent.scrollLeft() : scrollIsRootNode ? 0 : scroll.scrollLeft()) * mod
          )
        };
      },
      _generatePosition: function(event) {
        var top2, left2, o = this.options, pageX = event.pageX, pageY = event.pageY, scroll = this.cssPosition === "absolute" && !(this.scrollParent[0] !== this.document[0] && $.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent, scrollIsRootNode = /(html|body)/i.test(scroll[0].tagName);
        if (this.cssPosition === "relative" && !(this.scrollParent[0] !== this.document[0] && this.scrollParent[0] !== this.offsetParent[0])) {
          this.offset.relative = this._getRelativeOffset();
        }
        if (this.originalPosition) {
          if (this.containment) {
            if (event.pageX - this.offset.click.left < this.containment[0]) {
              pageX = this.containment[0] + this.offset.click.left;
            }
            if (event.pageY - this.offset.click.top < this.containment[1]) {
              pageY = this.containment[1] + this.offset.click.top;
            }
            if (event.pageX - this.offset.click.left > this.containment[2]) {
              pageX = this.containment[2] + this.offset.click.left;
            }
            if (event.pageY - this.offset.click.top > this.containment[3]) {
              pageY = this.containment[3] + this.offset.click.top;
            }
          }
          if (o.grid) {
            top2 = this.originalPageY + Math.round((pageY - this.originalPageY) / o.grid[1]) * o.grid[1];
            pageY = this.containment ? top2 - this.offset.click.top >= this.containment[1] && top2 - this.offset.click.top <= this.containment[3] ? top2 : top2 - this.offset.click.top >= this.containment[1] ? top2 - o.grid[1] : top2 + o.grid[1] : top2;
            left2 = this.originalPageX + Math.round((pageX - this.originalPageX) / o.grid[0]) * o.grid[0];
            pageX = this.containment ? left2 - this.offset.click.left >= this.containment[0] && left2 - this.offset.click.left <= this.containment[2] ? left2 : left2 - this.offset.click.left >= this.containment[0] ? left2 - o.grid[0] : left2 + o.grid[0] : left2;
          }
        }
        return {
          top: (
            // The absolute mouse position
            pageY - // Click offset (relative to the element)
            this.offset.click.top - // Only for relative positioned nodes: Relative offset from element to offset parent
            this.offset.relative.top - // The offsetParent's offset without borders (offset + border)
            this.offset.parent.top + (this.cssPosition === "fixed" ? -this.scrollParent.scrollTop() : scrollIsRootNode ? 0 : scroll.scrollTop())
          ),
          left: (
            // The absolute mouse position
            pageX - // Click offset (relative to the element)
            this.offset.click.left - // Only for relative positioned nodes: Relative offset from element to offset parent
            this.offset.relative.left - // The offsetParent's offset without borders (offset + border)
            this.offset.parent.left + (this.cssPosition === "fixed" ? -this.scrollParent.scrollLeft() : scrollIsRootNode ? 0 : scroll.scrollLeft())
          )
        };
      },
      _rearrange: function(event, i, a, hardRefresh) {
        if (a) {
          a[0].appendChild(this.placeholder[0]);
        } else {
          i.item[0].parentNode.insertBefore(
            this.placeholder[0],
            this.direction === "down" ? i.item[0] : i.item[0].nextSibling
          );
        }
        this.counter = this.counter ? ++this.counter : 1;
        var counter = this.counter;
        this._delay(function() {
          if (counter === this.counter) {
            this.refreshPositions(!hardRefresh);
          }
        });
      },
      _clear: function(event, noPropagation) {
        this.reverting = false;
        var i, delayedTriggers = [];
        if (!this._noFinalSort && this.currentItem.parent().length) {
          this.placeholder.before(this.currentItem);
        }
        this._noFinalSort = null;
        if (this.helper[0] === this.currentItem[0]) {
          for (i in this._storedCSS) {
            if (this._storedCSS[i] === "auto" || this._storedCSS[i] === "static") {
              this._storedCSS[i] = "";
            }
          }
          this.currentItem.css(this._storedCSS);
          this._removeClass(this.currentItem, "ui-sortable-helper");
        } else {
          this.currentItem.show();
        }
        if (this.fromOutside && !noPropagation) {
          delayedTriggers.push(function(event2) {
            this._trigger("receive", event2, this._uiHash(this.fromOutside));
          });
        }
        if ((this.fromOutside || this.domPosition.prev !== this.currentItem.prev().not(".ui-sortable-helper")[0] || this.domPosition.parent !== this.currentItem.parent()[0]) && !noPropagation) {
          delayedTriggers.push(function(event2) {
            this._trigger("update", event2, this._uiHash());
          });
        }
        if (this !== this.currentContainer) {
          if (!noPropagation) {
            delayedTriggers.push(function(event2) {
              this._trigger("remove", event2, this._uiHash());
            });
            delayedTriggers.push(function(c) {
              return function(event2) {
                c._trigger("receive", event2, this._uiHash(this));
              };
            }.call(this, this.currentContainer));
            delayedTriggers.push(function(c) {
              return function(event2) {
                c._trigger("update", event2, this._uiHash(this));
              };
            }.call(this, this.currentContainer));
          }
        }
        function delayEvent(type, instance, container) {
          return function(event2) {
            container._trigger(type, event2, instance._uiHash(instance));
          };
        }
        for (i = this.containers.length - 1; i >= 0; i--) {
          if (!noPropagation) {
            delayedTriggers.push(delayEvent("deactivate", this, this.containers[i]));
          }
          if (this.containers[i].containerCache.over) {
            delayedTriggers.push(delayEvent("out", this, this.containers[i]));
            this.containers[i].containerCache.over = 0;
          }
        }
        if (this.storedCursor) {
          this.document.find("body").css("cursor", this.storedCursor);
          this.storedStylesheet.remove();
        }
        if (this._storedOpacity) {
          this.helper.css("opacity", this._storedOpacity);
        }
        if (this._storedZIndex) {
          this.helper.css("zIndex", this._storedZIndex === "auto" ? "" : this._storedZIndex);
        }
        this.dragging = false;
        if (!noPropagation) {
          this._trigger("beforeStop", event, this._uiHash());
        }
        this.placeholder[0].parentNode.removeChild(this.placeholder[0]);
        if (!this.cancelHelperRemoval) {
          if (this.helper[0] !== this.currentItem[0]) {
            this.helper.remove();
          }
          this.helper = null;
        }
        if (!noPropagation) {
          for (i = 0; i < delayedTriggers.length; i++) {
            delayedTriggers[i].call(this, event);
          }
          this._trigger("stop", event, this._uiHash());
        }
        this.fromOutside = false;
        return !this.cancelHelperRemoval;
      },
      _trigger: function() {
        if ($.Widget.prototype._trigger.apply(this, arguments) === false) {
          this.cancel();
        }
      },
      _uiHash: function(_inst) {
        var inst = _inst || this;
        return {
          helper: inst.helper,
          placeholder: inst.placeholder || $([]),
          position: inst.position,
          originalPosition: inst.originalPosition,
          offset: inst.positionAbs,
          item: inst.currentItem,
          sender: _inst ? _inst.element : null
        };
      }
    });
  });

  // node_modules/rails_admin/src/rails_admin/widgets.js
  (function($) {
    document.addEventListener("rails_admin.dom_ready", function(event) {
      var $editors, array, config_options, goBootstrapWysihtml5s, goCkeditors, goCodeMirrors, goFroalaWysiwygs, goSimpleMDEs, options;
      var content = event.detail || $("form");
      if (content.length) {
        content.find("[data-datetimepicker]").each(function() {
          esm_default(
            this,
            $.extend(
              {
                dateFormat: "Y-m-dTH:i:S",
                altInput: true,
                locale: I18n.locale
              },
              $(this).data("options")
            )
          );
        });
        content.find("[data-enumeration]").each(function() {
          if ($(this).is("[multiple]")) {
            $(this).filteringMultiselect($(this).data("options"));
          } else {
            $(this).filteringSelect($(this).data("options"));
          }
        });
        content.find("[data-fileupload]").each(function() {
          var parent;
          parent = $(this).closest(".controls");
          parent.find(".btn-remove-image").on("click", function() {
            $(this).siblings("[type=checkbox]").click();
            parent.find(".toggle").toggle("slow");
            $(this).toggleClass("btn-danger btn-info");
            return false;
          });
        });
        content.find("[data-fileupload]").change(function() {
          var ext, image_container, input, reader;
          input = this;
          image_container = $("#" + input.id).parent().children(".preview");
          if (!image_container.length) {
            image_container = $("#" + input.id).parent().prepend($("<img />").addClass("preview").addClass("img-thumbnail")).find("img.preview");
            image_container.parent().find("img:not(.preview)").hide();
          }
          ext = $("#" + input.id).val().split(".").pop().toLowerCase();
          if (input.files && input.files[0] && $.inArray(ext, ["gif", "png", "jpg", "jpeg", "bmp"]) !== -1) {
            reader = new FileReader();
            reader.onload = function(e) {
              image_container.attr("src", e.target.result);
            };
            reader.readAsDataURL(input.files[0]);
            image_container.show();
          } else {
            image_container.hide();
          }
        });
        content.find("[data-multiple-fileupload]").each(function() {
          $(this).closest(".controls").find(".btn-remove-image").on("click", function() {
            $(this).siblings("[type=checkbox]").click();
            $(this).parent(".toggle").toggle("slow");
            $(this).toggleClass("btn-danger btn-info");
            return false;
          }).end().sortable({
            items: ".sortables"
          });
        });
        content.find("[data-multiple-fileupload]").change(function() {
          var ext, file, i, image_container, input, len, ref, results;
          input = this;
          $("#" + input.id).parent().children(".preview").remove();
          ref = input.files;
          results = [];
          for (i = 0, len = ref.length; i < len; i++) {
            file = ref[i];
            ext = file.name.split(".").pop().toLowerCase();
            if ($.inArray(ext, ["gif", "png", "jpg", "jpeg", "bmp"]) === -1) {
              continue;
            }
            image_container = $("<img />").addClass("preview").addClass("img-thumbnail");
            results.push(
              function(image_container2) {
                var reader;
                reader = new FileReader();
                reader.onload = function(e) {
                  image_container2.attr("src", e.target.result);
                };
                reader.readAsDataURL(file);
                return $("#" + input.id).parent().append(
                  $("<div></div>").addClass("preview").append(image_container2)
                );
              }(image_container)
            );
          }
          return results;
        });
        content.find("[data-filteringmultiselect]").each(function() {
          $(this).filteringMultiselect($(this).data("options"));
          if ($(this).parents("#modal").length) {
            $(this).parent().siblings(".modal-actions").remove();
          } else {
            $(this).parents(".control-group").first().remoteForm();
          }
        });
        content.find("[data-filteringselect]").each(function() {
          $(this).filteringSelect($(this).data("options"));
          if ($(this).parents("#modal").length) {
            $(this).parent().siblings(".modal-actions").remove();
          } else {
            $(this).parents(".control-group").first().remoteForm();
          }
        });
        content.find("[data-nestedmany]").each(function() {
          var field, nav, tab_content, toggler;
          field = $(this).parents(".control-group").first();
          nav = field.find("> .controls > .nav");
          tab_content = field.find("> .tab-content");
          toggler = field.find("> .controls > .btn-group > .toggler");
          tab_content.children(".fields:not(.tab-pane)").addClass("tab-pane").each(function() {
            $(this).attr(
              "id",
              "unique-id-" + (/* @__PURE__ */ new Date()).getTime() + Math.floor(Math.random() * 1e5)
            );
            nav.append(
              $("<li></li>").append(
                $("<a></a>").addClass("nav-link").attr("data-bs-toggle", "tab").attr("href", "#" + this.id).text(
                  $(this).children(".object-infos").data("object-label")
                )
              ).addClass("nav-item")
            );
          });
          if (nav.find("> li.active").length === 0) {
            nav.find("> li > a[data-bs-toggle='tab']:first").each(function(index, element) {
              Tab.getOrCreateInstance(element).show();
            });
          }
          if (nav.children().length === 0) {
            toggler.addClass("disabled").removeClass("active").children("i").addClass("fa-chevron-right");
          } else {
            if (toggler.hasClass("active")) {
              $(toggler.data("bs-target")).addClass("show");
              toggler.children("i").addClass("fa-chevron-down");
            } else {
              toggler.children("i").addClass("fa-chevron-right");
            }
          }
        });
        content.find("[data-nestedone]").each(function() {
          var field, first_tab, nav, tab_content, toggler;
          field = $(this).parents(".control-group").first();
          nav = field.find("> .controls > .nav");
          tab_content = field.find("> .tab-content");
          toggler = field.find("> .controls > .btn-group > .toggler");
          tab_content.children(".fields:not(.tab-pane)").addClass("tab-pane active").each(function() {
            field.find("> .controls .add_nested_fields").removeClass("add_nested_fields").text($(this).children(".object-infos").data("object-label"));
            nav.append(
              $("<li></li>").append(
                $("<a></a>").attr("data-bs-toggle", "tab").attr("href", "#" + $(this).id).text($(this).children(".object-infos").data("object-label"))
              )
            );
          });
          first_tab = nav.find("> li > a[data-bs-toggle='tab']:first");
          first_tab.each(function(index, element) {
            Tab.getOrCreateInstance(element).show();
          });
          field.find("> .controls > [data-target]:first").html('<i class="fas"></i> ' + first_tab.html());
          nav.hide();
          if (nav.children().length === 0) {
            toggler.addClass("disabled").removeClass("active").children("i").addClass("fa-chevron-right");
          } else {
            if (toggler.hasClass("active")) {
              $(toggler.data("bs-target")).addClass("show");
              toggler.children("i").addClass("fa-chevron-down");
            } else {
              toggler.children("i").addClass("fa-chevron-right");
            }
          }
        });
        content.find("[data-polymorphic]").each(function() {
          var field, object_select, type_select, urls;
          type_select = $(this);
          field = type_select.parents(".control-group").first();
          object_select = field.find("select").last();
          urls = type_select.data("urls");
          type_select.on("change", function(e) {
            var selected_data, selected_type;
            selected_type = type_select.val().toLowerCase().replace(/::/g, "-");
            selected_data = $("#" + selected_type + "-js-options").data(
              "options"
            );
            object_select.data("options", selected_data);
            object_select.filteringSelect("destroy");
            object_select.filteringSelect(selected_data);
          });
        });
        goSimpleMDEs = function() {
          return content.find("[data-richtext=simplemde]").not(".simplemded").each(function(index, domEle) {
            var instance_config, options2;
            options2 = $(this).data("options");
            instance_config = options2.instance_config;
            new window.SimpleMDE(
              $.extend(
                true,
                {
                  element: document.getElementById(this.id),
                  autosave: {
                    uniqueId: this.id
                  }
                },
                instance_config
              )
            );
            $(this).addClass("simplemded");
          });
        };
        $editors = content.find("[data-richtext=simplemde]").not(".simplemded");
        if ($editors.length) {
          if (!window.SimpleMDE) {
            options = $editors.first().data("options");
            $("head").append(
              '<link href="' + options["css_location"] + '" rel="stylesheet" media="all" type="text/css">'
            );
            $.getScript(
              options["js_location"],
              function(script, textStatus, jqXHR) {
                return goSimpleMDEs();
              }
            );
          } else {
            goSimpleMDEs();
          }
        }
        goCkeditors = function() {
          return content.find("[data-richtext=ckeditor]").not(".ckeditored").each(function(index, domEle) {
            var instance;
            try {
              if (instance = window.CKEDITOR.instances[this.id]) {
                instance.destroy(true);
              }
            } catch (error1) {
            }
            window.CKEDITOR.replace(this, $(this).data("options").options);
            $(this).addClass("ckeditored");
          });
        };
        $editors = content.find("[data-richtext=ckeditor]").not(".ckeditored");
        if ($editors.length) {
          if (!window.CKEDITOR) {
            options = $editors.first().data("options");
            window.CKEDITOR_BASEPATH = options["base_location"];
            $.getScript(
              options["jspath"],
              /* @__PURE__ */ function(_this) {
                return function(script, textStatus, jqXHR) {
                  return goCkeditors();
                };
              }(this)
            );
          } else {
            goCkeditors();
          }
        }
        goCodeMirrors = /* @__PURE__ */ function(_this) {
          return function(array2) {
            return array2.each(function(index, domEle) {
              var textarea;
              options = $(this).data("options");
              textarea = this;
              $.getScript(
                options["locations"]["mode"],
                function(script, textStatus, jqXHR) {
                  options = $(domEle).data("options");
                  $("head").append(
                    '<link href="' + options["locations"]["theme"] + '" rel="stylesheet" media="all" type="text/css">'
                  );
                  CodeMirror.fromTextArea(textarea, options["options"]);
                  return $(textarea).addClass("codemirrored");
                }
              );
            });
          };
        }(this);
        array = content.find("[data-richtext=codemirror]").not(".codemirrored");
        if (array.length) {
          this.array = array;
          if (!window.CodeMirror) {
            options = $(array[0]).data("options");
            $("head").append(
              '<link href="' + options["csspath"] + '" rel="stylesheet" media="all" type="text/css">'
            );
            $.getScript(
              options["jspath"],
              /* @__PURE__ */ function(_this) {
                return function(script, textStatus, jqXHR) {
                  return goCodeMirrors(_this.array);
                };
              }(this)
            );
          } else {
            goCodeMirrors(this.array);
          }
        }
        goBootstrapWysihtml5s = /* @__PURE__ */ function(_this) {
          return function(array2, config_options2) {
            return array2.each(function() {
              $(this).addClass("bootstrap-wysihtml5ed");
              $(this).closest(".controls").addClass("well");
              $(this).wysihtml5(config_options2);
            });
          };
        }(this);
        array = content.find("[data-richtext=bootstrap-wysihtml5]").not(".bootstrap-wysihtml5ed");
        if (array.length) {
          this.array = array;
          options = $(array[0]).data("options");
          config_options = $.parseJSON(options["config_options"]);
          if (!window.wysihtml5) {
            $("head").append(
              '<link href="' + options["csspath"] + '" rel="stylesheet" media="all" type="text/css">'
            );
            $.getScript(
              options["jspath"],
              /* @__PURE__ */ function(_this) {
                return function(script, textStatus, jqXHR) {
                  return goBootstrapWysihtml5s(_this.array, config_options);
                };
              }(this)
            );
          } else {
            goBootstrapWysihtml5s(this.array, config_options);
          }
        }
        goFroalaWysiwygs = /* @__PURE__ */ function(_this) {
          return function(array2) {
            return array2.each(function() {
              var uploadEnabled;
              options = $(this).data("options");
              config_options = $.parseJSON(options["config_options"]);
              if (config_options) {
                if (!config_options["inlineMode"]) {
                  config_options["inlineMode"] = false;
                }
              } else {
                config_options = {
                  inlineMode: false
                };
              }
              uploadEnabled = config_options["imageUploadURL"] ? config_options["imageUploadParams"] = {
                authenticity_token: $("meta[name=csrf-token]").attr(
                  "content"
                )
              } : void 0;
              $(this).addClass("froala-wysiwyged");
              $(this).froalaEditor(config_options);
              if (uploadEnabled) {
                $(this).on("froalaEditor.image.error", function(e, editor, error) {
                  alert("error uploading image: " + error.message);
                }).on("froalaEditor.image.removed", function(e, editor, $img) {
                  editor.options.imageDeleteParams = {
                    src: $img.attr("src"),
                    authenticity_token: $("meta[name=csrf-token]").attr(
                      "content"
                    )
                  };
                  editor.deleteImage($img);
                }).on(
                  "editable.imageDeleteSuccess",
                  function(e, editor, data) {
                  }
                ).on("editable.imageDeleteError", function(e, editor, error) {
                  alert("error deleting image: " + error.message);
                });
              }
            });
          };
        }(this);
        array = content.find("[data-richtext=froala-wysiwyg]").not(".froala-wysiwyged");
        if (array.length) {
          options = $(array[0]).data("options");
          if (!$.isFunction($.fn.editable)) {
            $("head").append(
              '<link href="' + options["csspath"] + '" rel="stylesheet" media="all" type="text/css">'
            );
            $.getScript(
              options["jspath"],
              /* @__PURE__ */ function(_this) {
                return function(script, textStatus, jqXHR) {
                  return goFroalaWysiwygs(array);
                };
              }(this)
            );
          } else {
            goFroalaWysiwygs(array);
          }
        }
        return content.find("trix-editor").each(function() {
          if (!window.Trix) {
            options = $(this).data("options");
            if (options.warn_dynamic_load) {
              console.warn(
                "ActionText assets should be loaded statically. Follow instructions in https://github.com/railsadminteam/rails_admin/wiki/ActionText"
              );
            }
            $("head").append(
              '<link href="' + options["csspath"] + '" rel="stylesheet" media="all" type="text/css">'
            );
            return $.getScript(options["jspath"]);
          }
        });
      }
    });
  })(import_jquery10.default);

  // node_modules/rails_admin/src/rails_admin/base.js
  if (!window._rails_loaded) {
    import_ujs2.default.start();
  }

  // app/javascript/rails_admin.js
  document.addEventListener("trix-before-initialize", () => {
    Trix.config.blockAttributes.heading1.tagName = "h3";
    Trix.config.blockAttributes.default.tagName = "p";
  });
})();
/*! Bundled license information:

jquery/dist/jquery.js:
  (*!
   * jQuery JavaScript Library v3.7.1
   * https://jquery.com/
   *
   * Copyright OpenJS Foundation and other contributors
   * Released under the MIT license
   * https://jquery.org/license
   *
   * Date: 2023-08-28T13:37Z
   *)

bootstrap/dist/js/bootstrap.esm.js:
  (*!
    * Bootstrap v5.3.1 (https://getbootstrap.com/)
    * Copyright 2011-2023 The Bootstrap Authors (https://github.com/twbs/bootstrap/graphs/contributors)
    * Licensed under MIT (https://github.com/twbs/bootstrap/blob/main/LICENSE)
    *)

jquery-ui/ui/keycode.js:
  (*!
   * jQuery UI Keycode 1.13.3
   * https://jqueryui.com
   *
   * Copyright OpenJS Foundation and other contributors
   * Released under the MIT license.
   * https://jquery.org/license
   *)

jquery-ui/ui/position.js:
  (*!
   * jQuery UI Position 1.13.3
   * https://jqueryui.com
   *
   * Copyright OpenJS Foundation and other contributors
   * Released under the MIT license.
   * https://jquery.org/license
   *
   * https://api.jqueryui.com/position/
   *)

jquery-ui/ui/data.js:
  (*!
   * jQuery UI :data 1.13.3
   * https://jqueryui.com
   *
   * Copyright OpenJS Foundation and other contributors
   * Released under the MIT license.
   * https://jquery.org/license
   *)

jquery-ui/ui/scroll-parent.js:
  (*!
   * jQuery UI Scroll Parent 1.13.3
   * https://jqueryui.com
   *
   * Copyright OpenJS Foundation and other contributors
   * Released under the MIT license.
   * https://jquery.org/license
   *)

jquery-ui/ui/unique-id.js:
  (*!
   * jQuery UI Unique ID 1.13.3
   * https://jqueryui.com
   *
   * Copyright OpenJS Foundation and other contributors
   * Released under the MIT license.
   * https://jquery.org/license
   *)

jquery-ui/ui/widget.js:
  (*!
   * jQuery UI Widget 1.13.3
   * https://jqueryui.com
   *
   * Copyright OpenJS Foundation and other contributors
   * Released under the MIT license.
   * https://jquery.org/license
   *)

jquery-ui/ui/widgets/menu.js:
  (*!
   * jQuery UI Menu 1.13.3
   * https://jqueryui.com
   *
   * Copyright OpenJS Foundation and other contributors
   * Released under the MIT license.
   * https://jquery.org/license
   *)

jquery-ui/ui/widgets/mouse.js:
  (*!
   * jQuery UI Mouse 1.13.3
   * https://jqueryui.com
   *
   * Copyright OpenJS Foundation and other contributors
   * Released under the MIT license.
   * https://jquery.org/license
   *)

jquery-ui/ui/widgets/autocomplete.js:
  (*!
   * jQuery UI Autocomplete 1.13.3
   * https://jqueryui.com
   *
   * Copyright OpenJS Foundation and other contributors
   * Released under the MIT license.
   * https://jquery.org/license
   *)

jquery-ui/ui/effect.js:
  (*!
   * jQuery UI Effects 1.13.3
   * https://jqueryui.com
   *
   * Copyright OpenJS Foundation and other contributors
   * Released under the MIT license.
   * https://jquery.org/license
   *)

jquery-ui/ui/widgets/sortable.js:
  (*!
   * jQuery UI Sortable 1.13.3
   * https://jqueryui.com
   *
   * Copyright OpenJS Foundation and other contributors
   * Released under the MIT license.
   * https://jquery.org/license
   *)
*/
//
