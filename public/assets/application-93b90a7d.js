(() => {
  // node_modules/@sentry/utils/build/esm/is.js
  var objectToString = Object.prototype.toString;
  function isError(wat) {
    switch (objectToString.call(wat)) {
      case "[object Error]":
      case "[object Exception]":
      case "[object DOMException]":
      case "[object WebAssembly.Exception]":
        return true;
      default:
        return isInstanceOf(wat, Error);
    }
  }
  function isBuiltin(wat, className) {
    return objectToString.call(wat) === `[object ${className}]`;
  }
  function isErrorEvent(wat) {
    return isBuiltin(wat, "ErrorEvent");
  }
  function isDOMError(wat) {
    return isBuiltin(wat, "DOMError");
  }
  function isDOMException(wat) {
    return isBuiltin(wat, "DOMException");
  }
  function isString(wat) {
    return isBuiltin(wat, "String");
  }
  function isParameterizedString(wat) {
    return typeof wat === "object" && wat !== null && "__sentry_template_string__" in wat && "__sentry_template_values__" in wat;
  }
  function isPrimitive(wat) {
    return wat === null || isParameterizedString(wat) || typeof wat !== "object" && typeof wat !== "function";
  }
  function isPlainObject(wat) {
    return isBuiltin(wat, "Object");
  }
  function isEvent(wat) {
    return typeof Event !== "undefined" && isInstanceOf(wat, Event);
  }
  function isElement(wat) {
    return typeof Element !== "undefined" && isInstanceOf(wat, Element);
  }
  function isRegExp(wat) {
    return isBuiltin(wat, "RegExp");
  }
  function isThenable(wat) {
    return Boolean(wat && wat.then && typeof wat.then === "function");
  }
  function isSyntheticEvent(wat) {
    return isPlainObject(wat) && "nativeEvent" in wat && "preventDefault" in wat && "stopPropagation" in wat;
  }
  function isInstanceOf(wat, base) {
    try {
      return wat instanceof base;
    } catch (_e) {
      return false;
    }
  }
  function isVueViewModel(wat) {
    return !!(typeof wat === "object" && wat !== null && (wat.__isVue || wat._isVue));
  }

  // node_modules/@sentry/utils/build/esm/string.js
  function truncate(str, max = 0) {
    if (typeof str !== "string" || max === 0) {
      return str;
    }
    return str.length <= max ? str : `${str.slice(0, max)}...`;
  }
  function safeJoin(input, delimiter) {
    if (!Array.isArray(input)) {
      return "";
    }
    const output = [];
    for (let i = 0; i < input.length; i++) {
      const value = input[i];
      try {
        if (isVueViewModel(value)) {
          output.push("[VueViewModel]");
        } else {
          output.push(String(value));
        }
      } catch (e2) {
        output.push("[value cannot be serialized]");
      }
    }
    return output.join(delimiter);
  }
  function isMatchingPattern(value, pattern, requireExactStringMatch = false) {
    if (!isString(value)) {
      return false;
    }
    if (isRegExp(pattern)) {
      return pattern.test(value);
    }
    if (isString(pattern)) {
      return requireExactStringMatch ? value === pattern : value.includes(pattern);
    }
    return false;
  }
  function stringMatchesSomePattern(testString, patterns = [], requireExactStringMatch = false) {
    return patterns.some((pattern) => isMatchingPattern(testString, pattern, requireExactStringMatch));
  }

  // node_modules/@sentry/utils/build/esm/aggregate-errors.js
  function applyAggregateErrorsToEvent(exceptionFromErrorImplementation, parser, maxValueLimit = 250, key, limit, event, hint) {
    if (!event.exception || !event.exception.values || !hint || !isInstanceOf(hint.originalException, Error)) {
      return;
    }
    const originalException = event.exception.values.length > 0 ? event.exception.values[event.exception.values.length - 1] : void 0;
    if (originalException) {
      event.exception.values = truncateAggregateExceptions(
        aggregateExceptionsFromError(
          exceptionFromErrorImplementation,
          parser,
          limit,
          hint.originalException,
          key,
          event.exception.values,
          originalException,
          0
        ),
        maxValueLimit
      );
    }
  }
  function aggregateExceptionsFromError(exceptionFromErrorImplementation, parser, limit, error, key, prevExceptions, exception, exceptionId) {
    if (prevExceptions.length >= limit + 1) {
      return prevExceptions;
    }
    let newExceptions = [...prevExceptions];
    if (isInstanceOf(error[key], Error)) {
      applyExceptionGroupFieldsForParentException(exception, exceptionId);
      const newException = exceptionFromErrorImplementation(parser, error[key]);
      const newExceptionId = newExceptions.length;
      applyExceptionGroupFieldsForChildException(newException, key, newExceptionId, exceptionId);
      newExceptions = aggregateExceptionsFromError(
        exceptionFromErrorImplementation,
        parser,
        limit,
        error[key],
        key,
        [newException, ...newExceptions],
        newException,
        newExceptionId
      );
    }
    if (Array.isArray(error.errors)) {
      error.errors.forEach((childError, i) => {
        if (isInstanceOf(childError, Error)) {
          applyExceptionGroupFieldsForParentException(exception, exceptionId);
          const newException = exceptionFromErrorImplementation(parser, childError);
          const newExceptionId = newExceptions.length;
          applyExceptionGroupFieldsForChildException(newException, `errors[${i}]`, newExceptionId, exceptionId);
          newExceptions = aggregateExceptionsFromError(
            exceptionFromErrorImplementation,
            parser,
            limit,
            childError,
            key,
            [newException, ...newExceptions],
            newException,
            newExceptionId
          );
        }
      });
    }
    return newExceptions;
  }
  function applyExceptionGroupFieldsForParentException(exception, exceptionId) {
    exception.mechanism = exception.mechanism || { type: "generic", handled: true };
    exception.mechanism = {
      ...exception.mechanism,
      ...exception.type === "AggregateError" && { is_exception_group: true },
      exception_id: exceptionId
    };
  }
  function applyExceptionGroupFieldsForChildException(exception, source, exceptionId, parentId) {
    exception.mechanism = exception.mechanism || { type: "generic", handled: true };
    exception.mechanism = {
      ...exception.mechanism,
      type: "chained",
      source,
      exception_id: exceptionId,
      parent_id: parentId
    };
  }
  function truncateAggregateExceptions(exceptions, maxValueLength) {
    return exceptions.map((exception) => {
      if (exception.value) {
        exception.value = truncate(exception.value, maxValueLength);
      }
      return exception;
    });
  }

  // node_modules/@sentry/utils/build/esm/breadcrumb-log-level.js
  function getBreadcrumbLogLevelFromHttpStatusCode(statusCode) {
    if (statusCode === void 0) {
      return void 0;
    } else if (statusCode >= 400 && statusCode < 500) {
      return "warning";
    } else if (statusCode >= 500) {
      return "error";
    } else {
      return void 0;
    }
  }

  // node_modules/@sentry/utils/build/esm/version.js
  var SDK_VERSION = "8.35.0";

  // node_modules/@sentry/utils/build/esm/worldwide.js
  var GLOBAL_OBJ = globalThis;
  function getGlobalSingleton(name, creator, obj) {
    const gbl = obj || GLOBAL_OBJ;
    const __SENTRY__ = gbl.__SENTRY__ = gbl.__SENTRY__ || {};
    const versionedCarrier = __SENTRY__[SDK_VERSION] = __SENTRY__[SDK_VERSION] || {};
    return versionedCarrier[name] || (versionedCarrier[name] = creator());
  }

  // node_modules/@sentry/utils/build/esm/browser.js
  var WINDOW = GLOBAL_OBJ;
  var DEFAULT_MAX_STRING_LENGTH = 80;
  function htmlTreeAsString(elem, options = {}) {
    if (!elem) {
      return "<unknown>";
    }
    try {
      let currentElem = elem;
      const MAX_TRAVERSE_HEIGHT = 5;
      const out = [];
      let height = 0;
      let len = 0;
      const separator = " > ";
      const sepLength = separator.length;
      let nextStr;
      const keyAttrs = Array.isArray(options) ? options : options.keyAttrs;
      const maxStringLength = !Array.isArray(options) && options.maxStringLength || DEFAULT_MAX_STRING_LENGTH;
      while (currentElem && height++ < MAX_TRAVERSE_HEIGHT) {
        nextStr = _htmlElementAsString(currentElem, keyAttrs);
        if (nextStr === "html" || height > 1 && len + out.length * sepLength + nextStr.length >= maxStringLength) {
          break;
        }
        out.push(nextStr);
        len += nextStr.length;
        currentElem = currentElem.parentNode;
      }
      return out.reverse().join(separator);
    } catch (_oO) {
      return "<unknown>";
    }
  }
  function _htmlElementAsString(el, keyAttrs) {
    const elem = el;
    const out = [];
    if (!elem || !elem.tagName) {
      return "";
    }
    if (WINDOW.HTMLElement) {
      if (elem instanceof HTMLElement && elem.dataset) {
        if (elem.dataset["sentryComponent"]) {
          return elem.dataset["sentryComponent"];
        }
        if (elem.dataset["sentryElement"]) {
          return elem.dataset["sentryElement"];
        }
      }
    }
    out.push(elem.tagName.toLowerCase());
    const keyAttrPairs = keyAttrs && keyAttrs.length ? keyAttrs.filter((keyAttr) => elem.getAttribute(keyAttr)).map((keyAttr) => [keyAttr, elem.getAttribute(keyAttr)]) : null;
    if (keyAttrPairs && keyAttrPairs.length) {
      keyAttrPairs.forEach((keyAttrPair) => {
        out.push(`[${keyAttrPair[0]}="${keyAttrPair[1]}"]`);
      });
    } else {
      if (elem.id) {
        out.push(`#${elem.id}`);
      }
      const className = elem.className;
      if (className && isString(className)) {
        const classes = className.split(/\s+/);
        for (const c of classes) {
          out.push(`.${c}`);
        }
      }
    }
    const allowedAttrs = ["aria-label", "type", "name", "title", "alt"];
    for (const k of allowedAttrs) {
      const attr = elem.getAttribute(k);
      if (attr) {
        out.push(`[${k}="${attr}"]`);
      }
    }
    return out.join("");
  }
  function getLocationHref() {
    try {
      return WINDOW.document.location.href;
    } catch (oO) {
      return "";
    }
  }
  function getDomElement(selector) {
    if (WINDOW.document && WINDOW.document.querySelector) {
      return WINDOW.document.querySelector(selector);
    }
    return null;
  }
  function getComponentName(elem) {
    if (!WINDOW.HTMLElement) {
      return null;
    }
    let currentElem = elem;
    const MAX_TRAVERSE_HEIGHT = 5;
    for (let i = 0; i < MAX_TRAVERSE_HEIGHT; i++) {
      if (!currentElem) {
        return null;
      }
      if (currentElem instanceof HTMLElement) {
        if (currentElem.dataset["sentryComponent"]) {
          return currentElem.dataset["sentryComponent"];
        }
        if (currentElem.dataset["sentryElement"]) {
          return currentElem.dataset["sentryElement"];
        }
      }
      currentElem = currentElem.parentNode;
    }
    return null;
  }

  // node_modules/@sentry/utils/build/esm/debug-build.js
  var DEBUG_BUILD = typeof __SENTRY_DEBUG__ === "undefined" || __SENTRY_DEBUG__;

  // node_modules/@sentry/utils/build/esm/logger.js
  var PREFIX = "Sentry Logger ";
  var CONSOLE_LEVELS = [
    "debug",
    "info",
    "warn",
    "error",
    "log",
    "assert",
    "trace"
  ];
  var originalConsoleMethods = {};
  function consoleSandbox(callback) {
    if (!("console" in GLOBAL_OBJ)) {
      return callback();
    }
    const console2 = GLOBAL_OBJ.console;
    const wrappedFuncs = {};
    const wrappedLevels = Object.keys(originalConsoleMethods);
    wrappedLevels.forEach((level) => {
      const originalConsoleMethod = originalConsoleMethods[level];
      wrappedFuncs[level] = console2[level];
      console2[level] = originalConsoleMethod;
    });
    try {
      return callback();
    } finally {
      wrappedLevels.forEach((level) => {
        console2[level] = wrappedFuncs[level];
      });
    }
  }
  function makeLogger() {
    let enabled = false;
    const logger3 = {
      enable: () => {
        enabled = true;
      },
      disable: () => {
        enabled = false;
      },
      isEnabled: () => enabled
    };
    if (DEBUG_BUILD) {
      CONSOLE_LEVELS.forEach((name) => {
        logger3[name] = (...args) => {
          if (enabled) {
            consoleSandbox(() => {
              GLOBAL_OBJ.console[name](`${PREFIX}[${name}]:`, ...args);
            });
          }
        };
      });
    } else {
      CONSOLE_LEVELS.forEach((name) => {
        logger3[name] = () => void 0;
      });
    }
    return logger3;
  }
  var logger = getGlobalSingleton("logger", makeLogger);

  // node_modules/@sentry/utils/build/esm/dsn.js
  var DSN_REGEX = /^(?:(\w+):)\/\/(?:(\w+)(?::(\w+)?)?@)([\w.-]+)(?::(\d+))?\/(.+)/;
  function isValidProtocol(protocol) {
    return protocol === "http" || protocol === "https";
  }
  function dsnToString(dsn, withPassword = false) {
    const { host, path, pass, port, projectId, protocol, publicKey } = dsn;
    return `${protocol}://${publicKey}${withPassword && pass ? `:${pass}` : ""}@${host}${port ? `:${port}` : ""}/${path ? `${path}/` : path}${projectId}`;
  }
  function dsnFromString(str) {
    const match = DSN_REGEX.exec(str);
    if (!match) {
      consoleSandbox(() => {
        console.error(`Invalid Sentry Dsn: ${str}`);
      });
      return void 0;
    }
    const [protocol, publicKey, pass = "", host = "", port = "", lastPath = ""] = match.slice(1);
    let path = "";
    let projectId = lastPath;
    const split = projectId.split("/");
    if (split.length > 1) {
      path = split.slice(0, -1).join("/");
      projectId = split.pop();
    }
    if (projectId) {
      const projectMatch = projectId.match(/^\d+/);
      if (projectMatch) {
        projectId = projectMatch[0];
      }
    }
    return dsnFromComponents({ host, pass, path, projectId, port, protocol, publicKey });
  }
  function dsnFromComponents(components) {
    return {
      protocol: components.protocol,
      publicKey: components.publicKey || "",
      pass: components.pass || "",
      host: components.host,
      port: components.port || "",
      path: components.path || "",
      projectId: components.projectId
    };
  }
  function validateDsn(dsn) {
    if (!DEBUG_BUILD) {
      return true;
    }
    const { port, projectId, protocol } = dsn;
    const requiredComponents = ["protocol", "publicKey", "host", "projectId"];
    const hasMissingRequiredComponent = requiredComponents.find((component) => {
      if (!dsn[component]) {
        logger.error(`Invalid Sentry Dsn: ${component} missing`);
        return true;
      }
      return false;
    });
    if (hasMissingRequiredComponent) {
      return false;
    }
    if (!projectId.match(/^\d+$/)) {
      logger.error(`Invalid Sentry Dsn: Invalid projectId ${projectId}`);
      return false;
    }
    if (!isValidProtocol(protocol)) {
      logger.error(`Invalid Sentry Dsn: Invalid protocol ${protocol}`);
      return false;
    }
    if (port && isNaN(parseInt(port, 10))) {
      logger.error(`Invalid Sentry Dsn: Invalid port ${port}`);
      return false;
    }
    return true;
  }
  function makeDsn(from) {
    const components = typeof from === "string" ? dsnFromString(from) : dsnFromComponents(from);
    if (!components || !validateDsn(components)) {
      return void 0;
    }
    return components;
  }

  // node_modules/@sentry/utils/build/esm/error.js
  var SentryError = class extends Error {
    /** Display name of this error instance. */
    constructor(message, logLevel = "warn") {
      super(message);
      this.message = message;
      this.name = new.target.prototype.constructor.name;
      Object.setPrototypeOf(this, new.target.prototype);
      this.logLevel = logLevel;
    }
  };

  // node_modules/@sentry/utils/build/esm/object.js
  function fill(source, name, replacementFactory) {
    if (!(name in source)) {
      return;
    }
    const original = source[name];
    const wrapped = replacementFactory(original);
    if (typeof wrapped === "function") {
      markFunctionWrapped(wrapped, original);
    }
    source[name] = wrapped;
  }
  function addNonEnumerableProperty(obj, name, value) {
    try {
      Object.defineProperty(obj, name, {
        // enumerable: false, // the default, so we can save on bundle size by not explicitly setting it
        value,
        writable: true,
        configurable: true
      });
    } catch (o_O) {
      DEBUG_BUILD && logger.log(`Failed to add non-enumerable property "${name}" to object`, obj);
    }
  }
  function markFunctionWrapped(wrapped, original) {
    try {
      const proto = original.prototype || {};
      wrapped.prototype = original.prototype = proto;
      addNonEnumerableProperty(wrapped, "__sentry_original__", original);
    } catch (o_O) {
    }
  }
  function getOriginalFunction(func) {
    return func.__sentry_original__;
  }
  function urlEncode(object) {
    return Object.keys(object).map((key) => `${encodeURIComponent(key)}=${encodeURIComponent(object[key])}`).join("&");
  }
  function convertToPlainObject(value) {
    if (isError(value)) {
      return {
        message: value.message,
        name: value.name,
        stack: value.stack,
        ...getOwnProperties(value)
      };
    } else if (isEvent(value)) {
      const newObj = {
        type: value.type,
        target: serializeEventTarget(value.target),
        currentTarget: serializeEventTarget(value.currentTarget),
        ...getOwnProperties(value)
      };
      if (typeof CustomEvent !== "undefined" && isInstanceOf(value, CustomEvent)) {
        newObj.detail = value.detail;
      }
      return newObj;
    } else {
      return value;
    }
  }
  function serializeEventTarget(target) {
    try {
      return isElement(target) ? htmlTreeAsString(target) : Object.prototype.toString.call(target);
    } catch (_oO) {
      return "<unknown>";
    }
  }
  function getOwnProperties(obj) {
    if (typeof obj === "object" && obj !== null) {
      const extractedProps = {};
      for (const property in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, property)) {
          extractedProps[property] = obj[property];
        }
      }
      return extractedProps;
    } else {
      return {};
    }
  }
  function extractExceptionKeysForMessage(exception, maxLength = 40) {
    const keys = Object.keys(convertToPlainObject(exception));
    keys.sort();
    const firstKey = keys[0];
    if (!firstKey) {
      return "[object has no keys]";
    }
    if (firstKey.length >= maxLength) {
      return truncate(firstKey, maxLength);
    }
    for (let includedKeys = keys.length; includedKeys > 0; includedKeys--) {
      const serialized = keys.slice(0, includedKeys).join(", ");
      if (serialized.length > maxLength) {
        continue;
      }
      if (includedKeys === keys.length) {
        return serialized;
      }
      return truncate(serialized, maxLength);
    }
    return "";
  }
  function dropUndefinedKeys(inputValue) {
    const memoizationMap = /* @__PURE__ */ new Map();
    return _dropUndefinedKeys(inputValue, memoizationMap);
  }
  function _dropUndefinedKeys(inputValue, memoizationMap) {
    if (isPojo(inputValue)) {
      const memoVal = memoizationMap.get(inputValue);
      if (memoVal !== void 0) {
        return memoVal;
      }
      const returnValue = {};
      memoizationMap.set(inputValue, returnValue);
      for (const key of Object.getOwnPropertyNames(inputValue)) {
        if (typeof inputValue[key] !== "undefined") {
          returnValue[key] = _dropUndefinedKeys(inputValue[key], memoizationMap);
        }
      }
      return returnValue;
    }
    if (Array.isArray(inputValue)) {
      const memoVal = memoizationMap.get(inputValue);
      if (memoVal !== void 0) {
        return memoVal;
      }
      const returnValue = [];
      memoizationMap.set(inputValue, returnValue);
      inputValue.forEach((item) => {
        returnValue.push(_dropUndefinedKeys(item, memoizationMap));
      });
      return returnValue;
    }
    return inputValue;
  }
  function isPojo(input) {
    if (!isPlainObject(input)) {
      return false;
    }
    try {
      const name = Object.getPrototypeOf(input).constructor.name;
      return !name || name === "Object";
    } catch (e2) {
      return true;
    }
  }

  // node_modules/@sentry/utils/build/esm/stacktrace.js
  var STACKTRACE_FRAME_LIMIT = 50;
  var UNKNOWN_FUNCTION = "?";
  var WEBPACK_ERROR_REGEXP = /\(error: (.*)\)/;
  var STRIP_FRAME_REGEXP = /captureMessage|captureException/;
  function createStackParser(...parsers) {
    const sortedParsers = parsers.sort((a, b) => a[0] - b[0]).map((p) => p[1]);
    return (stack, skipFirstLines = 0, framesToPop = 0) => {
      const frames = [];
      const lines = stack.split("\n");
      for (let i = skipFirstLines; i < lines.length; i++) {
        const line = lines[i];
        if (line.length > 1024) {
          continue;
        }
        const cleanedLine = WEBPACK_ERROR_REGEXP.test(line) ? line.replace(WEBPACK_ERROR_REGEXP, "$1") : line;
        if (cleanedLine.match(/\S*Error: /)) {
          continue;
        }
        for (const parser of sortedParsers) {
          const frame = parser(cleanedLine);
          if (frame) {
            frames.push(frame);
            break;
          }
        }
        if (frames.length >= STACKTRACE_FRAME_LIMIT + framesToPop) {
          break;
        }
      }
      return stripSentryFramesAndReverse(frames.slice(framesToPop));
    };
  }
  function stackParserFromStackParserOptions(stackParser) {
    if (Array.isArray(stackParser)) {
      return createStackParser(...stackParser);
    }
    return stackParser;
  }
  function stripSentryFramesAndReverse(stack) {
    if (!stack.length) {
      return [];
    }
    const localStack = Array.from(stack);
    if (/sentryWrapped/.test(getLastStackFrame(localStack).function || "")) {
      localStack.pop();
    }
    localStack.reverse();
    if (STRIP_FRAME_REGEXP.test(getLastStackFrame(localStack).function || "")) {
      localStack.pop();
      if (STRIP_FRAME_REGEXP.test(getLastStackFrame(localStack).function || "")) {
        localStack.pop();
      }
    }
    return localStack.slice(0, STACKTRACE_FRAME_LIMIT).map((frame) => ({
      ...frame,
      filename: frame.filename || getLastStackFrame(localStack).filename,
      function: frame.function || UNKNOWN_FUNCTION
    }));
  }
  function getLastStackFrame(arr) {
    return arr[arr.length - 1] || {};
  }
  var defaultFunctionName = "<anonymous>";
  function getFunctionName(fn) {
    try {
      if (!fn || typeof fn !== "function") {
        return defaultFunctionName;
      }
      return fn.name || defaultFunctionName;
    } catch (e2) {
      return defaultFunctionName;
    }
  }
  function getFramesFromEvent(event) {
    const exception = event.exception;
    if (exception) {
      const frames = [];
      try {
        exception.values.forEach((value) => {
          if (value.stacktrace.frames) {
            frames.push(...value.stacktrace.frames);
          }
        });
        return frames;
      } catch (_oO) {
        return void 0;
      }
    }
    return void 0;
  }

  // node_modules/@sentry/utils/build/esm/instrument/handlers.js
  var handlers = {};
  var instrumented = {};
  function addHandler(type, handler) {
    handlers[type] = handlers[type] || [];
    handlers[type].push(handler);
  }
  function maybeInstrument(type, instrumentFn) {
    if (!instrumented[type]) {
      instrumentFn();
      instrumented[type] = true;
    }
  }
  function triggerHandlers(type, data) {
    const typeHandlers = type && handlers[type];
    if (!typeHandlers) {
      return;
    }
    for (const handler of typeHandlers) {
      try {
        handler(data);
      } catch (e2) {
        DEBUG_BUILD && logger.error(
          `Error while triggering instrumentation handler.
Type: ${type}
Name: ${getFunctionName(handler)}
Error:`,
          e2
        );
      }
    }
  }

  // node_modules/@sentry/utils/build/esm/instrument/console.js
  function addConsoleInstrumentationHandler(handler) {
    const type = "console";
    addHandler(type, handler);
    maybeInstrument(type, instrumentConsole);
  }
  function instrumentConsole() {
    if (!("console" in GLOBAL_OBJ)) {
      return;
    }
    CONSOLE_LEVELS.forEach(function(level) {
      if (!(level in GLOBAL_OBJ.console)) {
        return;
      }
      fill(GLOBAL_OBJ.console, level, function(originalConsoleMethod) {
        originalConsoleMethods[level] = originalConsoleMethod;
        return function(...args) {
          const handlerData = { args, level };
          triggerHandlers("console", handlerData);
          const log = originalConsoleMethods[level];
          log && log.apply(GLOBAL_OBJ.console, args);
        };
      });
    });
  }

  // node_modules/@sentry/utils/build/esm/supports.js
  var WINDOW2 = GLOBAL_OBJ;
  function supportsFetch() {
    if (!("fetch" in WINDOW2)) {
      return false;
    }
    try {
      new Headers();
      new Request("http://www.example.com");
      new Response();
      return true;
    } catch (e2) {
      return false;
    }
  }
  function isNativeFunction(func) {
    return func && /^function\s+\w+\(\)\s+\{\s+\[native code\]\s+\}$/.test(func.toString());
  }
  function supportsNativeFetch() {
    if (typeof EdgeRuntime === "string") {
      return true;
    }
    if (!supportsFetch()) {
      return false;
    }
    if (isNativeFunction(WINDOW2.fetch)) {
      return true;
    }
    let result = false;
    const doc = WINDOW2.document;
    if (doc && typeof doc.createElement === "function") {
      try {
        const sandbox = doc.createElement("iframe");
        sandbox.hidden = true;
        doc.head.appendChild(sandbox);
        if (sandbox.contentWindow && sandbox.contentWindow.fetch) {
          result = isNativeFunction(sandbox.contentWindow.fetch);
        }
        doc.head.removeChild(sandbox);
      } catch (err) {
        DEBUG_BUILD && logger.warn("Could not create sandbox iframe for pure fetch check, bailing to window.fetch: ", err);
      }
    }
    return result;
  }

  // node_modules/@sentry/utils/build/esm/time.js
  var ONE_SECOND_IN_MS = 1e3;
  function dateTimestampInSeconds() {
    return Date.now() / ONE_SECOND_IN_MS;
  }
  function createUnixTimestampInSecondsFunc() {
    const { performance: performance2 } = GLOBAL_OBJ;
    if (!performance2 || !performance2.now) {
      return dateTimestampInSeconds;
    }
    const approxStartingTimeOrigin = Date.now() - performance2.now();
    const timeOrigin = performance2.timeOrigin == void 0 ? approxStartingTimeOrigin : performance2.timeOrigin;
    return () => {
      return (timeOrigin + performance2.now()) / ONE_SECOND_IN_MS;
    };
  }
  var timestampInSeconds = createUnixTimestampInSecondsFunc();
  var _browserPerformanceTimeOriginMode;
  var browserPerformanceTimeOrigin = (() => {
    const { performance: performance2 } = GLOBAL_OBJ;
    if (!performance2 || !performance2.now) {
      _browserPerformanceTimeOriginMode = "none";
      return void 0;
    }
    const threshold = 3600 * 1e3;
    const performanceNow = performance2.now();
    const dateNow = Date.now();
    const timeOriginDelta = performance2.timeOrigin ? Math.abs(performance2.timeOrigin + performanceNow - dateNow) : threshold;
    const timeOriginIsReliable = timeOriginDelta < threshold;
    const navigationStart = performance2.timing && performance2.timing.navigationStart;
    const hasNavigationStart = typeof navigationStart === "number";
    const navigationStartDelta = hasNavigationStart ? Math.abs(navigationStart + performanceNow - dateNow) : threshold;
    const navigationStartIsReliable = navigationStartDelta < threshold;
    if (timeOriginIsReliable || navigationStartIsReliable) {
      if (timeOriginDelta <= navigationStartDelta) {
        _browserPerformanceTimeOriginMode = "timeOrigin";
        return performance2.timeOrigin;
      } else {
        _browserPerformanceTimeOriginMode = "navigationStart";
        return navigationStart;
      }
    }
    _browserPerformanceTimeOriginMode = "dateNow";
    return dateNow;
  })();

  // node_modules/@sentry/utils/build/esm/instrument/fetch.js
  function addFetchInstrumentationHandler(handler, skipNativeFetchCheck) {
    const type = "fetch";
    addHandler(type, handler);
    maybeInstrument(type, () => instrumentFetch(void 0, skipNativeFetchCheck));
  }
  function addFetchEndInstrumentationHandler(handler) {
    const type = "fetch-body-resolved";
    addHandler(type, handler);
    maybeInstrument(type, () => instrumentFetch(streamHandler));
  }
  function instrumentFetch(onFetchResolved, skipNativeFetchCheck = false) {
    if (skipNativeFetchCheck && !supportsNativeFetch()) {
      return;
    }
    fill(GLOBAL_OBJ, "fetch", function(originalFetch) {
      return function(...args) {
        const { method, url } = parseFetchArgs(args);
        const handlerData = {
          args,
          fetchData: {
            method,
            url
          },
          startTimestamp: timestampInSeconds() * 1e3
        };
        if (!onFetchResolved) {
          triggerHandlers("fetch", {
            ...handlerData
          });
        }
        const virtualStackTrace = new Error().stack;
        return originalFetch.apply(GLOBAL_OBJ, args).then(
          async (response) => {
            if (onFetchResolved) {
              onFetchResolved(response);
            } else {
              triggerHandlers("fetch", {
                ...handlerData,
                endTimestamp: timestampInSeconds() * 1e3,
                response
              });
            }
            return response;
          },
          (error) => {
            triggerHandlers("fetch", {
              ...handlerData,
              endTimestamp: timestampInSeconds() * 1e3,
              error
            });
            if (isError(error) && error.stack === void 0) {
              error.stack = virtualStackTrace;
              addNonEnumerableProperty(error, "framesToPop", 1);
            }
            throw error;
          }
        );
      };
    });
  }
  async function resolveResponse(res, onFinishedResolving) {
    if (res && res.body) {
      const body = res.body;
      const responseReader = body.getReader();
      const maxFetchDurationTimeout = setTimeout(
        () => {
          body.cancel().then(null, () => {
          });
        },
        90 * 1e3
        // 90s
      );
      let readingActive = true;
      while (readingActive) {
        let chunkTimeout;
        try {
          chunkTimeout = setTimeout(() => {
            body.cancel().then(null, () => {
            });
          }, 5e3);
          const { done } = await responseReader.read();
          clearTimeout(chunkTimeout);
          if (done) {
            onFinishedResolving();
            readingActive = false;
          }
        } catch (error) {
          readingActive = false;
        } finally {
          clearTimeout(chunkTimeout);
        }
      }
      clearTimeout(maxFetchDurationTimeout);
      responseReader.releaseLock();
      body.cancel().then(null, () => {
      });
    }
  }
  function streamHandler(response) {
    let clonedResponseForResolving;
    try {
      clonedResponseForResolving = response.clone();
    } catch (e2) {
      return;
    }
    resolveResponse(clonedResponseForResolving, () => {
      triggerHandlers("fetch-body-resolved", {
        endTimestamp: timestampInSeconds() * 1e3,
        response
      });
    });
  }
  function hasProp(obj, prop) {
    return !!obj && typeof obj === "object" && !!obj[prop];
  }
  function getUrlFromResource(resource) {
    if (typeof resource === "string") {
      return resource;
    }
    if (!resource) {
      return "";
    }
    if (hasProp(resource, "url")) {
      return resource.url;
    }
    if (resource.toString) {
      return resource.toString();
    }
    return "";
  }
  function parseFetchArgs(fetchArgs) {
    if (fetchArgs.length === 0) {
      return { method: "GET", url: "" };
    }
    if (fetchArgs.length === 2) {
      const [url, options] = fetchArgs;
      return {
        url: getUrlFromResource(url),
        method: hasProp(options, "method") ? String(options.method).toUpperCase() : "GET"
      };
    }
    const arg = fetchArgs[0];
    return {
      url: getUrlFromResource(arg),
      method: hasProp(arg, "method") ? String(arg.method).toUpperCase() : "GET"
    };
  }

  // node_modules/@sentry/utils/build/esm/instrument/globalError.js
  var _oldOnErrorHandler = null;
  function addGlobalErrorInstrumentationHandler(handler) {
    const type = "error";
    addHandler(type, handler);
    maybeInstrument(type, instrumentError);
  }
  function instrumentError() {
    _oldOnErrorHandler = GLOBAL_OBJ.onerror;
    GLOBAL_OBJ.onerror = function(msg, url, line, column, error) {
      const handlerData = {
        column,
        error,
        line,
        msg,
        url
      };
      triggerHandlers("error", handlerData);
      if (_oldOnErrorHandler && !_oldOnErrorHandler.__SENTRY_LOADER__) {
        return _oldOnErrorHandler.apply(this, arguments);
      }
      return false;
    };
    GLOBAL_OBJ.onerror.__SENTRY_INSTRUMENTED__ = true;
  }

  // node_modules/@sentry/utils/build/esm/instrument/globalUnhandledRejection.js
  var _oldOnUnhandledRejectionHandler = null;
  function addGlobalUnhandledRejectionInstrumentationHandler(handler) {
    const type = "unhandledrejection";
    addHandler(type, handler);
    maybeInstrument(type, instrumentUnhandledRejection);
  }
  function instrumentUnhandledRejection() {
    _oldOnUnhandledRejectionHandler = GLOBAL_OBJ.onunhandledrejection;
    GLOBAL_OBJ.onunhandledrejection = function(e2) {
      const handlerData = e2;
      triggerHandlers("unhandledrejection", handlerData);
      if (_oldOnUnhandledRejectionHandler && !_oldOnUnhandledRejectionHandler.__SENTRY_LOADER__) {
        return _oldOnUnhandledRejectionHandler.apply(this, arguments);
      }
      return true;
    };
    GLOBAL_OBJ.onunhandledrejection.__SENTRY_INSTRUMENTED__ = true;
  }

  // node_modules/@sentry/utils/build/esm/env.js
  function isBrowserBundle() {
    return typeof __SENTRY_BROWSER_BUNDLE__ !== "undefined" && !!__SENTRY_BROWSER_BUNDLE__;
  }
  function getSDKSource() {
    return "npm";
  }

  // node_modules/@sentry/utils/build/esm/node.js
  function isNodeEnv() {
    return !isBrowserBundle() && Object.prototype.toString.call(typeof process !== "undefined" ? process : 0) === "[object process]";
  }

  // node_modules/@sentry/utils/build/esm/isBrowser.js
  function isBrowser() {
    return typeof window !== "undefined" && (!isNodeEnv() || isElectronNodeRenderer());
  }
  function isElectronNodeRenderer() {
    return (
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-explicit-any
      GLOBAL_OBJ.process !== void 0 && GLOBAL_OBJ.process.type === "renderer"
    );
  }

  // node_modules/@sentry/utils/build/esm/memo.js
  function memoBuilder() {
    const hasWeakSet = typeof WeakSet === "function";
    const inner = hasWeakSet ? /* @__PURE__ */ new WeakSet() : [];
    function memoize(obj) {
      if (hasWeakSet) {
        if (inner.has(obj)) {
          return true;
        }
        inner.add(obj);
        return false;
      }
      for (let i = 0; i < inner.length; i++) {
        const value = inner[i];
        if (value === obj) {
          return true;
        }
      }
      inner.push(obj);
      return false;
    }
    function unmemoize(obj) {
      if (hasWeakSet) {
        inner.delete(obj);
      } else {
        for (let i = 0; i < inner.length; i++) {
          if (inner[i] === obj) {
            inner.splice(i, 1);
            break;
          }
        }
      }
    }
    return [memoize, unmemoize];
  }

  // node_modules/@sentry/utils/build/esm/misc.js
  function uuid4() {
    const gbl = GLOBAL_OBJ;
    const crypto = gbl.crypto || gbl.msCrypto;
    let getRandomByte = () => Math.random() * 16;
    try {
      if (crypto && crypto.randomUUID) {
        return crypto.randomUUID().replace(/-/g, "");
      }
      if (crypto && crypto.getRandomValues) {
        getRandomByte = () => {
          const typedArray = new Uint8Array(1);
          crypto.getRandomValues(typedArray);
          return typedArray[0];
        };
      }
    } catch (_) {
    }
    return ("10000000100040008000" + 1e11).replace(
      /[018]/g,
      (c) => (
        // eslint-disable-next-line no-bitwise
        (c ^ (getRandomByte() & 15) >> c / 4).toString(16)
      )
    );
  }
  function getFirstException(event) {
    return event.exception && event.exception.values ? event.exception.values[0] : void 0;
  }
  function getEventDescription(event) {
    const { message, event_id: eventId } = event;
    if (message) {
      return message;
    }
    const firstException = getFirstException(event);
    if (firstException) {
      if (firstException.type && firstException.value) {
        return `${firstException.type}: ${firstException.value}`;
      }
      return firstException.type || firstException.value || eventId || "<unknown>";
    }
    return eventId || "<unknown>";
  }
  function addExceptionTypeValue(event, value, type) {
    const exception = event.exception = event.exception || {};
    const values = exception.values = exception.values || [];
    const firstException = values[0] = values[0] || {};
    if (!firstException.value) {
      firstException.value = value || "";
    }
    if (!firstException.type) {
      firstException.type = type || "Error";
    }
  }
  function addExceptionMechanism(event, newMechanism) {
    const firstException = getFirstException(event);
    if (!firstException) {
      return;
    }
    const defaultMechanism = { type: "generic", handled: true };
    const currentMechanism = firstException.mechanism;
    firstException.mechanism = { ...defaultMechanism, ...currentMechanism, ...newMechanism };
    if (newMechanism && "data" in newMechanism) {
      const mergedData = { ...currentMechanism && currentMechanism.data, ...newMechanism.data };
      firstException.mechanism.data = mergedData;
    }
  }
  function checkOrSetAlreadyCaught(exception) {
    if (exception && exception.__sentry_captured__) {
      return true;
    }
    try {
      addNonEnumerableProperty(exception, "__sentry_captured__", true);
    } catch (err) {
    }
    return false;
  }
  function arrayify(maybeArray) {
    return Array.isArray(maybeArray) ? maybeArray : [maybeArray];
  }

  // node_modules/@sentry/utils/build/esm/normalize.js
  function normalize(input, depth = 100, maxProperties = Infinity) {
    try {
      return visit("", input, depth, maxProperties);
    } catch (err) {
      return { ERROR: `**non-serializable** (${err})` };
    }
  }
  function normalizeToSize(object, depth = 3, maxSize = 100 * 1024) {
    const normalized = normalize(object, depth);
    if (jsonSize(normalized) > maxSize) {
      return normalizeToSize(object, depth - 1, maxSize);
    }
    return normalized;
  }
  function visit(key, value, depth = Infinity, maxProperties = Infinity, memo = memoBuilder()) {
    const [memoize, unmemoize] = memo;
    if (value == null || // this matches null and undefined -> eqeq not eqeqeq
    ["boolean", "string"].includes(typeof value) || typeof value === "number" && Number.isFinite(value)) {
      return value;
    }
    const stringified = stringifyValue(key, value);
    if (!stringified.startsWith("[object ")) {
      return stringified;
    }
    if (value["__sentry_skip_normalization__"]) {
      return value;
    }
    const remainingDepth = typeof value["__sentry_override_normalization_depth__"] === "number" ? value["__sentry_override_normalization_depth__"] : depth;
    if (remainingDepth === 0) {
      return stringified.replace("object ", "");
    }
    if (memoize(value)) {
      return "[Circular ~]";
    }
    const valueWithToJSON = value;
    if (valueWithToJSON && typeof valueWithToJSON.toJSON === "function") {
      try {
        const jsonValue = valueWithToJSON.toJSON();
        return visit("", jsonValue, remainingDepth - 1, maxProperties, memo);
      } catch (err) {
      }
    }
    const normalized = Array.isArray(value) ? [] : {};
    let numAdded = 0;
    const visitable = convertToPlainObject(value);
    for (const visitKey in visitable) {
      if (!Object.prototype.hasOwnProperty.call(visitable, visitKey)) {
        continue;
      }
      if (numAdded >= maxProperties) {
        normalized[visitKey] = "[MaxProperties ~]";
        break;
      }
      const visitValue = visitable[visitKey];
      normalized[visitKey] = visit(visitKey, visitValue, remainingDepth - 1, maxProperties, memo);
      numAdded++;
    }
    unmemoize(value);
    return normalized;
  }
  function stringifyValue(key, value) {
    try {
      if (key === "domain" && value && typeof value === "object" && value._events) {
        return "[Domain]";
      }
      if (key === "domainEmitter") {
        return "[DomainEmitter]";
      }
      if (typeof global !== "undefined" && value === global) {
        return "[Global]";
      }
      if (typeof window !== "undefined" && value === window) {
        return "[Window]";
      }
      if (typeof document !== "undefined" && value === document) {
        return "[Document]";
      }
      if (isVueViewModel(value)) {
        return "[VueViewModel]";
      }
      if (isSyntheticEvent(value)) {
        return "[SyntheticEvent]";
      }
      if (typeof value === "number" && !Number.isFinite(value)) {
        return `[${value}]`;
      }
      if (typeof value === "function") {
        return `[Function: ${getFunctionName(value)}]`;
      }
      if (typeof value === "symbol") {
        return `[${String(value)}]`;
      }
      if (typeof value === "bigint") {
        return `[BigInt: ${String(value)}]`;
      }
      const objName = getConstructorName(value);
      if (/^HTML(\w*)Element$/.test(objName)) {
        return `[HTMLElement: ${objName}]`;
      }
      return `[object ${objName}]`;
    } catch (err) {
      return `**non-serializable** (${err})`;
    }
  }
  function getConstructorName(value) {
    const prototype = Object.getPrototypeOf(value);
    return prototype ? prototype.constructor.name : "null prototype";
  }
  function utf8Length(value) {
    return ~-encodeURI(value).split(/%..|./).length;
  }
  function jsonSize(value) {
    return utf8Length(JSON.stringify(value));
  }

  // node_modules/@sentry/utils/build/esm/syncpromise.js
  var States;
  (function(States2) {
    const PENDING = 0;
    States2[States2["PENDING"] = PENDING] = "PENDING";
    const RESOLVED = 1;
    States2[States2["RESOLVED"] = RESOLVED] = "RESOLVED";
    const REJECTED = 2;
    States2[States2["REJECTED"] = REJECTED] = "REJECTED";
  })(States || (States = {}));
  function resolvedSyncPromise(value) {
    return new SyncPromise((resolve) => {
      resolve(value);
    });
  }
  function rejectedSyncPromise(reason) {
    return new SyncPromise((_, reject) => {
      reject(reason);
    });
  }
  var SyncPromise = class _SyncPromise {
    constructor(executor) {
      _SyncPromise.prototype.__init.call(this);
      _SyncPromise.prototype.__init2.call(this);
      _SyncPromise.prototype.__init3.call(this);
      _SyncPromise.prototype.__init4.call(this);
      this._state = States.PENDING;
      this._handlers = [];
      try {
        executor(this._resolve, this._reject);
      } catch (e2) {
        this._reject(e2);
      }
    }
    /** JSDoc */
    then(onfulfilled, onrejected) {
      return new _SyncPromise((resolve, reject) => {
        this._handlers.push([
          false,
          (result) => {
            if (!onfulfilled) {
              resolve(result);
            } else {
              try {
                resolve(onfulfilled(result));
              } catch (e2) {
                reject(e2);
              }
            }
          },
          (reason) => {
            if (!onrejected) {
              reject(reason);
            } else {
              try {
                resolve(onrejected(reason));
              } catch (e2) {
                reject(e2);
              }
            }
          }
        ]);
        this._executeHandlers();
      });
    }
    /** JSDoc */
    catch(onrejected) {
      return this.then((val) => val, onrejected);
    }
    /** JSDoc */
    finally(onfinally) {
      return new _SyncPromise((resolve, reject) => {
        let val;
        let isRejected;
        return this.then(
          (value) => {
            isRejected = false;
            val = value;
            if (onfinally) {
              onfinally();
            }
          },
          (reason) => {
            isRejected = true;
            val = reason;
            if (onfinally) {
              onfinally();
            }
          }
        ).then(() => {
          if (isRejected) {
            reject(val);
            return;
          }
          resolve(val);
        });
      });
    }
    /** JSDoc */
    __init() {
      this._resolve = (value) => {
        this._setResult(States.RESOLVED, value);
      };
    }
    /** JSDoc */
    __init2() {
      this._reject = (reason) => {
        this._setResult(States.REJECTED, reason);
      };
    }
    /** JSDoc */
    __init3() {
      this._setResult = (state, value) => {
        if (this._state !== States.PENDING) {
          return;
        }
        if (isThenable(value)) {
          void value.then(this._resolve, this._reject);
          return;
        }
        this._state = state;
        this._value = value;
        this._executeHandlers();
      };
    }
    /** JSDoc */
    __init4() {
      this._executeHandlers = () => {
        if (this._state === States.PENDING) {
          return;
        }
        const cachedHandlers = this._handlers.slice();
        this._handlers = [];
        cachedHandlers.forEach((handler) => {
          if (handler[0]) {
            return;
          }
          if (this._state === States.RESOLVED) {
            handler[1](this._value);
          }
          if (this._state === States.REJECTED) {
            handler[2](this._value);
          }
          handler[0] = true;
        });
      };
    }
  };

  // node_modules/@sentry/utils/build/esm/promisebuffer.js
  function makePromiseBuffer(limit) {
    const buffer = [];
    function isReady() {
      return limit === void 0 || buffer.length < limit;
    }
    function remove2(task) {
      return buffer.splice(buffer.indexOf(task), 1)[0] || Promise.resolve(void 0);
    }
    function add(taskProducer) {
      if (!isReady()) {
        return rejectedSyncPromise(new SentryError("Not adding Promise because buffer limit was reached."));
      }
      const task = taskProducer();
      if (buffer.indexOf(task) === -1) {
        buffer.push(task);
      }
      void task.then(() => remove2(task)).then(
        null,
        () => remove2(task).then(null, () => {
        })
      );
      return task;
    }
    function drain(timeout) {
      return new SyncPromise((resolve, reject) => {
        let counter = buffer.length;
        if (!counter) {
          return resolve(true);
        }
        const capturedSetTimeout = setTimeout(() => {
          if (timeout && timeout > 0) {
            resolve(false);
          }
        }, timeout);
        buffer.forEach((item) => {
          void resolvedSyncPromise(item).then(() => {
            if (!--counter) {
              clearTimeout(capturedSetTimeout);
              resolve(true);
            }
          }, reject);
        });
      });
    }
    return {
      $: buffer,
      add,
      drain
    };
  }

  // node_modules/@sentry/utils/build/esm/url.js
  function parseUrl(url) {
    if (!url) {
      return {};
    }
    const match = url.match(/^(([^:/?#]+):)?(\/\/([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?$/);
    if (!match) {
      return {};
    }
    const query = match[6] || "";
    const fragment = match[8] || "";
    return {
      host: match[4],
      path: match[5],
      protocol: match[2],
      search: query,
      hash: fragment,
      relative: match[5] + query + fragment
      // everything minus origin
    };
  }

  // node_modules/@sentry/utils/build/esm/severity.js
  var validSeverityLevels = ["fatal", "error", "warning", "log", "info", "debug"];
  function severityLevelFromString(level) {
    return level === "warn" ? "warning" : validSeverityLevels.includes(level) ? level : "log";
  }

  // node_modules/@sentry/utils/build/esm/baggage.js
  var BAGGAGE_HEADER_NAME = "baggage";
  var SENTRY_BAGGAGE_KEY_PREFIX = "sentry-";
  var SENTRY_BAGGAGE_KEY_PREFIX_REGEX = /^sentry-/;
  var MAX_BAGGAGE_STRING_LENGTH = 8192;
  function baggageHeaderToDynamicSamplingContext(baggageHeader) {
    const baggageObject = parseBaggageHeader(baggageHeader);
    if (!baggageObject) {
      return void 0;
    }
    const dynamicSamplingContext = Object.entries(baggageObject).reduce((acc, [key, value]) => {
      if (key.match(SENTRY_BAGGAGE_KEY_PREFIX_REGEX)) {
        const nonPrefixedKey = key.slice(SENTRY_BAGGAGE_KEY_PREFIX.length);
        acc[nonPrefixedKey] = value;
      }
      return acc;
    }, {});
    if (Object.keys(dynamicSamplingContext).length > 0) {
      return dynamicSamplingContext;
    } else {
      return void 0;
    }
  }
  function dynamicSamplingContextToSentryBaggageHeader(dynamicSamplingContext) {
    if (!dynamicSamplingContext) {
      return void 0;
    }
    const sentryPrefixedDSC = Object.entries(dynamicSamplingContext).reduce(
      (acc, [dscKey, dscValue]) => {
        if (dscValue) {
          acc[`${SENTRY_BAGGAGE_KEY_PREFIX}${dscKey}`] = dscValue;
        }
        return acc;
      },
      {}
    );
    return objectToBaggageHeader(sentryPrefixedDSC);
  }
  function parseBaggageHeader(baggageHeader) {
    if (!baggageHeader || !isString(baggageHeader) && !Array.isArray(baggageHeader)) {
      return void 0;
    }
    if (Array.isArray(baggageHeader)) {
      return baggageHeader.reduce((acc, curr) => {
        const currBaggageObject = baggageHeaderToObject(curr);
        Object.entries(currBaggageObject).forEach(([key, value]) => {
          acc[key] = value;
        });
        return acc;
      }, {});
    }
    return baggageHeaderToObject(baggageHeader);
  }
  function baggageHeaderToObject(baggageHeader) {
    return baggageHeader.split(",").map((baggageEntry) => baggageEntry.split("=").map((keyOrValue) => decodeURIComponent(keyOrValue.trim()))).reduce((acc, [key, value]) => {
      if (key && value) {
        acc[key] = value;
      }
      return acc;
    }, {});
  }
  function objectToBaggageHeader(object) {
    if (Object.keys(object).length === 0) {
      return void 0;
    }
    return Object.entries(object).reduce((baggageHeader, [objectKey, objectValue], currentIndex) => {
      const baggageEntry = `${encodeURIComponent(objectKey)}=${encodeURIComponent(objectValue)}`;
      const newBaggageHeader = currentIndex === 0 ? baggageEntry : `${baggageHeader},${baggageEntry}`;
      if (newBaggageHeader.length > MAX_BAGGAGE_STRING_LENGTH) {
        DEBUG_BUILD && logger.warn(
          `Not adding key: ${objectKey} with val: ${objectValue} to baggage header due to exceeding baggage size limits.`
        );
        return baggageHeader;
      } else {
        return newBaggageHeader;
      }
    }, "");
  }

  // node_modules/@sentry/utils/build/esm/tracing.js
  var TRACEPARENT_REGEXP = new RegExp(
    "^[ \\t]*([0-9a-f]{32})?-?([0-9a-f]{16})?-?([01])?[ \\t]*$"
    // whitespace
  );
  function extractTraceparentData(traceparent) {
    if (!traceparent) {
      return void 0;
    }
    const matches2 = traceparent.match(TRACEPARENT_REGEXP);
    if (!matches2) {
      return void 0;
    }
    let parentSampled;
    if (matches2[3] === "1") {
      parentSampled = true;
    } else if (matches2[3] === "0") {
      parentSampled = false;
    }
    return {
      traceId: matches2[1],
      parentSampled,
      parentSpanId: matches2[2]
    };
  }
  function propagationContextFromHeaders(sentryTrace, baggage) {
    const traceparentData = extractTraceparentData(sentryTrace);
    const dynamicSamplingContext = baggageHeaderToDynamicSamplingContext(baggage);
    const { traceId, parentSpanId, parentSampled } = traceparentData || {};
    if (!traceparentData) {
      return {
        traceId: traceId || uuid4(),
        spanId: uuid4().substring(16)
      };
    } else {
      return {
        traceId: traceId || uuid4(),
        parentSpanId: parentSpanId || uuid4().substring(16),
        spanId: uuid4().substring(16),
        sampled: parentSampled,
        dsc: dynamicSamplingContext || {}
        // If we have traceparent data but no DSC it means we are not head of trace and we must freeze it
      };
    }
  }
  function generateSentryTraceHeader(traceId = uuid4(), spanId = uuid4().substring(16), sampled) {
    let sampledString = "";
    if (sampled !== void 0) {
      sampledString = sampled ? "-1" : "-0";
    }
    return `${traceId}-${spanId}${sampledString}`;
  }

  // node_modules/@sentry/utils/build/esm/envelope.js
  function createEnvelope(headers, items = []) {
    return [headers, items];
  }
  function addItemToEnvelope(envelope, newItem) {
    const [headers, items] = envelope;
    return [headers, [...items, newItem]];
  }
  function forEachEnvelopeItem(envelope, callback) {
    const envelopeItems = envelope[1];
    for (const envelopeItem of envelopeItems) {
      const envelopeItemType = envelopeItem[0].type;
      const result = callback(envelopeItem, envelopeItemType);
      if (result) {
        return true;
      }
    }
    return false;
  }
  function encodeUTF8(input) {
    return GLOBAL_OBJ.__SENTRY__ && GLOBAL_OBJ.__SENTRY__.encodePolyfill ? GLOBAL_OBJ.__SENTRY__.encodePolyfill(input) : new TextEncoder().encode(input);
  }
  function serializeEnvelope(envelope) {
    const [envHeaders, items] = envelope;
    let parts = JSON.stringify(envHeaders);
    function append(next) {
      if (typeof parts === "string") {
        parts = typeof next === "string" ? parts + next : [encodeUTF8(parts), next];
      } else {
        parts.push(typeof next === "string" ? encodeUTF8(next) : next);
      }
    }
    for (const item of items) {
      const [itemHeaders, payload] = item;
      append(`
${JSON.stringify(itemHeaders)}
`);
      if (typeof payload === "string" || payload instanceof Uint8Array) {
        append(payload);
      } else {
        let stringifiedPayload;
        try {
          stringifiedPayload = JSON.stringify(payload);
        } catch (e2) {
          stringifiedPayload = JSON.stringify(normalize(payload));
        }
        append(stringifiedPayload);
      }
    }
    return typeof parts === "string" ? parts : concatBuffers(parts);
  }
  function concatBuffers(buffers) {
    const totalLength = buffers.reduce((acc, buf) => acc + buf.length, 0);
    const merged = new Uint8Array(totalLength);
    let offset = 0;
    for (const buffer of buffers) {
      merged.set(buffer, offset);
      offset += buffer.length;
    }
    return merged;
  }
  function createSpanEnvelopeItem(spanJson) {
    const spanHeaders = {
      type: "span"
    };
    return [spanHeaders, spanJson];
  }
  function createAttachmentEnvelopeItem(attachment) {
    const buffer = typeof attachment.data === "string" ? encodeUTF8(attachment.data) : attachment.data;
    return [
      dropUndefinedKeys({
        type: "attachment",
        length: buffer.length,
        filename: attachment.filename,
        content_type: attachment.contentType,
        attachment_type: attachment.attachmentType
      }),
      buffer
    ];
  }
  var ITEM_TYPE_TO_DATA_CATEGORY_MAP = {
    session: "session",
    sessions: "session",
    attachment: "attachment",
    transaction: "transaction",
    event: "error",
    client_report: "internal",
    user_report: "default",
    profile: "profile",
    profile_chunk: "profile",
    replay_event: "replay",
    replay_recording: "replay",
    check_in: "monitor",
    feedback: "feedback",
    span: "span",
    statsd: "metric_bucket"
  };
  function envelopeItemTypeToDataCategory(type) {
    return ITEM_TYPE_TO_DATA_CATEGORY_MAP[type];
  }
  function getSdkMetadataForEnvelopeHeader(metadataOrEvent) {
    if (!metadataOrEvent || !metadataOrEvent.sdk) {
      return;
    }
    const { name, version } = metadataOrEvent.sdk;
    return { name, version };
  }
  function createEventEnvelopeHeaders(event, sdkInfo, tunnel, dsn) {
    const dynamicSamplingContext = event.sdkProcessingMetadata && event.sdkProcessingMetadata.dynamicSamplingContext;
    return {
      event_id: event.event_id,
      sent_at: (/* @__PURE__ */ new Date()).toISOString(),
      ...sdkInfo && { sdk: sdkInfo },
      ...!!tunnel && dsn && { dsn: dsnToString(dsn) },
      ...dynamicSamplingContext && {
        trace: dropUndefinedKeys({ ...dynamicSamplingContext })
      }
    };
  }

  // node_modules/@sentry/utils/build/esm/clientreport.js
  function createClientReportEnvelope(discarded_events, dsn, timestamp) {
    const clientReportItem = [
      { type: "client_report" },
      {
        timestamp: timestamp || dateTimestampInSeconds(),
        discarded_events
      }
    ];
    return createEnvelope(dsn ? { dsn } : {}, [clientReportItem]);
  }

  // node_modules/@sentry/utils/build/esm/ratelimit.js
  var DEFAULT_RETRY_AFTER = 60 * 1e3;
  function parseRetryAfterHeader(header, now = Date.now()) {
    const headerDelay = parseInt(`${header}`, 10);
    if (!isNaN(headerDelay)) {
      return headerDelay * 1e3;
    }
    const headerDate = Date.parse(`${header}`);
    if (!isNaN(headerDate)) {
      return headerDate - now;
    }
    return DEFAULT_RETRY_AFTER;
  }
  function disabledUntil(limits, dataCategory) {
    return limits[dataCategory] || limits.all || 0;
  }
  function isRateLimited(limits, dataCategory, now = Date.now()) {
    return disabledUntil(limits, dataCategory) > now;
  }
  function updateRateLimits(limits, { statusCode, headers }, now = Date.now()) {
    const updatedRateLimits = {
      ...limits
    };
    const rateLimitHeader = headers && headers["x-sentry-rate-limits"];
    const retryAfterHeader = headers && headers["retry-after"];
    if (rateLimitHeader) {
      for (const limit of rateLimitHeader.trim().split(",")) {
        const [retryAfter, categories, , , namespaces] = limit.split(":", 5);
        const headerDelay = parseInt(retryAfter, 10);
        const delay = (!isNaN(headerDelay) ? headerDelay : 60) * 1e3;
        if (!categories) {
          updatedRateLimits.all = now + delay;
        } else {
          for (const category of categories.split(";")) {
            if (category === "metric_bucket") {
              if (!namespaces || namespaces.split(";").includes("custom")) {
                updatedRateLimits[category] = now + delay;
              }
            } else {
              updatedRateLimits[category] = now + delay;
            }
          }
        }
      }
    } else if (retryAfterHeader) {
      updatedRateLimits.all = now + parseRetryAfterHeader(retryAfterHeader, now);
    } else if (statusCode === 429) {
      updatedRateLimits.all = now + 60 * 1e3;
    }
    return updatedRateLimits;
  }

  // node_modules/@sentry/utils/build/esm/buildPolyfills/_nullishCoalesce.js
  function _nullishCoalesce(lhs, rhsFn) {
    return lhs != null ? lhs : rhsFn();
  }

  // node_modules/@sentry/utils/build/esm/buildPolyfills/_optionalChain.js
  function _optionalChain(ops) {
    let lastAccessLHS = void 0;
    let value = ops[0];
    let i = 1;
    while (i < ops.length) {
      const op = ops[i];
      const fn = ops[i + 1];
      i += 2;
      if ((op === "optionalAccess" || op === "optionalCall") && value == null) {
        return;
      }
      if (op === "access" || op === "optionalAccess") {
        lastAccessLHS = value;
        value = fn(value);
      } else if (op === "call" || op === "optionalCall") {
        value = fn((...args) => value.call(lastAccessLHS, ...args));
        lastAccessLHS = void 0;
      }
    }
    return value;
  }

  // node_modules/@sentry/utils/build/esm/propagationContext.js
  function generatePropagationContext() {
    return {
      traceId: uuid4(),
      spanId: uuid4().substring(16)
    };
  }

  // node_modules/@sentry/utils/build/esm/vendor/supportsHistory.js
  var WINDOW3 = GLOBAL_OBJ;
  function supportsHistory() {
    const chromeVar = WINDOW3.chrome;
    const isChromePackagedApp = chromeVar && chromeVar.app && chromeVar.app.runtime;
    const hasHistoryApi = "history" in WINDOW3 && !!WINDOW3.history.pushState && !!WINDOW3.history.replaceState;
    return !isChromePackagedApp && hasHistoryApi;
  }

  // node_modules/@sentry/core/build/esm/debug-build.js
  var DEBUG_BUILD2 = typeof __SENTRY_DEBUG__ === "undefined" || __SENTRY_DEBUG__;

  // node_modules/@sentry/core/build/esm/carrier.js
  function getMainCarrier() {
    getSentryCarrier(GLOBAL_OBJ);
    return GLOBAL_OBJ;
  }
  function getSentryCarrier(carrier) {
    const __SENTRY__ = carrier.__SENTRY__ = carrier.__SENTRY__ || {};
    __SENTRY__.version = __SENTRY__.version || SDK_VERSION;
    return __SENTRY__[SDK_VERSION] = __SENTRY__[SDK_VERSION] || {};
  }

  // node_modules/@sentry/core/build/esm/session.js
  function makeSession(context) {
    const startingTime = timestampInSeconds();
    const session = {
      sid: uuid4(),
      init: true,
      timestamp: startingTime,
      started: startingTime,
      duration: 0,
      status: "ok",
      errors: 0,
      ignoreDuration: false,
      toJSON: () => sessionToJSON(session)
    };
    if (context) {
      updateSession(session, context);
    }
    return session;
  }
  function updateSession(session, context = {}) {
    if (context.user) {
      if (!session.ipAddress && context.user.ip_address) {
        session.ipAddress = context.user.ip_address;
      }
      if (!session.did && !context.did) {
        session.did = context.user.id || context.user.email || context.user.username;
      }
    }
    session.timestamp = context.timestamp || timestampInSeconds();
    if (context.abnormal_mechanism) {
      session.abnormal_mechanism = context.abnormal_mechanism;
    }
    if (context.ignoreDuration) {
      session.ignoreDuration = context.ignoreDuration;
    }
    if (context.sid) {
      session.sid = context.sid.length === 32 ? context.sid : uuid4();
    }
    if (context.init !== void 0) {
      session.init = context.init;
    }
    if (!session.did && context.did) {
      session.did = `${context.did}`;
    }
    if (typeof context.started === "number") {
      session.started = context.started;
    }
    if (session.ignoreDuration) {
      session.duration = void 0;
    } else if (typeof context.duration === "number") {
      session.duration = context.duration;
    } else {
      const duration = session.timestamp - session.started;
      session.duration = duration >= 0 ? duration : 0;
    }
    if (context.release) {
      session.release = context.release;
    }
    if (context.environment) {
      session.environment = context.environment;
    }
    if (!session.ipAddress && context.ipAddress) {
      session.ipAddress = context.ipAddress;
    }
    if (!session.userAgent && context.userAgent) {
      session.userAgent = context.userAgent;
    }
    if (typeof context.errors === "number") {
      session.errors = context.errors;
    }
    if (context.status) {
      session.status = context.status;
    }
  }
  function closeSession(session, status) {
    let context = {};
    if (status) {
      context = { status };
    } else if (session.status === "ok") {
      context = { status: "exited" };
    }
    updateSession(session, context);
  }
  function sessionToJSON(session) {
    return dropUndefinedKeys({
      sid: `${session.sid}`,
      init: session.init,
      // Make sure that sec is converted to ms for date constructor
      started: new Date(session.started * 1e3).toISOString(),
      timestamp: new Date(session.timestamp * 1e3).toISOString(),
      status: session.status,
      errors: session.errors,
      did: typeof session.did === "number" || typeof session.did === "string" ? `${session.did}` : void 0,
      duration: session.duration,
      abnormal_mechanism: session.abnormal_mechanism,
      attrs: {
        release: session.release,
        environment: session.environment,
        ip_address: session.ipAddress,
        user_agent: session.userAgent
      }
    });
  }

  // node_modules/@sentry/core/build/esm/utils/spanOnScope.js
  var SCOPE_SPAN_FIELD = "_sentrySpan";
  function _setSpanForScope(scope, span) {
    if (span) {
      addNonEnumerableProperty(scope, SCOPE_SPAN_FIELD, span);
    } else {
      delete scope[SCOPE_SPAN_FIELD];
    }
  }
  function _getSpanForScope(scope) {
    return scope[SCOPE_SPAN_FIELD];
  }

  // node_modules/@sentry/core/build/esm/scope.js
  var DEFAULT_MAX_BREADCRUMBS = 100;
  var ScopeClass = class _ScopeClass {
    /** Flag if notifying is happening. */
    /** Callback for client to receive scope changes. */
    /** Callback list that will be called during event processing. */
    /** Array of breadcrumbs. */
    /** User */
    /** Tags */
    /** Extra */
    /** Contexts */
    /** Attachments */
    /** Propagation Context for distributed tracing */
    /**
     * A place to stash data which is needed at some point in the SDK's event processing pipeline but which shouldn't get
     * sent to Sentry
     */
    /** Fingerprint */
    /** Severity */
    /**
     * Transaction Name
     *
     * IMPORTANT: The transaction name on the scope has nothing to do with root spans/transaction objects.
     * It's purpose is to assign a transaction to the scope that's added to non-transaction events.
     */
    /** Session */
    /** Request Mode Session Status */
    /** The client on this scope */
    /** Contains the last event id of a captured event.  */
    // NOTE: Any field which gets added here should get added not only to the constructor but also to the `clone` method.
    constructor() {
      this._notifyingListeners = false;
      this._scopeListeners = [];
      this._eventProcessors = [];
      this._breadcrumbs = [];
      this._attachments = [];
      this._user = {};
      this._tags = {};
      this._extra = {};
      this._contexts = {};
      this._sdkProcessingMetadata = {};
      this._propagationContext = generatePropagationContext();
    }
    /**
     * @inheritDoc
     */
    clone() {
      const newScope = new _ScopeClass();
      newScope._breadcrumbs = [...this._breadcrumbs];
      newScope._tags = { ...this._tags };
      newScope._extra = { ...this._extra };
      newScope._contexts = { ...this._contexts };
      newScope._user = this._user;
      newScope._level = this._level;
      newScope._session = this._session;
      newScope._transactionName = this._transactionName;
      newScope._fingerprint = this._fingerprint;
      newScope._eventProcessors = [...this._eventProcessors];
      newScope._requestSession = this._requestSession;
      newScope._attachments = [...this._attachments];
      newScope._sdkProcessingMetadata = { ...this._sdkProcessingMetadata };
      newScope._propagationContext = { ...this._propagationContext };
      newScope._client = this._client;
      newScope._lastEventId = this._lastEventId;
      _setSpanForScope(newScope, _getSpanForScope(this));
      return newScope;
    }
    /**
     * @inheritDoc
     */
    setClient(client) {
      this._client = client;
    }
    /**
     * @inheritDoc
     */
    setLastEventId(lastEventId2) {
      this._lastEventId = lastEventId2;
    }
    /**
     * @inheritDoc
     */
    getClient() {
      return this._client;
    }
    /**
     * @inheritDoc
     */
    lastEventId() {
      return this._lastEventId;
    }
    /**
     * @inheritDoc
     */
    addScopeListener(callback) {
      this._scopeListeners.push(callback);
    }
    /**
     * @inheritDoc
     */
    addEventProcessor(callback) {
      this._eventProcessors.push(callback);
      return this;
    }
    /**
     * @inheritDoc
     */
    setUser(user) {
      this._user = user || {
        email: void 0,
        id: void 0,
        ip_address: void 0,
        username: void 0
      };
      if (this._session) {
        updateSession(this._session, { user });
      }
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    getUser() {
      return this._user;
    }
    /**
     * @inheritDoc
     */
    getRequestSession() {
      return this._requestSession;
    }
    /**
     * @inheritDoc
     */
    setRequestSession(requestSession) {
      this._requestSession = requestSession;
      return this;
    }
    /**
     * @inheritDoc
     */
    setTags(tags) {
      this._tags = {
        ...this._tags,
        ...tags
      };
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    setTag(key, value) {
      this._tags = { ...this._tags, [key]: value };
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    setExtras(extras) {
      this._extra = {
        ...this._extra,
        ...extras
      };
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    setExtra(key, extra) {
      this._extra = { ...this._extra, [key]: extra };
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    setFingerprint(fingerprint) {
      this._fingerprint = fingerprint;
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    setLevel(level) {
      this._level = level;
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    setTransactionName(name) {
      this._transactionName = name;
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    setContext(key, context) {
      if (context === null) {
        delete this._contexts[key];
      } else {
        this._contexts[key] = context;
      }
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    setSession(session) {
      if (!session) {
        delete this._session;
      } else {
        this._session = session;
      }
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    getSession() {
      return this._session;
    }
    /**
     * @inheritDoc
     */
    update(captureContext) {
      if (!captureContext) {
        return this;
      }
      const scopeToMerge = typeof captureContext === "function" ? captureContext(this) : captureContext;
      const [scopeInstance, requestSession] = scopeToMerge instanceof Scope ? [scopeToMerge.getScopeData(), scopeToMerge.getRequestSession()] : isPlainObject(scopeToMerge) ? [captureContext, captureContext.requestSession] : [];
      const { tags, extra, user, contexts, level, fingerprint = [], propagationContext } = scopeInstance || {};
      this._tags = { ...this._tags, ...tags };
      this._extra = { ...this._extra, ...extra };
      this._contexts = { ...this._contexts, ...contexts };
      if (user && Object.keys(user).length) {
        this._user = user;
      }
      if (level) {
        this._level = level;
      }
      if (fingerprint.length) {
        this._fingerprint = fingerprint;
      }
      if (propagationContext) {
        this._propagationContext = propagationContext;
      }
      if (requestSession) {
        this._requestSession = requestSession;
      }
      return this;
    }
    /**
     * @inheritDoc
     */
    clear() {
      this._breadcrumbs = [];
      this._tags = {};
      this._extra = {};
      this._user = {};
      this._contexts = {};
      this._level = void 0;
      this._transactionName = void 0;
      this._fingerprint = void 0;
      this._requestSession = void 0;
      this._session = void 0;
      _setSpanForScope(this, void 0);
      this._attachments = [];
      this._propagationContext = generatePropagationContext();
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    addBreadcrumb(breadcrumb, maxBreadcrumbs) {
      const maxCrumbs = typeof maxBreadcrumbs === "number" ? maxBreadcrumbs : DEFAULT_MAX_BREADCRUMBS;
      if (maxCrumbs <= 0) {
        return this;
      }
      const mergedBreadcrumb = {
        timestamp: dateTimestampInSeconds(),
        ...breadcrumb
      };
      const breadcrumbs = this._breadcrumbs;
      breadcrumbs.push(mergedBreadcrumb);
      this._breadcrumbs = breadcrumbs.length > maxCrumbs ? breadcrumbs.slice(-maxCrumbs) : breadcrumbs;
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    getLastBreadcrumb() {
      return this._breadcrumbs[this._breadcrumbs.length - 1];
    }
    /**
     * @inheritDoc
     */
    clearBreadcrumbs() {
      this._breadcrumbs = [];
      this._notifyScopeListeners();
      return this;
    }
    /**
     * @inheritDoc
     */
    addAttachment(attachment) {
      this._attachments.push(attachment);
      return this;
    }
    /**
     * @inheritDoc
     */
    clearAttachments() {
      this._attachments = [];
      return this;
    }
    /** @inheritDoc */
    getScopeData() {
      return {
        breadcrumbs: this._breadcrumbs,
        attachments: this._attachments,
        contexts: this._contexts,
        tags: this._tags,
        extra: this._extra,
        user: this._user,
        level: this._level,
        fingerprint: this._fingerprint || [],
        eventProcessors: this._eventProcessors,
        propagationContext: this._propagationContext,
        sdkProcessingMetadata: this._sdkProcessingMetadata,
        transactionName: this._transactionName,
        span: _getSpanForScope(this)
      };
    }
    /**
     * @inheritDoc
     */
    setSDKProcessingMetadata(newData) {
      this._sdkProcessingMetadata = { ...this._sdkProcessingMetadata, ...newData };
      return this;
    }
    /**
     * @inheritDoc
     */
    setPropagationContext(context) {
      this._propagationContext = context;
      return this;
    }
    /**
     * @inheritDoc
     */
    getPropagationContext() {
      return this._propagationContext;
    }
    /**
     * @inheritDoc
     */
    captureException(exception, hint) {
      const eventId = hint && hint.event_id ? hint.event_id : uuid4();
      if (!this._client) {
        logger.warn("No client configured on scope - will not capture exception!");
        return eventId;
      }
      const syntheticException = new Error("Sentry syntheticException");
      this._client.captureException(
        exception,
        {
          originalException: exception,
          syntheticException,
          ...hint,
          event_id: eventId
        },
        this
      );
      return eventId;
    }
    /**
     * @inheritDoc
     */
    captureMessage(message, level, hint) {
      const eventId = hint && hint.event_id ? hint.event_id : uuid4();
      if (!this._client) {
        logger.warn("No client configured on scope - will not capture message!");
        return eventId;
      }
      const syntheticException = new Error(message);
      this._client.captureMessage(
        message,
        level,
        {
          originalException: message,
          syntheticException,
          ...hint,
          event_id: eventId
        },
        this
      );
      return eventId;
    }
    /**
     * @inheritDoc
     */
    captureEvent(event, hint) {
      const eventId = hint && hint.event_id ? hint.event_id : uuid4();
      if (!this._client) {
        logger.warn("No client configured on scope - will not capture event!");
        return eventId;
      }
      this._client.captureEvent(event, { ...hint, event_id: eventId }, this);
      return eventId;
    }
    /**
     * This will be called on every set call.
     */
    _notifyScopeListeners() {
      if (!this._notifyingListeners) {
        this._notifyingListeners = true;
        this._scopeListeners.forEach((callback) => {
          callback(this);
        });
        this._notifyingListeners = false;
      }
    }
  };
  var Scope = ScopeClass;

  // node_modules/@sentry/core/build/esm/defaultScopes.js
  function getDefaultCurrentScope() {
    return getGlobalSingleton("defaultCurrentScope", () => new Scope());
  }
  function getDefaultIsolationScope() {
    return getGlobalSingleton("defaultIsolationScope", () => new Scope());
  }

  // node_modules/@sentry/core/build/esm/asyncContext/stackStrategy.js
  var AsyncContextStack = class {
    constructor(scope, isolationScope) {
      let assignedScope;
      if (!scope) {
        assignedScope = new Scope();
      } else {
        assignedScope = scope;
      }
      let assignedIsolationScope;
      if (!isolationScope) {
        assignedIsolationScope = new Scope();
      } else {
        assignedIsolationScope = isolationScope;
      }
      this._stack = [{ scope: assignedScope }];
      this._isolationScope = assignedIsolationScope;
    }
    /**
     * Fork a scope for the stack.
     */
    withScope(callback) {
      const scope = this._pushScope();
      let maybePromiseResult;
      try {
        maybePromiseResult = callback(scope);
      } catch (e2) {
        this._popScope();
        throw e2;
      }
      if (isThenable(maybePromiseResult)) {
        return maybePromiseResult.then(
          (res) => {
            this._popScope();
            return res;
          },
          (e2) => {
            this._popScope();
            throw e2;
          }
        );
      }
      this._popScope();
      return maybePromiseResult;
    }
    /**
     * Get the client of the stack.
     */
    getClient() {
      return this.getStackTop().client;
    }
    /**
     * Returns the scope of the top stack.
     */
    getScope() {
      return this.getStackTop().scope;
    }
    /**
     * Get the isolation scope for the stack.
     */
    getIsolationScope() {
      return this._isolationScope;
    }
    /**
     * Returns the topmost scope layer in the order domain > local > process.
     */
    getStackTop() {
      return this._stack[this._stack.length - 1];
    }
    /**
     * Push a scope to the stack.
     */
    _pushScope() {
      const scope = this.getScope().clone();
      this._stack.push({
        client: this.getClient(),
        scope
      });
      return scope;
    }
    /**
     * Pop a scope from the stack.
     */
    _popScope() {
      if (this._stack.length <= 1) return false;
      return !!this._stack.pop();
    }
  };
  function getAsyncContextStack() {
    const registry = getMainCarrier();
    const sentry = getSentryCarrier(registry);
    return sentry.stack = sentry.stack || new AsyncContextStack(getDefaultCurrentScope(), getDefaultIsolationScope());
  }
  function withScope(callback) {
    return getAsyncContextStack().withScope(callback);
  }
  function withSetScope(scope, callback) {
    const stack = getAsyncContextStack();
    return stack.withScope(() => {
      stack.getStackTop().scope = scope;
      return callback(scope);
    });
  }
  function withIsolationScope(callback) {
    return getAsyncContextStack().withScope(() => {
      return callback(getAsyncContextStack().getIsolationScope());
    });
  }
  function getStackAsyncContextStrategy() {
    return {
      withIsolationScope,
      withScope,
      withSetScope,
      withSetIsolationScope: (_isolationScope, callback) => {
        return withIsolationScope(callback);
      },
      getCurrentScope: () => getAsyncContextStack().getScope(),
      getIsolationScope: () => getAsyncContextStack().getIsolationScope()
    };
  }

  // node_modules/@sentry/core/build/esm/asyncContext/index.js
  function getAsyncContextStrategy(carrier) {
    const sentry = getSentryCarrier(carrier);
    if (sentry.acs) {
      return sentry.acs;
    }
    return getStackAsyncContextStrategy();
  }

  // node_modules/@sentry/core/build/esm/currentScopes.js
  function getCurrentScope() {
    const carrier = getMainCarrier();
    const acs = getAsyncContextStrategy(carrier);
    return acs.getCurrentScope();
  }
  function getIsolationScope() {
    const carrier = getMainCarrier();
    const acs = getAsyncContextStrategy(carrier);
    return acs.getIsolationScope();
  }
  function getGlobalScope() {
    return getGlobalSingleton("globalScope", () => new Scope());
  }
  function withScope2(...rest) {
    const carrier = getMainCarrier();
    const acs = getAsyncContextStrategy(carrier);
    if (rest.length === 2) {
      const [scope, callback] = rest;
      if (!scope) {
        return acs.withScope(callback);
      }
      return acs.withSetScope(scope, callback);
    }
    return acs.withScope(rest[0]);
  }
  function getClient() {
    return getCurrentScope().getClient();
  }

  // node_modules/@sentry/core/build/esm/metrics/metric-summary.js
  var METRICS_SPAN_FIELD = "_sentryMetrics";
  function getMetricSummaryJsonForSpan(span) {
    const storage = span[METRICS_SPAN_FIELD];
    if (!storage) {
      return void 0;
    }
    const output = {};
    for (const [, [exportKey, summary]] of storage) {
      const arr = output[exportKey] || (output[exportKey] = []);
      arr.push(dropUndefinedKeys(summary));
    }
    return output;
  }

  // node_modules/@sentry/core/build/esm/semanticAttributes.js
  var SEMANTIC_ATTRIBUTE_SENTRY_SOURCE = "sentry.source";
  var SEMANTIC_ATTRIBUTE_SENTRY_SAMPLE_RATE = "sentry.sample_rate";
  var SEMANTIC_ATTRIBUTE_SENTRY_OP = "sentry.op";
  var SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN = "sentry.origin";
  var SEMANTIC_ATTRIBUTE_SENTRY_IDLE_SPAN_FINISH_REASON = "sentry.idle_span_finish_reason";
  var SEMANTIC_ATTRIBUTE_SENTRY_MEASUREMENT_UNIT = "sentry.measurement_unit";
  var SEMANTIC_ATTRIBUTE_SENTRY_MEASUREMENT_VALUE = "sentry.measurement_value";
  var SEMANTIC_ATTRIBUTE_PROFILE_ID = "sentry.profile_id";
  var SEMANTIC_ATTRIBUTE_EXCLUSIVE_TIME = "sentry.exclusive_time";

  // node_modules/@sentry/core/build/esm/tracing/spanstatus.js
  var SPAN_STATUS_UNSET = 0;
  var SPAN_STATUS_OK = 1;
  var SPAN_STATUS_ERROR = 2;
  function getSpanStatusFromHttpCode(httpStatus) {
    if (httpStatus < 400 && httpStatus >= 100) {
      return { code: SPAN_STATUS_OK };
    }
    if (httpStatus >= 400 && httpStatus < 500) {
      switch (httpStatus) {
        case 401:
          return { code: SPAN_STATUS_ERROR, message: "unauthenticated" };
        case 403:
          return { code: SPAN_STATUS_ERROR, message: "permission_denied" };
        case 404:
          return { code: SPAN_STATUS_ERROR, message: "not_found" };
        case 409:
          return { code: SPAN_STATUS_ERROR, message: "already_exists" };
        case 413:
          return { code: SPAN_STATUS_ERROR, message: "failed_precondition" };
        case 429:
          return { code: SPAN_STATUS_ERROR, message: "resource_exhausted" };
        case 499:
          return { code: SPAN_STATUS_ERROR, message: "cancelled" };
        default:
          return { code: SPAN_STATUS_ERROR, message: "invalid_argument" };
      }
    }
    if (httpStatus >= 500 && httpStatus < 600) {
      switch (httpStatus) {
        case 501:
          return { code: SPAN_STATUS_ERROR, message: "unimplemented" };
        case 503:
          return { code: SPAN_STATUS_ERROR, message: "unavailable" };
        case 504:
          return { code: SPAN_STATUS_ERROR, message: "deadline_exceeded" };
        default:
          return { code: SPAN_STATUS_ERROR, message: "internal_error" };
      }
    }
    return { code: SPAN_STATUS_ERROR, message: "unknown_error" };
  }
  function setHttpStatus(span, httpStatus) {
    span.setAttribute("http.response.status_code", httpStatus);
    const spanStatus = getSpanStatusFromHttpCode(httpStatus);
    if (spanStatus.message !== "unknown_error") {
      span.setStatus(spanStatus);
    }
  }

  // node_modules/@sentry/core/build/esm/utils/spanUtils.js
  var TRACE_FLAG_NONE = 0;
  var TRACE_FLAG_SAMPLED = 1;
  function spanToTransactionTraceContext(span) {
    const { spanId: span_id, traceId: trace_id } = span.spanContext();
    const { data, op, parent_span_id, status, origin } = spanToJSON(span);
    return dropUndefinedKeys({
      parent_span_id,
      span_id,
      trace_id,
      data,
      op,
      status,
      origin
    });
  }
  function spanToTraceContext(span) {
    const { spanId: span_id, traceId: trace_id } = span.spanContext();
    const { parent_span_id } = spanToJSON(span);
    return dropUndefinedKeys({ parent_span_id, span_id, trace_id });
  }
  function spanToTraceHeader(span) {
    const { traceId, spanId } = span.spanContext();
    const sampled = spanIsSampled(span);
    return generateSentryTraceHeader(traceId, spanId, sampled);
  }
  function spanTimeInputToSeconds(input) {
    if (typeof input === "number") {
      return ensureTimestampInSeconds(input);
    }
    if (Array.isArray(input)) {
      return input[0] + input[1] / 1e9;
    }
    if (input instanceof Date) {
      return ensureTimestampInSeconds(input.getTime());
    }
    return timestampInSeconds();
  }
  function ensureTimestampInSeconds(timestamp) {
    const isMs = timestamp > 9999999999;
    return isMs ? timestamp / 1e3 : timestamp;
  }
  function spanToJSON(span) {
    if (spanIsSentrySpan(span)) {
      return span.getSpanJSON();
    }
    try {
      const { spanId: span_id, traceId: trace_id } = span.spanContext();
      if (spanIsOpenTelemetrySdkTraceBaseSpan(span)) {
        const { attributes, startTime, name, endTime, parentSpanId, status } = span;
        return dropUndefinedKeys({
          span_id,
          trace_id,
          data: attributes,
          description: name,
          parent_span_id: parentSpanId,
          start_timestamp: spanTimeInputToSeconds(startTime),
          // This is [0,0] by default in OTEL, in which case we want to interpret this as no end time
          timestamp: spanTimeInputToSeconds(endTime) || void 0,
          status: getStatusMessage(status),
          op: attributes[SEMANTIC_ATTRIBUTE_SENTRY_OP],
          origin: attributes[SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN],
          _metrics_summary: getMetricSummaryJsonForSpan(span)
        });
      }
      return {
        span_id,
        trace_id
      };
    } catch (e2) {
      return {};
    }
  }
  function spanIsOpenTelemetrySdkTraceBaseSpan(span) {
    const castSpan = span;
    return !!castSpan.attributes && !!castSpan.startTime && !!castSpan.name && !!castSpan.endTime && !!castSpan.status;
  }
  function spanIsSentrySpan(span) {
    return typeof span.getSpanJSON === "function";
  }
  function spanIsSampled(span) {
    const { traceFlags } = span.spanContext();
    return traceFlags === TRACE_FLAG_SAMPLED;
  }
  function getStatusMessage(status) {
    if (!status || status.code === SPAN_STATUS_UNSET) {
      return void 0;
    }
    if (status.code === SPAN_STATUS_OK) {
      return "ok";
    }
    return status.message || "unknown_error";
  }
  var CHILD_SPANS_FIELD = "_sentryChildSpans";
  var ROOT_SPAN_FIELD = "_sentryRootSpan";
  function addChildSpanToSpan(span, childSpan) {
    const rootSpan = span[ROOT_SPAN_FIELD] || span;
    addNonEnumerableProperty(childSpan, ROOT_SPAN_FIELD, rootSpan);
    if (span[CHILD_SPANS_FIELD]) {
      span[CHILD_SPANS_FIELD].add(childSpan);
    } else {
      addNonEnumerableProperty(span, CHILD_SPANS_FIELD, /* @__PURE__ */ new Set([childSpan]));
    }
  }
  function removeChildSpanFromSpan(span, childSpan) {
    if (span[CHILD_SPANS_FIELD]) {
      span[CHILD_SPANS_FIELD].delete(childSpan);
    }
  }
  function getSpanDescendants(span) {
    const resultSet = /* @__PURE__ */ new Set();
    function addSpanChildren(span2) {
      if (resultSet.has(span2)) {
        return;
      } else if (spanIsSampled(span2)) {
        resultSet.add(span2);
        const childSpans = span2[CHILD_SPANS_FIELD] ? Array.from(span2[CHILD_SPANS_FIELD]) : [];
        for (const childSpan of childSpans) {
          addSpanChildren(childSpan);
        }
      }
    }
    addSpanChildren(span);
    return Array.from(resultSet);
  }
  function getRootSpan(span) {
    return span[ROOT_SPAN_FIELD] || span;
  }
  function getActiveSpan() {
    const carrier = getMainCarrier();
    const acs = getAsyncContextStrategy(carrier);
    if (acs.getActiveSpan) {
      return acs.getActiveSpan();
    }
    return _getSpanForScope(getCurrentScope());
  }

  // node_modules/@sentry/core/build/esm/tracing/errors.js
  var errorsInstrumented = false;
  function registerSpanErrorInstrumentation() {
    if (errorsInstrumented) {
      return;
    }
    errorsInstrumented = true;
    addGlobalErrorInstrumentationHandler(errorCallback);
    addGlobalUnhandledRejectionInstrumentationHandler(errorCallback);
  }
  function errorCallback() {
    const activeSpan = getActiveSpan();
    const rootSpan = activeSpan && getRootSpan(activeSpan);
    if (rootSpan) {
      const message = "internal_error";
      DEBUG_BUILD2 && logger.log(`[Tracing] Root span: ${message} -> Global error occured`);
      rootSpan.setStatus({ code: SPAN_STATUS_ERROR, message });
    }
  }
  errorCallback.tag = "sentry_tracingErrorCallback";

  // node_modules/@sentry/core/build/esm/tracing/utils.js
  var SCOPE_ON_START_SPAN_FIELD = "_sentryScope";
  var ISOLATION_SCOPE_ON_START_SPAN_FIELD = "_sentryIsolationScope";
  function setCapturedScopesOnSpan(span, scope, isolationScope) {
    if (span) {
      addNonEnumerableProperty(span, ISOLATION_SCOPE_ON_START_SPAN_FIELD, isolationScope);
      addNonEnumerableProperty(span, SCOPE_ON_START_SPAN_FIELD, scope);
    }
  }
  function getCapturedScopesOnSpan(span) {
    return {
      scope: span[SCOPE_ON_START_SPAN_FIELD],
      isolationScope: span[ISOLATION_SCOPE_ON_START_SPAN_FIELD]
    };
  }

  // node_modules/@sentry/core/build/esm/utils/hasTracingEnabled.js
  function hasTracingEnabled(maybeOptions) {
    if (typeof __SENTRY_TRACING__ === "boolean" && !__SENTRY_TRACING__) {
      return false;
    }
    const client = getClient();
    const options = maybeOptions || client && client.getOptions();
    return !!options && (options.enableTracing || "tracesSampleRate" in options || "tracesSampler" in options);
  }

  // node_modules/@sentry/core/build/esm/tracing/sentryNonRecordingSpan.js
  var SentryNonRecordingSpan = class {
    constructor(spanContext = {}) {
      this._traceId = spanContext.traceId || uuid4();
      this._spanId = spanContext.spanId || uuid4().substring(16);
    }
    /** @inheritdoc */
    spanContext() {
      return {
        spanId: this._spanId,
        traceId: this._traceId,
        traceFlags: TRACE_FLAG_NONE
      };
    }
    /** @inheritdoc */
    // eslint-disable-next-line @typescript-eslint/no-empty-function
    end(_timestamp) {
    }
    /** @inheritdoc */
    setAttribute(_key, _value) {
      return this;
    }
    /** @inheritdoc */
    setAttributes(_values) {
      return this;
    }
    /** @inheritdoc */
    setStatus(_status) {
      return this;
    }
    /** @inheritdoc */
    updateName(_name) {
      return this;
    }
    /** @inheritdoc */
    isRecording() {
      return false;
    }
    /** @inheritdoc */
    addEvent(_name, _attributesOrStartTime, _startTime) {
      return this;
    }
    /**
     * This should generally not be used,
     * but we need it for being comliant with the OTEL Span interface.
     *
     * @hidden
     * @internal
     */
    addLink(_link) {
      return this;
    }
    /**
     * This should generally not be used,
     * but we need it for being comliant with the OTEL Span interface.
     *
     * @hidden
     * @internal
     */
    addLinks(_links) {
      return this;
    }
    /**
     * This should generally not be used,
     * but we need it for being comliant with the OTEL Span interface.
     *
     * @hidden
     * @internal
     */
    recordException(_exception, _time) {
    }
  };

  // node_modules/@sentry/core/build/esm/constants.js
  var DEFAULT_ENVIRONMENT = "production";

  // node_modules/@sentry/core/build/esm/tracing/dynamicSamplingContext.js
  var FROZEN_DSC_FIELD = "_frozenDsc";
  function freezeDscOnSpan(span, dsc) {
    const spanWithMaybeDsc = span;
    addNonEnumerableProperty(spanWithMaybeDsc, FROZEN_DSC_FIELD, dsc);
  }
  function getDynamicSamplingContextFromClient(trace_id, client) {
    const options = client.getOptions();
    const { publicKey: public_key } = client.getDsn() || {};
    const dsc = dropUndefinedKeys({
      environment: options.environment || DEFAULT_ENVIRONMENT,
      release: options.release,
      public_key,
      trace_id
    });
    client.emit("createDsc", dsc);
    return dsc;
  }
  function getDynamicSamplingContextFromSpan(span) {
    const client = getClient();
    if (!client) {
      return {};
    }
    const dsc = getDynamicSamplingContextFromClient(spanToJSON(span).trace_id || "", client);
    const rootSpan = getRootSpan(span);
    const frozenDsc = rootSpan[FROZEN_DSC_FIELD];
    if (frozenDsc) {
      return frozenDsc;
    }
    const traceState = rootSpan.spanContext().traceState;
    const traceStateDsc = traceState && traceState.get("sentry.dsc");
    const dscOnTraceState = traceStateDsc && baggageHeaderToDynamicSamplingContext(traceStateDsc);
    if (dscOnTraceState) {
      return dscOnTraceState;
    }
    const jsonSpan = spanToJSON(rootSpan);
    const attributes = jsonSpan.data || {};
    const maybeSampleRate = attributes[SEMANTIC_ATTRIBUTE_SENTRY_SAMPLE_RATE];
    if (maybeSampleRate != null) {
      dsc.sample_rate = `${maybeSampleRate}`;
    }
    const source = attributes[SEMANTIC_ATTRIBUTE_SENTRY_SOURCE];
    const name = jsonSpan.description;
    if (source !== "url" && name) {
      dsc.transaction = name;
    }
    if (hasTracingEnabled()) {
      dsc.sampled = String(spanIsSampled(rootSpan));
    }
    client.emit("createDsc", dsc, rootSpan);
    return dsc;
  }

  // node_modules/@sentry/core/build/esm/tracing/logSpans.js
  function logSpanStart(span) {
    if (!DEBUG_BUILD2) return;
    const { description = "< unknown name >", op = "< unknown op >", parent_span_id: parentSpanId } = spanToJSON(span);
    const { spanId } = span.spanContext();
    const sampled = spanIsSampled(span);
    const rootSpan = getRootSpan(span);
    const isRootSpan = rootSpan === span;
    const header = `[Tracing] Starting ${sampled ? "sampled" : "unsampled"} ${isRootSpan ? "root " : ""}span`;
    const infoParts = [`op: ${op}`, `name: ${description}`, `ID: ${spanId}`];
    if (parentSpanId) {
      infoParts.push(`parent ID: ${parentSpanId}`);
    }
    if (!isRootSpan) {
      const { op: op2, description: description2 } = spanToJSON(rootSpan);
      infoParts.push(`root ID: ${rootSpan.spanContext().spanId}`);
      if (op2) {
        infoParts.push(`root op: ${op2}`);
      }
      if (description2) {
        infoParts.push(`root description: ${description2}`);
      }
    }
    logger.log(`${header}
  ${infoParts.join("\n  ")}`);
  }
  function logSpanEnd(span) {
    if (!DEBUG_BUILD2) return;
    const { description = "< unknown name >", op = "< unknown op >" } = spanToJSON(span);
    const { spanId } = span.spanContext();
    const rootSpan = getRootSpan(span);
    const isRootSpan = rootSpan === span;
    const msg = `[Tracing] Finishing "${op}" ${isRootSpan ? "root " : ""}span "${description}" with ID ${spanId}`;
    logger.log(msg);
  }

  // node_modules/@sentry/core/build/esm/utils/parseSampleRate.js
  function parseSampleRate(sampleRate) {
    if (typeof sampleRate === "boolean") {
      return Number(sampleRate);
    }
    const rate = typeof sampleRate === "string" ? parseFloat(sampleRate) : sampleRate;
    if (typeof rate !== "number" || isNaN(rate) || rate < 0 || rate > 1) {
      DEBUG_BUILD2 && logger.warn(
        `[Tracing] Given sample rate is invalid. Sample rate must be a boolean or a number between 0 and 1. Got ${JSON.stringify(
          sampleRate
        )} of type ${JSON.stringify(typeof sampleRate)}.`
      );
      return void 0;
    }
    return rate;
  }

  // node_modules/@sentry/core/build/esm/tracing/sampling.js
  function sampleSpan(options, samplingContext) {
    if (!hasTracingEnabled(options)) {
      return [false];
    }
    let sampleRate;
    if (typeof options.tracesSampler === "function") {
      sampleRate = options.tracesSampler(samplingContext);
    } else if (samplingContext.parentSampled !== void 0) {
      sampleRate = samplingContext.parentSampled;
    } else if (typeof options.tracesSampleRate !== "undefined") {
      sampleRate = options.tracesSampleRate;
    } else {
      sampleRate = 1;
    }
    const parsedSampleRate = parseSampleRate(sampleRate);
    if (parsedSampleRate === void 0) {
      DEBUG_BUILD2 && logger.warn("[Tracing] Discarding transaction because of invalid sample rate.");
      return [false];
    }
    if (!parsedSampleRate) {
      DEBUG_BUILD2 && logger.log(
        `[Tracing] Discarding transaction because ${typeof options.tracesSampler === "function" ? "tracesSampler returned 0 or false" : "a negative sampling decision was inherited or tracesSampleRate is set to 0"}`
      );
      return [false, parsedSampleRate];
    }
    const shouldSample = Math.random() < parsedSampleRate;
    if (!shouldSample) {
      DEBUG_BUILD2 && logger.log(
        `[Tracing] Discarding transaction because it's not included in the random sample (sampling rate = ${Number(
          sampleRate
        )})`
      );
      return [false, parsedSampleRate];
    }
    return [true, parsedSampleRate];
  }

  // node_modules/@sentry/core/build/esm/envelope.js
  function enhanceEventWithSdkInfo(event, sdkInfo) {
    if (!sdkInfo) {
      return event;
    }
    event.sdk = event.sdk || {};
    event.sdk.name = event.sdk.name || sdkInfo.name;
    event.sdk.version = event.sdk.version || sdkInfo.version;
    event.sdk.integrations = [...event.sdk.integrations || [], ...sdkInfo.integrations || []];
    event.sdk.packages = [...event.sdk.packages || [], ...sdkInfo.packages || []];
    return event;
  }
  function createSessionEnvelope(session, dsn, metadata, tunnel) {
    const sdkInfo = getSdkMetadataForEnvelopeHeader(metadata);
    const envelopeHeaders = {
      sent_at: (/* @__PURE__ */ new Date()).toISOString(),
      ...sdkInfo && { sdk: sdkInfo },
      ...!!tunnel && dsn && { dsn: dsnToString(dsn) }
    };
    const envelopeItem = "aggregates" in session ? [{ type: "sessions" }, session] : [{ type: "session" }, session.toJSON()];
    return createEnvelope(envelopeHeaders, [envelopeItem]);
  }
  function createEventEnvelope(event, dsn, metadata, tunnel) {
    const sdkInfo = getSdkMetadataForEnvelopeHeader(metadata);
    const eventType = event.type && event.type !== "replay_event" ? event.type : "event";
    enhanceEventWithSdkInfo(event, metadata && metadata.sdk);
    const envelopeHeaders = createEventEnvelopeHeaders(event, sdkInfo, tunnel, dsn);
    delete event.sdkProcessingMetadata;
    const eventItem = [{ type: eventType }, event];
    return createEnvelope(envelopeHeaders, [eventItem]);
  }
  function createSpanEnvelope(spans, client) {
    function dscHasRequiredProps(dsc2) {
      return !!dsc2.trace_id && !!dsc2.public_key;
    }
    const dsc = getDynamicSamplingContextFromSpan(spans[0]);
    const dsn = client && client.getDsn();
    const tunnel = client && client.getOptions().tunnel;
    const headers = {
      sent_at: (/* @__PURE__ */ new Date()).toISOString(),
      ...dscHasRequiredProps(dsc) && { trace: dsc },
      ...!!tunnel && dsn && { dsn: dsnToString(dsn) }
    };
    const beforeSendSpan = client && client.getOptions().beforeSendSpan;
    const convertToSpanJSON = beforeSendSpan ? (span) => beforeSendSpan(spanToJSON(span)) : (span) => spanToJSON(span);
    const items = [];
    for (const span of spans) {
      const spanJson = convertToSpanJSON(span);
      if (spanJson) {
        items.push(createSpanEnvelopeItem(spanJson));
      }
    }
    return createEnvelope(headers, items);
  }

  // node_modules/@sentry/core/build/esm/tracing/measurement.js
  function setMeasurement(name, value, unit, activeSpan = getActiveSpan()) {
    const rootSpan = activeSpan && getRootSpan(activeSpan);
    if (rootSpan) {
      rootSpan.addEvent(name, {
        [SEMANTIC_ATTRIBUTE_SENTRY_MEASUREMENT_VALUE]: value,
        [SEMANTIC_ATTRIBUTE_SENTRY_MEASUREMENT_UNIT]: unit
      });
    }
  }
  function timedEventsToMeasurements(events) {
    if (!events || events.length === 0) {
      return void 0;
    }
    const measurements = {};
    events.forEach((event) => {
      const attributes = event.attributes || {};
      const unit = attributes[SEMANTIC_ATTRIBUTE_SENTRY_MEASUREMENT_UNIT];
      const value = attributes[SEMANTIC_ATTRIBUTE_SENTRY_MEASUREMENT_VALUE];
      if (typeof unit === "string" && typeof value === "number") {
        measurements[event.name] = { value, unit };
      }
    });
    return measurements;
  }

  // node_modules/@sentry/core/build/esm/tracing/sentrySpan.js
  var MAX_SPAN_COUNT = 1e3;
  var SentrySpan = class {
    /** Epoch timestamp in seconds when the span started. */
    /** Epoch timestamp in seconds when the span ended. */
    /** Internal keeper of the status */
    /** The timed events added to this span. */
    /** if true, treat span as a standalone span (not part of a transaction) */
    /**
     * You should never call the constructor manually, always use `Sentry.startSpan()`
     * or other span methods.
     * @internal
     * @hideconstructor
     * @hidden
     */
    constructor(spanContext = {}) {
      this._traceId = spanContext.traceId || uuid4();
      this._spanId = spanContext.spanId || uuid4().substring(16);
      this._startTime = spanContext.startTimestamp || timestampInSeconds();
      this._attributes = {};
      this.setAttributes({
        [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "manual",
        [SEMANTIC_ATTRIBUTE_SENTRY_OP]: spanContext.op,
        ...spanContext.attributes
      });
      this._name = spanContext.name;
      if (spanContext.parentSpanId) {
        this._parentSpanId = spanContext.parentSpanId;
      }
      if ("sampled" in spanContext) {
        this._sampled = spanContext.sampled;
      }
      if (spanContext.endTimestamp) {
        this._endTime = spanContext.endTimestamp;
      }
      this._events = [];
      this._isStandaloneSpan = spanContext.isStandalone;
      if (this._endTime) {
        this._onSpanEnded();
      }
    }
    /**
     * This should generally not be used,
     * but it is needed for being compliant with the OTEL Span interface.
     *
     * @hidden
     * @internal
     */
    addLink(_link) {
      return this;
    }
    /**
     * This should generally not be used,
     * but it is needed for being compliant with the OTEL Span interface.
     *
     * @hidden
     * @internal
     */
    addLinks(_links) {
      return this;
    }
    /**
     * This should generally not be used,
     * but it is needed for being compliant with the OTEL Span interface.
     *
     * @hidden
     * @internal
     */
    recordException(_exception, _time) {
    }
    /** @inheritdoc */
    spanContext() {
      const { _spanId: spanId, _traceId: traceId, _sampled: sampled } = this;
      return {
        spanId,
        traceId,
        traceFlags: sampled ? TRACE_FLAG_SAMPLED : TRACE_FLAG_NONE
      };
    }
    /** @inheritdoc */
    setAttribute(key, value) {
      if (value === void 0) {
        delete this._attributes[key];
      } else {
        this._attributes[key] = value;
      }
      return this;
    }
    /** @inheritdoc */
    setAttributes(attributes) {
      Object.keys(attributes).forEach((key) => this.setAttribute(key, attributes[key]));
      return this;
    }
    /**
     * This should generally not be used,
     * but we need it for browser tracing where we want to adjust the start time afterwards.
     * USE THIS WITH CAUTION!
     *
     * @hidden
     * @internal
     */
    updateStartTime(timeInput) {
      this._startTime = spanTimeInputToSeconds(timeInput);
    }
    /**
     * @inheritDoc
     */
    setStatus(value) {
      this._status = value;
      return this;
    }
    /**
     * @inheritDoc
     */
    updateName(name) {
      this._name = name;
      return this;
    }
    /** @inheritdoc */
    end(endTimestamp) {
      if (this._endTime) {
        return;
      }
      this._endTime = spanTimeInputToSeconds(endTimestamp);
      logSpanEnd(this);
      this._onSpanEnded();
    }
    /**
     * Get JSON representation of this span.
     *
     * @hidden
     * @internal This method is purely for internal purposes and should not be used outside
     * of SDK code. If you need to get a JSON representation of a span,
     * use `spanToJSON(span)` instead.
     */
    getSpanJSON() {
      return dropUndefinedKeys({
        data: this._attributes,
        description: this._name,
        op: this._attributes[SEMANTIC_ATTRIBUTE_SENTRY_OP],
        parent_span_id: this._parentSpanId,
        span_id: this._spanId,
        start_timestamp: this._startTime,
        status: getStatusMessage(this._status),
        timestamp: this._endTime,
        trace_id: this._traceId,
        origin: this._attributes[SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN],
        _metrics_summary: getMetricSummaryJsonForSpan(this),
        profile_id: this._attributes[SEMANTIC_ATTRIBUTE_PROFILE_ID],
        exclusive_time: this._attributes[SEMANTIC_ATTRIBUTE_EXCLUSIVE_TIME],
        measurements: timedEventsToMeasurements(this._events),
        is_segment: this._isStandaloneSpan && getRootSpan(this) === this || void 0,
        segment_id: this._isStandaloneSpan ? getRootSpan(this).spanContext().spanId : void 0
      });
    }
    /** @inheritdoc */
    isRecording() {
      return !this._endTime && !!this._sampled;
    }
    /**
     * @inheritdoc
     */
    addEvent(name, attributesOrStartTime, startTime) {
      DEBUG_BUILD2 && logger.log("[Tracing] Adding an event to span:", name);
      const time = isSpanTimeInput(attributesOrStartTime) ? attributesOrStartTime : startTime || timestampInSeconds();
      const attributes = isSpanTimeInput(attributesOrStartTime) ? {} : attributesOrStartTime || {};
      const event = {
        name,
        time: spanTimeInputToSeconds(time),
        attributes
      };
      this._events.push(event);
      return this;
    }
    /**
     * This method should generally not be used,
     * but for now we need a way to publicly check if the `_isStandaloneSpan` flag is set.
     * USE THIS WITH CAUTION!
     * @internal
     * @hidden
     * @experimental
     */
    isStandaloneSpan() {
      return !!this._isStandaloneSpan;
    }
    /** Emit `spanEnd` when the span is ended. */
    _onSpanEnded() {
      const client = getClient();
      if (client) {
        client.emit("spanEnd", this);
      }
      const isSegmentSpan = this._isStandaloneSpan || this === getRootSpan(this);
      if (!isSegmentSpan) {
        return;
      }
      if (this._isStandaloneSpan) {
        if (this._sampled) {
          sendSpanEnvelope(createSpanEnvelope([this], client));
        } else {
          DEBUG_BUILD2 && logger.log("[Tracing] Discarding standalone span because its trace was not chosen to be sampled.");
          if (client) {
            client.recordDroppedEvent("sample_rate", "span");
          }
        }
        return;
      }
      const transactionEvent = this._convertSpanToTransaction();
      if (transactionEvent) {
        const scope = getCapturedScopesOnSpan(this).scope || getCurrentScope();
        scope.captureEvent(transactionEvent);
      }
    }
    /**
     * Finish the transaction & prepare the event to send to Sentry.
     */
    _convertSpanToTransaction() {
      if (!isFullFinishedSpan(spanToJSON(this))) {
        return void 0;
      }
      if (!this._name) {
        DEBUG_BUILD2 && logger.warn("Transaction has no name, falling back to `<unlabeled transaction>`.");
        this._name = "<unlabeled transaction>";
      }
      const { scope: capturedSpanScope, isolationScope: capturedSpanIsolationScope } = getCapturedScopesOnSpan(this);
      const scope = capturedSpanScope || getCurrentScope();
      const client = scope.getClient() || getClient();
      if (this._sampled !== true) {
        DEBUG_BUILD2 && logger.log("[Tracing] Discarding transaction because its trace was not chosen to be sampled.");
        if (client) {
          client.recordDroppedEvent("sample_rate", "transaction");
        }
        return void 0;
      }
      const finishedSpans = getSpanDescendants(this).filter((span) => span !== this && !isStandaloneSpan(span));
      const spans = finishedSpans.map((span) => spanToJSON(span)).filter(isFullFinishedSpan);
      const source = this._attributes[SEMANTIC_ATTRIBUTE_SENTRY_SOURCE];
      const transaction = {
        contexts: {
          trace: spanToTransactionTraceContext(this)
        },
        spans: (
          // spans.sort() mutates the array, but `spans` is already a copy so we can safely do this here
          // we do not use spans anymore after this point
          spans.length > MAX_SPAN_COUNT ? spans.sort((a, b) => a.start_timestamp - b.start_timestamp).slice(0, MAX_SPAN_COUNT) : spans
        ),
        start_timestamp: this._startTime,
        timestamp: this._endTime,
        transaction: this._name,
        type: "transaction",
        sdkProcessingMetadata: {
          capturedSpanScope,
          capturedSpanIsolationScope,
          ...dropUndefinedKeys({
            dynamicSamplingContext: getDynamicSamplingContextFromSpan(this)
          })
        },
        _metrics_summary: getMetricSummaryJsonForSpan(this),
        ...source && {
          transaction_info: {
            source
          }
        }
      };
      const measurements = timedEventsToMeasurements(this._events);
      const hasMeasurements = measurements && Object.keys(measurements).length;
      if (hasMeasurements) {
        DEBUG_BUILD2 && logger.log(
          "[Measurements] Adding measurements to transaction event",
          JSON.stringify(measurements, void 0, 2)
        );
        transaction.measurements = measurements;
      }
      return transaction;
    }
  };
  function isSpanTimeInput(value) {
    return value && typeof value === "number" || value instanceof Date || Array.isArray(value);
  }
  function isFullFinishedSpan(input) {
    return !!input.start_timestamp && !!input.timestamp && !!input.span_id && !!input.trace_id;
  }
  function isStandaloneSpan(span) {
    return span instanceof SentrySpan && span.isStandaloneSpan();
  }
  function sendSpanEnvelope(envelope) {
    const client = getClient();
    if (!client) {
      return;
    }
    const spanItems = envelope[1];
    if (!spanItems || spanItems.length === 0) {
      client.recordDroppedEvent("before_send", "span");
      return;
    }
    const transport = client.getTransport();
    if (transport) {
      transport.send(envelope).then(null, (reason) => {
        DEBUG_BUILD2 && logger.error("Error while sending span:", reason);
      });
    }
  }

  // node_modules/@sentry/core/build/esm/tracing/trace.js
  var SUPPRESS_TRACING_KEY = "__SENTRY_SUPPRESS_TRACING__";
  function startInactiveSpan(options) {
    const acs = getAcs();
    if (acs.startInactiveSpan) {
      return acs.startInactiveSpan(options);
    }
    const spanArguments = parseSentrySpanArguments(options);
    const { forceTransaction, parentSpan: customParentSpan } = options;
    const wrapper = options.scope ? (callback) => withScope2(options.scope, callback) : customParentSpan !== void 0 ? (callback) => withActiveSpan(customParentSpan, callback) : (callback) => callback();
    return wrapper(() => {
      const scope = getCurrentScope();
      const parentSpan = getParentSpan(scope);
      const shouldSkipSpan = options.onlyIfParent && !parentSpan;
      if (shouldSkipSpan) {
        return new SentryNonRecordingSpan();
      }
      return createChildOrRootSpan({
        parentSpan,
        spanArguments,
        forceTransaction,
        scope
      });
    });
  }
  function withActiveSpan(span, callback) {
    const acs = getAcs();
    if (acs.withActiveSpan) {
      return acs.withActiveSpan(span, callback);
    }
    return withScope2((scope) => {
      _setSpanForScope(scope, span || void 0);
      return callback(scope);
    });
  }
  function createChildOrRootSpan({
    parentSpan,
    spanArguments,
    forceTransaction,
    scope
  }) {
    if (!hasTracingEnabled()) {
      return new SentryNonRecordingSpan();
    }
    const isolationScope = getIsolationScope();
    let span;
    if (parentSpan && !forceTransaction) {
      span = _startChildSpan(parentSpan, scope, spanArguments);
      addChildSpanToSpan(parentSpan, span);
    } else if (parentSpan) {
      const dsc = getDynamicSamplingContextFromSpan(parentSpan);
      const { traceId, spanId: parentSpanId } = parentSpan.spanContext();
      const parentSampled = spanIsSampled(parentSpan);
      span = _startRootSpan(
        {
          traceId,
          parentSpanId,
          ...spanArguments
        },
        scope,
        parentSampled
      );
      freezeDscOnSpan(span, dsc);
    } else {
      const {
        traceId,
        dsc,
        parentSpanId,
        sampled: parentSampled
      } = {
        ...isolationScope.getPropagationContext(),
        ...scope.getPropagationContext()
      };
      span = _startRootSpan(
        {
          traceId,
          parentSpanId,
          ...spanArguments
        },
        scope,
        parentSampled
      );
      if (dsc) {
        freezeDscOnSpan(span, dsc);
      }
    }
    logSpanStart(span);
    setCapturedScopesOnSpan(span, scope, isolationScope);
    return span;
  }
  function parseSentrySpanArguments(options) {
    const exp = options.experimental || {};
    const initialCtx = {
      isStandalone: exp.standalone,
      ...options
    };
    if (options.startTime) {
      const ctx = { ...initialCtx };
      ctx.startTimestamp = spanTimeInputToSeconds(options.startTime);
      delete ctx.startTime;
      return ctx;
    }
    return initialCtx;
  }
  function getAcs() {
    const carrier = getMainCarrier();
    return getAsyncContextStrategy(carrier);
  }
  function _startRootSpan(spanArguments, scope, parentSampled) {
    const client = getClient();
    const options = client && client.getOptions() || {};
    const { name = "", attributes } = spanArguments;
    const [sampled, sampleRate] = scope.getScopeData().sdkProcessingMetadata[SUPPRESS_TRACING_KEY] ? [false] : sampleSpan(options, {
      name,
      parentSampled,
      attributes,
      transactionContext: {
        name,
        parentSampled
      }
    });
    const rootSpan = new SentrySpan({
      ...spanArguments,
      attributes: {
        [SEMANTIC_ATTRIBUTE_SENTRY_SOURCE]: "custom",
        ...spanArguments.attributes
      },
      sampled
    });
    if (sampleRate !== void 0) {
      rootSpan.setAttribute(SEMANTIC_ATTRIBUTE_SENTRY_SAMPLE_RATE, sampleRate);
    }
    if (client) {
      client.emit("spanStart", rootSpan);
    }
    return rootSpan;
  }
  function _startChildSpan(parentSpan, scope, spanArguments) {
    const { spanId, traceId } = parentSpan.spanContext();
    const sampled = scope.getScopeData().sdkProcessingMetadata[SUPPRESS_TRACING_KEY] ? false : spanIsSampled(parentSpan);
    const childSpan = sampled ? new SentrySpan({
      ...spanArguments,
      parentSpanId: spanId,
      traceId,
      sampled
    }) : new SentryNonRecordingSpan({ traceId });
    addChildSpanToSpan(parentSpan, childSpan);
    const client = getClient();
    if (client) {
      client.emit("spanStart", childSpan);
      if (spanArguments.endTimestamp) {
        client.emit("spanEnd", childSpan);
      }
    }
    return childSpan;
  }
  function getParentSpan(scope) {
    const span = _getSpanForScope(scope);
    if (!span) {
      return void 0;
    }
    const client = getClient();
    const options = client ? client.getOptions() : {};
    if (options.parentSpanIsAlwaysRootSpan) {
      return getRootSpan(span);
    }
    return span;
  }

  // node_modules/@sentry/core/build/esm/tracing/idleSpan.js
  var TRACING_DEFAULTS = {
    idleTimeout: 1e3,
    finalTimeout: 3e4,
    childSpanTimeout: 15e3
  };
  var FINISH_REASON_HEARTBEAT_FAILED = "heartbeatFailed";
  var FINISH_REASON_IDLE_TIMEOUT = "idleTimeout";
  var FINISH_REASON_FINAL_TIMEOUT = "finalTimeout";
  var FINISH_REASON_EXTERNAL_FINISH = "externalFinish";
  function startIdleSpan(startSpanOptions, options = {}) {
    const activities = /* @__PURE__ */ new Map();
    let _finished = false;
    let _idleTimeoutID;
    let _finishReason = FINISH_REASON_EXTERNAL_FINISH;
    let _autoFinishAllowed = !options.disableAutoFinish;
    const _cleanupHooks = [];
    const {
      idleTimeout = TRACING_DEFAULTS.idleTimeout,
      finalTimeout = TRACING_DEFAULTS.finalTimeout,
      childSpanTimeout = TRACING_DEFAULTS.childSpanTimeout,
      beforeSpanEnd
    } = options;
    const client = getClient();
    if (!client || !hasTracingEnabled()) {
      return new SentryNonRecordingSpan();
    }
    const scope = getCurrentScope();
    const previousActiveSpan = getActiveSpan();
    const span = _startIdleSpan(startSpanOptions);
    span.end = new Proxy(span.end, {
      apply(target, thisArg, args) {
        if (beforeSpanEnd) {
          beforeSpanEnd(span);
        }
        const [definedEndTimestamp, ...rest] = args;
        const timestamp = definedEndTimestamp || timestampInSeconds();
        const spanEndTimestamp = spanTimeInputToSeconds(timestamp);
        const spans = getSpanDescendants(span).filter((child) => child !== span);
        if (!spans.length) {
          onIdleSpanEnded(spanEndTimestamp);
          return Reflect.apply(target, thisArg, [spanEndTimestamp, ...rest]);
        }
        const childEndTimestamps = spans.map((span2) => spanToJSON(span2).timestamp).filter((timestamp2) => !!timestamp2);
        const latestSpanEndTimestamp = childEndTimestamps.length ? Math.max(...childEndTimestamps) : void 0;
        const spanStartTimestamp = spanToJSON(span).start_timestamp;
        const endTimestamp = Math.min(
          spanStartTimestamp ? spanStartTimestamp + finalTimeout / 1e3 : Infinity,
          Math.max(spanStartTimestamp || -Infinity, Math.min(spanEndTimestamp, latestSpanEndTimestamp || Infinity))
        );
        onIdleSpanEnded(endTimestamp);
        return Reflect.apply(target, thisArg, [endTimestamp, ...rest]);
      }
    });
    function _cancelIdleTimeout() {
      if (_idleTimeoutID) {
        clearTimeout(_idleTimeoutID);
        _idleTimeoutID = void 0;
      }
    }
    function _restartIdleTimeout(endTimestamp) {
      _cancelIdleTimeout();
      _idleTimeoutID = setTimeout(() => {
        if (!_finished && activities.size === 0 && _autoFinishAllowed) {
          _finishReason = FINISH_REASON_IDLE_TIMEOUT;
          span.end(endTimestamp);
        }
      }, idleTimeout);
    }
    function _restartChildSpanTimeout(endTimestamp) {
      _idleTimeoutID = setTimeout(() => {
        if (!_finished && _autoFinishAllowed) {
          _finishReason = FINISH_REASON_HEARTBEAT_FAILED;
          span.end(endTimestamp);
        }
      }, childSpanTimeout);
    }
    function _pushActivity(spanId) {
      _cancelIdleTimeout();
      activities.set(spanId, true);
      const endTimestamp = timestampInSeconds();
      _restartChildSpanTimeout(endTimestamp + childSpanTimeout / 1e3);
    }
    function _popActivity(spanId) {
      if (activities.has(spanId)) {
        activities.delete(spanId);
      }
      if (activities.size === 0) {
        const endTimestamp = timestampInSeconds();
        _restartIdleTimeout(endTimestamp + idleTimeout / 1e3);
      }
    }
    function onIdleSpanEnded(endTimestamp) {
      _finished = true;
      activities.clear();
      _cleanupHooks.forEach((cleanup) => cleanup());
      _setSpanForScope(scope, previousActiveSpan);
      const spanJSON = spanToJSON(span);
      const { start_timestamp: startTimestamp } = spanJSON;
      if (!startTimestamp) {
        return;
      }
      const attributes = spanJSON.data || {};
      if (!attributes[SEMANTIC_ATTRIBUTE_SENTRY_IDLE_SPAN_FINISH_REASON]) {
        span.setAttribute(SEMANTIC_ATTRIBUTE_SENTRY_IDLE_SPAN_FINISH_REASON, _finishReason);
      }
      logger.log(`[Tracing] Idle span "${spanJSON.op}" finished`);
      const childSpans = getSpanDescendants(span).filter((child) => child !== span);
      let discardedSpans = 0;
      childSpans.forEach((childSpan) => {
        if (childSpan.isRecording()) {
          childSpan.setStatus({ code: SPAN_STATUS_ERROR, message: "cancelled" });
          childSpan.end(endTimestamp);
          DEBUG_BUILD2 && logger.log("[Tracing] Cancelling span since span ended early", JSON.stringify(childSpan, void 0, 2));
        }
        const childSpanJSON = spanToJSON(childSpan);
        const { timestamp: childEndTimestamp = 0, start_timestamp: childStartTimestamp = 0 } = childSpanJSON;
        const spanStartedBeforeIdleSpanEnd = childStartTimestamp <= endTimestamp;
        const timeoutWithMarginOfError = (finalTimeout + idleTimeout) / 1e3;
        const spanEndedBeforeFinalTimeout = childEndTimestamp - childStartTimestamp <= timeoutWithMarginOfError;
        if (DEBUG_BUILD2) {
          const stringifiedSpan = JSON.stringify(childSpan, void 0, 2);
          if (!spanStartedBeforeIdleSpanEnd) {
            logger.log("[Tracing] Discarding span since it happened after idle span was finished", stringifiedSpan);
          } else if (!spanEndedBeforeFinalTimeout) {
            logger.log("[Tracing] Discarding span since it finished after idle span final timeout", stringifiedSpan);
          }
        }
        if (!spanEndedBeforeFinalTimeout || !spanStartedBeforeIdleSpanEnd) {
          removeChildSpanFromSpan(span, childSpan);
          discardedSpans++;
        }
      });
      if (discardedSpans > 0) {
        span.setAttribute("sentry.idle_span_discarded_spans", discardedSpans);
      }
    }
    _cleanupHooks.push(
      client.on("spanStart", (startedSpan) => {
        if (_finished || startedSpan === span || !!spanToJSON(startedSpan).timestamp) {
          return;
        }
        const allSpans = getSpanDescendants(span);
        if (allSpans.includes(startedSpan)) {
          _pushActivity(startedSpan.spanContext().spanId);
        }
      })
    );
    _cleanupHooks.push(
      client.on("spanEnd", (endedSpan) => {
        if (_finished) {
          return;
        }
        _popActivity(endedSpan.spanContext().spanId);
      })
    );
    _cleanupHooks.push(
      client.on("idleSpanEnableAutoFinish", (spanToAllowAutoFinish) => {
        if (spanToAllowAutoFinish === span) {
          _autoFinishAllowed = true;
          _restartIdleTimeout();
          if (activities.size) {
            _restartChildSpanTimeout();
          }
        }
      })
    );
    if (!options.disableAutoFinish) {
      _restartIdleTimeout();
    }
    setTimeout(() => {
      if (!_finished) {
        span.setStatus({ code: SPAN_STATUS_ERROR, message: "deadline_exceeded" });
        _finishReason = FINISH_REASON_FINAL_TIMEOUT;
        span.end();
      }
    }, finalTimeout);
    return span;
  }
  function _startIdleSpan(options) {
    const span = startInactiveSpan(options);
    _setSpanForScope(getCurrentScope(), span);
    DEBUG_BUILD2 && logger.log("[Tracing] Started span is an idle span");
    return span;
  }

  // node_modules/@sentry/core/build/esm/eventProcessors.js
  function notifyEventProcessors(processors, event, hint, index = 0) {
    return new SyncPromise((resolve, reject) => {
      const processor = processors[index];
      if (event === null || typeof processor !== "function") {
        resolve(event);
      } else {
        const result = processor({ ...event }, hint);
        DEBUG_BUILD2 && processor.id && result === null && logger.log(`Event processor "${processor.id}" dropped event`);
        if (isThenable(result)) {
          void result.then((final) => notifyEventProcessors(processors, final, hint, index + 1).then(resolve)).then(null, reject);
        } else {
          void notifyEventProcessors(processors, result, hint, index + 1).then(resolve).then(null, reject);
        }
      }
    });
  }

  // node_modules/@sentry/core/build/esm/utils/applyScopeDataToEvent.js
  function applyScopeDataToEvent(event, data) {
    const { fingerprint, span, breadcrumbs, sdkProcessingMetadata } = data;
    applyDataToEvent(event, data);
    if (span) {
      applySpanToEvent(event, span);
    }
    applyFingerprintToEvent(event, fingerprint);
    applyBreadcrumbsToEvent(event, breadcrumbs);
    applySdkMetadataToEvent(event, sdkProcessingMetadata);
  }
  function mergeScopeData(data, mergeData) {
    const {
      extra,
      tags,
      user,
      contexts,
      level,
      sdkProcessingMetadata,
      breadcrumbs,
      fingerprint,
      eventProcessors,
      attachments,
      propagationContext,
      transactionName,
      span
    } = mergeData;
    mergeAndOverwriteScopeData(data, "extra", extra);
    mergeAndOverwriteScopeData(data, "tags", tags);
    mergeAndOverwriteScopeData(data, "user", user);
    mergeAndOverwriteScopeData(data, "contexts", contexts);
    mergeAndOverwriteScopeData(data, "sdkProcessingMetadata", sdkProcessingMetadata);
    if (level) {
      data.level = level;
    }
    if (transactionName) {
      data.transactionName = transactionName;
    }
    if (span) {
      data.span = span;
    }
    if (breadcrumbs.length) {
      data.breadcrumbs = [...data.breadcrumbs, ...breadcrumbs];
    }
    if (fingerprint.length) {
      data.fingerprint = [...data.fingerprint, ...fingerprint];
    }
    if (eventProcessors.length) {
      data.eventProcessors = [...data.eventProcessors, ...eventProcessors];
    }
    if (attachments.length) {
      data.attachments = [...data.attachments, ...attachments];
    }
    data.propagationContext = { ...data.propagationContext, ...propagationContext };
  }
  function mergeAndOverwriteScopeData(data, prop, mergeVal) {
    if (mergeVal && Object.keys(mergeVal).length) {
      data[prop] = { ...data[prop] };
      for (const key in mergeVal) {
        if (Object.prototype.hasOwnProperty.call(mergeVal, key)) {
          data[prop][key] = mergeVal[key];
        }
      }
    }
  }
  function applyDataToEvent(event, data) {
    const { extra, tags, user, contexts, level, transactionName } = data;
    const cleanedExtra = dropUndefinedKeys(extra);
    if (cleanedExtra && Object.keys(cleanedExtra).length) {
      event.extra = { ...cleanedExtra, ...event.extra };
    }
    const cleanedTags = dropUndefinedKeys(tags);
    if (cleanedTags && Object.keys(cleanedTags).length) {
      event.tags = { ...cleanedTags, ...event.tags };
    }
    const cleanedUser = dropUndefinedKeys(user);
    if (cleanedUser && Object.keys(cleanedUser).length) {
      event.user = { ...cleanedUser, ...event.user };
    }
    const cleanedContexts = dropUndefinedKeys(contexts);
    if (cleanedContexts && Object.keys(cleanedContexts).length) {
      event.contexts = { ...cleanedContexts, ...event.contexts };
    }
    if (level) {
      event.level = level;
    }
    if (transactionName && event.type !== "transaction") {
      event.transaction = transactionName;
    }
  }
  function applyBreadcrumbsToEvent(event, breadcrumbs) {
    const mergedBreadcrumbs = [...event.breadcrumbs || [], ...breadcrumbs];
    event.breadcrumbs = mergedBreadcrumbs.length ? mergedBreadcrumbs : void 0;
  }
  function applySdkMetadataToEvent(event, sdkProcessingMetadata) {
    event.sdkProcessingMetadata = {
      ...event.sdkProcessingMetadata,
      ...sdkProcessingMetadata
    };
  }
  function applySpanToEvent(event, span) {
    event.contexts = {
      trace: spanToTraceContext(span),
      ...event.contexts
    };
    event.sdkProcessingMetadata = {
      dynamicSamplingContext: getDynamicSamplingContextFromSpan(span),
      ...event.sdkProcessingMetadata
    };
    const rootSpan = getRootSpan(span);
    const transactionName = spanToJSON(rootSpan).description;
    if (transactionName && !event.transaction && event.type === "transaction") {
      event.transaction = transactionName;
    }
  }
  function applyFingerprintToEvent(event, fingerprint) {
    event.fingerprint = event.fingerprint ? arrayify(event.fingerprint) : [];
    if (fingerprint) {
      event.fingerprint = event.fingerprint.concat(fingerprint);
    }
    if (event.fingerprint && !event.fingerprint.length) {
      delete event.fingerprint;
    }
  }

  // node_modules/@sentry/core/build/esm/utils/prepareEvent.js
  function prepareEvent(options, event, hint, scope, client, isolationScope) {
    const { normalizeDepth = 3, normalizeMaxBreadth = 1e3 } = options;
    const prepared = {
      ...event,
      event_id: event.event_id || hint.event_id || uuid4(),
      timestamp: event.timestamp || dateTimestampInSeconds()
    };
    const integrations = hint.integrations || options.integrations.map((i) => i.name);
    applyClientOptions(prepared, options);
    applyIntegrationsMetadata(prepared, integrations);
    if (client) {
      client.emit("applyFrameMetadata", event);
    }
    if (event.type === void 0) {
      applyDebugIds(prepared, options.stackParser);
    }
    const finalScope = getFinalScope(scope, hint.captureContext);
    if (hint.mechanism) {
      addExceptionMechanism(prepared, hint.mechanism);
    }
    const clientEventProcessors = client ? client.getEventProcessors() : [];
    const data = getGlobalScope().getScopeData();
    if (isolationScope) {
      const isolationData = isolationScope.getScopeData();
      mergeScopeData(data, isolationData);
    }
    if (finalScope) {
      const finalScopeData = finalScope.getScopeData();
      mergeScopeData(data, finalScopeData);
    }
    const attachments = [...hint.attachments || [], ...data.attachments];
    if (attachments.length) {
      hint.attachments = attachments;
    }
    applyScopeDataToEvent(prepared, data);
    const eventProcessors = [
      ...clientEventProcessors,
      // Run scope event processors _after_ all other processors
      ...data.eventProcessors
    ];
    const result = notifyEventProcessors(eventProcessors, prepared, hint);
    return result.then((evt) => {
      if (evt) {
        applyDebugMeta(evt);
      }
      if (typeof normalizeDepth === "number" && normalizeDepth > 0) {
        return normalizeEvent(evt, normalizeDepth, normalizeMaxBreadth);
      }
      return evt;
    });
  }
  function applyClientOptions(event, options) {
    const { environment, release, dist, maxValueLength = 250 } = options;
    if (!("environment" in event)) {
      event.environment = "environment" in options ? environment : DEFAULT_ENVIRONMENT;
    }
    if (event.release === void 0 && release !== void 0) {
      event.release = release;
    }
    if (event.dist === void 0 && dist !== void 0) {
      event.dist = dist;
    }
    if (event.message) {
      event.message = truncate(event.message, maxValueLength);
    }
    const exception = event.exception && event.exception.values && event.exception.values[0];
    if (exception && exception.value) {
      exception.value = truncate(exception.value, maxValueLength);
    }
    const request = event.request;
    if (request && request.url) {
      request.url = truncate(request.url, maxValueLength);
    }
  }
  var debugIdStackParserCache = /* @__PURE__ */ new WeakMap();
  function applyDebugIds(event, stackParser) {
    const debugIdMap = GLOBAL_OBJ._sentryDebugIds;
    if (!debugIdMap) {
      return;
    }
    let debugIdStackFramesCache;
    const cachedDebugIdStackFrameCache = debugIdStackParserCache.get(stackParser);
    if (cachedDebugIdStackFrameCache) {
      debugIdStackFramesCache = cachedDebugIdStackFrameCache;
    } else {
      debugIdStackFramesCache = /* @__PURE__ */ new Map();
      debugIdStackParserCache.set(stackParser, debugIdStackFramesCache);
    }
    const filenameDebugIdMap = Object.entries(debugIdMap).reduce(
      (acc, [debugIdStackTrace, debugIdValue]) => {
        let parsedStack;
        const cachedParsedStack = debugIdStackFramesCache.get(debugIdStackTrace);
        if (cachedParsedStack) {
          parsedStack = cachedParsedStack;
        } else {
          parsedStack = stackParser(debugIdStackTrace);
          debugIdStackFramesCache.set(debugIdStackTrace, parsedStack);
        }
        for (let i = parsedStack.length - 1; i >= 0; i--) {
          const stackFrame = parsedStack[i];
          if (stackFrame.filename) {
            acc[stackFrame.filename] = debugIdValue;
            break;
          }
        }
        return acc;
      },
      {}
    );
    try {
      event.exception.values.forEach((exception) => {
        exception.stacktrace.frames.forEach((frame) => {
          if (frame.filename) {
            frame.debug_id = filenameDebugIdMap[frame.filename];
          }
        });
      });
    } catch (e2) {
    }
  }
  function applyDebugMeta(event) {
    const filenameDebugIdMap = {};
    try {
      event.exception.values.forEach((exception) => {
        exception.stacktrace.frames.forEach((frame) => {
          if (frame.debug_id) {
            if (frame.abs_path) {
              filenameDebugIdMap[frame.abs_path] = frame.debug_id;
            } else if (frame.filename) {
              filenameDebugIdMap[frame.filename] = frame.debug_id;
            }
            delete frame.debug_id;
          }
        });
      });
    } catch (e2) {
    }
    if (Object.keys(filenameDebugIdMap).length === 0) {
      return;
    }
    event.debug_meta = event.debug_meta || {};
    event.debug_meta.images = event.debug_meta.images || [];
    const images = event.debug_meta.images;
    Object.entries(filenameDebugIdMap).forEach(([filename, debug_id]) => {
      images.push({
        type: "sourcemap",
        code_file: filename,
        debug_id
      });
    });
  }
  function applyIntegrationsMetadata(event, integrationNames) {
    if (integrationNames.length > 0) {
      event.sdk = event.sdk || {};
      event.sdk.integrations = [...event.sdk.integrations || [], ...integrationNames];
    }
  }
  function normalizeEvent(event, depth, maxBreadth) {
    if (!event) {
      return null;
    }
    const normalized = {
      ...event,
      ...event.breadcrumbs && {
        breadcrumbs: event.breadcrumbs.map((b) => ({
          ...b,
          ...b.data && {
            data: normalize(b.data, depth, maxBreadth)
          }
        }))
      },
      ...event.user && {
        user: normalize(event.user, depth, maxBreadth)
      },
      ...event.contexts && {
        contexts: normalize(event.contexts, depth, maxBreadth)
      },
      ...event.extra && {
        extra: normalize(event.extra, depth, maxBreadth)
      }
    };
    if (event.contexts && event.contexts.trace && normalized.contexts) {
      normalized.contexts.trace = event.contexts.trace;
      if (event.contexts.trace.data) {
        normalized.contexts.trace.data = normalize(event.contexts.trace.data, depth, maxBreadth);
      }
    }
    if (event.spans) {
      normalized.spans = event.spans.map((span) => {
        return {
          ...span,
          ...span.data && {
            data: normalize(span.data, depth, maxBreadth)
          }
        };
      });
    }
    return normalized;
  }
  function getFinalScope(scope, captureContext) {
    if (!captureContext) {
      return scope;
    }
    const finalScope = scope ? scope.clone() : new Scope();
    finalScope.update(captureContext);
    return finalScope;
  }
  function parseEventHintOrCaptureContext(hint) {
    if (!hint) {
      return void 0;
    }
    if (hintIsScopeOrFunction(hint)) {
      return { captureContext: hint };
    }
    if (hintIsScopeContext(hint)) {
      return {
        captureContext: hint
      };
    }
    return hint;
  }
  function hintIsScopeOrFunction(hint) {
    return hint instanceof Scope || typeof hint === "function";
  }
  var captureContextKeys = [
    "user",
    "level",
    "extra",
    "contexts",
    "tags",
    "fingerprint",
    "requestSession",
    "propagationContext"
  ];
  function hintIsScopeContext(hint) {
    return Object.keys(hint).some((key) => captureContextKeys.includes(key));
  }

  // node_modules/@sentry/core/build/esm/exports.js
  function captureException(exception, hint) {
    return getCurrentScope().captureException(exception, parseEventHintOrCaptureContext(hint));
  }
  function captureEvent(event, hint) {
    return getCurrentScope().captureEvent(event, hint);
  }
  function setContext(name, context) {
    getIsolationScope().setContext(name, context);
  }
  function addEventProcessor(callback) {
    getIsolationScope().addEventProcessor(callback);
  }
  function startSession(context) {
    const client = getClient();
    const isolationScope = getIsolationScope();
    const currentScope = getCurrentScope();
    const { release, environment = DEFAULT_ENVIRONMENT } = client && client.getOptions() || {};
    const { userAgent } = GLOBAL_OBJ.navigator || {};
    const session = makeSession({
      release,
      environment,
      user: currentScope.getUser() || isolationScope.getUser(),
      ...userAgent && { userAgent },
      ...context
    });
    const currentSession = isolationScope.getSession();
    if (currentSession && currentSession.status === "ok") {
      updateSession(currentSession, { status: "exited" });
    }
    endSession();
    isolationScope.setSession(session);
    currentScope.setSession(session);
    return session;
  }
  function endSession() {
    const isolationScope = getIsolationScope();
    const currentScope = getCurrentScope();
    const session = currentScope.getSession() || isolationScope.getSession();
    if (session) {
      closeSession(session);
    }
    _sendSessionUpdate();
    isolationScope.setSession();
    currentScope.setSession();
  }
  function _sendSessionUpdate() {
    const isolationScope = getIsolationScope();
    const currentScope = getCurrentScope();
    const client = getClient();
    const session = currentScope.getSession() || isolationScope.getSession();
    if (session && client) {
      client.captureSession(session);
    }
  }
  function captureSession(end = false) {
    if (end) {
      endSession();
      return;
    }
    _sendSessionUpdate();
  }

  // node_modules/@sentry/core/build/esm/api.js
  var SENTRY_API_VERSION = "7";
  function getBaseApiEndpoint(dsn) {
    const protocol = dsn.protocol ? `${dsn.protocol}:` : "";
    const port = dsn.port ? `:${dsn.port}` : "";
    return `${protocol}//${dsn.host}${port}${dsn.path ? `/${dsn.path}` : ""}/api/`;
  }
  function _getIngestEndpoint(dsn) {
    return `${getBaseApiEndpoint(dsn)}${dsn.projectId}/envelope/`;
  }
  function _encodedAuth(dsn, sdkInfo) {
    return urlEncode({
      // We send only the minimum set of required information. See
      // https://github.com/getsentry/sentry-javascript/issues/2572.
      sentry_key: dsn.publicKey,
      sentry_version: SENTRY_API_VERSION,
      ...sdkInfo && { sentry_client: `${sdkInfo.name}/${sdkInfo.version}` }
    });
  }
  function getEnvelopeEndpointWithUrlEncodedAuth(dsn, tunnel, sdkInfo) {
    return tunnel ? tunnel : `${_getIngestEndpoint(dsn)}?${_encodedAuth(dsn, sdkInfo)}`;
  }

  // node_modules/@sentry/core/build/esm/integration.js
  var installedIntegrations = [];
  function filterDuplicates(integrations) {
    const integrationsByName = {};
    integrations.forEach((currentInstance) => {
      const { name } = currentInstance;
      const existingInstance = integrationsByName[name];
      if (existingInstance && !existingInstance.isDefaultInstance && currentInstance.isDefaultInstance) {
        return;
      }
      integrationsByName[name] = currentInstance;
    });
    return Object.values(integrationsByName);
  }
  function getIntegrationsToSetup(options) {
    const defaultIntegrations = options.defaultIntegrations || [];
    const userIntegrations = options.integrations;
    defaultIntegrations.forEach((integration) => {
      integration.isDefaultInstance = true;
    });
    let integrations;
    if (Array.isArray(userIntegrations)) {
      integrations = [...defaultIntegrations, ...userIntegrations];
    } else if (typeof userIntegrations === "function") {
      integrations = arrayify(userIntegrations(defaultIntegrations));
    } else {
      integrations = defaultIntegrations;
    }
    const finalIntegrations = filterDuplicates(integrations);
    const debugIndex = finalIntegrations.findIndex((integration) => integration.name === "Debug");
    if (debugIndex > -1) {
      const [debugInstance] = finalIntegrations.splice(debugIndex, 1);
      finalIntegrations.push(debugInstance);
    }
    return finalIntegrations;
  }
  function setupIntegrations(client, integrations) {
    const integrationIndex = {};
    integrations.forEach((integration) => {
      if (integration) {
        setupIntegration(client, integration, integrationIndex);
      }
    });
    return integrationIndex;
  }
  function afterSetupIntegrations(client, integrations) {
    for (const integration of integrations) {
      if (integration && integration.afterAllSetup) {
        integration.afterAllSetup(client);
      }
    }
  }
  function setupIntegration(client, integration, integrationIndex) {
    if (integrationIndex[integration.name]) {
      DEBUG_BUILD2 && logger.log(`Integration skipped because it was already installed: ${integration.name}`);
      return;
    }
    integrationIndex[integration.name] = integration;
    if (installedIntegrations.indexOf(integration.name) === -1 && typeof integration.setupOnce === "function") {
      integration.setupOnce();
      installedIntegrations.push(integration.name);
    }
    if (integration.setup && typeof integration.setup === "function") {
      integration.setup(client);
    }
    if (typeof integration.preprocessEvent === "function") {
      const callback = integration.preprocessEvent.bind(integration);
      client.on("preprocessEvent", (event, hint) => callback(event, hint, client));
    }
    if (typeof integration.processEvent === "function") {
      const callback = integration.processEvent.bind(integration);
      const processor = Object.assign((event, hint) => callback(event, hint, client), {
        id: integration.name
      });
      client.addEventProcessor(processor);
    }
    DEBUG_BUILD2 && logger.log(`Integration installed: ${integration.name}`);
  }
  function defineIntegration(fn) {
    return fn;
  }

  // node_modules/@sentry/core/build/esm/baseclient.js
  var ALREADY_SEEN_ERROR = "Not capturing exception because it's already been captured.";
  var BaseClient = class {
    /** Options passed to the SDK. */
    /** The client Dsn, if specified in options. Without this Dsn, the SDK will be disabled. */
    /** Array of set up integrations. */
    /** Number of calls being processed */
    /** Holds flushable  */
    // eslint-disable-next-line @typescript-eslint/ban-types
    /**
     * Initializes this client instance.
     *
     * @param options Options for the client.
     */
    constructor(options) {
      this._options = options;
      this._integrations = {};
      this._numProcessing = 0;
      this._outcomes = {};
      this._hooks = {};
      this._eventProcessors = [];
      if (options.dsn) {
        this._dsn = makeDsn(options.dsn);
      } else {
        DEBUG_BUILD2 && logger.warn("No DSN provided, client will not send events.");
      }
      if (this._dsn) {
        const url = getEnvelopeEndpointWithUrlEncodedAuth(
          this._dsn,
          options.tunnel,
          options._metadata ? options._metadata.sdk : void 0
        );
        this._transport = options.transport({
          tunnel: this._options.tunnel,
          recordDroppedEvent: this.recordDroppedEvent.bind(this),
          ...options.transportOptions,
          url
        });
      }
    }
    /**
     * @inheritDoc
     */
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    captureException(exception, hint, scope) {
      const eventId = uuid4();
      if (checkOrSetAlreadyCaught(exception)) {
        DEBUG_BUILD2 && logger.log(ALREADY_SEEN_ERROR);
        return eventId;
      }
      const hintWithEventId = {
        event_id: eventId,
        ...hint
      };
      this._process(
        this.eventFromException(exception, hintWithEventId).then(
          (event) => this._captureEvent(event, hintWithEventId, scope)
        )
      );
      return hintWithEventId.event_id;
    }
    /**
     * @inheritDoc
     */
    captureMessage(message, level, hint, currentScope) {
      const hintWithEventId = {
        event_id: uuid4(),
        ...hint
      };
      const eventMessage = isParameterizedString(message) ? message : String(message);
      const promisedEvent = isPrimitive(message) ? this.eventFromMessage(eventMessage, level, hintWithEventId) : this.eventFromException(message, hintWithEventId);
      this._process(promisedEvent.then((event) => this._captureEvent(event, hintWithEventId, currentScope)));
      return hintWithEventId.event_id;
    }
    /**
     * @inheritDoc
     */
    captureEvent(event, hint, currentScope) {
      const eventId = uuid4();
      if (hint && hint.originalException && checkOrSetAlreadyCaught(hint.originalException)) {
        DEBUG_BUILD2 && logger.log(ALREADY_SEEN_ERROR);
        return eventId;
      }
      const hintWithEventId = {
        event_id: eventId,
        ...hint
      };
      const sdkProcessingMetadata = event.sdkProcessingMetadata || {};
      const capturedSpanScope = sdkProcessingMetadata.capturedSpanScope;
      this._process(this._captureEvent(event, hintWithEventId, capturedSpanScope || currentScope));
      return hintWithEventId.event_id;
    }
    /**
     * @inheritDoc
     */
    captureSession(session) {
      if (!(typeof session.release === "string")) {
        DEBUG_BUILD2 && logger.warn("Discarded session because of missing or non-string release");
      } else {
        this.sendSession(session);
        updateSession(session, { init: false });
      }
    }
    /**
     * @inheritDoc
     */
    getDsn() {
      return this._dsn;
    }
    /**
     * @inheritDoc
     */
    getOptions() {
      return this._options;
    }
    /**
     * @see SdkMetadata in @sentry/types
     *
     * @return The metadata of the SDK
     */
    getSdkMetadata() {
      return this._options._metadata;
    }
    /**
     * @inheritDoc
     */
    getTransport() {
      return this._transport;
    }
    /**
     * @inheritDoc
     */
    flush(timeout) {
      const transport = this._transport;
      if (transport) {
        this.emit("flush");
        return this._isClientDoneProcessing(timeout).then((clientFinished) => {
          return transport.flush(timeout).then((transportFlushed) => clientFinished && transportFlushed);
        });
      } else {
        return resolvedSyncPromise(true);
      }
    }
    /**
     * @inheritDoc
     */
    close(timeout) {
      return this.flush(timeout).then((result) => {
        this.getOptions().enabled = false;
        this.emit("close");
        return result;
      });
    }
    /** Get all installed event processors. */
    getEventProcessors() {
      return this._eventProcessors;
    }
    /** @inheritDoc */
    addEventProcessor(eventProcessor) {
      this._eventProcessors.push(eventProcessor);
    }
    /** @inheritdoc */
    init() {
      if (this._isEnabled() || // Force integrations to be setup even if no DSN was set when we have
      // Spotlight enabled. This is particularly important for browser as we
      // don't support the `spotlight` option there and rely on the users
      // adding the `spotlightBrowserIntegration()` to their integrations which
      // wouldn't get initialized with the check below when there's no DSN set.
      this._options.integrations.some(({ name }) => name.startsWith("Spotlight"))) {
        this._setupIntegrations();
      }
    }
    /**
     * Gets an installed integration by its name.
     *
     * @returns The installed integration or `undefined` if no integration with that `name` was installed.
     */
    getIntegrationByName(integrationName) {
      return this._integrations[integrationName];
    }
    /**
     * @inheritDoc
     */
    addIntegration(integration) {
      const isAlreadyInstalled = this._integrations[integration.name];
      setupIntegration(this, integration, this._integrations);
      if (!isAlreadyInstalled) {
        afterSetupIntegrations(this, [integration]);
      }
    }
    /**
     * @inheritDoc
     */
    sendEvent(event, hint = {}) {
      this.emit("beforeSendEvent", event, hint);
      let env = createEventEnvelope(event, this._dsn, this._options._metadata, this._options.tunnel);
      for (const attachment of hint.attachments || []) {
        env = addItemToEnvelope(env, createAttachmentEnvelopeItem(attachment));
      }
      const promise = this.sendEnvelope(env);
      if (promise) {
        promise.then((sendResponse) => this.emit("afterSendEvent", event, sendResponse), null);
      }
    }
    /**
     * @inheritDoc
     */
    sendSession(session) {
      const env = createSessionEnvelope(session, this._dsn, this._options._metadata, this._options.tunnel);
      this.sendEnvelope(env);
    }
    /**
     * @inheritDoc
     */
    recordDroppedEvent(reason, category, eventOrCount) {
      if (this._options.sendClientReports) {
        const count = typeof eventOrCount === "number" ? eventOrCount : 1;
        const key = `${reason}:${category}`;
        DEBUG_BUILD2 && logger.log(`Recording outcome: "${key}"${count > 1 ? ` (${count} times)` : ""}`);
        this._outcomes[key] = (this._outcomes[key] || 0) + count;
      }
    }
    // Keep on() & emit() signatures in sync with types' client.ts interface
    /* eslint-disable @typescript-eslint/unified-signatures */
    /** @inheritdoc */
    /** @inheritdoc */
    on(hook, callback) {
      const hooks = this._hooks[hook] = this._hooks[hook] || [];
      hooks.push(callback);
      return () => {
        const cbIndex = hooks.indexOf(callback);
        if (cbIndex > -1) {
          hooks.splice(cbIndex, 1);
        }
      };
    }
    /** @inheritdoc */
    /** @inheritdoc */
    emit(hook, ...rest) {
      const callbacks = this._hooks[hook];
      if (callbacks) {
        callbacks.forEach((callback) => callback(...rest));
      }
    }
    /**
     * @inheritdoc
     */
    sendEnvelope(envelope) {
      this.emit("beforeEnvelope", envelope);
      if (this._isEnabled() && this._transport) {
        return this._transport.send(envelope).then(null, (reason) => {
          DEBUG_BUILD2 && logger.error("Error while sending event:", reason);
          return reason;
        });
      }
      DEBUG_BUILD2 && logger.error("Transport disabled");
      return resolvedSyncPromise({});
    }
    /* eslint-enable @typescript-eslint/unified-signatures */
    /** Setup integrations for this client. */
    _setupIntegrations() {
      const { integrations } = this._options;
      this._integrations = setupIntegrations(this, integrations);
      afterSetupIntegrations(this, integrations);
    }
    /** Updates existing session based on the provided event */
    _updateSessionFromEvent(session, event) {
      let crashed = false;
      let errored = false;
      const exceptions = event.exception && event.exception.values;
      if (exceptions) {
        errored = true;
        for (const ex of exceptions) {
          const mechanism = ex.mechanism;
          if (mechanism && mechanism.handled === false) {
            crashed = true;
            break;
          }
        }
      }
      const sessionNonTerminal = session.status === "ok";
      const shouldUpdateAndSend = sessionNonTerminal && session.errors === 0 || sessionNonTerminal && crashed;
      if (shouldUpdateAndSend) {
        updateSession(session, {
          ...crashed && { status: "crashed" },
          errors: session.errors || Number(errored || crashed)
        });
        this.captureSession(session);
      }
    }
    /**
     * Determine if the client is finished processing. Returns a promise because it will wait `timeout` ms before saying
     * "no" (resolving to `false`) in order to give the client a chance to potentially finish first.
     *
     * @param timeout The time, in ms, after which to resolve to `false` if the client is still busy. Passing `0` (or not
     * passing anything) will make the promise wait as long as it takes for processing to finish before resolving to
     * `true`.
     * @returns A promise which will resolve to `true` if processing is already done or finishes before the timeout, and
     * `false` otherwise
     */
    _isClientDoneProcessing(timeout) {
      return new SyncPromise((resolve) => {
        let ticked = 0;
        const tick = 1;
        const interval = setInterval(() => {
          if (this._numProcessing == 0) {
            clearInterval(interval);
            resolve(true);
          } else {
            ticked += tick;
            if (timeout && ticked >= timeout) {
              clearInterval(interval);
              resolve(false);
            }
          }
        }, tick);
      });
    }
    /** Determines whether this SDK is enabled and a transport is present. */
    _isEnabled() {
      return this.getOptions().enabled !== false && this._transport !== void 0;
    }
    /**
     * Adds common information to events.
     *
     * The information includes release and environment from `options`,
     * breadcrumbs and context (extra, tags and user) from the scope.
     *
     * Information that is already present in the event is never overwritten. For
     * nested objects, such as the context, keys are merged.
     *
     * @param event The original event.
     * @param hint May contain additional information about the original exception.
     * @param currentScope A scope containing event metadata.
     * @returns A new event with more information.
     */
    _prepareEvent(event, hint, currentScope, isolationScope = getIsolationScope()) {
      const options = this.getOptions();
      const integrations = Object.keys(this._integrations);
      if (!hint.integrations && integrations.length > 0) {
        hint.integrations = integrations;
      }
      this.emit("preprocessEvent", event, hint);
      if (!event.type) {
        isolationScope.setLastEventId(event.event_id || hint.event_id);
      }
      return prepareEvent(options, event, hint, currentScope, this, isolationScope).then((evt) => {
        if (evt === null) {
          return evt;
        }
        const propagationContext = {
          ...isolationScope.getPropagationContext(),
          ...currentScope ? currentScope.getPropagationContext() : void 0
        };
        const trace = evt.contexts && evt.contexts.trace;
        if (!trace && propagationContext) {
          const { traceId: trace_id, spanId, parentSpanId, dsc } = propagationContext;
          evt.contexts = {
            trace: dropUndefinedKeys({
              trace_id,
              span_id: spanId,
              parent_span_id: parentSpanId
            }),
            ...evt.contexts
          };
          const dynamicSamplingContext = dsc ? dsc : getDynamicSamplingContextFromClient(trace_id, this);
          evt.sdkProcessingMetadata = {
            dynamicSamplingContext,
            ...evt.sdkProcessingMetadata
          };
        }
        return evt;
      });
    }
    /**
     * Processes the event and logs an error in case of rejection
     * @param event
     * @param hint
     * @param scope
     */
    _captureEvent(event, hint = {}, scope) {
      return this._processEvent(event, hint, scope).then(
        (finalEvent) => {
          return finalEvent.event_id;
        },
        (reason) => {
          if (DEBUG_BUILD2) {
            const sentryError = reason;
            if (sentryError.logLevel === "log") {
              logger.log(sentryError.message);
            } else {
              logger.warn(sentryError);
            }
          }
          return void 0;
        }
      );
    }
    /**
     * Processes an event (either error or message) and sends it to Sentry.
     *
     * This also adds breadcrumbs and context information to the event. However,
     * platform specific meta data (such as the User's IP address) must be added
     * by the SDK implementor.
     *
     *
     * @param event The event to send to Sentry.
     * @param hint May contain additional information about the original exception.
     * @param currentScope A scope containing event metadata.
     * @returns A SyncPromise that resolves with the event or rejects in case event was/will not be send.
     */
    _processEvent(event, hint, currentScope) {
      const options = this.getOptions();
      const { sampleRate } = options;
      const isTransaction = isTransactionEvent(event);
      const isError2 = isErrorEvent2(event);
      const eventType = event.type || "error";
      const beforeSendLabel = `before send for type \`${eventType}\``;
      const parsedSampleRate = typeof sampleRate === "undefined" ? void 0 : parseSampleRate(sampleRate);
      if (isError2 && typeof parsedSampleRate === "number" && Math.random() > parsedSampleRate) {
        this.recordDroppedEvent("sample_rate", "error", event);
        return rejectedSyncPromise(
          new SentryError(
            `Discarding event because it's not included in the random sample (sampling rate = ${sampleRate})`,
            "log"
          )
        );
      }
      const dataCategory = eventType === "replay_event" ? "replay" : eventType;
      const sdkProcessingMetadata = event.sdkProcessingMetadata || {};
      const capturedSpanIsolationScope = sdkProcessingMetadata.capturedSpanIsolationScope;
      return this._prepareEvent(event, hint, currentScope, capturedSpanIsolationScope).then((prepared) => {
        if (prepared === null) {
          this.recordDroppedEvent("event_processor", dataCategory, event);
          throw new SentryError("An event processor returned `null`, will not send event.", "log");
        }
        const isInternalException = hint.data && hint.data.__sentry__ === true;
        if (isInternalException) {
          return prepared;
        }
        const result = processBeforeSend(this, options, prepared, hint);
        return _validateBeforeSendResult(result, beforeSendLabel);
      }).then((processedEvent) => {
        if (processedEvent === null) {
          this.recordDroppedEvent("before_send", dataCategory, event);
          if (isTransaction) {
            const spans = event.spans || [];
            const spanCount = 1 + spans.length;
            this.recordDroppedEvent("before_send", "span", spanCount);
          }
          throw new SentryError(`${beforeSendLabel} returned \`null\`, will not send event.`, "log");
        }
        const session = currentScope && currentScope.getSession();
        if (!isTransaction && session) {
          this._updateSessionFromEvent(session, processedEvent);
        }
        if (isTransaction) {
          const spanCountBefore = processedEvent.sdkProcessingMetadata && processedEvent.sdkProcessingMetadata.spanCountBeforeProcessing || 0;
          const spanCountAfter = processedEvent.spans ? processedEvent.spans.length : 0;
          const droppedSpanCount = spanCountBefore - spanCountAfter;
          if (droppedSpanCount > 0) {
            this.recordDroppedEvent("before_send", "span", droppedSpanCount);
          }
        }
        const transactionInfo = processedEvent.transaction_info;
        if (isTransaction && transactionInfo && processedEvent.transaction !== event.transaction) {
          const source = "custom";
          processedEvent.transaction_info = {
            ...transactionInfo,
            source
          };
        }
        this.sendEvent(processedEvent, hint);
        return processedEvent;
      }).then(null, (reason) => {
        if (reason instanceof SentryError) {
          throw reason;
        }
        this.captureException(reason, {
          data: {
            __sentry__: true
          },
          originalException: reason
        });
        throw new SentryError(
          `Event processing pipeline threw an error, original event will not be sent. Details have been sent as a new event.
Reason: ${reason}`
        );
      });
    }
    /**
     * Occupies the client with processing and event
     */
    _process(promise) {
      this._numProcessing++;
      void promise.then(
        (value) => {
          this._numProcessing--;
          return value;
        },
        (reason) => {
          this._numProcessing--;
          return reason;
        }
      );
    }
    /**
     * Clears outcomes on this client and returns them.
     */
    _clearOutcomes() {
      const outcomes = this._outcomes;
      this._outcomes = {};
      return Object.entries(outcomes).map(([key, quantity]) => {
        const [reason, category] = key.split(":");
        return {
          reason,
          category,
          quantity
        };
      });
    }
    /**
     * Sends client reports as an envelope.
     */
    _flushOutcomes() {
      DEBUG_BUILD2 && logger.log("Flushing outcomes...");
      const outcomes = this._clearOutcomes();
      if (outcomes.length === 0) {
        DEBUG_BUILD2 && logger.log("No outcomes to send");
        return;
      }
      if (!this._dsn) {
        DEBUG_BUILD2 && logger.log("No dsn provided, will not send outcomes");
        return;
      }
      DEBUG_BUILD2 && logger.log("Sending outcomes:", outcomes);
      const envelope = createClientReportEnvelope(outcomes, this._options.tunnel && dsnToString(this._dsn));
      this.sendEnvelope(envelope);
    }
    /**
     * @inheritDoc
     */
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
  };
  function _validateBeforeSendResult(beforeSendResult, beforeSendLabel) {
    const invalidValueError = `${beforeSendLabel} must return \`null\` or a valid event.`;
    if (isThenable(beforeSendResult)) {
      return beforeSendResult.then(
        (event) => {
          if (!isPlainObject(event) && event !== null) {
            throw new SentryError(invalidValueError);
          }
          return event;
        },
        (e2) => {
          throw new SentryError(`${beforeSendLabel} rejected with ${e2}`);
        }
      );
    } else if (!isPlainObject(beforeSendResult) && beforeSendResult !== null) {
      throw new SentryError(invalidValueError);
    }
    return beforeSendResult;
  }
  function processBeforeSend(client, options, event, hint) {
    const { beforeSend, beforeSendTransaction, beforeSendSpan } = options;
    if (isErrorEvent2(event) && beforeSend) {
      return beforeSend(event, hint);
    }
    if (isTransactionEvent(event)) {
      if (event.spans && beforeSendSpan) {
        const processedSpans = [];
        for (const span of event.spans) {
          const processedSpan = beforeSendSpan(span);
          if (processedSpan) {
            processedSpans.push(processedSpan);
          } else {
            client.recordDroppedEvent("before_send", "span");
          }
        }
        event.spans = processedSpans;
      }
      if (beforeSendTransaction) {
        if (event.spans) {
          const spanCountBefore = event.spans.length;
          event.sdkProcessingMetadata = {
            ...event.sdkProcessingMetadata,
            spanCountBeforeProcessing: spanCountBefore
          };
        }
        return beforeSendTransaction(event, hint);
      }
    }
    return event;
  }
  function isErrorEvent2(event) {
    return event.type === void 0;
  }
  function isTransactionEvent(event) {
    return event.type === "transaction";
  }

  // node_modules/@sentry/core/build/esm/sdk.js
  function initAndBind(clientClass, options) {
    if (options.debug === true) {
      if (DEBUG_BUILD2) {
        logger.enable();
      } else {
        consoleSandbox(() => {
          console.warn("[Sentry] Cannot initialize SDK with `debug` option using a non-debug bundle.");
        });
      }
    }
    const scope = getCurrentScope();
    scope.update(options.initialScope);
    const client = new clientClass(options);
    setCurrentClient(client);
    client.init();
    return client;
  }
  function setCurrentClient(client) {
    getCurrentScope().setClient(client);
  }

  // node_modules/@sentry/core/build/esm/transports/base.js
  var DEFAULT_TRANSPORT_BUFFER_SIZE = 64;
  function createTransport(options, makeRequest, buffer = makePromiseBuffer(
    options.bufferSize || DEFAULT_TRANSPORT_BUFFER_SIZE
  )) {
    let rateLimits = {};
    const flush2 = (timeout) => buffer.drain(timeout);
    function send(envelope) {
      const filteredEnvelopeItems = [];
      forEachEnvelopeItem(envelope, (item, type) => {
        const dataCategory = envelopeItemTypeToDataCategory(type);
        if (isRateLimited(rateLimits, dataCategory)) {
          const event = getEventForEnvelopeItem(item, type);
          options.recordDroppedEvent("ratelimit_backoff", dataCategory, event);
        } else {
          filteredEnvelopeItems.push(item);
        }
      });
      if (filteredEnvelopeItems.length === 0) {
        return resolvedSyncPromise({});
      }
      const filteredEnvelope = createEnvelope(envelope[0], filteredEnvelopeItems);
      const recordEnvelopeLoss = (reason) => {
        forEachEnvelopeItem(filteredEnvelope, (item, type) => {
          const event = getEventForEnvelopeItem(item, type);
          options.recordDroppedEvent(reason, envelopeItemTypeToDataCategory(type), event);
        });
      };
      const requestTask = () => makeRequest({ body: serializeEnvelope(filteredEnvelope) }).then(
        (response) => {
          if (response.statusCode !== void 0 && (response.statusCode < 200 || response.statusCode >= 300)) {
            DEBUG_BUILD2 && logger.warn(`Sentry responded with status code ${response.statusCode} to sent event.`);
          }
          rateLimits = updateRateLimits(rateLimits, response);
          return response;
        },
        (error) => {
          recordEnvelopeLoss("network_error");
          throw error;
        }
      );
      return buffer.add(requestTask).then(
        (result) => result,
        (error) => {
          if (error instanceof SentryError) {
            DEBUG_BUILD2 && logger.error("Skipped sending event because buffer is full.");
            recordEnvelopeLoss("queue_overflow");
            return resolvedSyncPromise({});
          } else {
            throw error;
          }
        }
      );
    }
    return {
      send,
      flush: flush2
    };
  }
  function getEventForEnvelopeItem(item, type) {
    if (type !== "event" && type !== "transaction") {
      return void 0;
    }
    return Array.isArray(item) ? item[1] : void 0;
  }

  // node_modules/@sentry/core/build/esm/utils/isSentryRequestUrl.js
  function isSentryRequestUrl(url, client) {
    const dsn = client && client.getDsn();
    const tunnel = client && client.getOptions().tunnel;
    return checkDsn(url, dsn) || checkTunnel(url, tunnel);
  }
  function checkTunnel(url, tunnel) {
    if (!tunnel) {
      return false;
    }
    return removeTrailingSlash(url) === removeTrailingSlash(tunnel);
  }
  function checkDsn(url, dsn) {
    return dsn ? url.includes(dsn.host) : false;
  }
  function removeTrailingSlash(str) {
    return str[str.length - 1] === "/" ? str.slice(0, -1) : str;
  }

  // node_modules/@sentry/core/build/esm/utils/sdkMetadata.js
  function applySdkMetadata(options, name, names = [name], source = "npm") {
    const metadata = options._metadata || {};
    if (!metadata.sdk) {
      metadata.sdk = {
        name: `sentry.javascript.${name}`,
        packages: names.map((name2) => ({
          name: `${source}:@sentry/${name2}`,
          version: SDK_VERSION
        })),
        version: SDK_VERSION
      };
    }
    options._metadata = metadata;
  }

  // node_modules/@sentry/core/build/esm/breadcrumbs.js
  var DEFAULT_BREADCRUMBS = 100;
  function addBreadcrumb(breadcrumb, hint) {
    const client = getClient();
    const isolationScope = getIsolationScope();
    if (!client) return;
    const { beforeBreadcrumb = null, maxBreadcrumbs = DEFAULT_BREADCRUMBS } = client.getOptions();
    if (maxBreadcrumbs <= 0) return;
    const timestamp = dateTimestampInSeconds();
    const mergedBreadcrumb = { timestamp, ...breadcrumb };
    const finalBreadcrumb = beforeBreadcrumb ? consoleSandbox(() => beforeBreadcrumb(mergedBreadcrumb, hint)) : mergedBreadcrumb;
    if (finalBreadcrumb === null) return;
    if (client.emit) {
      client.emit("beforeAddBreadcrumb", finalBreadcrumb, hint);
    }
    isolationScope.addBreadcrumb(finalBreadcrumb, maxBreadcrumbs);
  }

  // node_modules/@sentry/core/build/esm/integrations/functiontostring.js
  var originalFunctionToString;
  var INTEGRATION_NAME = "FunctionToString";
  var SETUP_CLIENTS = /* @__PURE__ */ new WeakMap();
  var _functionToStringIntegration = () => {
    return {
      name: INTEGRATION_NAME,
      setupOnce() {
        originalFunctionToString = Function.prototype.toString;
        try {
          Function.prototype.toString = function(...args) {
            const originalFunction = getOriginalFunction(this);
            const context = SETUP_CLIENTS.has(getClient()) && originalFunction !== void 0 ? originalFunction : this;
            return originalFunctionToString.apply(context, args);
          };
        } catch (e2) {
        }
      },
      setup(client) {
        SETUP_CLIENTS.set(client, true);
      }
    };
  };
  var functionToStringIntegration = defineIntegration(_functionToStringIntegration);

  // node_modules/@sentry/core/build/esm/integrations/inboundfilters.js
  var DEFAULT_IGNORE_ERRORS = [
    /^Script error\.?$/,
    /^Javascript error: Script error\.? on line 0$/,
    /^ResizeObserver loop completed with undelivered notifications.$/,
    // The browser logs this when a ResizeObserver handler takes a bit longer. Usually this is not an actual issue though. It indicates slowness.
    /^Cannot redefine property: googletag$/,
    // This is thrown when google tag manager is used in combination with an ad blocker
    "undefined is not an object (evaluating 'a.L')",
    // Random error that happens but not actionable or noticeable to end-users.
    `can't redefine non-configurable property "solana"`,
    // Probably a browser extension or custom browser (Brave) throwing this error
    "vv().getRestrictions is not a function. (In 'vv().getRestrictions(1,a)', 'vv().getRestrictions' is undefined)",
    // Error thrown by GTM, seemingly not affecting end-users
    "Can't find variable: _AutofillCallbackHandler"
    // Unactionable error in instagram webview https://developers.facebook.com/community/threads/320013549791141/
  ];
  var INTEGRATION_NAME2 = "InboundFilters";
  var _inboundFiltersIntegration = (options = {}) => {
    return {
      name: INTEGRATION_NAME2,
      processEvent(event, _hint, client) {
        const clientOptions = client.getOptions();
        const mergedOptions = _mergeOptions(options, clientOptions);
        return _shouldDropEvent(event, mergedOptions) ? null : event;
      }
    };
  };
  var inboundFiltersIntegration = defineIntegration(_inboundFiltersIntegration);
  function _mergeOptions(internalOptions = {}, clientOptions = {}) {
    return {
      allowUrls: [...internalOptions.allowUrls || [], ...clientOptions.allowUrls || []],
      denyUrls: [...internalOptions.denyUrls || [], ...clientOptions.denyUrls || []],
      ignoreErrors: [
        ...internalOptions.ignoreErrors || [],
        ...clientOptions.ignoreErrors || [],
        ...internalOptions.disableErrorDefaults ? [] : DEFAULT_IGNORE_ERRORS
      ],
      ignoreTransactions: [...internalOptions.ignoreTransactions || [], ...clientOptions.ignoreTransactions || []],
      ignoreInternal: internalOptions.ignoreInternal !== void 0 ? internalOptions.ignoreInternal : true
    };
  }
  function _shouldDropEvent(event, options) {
    if (options.ignoreInternal && _isSentryError(event)) {
      DEBUG_BUILD2 && logger.warn(`Event dropped due to being internal Sentry Error.
Event: ${getEventDescription(event)}`);
      return true;
    }
    if (_isIgnoredError(event, options.ignoreErrors)) {
      DEBUG_BUILD2 && logger.warn(
        `Event dropped due to being matched by \`ignoreErrors\` option.
Event: ${getEventDescription(event)}`
      );
      return true;
    }
    if (_isUselessError(event)) {
      DEBUG_BUILD2 && logger.warn(
        `Event dropped due to not having an error message, error type or stacktrace.
Event: ${getEventDescription(
          event
        )}`
      );
      return true;
    }
    if (_isIgnoredTransaction(event, options.ignoreTransactions)) {
      DEBUG_BUILD2 && logger.warn(
        `Event dropped due to being matched by \`ignoreTransactions\` option.
Event: ${getEventDescription(event)}`
      );
      return true;
    }
    if (_isDeniedUrl(event, options.denyUrls)) {
      DEBUG_BUILD2 && logger.warn(
        `Event dropped due to being matched by \`denyUrls\` option.
Event: ${getEventDescription(
          event
        )}.
Url: ${_getEventFilterUrl(event)}`
      );
      return true;
    }
    if (!_isAllowedUrl(event, options.allowUrls)) {
      DEBUG_BUILD2 && logger.warn(
        `Event dropped due to not being matched by \`allowUrls\` option.
Event: ${getEventDescription(
          event
        )}.
Url: ${_getEventFilterUrl(event)}`
      );
      return true;
    }
    return false;
  }
  function _isIgnoredError(event, ignoreErrors) {
    if (event.type || !ignoreErrors || !ignoreErrors.length) {
      return false;
    }
    return _getPossibleEventMessages(event).some((message) => stringMatchesSomePattern(message, ignoreErrors));
  }
  function _isIgnoredTransaction(event, ignoreTransactions) {
    if (event.type !== "transaction" || !ignoreTransactions || !ignoreTransactions.length) {
      return false;
    }
    const name = event.transaction;
    return name ? stringMatchesSomePattern(name, ignoreTransactions) : false;
  }
  function _isDeniedUrl(event, denyUrls) {
    if (!denyUrls || !denyUrls.length) {
      return false;
    }
    const url = _getEventFilterUrl(event);
    return !url ? false : stringMatchesSomePattern(url, denyUrls);
  }
  function _isAllowedUrl(event, allowUrls) {
    if (!allowUrls || !allowUrls.length) {
      return true;
    }
    const url = _getEventFilterUrl(event);
    return !url ? true : stringMatchesSomePattern(url, allowUrls);
  }
  function _getPossibleEventMessages(event) {
    const possibleMessages = [];
    if (event.message) {
      possibleMessages.push(event.message);
    }
    let lastException;
    try {
      lastException = event.exception.values[event.exception.values.length - 1];
    } catch (e2) {
    }
    if (lastException) {
      if (lastException.value) {
        possibleMessages.push(lastException.value);
        if (lastException.type) {
          possibleMessages.push(`${lastException.type}: ${lastException.value}`);
        }
      }
    }
    return possibleMessages;
  }
  function _isSentryError(event) {
    try {
      return event.exception.values[0].type === "SentryError";
    } catch (e2) {
    }
    return false;
  }
  function _getLastValidUrl(frames = []) {
    for (let i = frames.length - 1; i >= 0; i--) {
      const frame = frames[i];
      if (frame && frame.filename !== "<anonymous>" && frame.filename !== "[native code]") {
        return frame.filename || null;
      }
    }
    return null;
  }
  function _getEventFilterUrl(event) {
    try {
      let frames;
      try {
        frames = event.exception.values[0].stacktrace.frames;
      } catch (e2) {
      }
      return frames ? _getLastValidUrl(frames) : null;
    } catch (oO) {
      DEBUG_BUILD2 && logger.error(`Cannot extract url for event ${getEventDescription(event)}`);
      return null;
    }
  }
  function _isUselessError(event) {
    if (event.type) {
      return false;
    }
    if (!event.exception || !event.exception.values || event.exception.values.length === 0) {
      return false;
    }
    return (
      // No top-level message
      !event.message && // There are no exception values that have a stacktrace, a non-generic-Error type or value
      !event.exception.values.some((value) => value.stacktrace || value.type && value.type !== "Error" || value.value)
    );
  }

  // node_modules/@sentry/core/build/esm/integrations/dedupe.js
  var INTEGRATION_NAME3 = "Dedupe";
  var _dedupeIntegration = () => {
    let previousEvent;
    return {
      name: INTEGRATION_NAME3,
      processEvent(currentEvent) {
        if (currentEvent.type) {
          return currentEvent;
        }
        try {
          if (_shouldDropEvent2(currentEvent, previousEvent)) {
            DEBUG_BUILD2 && logger.warn("Event dropped due to being a duplicate of previously captured event.");
            return null;
          }
        } catch (_oO) {
        }
        return previousEvent = currentEvent;
      }
    };
  };
  var dedupeIntegration = defineIntegration(_dedupeIntegration);
  function _shouldDropEvent2(currentEvent, previousEvent) {
    if (!previousEvent) {
      return false;
    }
    if (_isSameMessageEvent(currentEvent, previousEvent)) {
      return true;
    }
    if (_isSameExceptionEvent(currentEvent, previousEvent)) {
      return true;
    }
    return false;
  }
  function _isSameMessageEvent(currentEvent, previousEvent) {
    const currentMessage = currentEvent.message;
    const previousMessage = previousEvent.message;
    if (!currentMessage && !previousMessage) {
      return false;
    }
    if (currentMessage && !previousMessage || !currentMessage && previousMessage) {
      return false;
    }
    if (currentMessage !== previousMessage) {
      return false;
    }
    if (!_isSameFingerprint(currentEvent, previousEvent)) {
      return false;
    }
    if (!_isSameStacktrace(currentEvent, previousEvent)) {
      return false;
    }
    return true;
  }
  function _isSameExceptionEvent(currentEvent, previousEvent) {
    const previousException = _getExceptionFromEvent(previousEvent);
    const currentException = _getExceptionFromEvent(currentEvent);
    if (!previousException || !currentException) {
      return false;
    }
    if (previousException.type !== currentException.type || previousException.value !== currentException.value) {
      return false;
    }
    if (!_isSameFingerprint(currentEvent, previousEvent)) {
      return false;
    }
    if (!_isSameStacktrace(currentEvent, previousEvent)) {
      return false;
    }
    return true;
  }
  function _isSameStacktrace(currentEvent, previousEvent) {
    let currentFrames = getFramesFromEvent(currentEvent);
    let previousFrames = getFramesFromEvent(previousEvent);
    if (!currentFrames && !previousFrames) {
      return true;
    }
    if (currentFrames && !previousFrames || !currentFrames && previousFrames) {
      return false;
    }
    currentFrames = currentFrames;
    previousFrames = previousFrames;
    if (previousFrames.length !== currentFrames.length) {
      return false;
    }
    for (let i = 0; i < previousFrames.length; i++) {
      const frameA = previousFrames[i];
      const frameB = currentFrames[i];
      if (frameA.filename !== frameB.filename || frameA.lineno !== frameB.lineno || frameA.colno !== frameB.colno || frameA.function !== frameB.function) {
        return false;
      }
    }
    return true;
  }
  function _isSameFingerprint(currentEvent, previousEvent) {
    let currentFingerprint = currentEvent.fingerprint;
    let previousFingerprint = previousEvent.fingerprint;
    if (!currentFingerprint && !previousFingerprint) {
      return true;
    }
    if (currentFingerprint && !previousFingerprint || !currentFingerprint && previousFingerprint) {
      return false;
    }
    currentFingerprint = currentFingerprint;
    previousFingerprint = previousFingerprint;
    try {
      return !!(currentFingerprint.join("") === previousFingerprint.join(""));
    } catch (_oO) {
      return false;
    }
  }
  function _getExceptionFromEvent(event) {
    return event.exception && event.exception.values && event.exception.values[0];
  }

  // node_modules/@sentry/core/build/esm/fetch.js
  function instrumentFetchRequest(handlerData, shouldCreateSpan, shouldAttachHeaders2, spans, spanOrigin = "auto.http.browser") {
    if (!handlerData.fetchData) {
      return void 0;
    }
    const shouldCreateSpanResult = hasTracingEnabled() && shouldCreateSpan(handlerData.fetchData.url);
    if (handlerData.endTimestamp && shouldCreateSpanResult) {
      const spanId = handlerData.fetchData.__span;
      if (!spanId) return;
      const span2 = spans[spanId];
      if (span2) {
        endSpan(span2, handlerData);
        delete spans[spanId];
      }
      return void 0;
    }
    const scope = getCurrentScope();
    const client = getClient();
    const { method, url } = handlerData.fetchData;
    const fullUrl = getFullURL(url);
    const host = fullUrl ? parseUrl(fullUrl).host : void 0;
    const hasParent = !!getActiveSpan();
    const span = shouldCreateSpanResult && hasParent ? startInactiveSpan({
      name: `${method} ${url}`,
      attributes: {
        url,
        type: "fetch",
        "http.method": method,
        "http.url": fullUrl,
        "server.address": host,
        [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: spanOrigin,
        [SEMANTIC_ATTRIBUTE_SENTRY_OP]: "http.client"
      }
    }) : new SentryNonRecordingSpan();
    handlerData.fetchData.__span = span.spanContext().spanId;
    spans[span.spanContext().spanId] = span;
    if (shouldAttachHeaders2(handlerData.fetchData.url) && client) {
      const request = handlerData.args[0];
      handlerData.args[1] = handlerData.args[1] || {};
      const options = handlerData.args[1];
      options.headers = addTracingHeadersToFetchRequest(
        request,
        client,
        scope,
        options,
        // If performance is disabled (TWP) or there's no active root span (pageload/navigation/interaction),
        // we do not want to use the span as base for the trace headers,
        // which means that the headers will be generated from the scope and the sampling decision is deferred
        hasTracingEnabled() && hasParent ? span : void 0
      );
    }
    return span;
  }
  function addTracingHeadersToFetchRequest(request, client, scope, fetchOptionsObj, span) {
    const isolationScope = getIsolationScope();
    const { traceId, spanId, sampled, dsc } = {
      ...isolationScope.getPropagationContext(),
      ...scope.getPropagationContext()
    };
    const sentryTraceHeader = span ? spanToTraceHeader(span) : generateSentryTraceHeader(traceId, spanId, sampled);
    const sentryBaggageHeader = dynamicSamplingContextToSentryBaggageHeader(
      dsc || (span ? getDynamicSamplingContextFromSpan(span) : getDynamicSamplingContextFromClient(traceId, client))
    );
    const headers = fetchOptionsObj.headers || (typeof Request !== "undefined" && isInstanceOf(request, Request) ? request.headers : void 0);
    if (!headers) {
      return { "sentry-trace": sentryTraceHeader, baggage: sentryBaggageHeader };
    } else if (typeof Headers !== "undefined" && isInstanceOf(headers, Headers)) {
      const newHeaders = new Headers(headers);
      newHeaders.set("sentry-trace", sentryTraceHeader);
      if (sentryBaggageHeader) {
        const prevBaggageHeader = newHeaders.get(BAGGAGE_HEADER_NAME);
        if (prevBaggageHeader) {
          const prevHeaderStrippedFromSentryBaggage = stripBaggageHeaderOfSentryBaggageValues(prevBaggageHeader);
          newHeaders.set(
            BAGGAGE_HEADER_NAME,
            // If there are non-sentry entries (i.e. if the stripped string is non-empty/truthy) combine the stripped header and sentry baggage header
            // otherwise just set the sentry baggage header
            prevHeaderStrippedFromSentryBaggage ? `${prevHeaderStrippedFromSentryBaggage},${sentryBaggageHeader}` : sentryBaggageHeader
          );
        } else {
          newHeaders.set(BAGGAGE_HEADER_NAME, sentryBaggageHeader);
        }
      }
      return newHeaders;
    } else if (Array.isArray(headers)) {
      const newHeaders = [
        ...headers.filter((header) => {
          return !(Array.isArray(header) && header[0] === "sentry-trace");
        }).map((header) => {
          if (Array.isArray(header) && header[0] === BAGGAGE_HEADER_NAME && typeof header[1] === "string") {
            const [headerName, headerValue, ...rest] = header;
            return [headerName, stripBaggageHeaderOfSentryBaggageValues(headerValue), ...rest];
          } else {
            return header;
          }
        }),
        // Attach the new sentry-trace header
        ["sentry-trace", sentryTraceHeader]
      ];
      if (sentryBaggageHeader) {
        newHeaders.push([BAGGAGE_HEADER_NAME, sentryBaggageHeader]);
      }
      return newHeaders;
    } else {
      const existingBaggageHeader = "baggage" in headers ? headers.baggage : void 0;
      let newBaggageHeaders = [];
      if (Array.isArray(existingBaggageHeader)) {
        newBaggageHeaders = existingBaggageHeader.map(
          (headerItem) => typeof headerItem === "string" ? stripBaggageHeaderOfSentryBaggageValues(headerItem) : headerItem
        ).filter((headerItem) => headerItem === "");
      } else if (existingBaggageHeader) {
        newBaggageHeaders.push(stripBaggageHeaderOfSentryBaggageValues(existingBaggageHeader));
      }
      if (sentryBaggageHeader) {
        newBaggageHeaders.push(sentryBaggageHeader);
      }
      return {
        ...headers,
        "sentry-trace": sentryTraceHeader,
        baggage: newBaggageHeaders.length > 0 ? newBaggageHeaders.join(",") : void 0
      };
    }
  }
  function getFullURL(url) {
    try {
      const parsed = new URL(url);
      return parsed.href;
    } catch (e2) {
      return void 0;
    }
  }
  function endSpan(span, handlerData) {
    if (handlerData.response) {
      setHttpStatus(span, handlerData.response.status);
      const contentLength = handlerData.response && handlerData.response.headers && handlerData.response.headers.get("content-length");
      if (contentLength) {
        const contentLengthNum = parseInt(contentLength);
        if (contentLengthNum > 0) {
          span.setAttribute("http.response_content_length", contentLengthNum);
        }
      }
    } else if (handlerData.error) {
      span.setStatus({ code: SPAN_STATUS_ERROR, message: "internal_error" });
    }
    span.end();
  }
  function stripBaggageHeaderOfSentryBaggageValues(baggageHeader) {
    return baggageHeader.split(",").filter((baggageEntry) => !baggageEntry.split("=")[0].startsWith(SENTRY_BAGGAGE_KEY_PREFIX)).join(",");
  }

  // node_modules/@sentry/browser/build/npm/esm/helpers.js
  var WINDOW4 = GLOBAL_OBJ;
  var ignoreOnError = 0;
  function shouldIgnoreOnError() {
    return ignoreOnError > 0;
  }
  function ignoreNextOnError() {
    ignoreOnError++;
    setTimeout(() => {
      ignoreOnError--;
    });
  }
  function wrap(fn, options = {}, before) {
    if (typeof fn !== "function") {
      return fn;
    }
    try {
      const wrapper = fn.__sentry_wrapped__;
      if (wrapper) {
        if (typeof wrapper === "function") {
          return wrapper;
        } else {
          return fn;
        }
      }
      if (getOriginalFunction(fn)) {
        return fn;
      }
    } catch (e2) {
      return fn;
    }
    const sentryWrapped = function() {
      const args = Array.prototype.slice.call(arguments);
      try {
        if (before && typeof before === "function") {
          before.apply(this, arguments);
        }
        const wrappedArguments = args.map((arg) => wrap(arg, options));
        return fn.apply(this, wrappedArguments);
      } catch (ex) {
        ignoreNextOnError();
        withScope2((scope) => {
          scope.addEventProcessor((event) => {
            if (options.mechanism) {
              addExceptionTypeValue(event, void 0, void 0);
              addExceptionMechanism(event, options.mechanism);
            }
            event.extra = {
              ...event.extra,
              arguments: args
            };
            return event;
          });
          captureException(ex);
        });
        throw ex;
      }
    };
    try {
      for (const property in fn) {
        if (Object.prototype.hasOwnProperty.call(fn, property)) {
          sentryWrapped[property] = fn[property];
        }
      }
    } catch (_oO) {
    }
    markFunctionWrapped(sentryWrapped, fn);
    addNonEnumerableProperty(fn, "__sentry_wrapped__", sentryWrapped);
    try {
      const descriptor = Object.getOwnPropertyDescriptor(sentryWrapped, "name");
      if (descriptor.configurable) {
        Object.defineProperty(sentryWrapped, "name", {
          get() {
            return fn.name;
          }
        });
      }
    } catch (_oO) {
    }
    return sentryWrapped;
  }

  // node_modules/@sentry/browser/build/npm/esm/debug-build.js
  var DEBUG_BUILD3 = typeof __SENTRY_DEBUG__ === "undefined" || __SENTRY_DEBUG__;

  // node_modules/@sentry/browser/build/npm/esm/eventbuilder.js
  function exceptionFromError(stackParser, ex) {
    const frames = parseStackFrames(stackParser, ex);
    const exception = {
      type: extractType(ex),
      value: extractMessage(ex)
    };
    if (frames.length) {
      exception.stacktrace = { frames };
    }
    if (exception.type === void 0 && exception.value === "") {
      exception.value = "Unrecoverable error caught";
    }
    return exception;
  }
  function eventFromPlainObject(stackParser, exception, syntheticException, isUnhandledRejection) {
    const client = getClient();
    const normalizeDepth = client && client.getOptions().normalizeDepth;
    const errorFromProp = getErrorPropertyFromObject(exception);
    const extra = {
      __serialized__: normalizeToSize(exception, normalizeDepth)
    };
    if (errorFromProp) {
      return {
        exception: {
          values: [exceptionFromError(stackParser, errorFromProp)]
        },
        extra
      };
    }
    const event = {
      exception: {
        values: [
          {
            type: isEvent(exception) ? exception.constructor.name : isUnhandledRejection ? "UnhandledRejection" : "Error",
            value: getNonErrorObjectExceptionValue(exception, { isUnhandledRejection })
          }
        ]
      },
      extra
    };
    if (syntheticException) {
      const frames = parseStackFrames(stackParser, syntheticException);
      if (frames.length) {
        event.exception.values[0].stacktrace = { frames };
      }
    }
    return event;
  }
  function eventFromError(stackParser, ex) {
    return {
      exception: {
        values: [exceptionFromError(stackParser, ex)]
      }
    };
  }
  function parseStackFrames(stackParser, ex) {
    const stacktrace = ex.stacktrace || ex.stack || "";
    const skipLines = getSkipFirstStackStringLines(ex);
    const framesToPop = getPopFirstTopFrames(ex);
    try {
      return stackParser(stacktrace, skipLines, framesToPop);
    } catch (e2) {
    }
    return [];
  }
  var reactMinifiedRegexp = /Minified React error #\d+;/i;
  function getSkipFirstStackStringLines(ex) {
    if (ex && reactMinifiedRegexp.test(ex.message)) {
      return 1;
    }
    return 0;
  }
  function getPopFirstTopFrames(ex) {
    if (typeof ex.framesToPop === "number") {
      return ex.framesToPop;
    }
    return 0;
  }
  function isWebAssemblyException(exception) {
    if (typeof WebAssembly !== "undefined" && typeof WebAssembly.Exception !== "undefined") {
      return exception instanceof WebAssembly.Exception;
    } else {
      return false;
    }
  }
  function extractType(ex) {
    const name = ex && ex.name;
    if (!name && isWebAssemblyException(ex)) {
      const hasTypeInMessage = ex.message && Array.isArray(ex.message) && ex.message.length == 2;
      return hasTypeInMessage ? ex.message[0] : "WebAssembly.Exception";
    }
    return name;
  }
  function extractMessage(ex) {
    const message = ex && ex.message;
    if (!message) {
      return "No error message";
    }
    if (message.error && typeof message.error.message === "string") {
      return message.error.message;
    }
    if (isWebAssemblyException(ex) && Array.isArray(ex.message) && ex.message.length == 2) {
      return ex.message[1];
    }
    return message;
  }
  function eventFromException(stackParser, exception, hint, attachStacktrace) {
    const syntheticException = hint && hint.syntheticException || void 0;
    const event = eventFromUnknownInput(stackParser, exception, syntheticException, attachStacktrace);
    addExceptionMechanism(event);
    event.level = "error";
    if (hint && hint.event_id) {
      event.event_id = hint.event_id;
    }
    return resolvedSyncPromise(event);
  }
  function eventFromMessage(stackParser, message, level = "info", hint, attachStacktrace) {
    const syntheticException = hint && hint.syntheticException || void 0;
    const event = eventFromString(stackParser, message, syntheticException, attachStacktrace);
    event.level = level;
    if (hint && hint.event_id) {
      event.event_id = hint.event_id;
    }
    return resolvedSyncPromise(event);
  }
  function eventFromUnknownInput(stackParser, exception, syntheticException, attachStacktrace, isUnhandledRejection) {
    let event;
    if (isErrorEvent(exception) && exception.error) {
      const errorEvent = exception;
      return eventFromError(stackParser, errorEvent.error);
    }
    if (isDOMError(exception) || isDOMException(exception)) {
      const domException = exception;
      if ("stack" in exception) {
        event = eventFromError(stackParser, exception);
      } else {
        const name = domException.name || (isDOMError(domException) ? "DOMError" : "DOMException");
        const message = domException.message ? `${name}: ${domException.message}` : name;
        event = eventFromString(stackParser, message, syntheticException, attachStacktrace);
        addExceptionTypeValue(event, message);
      }
      if ("code" in domException) {
        event.tags = { ...event.tags, "DOMException.code": `${domException.code}` };
      }
      return event;
    }
    if (isError(exception)) {
      return eventFromError(stackParser, exception);
    }
    if (isPlainObject(exception) || isEvent(exception)) {
      const objectException = exception;
      event = eventFromPlainObject(stackParser, objectException, syntheticException, isUnhandledRejection);
      addExceptionMechanism(event, {
        synthetic: true
      });
      return event;
    }
    event = eventFromString(stackParser, exception, syntheticException, attachStacktrace);
    addExceptionTypeValue(event, `${exception}`, void 0);
    addExceptionMechanism(event, {
      synthetic: true
    });
    return event;
  }
  function eventFromString(stackParser, message, syntheticException, attachStacktrace) {
    const event = {};
    if (attachStacktrace && syntheticException) {
      const frames = parseStackFrames(stackParser, syntheticException);
      if (frames.length) {
        event.exception = {
          values: [{ value: message, stacktrace: { frames } }]
        };
      }
    }
    if (isParameterizedString(message)) {
      const { __sentry_template_string__, __sentry_template_values__ } = message;
      event.logentry = {
        message: __sentry_template_string__,
        params: __sentry_template_values__
      };
      return event;
    }
    event.message = message;
    return event;
  }
  function getNonErrorObjectExceptionValue(exception, { isUnhandledRejection }) {
    const keys = extractExceptionKeysForMessage(exception);
    const captureType = isUnhandledRejection ? "promise rejection" : "exception";
    if (isErrorEvent(exception)) {
      return `Event \`ErrorEvent\` captured as ${captureType} with message \`${exception.message}\``;
    }
    if (isEvent(exception)) {
      const className = getObjectClassName(exception);
      return `Event \`${className}\` (type=${exception.type}) captured as ${captureType}`;
    }
    return `Object captured as ${captureType} with keys: ${keys}`;
  }
  function getObjectClassName(obj) {
    try {
      const prototype = Object.getPrototypeOf(obj);
      return prototype ? prototype.constructor.name : void 0;
    } catch (e2) {
    }
  }
  function getErrorPropertyFromObject(obj) {
    for (const prop in obj) {
      if (Object.prototype.hasOwnProperty.call(obj, prop)) {
        const value = obj[prop];
        if (value instanceof Error) {
          return value;
        }
      }
    }
    return void 0;
  }

  // node_modules/@sentry/browser/build/npm/esm/userfeedback.js
  function createUserFeedbackEnvelope(feedback, {
    metadata,
    tunnel,
    dsn
  }) {
    const headers = {
      event_id: feedback.event_id,
      sent_at: (/* @__PURE__ */ new Date()).toISOString(),
      ...metadata && metadata.sdk && {
        sdk: {
          name: metadata.sdk.name,
          version: metadata.sdk.version
        }
      },
      ...!!tunnel && !!dsn && { dsn: dsnToString(dsn) }
    };
    const item = createUserFeedbackEnvelopeItem(feedback);
    return createEnvelope(headers, [item]);
  }
  function createUserFeedbackEnvelopeItem(feedback) {
    const feedbackHeaders = {
      type: "user_report"
    };
    return [feedbackHeaders, feedback];
  }

  // node_modules/@sentry/browser/build/npm/esm/client.js
  var BrowserClient = class extends BaseClient {
    /**
     * Creates a new Browser SDK instance.
     *
     * @param options Configuration options for this SDK.
     */
    constructor(options) {
      const opts = {
        // We default this to true, as it is the safer scenario
        parentSpanIsAlwaysRootSpan: true,
        ...options
      };
      const sdkSource = WINDOW4.SENTRY_SDK_SOURCE || getSDKSource();
      applySdkMetadata(opts, "browser", ["browser"], sdkSource);
      super(opts);
      if (opts.sendClientReports && WINDOW4.document) {
        WINDOW4.document.addEventListener("visibilitychange", () => {
          if (WINDOW4.document.visibilityState === "hidden") {
            this._flushOutcomes();
          }
        });
      }
    }
    /**
     * @inheritDoc
     */
    eventFromException(exception, hint) {
      return eventFromException(this._options.stackParser, exception, hint, this._options.attachStacktrace);
    }
    /**
     * @inheritDoc
     */
    eventFromMessage(message, level = "info", hint) {
      return eventFromMessage(this._options.stackParser, message, level, hint, this._options.attachStacktrace);
    }
    /**
     * Sends user feedback to Sentry.
     *
     * @deprecated Use `captureFeedback` instead.
     */
    captureUserFeedback(feedback) {
      if (!this._isEnabled()) {
        DEBUG_BUILD3 && logger.warn("SDK not enabled, will not capture user feedback.");
        return;
      }
      const envelope = createUserFeedbackEnvelope(feedback, {
        metadata: this.getSdkMetadata(),
        dsn: this.getDsn(),
        tunnel: this.getOptions().tunnel
      });
      this.sendEnvelope(envelope);
    }
    /**
     * @inheritDoc
     */
    _prepareEvent(event, hint, scope) {
      event.platform = event.platform || "javascript";
      return super._prepareEvent(event, hint, scope);
    }
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/debug-build.js
  var DEBUG_BUILD4 = typeof __SENTRY_DEBUG__ === "undefined" || __SENTRY_DEBUG__;

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/lib/bindReporter.js
  var getRating = (value, thresholds) => {
    if (value > thresholds[1]) {
      return "poor";
    }
    if (value > thresholds[0]) {
      return "needs-improvement";
    }
    return "good";
  };
  var bindReporter = (callback, metric, thresholds, reportAllChanges) => {
    let prevValue;
    let delta;
    return (forceReport) => {
      if (metric.value >= 0) {
        if (forceReport || reportAllChanges) {
          delta = metric.value - (prevValue || 0);
          if (delta || prevValue === void 0) {
            prevValue = metric.value;
            metric.delta = delta;
            metric.rating = getRating(metric.value, thresholds);
            callback(metric);
          }
        }
      }
    };
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/types.js
  var WINDOW5 = GLOBAL_OBJ;

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/lib/generateUniqueID.js
  var generateUniqueID = () => {
    return `v3-${Date.now()}-${Math.floor(Math.random() * (9e12 - 1)) + 1e12}`;
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/lib/getNavigationEntry.js
  var getNavigationEntry = () => {
    return WINDOW5.performance && performance.getEntriesByType && performance.getEntriesByType("navigation")[0];
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/lib/getActivationStart.js
  var getActivationStart = () => {
    const navEntry = getNavigationEntry();
    return navEntry && navEntry.activationStart || 0;
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/lib/initMetric.js
  var initMetric = (name, value) => {
    const navEntry = getNavigationEntry();
    let navigationType = "navigate";
    if (navEntry) {
      if (WINDOW5.document && WINDOW5.document.prerendering || getActivationStart() > 0) {
        navigationType = "prerender";
      } else if (WINDOW5.document && WINDOW5.document.wasDiscarded) {
        navigationType = "restore";
      } else if (navEntry.type) {
        navigationType = navEntry.type.replace(/_/g, "-");
      }
    }
    const entries = [];
    return {
      name,
      value: typeof value === "undefined" ? -1 : value,
      rating: "good",
      // If needed, will be updated when reported. `const` to keep the type from widening to `string`.
      delta: 0,
      entries,
      id: generateUniqueID(),
      navigationType
    };
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/lib/observe.js
  var observe = (type, callback, opts) => {
    try {
      if (PerformanceObserver.supportedEntryTypes.includes(type)) {
        const po2 = new PerformanceObserver((list) => {
          Promise.resolve().then(() => {
            callback(list.getEntries());
          });
        });
        po2.observe(
          Object.assign(
            {
              type,
              buffered: true
            },
            opts || {}
          )
        );
        return po2;
      }
    } catch (e2) {
    }
    return;
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/lib/onHidden.js
  var onHidden = (cb) => {
    const onHiddenOrPageHide = (event) => {
      if (event.type === "pagehide" || WINDOW5.document && WINDOW5.document.visibilityState === "hidden") {
        cb(event);
      }
    };
    if (WINDOW5.document) {
      addEventListener("visibilitychange", onHiddenOrPageHide, true);
      addEventListener("pagehide", onHiddenOrPageHide, true);
    }
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/lib/runOnce.js
  var runOnce = (cb) => {
    let called = false;
    return (arg) => {
      if (!called) {
        cb(arg);
        called = true;
      }
    };
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/lib/getVisibilityWatcher.js
  var firstHiddenTime = -1;
  var initHiddenTime = () => {
    firstHiddenTime = WINDOW5.document.visibilityState === "hidden" && !WINDOW5.document.prerendering ? 0 : Infinity;
  };
  var onVisibilityUpdate = (event) => {
    if (WINDOW5.document.visibilityState === "hidden" && firstHiddenTime > -1) {
      firstHiddenTime = event.type === "visibilitychange" ? event.timeStamp : 0;
      removeEventListener("visibilitychange", onVisibilityUpdate, true);
      removeEventListener("prerenderingchange", onVisibilityUpdate, true);
    }
  };
  var addChangeListeners = () => {
    addEventListener("visibilitychange", onVisibilityUpdate, true);
    addEventListener("prerenderingchange", onVisibilityUpdate, true);
  };
  var getVisibilityWatcher = () => {
    if (WINDOW5.document && firstHiddenTime < 0) {
      initHiddenTime();
      addChangeListeners();
    }
    return {
      get firstHiddenTime() {
        return firstHiddenTime;
      }
    };
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/lib/whenActivated.js
  var whenActivated = (callback) => {
    if (WINDOW5.document && WINDOW5.document.prerendering) {
      addEventListener("prerenderingchange", () => callback(), true);
    } else {
      callback();
    }
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/onFCP.js
  var FCPThresholds = [1800, 3e3];
  var onFCP = (onReport, opts = {}) => {
    whenActivated(() => {
      const visibilityWatcher = getVisibilityWatcher();
      const metric = initMetric("FCP");
      let report;
      const handleEntries = (entries) => {
        entries.forEach((entry) => {
          if (entry.name === "first-contentful-paint") {
            po2.disconnect();
            if (entry.startTime < visibilityWatcher.firstHiddenTime) {
              metric.value = Math.max(entry.startTime - getActivationStart(), 0);
              metric.entries.push(entry);
              report(true);
            }
          }
        });
      };
      const po2 = observe("paint", handleEntries);
      if (po2) {
        report = bindReporter(onReport, metric, FCPThresholds, opts.reportAllChanges);
      }
    });
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/getCLS.js
  var CLSThresholds = [0.1, 0.25];
  var onCLS = (onReport, opts = {}) => {
    onFCP(
      runOnce(() => {
        const metric = initMetric("CLS", 0);
        let report;
        let sessionValue = 0;
        let sessionEntries = [];
        const handleEntries = (entries) => {
          entries.forEach((entry) => {
            if (!entry.hadRecentInput) {
              const firstSessionEntry = sessionEntries[0];
              const lastSessionEntry = sessionEntries[sessionEntries.length - 1];
              if (sessionValue && firstSessionEntry && lastSessionEntry && entry.startTime - lastSessionEntry.startTime < 1e3 && entry.startTime - firstSessionEntry.startTime < 5e3) {
                sessionValue += entry.value;
                sessionEntries.push(entry);
              } else {
                sessionValue = entry.value;
                sessionEntries = [entry];
              }
            }
          });
          if (sessionValue > metric.value) {
            metric.value = sessionValue;
            metric.entries = sessionEntries;
            report();
          }
        };
        const po2 = observe("layout-shift", handleEntries);
        if (po2) {
          report = bindReporter(onReport, metric, CLSThresholds, opts.reportAllChanges);
          onHidden(() => {
            handleEntries(po2.takeRecords());
            report(true);
          });
          setTimeout(report, 0);
        }
      })
    );
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/getFID.js
  var FIDThresholds = [100, 300];
  var onFID = (onReport, opts = {}) => {
    whenActivated(() => {
      const visibilityWatcher = getVisibilityWatcher();
      const metric = initMetric("FID");
      let report;
      const handleEntry = (entry) => {
        if (entry.startTime < visibilityWatcher.firstHiddenTime) {
          metric.value = entry.processingStart - entry.startTime;
          metric.entries.push(entry);
          report(true);
        }
      };
      const handleEntries = (entries) => {
        entries.forEach(handleEntry);
      };
      const po2 = observe("first-input", handleEntries);
      report = bindReporter(onReport, metric, FIDThresholds, opts.reportAllChanges);
      if (po2) {
        onHidden(
          runOnce(() => {
            handleEntries(po2.takeRecords());
            po2.disconnect();
          })
        );
      }
    });
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/lib/polyfills/interactionCountPolyfill.js
  var interactionCountEstimate = 0;
  var minKnownInteractionId = Infinity;
  var maxKnownInteractionId = 0;
  var updateEstimate = (entries) => {
    entries.forEach((e2) => {
      if (e2.interactionId) {
        minKnownInteractionId = Math.min(minKnownInteractionId, e2.interactionId);
        maxKnownInteractionId = Math.max(maxKnownInteractionId, e2.interactionId);
        interactionCountEstimate = maxKnownInteractionId ? (maxKnownInteractionId - minKnownInteractionId) / 7 + 1 : 0;
      }
    });
  };
  var po;
  var getInteractionCount = () => {
    return po ? interactionCountEstimate : performance.interactionCount || 0;
  };
  var initInteractionCountPolyfill = () => {
    if ("interactionCount" in performance || po) return;
    po = observe("event", updateEstimate, {
      type: "event",
      buffered: true,
      durationThreshold: 0
    });
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/getINP.js
  var INPThresholds = [200, 500];
  var prevInteractionCount = 0;
  var getInteractionCountForNavigation = () => {
    return getInteractionCount() - prevInteractionCount;
  };
  var MAX_INTERACTIONS_TO_CONSIDER = 10;
  var longestInteractionList = [];
  var longestInteractionMap = {};
  var processEntry = (entry) => {
    const minLongestInteraction = longestInteractionList[longestInteractionList.length - 1];
    const existingInteraction = longestInteractionMap[entry.interactionId];
    if (existingInteraction || longestInteractionList.length < MAX_INTERACTIONS_TO_CONSIDER || minLongestInteraction && entry.duration > minLongestInteraction.latency) {
      if (existingInteraction) {
        existingInteraction.entries.push(entry);
        existingInteraction.latency = Math.max(existingInteraction.latency, entry.duration);
      } else {
        const interaction = {
          // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
          id: entry.interactionId,
          latency: entry.duration,
          entries: [entry]
        };
        longestInteractionMap[interaction.id] = interaction;
        longestInteractionList.push(interaction);
      }
      longestInteractionList.sort((a, b) => b.latency - a.latency);
      longestInteractionList.splice(MAX_INTERACTIONS_TO_CONSIDER).forEach((i) => {
        delete longestInteractionMap[i.id];
      });
    }
  };
  var estimateP98LongestInteraction = () => {
    const candidateInteractionIndex = Math.min(
      longestInteractionList.length - 1,
      Math.floor(getInteractionCountForNavigation() / 50)
    );
    return longestInteractionList[candidateInteractionIndex];
  };
  var onINP = (onReport, opts = {}) => {
    whenActivated(() => {
      initInteractionCountPolyfill();
      const metric = initMetric("INP");
      let report;
      const handleEntries = (entries) => {
        entries.forEach((entry) => {
          if (entry.interactionId) {
            processEntry(entry);
          }
          if (entry.entryType === "first-input") {
            const noMatchingEntry = !longestInteractionList.some((interaction) => {
              return interaction.entries.some((prevEntry) => {
                return entry.duration === prevEntry.duration && entry.startTime === prevEntry.startTime;
              });
            });
            if (noMatchingEntry) {
              processEntry(entry);
            }
          }
        });
        const inp = estimateP98LongestInteraction();
        if (inp && inp.latency !== metric.value) {
          metric.value = inp.latency;
          metric.entries = inp.entries;
          report();
        }
      };
      const po2 = observe("event", handleEntries, {
        // Event Timing entries have their durations rounded to the nearest 8ms,
        // so a duration of 40ms would be any event that spans 2.5 or more frames
        // at 60Hz. This threshold is chosen to strike a balance between usefulness
        // and performance. Running this callback for any interaction that spans
        // just one or two frames is likely not worth the insight that could be
        // gained.
        durationThreshold: opts.durationThreshold != null ? opts.durationThreshold : 40
      });
      report = bindReporter(onReport, metric, INPThresholds, opts.reportAllChanges);
      if (po2) {
        if ("PerformanceEventTiming" in WINDOW5 && "interactionId" in PerformanceEventTiming.prototype) {
          po2.observe({ type: "first-input", buffered: true });
        }
        onHidden(() => {
          handleEntries(po2.takeRecords());
          if (metric.value < 0 && getInteractionCountForNavigation() > 0) {
            metric.value = 0;
            metric.entries = [];
          }
          report(true);
        });
      }
    });
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/getLCP.js
  var LCPThresholds = [2500, 4e3];
  var reportedMetricIDs = {};
  var onLCP = (onReport, opts = {}) => {
    whenActivated(() => {
      const visibilityWatcher = getVisibilityWatcher();
      const metric = initMetric("LCP");
      let report;
      const handleEntries = (entries) => {
        const lastEntry = entries[entries.length - 1];
        if (lastEntry) {
          if (lastEntry.startTime < visibilityWatcher.firstHiddenTime) {
            metric.value = Math.max(lastEntry.startTime - getActivationStart(), 0);
            metric.entries = [lastEntry];
            report();
          }
        }
      };
      const po2 = observe("largest-contentful-paint", handleEntries);
      if (po2) {
        report = bindReporter(onReport, metric, LCPThresholds, opts.reportAllChanges);
        const stopListening = runOnce(() => {
          if (!reportedMetricIDs[metric.id]) {
            handleEntries(po2.takeRecords());
            po2.disconnect();
            reportedMetricIDs[metric.id] = true;
            report(true);
          }
        });
        ["keydown", "click"].forEach((type) => {
          if (WINDOW5.document) {
            addEventListener(type, () => setTimeout(stopListening, 0), true);
          }
        });
        onHidden(stopListening);
      }
    });
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/web-vitals/onTTFB.js
  var TTFBThresholds = [800, 1800];
  var whenReady = (callback) => {
    if (WINDOW5.document && WINDOW5.document.prerendering) {
      whenActivated(() => whenReady(callback));
    } else if (WINDOW5.document && WINDOW5.document.readyState !== "complete") {
      addEventListener("load", () => whenReady(callback), true);
    } else {
      setTimeout(callback, 0);
    }
  };
  var onTTFB = (onReport, opts = {}) => {
    const metric = initMetric("TTFB");
    const report = bindReporter(onReport, metric, TTFBThresholds, opts.reportAllChanges);
    whenReady(() => {
      const navEntry = getNavigationEntry();
      if (navEntry) {
        const responseStart = navEntry.responseStart;
        if (responseStart <= 0 || responseStart > performance.now()) return;
        metric.value = Math.max(responseStart - getActivationStart(), 0);
        metric.entries = [navEntry];
        report(true);
      }
    });
  };

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/instrument.js
  var handlers2 = {};
  var instrumented2 = {};
  var _previousCls;
  var _previousFid;
  var _previousLcp;
  var _previousTtfb;
  var _previousInp;
  function addClsInstrumentationHandler(callback, stopOnCallback = false) {
    return addMetricObserver("cls", callback, instrumentCls, _previousCls, stopOnCallback);
  }
  function addLcpInstrumentationHandler(callback, stopOnCallback = false) {
    return addMetricObserver("lcp", callback, instrumentLcp, _previousLcp, stopOnCallback);
  }
  function addFidInstrumentationHandler(callback) {
    return addMetricObserver("fid", callback, instrumentFid, _previousFid);
  }
  function addTtfbInstrumentationHandler(callback) {
    return addMetricObserver("ttfb", callback, instrumentTtfb, _previousTtfb);
  }
  function addInpInstrumentationHandler(callback) {
    return addMetricObserver("inp", callback, instrumentInp, _previousInp);
  }
  function addPerformanceInstrumentationHandler(type, callback) {
    addHandler2(type, callback);
    if (!instrumented2[type]) {
      instrumentPerformanceObserver(type);
      instrumented2[type] = true;
    }
    return getCleanupCallback(type, callback);
  }
  function triggerHandlers2(type, data) {
    const typeHandlers = handlers2[type];
    if (!typeHandlers || !typeHandlers.length) {
      return;
    }
    for (const handler of typeHandlers) {
      try {
        handler(data);
      } catch (e2) {
        DEBUG_BUILD4 && logger.error(
          `Error while triggering instrumentation handler.
Type: ${type}
Name: ${getFunctionName(handler)}
Error:`,
          e2
        );
      }
    }
  }
  function instrumentCls() {
    return onCLS(
      (metric) => {
        triggerHandlers2("cls", {
          metric
        });
        _previousCls = metric;
      },
      // We want the callback to be called whenever the CLS value updates.
      // By default, the callback is only called when the tab goes to the background.
      { reportAllChanges: true }
    );
  }
  function instrumentFid() {
    return onFID((metric) => {
      triggerHandlers2("fid", {
        metric
      });
      _previousFid = metric;
    });
  }
  function instrumentLcp() {
    return onLCP(
      (metric) => {
        triggerHandlers2("lcp", {
          metric
        });
        _previousLcp = metric;
      },
      // We want the callback to be called whenever the LCP value updates.
      // By default, the callback is only called when the tab goes to the background.
      { reportAllChanges: true }
    );
  }
  function instrumentTtfb() {
    return onTTFB((metric) => {
      triggerHandlers2("ttfb", {
        metric
      });
      _previousTtfb = metric;
    });
  }
  function instrumentInp() {
    return onINP((metric) => {
      triggerHandlers2("inp", {
        metric
      });
      _previousInp = metric;
    });
  }
  function addMetricObserver(type, callback, instrumentFn, previousValue, stopOnCallback = false) {
    addHandler2(type, callback);
    let stopListening;
    if (!instrumented2[type]) {
      stopListening = instrumentFn();
      instrumented2[type] = true;
    }
    if (previousValue) {
      callback({ metric: previousValue });
    }
    return getCleanupCallback(type, callback, stopOnCallback ? stopListening : void 0);
  }
  function instrumentPerformanceObserver(type) {
    const options = {};
    if (type === "event") {
      options.durationThreshold = 0;
    }
    observe(
      type,
      (entries) => {
        triggerHandlers2(type, { entries });
      },
      options
    );
  }
  function addHandler2(type, handler) {
    handlers2[type] = handlers2[type] || [];
    handlers2[type].push(handler);
  }
  function getCleanupCallback(type, callback, stopListening) {
    return () => {
      if (stopListening) {
        stopListening();
      }
      const typeHandlers = handlers2[type];
      if (!typeHandlers) {
        return;
      }
      const index = typeHandlers.indexOf(callback);
      if (index !== -1) {
        typeHandlers.splice(index, 1);
      }
    };
  }
  function isPerformanceEventTiming(entry) {
    return "duration" in entry;
  }

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/utils.js
  function isMeasurementValue(value) {
    return typeof value === "number" && isFinite(value);
  }
  function startAndEndSpan(parentSpan, startTimeInSeconds, endTime, { ...ctx }) {
    const parentStartTime = spanToJSON(parentSpan).start_timestamp;
    if (parentStartTime && parentStartTime > startTimeInSeconds) {
      if (typeof parentSpan.updateStartTime === "function") {
        parentSpan.updateStartTime(startTimeInSeconds);
      }
    }
    return withActiveSpan(parentSpan, () => {
      const span = startInactiveSpan({
        startTime: startTimeInSeconds,
        ...ctx
      });
      if (span) {
        span.end(endTime);
      }
      return span;
    });
  }
  function startStandaloneWebVitalSpan(options) {
    const client = getClient();
    if (!client) {
      return;
    }
    const { name, transaction, attributes: passedAttributes, startTime } = options;
    const { release, environment } = client.getOptions();
    const replay = client.getIntegrationByName("Replay");
    const replayId = replay && replay.getReplayId();
    const scope = getCurrentScope();
    const user = scope.getUser();
    const userDisplay = user !== void 0 ? user.email || user.id || user.ip_address : void 0;
    let profileId;
    try {
      profileId = scope.getScopeData().contexts.profile.profile_id;
    } catch (e2) {
    }
    const attributes = {
      release,
      environment,
      user: userDisplay || void 0,
      profile_id: profileId || void 0,
      replay_id: replayId || void 0,
      transaction,
      // Web vital score calculation relies on the user agent to account for different
      // browsers setting different thresholds for what is considered a good/meh/bad value.
      // For example: Chrome vs. Chrome Mobile
      "user_agent.original": WINDOW5.navigator && WINDOW5.navigator.userAgent,
      ...passedAttributes
    };
    return startInactiveSpan({
      name,
      attributes,
      startTime,
      experimental: {
        standalone: true
      }
    });
  }
  function getBrowserPerformanceAPI() {
    return WINDOW5 && WINDOW5.addEventListener && WINDOW5.performance;
  }
  function msToSec(time) {
    return time / 1e3;
  }

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/cls.js
  function trackClsAsStandaloneSpan() {
    let standaloneCLsValue = 0;
    let standaloneClsEntry;
    let pageloadSpanId;
    if (!supportsLayoutShift()) {
      return;
    }
    let sentSpan = false;
    function _collectClsOnce() {
      if (sentSpan) {
        return;
      }
      sentSpan = true;
      if (pageloadSpanId) {
        sendStandaloneClsSpan(standaloneCLsValue, standaloneClsEntry, pageloadSpanId);
      }
      cleanupClsHandler();
    }
    const cleanupClsHandler = addClsInstrumentationHandler(({ metric }) => {
      const entry = metric.entries[metric.entries.length - 1];
      if (!entry) {
        return;
      }
      standaloneCLsValue = metric.value;
      standaloneClsEntry = entry;
    }, true);
    onHidden(() => {
      _collectClsOnce();
    });
    setTimeout(() => {
      const client = getClient();
      const unsubscribeStartNavigation = _optionalChain([client, "optionalAccess", (_) => _.on, "call", (_2) => _2("startNavigationSpan", () => {
        _collectClsOnce();
        unsubscribeStartNavigation && unsubscribeStartNavigation();
      })]);
      const activeSpan = getActiveSpan();
      const rootSpan = activeSpan && getRootSpan(activeSpan);
      const spanJSON = rootSpan && spanToJSON(rootSpan);
      if (spanJSON && spanJSON.op === "pageload") {
        pageloadSpanId = rootSpan.spanContext().spanId;
      }
    }, 0);
  }
  function sendStandaloneClsSpan(clsValue, entry, pageloadSpanId) {
    DEBUG_BUILD4 && logger.log(`Sending CLS span (${clsValue})`);
    const startTime = msToSec((browserPerformanceTimeOrigin || 0) + (_optionalChain([entry, "optionalAccess", (_3) => _3.startTime]) || 0));
    const routeName = getCurrentScope().getScopeData().transactionName;
    const name = entry ? htmlTreeAsString(_optionalChain([entry, "access", (_4) => _4.sources, "access", (_5) => _5[0], "optionalAccess", (_6) => _6.node])) : "Layout shift";
    const attributes = dropUndefinedKeys({
      [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.http.browser.cls",
      [SEMANTIC_ATTRIBUTE_SENTRY_OP]: "ui.webvital.cls",
      [SEMANTIC_ATTRIBUTE_EXCLUSIVE_TIME]: _optionalChain([entry, "optionalAccess", (_7) => _7.duration]) || 0,
      // attach the pageload span id to the CLS span so that we can link them in the UI
      "sentry.pageload.span_id": pageloadSpanId
    });
    const span = startStandaloneWebVitalSpan({
      name,
      transaction: routeName,
      attributes,
      startTime
    });
    _optionalChain([span, "optionalAccess", (_8) => _8.addEvent, "call", (_9) => _9("cls", {
      [SEMANTIC_ATTRIBUTE_SENTRY_MEASUREMENT_UNIT]: "",
      [SEMANTIC_ATTRIBUTE_SENTRY_MEASUREMENT_VALUE]: clsValue
    })]);
    _optionalChain([span, "optionalAccess", (_10) => _10.end, "call", (_11) => _11(startTime)]);
  }
  function supportsLayoutShift() {
    try {
      return _optionalChain([PerformanceObserver, "access", (_12) => _12.supportedEntryTypes, "optionalAccess", (_13) => _13.includes, "call", (_14) => _14("layout-shift")]);
    } catch (e2) {
      return false;
    }
  }

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/browserMetrics.js
  var MAX_INT_AS_BYTES = 2147483647;
  var _performanceCursor = 0;
  var _measurements = {};
  var _lcpEntry;
  var _clsEntry;
  function startTrackingWebVitals({ recordClsStandaloneSpans }) {
    const performance2 = getBrowserPerformanceAPI();
    if (performance2 && browserPerformanceTimeOrigin) {
      if (performance2.mark) {
        WINDOW5.performance.mark("sentry-tracing-init");
      }
      const fidCleanupCallback = _trackFID();
      const lcpCleanupCallback = _trackLCP();
      const ttfbCleanupCallback = _trackTtfb();
      const clsCleanupCallback = recordClsStandaloneSpans ? trackClsAsStandaloneSpan() : _trackCLS();
      return () => {
        fidCleanupCallback();
        lcpCleanupCallback();
        ttfbCleanupCallback();
        clsCleanupCallback && clsCleanupCallback();
      };
    }
    return () => void 0;
  }
  function startTrackingLongTasks() {
    addPerformanceInstrumentationHandler("longtask", ({ entries }) => {
      if (!getActiveSpan()) {
        return;
      }
      for (const entry of entries) {
        const startTime = msToSec(browserPerformanceTimeOrigin + entry.startTime);
        const duration = msToSec(entry.duration);
        const span = startInactiveSpan({
          name: "Main UI thread blocked",
          op: "ui.long-task",
          startTime,
          attributes: {
            [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.ui.browser.metrics"
          }
        });
        if (span) {
          span.end(startTime + duration);
        }
      }
    });
  }
  function startTrackingLongAnimationFrames() {
    const observer = new PerformanceObserver((list) => {
      if (!getActiveSpan()) {
        return;
      }
      for (const entry of list.getEntries()) {
        if (!entry.scripts[0]) {
          continue;
        }
        const startTime = msToSec(browserPerformanceTimeOrigin + entry.startTime);
        const duration = msToSec(entry.duration);
        const attributes = {
          [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.ui.browser.metrics"
        };
        const initialScript = entry.scripts[0];
        const { invoker, invokerType, sourceURL, sourceFunctionName, sourceCharPosition } = initialScript;
        attributes["browser.script.invoker"] = invoker;
        attributes["browser.script.invoker_type"] = invokerType;
        if (sourceURL) {
          attributes["code.filepath"] = sourceURL;
        }
        if (sourceFunctionName) {
          attributes["code.function"] = sourceFunctionName;
        }
        if (sourceCharPosition !== -1) {
          attributes["browser.script.source_char_position"] = sourceCharPosition;
        }
        const span = startInactiveSpan({
          name: "Main UI thread blocked",
          op: "ui.long-animation-frame",
          startTime,
          attributes
        });
        if (span) {
          span.end(startTime + duration);
        }
      }
    });
    observer.observe({ type: "long-animation-frame", buffered: true });
  }
  function startTrackingInteractions() {
    addPerformanceInstrumentationHandler("event", ({ entries }) => {
      if (!getActiveSpan()) {
        return;
      }
      for (const entry of entries) {
        if (entry.name === "click") {
          const startTime = msToSec(browserPerformanceTimeOrigin + entry.startTime);
          const duration = msToSec(entry.duration);
          const spanOptions = {
            name: htmlTreeAsString(entry.target),
            op: `ui.interaction.${entry.name}`,
            startTime,
            attributes: {
              [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.ui.browser.metrics"
            }
          };
          const componentName = getComponentName(entry.target);
          if (componentName) {
            spanOptions.attributes["ui.component_name"] = componentName;
          }
          const span = startInactiveSpan(spanOptions);
          if (span) {
            span.end(startTime + duration);
          }
        }
      }
    });
  }
  function _trackCLS() {
    return addClsInstrumentationHandler(({ metric }) => {
      const entry = metric.entries[metric.entries.length - 1];
      if (!entry) {
        return;
      }
      DEBUG_BUILD4 && logger.log(`[Measurements] Adding CLS ${metric.value}`);
      _measurements["cls"] = { value: metric.value, unit: "" };
      _clsEntry = entry;
    }, true);
  }
  function _trackLCP() {
    return addLcpInstrumentationHandler(({ metric }) => {
      const entry = metric.entries[metric.entries.length - 1];
      if (!entry) {
        return;
      }
      DEBUG_BUILD4 && logger.log("[Measurements] Adding LCP");
      _measurements["lcp"] = { value: metric.value, unit: "millisecond" };
      _lcpEntry = entry;
    }, true);
  }
  function _trackFID() {
    return addFidInstrumentationHandler(({ metric }) => {
      const entry = metric.entries[metric.entries.length - 1];
      if (!entry) {
        return;
      }
      const timeOrigin = msToSec(browserPerformanceTimeOrigin);
      const startTime = msToSec(entry.startTime);
      DEBUG_BUILD4 && logger.log("[Measurements] Adding FID");
      _measurements["fid"] = { value: metric.value, unit: "millisecond" };
      _measurements["mark.fid"] = { value: timeOrigin + startTime, unit: "second" };
    });
  }
  function _trackTtfb() {
    return addTtfbInstrumentationHandler(({ metric }) => {
      const entry = metric.entries[metric.entries.length - 1];
      if (!entry) {
        return;
      }
      DEBUG_BUILD4 && logger.log("[Measurements] Adding TTFB");
      _measurements["ttfb"] = { value: metric.value, unit: "millisecond" };
    });
  }
  function addPerformanceEntries(span, options) {
    const performance2 = getBrowserPerformanceAPI();
    if (!performance2 || !WINDOW5.performance.getEntries || !browserPerformanceTimeOrigin) {
      return;
    }
    DEBUG_BUILD4 && logger.log("[Tracing] Adding & adjusting spans using Performance API");
    const timeOrigin = msToSec(browserPerformanceTimeOrigin);
    const performanceEntries = performance2.getEntries();
    const { op, start_timestamp: transactionStartTime } = spanToJSON(span);
    performanceEntries.slice(_performanceCursor).forEach((entry) => {
      const startTime = msToSec(entry.startTime);
      const duration = msToSec(
        // Inexplicably, Chrome sometimes emits a negative duration. We need to work around this.
        // There is a SO post attempting to explain this, but it leaves one with open questions: https://stackoverflow.com/questions/23191918/peformance-getentries-and-negative-duration-display
        // The way we clamp the value is probably not accurate, since we have observed this happen for things that may take a while to load, like for example the replay worker.
        // TODO: Investigate why this happens and how to properly mitigate. For now, this is a workaround to prevent transactions being dropped due to negative duration spans.
        Math.max(0, entry.duration)
      );
      if (op === "navigation" && transactionStartTime && timeOrigin + startTime < transactionStartTime) {
        return;
      }
      switch (entry.entryType) {
        case "navigation": {
          _addNavigationSpans(span, entry, timeOrigin);
          break;
        }
        case "mark":
        case "paint":
        case "measure": {
          _addMeasureSpans(span, entry, startTime, duration, timeOrigin);
          const firstHidden = getVisibilityWatcher();
          const shouldRecord = entry.startTime < firstHidden.firstHiddenTime;
          if (entry.name === "first-paint" && shouldRecord) {
            DEBUG_BUILD4 && logger.log("[Measurements] Adding FP");
            _measurements["fp"] = { value: entry.startTime, unit: "millisecond" };
          }
          if (entry.name === "first-contentful-paint" && shouldRecord) {
            DEBUG_BUILD4 && logger.log("[Measurements] Adding FCP");
            _measurements["fcp"] = { value: entry.startTime, unit: "millisecond" };
          }
          break;
        }
        case "resource": {
          _addResourceSpans(span, entry, entry.name, startTime, duration, timeOrigin);
          break;
        }
      }
    });
    _performanceCursor = Math.max(performanceEntries.length - 1, 0);
    _trackNavigator(span);
    if (op === "pageload") {
      _addTtfbRequestTimeToMeasurements(_measurements);
      const fidMark = _measurements["mark.fid"];
      if (fidMark && _measurements["fid"]) {
        startAndEndSpan(span, fidMark.value, fidMark.value + msToSec(_measurements["fid"].value), {
          name: "first input delay",
          op: "ui.action",
          attributes: {
            [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.ui.browser.metrics"
          }
        });
        delete _measurements["mark.fid"];
      }
      if (!("fcp" in _measurements) || !options.recordClsOnPageloadSpan) {
        delete _measurements.cls;
      }
      Object.entries(_measurements).forEach(([measurementName, measurement]) => {
        setMeasurement(measurementName, measurement.value, measurement.unit);
      });
      span.setAttribute("performance.timeOrigin", timeOrigin);
      span.setAttribute("performance.activationStart", getActivationStart());
      _setWebVitalAttributes(span);
    }
    _lcpEntry = void 0;
    _clsEntry = void 0;
    _measurements = {};
  }
  function _addMeasureSpans(span, entry, startTime, duration, timeOrigin) {
    const navEntry = getNavigationEntry();
    const requestTime = msToSec(navEntry ? navEntry.requestStart : 0);
    const measureStartTimestamp = timeOrigin + Math.max(startTime, requestTime);
    const startTimeStamp = timeOrigin + startTime;
    const measureEndTimestamp = startTimeStamp + duration;
    const attributes = {
      [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.resource.browser.metrics"
    };
    if (measureStartTimestamp !== startTimeStamp) {
      attributes["sentry.browser.measure_happened_before_request"] = true;
      attributes["sentry.browser.measure_start_time"] = measureStartTimestamp;
    }
    startAndEndSpan(span, measureStartTimestamp, measureEndTimestamp, {
      name: entry.name,
      op: entry.entryType,
      attributes
    });
    return measureStartTimestamp;
  }
  function _addNavigationSpans(span, entry, timeOrigin) {
    ["unloadEvent", "redirect", "domContentLoadedEvent", "loadEvent", "connect"].forEach((event) => {
      _addPerformanceNavigationTiming(span, entry, event, timeOrigin);
    });
    _addPerformanceNavigationTiming(span, entry, "secureConnection", timeOrigin, "TLS/SSL", "connectEnd");
    _addPerformanceNavigationTiming(span, entry, "fetch", timeOrigin, "cache", "domainLookupStart");
    _addPerformanceNavigationTiming(span, entry, "domainLookup", timeOrigin, "DNS");
    _addRequest(span, entry, timeOrigin);
  }
  function _addPerformanceNavigationTiming(span, entry, event, timeOrigin, name, eventEnd) {
    const end = eventEnd ? entry[eventEnd] : entry[`${event}End`];
    const start2 = entry[`${event}Start`];
    if (!start2 || !end) {
      return;
    }
    startAndEndSpan(span, timeOrigin + msToSec(start2), timeOrigin + msToSec(end), {
      op: `browser.${name || event}`,
      name: entry.name,
      attributes: {
        [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.ui.browser.metrics"
      }
    });
  }
  function _addRequest(span, entry, timeOrigin) {
    const requestStartTimestamp = timeOrigin + msToSec(entry.requestStart);
    const responseEndTimestamp = timeOrigin + msToSec(entry.responseEnd);
    const responseStartTimestamp = timeOrigin + msToSec(entry.responseStart);
    if (entry.responseEnd) {
      startAndEndSpan(span, requestStartTimestamp, responseEndTimestamp, {
        op: "browser.request",
        name: entry.name,
        attributes: {
          [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.ui.browser.metrics"
        }
      });
      startAndEndSpan(span, responseStartTimestamp, responseEndTimestamp, {
        op: "browser.response",
        name: entry.name,
        attributes: {
          [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.ui.browser.metrics"
        }
      });
    }
  }
  function _addResourceSpans(span, entry, resourceUrl, startTime, duration, timeOrigin) {
    if (entry.initiatorType === "xmlhttprequest" || entry.initiatorType === "fetch") {
      return;
    }
    const parsedUrl = parseUrl(resourceUrl);
    const attributes = {
      [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.resource.browser.metrics"
    };
    setResourceEntrySizeData(attributes, entry, "transferSize", "http.response_transfer_size");
    setResourceEntrySizeData(attributes, entry, "encodedBodySize", "http.response_content_length");
    setResourceEntrySizeData(attributes, entry, "decodedBodySize", "http.decoded_response_content_length");
    if ("renderBlockingStatus" in entry) {
      attributes["resource.render_blocking_status"] = entry.renderBlockingStatus;
    }
    if (parsedUrl.protocol) {
      attributes["url.scheme"] = parsedUrl.protocol.split(":").pop();
    }
    if (parsedUrl.host) {
      attributes["server.address"] = parsedUrl.host;
    }
    attributes["url.same_origin"] = resourceUrl.includes(WINDOW5.location.origin);
    const startTimestamp = timeOrigin + startTime;
    const endTimestamp = startTimestamp + duration;
    startAndEndSpan(span, startTimestamp, endTimestamp, {
      name: resourceUrl.replace(WINDOW5.location.origin, ""),
      op: entry.initiatorType ? `resource.${entry.initiatorType}` : "resource.other",
      attributes
    });
  }
  function _trackNavigator(span) {
    const navigator = WINDOW5.navigator;
    if (!navigator) {
      return;
    }
    const connection = navigator.connection;
    if (connection) {
      if (connection.effectiveType) {
        span.setAttribute("effectiveConnectionType", connection.effectiveType);
      }
      if (connection.type) {
        span.setAttribute("connectionType", connection.type);
      }
      if (isMeasurementValue(connection.rtt)) {
        _measurements["connection.rtt"] = { value: connection.rtt, unit: "millisecond" };
      }
    }
    if (isMeasurementValue(navigator.deviceMemory)) {
      span.setAttribute("deviceMemory", `${navigator.deviceMemory} GB`);
    }
    if (isMeasurementValue(navigator.hardwareConcurrency)) {
      span.setAttribute("hardwareConcurrency", String(navigator.hardwareConcurrency));
    }
  }
  function _setWebVitalAttributes(span) {
    if (_lcpEntry) {
      DEBUG_BUILD4 && logger.log("[Measurements] Adding LCP Data");
      if (_lcpEntry.element) {
        span.setAttribute("lcp.element", htmlTreeAsString(_lcpEntry.element));
      }
      if (_lcpEntry.id) {
        span.setAttribute("lcp.id", _lcpEntry.id);
      }
      if (_lcpEntry.url) {
        span.setAttribute("lcp.url", _lcpEntry.url.trim().slice(0, 200));
      }
      span.setAttribute("lcp.size", _lcpEntry.size);
    }
    if (_clsEntry && _clsEntry.sources) {
      DEBUG_BUILD4 && logger.log("[Measurements] Adding CLS Data");
      _clsEntry.sources.forEach(
        (source, index) => span.setAttribute(`cls.source.${index + 1}`, htmlTreeAsString(source.node))
      );
    }
  }
  function setResourceEntrySizeData(attributes, entry, key, dataKey) {
    const entryVal = entry[key];
    if (entryVal != null && entryVal < MAX_INT_AS_BYTES) {
      attributes[dataKey] = entryVal;
    }
  }
  function _addTtfbRequestTimeToMeasurements(_measurements2) {
    const navEntry = getNavigationEntry();
    if (!navEntry) {
      return;
    }
    const { responseStart, requestStart } = navEntry;
    if (requestStart <= responseStart) {
      DEBUG_BUILD4 && logger.log("[Measurements] Adding TTFB Request Time");
      _measurements2["ttfb.requestTime"] = {
        value: responseStart - requestStart,
        unit: "millisecond"
      };
    }
  }

  // node_modules/@sentry-internal/browser-utils/build/esm/instrument/dom.js
  var DEBOUNCE_DURATION = 1e3;
  var debounceTimerID;
  var lastCapturedEventType;
  var lastCapturedEventTargetId;
  function addClickKeypressInstrumentationHandler(handler) {
    const type = "dom";
    addHandler(type, handler);
    maybeInstrument(type, instrumentDOM);
  }
  function instrumentDOM() {
    if (!WINDOW5.document) {
      return;
    }
    const triggerDOMHandler = triggerHandlers.bind(null, "dom");
    const globalDOMEventHandler = makeDOMEventHandler(triggerDOMHandler, true);
    WINDOW5.document.addEventListener("click", globalDOMEventHandler, false);
    WINDOW5.document.addEventListener("keypress", globalDOMEventHandler, false);
    ["EventTarget", "Node"].forEach((target) => {
      const proto = WINDOW5[target] && WINDOW5[target].prototype;
      if (!proto || !proto.hasOwnProperty || !proto.hasOwnProperty("addEventListener")) {
        return;
      }
      fill(proto, "addEventListener", function(originalAddEventListener) {
        return function(type, listener, options) {
          if (type === "click" || type == "keypress") {
            try {
              const el = this;
              const handlers4 = el.__sentry_instrumentation_handlers__ = el.__sentry_instrumentation_handlers__ || {};
              const handlerForType = handlers4[type] = handlers4[type] || { refCount: 0 };
              if (!handlerForType.handler) {
                const handler = makeDOMEventHandler(triggerDOMHandler);
                handlerForType.handler = handler;
                originalAddEventListener.call(this, type, handler, options);
              }
              handlerForType.refCount++;
            } catch (e2) {
            }
          }
          return originalAddEventListener.call(this, type, listener, options);
        };
      });
      fill(
        proto,
        "removeEventListener",
        function(originalRemoveEventListener) {
          return function(type, listener, options) {
            if (type === "click" || type == "keypress") {
              try {
                const el = this;
                const handlers4 = el.__sentry_instrumentation_handlers__ || {};
                const handlerForType = handlers4[type];
                if (handlerForType) {
                  handlerForType.refCount--;
                  if (handlerForType.refCount <= 0) {
                    originalRemoveEventListener.call(this, type, handlerForType.handler, options);
                    handlerForType.handler = void 0;
                    delete handlers4[type];
                  }
                  if (Object.keys(handlers4).length === 0) {
                    delete el.__sentry_instrumentation_handlers__;
                  }
                }
              } catch (e2) {
              }
            }
            return originalRemoveEventListener.call(this, type, listener, options);
          };
        }
      );
    });
  }
  function isSimilarToLastCapturedEvent(event) {
    if (event.type !== lastCapturedEventType) {
      return false;
    }
    try {
      if (!event.target || event.target._sentryId !== lastCapturedEventTargetId) {
        return false;
      }
    } catch (e2) {
    }
    return true;
  }
  function shouldSkipDOMEvent(eventType, target) {
    if (eventType !== "keypress") {
      return false;
    }
    if (!target || !target.tagName) {
      return true;
    }
    if (target.tagName === "INPUT" || target.tagName === "TEXTAREA" || target.isContentEditable) {
      return false;
    }
    return true;
  }
  function makeDOMEventHandler(handler, globalListener = false) {
    return (event) => {
      if (!event || event["_sentryCaptured"]) {
        return;
      }
      const target = getEventTarget(event);
      if (shouldSkipDOMEvent(event.type, target)) {
        return;
      }
      addNonEnumerableProperty(event, "_sentryCaptured", true);
      if (target && !target._sentryId) {
        addNonEnumerableProperty(target, "_sentryId", uuid4());
      }
      const name = event.type === "keypress" ? "input" : event.type;
      if (!isSimilarToLastCapturedEvent(event)) {
        const handlerData = { event, name, global: globalListener };
        handler(handlerData);
        lastCapturedEventType = event.type;
        lastCapturedEventTargetId = target ? target._sentryId : void 0;
      }
      clearTimeout(debounceTimerID);
      debounceTimerID = WINDOW5.setTimeout(() => {
        lastCapturedEventTargetId = void 0;
        lastCapturedEventType = void 0;
      }, DEBOUNCE_DURATION);
    };
  }
  function getEventTarget(event) {
    try {
      return event.target;
    } catch (e2) {
      return null;
    }
  }

  // node_modules/@sentry-internal/browser-utils/build/esm/instrument/history.js
  var lastHref;
  function addHistoryInstrumentationHandler(handler) {
    const type = "history";
    addHandler(type, handler);
    maybeInstrument(type, instrumentHistory);
  }
  function instrumentHistory() {
    if (!supportsHistory()) {
      return;
    }
    const oldOnPopState = WINDOW5.onpopstate;
    WINDOW5.onpopstate = function(...args) {
      const to = WINDOW5.location.href;
      const from = lastHref;
      lastHref = to;
      const handlerData = { from, to };
      triggerHandlers("history", handlerData);
      if (oldOnPopState) {
        try {
          return oldOnPopState.apply(this, args);
        } catch (_oO) {
        }
      }
    };
    function historyReplacementFunction(originalHistoryFunction) {
      return function(...args) {
        const url = args.length > 2 ? args[2] : void 0;
        if (url) {
          const from = lastHref;
          const to = String(url);
          lastHref = to;
          const handlerData = { from, to };
          triggerHandlers("history", handlerData);
        }
        return originalHistoryFunction.apply(this, args);
      };
    }
    fill(WINDOW5.history, "pushState", historyReplacementFunction);
    fill(WINDOW5.history, "replaceState", historyReplacementFunction);
  }

  // node_modules/@sentry-internal/browser-utils/build/esm/getNativeImplementation.js
  var cachedImplementations = {};
  function getNativeImplementation(name) {
    const cached = cachedImplementations[name];
    if (cached) {
      return cached;
    }
    let impl = WINDOW5[name];
    if (isNativeFunction(impl)) {
      return cachedImplementations[name] = impl.bind(WINDOW5);
    }
    const document2 = WINDOW5.document;
    if (document2 && typeof document2.createElement === "function") {
      try {
        const sandbox = document2.createElement("iframe");
        sandbox.hidden = true;
        document2.head.appendChild(sandbox);
        const contentWindow = sandbox.contentWindow;
        if (contentWindow && contentWindow[name]) {
          impl = contentWindow[name];
        }
        document2.head.removeChild(sandbox);
      } catch (e2) {
        DEBUG_BUILD4 && logger.warn(`Could not create sandbox iframe for ${name} check, bailing to window.${name}: `, e2);
      }
    }
    if (!impl) {
      return impl;
    }
    return cachedImplementations[name] = impl.bind(WINDOW5);
  }
  function clearCachedImplementation(name) {
    cachedImplementations[name] = void 0;
  }
  function setTimeout2(...rest) {
    return getNativeImplementation("setTimeout")(...rest);
  }

  // node_modules/@sentry-internal/browser-utils/build/esm/instrument/xhr.js
  var SENTRY_XHR_DATA_KEY = "__sentry_xhr_v3__";
  function addXhrInstrumentationHandler(handler) {
    const type = "xhr";
    addHandler(type, handler);
    maybeInstrument(type, instrumentXHR);
  }
  function instrumentXHR() {
    if (!WINDOW5.XMLHttpRequest) {
      return;
    }
    const xhrproto = XMLHttpRequest.prototype;
    xhrproto.open = new Proxy(xhrproto.open, {
      apply(originalOpen, xhrOpenThisArg, xhrOpenArgArray) {
        const startTimestamp = timestampInSeconds() * 1e3;
        const method = isString(xhrOpenArgArray[0]) ? xhrOpenArgArray[0].toUpperCase() : void 0;
        const url = parseUrl2(xhrOpenArgArray[1]);
        if (!method || !url) {
          return originalOpen.apply(xhrOpenThisArg, xhrOpenArgArray);
        }
        xhrOpenThisArg[SENTRY_XHR_DATA_KEY] = {
          method,
          url,
          request_headers: {}
        };
        if (method === "POST" && url.match(/sentry_key/)) {
          xhrOpenThisArg.__sentry_own_request__ = true;
        }
        const onreadystatechangeHandler = () => {
          const xhrInfo = xhrOpenThisArg[SENTRY_XHR_DATA_KEY];
          if (!xhrInfo) {
            return;
          }
          if (xhrOpenThisArg.readyState === 4) {
            try {
              xhrInfo.status_code = xhrOpenThisArg.status;
            } catch (e2) {
            }
            const handlerData = {
              endTimestamp: timestampInSeconds() * 1e3,
              startTimestamp,
              xhr: xhrOpenThisArg
            };
            triggerHandlers("xhr", handlerData);
          }
        };
        if ("onreadystatechange" in xhrOpenThisArg && typeof xhrOpenThisArg.onreadystatechange === "function") {
          xhrOpenThisArg.onreadystatechange = new Proxy(xhrOpenThisArg.onreadystatechange, {
            apply(originalOnreadystatechange, onreadystatechangeThisArg, onreadystatechangeArgArray) {
              onreadystatechangeHandler();
              return originalOnreadystatechange.apply(onreadystatechangeThisArg, onreadystatechangeArgArray);
            }
          });
        } else {
          xhrOpenThisArg.addEventListener("readystatechange", onreadystatechangeHandler);
        }
        xhrOpenThisArg.setRequestHeader = new Proxy(xhrOpenThisArg.setRequestHeader, {
          apply(originalSetRequestHeader, setRequestHeaderThisArg, setRequestHeaderArgArray) {
            const [header, value] = setRequestHeaderArgArray;
            const xhrInfo = setRequestHeaderThisArg[SENTRY_XHR_DATA_KEY];
            if (xhrInfo && isString(header) && isString(value)) {
              xhrInfo.request_headers[header.toLowerCase()] = value;
            }
            return originalSetRequestHeader.apply(setRequestHeaderThisArg, setRequestHeaderArgArray);
          }
        });
        return originalOpen.apply(xhrOpenThisArg, xhrOpenArgArray);
      }
    });
    xhrproto.send = new Proxy(xhrproto.send, {
      apply(originalSend, sendThisArg, sendArgArray) {
        const sentryXhrData = sendThisArg[SENTRY_XHR_DATA_KEY];
        if (!sentryXhrData) {
          return originalSend.apply(sendThisArg, sendArgArray);
        }
        if (sendArgArray[0] !== void 0) {
          sentryXhrData.body = sendArgArray[0];
        }
        const handlerData = {
          startTimestamp: timestampInSeconds() * 1e3,
          xhr: sendThisArg
        };
        triggerHandlers("xhr", handlerData);
        return originalSend.apply(sendThisArg, sendArgArray);
      }
    });
  }
  function parseUrl2(url) {
    if (isString(url)) {
      return url;
    }
    try {
      return url.toString();
    } catch (e2) {
    }
    return void 0;
  }

  // node_modules/@sentry-internal/browser-utils/build/esm/metrics/inp.js
  var LAST_INTERACTIONS = [];
  var INTERACTIONS_SPAN_MAP = /* @__PURE__ */ new Map();
  function startTrackingINP() {
    const performance2 = getBrowserPerformanceAPI();
    if (performance2 && browserPerformanceTimeOrigin) {
      const inpCallback = _trackINP();
      return () => {
        inpCallback();
      };
    }
    return () => void 0;
  }
  var INP_ENTRY_MAP = {
    click: "click",
    pointerdown: "click",
    pointerup: "click",
    mousedown: "click",
    mouseup: "click",
    touchstart: "click",
    touchend: "click",
    mouseover: "hover",
    mouseout: "hover",
    mouseenter: "hover",
    mouseleave: "hover",
    pointerover: "hover",
    pointerout: "hover",
    pointerenter: "hover",
    pointerleave: "hover",
    dragstart: "drag",
    dragend: "drag",
    drag: "drag",
    dragenter: "drag",
    dragleave: "drag",
    dragover: "drag",
    drop: "drag",
    keydown: "press",
    keyup: "press",
    keypress: "press",
    input: "press"
  };
  function _trackINP() {
    return addInpInstrumentationHandler(({ metric }) => {
      if (metric.value == void 0) {
        return;
      }
      const entry = metric.entries.find((entry2) => entry2.duration === metric.value && INP_ENTRY_MAP[entry2.name]);
      if (!entry) {
        return;
      }
      const { interactionId } = entry;
      const interactionType = INP_ENTRY_MAP[entry.name];
      const startTime = msToSec(browserPerformanceTimeOrigin + entry.startTime);
      const duration = msToSec(metric.value);
      const activeSpan = getActiveSpan();
      const rootSpan = activeSpan ? getRootSpan(activeSpan) : void 0;
      const cachedSpan = interactionId != null ? INTERACTIONS_SPAN_MAP.get(interactionId) : void 0;
      const spanToUse = cachedSpan || rootSpan;
      const routeName = spanToUse ? spanToJSON(spanToUse).description : getCurrentScope().getScopeData().transactionName;
      const name = htmlTreeAsString(entry.target);
      const attributes = dropUndefinedKeys({
        [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.http.browser.inp",
        [SEMANTIC_ATTRIBUTE_SENTRY_OP]: `ui.interaction.${interactionType}`,
        [SEMANTIC_ATTRIBUTE_EXCLUSIVE_TIME]: entry.duration
      });
      const span = startStandaloneWebVitalSpan({
        name,
        transaction: routeName,
        attributes,
        startTime
      });
      _optionalChain([span, "optionalAccess", (_) => _.addEvent, "call", (_2) => _2("inp", {
        [SEMANTIC_ATTRIBUTE_SENTRY_MEASUREMENT_UNIT]: "millisecond",
        [SEMANTIC_ATTRIBUTE_SENTRY_MEASUREMENT_VALUE]: metric.value
      })]);
      _optionalChain([span, "optionalAccess", (_3) => _3.end, "call", (_4) => _4(startTime + duration)]);
    });
  }
  function registerInpInteractionListener(_latestRoute) {
    const handleEntries = ({ entries }) => {
      const activeSpan = getActiveSpan();
      const activeRootSpan = activeSpan && getRootSpan(activeSpan);
      entries.forEach((entry) => {
        if (!isPerformanceEventTiming(entry) || !activeRootSpan) {
          return;
        }
        const interactionId = entry.interactionId;
        if (interactionId == null) {
          return;
        }
        if (INTERACTIONS_SPAN_MAP.has(interactionId)) {
          return;
        }
        if (LAST_INTERACTIONS.length > 10) {
          const last = LAST_INTERACTIONS.shift();
          INTERACTIONS_SPAN_MAP.delete(last);
        }
        LAST_INTERACTIONS.push(interactionId);
        INTERACTIONS_SPAN_MAP.set(interactionId, activeRootSpan);
      });
    };
    addPerformanceInstrumentationHandler("event", handleEntries);
    addPerformanceInstrumentationHandler("first-input", handleEntries);
  }

  // node_modules/@sentry/browser/build/npm/esm/transports/fetch.js
  function makeFetchTransport(options, nativeFetch = getNativeImplementation("fetch")) {
    let pendingBodySize = 0;
    let pendingCount = 0;
    function makeRequest(request) {
      const requestSize = request.body.length;
      pendingBodySize += requestSize;
      pendingCount++;
      const requestOptions = {
        body: request.body,
        method: "POST",
        referrerPolicy: "origin",
        headers: options.headers,
        // Outgoing requests are usually cancelled when navigating to a different page, causing a "TypeError: Failed to
        // fetch" error and sending a "network_error" client-outcome - in Chrome, the request status shows "(cancelled)".
        // The `keepalive` flag keeps outgoing requests alive, even when switching pages. We want this since we're
        // frequently sending events right before the user is switching pages (eg. whenfinishing navigation transactions).
        // Gotchas:
        // - `keepalive` isn't supported by Firefox
        // - As per spec (https://fetch.spec.whatwg.org/#http-network-or-cache-fetch):
        //   If the sum of contentLength and inflightKeepaliveBytes is greater than 64 kibibytes, then return a network error.
        //   We will therefore only activate the flag when we're below that limit.
        // There is also a limit of requests that can be open at the same time, so we also limit this to 15
        // See https://github.com/getsentry/sentry-javascript/pull/7553 for details
        keepalive: pendingBodySize <= 6e4 && pendingCount < 15,
        ...options.fetchOptions
      };
      if (!nativeFetch) {
        clearCachedImplementation("fetch");
        return rejectedSyncPromise("No fetch implementation available");
      }
      try {
        return nativeFetch(options.url, requestOptions).then((response) => {
          pendingBodySize -= requestSize;
          pendingCount--;
          return {
            statusCode: response.status,
            headers: {
              "x-sentry-rate-limits": response.headers.get("X-Sentry-Rate-Limits"),
              "retry-after": response.headers.get("Retry-After")
            }
          };
        });
      } catch (e2) {
        clearCachedImplementation("fetch");
        pendingBodySize -= requestSize;
        pendingCount--;
        return rejectedSyncPromise(e2);
      }
    }
    return createTransport(options, makeRequest);
  }

  // node_modules/@sentry/browser/build/npm/esm/stack-parsers.js
  var CHROME_PRIORITY = 30;
  var GECKO_PRIORITY = 50;
  function createFrame(filename, func, lineno, colno) {
    const frame = {
      filename,
      function: func === "<anonymous>" ? UNKNOWN_FUNCTION : func,
      in_app: true
      // All browser frames are considered in_app
    };
    if (lineno !== void 0) {
      frame.lineno = lineno;
    }
    if (colno !== void 0) {
      frame.colno = colno;
    }
    return frame;
  }
  var chromeRegexNoFnName = /^\s*at (\S+?)(?::(\d+))(?::(\d+))\s*$/i;
  var chromeRegex = /^\s*at (?:(.+?\)(?: \[.+\])?|.*?) ?\((?:address at )?)?(?:async )?((?:<anonymous>|[-a-z]+:|.*bundle|\/)?.*?)(?::(\d+))?(?::(\d+))?\)?\s*$/i;
  var chromeEvalRegex = /\((\S*)(?::(\d+))(?::(\d+))\)/;
  var chromeStackParserFn = (line) => {
    const noFnParts = chromeRegexNoFnName.exec(line);
    if (noFnParts) {
      const [, filename, line2, col] = noFnParts;
      return createFrame(filename, UNKNOWN_FUNCTION, +line2, +col);
    }
    const parts = chromeRegex.exec(line);
    if (parts) {
      const isEval = parts[2] && parts[2].indexOf("eval") === 0;
      if (isEval) {
        const subMatch = chromeEvalRegex.exec(parts[2]);
        if (subMatch) {
          parts[2] = subMatch[1];
          parts[3] = subMatch[2];
          parts[4] = subMatch[3];
        }
      }
      const [func, filename] = extractSafariExtensionDetails(parts[1] || UNKNOWN_FUNCTION, parts[2]);
      return createFrame(filename, func, parts[3] ? +parts[3] : void 0, parts[4] ? +parts[4] : void 0);
    }
    return;
  };
  var chromeStackLineParser = [CHROME_PRIORITY, chromeStackParserFn];
  var geckoREgex = /^\s*(.*?)(?:\((.*?)\))?(?:^|@)?((?:[-a-z]+)?:\/.*?|\[native code\]|[^@]*(?:bundle|\d+\.js)|\/[\w\-. /=]+)(?::(\d+))?(?::(\d+))?\s*$/i;
  var geckoEvalRegex = /(\S+) line (\d+)(?: > eval line \d+)* > eval/i;
  var gecko = (line) => {
    const parts = geckoREgex.exec(line);
    if (parts) {
      const isEval = parts[3] && parts[3].indexOf(" > eval") > -1;
      if (isEval) {
        const subMatch = geckoEvalRegex.exec(parts[3]);
        if (subMatch) {
          parts[1] = parts[1] || "eval";
          parts[3] = subMatch[1];
          parts[4] = subMatch[2];
          parts[5] = "";
        }
      }
      let filename = parts[3];
      let func = parts[1] || UNKNOWN_FUNCTION;
      [func, filename] = extractSafariExtensionDetails(func, filename);
      return createFrame(filename, func, parts[4] ? +parts[4] : void 0, parts[5] ? +parts[5] : void 0);
    }
    return;
  };
  var geckoStackLineParser = [GECKO_PRIORITY, gecko];
  var defaultStackLineParsers = [chromeStackLineParser, geckoStackLineParser];
  var defaultStackParser = createStackParser(...defaultStackLineParsers);
  var extractSafariExtensionDetails = (func, filename) => {
    const isSafariExtension = func.indexOf("safari-extension") !== -1;
    const isSafariWebExtension = func.indexOf("safari-web-extension") !== -1;
    return isSafariExtension || isSafariWebExtension ? [
      func.indexOf("@") !== -1 ? func.split("@")[0] : UNKNOWN_FUNCTION,
      isSafariExtension ? `safari-extension:${filename}` : `safari-web-extension:${filename}`
    ] : [func, filename];
  };

  // node_modules/@sentry/browser/build/npm/esm/integrations/breadcrumbs.js
  var MAX_ALLOWED_STRING_LENGTH = 1024;
  var INTEGRATION_NAME4 = "Breadcrumbs";
  var _breadcrumbsIntegration = (options = {}) => {
    const _options = {
      console: true,
      dom: true,
      fetch: true,
      history: true,
      sentry: true,
      xhr: true,
      ...options
    };
    return {
      name: INTEGRATION_NAME4,
      setup(client) {
        if (_options.console) {
          addConsoleInstrumentationHandler(_getConsoleBreadcrumbHandler(client));
        }
        if (_options.dom) {
          addClickKeypressInstrumentationHandler(_getDomBreadcrumbHandler(client, _options.dom));
        }
        if (_options.xhr) {
          addXhrInstrumentationHandler(_getXhrBreadcrumbHandler(client));
        }
        if (_options.fetch) {
          addFetchInstrumentationHandler(_getFetchBreadcrumbHandler(client));
        }
        if (_options.history) {
          addHistoryInstrumentationHandler(_getHistoryBreadcrumbHandler(client));
        }
        if (_options.sentry) {
          client.on("beforeSendEvent", _getSentryBreadcrumbHandler(client));
        }
      }
    };
  };
  var breadcrumbsIntegration = defineIntegration(_breadcrumbsIntegration);
  function _getSentryBreadcrumbHandler(client) {
    return function addSentryBreadcrumb(event) {
      if (getClient() !== client) {
        return;
      }
      addBreadcrumb(
        {
          category: `sentry.${event.type === "transaction" ? "transaction" : "event"}`,
          event_id: event.event_id,
          level: event.level,
          message: getEventDescription(event)
        },
        {
          event
        }
      );
    };
  }
  function _getDomBreadcrumbHandler(client, dom) {
    return function _innerDomBreadcrumb(handlerData) {
      if (getClient() !== client) {
        return;
      }
      let target;
      let componentName;
      let keyAttrs = typeof dom === "object" ? dom.serializeAttribute : void 0;
      let maxStringLength = typeof dom === "object" && typeof dom.maxStringLength === "number" ? dom.maxStringLength : void 0;
      if (maxStringLength && maxStringLength > MAX_ALLOWED_STRING_LENGTH) {
        DEBUG_BUILD3 && logger.warn(
          `\`dom.maxStringLength\` cannot exceed ${MAX_ALLOWED_STRING_LENGTH}, but a value of ${maxStringLength} was configured. Sentry will use ${MAX_ALLOWED_STRING_LENGTH} instead.`
        );
        maxStringLength = MAX_ALLOWED_STRING_LENGTH;
      }
      if (typeof keyAttrs === "string") {
        keyAttrs = [keyAttrs];
      }
      try {
        const event = handlerData.event;
        const element = _isEvent(event) ? event.target : event;
        target = htmlTreeAsString(element, { keyAttrs, maxStringLength });
        componentName = getComponentName(element);
      } catch (e2) {
        target = "<unknown>";
      }
      if (target.length === 0) {
        return;
      }
      const breadcrumb = {
        category: `ui.${handlerData.name}`,
        message: target
      };
      if (componentName) {
        breadcrumb.data = { "ui.component_name": componentName };
      }
      addBreadcrumb(breadcrumb, {
        event: handlerData.event,
        name: handlerData.name,
        global: handlerData.global
      });
    };
  }
  function _getConsoleBreadcrumbHandler(client) {
    return function _consoleBreadcrumb(handlerData) {
      if (getClient() !== client) {
        return;
      }
      const breadcrumb = {
        category: "console",
        data: {
          arguments: handlerData.args,
          logger: "console"
        },
        level: severityLevelFromString(handlerData.level),
        message: safeJoin(handlerData.args, " ")
      };
      if (handlerData.level === "assert") {
        if (handlerData.args[0] === false) {
          breadcrumb.message = `Assertion failed: ${safeJoin(handlerData.args.slice(1), " ") || "console.assert"}`;
          breadcrumb.data.arguments = handlerData.args.slice(1);
        } else {
          return;
        }
      }
      addBreadcrumb(breadcrumb, {
        input: handlerData.args,
        level: handlerData.level
      });
    };
  }
  function _getXhrBreadcrumbHandler(client) {
    return function _xhrBreadcrumb(handlerData) {
      if (getClient() !== client) {
        return;
      }
      const { startTimestamp, endTimestamp } = handlerData;
      const sentryXhrData = handlerData.xhr[SENTRY_XHR_DATA_KEY];
      if (!startTimestamp || !endTimestamp || !sentryXhrData) {
        return;
      }
      const { method, url, status_code, body } = sentryXhrData;
      const data = {
        method,
        url,
        status_code
      };
      const hint = {
        xhr: handlerData.xhr,
        input: body,
        startTimestamp,
        endTimestamp
      };
      const level = getBreadcrumbLogLevelFromHttpStatusCode(status_code);
      addBreadcrumb(
        {
          category: "xhr",
          data,
          type: "http",
          level
        },
        hint
      );
    };
  }
  function _getFetchBreadcrumbHandler(client) {
    return function _fetchBreadcrumb(handlerData) {
      if (getClient() !== client) {
        return;
      }
      const { startTimestamp, endTimestamp } = handlerData;
      if (!endTimestamp) {
        return;
      }
      if (handlerData.fetchData.url.match(/sentry_key/) && handlerData.fetchData.method === "POST") {
        return;
      }
      if (handlerData.error) {
        const data = handlerData.fetchData;
        const hint = {
          data: handlerData.error,
          input: handlerData.args,
          startTimestamp,
          endTimestamp
        };
        addBreadcrumb(
          {
            category: "fetch",
            data,
            level: "error",
            type: "http"
          },
          hint
        );
      } else {
        const response = handlerData.response;
        const data = {
          ...handlerData.fetchData,
          status_code: response && response.status
        };
        const hint = {
          input: handlerData.args,
          response,
          startTimestamp,
          endTimestamp
        };
        const level = getBreadcrumbLogLevelFromHttpStatusCode(data.status_code);
        addBreadcrumb(
          {
            category: "fetch",
            data,
            type: "http",
            level
          },
          hint
        );
      }
    };
  }
  function _getHistoryBreadcrumbHandler(client) {
    return function _historyBreadcrumb(handlerData) {
      if (getClient() !== client) {
        return;
      }
      let from = handlerData.from;
      let to = handlerData.to;
      const parsedLoc = parseUrl(WINDOW4.location.href);
      let parsedFrom = from ? parseUrl(from) : void 0;
      const parsedTo = parseUrl(to);
      if (!parsedFrom || !parsedFrom.path) {
        parsedFrom = parsedLoc;
      }
      if (parsedLoc.protocol === parsedTo.protocol && parsedLoc.host === parsedTo.host) {
        to = parsedTo.relative;
      }
      if (parsedLoc.protocol === parsedFrom.protocol && parsedLoc.host === parsedFrom.host) {
        from = parsedFrom.relative;
      }
      addBreadcrumb({
        category: "navigation",
        data: {
          from,
          to
        }
      });
    };
  }
  function _isEvent(event) {
    return !!event && !!event.target;
  }

  // node_modules/@sentry/browser/build/npm/esm/integrations/browserapierrors.js
  var DEFAULT_EVENT_TARGET = [
    "EventTarget",
    "Window",
    "Node",
    "ApplicationCache",
    "AudioTrackList",
    "BroadcastChannel",
    "ChannelMergerNode",
    "CryptoOperation",
    "EventSource",
    "FileReader",
    "HTMLUnknownElement",
    "IDBDatabase",
    "IDBRequest",
    "IDBTransaction",
    "KeyOperation",
    "MediaController",
    "MessagePort",
    "ModalWindow",
    "Notification",
    "SVGElementInstance",
    "Screen",
    "SharedWorker",
    "TextTrack",
    "TextTrackCue",
    "TextTrackList",
    "WebSocket",
    "WebSocketWorker",
    "Worker",
    "XMLHttpRequest",
    "XMLHttpRequestEventTarget",
    "XMLHttpRequestUpload"
  ];
  var INTEGRATION_NAME5 = "BrowserApiErrors";
  var _browserApiErrorsIntegration = (options = {}) => {
    const _options = {
      XMLHttpRequest: true,
      eventTarget: true,
      requestAnimationFrame: true,
      setInterval: true,
      setTimeout: true,
      ...options
    };
    return {
      name: INTEGRATION_NAME5,
      // TODO: This currently only works for the first client this is setup
      // We may want to adjust this to check for client etc.
      setupOnce() {
        if (_options.setTimeout) {
          fill(WINDOW4, "setTimeout", _wrapTimeFunction);
        }
        if (_options.setInterval) {
          fill(WINDOW4, "setInterval", _wrapTimeFunction);
        }
        if (_options.requestAnimationFrame) {
          fill(WINDOW4, "requestAnimationFrame", _wrapRAF);
        }
        if (_options.XMLHttpRequest && "XMLHttpRequest" in WINDOW4) {
          fill(XMLHttpRequest.prototype, "send", _wrapXHR);
        }
        const eventTargetOption = _options.eventTarget;
        if (eventTargetOption) {
          const eventTarget = Array.isArray(eventTargetOption) ? eventTargetOption : DEFAULT_EVENT_TARGET;
          eventTarget.forEach(_wrapEventTarget);
        }
      }
    };
  };
  var browserApiErrorsIntegration = defineIntegration(_browserApiErrorsIntegration);
  function _wrapTimeFunction(original) {
    return function(...args) {
      const originalCallback = args[0];
      args[0] = wrap(originalCallback, {
        mechanism: {
          data: { function: getFunctionName(original) },
          handled: false,
          type: "instrument"
        }
      });
      return original.apply(this, args);
    };
  }
  function _wrapRAF(original) {
    return function(callback) {
      return original.apply(this, [
        wrap(callback, {
          mechanism: {
            data: {
              function: "requestAnimationFrame",
              handler: getFunctionName(original)
            },
            handled: false,
            type: "instrument"
          }
        })
      ]);
    };
  }
  function _wrapXHR(originalSend) {
    return function(...args) {
      const xhr = this;
      const xmlHttpRequestProps = ["onload", "onerror", "onprogress", "onreadystatechange"];
      xmlHttpRequestProps.forEach((prop) => {
        if (prop in xhr && typeof xhr[prop] === "function") {
          fill(xhr, prop, function(original) {
            const wrapOptions = {
              mechanism: {
                data: {
                  function: prop,
                  handler: getFunctionName(original)
                },
                handled: false,
                type: "instrument"
              }
            };
            const originalFunction = getOriginalFunction(original);
            if (originalFunction) {
              wrapOptions.mechanism.data.handler = getFunctionName(originalFunction);
            }
            return wrap(original, wrapOptions);
          });
        }
      });
      return originalSend.apply(this, args);
    };
  }
  function _wrapEventTarget(target) {
    const globalObject = WINDOW4;
    const proto = globalObject[target] && globalObject[target].prototype;
    if (!proto || !proto.hasOwnProperty || !proto.hasOwnProperty("addEventListener")) {
      return;
    }
    fill(proto, "addEventListener", function(original) {
      return function(eventName, fn, options) {
        try {
          if (typeof fn.handleEvent === "function") {
            fn.handleEvent = wrap(fn.handleEvent, {
              mechanism: {
                data: {
                  function: "handleEvent",
                  handler: getFunctionName(fn),
                  target
                },
                handled: false,
                type: "instrument"
              }
            });
          }
        } catch (err) {
        }
        return original.apply(this, [
          eventName,
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          wrap(fn, {
            mechanism: {
              data: {
                function: "addEventListener",
                handler: getFunctionName(fn),
                target
              },
              handled: false,
              type: "instrument"
            }
          }),
          options
        ]);
      };
    });
    fill(
      proto,
      "removeEventListener",
      function(originalRemoveEventListener) {
        return function(eventName, fn, options) {
          const wrappedEventHandler = fn;
          try {
            const originalEventHandler = wrappedEventHandler && wrappedEventHandler.__sentry_wrapped__;
            if (originalEventHandler) {
              originalRemoveEventListener.call(this, eventName, originalEventHandler, options);
            }
          } catch (e2) {
          }
          return originalRemoveEventListener.call(this, eventName, wrappedEventHandler, options);
        };
      }
    );
  }

  // node_modules/@sentry/browser/build/npm/esm/integrations/globalhandlers.js
  var INTEGRATION_NAME6 = "GlobalHandlers";
  var _globalHandlersIntegration = (options = {}) => {
    const _options = {
      onerror: true,
      onunhandledrejection: true,
      ...options
    };
    return {
      name: INTEGRATION_NAME6,
      setupOnce() {
        Error.stackTraceLimit = 50;
      },
      setup(client) {
        if (_options.onerror) {
          _installGlobalOnErrorHandler(client);
          globalHandlerLog("onerror");
        }
        if (_options.onunhandledrejection) {
          _installGlobalOnUnhandledRejectionHandler(client);
          globalHandlerLog("onunhandledrejection");
        }
      }
    };
  };
  var globalHandlersIntegration = defineIntegration(_globalHandlersIntegration);
  function _installGlobalOnErrorHandler(client) {
    addGlobalErrorInstrumentationHandler((data) => {
      const { stackParser, attachStacktrace } = getOptions();
      if (getClient() !== client || shouldIgnoreOnError()) {
        return;
      }
      const { msg, url, line, column, error } = data;
      const event = _enhanceEventWithInitialFrame(
        eventFromUnknownInput(stackParser, error || msg, void 0, attachStacktrace, false),
        url,
        line,
        column
      );
      event.level = "error";
      captureEvent(event, {
        originalException: error,
        mechanism: {
          handled: false,
          type: "onerror"
        }
      });
    });
  }
  function _installGlobalOnUnhandledRejectionHandler(client) {
    addGlobalUnhandledRejectionInstrumentationHandler((e2) => {
      const { stackParser, attachStacktrace } = getOptions();
      if (getClient() !== client || shouldIgnoreOnError()) {
        return;
      }
      const error = _getUnhandledRejectionError(e2);
      const event = isPrimitive(error) ? _eventFromRejectionWithPrimitive(error) : eventFromUnknownInput(stackParser, error, void 0, attachStacktrace, true);
      event.level = "error";
      captureEvent(event, {
        originalException: error,
        mechanism: {
          handled: false,
          type: "onunhandledrejection"
        }
      });
    });
  }
  function _getUnhandledRejectionError(error) {
    if (isPrimitive(error)) {
      return error;
    }
    try {
      if ("reason" in error) {
        return error.reason;
      }
      if ("detail" in error && "reason" in error.detail) {
        return error.detail.reason;
      }
    } catch (e2) {
    }
    return error;
  }
  function _eventFromRejectionWithPrimitive(reason) {
    return {
      exception: {
        values: [
          {
            type: "UnhandledRejection",
            // String() is needed because the Primitive type includes symbols (which can't be automatically stringified)
            value: `Non-Error promise rejection captured with value: ${String(reason)}`
          }
        ]
      }
    };
  }
  function _enhanceEventWithInitialFrame(event, url, line, column) {
    const e2 = event.exception = event.exception || {};
    const ev = e2.values = e2.values || [];
    const ev0 = ev[0] = ev[0] || {};
    const ev0s = ev0.stacktrace = ev0.stacktrace || {};
    const ev0sf = ev0s.frames = ev0s.frames || [];
    const colno = isNaN(parseInt(column, 10)) ? void 0 : column;
    const lineno = isNaN(parseInt(line, 10)) ? void 0 : line;
    const filename = isString(url) && url.length > 0 ? url : getLocationHref();
    if (ev0sf.length === 0) {
      ev0sf.push({
        colno,
        filename,
        function: UNKNOWN_FUNCTION,
        in_app: true,
        lineno
      });
    }
    return event;
  }
  function globalHandlerLog(type) {
    DEBUG_BUILD3 && logger.log(`Global Handler attached: ${type}`);
  }
  function getOptions() {
    const client = getClient();
    const options = client && client.getOptions() || {
      stackParser: () => [],
      attachStacktrace: false
    };
    return options;
  }

  // node_modules/@sentry/browser/build/npm/esm/integrations/httpcontext.js
  var httpContextIntegration = defineIntegration(() => {
    return {
      name: "HttpContext",
      preprocessEvent(event) {
        if (!WINDOW4.navigator && !WINDOW4.location && !WINDOW4.document) {
          return;
        }
        const url = event.request && event.request.url || WINDOW4.location && WINDOW4.location.href;
        const { referrer } = WINDOW4.document || {};
        const { userAgent } = WINDOW4.navigator || {};
        const headers = {
          ...event.request && event.request.headers,
          ...referrer && { Referer: referrer },
          ...userAgent && { "User-Agent": userAgent }
        };
        const request = { ...event.request, ...url && { url }, headers };
        event.request = request;
      }
    };
  });

  // node_modules/@sentry/browser/build/npm/esm/integrations/linkederrors.js
  var DEFAULT_KEY = "cause";
  var DEFAULT_LIMIT = 5;
  var INTEGRATION_NAME7 = "LinkedErrors";
  var _linkedErrorsIntegration = (options = {}) => {
    const limit = options.limit || DEFAULT_LIMIT;
    const key = options.key || DEFAULT_KEY;
    return {
      name: INTEGRATION_NAME7,
      preprocessEvent(event, hint, client) {
        const options2 = client.getOptions();
        applyAggregateErrorsToEvent(
          // This differs from the LinkedErrors integration in core by using a different exceptionFromError function
          exceptionFromError,
          options2.stackParser,
          options2.maxValueLength,
          key,
          limit,
          event,
          hint
        );
      }
    };
  };
  var linkedErrorsIntegration = defineIntegration(_linkedErrorsIntegration);

  // node_modules/@sentry/browser/build/npm/esm/sdk.js
  function getDefaultIntegrations(_options) {
    return [
      inboundFiltersIntegration(),
      functionToStringIntegration(),
      browserApiErrorsIntegration(),
      breadcrumbsIntegration(),
      globalHandlersIntegration(),
      linkedErrorsIntegration(),
      dedupeIntegration(),
      httpContextIntegration()
    ];
  }
  function applyDefaultOptions(optionsArg = {}) {
    const defaultOptions = {
      defaultIntegrations: getDefaultIntegrations(),
      release: typeof __SENTRY_RELEASE__ === "string" ? __SENTRY_RELEASE__ : WINDOW4.SENTRY_RELEASE && WINDOW4.SENTRY_RELEASE.id ? WINDOW4.SENTRY_RELEASE.id : void 0,
      autoSessionTracking: true,
      sendClientReports: true
    };
    if (optionsArg.defaultIntegrations == null) {
      delete optionsArg.defaultIntegrations;
    }
    return { ...defaultOptions, ...optionsArg };
  }
  function shouldShowBrowserExtensionError() {
    const windowWithMaybeExtension = typeof WINDOW4.window !== "undefined" && WINDOW4;
    if (!windowWithMaybeExtension) {
      return false;
    }
    const extensionKey = windowWithMaybeExtension.chrome ? "chrome" : "browser";
    const extensionObject = windowWithMaybeExtension[extensionKey];
    const runtimeId = extensionObject && extensionObject.runtime && extensionObject.runtime.id;
    const href2 = WINDOW4.location && WINDOW4.location.href || "";
    const extensionProtocols = ["chrome-extension:", "moz-extension:", "ms-browser-extension:", "safari-web-extension:"];
    const isDedicatedExtensionPage = !!runtimeId && WINDOW4 === WINDOW4.top && extensionProtocols.some((protocol) => href2.startsWith(`${protocol}//`));
    const isNWjs = typeof windowWithMaybeExtension.nw !== "undefined";
    return !!runtimeId && !isDedicatedExtensionPage && !isNWjs;
  }
  function init(browserOptions = {}) {
    const options = applyDefaultOptions(browserOptions);
    if (shouldShowBrowserExtensionError()) {
      consoleSandbox(() => {
        console.error(
          "[Sentry] You cannot run Sentry this way in a browser extension, check: https://docs.sentry.io/platforms/javascript/best-practices/browser-extensions/"
        );
      });
      return;
    }
    if (DEBUG_BUILD3) {
      if (!supportsFetch()) {
        logger.warn(
          "No Fetch API detected. The Sentry SDK requires a Fetch API compatible environment to send events. Please add a Fetch API polyfill."
        );
      }
    }
    const clientOptions = {
      ...options,
      stackParser: stackParserFromStackParserOptions(options.stackParser || defaultStackParser),
      integrations: getIntegrationsToSetup(options),
      transport: options.transport || makeFetchTransport
    };
    const client = initAndBind(BrowserClient, clientOptions);
    if (options.autoSessionTracking) {
      startSessionTracking();
    }
    return client;
  }
  function startSessionTracking() {
    if (typeof WINDOW4.document === "undefined") {
      DEBUG_BUILD3 && logger.warn("Session tracking in non-browser environment with @sentry/browser is not supported.");
      return;
    }
    startSession({ ignoreDuration: true });
    captureSession();
    addHistoryInstrumentationHandler(({ from, to }) => {
      if (from !== void 0 && from !== to) {
        startSession({ ignoreDuration: true });
        captureSession();
      }
    });
  }

  // node_modules/@sentry-internal/replay/build/npm/esm/index.js
  var WINDOW6 = GLOBAL_OBJ;
  var REPLAY_SESSION_KEY = "sentryReplaySession";
  var REPLAY_EVENT_NAME = "replay_event";
  var UNABLE_TO_SEND_REPLAY = "Unable to send Replay";
  var SESSION_IDLE_PAUSE_DURATION = 3e5;
  var SESSION_IDLE_EXPIRE_DURATION = 9e5;
  var DEFAULT_FLUSH_MIN_DELAY = 5e3;
  var DEFAULT_FLUSH_MAX_DELAY = 5500;
  var BUFFER_CHECKOUT_TIME = 6e4;
  var RETRY_BASE_INTERVAL = 5e3;
  var RETRY_MAX_COUNT = 3;
  var NETWORK_BODY_MAX_SIZE = 15e4;
  var CONSOLE_ARG_MAX_SIZE = 5e3;
  var SLOW_CLICK_THRESHOLD = 3e3;
  var SLOW_CLICK_SCROLL_TIMEOUT = 300;
  var REPLAY_MAX_EVENT_BUFFER_SIZE = 2e7;
  var MIN_REPLAY_DURATION = 4999;
  var MIN_REPLAY_DURATION_LIMIT = 15e3;
  var MAX_REPLAY_DURATION = 36e5;
  function _nullishCoalesce$1(lhs, rhsFn) {
    if (lhs != null) {
      return lhs;
    } else {
      return rhsFn();
    }
  }
  function _optionalChain$5(ops) {
    let lastAccessLHS = void 0;
    let value = ops[0];
    let i = 1;
    while (i < ops.length) {
      const op = ops[i];
      const fn = ops[i + 1];
      i += 2;
      if ((op === "optionalAccess" || op === "optionalCall") && value == null) {
        return void 0;
      }
      if (op === "access" || op === "optionalAccess") {
        lastAccessLHS = value;
        value = fn(value);
      } else if (op === "call" || op === "optionalCall") {
        value = fn((...args) => value.call(lastAccessLHS, ...args));
        lastAccessLHS = void 0;
      }
    }
    return value;
  }
  var NodeType$1;
  (function(NodeType2) {
    NodeType2[NodeType2["Document"] = 0] = "Document";
    NodeType2[NodeType2["DocumentType"] = 1] = "DocumentType";
    NodeType2[NodeType2["Element"] = 2] = "Element";
    NodeType2[NodeType2["Text"] = 3] = "Text";
    NodeType2[NodeType2["CDATA"] = 4] = "CDATA";
    NodeType2[NodeType2["Comment"] = 5] = "Comment";
  })(NodeType$1 || (NodeType$1 = {}));
  function isElement$1(n) {
    return n.nodeType === n.ELEMENT_NODE;
  }
  function isShadowRoot(n) {
    const host = _optionalChain$5([n, "optionalAccess", (_) => _.host]);
    return Boolean(_optionalChain$5([host, "optionalAccess", (_2) => _2.shadowRoot]) === n);
  }
  function isNativeShadowDom(shadowRoot) {
    return Object.prototype.toString.call(shadowRoot) === "[object ShadowRoot]";
  }
  function fixBrowserCompatibilityIssuesInCSS(cssText) {
    if (cssText.includes(" background-clip: text;") && !cssText.includes(" -webkit-background-clip: text;")) {
      cssText = cssText.replace(/\sbackground-clip:\s*text;/g, " -webkit-background-clip: text; background-clip: text;");
    }
    return cssText;
  }
  function escapeImportStatement(rule) {
    const { cssText } = rule;
    if (cssText.split('"').length < 3)
      return cssText;
    const statement = ["@import", `url(${JSON.stringify(rule.href)})`];
    if (rule.layerName === "") {
      statement.push(`layer`);
    } else if (rule.layerName) {
      statement.push(`layer(${rule.layerName})`);
    }
    if (rule.supportsText) {
      statement.push(`supports(${rule.supportsText})`);
    }
    if (rule.media.length) {
      statement.push(rule.media.mediaText);
    }
    return statement.join(" ") + ";";
  }
  function stringifyStylesheet(s) {
    try {
      const rules = s.rules || s.cssRules;
      return rules ? fixBrowserCompatibilityIssuesInCSS(Array.from(rules, stringifyRule).join("")) : null;
    } catch (error) {
      return null;
    }
  }
  function stringifyRule(rule) {
    let importStringified;
    if (isCSSImportRule(rule)) {
      try {
        importStringified = stringifyStylesheet(rule.styleSheet) || escapeImportStatement(rule);
      } catch (error) {
      }
    } else if (isCSSStyleRule(rule) && rule.selectorText.includes(":")) {
      return fixSafariColons(rule.cssText);
    }
    return importStringified || rule.cssText;
  }
  function fixSafariColons(cssStringified) {
    const regex = /(\[(?:[\w-]+)[^\\])(:(?:[\w-]+)\])/gm;
    return cssStringified.replace(regex, "$1\\$2");
  }
  function isCSSImportRule(rule) {
    return "styleSheet" in rule;
  }
  function isCSSStyleRule(rule) {
    return "selectorText" in rule;
  }
  var Mirror = class {
    constructor() {
      this.idNodeMap = /* @__PURE__ */ new Map();
      this.nodeMetaMap = /* @__PURE__ */ new WeakMap();
    }
    getId(n) {
      if (!n)
        return -1;
      const id = _optionalChain$5([this, "access", (_3) => _3.getMeta, "call", (_4) => _4(n), "optionalAccess", (_5) => _5.id]);
      return _nullishCoalesce$1(id, () => -1);
    }
    getNode(id) {
      return this.idNodeMap.get(id) || null;
    }
    getIds() {
      return Array.from(this.idNodeMap.keys());
    }
    getMeta(n) {
      return this.nodeMetaMap.get(n) || null;
    }
    removeNodeFromMap(n) {
      const id = this.getId(n);
      this.idNodeMap.delete(id);
      if (n.childNodes) {
        n.childNodes.forEach((childNode) => this.removeNodeFromMap(childNode));
      }
    }
    has(id) {
      return this.idNodeMap.has(id);
    }
    hasNode(node) {
      return this.nodeMetaMap.has(node);
    }
    add(n, meta) {
      const id = meta.id;
      this.idNodeMap.set(id, n);
      this.nodeMetaMap.set(n, meta);
    }
    replace(id, n) {
      const oldNode = this.getNode(id);
      if (oldNode) {
        const meta = this.nodeMetaMap.get(oldNode);
        if (meta)
          this.nodeMetaMap.set(n, meta);
      }
      this.idNodeMap.set(id, n);
    }
    reset() {
      this.idNodeMap = /* @__PURE__ */ new Map();
      this.nodeMetaMap = /* @__PURE__ */ new WeakMap();
    }
  };
  function createMirror() {
    return new Mirror();
  }
  function shouldMaskInput({ maskInputOptions, tagName, type }) {
    if (tagName === "OPTION") {
      tagName = "SELECT";
    }
    return Boolean(maskInputOptions[tagName.toLowerCase()] || type && maskInputOptions[type] || type === "password" || tagName === "INPUT" && !type && maskInputOptions["text"]);
  }
  function maskInputValue({ isMasked, element, value, maskInputFn }) {
    let text = value || "";
    if (!isMasked) {
      return text;
    }
    if (maskInputFn) {
      text = maskInputFn(text, element);
    }
    return "*".repeat(text.length);
  }
  function toLowerCase(str) {
    return str.toLowerCase();
  }
  function toUpperCase(str) {
    return str.toUpperCase();
  }
  var ORIGINAL_ATTRIBUTE_NAME = "__rrweb_original__";
  function is2DCanvasBlank(canvas) {
    const ctx = canvas.getContext("2d");
    if (!ctx)
      return true;
    const chunkSize = 50;
    for (let x = 0; x < canvas.width; x += chunkSize) {
      for (let y = 0; y < canvas.height; y += chunkSize) {
        const getImageData = ctx.getImageData;
        const originalGetImageData = ORIGINAL_ATTRIBUTE_NAME in getImageData ? getImageData[ORIGINAL_ATTRIBUTE_NAME] : getImageData;
        const pixelBuffer = new Uint32Array(originalGetImageData.call(ctx, x, y, Math.min(chunkSize, canvas.width - x), Math.min(chunkSize, canvas.height - y)).data.buffer);
        if (pixelBuffer.some((pixel) => pixel !== 0))
          return false;
      }
    }
    return true;
  }
  function getInputType(element) {
    const type = element.type;
    return element.hasAttribute("data-rr-is-password") ? "password" : type ? toLowerCase(type) : null;
  }
  function getInputValue(el, tagName, type) {
    if (tagName === "INPUT" && (type === "radio" || type === "checkbox")) {
      return el.getAttribute("value") || "";
    }
    return el.value;
  }
  function extractFileExtension(path, baseURL) {
    let url;
    try {
      url = new URL(path, _nullishCoalesce$1(baseURL, () => window.location.href));
    } catch (err) {
      return null;
    }
    const regex = /\.([0-9a-z]+)(?:$)/i;
    const match = url.pathname.match(regex);
    return _nullishCoalesce$1(_optionalChain$5([match, "optionalAccess", (_6) => _6[1]]), () => null);
  }
  var cachedImplementations$1 = {};
  function getImplementation$1(name) {
    const cached = cachedImplementations$1[name];
    if (cached) {
      return cached;
    }
    const document2 = window.document;
    let impl = window[name];
    if (document2 && typeof document2.createElement === "function") {
      try {
        const sandbox = document2.createElement("iframe");
        sandbox.hidden = true;
        document2.head.appendChild(sandbox);
        const contentWindow = sandbox.contentWindow;
        if (contentWindow && contentWindow[name]) {
          impl = contentWindow[name];
        }
        document2.head.removeChild(sandbox);
      } catch (e2) {
      }
    }
    return cachedImplementations$1[name] = impl.bind(window);
  }
  function setTimeout$2(...rest) {
    return getImplementation$1("setTimeout")(...rest);
  }
  function clearTimeout$2(...rest) {
    return getImplementation$1("clearTimeout")(...rest);
  }
  var _id = 1;
  var tagNameRegex = new RegExp("[^a-z0-9-_:]");
  var IGNORED_NODE = -2;
  function genId() {
    return _id++;
  }
  function getValidTagName(element) {
    if (element instanceof HTMLFormElement) {
      return "form";
    }
    const processedTagName = toLowerCase(element.tagName);
    if (tagNameRegex.test(processedTagName)) {
      return "div";
    }
    return processedTagName;
  }
  function extractOrigin(url) {
    let origin = "";
    if (url.indexOf("//") > -1) {
      origin = url.split("/").slice(0, 3).join("/");
    } else {
      origin = url.split("/")[0];
    }
    origin = origin.split("?")[0];
    return origin;
  }
  var canvasService;
  var canvasCtx;
  var URL_IN_CSS_REF = /url\((?:(')([^']*)'|(")(.*?)"|([^)]*))\)/gm;
  var URL_PROTOCOL_MATCH = /^(?:[a-z+]+:)?\/\//i;
  var URL_WWW_MATCH = /^www\..*/i;
  var DATA_URI = /^(data:)([^,]*),(.*)/i;
  function absoluteToStylesheet(cssText, href2) {
    return (cssText || "").replace(URL_IN_CSS_REF, (origin, quote1, path1, quote2, path2, path3) => {
      const filePath = path1 || path2 || path3;
      const maybeQuote = quote1 || quote2 || "";
      if (!filePath) {
        return origin;
      }
      if (URL_PROTOCOL_MATCH.test(filePath) || URL_WWW_MATCH.test(filePath)) {
        return `url(${maybeQuote}${filePath}${maybeQuote})`;
      }
      if (DATA_URI.test(filePath)) {
        return `url(${maybeQuote}${filePath}${maybeQuote})`;
      }
      if (filePath[0] === "/") {
        return `url(${maybeQuote}${extractOrigin(href2) + filePath}${maybeQuote})`;
      }
      const stack = href2.split("/");
      const parts = filePath.split("/");
      stack.pop();
      for (const part of parts) {
        if (part === ".") {
          continue;
        } else if (part === "..") {
          stack.pop();
        } else {
          stack.push(part);
        }
      }
      return `url(${maybeQuote}${stack.join("/")}${maybeQuote})`;
    });
  }
  var SRCSET_NOT_SPACES = /^[^ \t\n\r\u000c]+/;
  var SRCSET_COMMAS_OR_SPACES = /^[, \t\n\r\u000c]+/;
  function getAbsoluteSrcsetString(doc, attributeValue) {
    if (attributeValue.trim() === "") {
      return attributeValue;
    }
    let pos = 0;
    function collectCharacters(regEx) {
      let chars;
      const match = regEx.exec(attributeValue.substring(pos));
      if (match) {
        chars = match[0];
        pos += chars.length;
        return chars;
      }
      return "";
    }
    const output = [];
    while (true) {
      collectCharacters(SRCSET_COMMAS_OR_SPACES);
      if (pos >= attributeValue.length) {
        break;
      }
      let url = collectCharacters(SRCSET_NOT_SPACES);
      if (url.slice(-1) === ",") {
        url = absoluteToDoc(doc, url.substring(0, url.length - 1));
        output.push(url);
      } else {
        let descriptorsStr = "";
        url = absoluteToDoc(doc, url);
        let inParens = false;
        while (true) {
          const c = attributeValue.charAt(pos);
          if (c === "") {
            output.push((url + descriptorsStr).trim());
            break;
          } else if (!inParens) {
            if (c === ",") {
              pos += 1;
              output.push((url + descriptorsStr).trim());
              break;
            } else if (c === "(") {
              inParens = true;
            }
          } else {
            if (c === ")") {
              inParens = false;
            }
          }
          descriptorsStr += c;
          pos += 1;
        }
      }
    }
    return output.join(", ");
  }
  var cachedDocument = /* @__PURE__ */ new WeakMap();
  function absoluteToDoc(doc, attributeValue) {
    if (!attributeValue || attributeValue.trim() === "") {
      return attributeValue;
    }
    return getHref(doc, attributeValue);
  }
  function isSVGElement(el) {
    return Boolean(el.tagName === "svg" || el.ownerSVGElement);
  }
  function getHref(doc, customHref) {
    let a = cachedDocument.get(doc);
    if (!a) {
      a = doc.createElement("a");
      cachedDocument.set(doc, a);
    }
    if (!customHref) {
      customHref = "";
    } else if (customHref.startsWith("blob:") || customHref.startsWith("data:")) {
      return customHref;
    }
    a.setAttribute("href", customHref);
    return a.href;
  }
  function transformAttribute(doc, tagName, name, value, element, maskAttributeFn) {
    if (!value) {
      return value;
    }
    if (name === "src" || name === "href" && !(tagName === "use" && value[0] === "#")) {
      return absoluteToDoc(doc, value);
    } else if (name === "xlink:href" && value[0] !== "#") {
      return absoluteToDoc(doc, value);
    } else if (name === "background" && (tagName === "table" || tagName === "td" || tagName === "th")) {
      return absoluteToDoc(doc, value);
    } else if (name === "srcset") {
      return getAbsoluteSrcsetString(doc, value);
    } else if (name === "style") {
      return absoluteToStylesheet(value, getHref(doc));
    } else if (tagName === "object" && name === "data") {
      return absoluteToDoc(doc, value);
    }
    if (typeof maskAttributeFn === "function") {
      return maskAttributeFn(name, value, element);
    }
    return value;
  }
  function ignoreAttribute(tagName, name, _value) {
    return (tagName === "video" || tagName === "audio") && name === "autoplay";
  }
  function _isBlockedElement(element, blockClass, blockSelector, unblockSelector) {
    try {
      if (unblockSelector && element.matches(unblockSelector)) {
        return false;
      }
      if (typeof blockClass === "string") {
        if (element.classList.contains(blockClass)) {
          return true;
        }
      } else {
        for (let eIndex = element.classList.length; eIndex--; ) {
          const className = element.classList[eIndex];
          if (blockClass.test(className)) {
            return true;
          }
        }
      }
      if (blockSelector) {
        return element.matches(blockSelector);
      }
    } catch (e2) {
    }
    return false;
  }
  function elementClassMatchesRegex(el, regex) {
    for (let eIndex = el.classList.length; eIndex--; ) {
      const className = el.classList[eIndex];
      if (regex.test(className)) {
        return true;
      }
    }
    return false;
  }
  function distanceToMatch(node, matchPredicate, limit = Infinity, distance = 0) {
    if (!node)
      return -1;
    if (node.nodeType !== node.ELEMENT_NODE)
      return -1;
    if (distance > limit)
      return -1;
    if (matchPredicate(node))
      return distance;
    return distanceToMatch(node.parentNode, matchPredicate, limit, distance + 1);
  }
  function createMatchPredicate(className, selector) {
    return (node) => {
      const el = node;
      if (el === null)
        return false;
      try {
        if (className) {
          if (typeof className === "string") {
            if (el.matches(`.${className}`))
              return true;
          } else if (elementClassMatchesRegex(el, className)) {
            return true;
          }
        }
        if (selector && el.matches(selector))
          return true;
        return false;
      } catch (e2) {
        return false;
      }
    };
  }
  function needMaskingText(node, maskTextClass, maskTextSelector, unmaskTextClass, unmaskTextSelector, maskAllText) {
    try {
      const el = node.nodeType === node.ELEMENT_NODE ? node : node.parentElement;
      if (el === null)
        return false;
      if (el.tagName === "INPUT") {
        const autocomplete = el.getAttribute("autocomplete");
        const disallowedAutocompleteValues = [
          "current-password",
          "new-password",
          "cc-number",
          "cc-exp",
          "cc-exp-month",
          "cc-exp-year",
          "cc-csc"
        ];
        if (disallowedAutocompleteValues.includes(autocomplete)) {
          return true;
        }
      }
      let maskDistance = -1;
      let unmaskDistance = -1;
      if (maskAllText) {
        unmaskDistance = distanceToMatch(el, createMatchPredicate(unmaskTextClass, unmaskTextSelector));
        if (unmaskDistance < 0) {
          return true;
        }
        maskDistance = distanceToMatch(el, createMatchPredicate(maskTextClass, maskTextSelector), unmaskDistance >= 0 ? unmaskDistance : Infinity);
      } else {
        maskDistance = distanceToMatch(el, createMatchPredicate(maskTextClass, maskTextSelector));
        if (maskDistance < 0) {
          return false;
        }
        unmaskDistance = distanceToMatch(el, createMatchPredicate(unmaskTextClass, unmaskTextSelector), maskDistance >= 0 ? maskDistance : Infinity);
      }
      return maskDistance >= 0 ? unmaskDistance >= 0 ? maskDistance <= unmaskDistance : true : unmaskDistance >= 0 ? false : !!maskAllText;
    } catch (e2) {
    }
    return !!maskAllText;
  }
  function onceIframeLoaded(iframeEl, listener, iframeLoadTimeout) {
    const win = iframeEl.contentWindow;
    if (!win) {
      return;
    }
    let fired = false;
    let readyState;
    try {
      readyState = win.document.readyState;
    } catch (error) {
      return;
    }
    if (readyState !== "complete") {
      const timer = setTimeout$2(() => {
        if (!fired) {
          listener();
          fired = true;
        }
      }, iframeLoadTimeout);
      iframeEl.addEventListener("load", () => {
        clearTimeout$2(timer);
        fired = true;
        listener();
      });
      return;
    }
    const blankUrl = "about:blank";
    if (win.location.href !== blankUrl || iframeEl.src === blankUrl || iframeEl.src === "") {
      setTimeout$2(listener, 0);
      return iframeEl.addEventListener("load", listener);
    }
    iframeEl.addEventListener("load", listener);
  }
  function onceStylesheetLoaded(link, listener, styleSheetLoadTimeout) {
    let fired = false;
    let styleSheetLoaded;
    try {
      styleSheetLoaded = link.sheet;
    } catch (error) {
      return;
    }
    if (styleSheetLoaded)
      return;
    const timer = setTimeout$2(() => {
      if (!fired) {
        listener();
        fired = true;
      }
    }, styleSheetLoadTimeout);
    link.addEventListener("load", () => {
      clearTimeout$2(timer);
      fired = true;
      listener();
    });
  }
  function serializeNode(n, options) {
    const { doc, mirror: mirror2, blockClass, blockSelector, unblockSelector, maskAllText, maskAttributeFn, maskTextClass, unmaskTextClass, maskTextSelector, unmaskTextSelector, inlineStylesheet, maskInputOptions = {}, maskTextFn, maskInputFn, dataURLOptions = {}, inlineImages, recordCanvas, keepIframeSrcFn, newlyAddedElement = false } = options;
    const rootId = getRootId(doc, mirror2);
    switch (n.nodeType) {
      case n.DOCUMENT_NODE:
        if (n.compatMode !== "CSS1Compat") {
          return {
            type: NodeType$1.Document,
            childNodes: [],
            compatMode: n.compatMode
          };
        } else {
          return {
            type: NodeType$1.Document,
            childNodes: []
          };
        }
      case n.DOCUMENT_TYPE_NODE:
        return {
          type: NodeType$1.DocumentType,
          name: n.name,
          publicId: n.publicId,
          systemId: n.systemId,
          rootId
        };
      case n.ELEMENT_NODE:
        return serializeElementNode(n, {
          doc,
          blockClass,
          blockSelector,
          unblockSelector,
          inlineStylesheet,
          maskAttributeFn,
          maskInputOptions,
          maskInputFn,
          dataURLOptions,
          inlineImages,
          recordCanvas,
          keepIframeSrcFn,
          newlyAddedElement,
          rootId,
          maskAllText,
          maskTextClass,
          unmaskTextClass,
          maskTextSelector,
          unmaskTextSelector
        });
      case n.TEXT_NODE:
        return serializeTextNode(n, {
          doc,
          maskAllText,
          maskTextClass,
          unmaskTextClass,
          maskTextSelector,
          unmaskTextSelector,
          maskTextFn,
          maskInputOptions,
          maskInputFn,
          rootId
        });
      case n.CDATA_SECTION_NODE:
        return {
          type: NodeType$1.CDATA,
          textContent: "",
          rootId
        };
      case n.COMMENT_NODE:
        return {
          type: NodeType$1.Comment,
          textContent: n.textContent || "",
          rootId
        };
      default:
        return false;
    }
  }
  function getRootId(doc, mirror2) {
    if (!mirror2.hasNode(doc))
      return void 0;
    const docId = mirror2.getId(doc);
    return docId === 1 ? void 0 : docId;
  }
  function serializeTextNode(n, options) {
    const { maskAllText, maskTextClass, unmaskTextClass, maskTextSelector, unmaskTextSelector, maskTextFn, maskInputOptions, maskInputFn, rootId } = options;
    const parentTagName = n.parentNode && n.parentNode.tagName;
    let textContent = n.textContent;
    const isStyle = parentTagName === "STYLE" ? true : void 0;
    const isScript = parentTagName === "SCRIPT" ? true : void 0;
    const isTextarea = parentTagName === "TEXTAREA" ? true : void 0;
    if (isStyle && textContent) {
      try {
        if (n.nextSibling || n.previousSibling) {
        } else if (_optionalChain$5([n, "access", (_7) => _7.parentNode, "access", (_8) => _8.sheet, "optionalAccess", (_9) => _9.cssRules])) {
          textContent = stringifyStylesheet(n.parentNode.sheet);
        }
      } catch (err) {
        console.warn(`Cannot get CSS styles from text's parentNode. Error: ${err}`, n);
      }
      textContent = absoluteToStylesheet(textContent, getHref(options.doc));
    }
    if (isScript) {
      textContent = "SCRIPT_PLACEHOLDER";
    }
    const forceMask = needMaskingText(n, maskTextClass, maskTextSelector, unmaskTextClass, unmaskTextSelector, maskAllText);
    if (!isStyle && !isScript && !isTextarea && textContent && forceMask) {
      textContent = maskTextFn ? maskTextFn(textContent, n.parentElement) : textContent.replace(/[\S]/g, "*");
    }
    if (isTextarea && textContent && (maskInputOptions.textarea || forceMask)) {
      textContent = maskInputFn ? maskInputFn(textContent, n.parentNode) : textContent.replace(/[\S]/g, "*");
    }
    if (parentTagName === "OPTION" && textContent) {
      const isInputMasked = shouldMaskInput({
        type: null,
        tagName: parentTagName,
        maskInputOptions
      });
      textContent = maskInputValue({
        isMasked: needMaskingText(n, maskTextClass, maskTextSelector, unmaskTextClass, unmaskTextSelector, isInputMasked),
        element: n,
        value: textContent,
        maskInputFn
      });
    }
    return {
      type: NodeType$1.Text,
      textContent: textContent || "",
      isStyle,
      rootId
    };
  }
  function serializeElementNode(n, options) {
    const { doc, blockClass, blockSelector, unblockSelector, inlineStylesheet, maskInputOptions = {}, maskAttributeFn, maskInputFn, dataURLOptions = {}, inlineImages, recordCanvas, keepIframeSrcFn, newlyAddedElement = false, rootId, maskAllText, maskTextClass, unmaskTextClass, maskTextSelector, unmaskTextSelector } = options;
    const needBlock = _isBlockedElement(n, blockClass, blockSelector, unblockSelector);
    const tagName = getValidTagName(n);
    let attributes = {};
    const len = n.attributes.length;
    for (let i = 0; i < len; i++) {
      const attr = n.attributes[i];
      if (attr.name && !ignoreAttribute(tagName, attr.name, attr.value)) {
        attributes[attr.name] = transformAttribute(doc, tagName, toLowerCase(attr.name), attr.value, n, maskAttributeFn);
      }
    }
    if (tagName === "link" && inlineStylesheet) {
      const stylesheet = Array.from(doc.styleSheets).find((s) => {
        return s.href === n.href;
      });
      let cssText = null;
      if (stylesheet) {
        cssText = stringifyStylesheet(stylesheet);
      }
      if (cssText) {
        delete attributes.rel;
        delete attributes.href;
        attributes._cssText = absoluteToStylesheet(cssText, stylesheet.href);
      }
    }
    if (tagName === "style" && n.sheet && !(n.innerText || n.textContent || "").trim().length) {
      const cssText = stringifyStylesheet(n.sheet);
      if (cssText) {
        attributes._cssText = absoluteToStylesheet(cssText, getHref(doc));
      }
    }
    if (tagName === "input" || tagName === "textarea" || tagName === "select" || tagName === "option") {
      const el = n;
      const type = getInputType(el);
      const value = getInputValue(el, toUpperCase(tagName), type);
      const checked = el.checked;
      if (type !== "submit" && type !== "button" && value) {
        const forceMask = needMaskingText(el, maskTextClass, maskTextSelector, unmaskTextClass, unmaskTextSelector, shouldMaskInput({
          type,
          tagName: toUpperCase(tagName),
          maskInputOptions
        }));
        attributes.value = maskInputValue({
          isMasked: forceMask,
          element: el,
          value,
          maskInputFn
        });
      }
      if (checked) {
        attributes.checked = checked;
      }
    }
    if (tagName === "option") {
      if (n.selected && !maskInputOptions["select"]) {
        attributes.selected = true;
      } else {
        delete attributes.selected;
      }
    }
    if (tagName === "canvas" && recordCanvas) {
      if (n.__context === "2d") {
        if (!is2DCanvasBlank(n)) {
          attributes.rr_dataURL = n.toDataURL(dataURLOptions.type, dataURLOptions.quality);
        }
      } else if (!("__context" in n)) {
        const canvasDataURL = n.toDataURL(dataURLOptions.type, dataURLOptions.quality);
        const blankCanvas = doc.createElement("canvas");
        blankCanvas.width = n.width;
        blankCanvas.height = n.height;
        const blankCanvasDataURL = blankCanvas.toDataURL(dataURLOptions.type, dataURLOptions.quality);
        if (canvasDataURL !== blankCanvasDataURL) {
          attributes.rr_dataURL = canvasDataURL;
        }
      }
    }
    if (tagName === "img" && inlineImages) {
      if (!canvasService) {
        canvasService = doc.createElement("canvas");
        canvasCtx = canvasService.getContext("2d");
      }
      const image = n;
      const imageSrc = image.currentSrc || image.getAttribute("src") || "<unknown-src>";
      const priorCrossOrigin = image.crossOrigin;
      const recordInlineImage = () => {
        image.removeEventListener("load", recordInlineImage);
        try {
          canvasService.width = image.naturalWidth;
          canvasService.height = image.naturalHeight;
          canvasCtx.drawImage(image, 0, 0);
          attributes.rr_dataURL = canvasService.toDataURL(dataURLOptions.type, dataURLOptions.quality);
        } catch (err) {
          if (image.crossOrigin !== "anonymous") {
            image.crossOrigin = "anonymous";
            if (image.complete && image.naturalWidth !== 0)
              recordInlineImage();
            else
              image.addEventListener("load", recordInlineImage);
            return;
          } else {
            console.warn(`Cannot inline img src=${imageSrc}! Error: ${err}`);
          }
        }
        if (image.crossOrigin === "anonymous") {
          priorCrossOrigin ? attributes.crossOrigin = priorCrossOrigin : image.removeAttribute("crossorigin");
        }
      };
      if (image.complete && image.naturalWidth !== 0)
        recordInlineImage();
      else
        image.addEventListener("load", recordInlineImage);
    }
    if (tagName === "audio" || tagName === "video") {
      attributes.rr_mediaState = n.paused ? "paused" : "played";
      attributes.rr_mediaCurrentTime = n.currentTime;
    }
    if (!newlyAddedElement) {
      if (n.scrollLeft) {
        attributes.rr_scrollLeft = n.scrollLeft;
      }
      if (n.scrollTop) {
        attributes.rr_scrollTop = n.scrollTop;
      }
    }
    if (needBlock) {
      const { width, height } = n.getBoundingClientRect();
      attributes = {
        class: attributes.class,
        rr_width: `${width}px`,
        rr_height: `${height}px`
      };
    }
    if (tagName === "iframe" && !keepIframeSrcFn(attributes.src)) {
      if (!needBlock && !n.contentDocument) {
        attributes.rr_src = attributes.src;
      }
      delete attributes.src;
    }
    let isCustomElement;
    try {
      if (customElements.get(tagName))
        isCustomElement = true;
    } catch (e2) {
    }
    return {
      type: NodeType$1.Element,
      tagName,
      attributes,
      childNodes: [],
      isSVG: isSVGElement(n) || void 0,
      needBlock,
      rootId,
      isCustom: isCustomElement
    };
  }
  function lowerIfExists(maybeAttr) {
    if (maybeAttr === void 0 || maybeAttr === null) {
      return "";
    } else {
      return maybeAttr.toLowerCase();
    }
  }
  function slimDOMExcluded(sn, slimDOMOptions) {
    if (slimDOMOptions.comment && sn.type === NodeType$1.Comment) {
      return true;
    } else if (sn.type === NodeType$1.Element) {
      if (slimDOMOptions.script && (sn.tagName === "script" || sn.tagName === "link" && (sn.attributes.rel === "preload" || sn.attributes.rel === "modulepreload") && sn.attributes.as === "script" || sn.tagName === "link" && sn.attributes.rel === "prefetch" && typeof sn.attributes.href === "string" && extractFileExtension(sn.attributes.href) === "js")) {
        return true;
      } else if (slimDOMOptions.headFavicon && (sn.tagName === "link" && sn.attributes.rel === "shortcut icon" || sn.tagName === "meta" && (lowerIfExists(sn.attributes.name).match(/^msapplication-tile(image|color)$/) || lowerIfExists(sn.attributes.name) === "application-name" || lowerIfExists(sn.attributes.rel) === "icon" || lowerIfExists(sn.attributes.rel) === "apple-touch-icon" || lowerIfExists(sn.attributes.rel) === "shortcut icon"))) {
        return true;
      } else if (sn.tagName === "meta") {
        if (slimDOMOptions.headMetaDescKeywords && lowerIfExists(sn.attributes.name).match(/^description|keywords$/)) {
          return true;
        } else if (slimDOMOptions.headMetaSocial && (lowerIfExists(sn.attributes.property).match(/^(og|twitter|fb):/) || lowerIfExists(sn.attributes.name).match(/^(og|twitter):/) || lowerIfExists(sn.attributes.name) === "pinterest")) {
          return true;
        } else if (slimDOMOptions.headMetaRobots && (lowerIfExists(sn.attributes.name) === "robots" || lowerIfExists(sn.attributes.name) === "googlebot" || lowerIfExists(sn.attributes.name) === "bingbot")) {
          return true;
        } else if (slimDOMOptions.headMetaHttpEquiv && sn.attributes["http-equiv"] !== void 0) {
          return true;
        } else if (slimDOMOptions.headMetaAuthorship && (lowerIfExists(sn.attributes.name) === "author" || lowerIfExists(sn.attributes.name) === "generator" || lowerIfExists(sn.attributes.name) === "framework" || lowerIfExists(sn.attributes.name) === "publisher" || lowerIfExists(sn.attributes.name) === "progid" || lowerIfExists(sn.attributes.property).match(/^article:/) || lowerIfExists(sn.attributes.property).match(/^product:/))) {
          return true;
        } else if (slimDOMOptions.headMetaVerification && (lowerIfExists(sn.attributes.name) === "google-site-verification" || lowerIfExists(sn.attributes.name) === "yandex-verification" || lowerIfExists(sn.attributes.name) === "csrf-token" || lowerIfExists(sn.attributes.name) === "p:domain_verify" || lowerIfExists(sn.attributes.name) === "verify-v1" || lowerIfExists(sn.attributes.name) === "verification" || lowerIfExists(sn.attributes.name) === "shopify-checkout-api-token")) {
          return true;
        }
      }
    }
    return false;
  }
  function serializeNodeWithId(n, options) {
    const { doc, mirror: mirror2, blockClass, blockSelector, unblockSelector, maskAllText, maskTextClass, unmaskTextClass, maskTextSelector, unmaskTextSelector, skipChild = false, inlineStylesheet = true, maskInputOptions = {}, maskAttributeFn, maskTextFn, maskInputFn, slimDOMOptions, dataURLOptions = {}, inlineImages = false, recordCanvas = false, onSerialize, onIframeLoad, iframeLoadTimeout = 5e3, onStylesheetLoad, stylesheetLoadTimeout = 5e3, keepIframeSrcFn = () => false, newlyAddedElement = false } = options;
    let { preserveWhiteSpace = true } = options;
    const _serializedNode = serializeNode(n, {
      doc,
      mirror: mirror2,
      blockClass,
      blockSelector,
      maskAllText,
      unblockSelector,
      maskTextClass,
      unmaskTextClass,
      maskTextSelector,
      unmaskTextSelector,
      inlineStylesheet,
      maskInputOptions,
      maskAttributeFn,
      maskTextFn,
      maskInputFn,
      dataURLOptions,
      inlineImages,
      recordCanvas,
      keepIframeSrcFn,
      newlyAddedElement
    });
    if (!_serializedNode) {
      console.warn(n, "not serialized");
      return null;
    }
    let id;
    if (mirror2.hasNode(n)) {
      id = mirror2.getId(n);
    } else if (slimDOMExcluded(_serializedNode, slimDOMOptions) || !preserveWhiteSpace && _serializedNode.type === NodeType$1.Text && !_serializedNode.isStyle && !_serializedNode.textContent.replace(/^\s+|\s+$/gm, "").length) {
      id = IGNORED_NODE;
    } else {
      id = genId();
    }
    const serializedNode = Object.assign(_serializedNode, { id });
    mirror2.add(n, serializedNode);
    if (id === IGNORED_NODE) {
      return null;
    }
    if (onSerialize) {
      onSerialize(n);
    }
    let recordChild = !skipChild;
    if (serializedNode.type === NodeType$1.Element) {
      recordChild = recordChild && !serializedNode.needBlock;
      delete serializedNode.needBlock;
      const shadowRoot = n.shadowRoot;
      if (shadowRoot && isNativeShadowDom(shadowRoot))
        serializedNode.isShadowHost = true;
    }
    if ((serializedNode.type === NodeType$1.Document || serializedNode.type === NodeType$1.Element) && recordChild) {
      if (slimDOMOptions.headWhitespace && serializedNode.type === NodeType$1.Element && serializedNode.tagName === "head") {
        preserveWhiteSpace = false;
      }
      const bypassOptions = {
        doc,
        mirror: mirror2,
        blockClass,
        blockSelector,
        maskAllText,
        unblockSelector,
        maskTextClass,
        unmaskTextClass,
        maskTextSelector,
        unmaskTextSelector,
        skipChild,
        inlineStylesheet,
        maskInputOptions,
        maskAttributeFn,
        maskTextFn,
        maskInputFn,
        slimDOMOptions,
        dataURLOptions,
        inlineImages,
        recordCanvas,
        preserveWhiteSpace,
        onSerialize,
        onIframeLoad,
        iframeLoadTimeout,
        onStylesheetLoad,
        stylesheetLoadTimeout,
        keepIframeSrcFn
      };
      for (const childN of Array.from(n.childNodes)) {
        const serializedChildNode = serializeNodeWithId(childN, bypassOptions);
        if (serializedChildNode) {
          serializedNode.childNodes.push(serializedChildNode);
        }
      }
      if (isElement$1(n) && n.shadowRoot) {
        for (const childN of Array.from(n.shadowRoot.childNodes)) {
          const serializedChildNode = serializeNodeWithId(childN, bypassOptions);
          if (serializedChildNode) {
            isNativeShadowDom(n.shadowRoot) && (serializedChildNode.isShadow = true);
            serializedNode.childNodes.push(serializedChildNode);
          }
        }
      }
    }
    if (n.parentNode && isShadowRoot(n.parentNode) && isNativeShadowDom(n.parentNode)) {
      serializedNode.isShadow = true;
    }
    if (serializedNode.type === NodeType$1.Element && serializedNode.tagName === "iframe") {
      onceIframeLoaded(n, () => {
        const iframeDoc = n.contentDocument;
        if (iframeDoc && onIframeLoad) {
          const serializedIframeNode = serializeNodeWithId(iframeDoc, {
            doc: iframeDoc,
            mirror: mirror2,
            blockClass,
            blockSelector,
            unblockSelector,
            maskAllText,
            maskTextClass,
            unmaskTextClass,
            maskTextSelector,
            unmaskTextSelector,
            skipChild: false,
            inlineStylesheet,
            maskInputOptions,
            maskAttributeFn,
            maskTextFn,
            maskInputFn,
            slimDOMOptions,
            dataURLOptions,
            inlineImages,
            recordCanvas,
            preserveWhiteSpace,
            onSerialize,
            onIframeLoad,
            iframeLoadTimeout,
            onStylesheetLoad,
            stylesheetLoadTimeout,
            keepIframeSrcFn
          });
          if (serializedIframeNode) {
            onIframeLoad(n, serializedIframeNode);
          }
        }
      }, iframeLoadTimeout);
    }
    if (serializedNode.type === NodeType$1.Element && serializedNode.tagName === "link" && typeof serializedNode.attributes.rel === "string" && (serializedNode.attributes.rel === "stylesheet" || serializedNode.attributes.rel === "preload" && typeof serializedNode.attributes.href === "string" && extractFileExtension(serializedNode.attributes.href) === "css")) {
      onceStylesheetLoaded(n, () => {
        if (onStylesheetLoad) {
          const serializedLinkNode = serializeNodeWithId(n, {
            doc,
            mirror: mirror2,
            blockClass,
            blockSelector,
            unblockSelector,
            maskAllText,
            maskTextClass,
            unmaskTextClass,
            maskTextSelector,
            unmaskTextSelector,
            skipChild: false,
            inlineStylesheet,
            maskInputOptions,
            maskAttributeFn,
            maskTextFn,
            maskInputFn,
            slimDOMOptions,
            dataURLOptions,
            inlineImages,
            recordCanvas,
            preserveWhiteSpace,
            onSerialize,
            onIframeLoad,
            iframeLoadTimeout,
            onStylesheetLoad,
            stylesheetLoadTimeout,
            keepIframeSrcFn
          });
          if (serializedLinkNode) {
            onStylesheetLoad(n, serializedLinkNode);
          }
        }
      }, stylesheetLoadTimeout);
    }
    return serializedNode;
  }
  function snapshot(n, options) {
    const { mirror: mirror2 = new Mirror(), blockClass = "rr-block", blockSelector = null, unblockSelector = null, maskAllText = false, maskTextClass = "rr-mask", unmaskTextClass = null, maskTextSelector = null, unmaskTextSelector = null, inlineStylesheet = true, inlineImages = false, recordCanvas = false, maskAllInputs = false, maskAttributeFn, maskTextFn, maskInputFn, slimDOM = false, dataURLOptions, preserveWhiteSpace, onSerialize, onIframeLoad, iframeLoadTimeout, onStylesheetLoad, stylesheetLoadTimeout, keepIframeSrcFn = () => false } = options || {};
    const maskInputOptions = maskAllInputs === true ? {
      color: true,
      date: true,
      "datetime-local": true,
      email: true,
      month: true,
      number: true,
      range: true,
      search: true,
      tel: true,
      text: true,
      time: true,
      url: true,
      week: true,
      textarea: true,
      select: true
    } : maskAllInputs === false ? {} : maskAllInputs;
    const slimDOMOptions = slimDOM === true || slimDOM === "all" ? {
      script: true,
      comment: true,
      headFavicon: true,
      headWhitespace: true,
      headMetaDescKeywords: slimDOM === "all",
      headMetaSocial: true,
      headMetaRobots: true,
      headMetaHttpEquiv: true,
      headMetaAuthorship: true,
      headMetaVerification: true
    } : slimDOM === false ? {} : slimDOM;
    return serializeNodeWithId(n, {
      doc: n,
      mirror: mirror2,
      blockClass,
      blockSelector,
      unblockSelector,
      maskAllText,
      maskTextClass,
      unmaskTextClass,
      maskTextSelector,
      unmaskTextSelector,
      skipChild: false,
      inlineStylesheet,
      maskInputOptions,
      maskAttributeFn,
      maskTextFn,
      maskInputFn,
      slimDOMOptions,
      dataURLOptions,
      inlineImages,
      recordCanvas,
      preserveWhiteSpace,
      onSerialize,
      onIframeLoad,
      iframeLoadTimeout,
      onStylesheetLoad,
      stylesheetLoadTimeout,
      keepIframeSrcFn,
      newlyAddedElement: false
    });
  }
  function _optionalChain$4(ops) {
    let lastAccessLHS = void 0;
    let value = ops[0];
    let i = 1;
    while (i < ops.length) {
      const op = ops[i];
      const fn = ops[i + 1];
      i += 2;
      if ((op === "optionalAccess" || op === "optionalCall") && value == null) {
        return void 0;
      }
      if (op === "access" || op === "optionalAccess") {
        lastAccessLHS = value;
        value = fn(value);
      } else if (op === "call" || op === "optionalCall") {
        value = fn((...args) => value.call(lastAccessLHS, ...args));
        lastAccessLHS = void 0;
      }
    }
    return value;
  }
  function on(type, fn, target = document) {
    const options = { capture: true, passive: true };
    target.addEventListener(type, fn, options);
    return () => target.removeEventListener(type, fn, options);
  }
  var DEPARTED_MIRROR_ACCESS_WARNING = "Please stop import mirror directly. Instead of that,\r\nnow you can use replayer.getMirror() to access the mirror instance of a replayer,\r\nor you can use record.mirror to access the mirror instance during recording.";
  var _mirror = {
    map: {},
    getId() {
      console.error(DEPARTED_MIRROR_ACCESS_WARNING);
      return -1;
    },
    getNode() {
      console.error(DEPARTED_MIRROR_ACCESS_WARNING);
      return null;
    },
    removeNodeFromMap() {
      console.error(DEPARTED_MIRROR_ACCESS_WARNING);
    },
    has() {
      console.error(DEPARTED_MIRROR_ACCESS_WARNING);
      return false;
    },
    reset() {
      console.error(DEPARTED_MIRROR_ACCESS_WARNING);
    }
  };
  if (typeof window !== "undefined" && window.Proxy && window.Reflect) {
    _mirror = new Proxy(_mirror, {
      get(target, prop, receiver) {
        if (prop === "map") {
          console.error(DEPARTED_MIRROR_ACCESS_WARNING);
        }
        return Reflect.get(target, prop, receiver);
      }
    });
  }
  function throttle$1(func, wait, options = {}) {
    let timeout = null;
    let previous = 0;
    return function(...args) {
      const now = Date.now();
      if (!previous && options.leading === false) {
        previous = now;
      }
      const remaining = wait - (now - previous);
      const context = this;
      if (remaining <= 0 || remaining > wait) {
        if (timeout) {
          clearTimeout$1(timeout);
          timeout = null;
        }
        previous = now;
        func.apply(context, args);
      } else if (!timeout && options.trailing !== false) {
        timeout = setTimeout$1(() => {
          previous = options.leading === false ? 0 : Date.now();
          timeout = null;
          func.apply(context, args);
        }, remaining);
      }
    };
  }
  function hookSetter(target, key, d, isRevoked, win = window) {
    const original = win.Object.getOwnPropertyDescriptor(target, key);
    win.Object.defineProperty(target, key, isRevoked ? d : {
      set(value) {
        setTimeout$1(() => {
          d.set.call(this, value);
        }, 0);
        if (original && original.set) {
          original.set.call(this, value);
        }
      }
    });
    return () => hookSetter(target, key, original || {}, true);
  }
  function patch(source, name, replacement) {
    try {
      if (!(name in source)) {
        return () => {
        };
      }
      const original = source[name];
      const wrapped = replacement(original);
      if (typeof wrapped === "function") {
        wrapped.prototype = wrapped.prototype || {};
        Object.defineProperties(wrapped, {
          __rrweb_original__: {
            enumerable: false,
            value: original
          }
        });
      }
      source[name] = wrapped;
      return () => {
        source[name] = original;
      };
    } catch (e2) {
      return () => {
      };
    }
  }
  var nowTimestamp = Date.now;
  if (!/[1-9][0-9]{12}/.test(Date.now().toString())) {
    nowTimestamp = () => (/* @__PURE__ */ new Date()).getTime();
  }
  function getWindowScroll(win) {
    const doc = win.document;
    return {
      left: doc.scrollingElement ? doc.scrollingElement.scrollLeft : win.pageXOffset !== void 0 ? win.pageXOffset : _optionalChain$4([doc, "optionalAccess", (_) => _.documentElement, "access", (_2) => _2.scrollLeft]) || _optionalChain$4([doc, "optionalAccess", (_3) => _3.body, "optionalAccess", (_4) => _4.parentElement, "optionalAccess", (_5) => _5.scrollLeft]) || _optionalChain$4([doc, "optionalAccess", (_6) => _6.body, "optionalAccess", (_7) => _7.scrollLeft]) || 0,
      top: doc.scrollingElement ? doc.scrollingElement.scrollTop : win.pageYOffset !== void 0 ? win.pageYOffset : _optionalChain$4([doc, "optionalAccess", (_8) => _8.documentElement, "access", (_9) => _9.scrollTop]) || _optionalChain$4([doc, "optionalAccess", (_10) => _10.body, "optionalAccess", (_11) => _11.parentElement, "optionalAccess", (_12) => _12.scrollTop]) || _optionalChain$4([doc, "optionalAccess", (_13) => _13.body, "optionalAccess", (_14) => _14.scrollTop]) || 0
    };
  }
  function getWindowHeight() {
    return window.innerHeight || document.documentElement && document.documentElement.clientHeight || document.body && document.body.clientHeight;
  }
  function getWindowWidth() {
    return window.innerWidth || document.documentElement && document.documentElement.clientWidth || document.body && document.body.clientWidth;
  }
  function closestElementOfNode(node) {
    if (!node) {
      return null;
    }
    const el = node.nodeType === node.ELEMENT_NODE ? node : node.parentElement;
    return el;
  }
  function isBlocked(node, blockClass, blockSelector, unblockSelector, checkAncestors) {
    if (!node) {
      return false;
    }
    const el = closestElementOfNode(node);
    if (!el) {
      return false;
    }
    const blockedPredicate = createMatchPredicate(blockClass, blockSelector);
    if (!checkAncestors) {
      const isUnblocked = unblockSelector && el.matches(unblockSelector);
      return blockedPredicate(el) && !isUnblocked;
    }
    const blockDistance = distanceToMatch(el, blockedPredicate);
    let unblockDistance = -1;
    if (blockDistance < 0) {
      return false;
    }
    if (unblockSelector) {
      unblockDistance = distanceToMatch(el, createMatchPredicate(null, unblockSelector));
    }
    if (blockDistance > -1 && unblockDistance < 0) {
      return true;
    }
    return blockDistance < unblockDistance;
  }
  function isSerialized(n, mirror2) {
    return mirror2.getId(n) !== -1;
  }
  function isIgnored(n, mirror2) {
    return mirror2.getId(n) === IGNORED_NODE;
  }
  function isAncestorRemoved(target, mirror2) {
    if (isShadowRoot(target)) {
      return false;
    }
    const id = mirror2.getId(target);
    if (!mirror2.has(id)) {
      return true;
    }
    if (target.parentNode && target.parentNode.nodeType === target.DOCUMENT_NODE) {
      return false;
    }
    if (!target.parentNode) {
      return true;
    }
    return isAncestorRemoved(target.parentNode, mirror2);
  }
  function legacy_isTouchEvent(event) {
    return Boolean(event.changedTouches);
  }
  function polyfill(win = window) {
    if ("NodeList" in win && !win.NodeList.prototype.forEach) {
      win.NodeList.prototype.forEach = Array.prototype.forEach;
    }
    if ("DOMTokenList" in win && !win.DOMTokenList.prototype.forEach) {
      win.DOMTokenList.prototype.forEach = Array.prototype.forEach;
    }
    if (!Node.prototype.contains) {
      Node.prototype.contains = (...args) => {
        let node = args[0];
        if (!(0 in args)) {
          throw new TypeError("1 argument is required");
        }
        do {
          if (this === node) {
            return true;
          }
        } while (node = node && node.parentNode);
        return false;
      };
    }
  }
  function isSerializedIframe(n, mirror2) {
    return Boolean(n.nodeName === "IFRAME" && mirror2.getMeta(n));
  }
  function isSerializedStylesheet(n, mirror2) {
    return Boolean(n.nodeName === "LINK" && n.nodeType === n.ELEMENT_NODE && n.getAttribute && n.getAttribute("rel") === "stylesheet" && mirror2.getMeta(n));
  }
  function hasShadowRoot(n) {
    return Boolean(_optionalChain$4([n, "optionalAccess", (_18) => _18.shadowRoot]));
  }
  var StyleSheetMirror = class {
    constructor() {
      this.id = 1;
      this.styleIDMap = /* @__PURE__ */ new WeakMap();
      this.idStyleMap = /* @__PURE__ */ new Map();
    }
    getId(stylesheet) {
      return _nullishCoalesce(this.styleIDMap.get(stylesheet), () => -1);
    }
    has(stylesheet) {
      return this.styleIDMap.has(stylesheet);
    }
    add(stylesheet, id) {
      if (this.has(stylesheet))
        return this.getId(stylesheet);
      let newId;
      if (id === void 0) {
        newId = this.id++;
      } else
        newId = id;
      this.styleIDMap.set(stylesheet, newId);
      this.idStyleMap.set(newId, stylesheet);
      return newId;
    }
    getStyle(id) {
      return this.idStyleMap.get(id) || null;
    }
    reset() {
      this.styleIDMap = /* @__PURE__ */ new WeakMap();
      this.idStyleMap = /* @__PURE__ */ new Map();
      this.id = 1;
    }
    generateId() {
      return this.id++;
    }
  };
  function getShadowHost(n) {
    let shadowHost = null;
    if (_optionalChain$4([n, "access", (_19) => _19.getRootNode, "optionalCall", (_20) => _20(), "optionalAccess", (_21) => _21.nodeType]) === Node.DOCUMENT_FRAGMENT_NODE && n.getRootNode().host)
      shadowHost = n.getRootNode().host;
    return shadowHost;
  }
  function getRootShadowHost(n) {
    let rootShadowHost = n;
    let shadowHost;
    while (shadowHost = getShadowHost(rootShadowHost))
      rootShadowHost = shadowHost;
    return rootShadowHost;
  }
  function shadowHostInDom(n) {
    const doc = n.ownerDocument;
    if (!doc)
      return false;
    const shadowHost = getRootShadowHost(n);
    return doc.contains(shadowHost);
  }
  function inDom(n) {
    const doc = n.ownerDocument;
    if (!doc)
      return false;
    return doc.contains(n) || shadowHostInDom(n);
  }
  var cachedImplementations2 = {};
  function getImplementation(name) {
    const cached = cachedImplementations2[name];
    if (cached) {
      return cached;
    }
    const document2 = window.document;
    let impl = window[name];
    if (document2 && typeof document2.createElement === "function") {
      try {
        const sandbox = document2.createElement("iframe");
        sandbox.hidden = true;
        document2.head.appendChild(sandbox);
        const contentWindow = sandbox.contentWindow;
        if (contentWindow && contentWindow[name]) {
          impl = contentWindow[name];
        }
        document2.head.removeChild(sandbox);
      } catch (e2) {
      }
    }
    return cachedImplementations2[name] = impl.bind(window);
  }
  function onRequestAnimationFrame(...rest) {
    return getImplementation("requestAnimationFrame")(...rest);
  }
  function setTimeout$1(...rest) {
    return getImplementation("setTimeout")(...rest);
  }
  function clearTimeout$1(...rest) {
    return getImplementation("clearTimeout")(...rest);
  }
  var EventType = /* @__PURE__ */ ((EventType2) => {
    EventType2[EventType2["DomContentLoaded"] = 0] = "DomContentLoaded";
    EventType2[EventType2["Load"] = 1] = "Load";
    EventType2[EventType2["FullSnapshot"] = 2] = "FullSnapshot";
    EventType2[EventType2["IncrementalSnapshot"] = 3] = "IncrementalSnapshot";
    EventType2[EventType2["Meta"] = 4] = "Meta";
    EventType2[EventType2["Custom"] = 5] = "Custom";
    EventType2[EventType2["Plugin"] = 6] = "Plugin";
    return EventType2;
  })(EventType || {});
  var IncrementalSource = /* @__PURE__ */ ((IncrementalSource2) => {
    IncrementalSource2[IncrementalSource2["Mutation"] = 0] = "Mutation";
    IncrementalSource2[IncrementalSource2["MouseMove"] = 1] = "MouseMove";
    IncrementalSource2[IncrementalSource2["MouseInteraction"] = 2] = "MouseInteraction";
    IncrementalSource2[IncrementalSource2["Scroll"] = 3] = "Scroll";
    IncrementalSource2[IncrementalSource2["ViewportResize"] = 4] = "ViewportResize";
    IncrementalSource2[IncrementalSource2["Input"] = 5] = "Input";
    IncrementalSource2[IncrementalSource2["TouchMove"] = 6] = "TouchMove";
    IncrementalSource2[IncrementalSource2["MediaInteraction"] = 7] = "MediaInteraction";
    IncrementalSource2[IncrementalSource2["StyleSheetRule"] = 8] = "StyleSheetRule";
    IncrementalSource2[IncrementalSource2["CanvasMutation"] = 9] = "CanvasMutation";
    IncrementalSource2[IncrementalSource2["Font"] = 10] = "Font";
    IncrementalSource2[IncrementalSource2["Log"] = 11] = "Log";
    IncrementalSource2[IncrementalSource2["Drag"] = 12] = "Drag";
    IncrementalSource2[IncrementalSource2["StyleDeclaration"] = 13] = "StyleDeclaration";
    IncrementalSource2[IncrementalSource2["Selection"] = 14] = "Selection";
    IncrementalSource2[IncrementalSource2["AdoptedStyleSheet"] = 15] = "AdoptedStyleSheet";
    IncrementalSource2[IncrementalSource2["CustomElement"] = 16] = "CustomElement";
    return IncrementalSource2;
  })(IncrementalSource || {});
  var MouseInteractions = /* @__PURE__ */ ((MouseInteractions2) => {
    MouseInteractions2[MouseInteractions2["MouseUp"] = 0] = "MouseUp";
    MouseInteractions2[MouseInteractions2["MouseDown"] = 1] = "MouseDown";
    MouseInteractions2[MouseInteractions2["Click"] = 2] = "Click";
    MouseInteractions2[MouseInteractions2["ContextMenu"] = 3] = "ContextMenu";
    MouseInteractions2[MouseInteractions2["DblClick"] = 4] = "DblClick";
    MouseInteractions2[MouseInteractions2["Focus"] = 5] = "Focus";
    MouseInteractions2[MouseInteractions2["Blur"] = 6] = "Blur";
    MouseInteractions2[MouseInteractions2["TouchStart"] = 7] = "TouchStart";
    MouseInteractions2[MouseInteractions2["TouchMove_Departed"] = 8] = "TouchMove_Departed";
    MouseInteractions2[MouseInteractions2["TouchEnd"] = 9] = "TouchEnd";
    MouseInteractions2[MouseInteractions2["TouchCancel"] = 10] = "TouchCancel";
    return MouseInteractions2;
  })(MouseInteractions || {});
  var PointerTypes = /* @__PURE__ */ ((PointerTypes2) => {
    PointerTypes2[PointerTypes2["Mouse"] = 0] = "Mouse";
    PointerTypes2[PointerTypes2["Pen"] = 1] = "Pen";
    PointerTypes2[PointerTypes2["Touch"] = 2] = "Touch";
    return PointerTypes2;
  })(PointerTypes || {});
  function _optionalChain$3(ops) {
    let lastAccessLHS = void 0;
    let value = ops[0];
    let i = 1;
    while (i < ops.length) {
      const op = ops[i];
      const fn = ops[i + 1];
      i += 2;
      if ((op === "optionalAccess" || op === "optionalCall") && value == null) {
        return void 0;
      }
      if (op === "access" || op === "optionalAccess") {
        lastAccessLHS = value;
        value = fn(value);
      } else if (op === "call" || op === "optionalCall") {
        value = fn((...args) => value.call(lastAccessLHS, ...args));
        lastAccessLHS = void 0;
      }
    }
    return value;
  }
  function isNodeInLinkedList(n) {
    return "__ln" in n;
  }
  var DoubleLinkedList = class {
    constructor() {
      this.length = 0;
      this.head = null;
      this.tail = null;
    }
    get(position) {
      if (position >= this.length) {
        throw new Error("Position outside of list range");
      }
      let current = this.head;
      for (let index = 0; index < position; index++) {
        current = _optionalChain$3([current, "optionalAccess", (_) => _.next]) || null;
      }
      return current;
    }
    addNode(n) {
      const node = {
        value: n,
        previous: null,
        next: null
      };
      n.__ln = node;
      if (n.previousSibling && isNodeInLinkedList(n.previousSibling)) {
        const current = n.previousSibling.__ln.next;
        node.next = current;
        node.previous = n.previousSibling.__ln;
        n.previousSibling.__ln.next = node;
        if (current) {
          current.previous = node;
        }
      } else if (n.nextSibling && isNodeInLinkedList(n.nextSibling) && n.nextSibling.__ln.previous) {
        const current = n.nextSibling.__ln.previous;
        node.previous = current;
        node.next = n.nextSibling.__ln;
        n.nextSibling.__ln.previous = node;
        if (current) {
          current.next = node;
        }
      } else {
        if (this.head) {
          this.head.previous = node;
        }
        node.next = this.head;
        this.head = node;
      }
      if (node.next === null) {
        this.tail = node;
      }
      this.length++;
    }
    removeNode(n) {
      const current = n.__ln;
      if (!this.head) {
        return;
      }
      if (!current.previous) {
        this.head = current.next;
        if (this.head) {
          this.head.previous = null;
        } else {
          this.tail = null;
        }
      } else {
        current.previous.next = current.next;
        if (current.next) {
          current.next.previous = current.previous;
        } else {
          this.tail = current.previous;
        }
      }
      if (n.__ln) {
        delete n.__ln;
      }
      this.length--;
    }
  };
  var moveKey = (id, parentId) => `${id}@${parentId}`;
  var MutationBuffer = class {
    constructor() {
      this.frozen = false;
      this.locked = false;
      this.texts = [];
      this.attributes = [];
      this.attributeMap = /* @__PURE__ */ new WeakMap();
      this.removes = [];
      this.mapRemoves = [];
      this.movedMap = {};
      this.addedSet = /* @__PURE__ */ new Set();
      this.movedSet = /* @__PURE__ */ new Set();
      this.droppedSet = /* @__PURE__ */ new Set();
      this.processMutations = (mutations) => {
        mutations.forEach(this.processMutation);
        this.emit();
      };
      this.emit = () => {
        if (this.frozen || this.locked) {
          return;
        }
        const adds = [];
        const addedIds = /* @__PURE__ */ new Set();
        const addList = new DoubleLinkedList();
        const getNextId = (n) => {
          let ns = n;
          let nextId = IGNORED_NODE;
          while (nextId === IGNORED_NODE) {
            ns = ns && ns.nextSibling;
            nextId = ns && this.mirror.getId(ns);
          }
          return nextId;
        };
        const pushAdd = (n) => {
          if (!n.parentNode || !inDom(n)) {
            return;
          }
          const parentId = isShadowRoot(n.parentNode) ? this.mirror.getId(getShadowHost(n)) : this.mirror.getId(n.parentNode);
          const nextId = getNextId(n);
          if (parentId === -1 || nextId === -1) {
            return addList.addNode(n);
          }
          const sn = serializeNodeWithId(n, {
            doc: this.doc,
            mirror: this.mirror,
            blockClass: this.blockClass,
            blockSelector: this.blockSelector,
            maskAllText: this.maskAllText,
            unblockSelector: this.unblockSelector,
            maskTextClass: this.maskTextClass,
            unmaskTextClass: this.unmaskTextClass,
            maskTextSelector: this.maskTextSelector,
            unmaskTextSelector: this.unmaskTextSelector,
            skipChild: true,
            newlyAddedElement: true,
            inlineStylesheet: this.inlineStylesheet,
            maskInputOptions: this.maskInputOptions,
            maskAttributeFn: this.maskAttributeFn,
            maskTextFn: this.maskTextFn,
            maskInputFn: this.maskInputFn,
            slimDOMOptions: this.slimDOMOptions,
            dataURLOptions: this.dataURLOptions,
            recordCanvas: this.recordCanvas,
            inlineImages: this.inlineImages,
            onSerialize: (currentN) => {
              if (isSerializedIframe(currentN, this.mirror) && !isBlocked(currentN, this.blockClass, this.blockSelector, this.unblockSelector, false)) {
                this.iframeManager.addIframe(currentN);
              }
              if (isSerializedStylesheet(currentN, this.mirror)) {
                this.stylesheetManager.trackLinkElement(currentN);
              }
              if (hasShadowRoot(n)) {
                this.shadowDomManager.addShadowRoot(n.shadowRoot, this.doc);
              }
            },
            onIframeLoad: (iframe, childSn) => {
              if (isBlocked(iframe, this.blockClass, this.blockSelector, this.unblockSelector, false)) {
                return;
              }
              this.iframeManager.attachIframe(iframe, childSn);
              if (iframe.contentWindow) {
                this.canvasManager.addWindow(iframe.contentWindow);
              }
              this.shadowDomManager.observeAttachShadow(iframe);
            },
            onStylesheetLoad: (link, childSn) => {
              this.stylesheetManager.attachLinkElement(link, childSn);
            }
          });
          if (sn) {
            adds.push({
              parentId,
              nextId,
              node: sn
            });
            addedIds.add(sn.id);
          }
        };
        while (this.mapRemoves.length) {
          this.mirror.removeNodeFromMap(this.mapRemoves.shift());
        }
        for (const n of this.movedSet) {
          if (isParentRemoved(this.removes, n, this.mirror) && !this.movedSet.has(n.parentNode)) {
            continue;
          }
          pushAdd(n);
        }
        for (const n of this.addedSet) {
          if (!isAncestorInSet(this.droppedSet, n) && !isParentRemoved(this.removes, n, this.mirror)) {
            pushAdd(n);
          } else if (isAncestorInSet(this.movedSet, n)) {
            pushAdd(n);
          } else {
            this.droppedSet.add(n);
          }
        }
        let candidate = null;
        while (addList.length) {
          let node = null;
          if (candidate) {
            const parentId = this.mirror.getId(candidate.value.parentNode);
            const nextId = getNextId(candidate.value);
            if (parentId !== -1 && nextId !== -1) {
              node = candidate;
            }
          }
          if (!node) {
            let tailNode = addList.tail;
            while (tailNode) {
              const _node = tailNode;
              tailNode = tailNode.previous;
              if (_node) {
                const parentId = this.mirror.getId(_node.value.parentNode);
                const nextId = getNextId(_node.value);
                if (nextId === -1)
                  continue;
                else if (parentId !== -1) {
                  node = _node;
                  break;
                } else {
                  const unhandledNode = _node.value;
                  if (unhandledNode.parentNode && unhandledNode.parentNode.nodeType === Node.DOCUMENT_FRAGMENT_NODE) {
                    const shadowHost = unhandledNode.parentNode.host;
                    const parentId2 = this.mirror.getId(shadowHost);
                    if (parentId2 !== -1) {
                      node = _node;
                      break;
                    }
                  }
                }
              }
            }
          }
          if (!node) {
            while (addList.head) {
              addList.removeNode(addList.head.value);
            }
            break;
          }
          candidate = node.previous;
          addList.removeNode(node.value);
          pushAdd(node.value);
        }
        const payload = {
          texts: this.texts.map((text) => ({
            id: this.mirror.getId(text.node),
            value: text.value
          })).filter((text) => !addedIds.has(text.id)).filter((text) => this.mirror.has(text.id)),
          attributes: this.attributes.map((attribute) => {
            const { attributes } = attribute;
            if (typeof attributes.style === "string") {
              const diffAsStr = JSON.stringify(attribute.styleDiff);
              const unchangedAsStr = JSON.stringify(attribute._unchangedStyles);
              if (diffAsStr.length < attributes.style.length) {
                if ((diffAsStr + unchangedAsStr).split("var(").length === attributes.style.split("var(").length) {
                  attributes.style = attribute.styleDiff;
                }
              }
            }
            return {
              id: this.mirror.getId(attribute.node),
              attributes
            };
          }).filter((attribute) => !addedIds.has(attribute.id)).filter((attribute) => this.mirror.has(attribute.id)),
          removes: this.removes,
          adds
        };
        if (!payload.texts.length && !payload.attributes.length && !payload.removes.length && !payload.adds.length) {
          return;
        }
        this.texts = [];
        this.attributes = [];
        this.attributeMap = /* @__PURE__ */ new WeakMap();
        this.removes = [];
        this.addedSet = /* @__PURE__ */ new Set();
        this.movedSet = /* @__PURE__ */ new Set();
        this.droppedSet = /* @__PURE__ */ new Set();
        this.movedMap = {};
        this.mutationCb(payload);
      };
      this.processMutation = (m2) => {
        if (isIgnored(m2.target, this.mirror)) {
          return;
        }
        switch (m2.type) {
          case "characterData": {
            const value = m2.target.textContent;
            if (!isBlocked(m2.target, this.blockClass, this.blockSelector, this.unblockSelector, false) && value !== m2.oldValue) {
              this.texts.push({
                value: needMaskingText(m2.target, this.maskTextClass, this.maskTextSelector, this.unmaskTextClass, this.unmaskTextSelector, this.maskAllText) && value ? this.maskTextFn ? this.maskTextFn(value, closestElementOfNode(m2.target)) : value.replace(/[\S]/g, "*") : value,
                node: m2.target
              });
            }
            break;
          }
          case "attributes": {
            const target = m2.target;
            let attributeName = m2.attributeName;
            let value = m2.target.getAttribute(attributeName);
            if (attributeName === "value") {
              const type = getInputType(target);
              const tagName = target.tagName;
              value = getInputValue(target, tagName, type);
              const isInputMasked = shouldMaskInput({
                maskInputOptions: this.maskInputOptions,
                tagName,
                type
              });
              const forceMask = needMaskingText(m2.target, this.maskTextClass, this.maskTextSelector, this.unmaskTextClass, this.unmaskTextSelector, isInputMasked);
              value = maskInputValue({
                isMasked: forceMask,
                element: target,
                value,
                maskInputFn: this.maskInputFn
              });
            }
            if (isBlocked(m2.target, this.blockClass, this.blockSelector, this.unblockSelector, false) || value === m2.oldValue) {
              return;
            }
            let item = this.attributeMap.get(m2.target);
            if (target.tagName === "IFRAME" && attributeName === "src" && !this.keepIframeSrcFn(value)) {
              if (!target.contentDocument) {
                attributeName = "rr_src";
              } else {
                return;
              }
            }
            if (!item) {
              item = {
                node: m2.target,
                attributes: {},
                styleDiff: {},
                _unchangedStyles: {}
              };
              this.attributes.push(item);
              this.attributeMap.set(m2.target, item);
            }
            if (attributeName === "type" && target.tagName === "INPUT" && (m2.oldValue || "").toLowerCase() === "password") {
              target.setAttribute("data-rr-is-password", "true");
            }
            if (!ignoreAttribute(target.tagName, attributeName)) {
              item.attributes[attributeName] = transformAttribute(this.doc, toLowerCase(target.tagName), toLowerCase(attributeName), value, target, this.maskAttributeFn);
              if (attributeName === "style") {
                if (!this.unattachedDoc) {
                  try {
                    this.unattachedDoc = document.implementation.createHTMLDocument();
                  } catch (e2) {
                    this.unattachedDoc = this.doc;
                  }
                }
                const old = this.unattachedDoc.createElement("span");
                if (m2.oldValue) {
                  old.setAttribute("style", m2.oldValue);
                }
                for (const pname of Array.from(target.style)) {
                  const newValue = target.style.getPropertyValue(pname);
                  const newPriority = target.style.getPropertyPriority(pname);
                  if (newValue !== old.style.getPropertyValue(pname) || newPriority !== old.style.getPropertyPriority(pname)) {
                    if (newPriority === "") {
                      item.styleDiff[pname] = newValue;
                    } else {
                      item.styleDiff[pname] = [newValue, newPriority];
                    }
                  } else {
                    item._unchangedStyles[pname] = [newValue, newPriority];
                  }
                }
                for (const pname of Array.from(old.style)) {
                  if (target.style.getPropertyValue(pname) === "") {
                    item.styleDiff[pname] = false;
                  }
                }
              }
            }
            break;
          }
          case "childList": {
            if (isBlocked(m2.target, this.blockClass, this.blockSelector, this.unblockSelector, true)) {
              return;
            }
            m2.addedNodes.forEach((n) => this.genAdds(n, m2.target));
            m2.removedNodes.forEach((n) => {
              const nodeId = this.mirror.getId(n);
              const parentId = isShadowRoot(m2.target) ? this.mirror.getId(m2.target.host) : this.mirror.getId(m2.target);
              if (isBlocked(m2.target, this.blockClass, this.blockSelector, this.unblockSelector, false) || isIgnored(n, this.mirror) || !isSerialized(n, this.mirror)) {
                return;
              }
              if (this.addedSet.has(n)) {
                deepDelete(this.addedSet, n);
                this.droppedSet.add(n);
              } else if (this.addedSet.has(m2.target) && nodeId === -1) ;
              else if (isAncestorRemoved(m2.target, this.mirror)) ;
              else if (this.movedSet.has(n) && this.movedMap[moveKey(nodeId, parentId)]) {
                deepDelete(this.movedSet, n);
              } else {
                this.removes.push({
                  parentId,
                  id: nodeId,
                  isShadow: isShadowRoot(m2.target) && isNativeShadowDom(m2.target) ? true : void 0
                });
              }
              this.mapRemoves.push(n);
            });
            break;
          }
        }
      };
      this.genAdds = (n, target) => {
        if (this.processedNodeManager.inOtherBuffer(n, this))
          return;
        if (this.addedSet.has(n) || this.movedSet.has(n))
          return;
        if (this.mirror.hasNode(n)) {
          if (isIgnored(n, this.mirror)) {
            return;
          }
          this.movedSet.add(n);
          let targetId = null;
          if (target && this.mirror.hasNode(target)) {
            targetId = this.mirror.getId(target);
          }
          if (targetId && targetId !== -1) {
            this.movedMap[moveKey(this.mirror.getId(n), targetId)] = true;
          }
        } else {
          this.addedSet.add(n);
          this.droppedSet.delete(n);
        }
        if (!isBlocked(n, this.blockClass, this.blockSelector, this.unblockSelector, false)) {
          n.childNodes.forEach((childN) => this.genAdds(childN));
          if (hasShadowRoot(n)) {
            n.shadowRoot.childNodes.forEach((childN) => {
              this.processedNodeManager.add(childN, this);
              this.genAdds(childN, n);
            });
          }
        }
      };
    }
    init(options) {
      [
        "mutationCb",
        "blockClass",
        "blockSelector",
        "unblockSelector",
        "maskAllText",
        "maskTextClass",
        "unmaskTextClass",
        "maskTextSelector",
        "unmaskTextSelector",
        "inlineStylesheet",
        "maskInputOptions",
        "maskAttributeFn",
        "maskTextFn",
        "maskInputFn",
        "keepIframeSrcFn",
        "recordCanvas",
        "inlineImages",
        "slimDOMOptions",
        "dataURLOptions",
        "doc",
        "mirror",
        "iframeManager",
        "stylesheetManager",
        "shadowDomManager",
        "canvasManager",
        "processedNodeManager"
      ].forEach((key) => {
        this[key] = options[key];
      });
    }
    freeze() {
      this.frozen = true;
      this.canvasManager.freeze();
    }
    unfreeze() {
      this.frozen = false;
      this.canvasManager.unfreeze();
      this.emit();
    }
    isFrozen() {
      return this.frozen;
    }
    lock() {
      this.locked = true;
      this.canvasManager.lock();
    }
    unlock() {
      this.locked = false;
      this.canvasManager.unlock();
      this.emit();
    }
    reset() {
      this.shadowDomManager.reset();
      this.canvasManager.reset();
    }
  };
  function deepDelete(addsSet, n) {
    addsSet.delete(n);
    n.childNodes.forEach((childN) => deepDelete(addsSet, childN));
  }
  function isParentRemoved(removes, n, mirror2) {
    if (removes.length === 0)
      return false;
    return _isParentRemoved(removes, n, mirror2);
  }
  function _isParentRemoved(removes, n, mirror2) {
    let node = n.parentNode;
    while (node) {
      const parentId = mirror2.getId(node);
      if (removes.some((r2) => r2.id === parentId)) {
        return true;
      }
      node = node.parentNode;
    }
    return false;
  }
  function isAncestorInSet(set, n) {
    if (set.size === 0)
      return false;
    return _isAncestorInSet(set, n);
  }
  function _isAncestorInSet(set, n) {
    const { parentNode } = n;
    if (!parentNode) {
      return false;
    }
    if (set.has(parentNode)) {
      return true;
    }
    return _isAncestorInSet(set, parentNode);
  }
  var errorHandler;
  function registerErrorHandler(handler) {
    errorHandler = handler;
  }
  function unregisterErrorHandler() {
    errorHandler = void 0;
  }
  var callbackWrapper = (cb) => {
    if (!errorHandler) {
      return cb;
    }
    const rrwebWrapped = (...rest) => {
      try {
        return cb(...rest);
      } catch (error) {
        if (errorHandler && errorHandler(error) === true) {
          return () => {
          };
        }
        throw error;
      }
    };
    return rrwebWrapped;
  };
  function _optionalChain$2(ops) {
    let lastAccessLHS = void 0;
    let value = ops[0];
    let i = 1;
    while (i < ops.length) {
      const op = ops[i];
      const fn = ops[i + 1];
      i += 2;
      if ((op === "optionalAccess" || op === "optionalCall") && value == null) {
        return void 0;
      }
      if (op === "access" || op === "optionalAccess") {
        lastAccessLHS = value;
        value = fn(value);
      } else if (op === "call" || op === "optionalCall") {
        value = fn((...args) => value.call(lastAccessLHS, ...args));
        lastAccessLHS = void 0;
      }
    }
    return value;
  }
  var mutationBuffers = [];
  function getEventTarget2(event) {
    try {
      if ("composedPath" in event) {
        const path = event.composedPath();
        if (path.length) {
          return path[0];
        }
      } else if ("path" in event && event.path.length) {
        return event.path[0];
      }
    } catch (e2) {
    }
    return event && event.target;
  }
  function initMutationObserver(options, rootEl) {
    const mutationBuffer = new MutationBuffer();
    mutationBuffers.push(mutationBuffer);
    mutationBuffer.init(options);
    let mutationObserverCtor = window.MutationObserver || window.__rrMutationObserver;
    const angularZoneSymbol = _optionalChain$2([window, "optionalAccess", (_) => _.Zone, "optionalAccess", (_2) => _2.__symbol__, "optionalCall", (_3) => _3("MutationObserver")]);
    if (angularZoneSymbol && window[angularZoneSymbol]) {
      mutationObserverCtor = window[angularZoneSymbol];
    }
    const observer = new mutationObserverCtor(callbackWrapper((mutations) => {
      if (options.onMutation && options.onMutation(mutations) === false) {
        return;
      }
      mutationBuffer.processMutations.bind(mutationBuffer)(mutations);
    }));
    observer.observe(rootEl, {
      attributes: true,
      attributeOldValue: true,
      characterData: true,
      characterDataOldValue: true,
      childList: true,
      subtree: true
    });
    return observer;
  }
  function initMoveObserver({ mousemoveCb, sampling, doc, mirror: mirror2 }) {
    if (sampling.mousemove === false) {
      return () => {
      };
    }
    const threshold = typeof sampling.mousemove === "number" ? sampling.mousemove : 50;
    const callbackThreshold = typeof sampling.mousemoveCallback === "number" ? sampling.mousemoveCallback : 500;
    let positions = [];
    let timeBaseline;
    const wrappedCb = throttle$1(callbackWrapper((source) => {
      const totalOffset = Date.now() - timeBaseline;
      mousemoveCb(positions.map((p) => {
        p.timeOffset -= totalOffset;
        return p;
      }), source);
      positions = [];
      timeBaseline = null;
    }), callbackThreshold);
    const updatePosition = callbackWrapper(throttle$1(callbackWrapper((evt) => {
      const target = getEventTarget2(evt);
      const { clientX, clientY } = legacy_isTouchEvent(evt) ? evt.changedTouches[0] : evt;
      if (!timeBaseline) {
        timeBaseline = nowTimestamp();
      }
      positions.push({
        x: clientX,
        y: clientY,
        id: mirror2.getId(target),
        timeOffset: nowTimestamp() - timeBaseline
      });
      wrappedCb(typeof DragEvent !== "undefined" && evt instanceof DragEvent ? IncrementalSource.Drag : evt instanceof MouseEvent ? IncrementalSource.MouseMove : IncrementalSource.TouchMove);
    }), threshold, {
      trailing: false
    }));
    const handlers4 = [
      on("mousemove", updatePosition, doc),
      on("touchmove", updatePosition, doc),
      on("drag", updatePosition, doc)
    ];
    return callbackWrapper(() => {
      handlers4.forEach((h) => h());
    });
  }
  function initMouseInteractionObserver({ mouseInteractionCb, doc, mirror: mirror2, blockClass, blockSelector, unblockSelector, sampling }) {
    if (sampling.mouseInteraction === false) {
      return () => {
      };
    }
    const disableMap = sampling.mouseInteraction === true || sampling.mouseInteraction === void 0 ? {} : sampling.mouseInteraction;
    const handlers4 = [];
    let currentPointerType = null;
    const getHandler = (eventKey) => {
      return (event) => {
        const target = getEventTarget2(event);
        if (isBlocked(target, blockClass, blockSelector, unblockSelector, true)) {
          return;
        }
        let pointerType = null;
        let thisEventKey = eventKey;
        if ("pointerType" in event) {
          switch (event.pointerType) {
            case "mouse":
              pointerType = PointerTypes.Mouse;
              break;
            case "touch":
              pointerType = PointerTypes.Touch;
              break;
            case "pen":
              pointerType = PointerTypes.Pen;
              break;
          }
          if (pointerType === PointerTypes.Touch) {
            if (MouseInteractions[eventKey] === MouseInteractions.MouseDown) {
              thisEventKey = "TouchStart";
            } else if (MouseInteractions[eventKey] === MouseInteractions.MouseUp) {
              thisEventKey = "TouchEnd";
            }
          } else if (pointerType === PointerTypes.Pen) ;
        } else if (legacy_isTouchEvent(event)) {
          pointerType = PointerTypes.Touch;
        }
        if (pointerType !== null) {
          currentPointerType = pointerType;
          if (thisEventKey.startsWith("Touch") && pointerType === PointerTypes.Touch || thisEventKey.startsWith("Mouse") && pointerType === PointerTypes.Mouse) {
            pointerType = null;
          }
        } else if (MouseInteractions[eventKey] === MouseInteractions.Click) {
          pointerType = currentPointerType;
          currentPointerType = null;
        }
        const e2 = legacy_isTouchEvent(event) ? event.changedTouches[0] : event;
        if (!e2) {
          return;
        }
        const id = mirror2.getId(target);
        const { clientX, clientY } = e2;
        callbackWrapper(mouseInteractionCb)({
          type: MouseInteractions[thisEventKey],
          id,
          x: clientX,
          y: clientY,
          ...pointerType !== null && { pointerType }
        });
      };
    };
    Object.keys(MouseInteractions).filter((key) => Number.isNaN(Number(key)) && !key.endsWith("_Departed") && disableMap[key] !== false).forEach((eventKey) => {
      let eventName = toLowerCase(eventKey);
      const handler = getHandler(eventKey);
      if (window.PointerEvent) {
        switch (MouseInteractions[eventKey]) {
          case MouseInteractions.MouseDown:
          case MouseInteractions.MouseUp:
            eventName = eventName.replace("mouse", "pointer");
            break;
          case MouseInteractions.TouchStart:
          case MouseInteractions.TouchEnd:
            return;
        }
      }
      handlers4.push(on(eventName, handler, doc));
    });
    return callbackWrapper(() => {
      handlers4.forEach((h) => h());
    });
  }
  function initScrollObserver({ scrollCb, doc, mirror: mirror2, blockClass, blockSelector, unblockSelector, sampling }) {
    const updatePosition = callbackWrapper(throttle$1(callbackWrapper((evt) => {
      const target = getEventTarget2(evt);
      if (!target || isBlocked(target, blockClass, blockSelector, unblockSelector, true)) {
        return;
      }
      const id = mirror2.getId(target);
      if (target === doc && doc.defaultView) {
        const scrollLeftTop = getWindowScroll(doc.defaultView);
        scrollCb({
          id,
          x: scrollLeftTop.left,
          y: scrollLeftTop.top
        });
      } else {
        scrollCb({
          id,
          x: target.scrollLeft,
          y: target.scrollTop
        });
      }
    }), sampling.scroll || 100));
    return on("scroll", updatePosition, doc);
  }
  function initViewportResizeObserver({ viewportResizeCb }, { win }) {
    let lastH = -1;
    let lastW = -1;
    const updateDimension = callbackWrapper(throttle$1(callbackWrapper(() => {
      const height = getWindowHeight();
      const width = getWindowWidth();
      if (lastH !== height || lastW !== width) {
        viewportResizeCb({
          width: Number(width),
          height: Number(height)
        });
        lastH = height;
        lastW = width;
      }
    }), 200));
    return on("resize", updateDimension, win);
  }
  var INPUT_TAGS = ["INPUT", "TEXTAREA", "SELECT"];
  var lastInputValueMap = /* @__PURE__ */ new WeakMap();
  function initInputObserver({ inputCb, doc, mirror: mirror2, blockClass, blockSelector, unblockSelector, ignoreClass, ignoreSelector, maskInputOptions, maskInputFn, sampling, userTriggeredOnInput, maskTextClass, unmaskTextClass, maskTextSelector, unmaskTextSelector }) {
    function eventHandler(event) {
      let target = getEventTarget2(event);
      const userTriggered = event.isTrusted;
      const tagName = target && toUpperCase(target.tagName);
      if (tagName === "OPTION")
        target = target.parentElement;
      if (!target || !tagName || INPUT_TAGS.indexOf(tagName) < 0 || isBlocked(target, blockClass, blockSelector, unblockSelector, true)) {
        return;
      }
      const el = target;
      if (el.classList.contains(ignoreClass) || ignoreSelector && el.matches(ignoreSelector)) {
        return;
      }
      const type = getInputType(target);
      let text = getInputValue(el, tagName, type);
      let isChecked = false;
      const isInputMasked = shouldMaskInput({
        maskInputOptions,
        tagName,
        type
      });
      const forceMask = needMaskingText(target, maskTextClass, maskTextSelector, unmaskTextClass, unmaskTextSelector, isInputMasked);
      if (type === "radio" || type === "checkbox") {
        isChecked = target.checked;
      }
      text = maskInputValue({
        isMasked: forceMask,
        element: target,
        value: text,
        maskInputFn
      });
      cbWithDedup(target, userTriggeredOnInput ? { text, isChecked, userTriggered } : { text, isChecked });
      const name = target.name;
      if (type === "radio" && name && isChecked) {
        doc.querySelectorAll(`input[type="radio"][name="${name}"]`).forEach((el2) => {
          if (el2 !== target) {
            const text2 = maskInputValue({
              isMasked: forceMask,
              element: el2,
              value: getInputValue(el2, tagName, type),
              maskInputFn
            });
            cbWithDedup(el2, userTriggeredOnInput ? { text: text2, isChecked: !isChecked, userTriggered: false } : { text: text2, isChecked: !isChecked });
          }
        });
      }
    }
    function cbWithDedup(target, v) {
      const lastInputValue = lastInputValueMap.get(target);
      if (!lastInputValue || lastInputValue.text !== v.text || lastInputValue.isChecked !== v.isChecked) {
        lastInputValueMap.set(target, v);
        const id = mirror2.getId(target);
        callbackWrapper(inputCb)({
          ...v,
          id
        });
      }
    }
    const events = sampling.input === "last" ? ["change"] : ["input", "change"];
    const handlers4 = events.map((eventName) => on(eventName, callbackWrapper(eventHandler), doc));
    const currentWindow = doc.defaultView;
    if (!currentWindow) {
      return () => {
        handlers4.forEach((h) => h());
      };
    }
    const propertyDescriptor = currentWindow.Object.getOwnPropertyDescriptor(currentWindow.HTMLInputElement.prototype, "value");
    const hookProperties = [
      [currentWindow.HTMLInputElement.prototype, "value"],
      [currentWindow.HTMLInputElement.prototype, "checked"],
      [currentWindow.HTMLSelectElement.prototype, "value"],
      [currentWindow.HTMLTextAreaElement.prototype, "value"],
      [currentWindow.HTMLSelectElement.prototype, "selectedIndex"],
      [currentWindow.HTMLOptionElement.prototype, "selected"]
    ];
    if (propertyDescriptor && propertyDescriptor.set) {
      handlers4.push(...hookProperties.map((p) => hookSetter(p[0], p[1], {
        set() {
          callbackWrapper(eventHandler)({
            target: this,
            isTrusted: false
          });
        }
      }, false, currentWindow)));
    }
    return callbackWrapper(() => {
      handlers4.forEach((h) => h());
    });
  }
  function getNestedCSSRulePositions(rule) {
    const positions = [];
    function recurse(childRule, pos) {
      if (hasNestedCSSRule("CSSGroupingRule") && childRule.parentRule instanceof CSSGroupingRule || hasNestedCSSRule("CSSMediaRule") && childRule.parentRule instanceof CSSMediaRule || hasNestedCSSRule("CSSSupportsRule") && childRule.parentRule instanceof CSSSupportsRule || hasNestedCSSRule("CSSConditionRule") && childRule.parentRule instanceof CSSConditionRule) {
        const rules = Array.from(childRule.parentRule.cssRules);
        const index = rules.indexOf(childRule);
        pos.unshift(index);
      } else if (childRule.parentStyleSheet) {
        const rules = Array.from(childRule.parentStyleSheet.cssRules);
        const index = rules.indexOf(childRule);
        pos.unshift(index);
      }
      return pos;
    }
    return recurse(rule, positions);
  }
  function getIdAndStyleId(sheet, mirror2, styleMirror) {
    let id, styleId;
    if (!sheet)
      return {};
    if (sheet.ownerNode)
      id = mirror2.getId(sheet.ownerNode);
    else
      styleId = styleMirror.getId(sheet);
    return {
      styleId,
      id
    };
  }
  function initStyleSheetObserver({ styleSheetRuleCb, mirror: mirror2, stylesheetManager }, { win }) {
    if (!win.CSSStyleSheet || !win.CSSStyleSheet.prototype) {
      return () => {
      };
    }
    const insertRule = win.CSSStyleSheet.prototype.insertRule;
    win.CSSStyleSheet.prototype.insertRule = new Proxy(insertRule, {
      apply: callbackWrapper((target, thisArg, argumentsList) => {
        const [rule, index] = argumentsList;
        const { id, styleId } = getIdAndStyleId(thisArg, mirror2, stylesheetManager.styleMirror);
        if (id && id !== -1 || styleId && styleId !== -1) {
          styleSheetRuleCb({
            id,
            styleId,
            adds: [{ rule, index }]
          });
        }
        return target.apply(thisArg, argumentsList);
      })
    });
    const deleteRule = win.CSSStyleSheet.prototype.deleteRule;
    win.CSSStyleSheet.prototype.deleteRule = new Proxy(deleteRule, {
      apply: callbackWrapper((target, thisArg, argumentsList) => {
        const [index] = argumentsList;
        const { id, styleId } = getIdAndStyleId(thisArg, mirror2, stylesheetManager.styleMirror);
        if (id && id !== -1 || styleId && styleId !== -1) {
          styleSheetRuleCb({
            id,
            styleId,
            removes: [{ index }]
          });
        }
        return target.apply(thisArg, argumentsList);
      })
    });
    let replace;
    if (win.CSSStyleSheet.prototype.replace) {
      replace = win.CSSStyleSheet.prototype.replace;
      win.CSSStyleSheet.prototype.replace = new Proxy(replace, {
        apply: callbackWrapper((target, thisArg, argumentsList) => {
          const [text] = argumentsList;
          const { id, styleId } = getIdAndStyleId(thisArg, mirror2, stylesheetManager.styleMirror);
          if (id && id !== -1 || styleId && styleId !== -1) {
            styleSheetRuleCb({
              id,
              styleId,
              replace: text
            });
          }
          return target.apply(thisArg, argumentsList);
        })
      });
    }
    let replaceSync;
    if (win.CSSStyleSheet.prototype.replaceSync) {
      replaceSync = win.CSSStyleSheet.prototype.replaceSync;
      win.CSSStyleSheet.prototype.replaceSync = new Proxy(replaceSync, {
        apply: callbackWrapper((target, thisArg, argumentsList) => {
          const [text] = argumentsList;
          const { id, styleId } = getIdAndStyleId(thisArg, mirror2, stylesheetManager.styleMirror);
          if (id && id !== -1 || styleId && styleId !== -1) {
            styleSheetRuleCb({
              id,
              styleId,
              replaceSync: text
            });
          }
          return target.apply(thisArg, argumentsList);
        })
      });
    }
    const supportedNestedCSSRuleTypes = {};
    if (canMonkeyPatchNestedCSSRule("CSSGroupingRule")) {
      supportedNestedCSSRuleTypes.CSSGroupingRule = win.CSSGroupingRule;
    } else {
      if (canMonkeyPatchNestedCSSRule("CSSMediaRule")) {
        supportedNestedCSSRuleTypes.CSSMediaRule = win.CSSMediaRule;
      }
      if (canMonkeyPatchNestedCSSRule("CSSConditionRule")) {
        supportedNestedCSSRuleTypes.CSSConditionRule = win.CSSConditionRule;
      }
      if (canMonkeyPatchNestedCSSRule("CSSSupportsRule")) {
        supportedNestedCSSRuleTypes.CSSSupportsRule = win.CSSSupportsRule;
      }
    }
    const unmodifiedFunctions = {};
    Object.entries(supportedNestedCSSRuleTypes).forEach(([typeKey, type]) => {
      unmodifiedFunctions[typeKey] = {
        insertRule: type.prototype.insertRule,
        deleteRule: type.prototype.deleteRule
      };
      type.prototype.insertRule = new Proxy(unmodifiedFunctions[typeKey].insertRule, {
        apply: callbackWrapper((target, thisArg, argumentsList) => {
          const [rule, index] = argumentsList;
          const { id, styleId } = getIdAndStyleId(thisArg.parentStyleSheet, mirror2, stylesheetManager.styleMirror);
          if (id && id !== -1 || styleId && styleId !== -1) {
            styleSheetRuleCb({
              id,
              styleId,
              adds: [
                {
                  rule,
                  index: [
                    ...getNestedCSSRulePositions(thisArg),
                    index || 0
                  ]
                }
              ]
            });
          }
          return target.apply(thisArg, argumentsList);
        })
      });
      type.prototype.deleteRule = new Proxy(unmodifiedFunctions[typeKey].deleteRule, {
        apply: callbackWrapper((target, thisArg, argumentsList) => {
          const [index] = argumentsList;
          const { id, styleId } = getIdAndStyleId(thisArg.parentStyleSheet, mirror2, stylesheetManager.styleMirror);
          if (id && id !== -1 || styleId && styleId !== -1) {
            styleSheetRuleCb({
              id,
              styleId,
              removes: [
                { index: [...getNestedCSSRulePositions(thisArg), index] }
              ]
            });
          }
          return target.apply(thisArg, argumentsList);
        })
      });
    });
    return callbackWrapper(() => {
      win.CSSStyleSheet.prototype.insertRule = insertRule;
      win.CSSStyleSheet.prototype.deleteRule = deleteRule;
      replace && (win.CSSStyleSheet.prototype.replace = replace);
      replaceSync && (win.CSSStyleSheet.prototype.replaceSync = replaceSync);
      Object.entries(supportedNestedCSSRuleTypes).forEach(([typeKey, type]) => {
        type.prototype.insertRule = unmodifiedFunctions[typeKey].insertRule;
        type.prototype.deleteRule = unmodifiedFunctions[typeKey].deleteRule;
      });
    });
  }
  function initAdoptedStyleSheetObserver({ mirror: mirror2, stylesheetManager }, host) {
    let hostId = null;
    if (host.nodeName === "#document")
      hostId = mirror2.getId(host);
    else
      hostId = mirror2.getId(host.host);
    const patchTarget = host.nodeName === "#document" ? _optionalChain$2([host, "access", (_4) => _4.defaultView, "optionalAccess", (_5) => _5.Document]) : _optionalChain$2([host, "access", (_6) => _6.ownerDocument, "optionalAccess", (_7) => _7.defaultView, "optionalAccess", (_8) => _8.ShadowRoot]);
    const originalPropertyDescriptor = _optionalChain$2([patchTarget, "optionalAccess", (_9) => _9.prototype]) ? Object.getOwnPropertyDescriptor(_optionalChain$2([patchTarget, "optionalAccess", (_10) => _10.prototype]), "adoptedStyleSheets") : void 0;
    if (hostId === null || hostId === -1 || !patchTarget || !originalPropertyDescriptor)
      return () => {
      };
    Object.defineProperty(host, "adoptedStyleSheets", {
      configurable: originalPropertyDescriptor.configurable,
      enumerable: originalPropertyDescriptor.enumerable,
      get() {
        return _optionalChain$2([originalPropertyDescriptor, "access", (_11) => _11.get, "optionalAccess", (_12) => _12.call, "call", (_13) => _13(this)]);
      },
      set(sheets) {
        const result = _optionalChain$2([originalPropertyDescriptor, "access", (_14) => _14.set, "optionalAccess", (_15) => _15.call, "call", (_16) => _16(this, sheets)]);
        if (hostId !== null && hostId !== -1) {
          try {
            stylesheetManager.adoptStyleSheets(sheets, hostId);
          } catch (e2) {
          }
        }
        return result;
      }
    });
    return callbackWrapper(() => {
      Object.defineProperty(host, "adoptedStyleSheets", {
        configurable: originalPropertyDescriptor.configurable,
        enumerable: originalPropertyDescriptor.enumerable,
        get: originalPropertyDescriptor.get,
        set: originalPropertyDescriptor.set
      });
    });
  }
  function initStyleDeclarationObserver({ styleDeclarationCb, mirror: mirror2, ignoreCSSAttributes, stylesheetManager }, { win }) {
    const setProperty = win.CSSStyleDeclaration.prototype.setProperty;
    win.CSSStyleDeclaration.prototype.setProperty = new Proxy(setProperty, {
      apply: callbackWrapper((target, thisArg, argumentsList) => {
        const [property, value, priority] = argumentsList;
        if (ignoreCSSAttributes.has(property)) {
          return setProperty.apply(thisArg, [property, value, priority]);
        }
        const { id, styleId } = getIdAndStyleId(_optionalChain$2([thisArg, "access", (_17) => _17.parentRule, "optionalAccess", (_18) => _18.parentStyleSheet]), mirror2, stylesheetManager.styleMirror);
        if (id && id !== -1 || styleId && styleId !== -1) {
          styleDeclarationCb({
            id,
            styleId,
            set: {
              property,
              value,
              priority
            },
            index: getNestedCSSRulePositions(thisArg.parentRule)
          });
        }
        return target.apply(thisArg, argumentsList);
      })
    });
    const removeProperty = win.CSSStyleDeclaration.prototype.removeProperty;
    win.CSSStyleDeclaration.prototype.removeProperty = new Proxy(removeProperty, {
      apply: callbackWrapper((target, thisArg, argumentsList) => {
        const [property] = argumentsList;
        if (ignoreCSSAttributes.has(property)) {
          return removeProperty.apply(thisArg, [property]);
        }
        const { id, styleId } = getIdAndStyleId(_optionalChain$2([thisArg, "access", (_19) => _19.parentRule, "optionalAccess", (_20) => _20.parentStyleSheet]), mirror2, stylesheetManager.styleMirror);
        if (id && id !== -1 || styleId && styleId !== -1) {
          styleDeclarationCb({
            id,
            styleId,
            remove: {
              property
            },
            index: getNestedCSSRulePositions(thisArg.parentRule)
          });
        }
        return target.apply(thisArg, argumentsList);
      })
    });
    return callbackWrapper(() => {
      win.CSSStyleDeclaration.prototype.setProperty = setProperty;
      win.CSSStyleDeclaration.prototype.removeProperty = removeProperty;
    });
  }
  function initMediaInteractionObserver({ mediaInteractionCb, blockClass, blockSelector, unblockSelector, mirror: mirror2, sampling, doc }) {
    const handler = callbackWrapper((type) => throttle$1(callbackWrapper((event) => {
      const target = getEventTarget2(event);
      if (!target || isBlocked(target, blockClass, blockSelector, unblockSelector, true)) {
        return;
      }
      const { currentTime, volume, muted, playbackRate } = target;
      mediaInteractionCb({
        type,
        id: mirror2.getId(target),
        currentTime,
        volume,
        muted,
        playbackRate
      });
    }), sampling.media || 500));
    const handlers4 = [
      on("play", handler(0), doc),
      on("pause", handler(1), doc),
      on("seeked", handler(2), doc),
      on("volumechange", handler(3), doc),
      on("ratechange", handler(4), doc)
    ];
    return callbackWrapper(() => {
      handlers4.forEach((h) => h());
    });
  }
  function initFontObserver({ fontCb, doc }) {
    const win = doc.defaultView;
    if (!win) {
      return () => {
      };
    }
    const handlers4 = [];
    const fontMap = /* @__PURE__ */ new WeakMap();
    const originalFontFace = win.FontFace;
    win.FontFace = function FontFace(family, source, descriptors) {
      const fontFace = new originalFontFace(family, source, descriptors);
      fontMap.set(fontFace, {
        family,
        buffer: typeof source !== "string",
        descriptors,
        fontSource: typeof source === "string" ? source : JSON.stringify(Array.from(new Uint8Array(source)))
      });
      return fontFace;
    };
    const restoreHandler = patch(doc.fonts, "add", function(original) {
      return function(fontFace) {
        setTimeout$1(callbackWrapper(() => {
          const p = fontMap.get(fontFace);
          if (p) {
            fontCb(p);
            fontMap.delete(fontFace);
          }
        }), 0);
        return original.apply(this, [fontFace]);
      };
    });
    handlers4.push(() => {
      win.FontFace = originalFontFace;
    });
    handlers4.push(restoreHandler);
    return callbackWrapper(() => {
      handlers4.forEach((h) => h());
    });
  }
  function initSelectionObserver(param) {
    const { doc, mirror: mirror2, blockClass, blockSelector, unblockSelector, selectionCb } = param;
    let collapsed = true;
    const updateSelection = callbackWrapper(() => {
      const selection = doc.getSelection();
      if (!selection || collapsed && _optionalChain$2([selection, "optionalAccess", (_21) => _21.isCollapsed]))
        return;
      collapsed = selection.isCollapsed || false;
      const ranges = [];
      const count = selection.rangeCount || 0;
      for (let i = 0; i < count; i++) {
        const range = selection.getRangeAt(i);
        const { startContainer, startOffset, endContainer, endOffset } = range;
        const blocked = isBlocked(startContainer, blockClass, blockSelector, unblockSelector, true) || isBlocked(endContainer, blockClass, blockSelector, unblockSelector, true);
        if (blocked)
          continue;
        ranges.push({
          start: mirror2.getId(startContainer),
          startOffset,
          end: mirror2.getId(endContainer),
          endOffset
        });
      }
      selectionCb({ ranges });
    });
    updateSelection();
    return on("selectionchange", updateSelection);
  }
  function initCustomElementObserver({ doc, customElementCb }) {
    const win = doc.defaultView;
    if (!win || !win.customElements)
      return () => {
      };
    const restoreHandler = patch(win.customElements, "define", function(original) {
      return function(name, constructor, options) {
        try {
          customElementCb({
            define: {
              name
            }
          });
        } catch (e2) {
        }
        return original.apply(this, [name, constructor, options]);
      };
    });
    return restoreHandler;
  }
  function initObservers(o, _hooks = {}) {
    const currentWindow = o.doc.defaultView;
    if (!currentWindow) {
      return () => {
      };
    }
    let mutationObserver;
    if (o.recordDOM) {
      mutationObserver = initMutationObserver(o, o.doc);
    }
    const mousemoveHandler = initMoveObserver(o);
    const mouseInteractionHandler = initMouseInteractionObserver(o);
    const scrollHandler = initScrollObserver(o);
    const viewportResizeHandler = initViewportResizeObserver(o, {
      win: currentWindow
    });
    const inputHandler = initInputObserver(o);
    const mediaInteractionHandler = initMediaInteractionObserver(o);
    let styleSheetObserver = () => {
    };
    let adoptedStyleSheetObserver = () => {
    };
    let styleDeclarationObserver = () => {
    };
    let fontObserver = () => {
    };
    if (o.recordDOM) {
      styleSheetObserver = initStyleSheetObserver(o, { win: currentWindow });
      adoptedStyleSheetObserver = initAdoptedStyleSheetObserver(o, o.doc);
      styleDeclarationObserver = initStyleDeclarationObserver(o, {
        win: currentWindow
      });
      if (o.collectFonts) {
        fontObserver = initFontObserver(o);
      }
    }
    const selectionObserver = initSelectionObserver(o);
    const customElementObserver = initCustomElementObserver(o);
    const pluginHandlers = [];
    for (const plugin of o.plugins) {
      pluginHandlers.push(plugin.observer(plugin.callback, currentWindow, plugin.options));
    }
    return callbackWrapper(() => {
      mutationBuffers.forEach((b) => b.reset());
      _optionalChain$2([mutationObserver, "optionalAccess", (_22) => _22.disconnect, "call", (_23) => _23()]);
      mousemoveHandler();
      mouseInteractionHandler();
      scrollHandler();
      viewportResizeHandler();
      inputHandler();
      mediaInteractionHandler();
      styleSheetObserver();
      adoptedStyleSheetObserver();
      styleDeclarationObserver();
      fontObserver();
      selectionObserver();
      customElementObserver();
      pluginHandlers.forEach((h) => h());
    });
  }
  function hasNestedCSSRule(prop) {
    return typeof window[prop] !== "undefined";
  }
  function canMonkeyPatchNestedCSSRule(prop) {
    return Boolean(typeof window[prop] !== "undefined" && window[prop].prototype && "insertRule" in window[prop].prototype && "deleteRule" in window[prop].prototype);
  }
  var CrossOriginIframeMirror = class {
    constructor(generateIdFn) {
      this.generateIdFn = generateIdFn;
      this.iframeIdToRemoteIdMap = /* @__PURE__ */ new WeakMap();
      this.iframeRemoteIdToIdMap = /* @__PURE__ */ new WeakMap();
    }
    getId(iframe, remoteId, idToRemoteMap, remoteToIdMap) {
      const idToRemoteIdMap = idToRemoteMap || this.getIdToRemoteIdMap(iframe);
      const remoteIdToIdMap = remoteToIdMap || this.getRemoteIdToIdMap(iframe);
      let id = idToRemoteIdMap.get(remoteId);
      if (!id) {
        id = this.generateIdFn();
        idToRemoteIdMap.set(remoteId, id);
        remoteIdToIdMap.set(id, remoteId);
      }
      return id;
    }
    getIds(iframe, remoteId) {
      const idToRemoteIdMap = this.getIdToRemoteIdMap(iframe);
      const remoteIdToIdMap = this.getRemoteIdToIdMap(iframe);
      return remoteId.map((id) => this.getId(iframe, id, idToRemoteIdMap, remoteIdToIdMap));
    }
    getRemoteId(iframe, id, map) {
      const remoteIdToIdMap = map || this.getRemoteIdToIdMap(iframe);
      if (typeof id !== "number")
        return id;
      const remoteId = remoteIdToIdMap.get(id);
      if (!remoteId)
        return -1;
      return remoteId;
    }
    getRemoteIds(iframe, ids) {
      const remoteIdToIdMap = this.getRemoteIdToIdMap(iframe);
      return ids.map((id) => this.getRemoteId(iframe, id, remoteIdToIdMap));
    }
    reset(iframe) {
      if (!iframe) {
        this.iframeIdToRemoteIdMap = /* @__PURE__ */ new WeakMap();
        this.iframeRemoteIdToIdMap = /* @__PURE__ */ new WeakMap();
        return;
      }
      this.iframeIdToRemoteIdMap.delete(iframe);
      this.iframeRemoteIdToIdMap.delete(iframe);
    }
    getIdToRemoteIdMap(iframe) {
      let idToRemoteIdMap = this.iframeIdToRemoteIdMap.get(iframe);
      if (!idToRemoteIdMap) {
        idToRemoteIdMap = /* @__PURE__ */ new Map();
        this.iframeIdToRemoteIdMap.set(iframe, idToRemoteIdMap);
      }
      return idToRemoteIdMap;
    }
    getRemoteIdToIdMap(iframe) {
      let remoteIdToIdMap = this.iframeRemoteIdToIdMap.get(iframe);
      if (!remoteIdToIdMap) {
        remoteIdToIdMap = /* @__PURE__ */ new Map();
        this.iframeRemoteIdToIdMap.set(iframe, remoteIdToIdMap);
      }
      return remoteIdToIdMap;
    }
  };
  function _optionalChain$1(ops) {
    let lastAccessLHS = void 0;
    let value = ops[0];
    let i = 1;
    while (i < ops.length) {
      const op = ops[i];
      const fn = ops[i + 1];
      i += 2;
      if ((op === "optionalAccess" || op === "optionalCall") && value == null) {
        return void 0;
      }
      if (op === "access" || op === "optionalAccess") {
        lastAccessLHS = value;
        value = fn(value);
      } else if (op === "call" || op === "optionalCall") {
        value = fn((...args) => value.call(lastAccessLHS, ...args));
        lastAccessLHS = void 0;
      }
    }
    return value;
  }
  var IframeManagerNoop = class {
    constructor() {
      this.crossOriginIframeMirror = new CrossOriginIframeMirror(genId);
      this.crossOriginIframeRootIdMap = /* @__PURE__ */ new WeakMap();
    }
    addIframe() {
    }
    addLoadListener() {
    }
    attachIframe() {
    }
  };
  var IframeManager = class {
    constructor(options) {
      this.iframes = /* @__PURE__ */ new WeakMap();
      this.crossOriginIframeMap = /* @__PURE__ */ new WeakMap();
      this.crossOriginIframeMirror = new CrossOriginIframeMirror(genId);
      this.crossOriginIframeRootIdMap = /* @__PURE__ */ new WeakMap();
      this.mutationCb = options.mutationCb;
      this.wrappedEmit = options.wrappedEmit;
      this.stylesheetManager = options.stylesheetManager;
      this.recordCrossOriginIframes = options.recordCrossOriginIframes;
      this.crossOriginIframeStyleMirror = new CrossOriginIframeMirror(this.stylesheetManager.styleMirror.generateId.bind(this.stylesheetManager.styleMirror));
      this.mirror = options.mirror;
      if (this.recordCrossOriginIframes) {
        window.addEventListener("message", this.handleMessage.bind(this));
      }
    }
    addIframe(iframeEl) {
      this.iframes.set(iframeEl, true);
      if (iframeEl.contentWindow)
        this.crossOriginIframeMap.set(iframeEl.contentWindow, iframeEl);
    }
    addLoadListener(cb) {
      this.loadListener = cb;
    }
    attachIframe(iframeEl, childSn) {
      this.mutationCb({
        adds: [
          {
            parentId: this.mirror.getId(iframeEl),
            nextId: null,
            node: childSn
          }
        ],
        removes: [],
        texts: [],
        attributes: [],
        isAttachIframe: true
      });
      _optionalChain$1([this, "access", (_) => _.loadListener, "optionalCall", (_2) => _2(iframeEl)]);
      if (iframeEl.contentDocument && iframeEl.contentDocument.adoptedStyleSheets && iframeEl.contentDocument.adoptedStyleSheets.length > 0)
        this.stylesheetManager.adoptStyleSheets(iframeEl.contentDocument.adoptedStyleSheets, this.mirror.getId(iframeEl.contentDocument));
    }
    handleMessage(message) {
      const crossOriginMessageEvent = message;
      if (crossOriginMessageEvent.data.type !== "rrweb" || crossOriginMessageEvent.origin !== crossOriginMessageEvent.data.origin)
        return;
      const iframeSourceWindow = message.source;
      if (!iframeSourceWindow)
        return;
      const iframeEl = this.crossOriginIframeMap.get(message.source);
      if (!iframeEl)
        return;
      const transformedEvent = this.transformCrossOriginEvent(iframeEl, crossOriginMessageEvent.data.event);
      if (transformedEvent)
        this.wrappedEmit(transformedEvent, crossOriginMessageEvent.data.isCheckout);
    }
    transformCrossOriginEvent(iframeEl, e2) {
      switch (e2.type) {
        case EventType.FullSnapshot: {
          this.crossOriginIframeMirror.reset(iframeEl);
          this.crossOriginIframeStyleMirror.reset(iframeEl);
          this.replaceIdOnNode(e2.data.node, iframeEl);
          const rootId = e2.data.node.id;
          this.crossOriginIframeRootIdMap.set(iframeEl, rootId);
          this.patchRootIdOnNode(e2.data.node, rootId);
          return {
            timestamp: e2.timestamp,
            type: EventType.IncrementalSnapshot,
            data: {
              source: IncrementalSource.Mutation,
              adds: [
                {
                  parentId: this.mirror.getId(iframeEl),
                  nextId: null,
                  node: e2.data.node
                }
              ],
              removes: [],
              texts: [],
              attributes: [],
              isAttachIframe: true
            }
          };
        }
        case EventType.Meta:
        case EventType.Load:
        case EventType.DomContentLoaded: {
          return false;
        }
        case EventType.Plugin: {
          return e2;
        }
        case EventType.Custom: {
          this.replaceIds(e2.data.payload, iframeEl, ["id", "parentId", "previousId", "nextId"]);
          return e2;
        }
        case EventType.IncrementalSnapshot: {
          switch (e2.data.source) {
            case IncrementalSource.Mutation: {
              e2.data.adds.forEach((n) => {
                this.replaceIds(n, iframeEl, [
                  "parentId",
                  "nextId",
                  "previousId"
                ]);
                this.replaceIdOnNode(n.node, iframeEl);
                const rootId = this.crossOriginIframeRootIdMap.get(iframeEl);
                rootId && this.patchRootIdOnNode(n.node, rootId);
              });
              e2.data.removes.forEach((n) => {
                this.replaceIds(n, iframeEl, ["parentId", "id"]);
              });
              e2.data.attributes.forEach((n) => {
                this.replaceIds(n, iframeEl, ["id"]);
              });
              e2.data.texts.forEach((n) => {
                this.replaceIds(n, iframeEl, ["id"]);
              });
              return e2;
            }
            case IncrementalSource.Drag:
            case IncrementalSource.TouchMove:
            case IncrementalSource.MouseMove: {
              e2.data.positions.forEach((p) => {
                this.replaceIds(p, iframeEl, ["id"]);
              });
              return e2;
            }
            case IncrementalSource.ViewportResize: {
              return false;
            }
            case IncrementalSource.MediaInteraction:
            case IncrementalSource.MouseInteraction:
            case IncrementalSource.Scroll:
            case IncrementalSource.CanvasMutation:
            case IncrementalSource.Input: {
              this.replaceIds(e2.data, iframeEl, ["id"]);
              return e2;
            }
            case IncrementalSource.StyleSheetRule:
            case IncrementalSource.StyleDeclaration: {
              this.replaceIds(e2.data, iframeEl, ["id"]);
              this.replaceStyleIds(e2.data, iframeEl, ["styleId"]);
              return e2;
            }
            case IncrementalSource.Font: {
              return e2;
            }
            case IncrementalSource.Selection: {
              e2.data.ranges.forEach((range) => {
                this.replaceIds(range, iframeEl, ["start", "end"]);
              });
              return e2;
            }
            case IncrementalSource.AdoptedStyleSheet: {
              this.replaceIds(e2.data, iframeEl, ["id"]);
              this.replaceStyleIds(e2.data, iframeEl, ["styleIds"]);
              _optionalChain$1([e2, "access", (_3) => _3.data, "access", (_4) => _4.styles, "optionalAccess", (_5) => _5.forEach, "call", (_6) => _6((style) => {
                this.replaceStyleIds(style, iframeEl, ["styleId"]);
              })]);
              return e2;
            }
          }
        }
      }
      return false;
    }
    replace(iframeMirror, obj, iframeEl, keys) {
      for (const key of keys) {
        if (!Array.isArray(obj[key]) && typeof obj[key] !== "number")
          continue;
        if (Array.isArray(obj[key])) {
          obj[key] = iframeMirror.getIds(iframeEl, obj[key]);
        } else {
          obj[key] = iframeMirror.getId(iframeEl, obj[key]);
        }
      }
      return obj;
    }
    replaceIds(obj, iframeEl, keys) {
      return this.replace(this.crossOriginIframeMirror, obj, iframeEl, keys);
    }
    replaceStyleIds(obj, iframeEl, keys) {
      return this.replace(this.crossOriginIframeStyleMirror, obj, iframeEl, keys);
    }
    replaceIdOnNode(node, iframeEl) {
      this.replaceIds(node, iframeEl, ["id", "rootId"]);
      if ("childNodes" in node) {
        node.childNodes.forEach((child) => {
          this.replaceIdOnNode(child, iframeEl);
        });
      }
    }
    patchRootIdOnNode(node, rootId) {
      if (node.type !== NodeType$1.Document && !node.rootId)
        node.rootId = rootId;
      if ("childNodes" in node) {
        node.childNodes.forEach((child) => {
          this.patchRootIdOnNode(child, rootId);
        });
      }
    }
  };
  var ShadowDomManagerNoop = class {
    init() {
    }
    addShadowRoot() {
    }
    observeAttachShadow() {
    }
    reset() {
    }
  };
  var ShadowDomManager = class {
    constructor(options) {
      this.shadowDoms = /* @__PURE__ */ new WeakSet();
      this.restoreHandlers = [];
      this.mutationCb = options.mutationCb;
      this.scrollCb = options.scrollCb;
      this.bypassOptions = options.bypassOptions;
      this.mirror = options.mirror;
      this.init();
    }
    init() {
      this.reset();
      this.patchAttachShadow(Element, document);
    }
    addShadowRoot(shadowRoot, doc) {
      if (!isNativeShadowDom(shadowRoot))
        return;
      if (this.shadowDoms.has(shadowRoot))
        return;
      this.shadowDoms.add(shadowRoot);
      this.bypassOptions.canvasManager.addShadowRoot(shadowRoot);
      const observer = initMutationObserver({
        ...this.bypassOptions,
        doc,
        mutationCb: this.mutationCb,
        mirror: this.mirror,
        shadowDomManager: this
      }, shadowRoot);
      this.restoreHandlers.push(() => observer.disconnect());
      this.restoreHandlers.push(initScrollObserver({
        ...this.bypassOptions,
        scrollCb: this.scrollCb,
        doc: shadowRoot,
        mirror: this.mirror
      }));
      setTimeout$1(() => {
        if (shadowRoot.adoptedStyleSheets && shadowRoot.adoptedStyleSheets.length > 0)
          this.bypassOptions.stylesheetManager.adoptStyleSheets(shadowRoot.adoptedStyleSheets, this.mirror.getId(shadowRoot.host));
        this.restoreHandlers.push(initAdoptedStyleSheetObserver({
          mirror: this.mirror,
          stylesheetManager: this.bypassOptions.stylesheetManager
        }, shadowRoot));
      }, 0);
    }
    observeAttachShadow(iframeElement) {
      if (!iframeElement.contentWindow || !iframeElement.contentDocument)
        return;
      this.patchAttachShadow(iframeElement.contentWindow.Element, iframeElement.contentDocument);
    }
    patchAttachShadow(element, doc) {
      const manager = this;
      this.restoreHandlers.push(patch(element.prototype, "attachShadow", function(original) {
        return function(option) {
          const shadowRoot = original.call(this, option);
          if (this.shadowRoot && inDom(this))
            manager.addShadowRoot(this.shadowRoot, doc);
          return shadowRoot;
        };
      }));
    }
    reset() {
      this.restoreHandlers.forEach((handler) => {
        try {
          handler();
        } catch (e2) {
        }
      });
      this.restoreHandlers = [];
      this.shadowDoms = /* @__PURE__ */ new WeakSet();
      this.bypassOptions.canvasManager.resetShadowRoots();
    }
  };
  var CanvasManagerNoop = class {
    reset() {
    }
    freeze() {
    }
    unfreeze() {
    }
    lock() {
    }
    unlock() {
    }
    snapshot() {
    }
    addWindow() {
    }
    addShadowRoot() {
    }
    resetShadowRoots() {
    }
  };
  var StylesheetManager = class {
    constructor(options) {
      this.trackedLinkElements = /* @__PURE__ */ new WeakSet();
      this.styleMirror = new StyleSheetMirror();
      this.mutationCb = options.mutationCb;
      this.adoptedStyleSheetCb = options.adoptedStyleSheetCb;
    }
    attachLinkElement(linkEl, childSn) {
      if ("_cssText" in childSn.attributes)
        this.mutationCb({
          adds: [],
          removes: [],
          texts: [],
          attributes: [
            {
              id: childSn.id,
              attributes: childSn.attributes
            }
          ]
        });
      this.trackLinkElement(linkEl);
    }
    trackLinkElement(linkEl) {
      if (this.trackedLinkElements.has(linkEl))
        return;
      this.trackedLinkElements.add(linkEl);
      this.trackStylesheetInLinkElement(linkEl);
    }
    adoptStyleSheets(sheets, hostId) {
      if (sheets.length === 0)
        return;
      const adoptedStyleSheetData = {
        id: hostId,
        styleIds: []
      };
      const styles = [];
      for (const sheet of sheets) {
        let styleId;
        if (!this.styleMirror.has(sheet)) {
          styleId = this.styleMirror.add(sheet);
          styles.push({
            styleId,
            rules: Array.from(sheet.rules || CSSRule, (r2, index) => ({
              rule: stringifyRule(r2),
              index
            }))
          });
        } else
          styleId = this.styleMirror.getId(sheet);
        adoptedStyleSheetData.styleIds.push(styleId);
      }
      if (styles.length > 0)
        adoptedStyleSheetData.styles = styles;
      this.adoptedStyleSheetCb(adoptedStyleSheetData);
    }
    reset() {
      this.styleMirror.reset();
      this.trackedLinkElements = /* @__PURE__ */ new WeakSet();
    }
    trackStylesheetInLinkElement(linkEl) {
    }
  };
  var ProcessedNodeManager = class {
    constructor() {
      this.nodeMap = /* @__PURE__ */ new WeakMap();
      this.active = false;
    }
    inOtherBuffer(node, thisBuffer) {
      const buffers = this.nodeMap.get(node);
      return buffers && Array.from(buffers).some((buffer) => buffer !== thisBuffer);
    }
    add(node, buffer) {
      if (!this.active) {
        this.active = true;
        onRequestAnimationFrame(() => {
          this.nodeMap = /* @__PURE__ */ new WeakMap();
          this.active = false;
        });
      }
      this.nodeMap.set(node, (this.nodeMap.get(node) || /* @__PURE__ */ new Set()).add(buffer));
    }
    destroy() {
    }
  };
  var wrappedEmit;
  var _takeFullSnapshot;
  try {
    if (Array.from([1], (x) => x * 2)[0] !== 2) {
      const cleanFrame = document.createElement("iframe");
      document.body.appendChild(cleanFrame);
      Array.from = _optionalChain([cleanFrame, "access", (_) => _.contentWindow, "optionalAccess", (_2) => _2.Array, "access", (_3) => _3.from]) || Array.from;
      document.body.removeChild(cleanFrame);
    }
  } catch (err) {
    console.debug("Unable to override Array.from", err);
  }
  var mirror = createMirror();
  function record(options = {}) {
    const { emit, checkoutEveryNms, checkoutEveryNth, blockClass = "rr-block", blockSelector = null, unblockSelector = null, ignoreClass = "rr-ignore", ignoreSelector = null, maskAllText = false, maskTextClass = "rr-mask", unmaskTextClass = null, maskTextSelector = null, unmaskTextSelector = null, inlineStylesheet = true, maskAllInputs, maskInputOptions: _maskInputOptions, slimDOMOptions: _slimDOMOptions, maskAttributeFn, maskInputFn, maskTextFn, maxCanvasSize = null, packFn, sampling = {}, dataURLOptions = {}, mousemoveWait, recordDOM = true, recordCanvas = false, recordCrossOriginIframes = false, recordAfter = options.recordAfter === "DOMContentLoaded" ? options.recordAfter : "load", userTriggeredOnInput = false, collectFonts = false, inlineImages = false, plugins, keepIframeSrcFn = () => false, ignoreCSSAttributes = /* @__PURE__ */ new Set([]), errorHandler: errorHandler2, onMutation, getCanvasManager } = options;
    registerErrorHandler(errorHandler2);
    const inEmittingFrame = recordCrossOriginIframes ? window.parent === window : true;
    let passEmitsToParent = false;
    if (!inEmittingFrame) {
      try {
        if (window.parent.document) {
          passEmitsToParent = false;
        }
      } catch (e2) {
        passEmitsToParent = true;
      }
    }
    if (inEmittingFrame && !emit) {
      throw new Error("emit function is required");
    }
    if (!inEmittingFrame && !passEmitsToParent) {
      return () => {
      };
    }
    if (mousemoveWait !== void 0 && sampling.mousemove === void 0) {
      sampling.mousemove = mousemoveWait;
    }
    mirror.reset();
    const maskInputOptions = maskAllInputs === true ? {
      color: true,
      date: true,
      "datetime-local": true,
      email: true,
      month: true,
      number: true,
      range: true,
      search: true,
      tel: true,
      text: true,
      time: true,
      url: true,
      week: true,
      textarea: true,
      select: true,
      radio: true,
      checkbox: true
    } : _maskInputOptions !== void 0 ? _maskInputOptions : {};
    const slimDOMOptions = _slimDOMOptions === true || _slimDOMOptions === "all" ? {
      script: true,
      comment: true,
      headFavicon: true,
      headWhitespace: true,
      headMetaSocial: true,
      headMetaRobots: true,
      headMetaHttpEquiv: true,
      headMetaVerification: true,
      headMetaAuthorship: _slimDOMOptions === "all",
      headMetaDescKeywords: _slimDOMOptions === "all"
    } : _slimDOMOptions ? _slimDOMOptions : {};
    polyfill();
    let lastFullSnapshotEvent;
    let incrementalSnapshotCount = 0;
    const eventProcessor = (e2) => {
      for (const plugin of plugins || []) {
        if (plugin.eventProcessor) {
          e2 = plugin.eventProcessor(e2);
        }
      }
      if (packFn && !passEmitsToParent) {
        e2 = packFn(e2);
      }
      return e2;
    };
    wrappedEmit = (r2, isCheckout) => {
      const e2 = r2;
      e2.timestamp = nowTimestamp();
      if (_optionalChain([mutationBuffers, "access", (_4) => _4[0], "optionalAccess", (_5) => _5.isFrozen, "call", (_6) => _6()]) && e2.type !== EventType.FullSnapshot && !(e2.type === EventType.IncrementalSnapshot && e2.data.source === IncrementalSource.Mutation)) {
        mutationBuffers.forEach((buf) => buf.unfreeze());
      }
      if (inEmittingFrame) {
        _optionalChain([emit, "optionalCall", (_7) => _7(eventProcessor(e2), isCheckout)]);
      } else if (passEmitsToParent) {
        const message = {
          type: "rrweb",
          event: eventProcessor(e2),
          origin: window.location.origin,
          isCheckout
        };
        window.parent.postMessage(message, "*");
      }
      if (e2.type === EventType.FullSnapshot) {
        lastFullSnapshotEvent = e2;
        incrementalSnapshotCount = 0;
      } else if (e2.type === EventType.IncrementalSnapshot) {
        if (e2.data.source === IncrementalSource.Mutation && e2.data.isAttachIframe) {
          return;
        }
        incrementalSnapshotCount++;
        const exceedCount = checkoutEveryNth && incrementalSnapshotCount >= checkoutEveryNth;
        const exceedTime = checkoutEveryNms && lastFullSnapshotEvent && e2.timestamp - lastFullSnapshotEvent.timestamp > checkoutEveryNms;
        if (exceedCount || exceedTime) {
          takeFullSnapshot2(true);
        }
      }
    };
    const wrappedMutationEmit = (m2) => {
      wrappedEmit({
        type: EventType.IncrementalSnapshot,
        data: {
          source: IncrementalSource.Mutation,
          ...m2
        }
      });
    };
    const wrappedScrollEmit = (p) => wrappedEmit({
      type: EventType.IncrementalSnapshot,
      data: {
        source: IncrementalSource.Scroll,
        ...p
      }
    });
    const wrappedCanvasMutationEmit = (p) => wrappedEmit({
      type: EventType.IncrementalSnapshot,
      data: {
        source: IncrementalSource.CanvasMutation,
        ...p
      }
    });
    const wrappedAdoptedStyleSheetEmit = (a) => wrappedEmit({
      type: EventType.IncrementalSnapshot,
      data: {
        source: IncrementalSource.AdoptedStyleSheet,
        ...a
      }
    });
    const stylesheetManager = new StylesheetManager({
      mutationCb: wrappedMutationEmit,
      adoptedStyleSheetCb: wrappedAdoptedStyleSheetEmit
    });
    const iframeManager = typeof __RRWEB_EXCLUDE_IFRAME__ === "boolean" && __RRWEB_EXCLUDE_IFRAME__ ? new IframeManagerNoop() : new IframeManager({
      mirror,
      mutationCb: wrappedMutationEmit,
      stylesheetManager,
      recordCrossOriginIframes,
      wrappedEmit
    });
    for (const plugin of plugins || []) {
      if (plugin.getMirror)
        plugin.getMirror({
          nodeMirror: mirror,
          crossOriginIframeMirror: iframeManager.crossOriginIframeMirror,
          crossOriginIframeStyleMirror: iframeManager.crossOriginIframeStyleMirror
        });
    }
    const processedNodeManager = new ProcessedNodeManager();
    const canvasManager = _getCanvasManager(getCanvasManager, {
      mirror,
      win: window,
      mutationCb: (p) => wrappedEmit({
        type: EventType.IncrementalSnapshot,
        data: {
          source: IncrementalSource.CanvasMutation,
          ...p
        }
      }),
      recordCanvas,
      blockClass,
      blockSelector,
      unblockSelector,
      maxCanvasSize,
      sampling: sampling["canvas"],
      dataURLOptions,
      errorHandler: errorHandler2
    });
    const shadowDomManager = typeof __RRWEB_EXCLUDE_SHADOW_DOM__ === "boolean" && __RRWEB_EXCLUDE_SHADOW_DOM__ ? new ShadowDomManagerNoop() : new ShadowDomManager({
      mutationCb: wrappedMutationEmit,
      scrollCb: wrappedScrollEmit,
      bypassOptions: {
        onMutation,
        blockClass,
        blockSelector,
        unblockSelector,
        maskAllText,
        maskTextClass,
        unmaskTextClass,
        maskTextSelector,
        unmaskTextSelector,
        inlineStylesheet,
        maskInputOptions,
        dataURLOptions,
        maskAttributeFn,
        maskTextFn,
        maskInputFn,
        recordCanvas,
        inlineImages,
        sampling,
        slimDOMOptions,
        iframeManager,
        stylesheetManager,
        canvasManager,
        keepIframeSrcFn,
        processedNodeManager
      },
      mirror
    });
    const takeFullSnapshot2 = (isCheckout = false) => {
      if (!recordDOM) {
        return;
      }
      wrappedEmit({
        type: EventType.Meta,
        data: {
          href: window.location.href,
          width: getWindowWidth(),
          height: getWindowHeight()
        }
      }, isCheckout);
      stylesheetManager.reset();
      shadowDomManager.init();
      mutationBuffers.forEach((buf) => buf.lock());
      const node = snapshot(document, {
        mirror,
        blockClass,
        blockSelector,
        unblockSelector,
        maskAllText,
        maskTextClass,
        unmaskTextClass,
        maskTextSelector,
        unmaskTextSelector,
        inlineStylesheet,
        maskAllInputs: maskInputOptions,
        maskAttributeFn,
        maskInputFn,
        maskTextFn,
        slimDOM: slimDOMOptions,
        dataURLOptions,
        recordCanvas,
        inlineImages,
        onSerialize: (n) => {
          if (isSerializedIframe(n, mirror)) {
            iframeManager.addIframe(n);
          }
          if (isSerializedStylesheet(n, mirror)) {
            stylesheetManager.trackLinkElement(n);
          }
          if (hasShadowRoot(n)) {
            shadowDomManager.addShadowRoot(n.shadowRoot, document);
          }
        },
        onIframeLoad: (iframe, childSn) => {
          iframeManager.attachIframe(iframe, childSn);
          if (iframe.contentWindow) {
            canvasManager.addWindow(iframe.contentWindow);
          }
          shadowDomManager.observeAttachShadow(iframe);
        },
        onStylesheetLoad: (linkEl, childSn) => {
          stylesheetManager.attachLinkElement(linkEl, childSn);
        },
        keepIframeSrcFn
      });
      if (!node) {
        return console.warn("Failed to snapshot the document");
      }
      wrappedEmit({
        type: EventType.FullSnapshot,
        data: {
          node,
          initialOffset: getWindowScroll(window)
        }
      });
      mutationBuffers.forEach((buf) => buf.unlock());
      if (document.adoptedStyleSheets && document.adoptedStyleSheets.length > 0)
        stylesheetManager.adoptStyleSheets(document.adoptedStyleSheets, mirror.getId(document));
    };
    _takeFullSnapshot = takeFullSnapshot2;
    try {
      const handlers4 = [];
      const observe2 = (doc) => {
        return callbackWrapper(initObservers)({
          onMutation,
          mutationCb: wrappedMutationEmit,
          mousemoveCb: (positions, source) => wrappedEmit({
            type: EventType.IncrementalSnapshot,
            data: {
              source,
              positions
            }
          }),
          mouseInteractionCb: (d) => wrappedEmit({
            type: EventType.IncrementalSnapshot,
            data: {
              source: IncrementalSource.MouseInteraction,
              ...d
            }
          }),
          scrollCb: wrappedScrollEmit,
          viewportResizeCb: (d) => wrappedEmit({
            type: EventType.IncrementalSnapshot,
            data: {
              source: IncrementalSource.ViewportResize,
              ...d
            }
          }),
          inputCb: (v) => wrappedEmit({
            type: EventType.IncrementalSnapshot,
            data: {
              source: IncrementalSource.Input,
              ...v
            }
          }),
          mediaInteractionCb: (p) => wrappedEmit({
            type: EventType.IncrementalSnapshot,
            data: {
              source: IncrementalSource.MediaInteraction,
              ...p
            }
          }),
          styleSheetRuleCb: (r2) => wrappedEmit({
            type: EventType.IncrementalSnapshot,
            data: {
              source: IncrementalSource.StyleSheetRule,
              ...r2
            }
          }),
          styleDeclarationCb: (r2) => wrappedEmit({
            type: EventType.IncrementalSnapshot,
            data: {
              source: IncrementalSource.StyleDeclaration,
              ...r2
            }
          }),
          canvasMutationCb: wrappedCanvasMutationEmit,
          fontCb: (p) => wrappedEmit({
            type: EventType.IncrementalSnapshot,
            data: {
              source: IncrementalSource.Font,
              ...p
            }
          }),
          selectionCb: (p) => {
            wrappedEmit({
              type: EventType.IncrementalSnapshot,
              data: {
                source: IncrementalSource.Selection,
                ...p
              }
            });
          },
          customElementCb: (c) => {
            wrappedEmit({
              type: EventType.IncrementalSnapshot,
              data: {
                source: IncrementalSource.CustomElement,
                ...c
              }
            });
          },
          blockClass,
          ignoreClass,
          ignoreSelector,
          maskAllText,
          maskTextClass,
          unmaskTextClass,
          maskTextSelector,
          unmaskTextSelector,
          maskInputOptions,
          inlineStylesheet,
          sampling,
          recordDOM,
          recordCanvas,
          inlineImages,
          userTriggeredOnInput,
          collectFonts,
          doc,
          maskAttributeFn,
          maskInputFn,
          maskTextFn,
          keepIframeSrcFn,
          blockSelector,
          unblockSelector,
          slimDOMOptions,
          dataURLOptions,
          mirror,
          iframeManager,
          stylesheetManager,
          shadowDomManager,
          processedNodeManager,
          canvasManager,
          ignoreCSSAttributes,
          plugins: _optionalChain([
            plugins,
            "optionalAccess",
            (_8) => _8.filter,
            "call",
            (_9) => _9((p) => p.observer),
            "optionalAccess",
            (_10) => _10.map,
            "call",
            (_11) => _11((p) => ({
              observer: p.observer,
              options: p.options,
              callback: (payload) => wrappedEmit({
                type: EventType.Plugin,
                data: {
                  plugin: p.name,
                  payload
                }
              })
            }))
          ]) || []
        }, {});
      };
      iframeManager.addLoadListener((iframeEl) => {
        try {
          handlers4.push(observe2(iframeEl.contentDocument));
        } catch (error) {
          console.warn(error);
        }
      });
      const init2 = () => {
        takeFullSnapshot2();
        handlers4.push(observe2(document));
      };
      if (document.readyState === "interactive" || document.readyState === "complete") {
        init2();
      } else {
        handlers4.push(on("DOMContentLoaded", () => {
          wrappedEmit({
            type: EventType.DomContentLoaded,
            data: {}
          });
          if (recordAfter === "DOMContentLoaded")
            init2();
        }));
        handlers4.push(on("load", () => {
          wrappedEmit({
            type: EventType.Load,
            data: {}
          });
          if (recordAfter === "load")
            init2();
        }, window));
      }
      return () => {
        handlers4.forEach((h) => h());
        processedNodeManager.destroy();
        _takeFullSnapshot = void 0;
        unregisterErrorHandler();
      };
    } catch (error) {
      console.warn(error);
    }
  }
  function takeFullSnapshot(isCheckout) {
    if (!_takeFullSnapshot) {
      throw new Error("please take full snapshot after start recording");
    }
    _takeFullSnapshot(isCheckout);
  }
  record.mirror = mirror;
  record.takeFullSnapshot = takeFullSnapshot;
  function _getCanvasManager(getCanvasManagerFn, options) {
    try {
      return getCanvasManagerFn ? getCanvasManagerFn(options) : new CanvasManagerNoop();
    } catch (e2) {
      console.warn("Unable to initialize CanvasManager");
      return new CanvasManagerNoop();
    }
  }
  var DEBUG_BUILD5 = typeof __SENTRY_DEBUG__ === "undefined" || __SENTRY_DEBUG__;
  var CONSOLE_LEVELS2 = ["info", "warn", "error", "log"];
  var PREFIX2 = "[Replay] ";
  function _addBreadcrumb(message, level = "info") {
    addBreadcrumb(
      {
        category: "console",
        data: {
          logger: "replay"
        },
        level,
        message: `${PREFIX2}${message}`
      },
      { level }
    );
  }
  function makeReplayLogger() {
    let _capture = false;
    let _trace = false;
    const _logger = {
      exception: () => void 0,
      infoTick: () => void 0,
      setConfig: (opts) => {
        _capture = opts.captureExceptions;
        _trace = opts.traceInternals;
      }
    };
    if (DEBUG_BUILD5) {
      CONSOLE_LEVELS2.forEach((name) => {
        _logger[name] = (...args) => {
          logger[name](PREFIX2, ...args);
          if (_trace) {
            _addBreadcrumb(args.join(""), severityLevelFromString(name));
          }
        };
      });
      _logger.exception = (error, ...message) => {
        if (message.length && _logger.error) {
          _logger.error(...message);
        }
        logger.error(PREFIX2, error);
        if (_capture) {
          captureException(error);
        } else if (_trace) {
          _addBreadcrumb(error, "error");
        }
      };
      _logger.infoTick = (...args) => {
        logger.info(PREFIX2, ...args);
        if (_trace) {
          setTimeout(() => _addBreadcrumb(args[0]), 0);
        }
      };
    } else {
      CONSOLE_LEVELS2.forEach((name) => {
        _logger[name] = () => void 0;
      });
    }
    return _logger;
  }
  var logger2 = makeReplayLogger();
  var ReplayEventTypeIncrementalSnapshot = 3;
  var ReplayEventTypeCustom = 5;
  function timestampToMs(timestamp) {
    const isMs = timestamp > 9999999999;
    return isMs ? timestamp : timestamp * 1e3;
  }
  function timestampToS(timestamp) {
    const isMs = timestamp > 9999999999;
    return isMs ? timestamp / 1e3 : timestamp;
  }
  function addBreadcrumbEvent(replay, breadcrumb) {
    if (breadcrumb.category === "sentry.transaction") {
      return;
    }
    if (["ui.click", "ui.input"].includes(breadcrumb.category)) {
      replay.triggerUserActivity();
    } else {
      replay.checkAndHandleExpiredSession();
    }
    replay.addUpdate(() => {
      replay.throttledAddEvent({
        type: EventType.Custom,
        // TODO: We were converting from ms to seconds for breadcrumbs, spans,
        // but maybe we should just keep them as milliseconds
        timestamp: (breadcrumb.timestamp || 0) * 1e3,
        data: {
          tag: "breadcrumb",
          // normalize to max. 10 depth and 1_000 properties per object
          payload: normalize(breadcrumb, 10, 1e3)
        }
      });
      return breadcrumb.category === "console";
    });
  }
  var INTERACTIVE_SELECTOR = "button,a";
  function getClosestInteractive(element) {
    const closestInteractive = element.closest(INTERACTIVE_SELECTOR);
    return closestInteractive || element;
  }
  function getClickTargetNode(event) {
    const target = getTargetNode(event);
    if (!target || !(target instanceof Element)) {
      return target;
    }
    return getClosestInteractive(target);
  }
  function getTargetNode(event) {
    if (isEventWithTarget(event)) {
      return event.target;
    }
    return event;
  }
  function isEventWithTarget(event) {
    return typeof event === "object" && !!event && "target" in event;
  }
  var handlers3;
  function onWindowOpen(cb) {
    if (!handlers3) {
      handlers3 = [];
      monkeyPatchWindowOpen();
    }
    handlers3.push(cb);
    return () => {
      const pos = handlers3 ? handlers3.indexOf(cb) : -1;
      if (pos > -1) {
        handlers3.splice(pos, 1);
      }
    };
  }
  function monkeyPatchWindowOpen() {
    fill(WINDOW6, "open", function(originalWindowOpen) {
      return function(...args) {
        if (handlers3) {
          try {
            handlers3.forEach((handler) => handler());
          } catch (e2) {
          }
        }
        return originalWindowOpen.apply(WINDOW6, args);
      };
    });
  }
  var IncrementalMutationSources = /* @__PURE__ */ new Set([
    IncrementalSource.Mutation,
    IncrementalSource.StyleSheetRule,
    IncrementalSource.StyleDeclaration,
    IncrementalSource.AdoptedStyleSheet,
    IncrementalSource.CanvasMutation,
    IncrementalSource.Selection,
    IncrementalSource.MediaInteraction
  ]);
  function handleClick(clickDetector, clickBreadcrumb, node) {
    clickDetector.handleClick(clickBreadcrumb, node);
  }
  var ClickDetector = class {
    // protected for testing
    constructor(replay, slowClickConfig, _addBreadcrumbEvent = addBreadcrumbEvent) {
      this._lastMutation = 0;
      this._lastScroll = 0;
      this._clicks = [];
      this._timeout = slowClickConfig.timeout / 1e3;
      this._threshold = slowClickConfig.threshold / 1e3;
      this._scollTimeout = slowClickConfig.scrollTimeout / 1e3;
      this._replay = replay;
      this._ignoreSelector = slowClickConfig.ignoreSelector;
      this._addBreadcrumbEvent = _addBreadcrumbEvent;
    }
    /** Register click detection handlers on mutation or scroll. */
    addListeners() {
      const cleanupWindowOpen = onWindowOpen(() => {
        this._lastMutation = nowInSeconds();
      });
      this._teardown = () => {
        cleanupWindowOpen();
        this._clicks = [];
        this._lastMutation = 0;
        this._lastScroll = 0;
      };
    }
    /** Clean up listeners. */
    removeListeners() {
      if (this._teardown) {
        this._teardown();
      }
      if (this._checkClickTimeout) {
        clearTimeout(this._checkClickTimeout);
      }
    }
    /** @inheritDoc */
    handleClick(breadcrumb, node) {
      if (ignoreElement(node, this._ignoreSelector) || !isClickBreadcrumb(breadcrumb)) {
        return;
      }
      const newClick = {
        timestamp: timestampToS(breadcrumb.timestamp),
        clickBreadcrumb: breadcrumb,
        // Set this to 0 so we know it originates from the click breadcrumb
        clickCount: 0,
        node
      };
      if (this._clicks.some((click) => click.node === newClick.node && Math.abs(click.timestamp - newClick.timestamp) < 1)) {
        return;
      }
      this._clicks.push(newClick);
      if (this._clicks.length === 1) {
        this._scheduleCheckClicks();
      }
    }
    /** @inheritDoc */
    registerMutation(timestamp = Date.now()) {
      this._lastMutation = timestampToS(timestamp);
    }
    /** @inheritDoc */
    registerScroll(timestamp = Date.now()) {
      this._lastScroll = timestampToS(timestamp);
    }
    /** @inheritDoc */
    registerClick(element) {
      const node = getClosestInteractive(element);
      this._handleMultiClick(node);
    }
    /** Count multiple clicks on elements. */
    _handleMultiClick(node) {
      this._getClicks(node).forEach((click) => {
        click.clickCount++;
      });
    }
    /** Get all pending clicks for a given node. */
    _getClicks(node) {
      return this._clicks.filter((click) => click.node === node);
    }
    /** Check the clicks that happened. */
    _checkClicks() {
      const timedOutClicks = [];
      const now = nowInSeconds();
      this._clicks.forEach((click) => {
        if (!click.mutationAfter && this._lastMutation) {
          click.mutationAfter = click.timestamp <= this._lastMutation ? this._lastMutation - click.timestamp : void 0;
        }
        if (!click.scrollAfter && this._lastScroll) {
          click.scrollAfter = click.timestamp <= this._lastScroll ? this._lastScroll - click.timestamp : void 0;
        }
        if (click.timestamp + this._timeout <= now) {
          timedOutClicks.push(click);
        }
      });
      for (const click of timedOutClicks) {
        const pos = this._clicks.indexOf(click);
        if (pos > -1) {
          this._generateBreadcrumbs(click);
          this._clicks.splice(pos, 1);
        }
      }
      if (this._clicks.length) {
        this._scheduleCheckClicks();
      }
    }
    /** Generate matching breadcrumb(s) for the click. */
    _generateBreadcrumbs(click) {
      const replay = this._replay;
      const hadScroll = click.scrollAfter && click.scrollAfter <= this._scollTimeout;
      const hadMutation = click.mutationAfter && click.mutationAfter <= this._threshold;
      const isSlowClick = !hadScroll && !hadMutation;
      const { clickCount, clickBreadcrumb } = click;
      if (isSlowClick) {
        const timeAfterClickMs = Math.min(click.mutationAfter || this._timeout, this._timeout) * 1e3;
        const endReason = timeAfterClickMs < this._timeout * 1e3 ? "mutation" : "timeout";
        const breadcrumb = {
          type: "default",
          message: clickBreadcrumb.message,
          timestamp: clickBreadcrumb.timestamp,
          category: "ui.slowClickDetected",
          data: {
            ...clickBreadcrumb.data,
            url: WINDOW6.location.href,
            route: replay.getCurrentRoute(),
            timeAfterClickMs,
            endReason,
            // If clickCount === 0, it means multiClick was not correctly captured here
            // - we still want to send 1 in this case
            clickCount: clickCount || 1
          }
        };
        this._addBreadcrumbEvent(replay, breadcrumb);
        return;
      }
      if (clickCount > 1) {
        const breadcrumb = {
          type: "default",
          message: clickBreadcrumb.message,
          timestamp: clickBreadcrumb.timestamp,
          category: "ui.multiClick",
          data: {
            ...clickBreadcrumb.data,
            url: WINDOW6.location.href,
            route: replay.getCurrentRoute(),
            clickCount,
            metric: true
          }
        };
        this._addBreadcrumbEvent(replay, breadcrumb);
      }
    }
    /** Schedule to check current clicks. */
    _scheduleCheckClicks() {
      if (this._checkClickTimeout) {
        clearTimeout(this._checkClickTimeout);
      }
      this._checkClickTimeout = setTimeout2(() => this._checkClicks(), 1e3);
    }
  };
  var SLOW_CLICK_TAGS = ["A", "BUTTON", "INPUT"];
  function ignoreElement(node, ignoreSelector) {
    if (!SLOW_CLICK_TAGS.includes(node.tagName)) {
      return true;
    }
    if (node.tagName === "INPUT" && !["submit", "button"].includes(node.getAttribute("type") || "")) {
      return true;
    }
    if (node.tagName === "A" && (node.hasAttribute("download") || node.hasAttribute("target") && node.getAttribute("target") !== "_self")) {
      return true;
    }
    if (ignoreSelector && node.matches(ignoreSelector)) {
      return true;
    }
    return false;
  }
  function isClickBreadcrumb(breadcrumb) {
    return !!(breadcrumb.data && typeof breadcrumb.data.nodeId === "number" && breadcrumb.timestamp);
  }
  function nowInSeconds() {
    return Date.now() / 1e3;
  }
  function updateClickDetectorForRecordingEvent(clickDetector, event) {
    try {
      if (!isIncrementalEvent(event)) {
        return;
      }
      const { source } = event.data;
      if (IncrementalMutationSources.has(source)) {
        clickDetector.registerMutation(event.timestamp);
      }
      if (source === IncrementalSource.Scroll) {
        clickDetector.registerScroll(event.timestamp);
      }
      if (isIncrementalMouseInteraction(event)) {
        const { type, id } = event.data;
        const node = record.mirror.getNode(id);
        if (node instanceof HTMLElement && type === MouseInteractions.Click) {
          clickDetector.registerClick(node);
        }
      }
    } catch (e2) {
    }
  }
  function isIncrementalEvent(event) {
    return event.type === ReplayEventTypeIncrementalSnapshot;
  }
  function isIncrementalMouseInteraction(event) {
    return event.data.source === IncrementalSource.MouseInteraction;
  }
  function createBreadcrumb(breadcrumb) {
    return {
      timestamp: Date.now() / 1e3,
      type: "default",
      ...breadcrumb
    };
  }
  var NodeType;
  (function(NodeType2) {
    NodeType2[NodeType2["Document"] = 0] = "Document";
    NodeType2[NodeType2["DocumentType"] = 1] = "DocumentType";
    NodeType2[NodeType2["Element"] = 2] = "Element";
    NodeType2[NodeType2["Text"] = 3] = "Text";
    NodeType2[NodeType2["CDATA"] = 4] = "CDATA";
    NodeType2[NodeType2["Comment"] = 5] = "Comment";
  })(NodeType || (NodeType = {}));
  var ATTRIBUTES_TO_RECORD = /* @__PURE__ */ new Set([
    "id",
    "class",
    "aria-label",
    "role",
    "name",
    "alt",
    "title",
    "data-test-id",
    "data-testid",
    "disabled",
    "aria-disabled",
    "data-sentry-component"
  ]);
  function getAttributesToRecord(attributes) {
    const obj = {};
    if (!attributes["data-sentry-component"] && attributes["data-sentry-element"]) {
      attributes["data-sentry-component"] = attributes["data-sentry-element"];
    }
    for (const key in attributes) {
      if (ATTRIBUTES_TO_RECORD.has(key)) {
        let normalizedKey = key;
        if (key === "data-testid" || key === "data-test-id") {
          normalizedKey = "testId";
        }
        obj[normalizedKey] = attributes[key];
      }
    }
    return obj;
  }
  var handleDomListener = (replay) => {
    return (handlerData) => {
      if (!replay.isEnabled()) {
        return;
      }
      const result = handleDom(handlerData);
      if (!result) {
        return;
      }
      const isClick = handlerData.name === "click";
      const event = isClick ? handlerData.event : void 0;
      if (isClick && replay.clickDetector && event && event.target && !event.altKey && !event.metaKey && !event.ctrlKey && !event.shiftKey) {
        handleClick(
          replay.clickDetector,
          result,
          getClickTargetNode(handlerData.event)
        );
      }
      addBreadcrumbEvent(replay, result);
    };
  };
  function getBaseDomBreadcrumb(target, message) {
    const nodeId = record.mirror.getId(target);
    const node = nodeId && record.mirror.getNode(nodeId);
    const meta = node && record.mirror.getMeta(node);
    const element = meta && isElement2(meta) ? meta : null;
    return {
      message,
      data: element ? {
        nodeId,
        node: {
          id: nodeId,
          tagName: element.tagName,
          textContent: Array.from(element.childNodes).map((node2) => node2.type === NodeType.Text && node2.textContent).filter(Boolean).map((text) => text.trim()).join(""),
          attributes: getAttributesToRecord(element.attributes)
        }
      } : {}
    };
  }
  function handleDom(handlerData) {
    const { target, message } = getDomTarget(handlerData);
    return createBreadcrumb({
      category: `ui.${handlerData.name}`,
      ...getBaseDomBreadcrumb(target, message)
    });
  }
  function getDomTarget(handlerData) {
    const isClick = handlerData.name === "click";
    let message;
    let target = null;
    try {
      target = isClick ? getClickTargetNode(handlerData.event) : getTargetNode(handlerData.event);
      message = htmlTreeAsString(target, { maxStringLength: 200 }) || "<unknown>";
    } catch (e2) {
      message = "<unknown>";
    }
    return { target, message };
  }
  function isElement2(node) {
    return node.type === NodeType.Element;
  }
  function handleKeyboardEvent(replay, event) {
    if (!replay.isEnabled()) {
      return;
    }
    replay.updateUserActivity();
    const breadcrumb = getKeyboardBreadcrumb(event);
    if (!breadcrumb) {
      return;
    }
    addBreadcrumbEvent(replay, breadcrumb);
  }
  function getKeyboardBreadcrumb(event) {
    const { metaKey, shiftKey, ctrlKey, altKey, key, target } = event;
    if (!target || isInputElement(target) || !key) {
      return null;
    }
    const hasModifierKey = metaKey || ctrlKey || altKey;
    const isCharacterKey = key.length === 1;
    if (!hasModifierKey && isCharacterKey) {
      return null;
    }
    const message = htmlTreeAsString(target, { maxStringLength: 200 }) || "<unknown>";
    const baseBreadcrumb = getBaseDomBreadcrumb(target, message);
    return createBreadcrumb({
      category: "ui.keyDown",
      message,
      data: {
        ...baseBreadcrumb.data,
        metaKey,
        shiftKey,
        ctrlKey,
        altKey,
        key
      }
    });
  }
  function isInputElement(target) {
    return target.tagName === "INPUT" || target.tagName === "TEXTAREA" || target.isContentEditable;
  }
  var ENTRY_TYPES = {
    // @ts-expect-error TODO: entry type does not fit the create* functions entry type
    resource: createResourceEntry,
    paint: createPaintEntry,
    // @ts-expect-error TODO: entry type does not fit the create* functions entry type
    navigation: createNavigationEntry
  };
  function webVitalHandler(getter, replay) {
    return ({ metric }) => void replay.replayPerformanceEntries.push(getter(metric));
  }
  function createPerformanceEntries(entries) {
    return entries.map(createPerformanceEntry).filter(Boolean);
  }
  function createPerformanceEntry(entry) {
    const entryType = ENTRY_TYPES[entry.entryType];
    if (!entryType) {
      return null;
    }
    return entryType(entry);
  }
  function getAbsoluteTime(time) {
    return ((browserPerformanceTimeOrigin || WINDOW6.performance.timeOrigin) + time) / 1e3;
  }
  function createPaintEntry(entry) {
    const { duration, entryType, name, startTime } = entry;
    const start2 = getAbsoluteTime(startTime);
    return {
      type: entryType,
      name,
      start: start2,
      end: start2 + duration,
      data: void 0
    };
  }
  function createNavigationEntry(entry) {
    const {
      entryType,
      name,
      decodedBodySize,
      duration,
      domComplete,
      encodedBodySize,
      domContentLoadedEventStart,
      domContentLoadedEventEnd,
      domInteractive,
      loadEventStart,
      loadEventEnd,
      redirectCount,
      startTime,
      transferSize,
      type
    } = entry;
    if (duration === 0) {
      return null;
    }
    return {
      type: `${entryType}.${type}`,
      start: getAbsoluteTime(startTime),
      end: getAbsoluteTime(domComplete),
      name,
      data: {
        size: transferSize,
        decodedBodySize,
        encodedBodySize,
        duration,
        domInteractive,
        domContentLoadedEventStart,
        domContentLoadedEventEnd,
        loadEventStart,
        loadEventEnd,
        domComplete,
        redirectCount
      }
    };
  }
  function createResourceEntry(entry) {
    const {
      entryType,
      initiatorType,
      name,
      responseEnd,
      startTime,
      decodedBodySize,
      encodedBodySize,
      responseStatus,
      transferSize
    } = entry;
    if (["fetch", "xmlhttprequest"].includes(initiatorType)) {
      return null;
    }
    return {
      type: `${entryType}.${initiatorType}`,
      start: getAbsoluteTime(startTime),
      end: getAbsoluteTime(responseEnd),
      name,
      data: {
        size: transferSize,
        statusCode: responseStatus,
        decodedBodySize,
        encodedBodySize
      }
    };
  }
  function getLargestContentfulPaint(metric) {
    const lastEntry = metric.entries[metric.entries.length - 1];
    const node = lastEntry && lastEntry.element ? [lastEntry.element] : void 0;
    return getWebVital(metric, "largest-contentful-paint", node);
  }
  function isLayoutShift(entry) {
    return entry.sources !== void 0;
  }
  function getCumulativeLayoutShift(metric) {
    const layoutShifts = [];
    const nodes = [];
    for (const entry of metric.entries) {
      if (isLayoutShift(entry)) {
        const nodeIds = [];
        for (const source of entry.sources) {
          if (source.node) {
            nodes.push(source.node);
            const nodeId = record.mirror.getId(source.node);
            if (nodeId) {
              nodeIds.push(nodeId);
            }
          }
        }
        layoutShifts.push({ value: entry.value, nodeIds: nodeIds.length ? nodeIds : void 0 });
      }
    }
    return getWebVital(metric, "cumulative-layout-shift", nodes, layoutShifts);
  }
  function getFirstInputDelay(metric) {
    const lastEntry = metric.entries[metric.entries.length - 1];
    const node = lastEntry && lastEntry.target ? [lastEntry.target] : void 0;
    return getWebVital(metric, "first-input-delay", node);
  }
  function getInteractionToNextPaint(metric) {
    const lastEntry = metric.entries[metric.entries.length - 1];
    const node = lastEntry && lastEntry.target ? [lastEntry.target] : void 0;
    return getWebVital(metric, "interaction-to-next-paint", node);
  }
  function getWebVital(metric, name, nodes, attributions) {
    const value = metric.value;
    const rating = metric.rating;
    const end = getAbsoluteTime(value);
    return {
      type: "web-vital",
      name,
      start: end,
      end,
      data: {
        value,
        size: value,
        rating,
        nodeIds: nodes ? nodes.map((node) => record.mirror.getId(node)) : void 0,
        attributions
      }
    };
  }
  function setupPerformanceObserver(replay) {
    function addPerformanceEntry(entry) {
      if (!replay.performanceEntries.includes(entry)) {
        replay.performanceEntries.push(entry);
      }
    }
    function onEntries({ entries }) {
      entries.forEach(addPerformanceEntry);
    }
    const clearCallbacks = [];
    ["navigation", "paint", "resource"].forEach((type) => {
      clearCallbacks.push(addPerformanceInstrumentationHandler(type, onEntries));
    });
    clearCallbacks.push(
      addLcpInstrumentationHandler(webVitalHandler(getLargestContentfulPaint, replay)),
      addClsInstrumentationHandler(webVitalHandler(getCumulativeLayoutShift, replay)),
      addFidInstrumentationHandler(webVitalHandler(getFirstInputDelay, replay)),
      addInpInstrumentationHandler(webVitalHandler(getInteractionToNextPaint, replay))
    );
    return () => {
      clearCallbacks.forEach((clearCallback) => clearCallback());
    };
  }
  var r = `var t=Uint8Array,n=Uint16Array,r=Int32Array,e=new t([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,0,0,0]),i=new t([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,0,0]),a=new t([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15]),s=function(t,e){for(var i=new n(31),a=0;a<31;++a)i[a]=e+=1<<t[a-1];var s=new r(i[30]);for(a=1;a<30;++a)for(var o=i[a];o<i[a+1];++o)s[o]=o-i[a]<<5|a;return{b:i,r:s}},o=s(e,2),f=o.b,h=o.r;f[28]=258,h[258]=28;for(var l=s(i,0).r,u=new n(32768),c=0;c<32768;++c){var v=(43690&c)>>1|(21845&c)<<1;v=(61680&(v=(52428&v)>>2|(13107&v)<<2))>>4|(3855&v)<<4,u[c]=((65280&v)>>8|(255&v)<<8)>>1}var d=function(t,r,e){for(var i=t.length,a=0,s=new n(r);a<i;++a)t[a]&&++s[t[a]-1];var o,f=new n(r);for(a=1;a<r;++a)f[a]=f[a-1]+s[a-1]<<1;if(e){o=new n(1<<r);var h=15-r;for(a=0;a<i;++a)if(t[a])for(var l=a<<4|t[a],c=r-t[a],v=f[t[a]-1]++<<c,d=v|(1<<c)-1;v<=d;++v)o[u[v]>>h]=l}else for(o=new n(i),a=0;a<i;++a)t[a]&&(o[a]=u[f[t[a]-1]++]>>15-t[a]);return o},g=new t(288);for(c=0;c<144;++c)g[c]=8;for(c=144;c<256;++c)g[c]=9;for(c=256;c<280;++c)g[c]=7;for(c=280;c<288;++c)g[c]=8;var w=new t(32);for(c=0;c<32;++c)w[c]=5;var p=d(g,9,0),y=d(w,5,0),m=function(t){return(t+7)/8|0},b=function(n,r,e){return(null==r||r<0)&&(r=0),(null==e||e>n.length)&&(e=n.length),new t(n.subarray(r,e))},M=["unexpected EOF","invalid block type","invalid length/literal","invalid distance","stream finished","no stream handler",,"no callback","invalid UTF-8 data","extra field too long","date not in range 1980-2099","filename too long","stream finishing","invalid zip data"],E=function(t,n,r){var e=new Error(n||M[t]);if(e.code=t,Error.captureStackTrace&&Error.captureStackTrace(e,E),!r)throw e;return e},z=function(t,n,r){r<<=7&n;var e=n/8|0;t[e]|=r,t[e+1]|=r>>8},A=function(t,n,r){r<<=7&n;var e=n/8|0;t[e]|=r,t[e+1]|=r>>8,t[e+2]|=r>>16},_=function(r,e){for(var i=[],a=0;a<r.length;++a)r[a]&&i.push({s:a,f:r[a]});var s=i.length,o=i.slice();if(!s)return{t:F,l:0};if(1==s){var f=new t(i[0].s+1);return f[i[0].s]=1,{t:f,l:1}}i.sort((function(t,n){return t.f-n.f})),i.push({s:-1,f:25001});var h=i[0],l=i[1],u=0,c=1,v=2;for(i[0]={s:-1,f:h.f+l.f,l:h,r:l};c!=s-1;)h=i[i[u].f<i[v].f?u++:v++],l=i[u!=c&&i[u].f<i[v].f?u++:v++],i[c++]={s:-1,f:h.f+l.f,l:h,r:l};var d=o[0].s;for(a=1;a<s;++a)o[a].s>d&&(d=o[a].s);var g=new n(d+1),w=x(i[c-1],g,0);if(w>e){a=0;var p=0,y=w-e,m=1<<y;for(o.sort((function(t,n){return g[n.s]-g[t.s]||t.f-n.f}));a<s;++a){var b=o[a].s;if(!(g[b]>e))break;p+=m-(1<<w-g[b]),g[b]=e}for(p>>=y;p>0;){var M=o[a].s;g[M]<e?p-=1<<e-g[M]++-1:++a}for(;a>=0&&p;--a){var E=o[a].s;g[E]==e&&(--g[E],++p)}w=e}return{t:new t(g),l:w}},x=function(t,n,r){return-1==t.s?Math.max(x(t.l,n,r+1),x(t.r,n,r+1)):n[t.s]=r},D=function(t){for(var r=t.length;r&&!t[--r];);for(var e=new n(++r),i=0,a=t[0],s=1,o=function(t){e[i++]=t},f=1;f<=r;++f)if(t[f]==a&&f!=r)++s;else{if(!a&&s>2){for(;s>138;s-=138)o(32754);s>2&&(o(s>10?s-11<<5|28690:s-3<<5|12305),s=0)}else if(s>3){for(o(a),--s;s>6;s-=6)o(8304);s>2&&(o(s-3<<5|8208),s=0)}for(;s--;)o(a);s=1,a=t[f]}return{c:e.subarray(0,i),n:r}},T=function(t,n){for(var r=0,e=0;e<n.length;++e)r+=t[e]*n[e];return r},k=function(t,n,r){var e=r.length,i=m(n+2);t[i]=255&e,t[i+1]=e>>8,t[i+2]=255^t[i],t[i+3]=255^t[i+1];for(var a=0;a<e;++a)t[i+a+4]=r[a];return 8*(i+4+e)},C=function(t,r,s,o,f,h,l,u,c,v,m){z(r,m++,s),++f[256];for(var b=_(f,15),M=b.t,E=b.l,x=_(h,15),C=x.t,U=x.l,F=D(M),I=F.c,S=F.n,L=D(C),O=L.c,j=L.n,q=new n(19),B=0;B<I.length;++B)++q[31&I[B]];for(B=0;B<O.length;++B)++q[31&O[B]];for(var G=_(q,7),H=G.t,J=G.l,K=19;K>4&&!H[a[K-1]];--K);var N,P,Q,R,V=v+5<<3,W=T(f,g)+T(h,w)+l,X=T(f,M)+T(h,C)+l+14+3*K+T(q,H)+2*q[16]+3*q[17]+7*q[18];if(c>=0&&V<=W&&V<=X)return k(r,m,t.subarray(c,c+v));if(z(r,m,1+(X<W)),m+=2,X<W){N=d(M,E,0),P=M,Q=d(C,U,0),R=C;var Y=d(H,J,0);z(r,m,S-257),z(r,m+5,j-1),z(r,m+10,K-4),m+=14;for(B=0;B<K;++B)z(r,m+3*B,H[a[B]]);m+=3*K;for(var Z=[I,O],$=0;$<2;++$){var tt=Z[$];for(B=0;B<tt.length;++B){var nt=31&tt[B];z(r,m,Y[nt]),m+=H[nt],nt>15&&(z(r,m,tt[B]>>5&127),m+=tt[B]>>12)}}}else N=p,P=g,Q=y,R=w;for(B=0;B<u;++B){var rt=o[B];if(rt>255){A(r,m,N[(nt=rt>>18&31)+257]),m+=P[nt+257],nt>7&&(z(r,m,rt>>23&31),m+=e[nt]);var et=31&rt;A(r,m,Q[et]),m+=R[et],et>3&&(A(r,m,rt>>5&8191),m+=i[et])}else A(r,m,N[rt]),m+=P[rt]}return A(r,m,N[256]),m+P[256]},U=new r([65540,131080,131088,131104,262176,1048704,1048832,2114560,2117632]),F=new t(0),I=function(){for(var t=new Int32Array(256),n=0;n<256;++n){for(var r=n,e=9;--e;)r=(1&r&&-306674912)^r>>>1;t[n]=r}return t}(),S=function(){var t=-1;return{p:function(n){for(var r=t,e=0;e<n.length;++e)r=I[255&r^n[e]]^r>>>8;t=r},d:function(){return~t}}},L=function(){var t=1,n=0;return{p:function(r){for(var e=t,i=n,a=0|r.length,s=0;s!=a;){for(var o=Math.min(s+2655,a);s<o;++s)i+=e+=r[s];e=(65535&e)+15*(e>>16),i=(65535&i)+15*(i>>16)}t=e,n=i},d:function(){return(255&(t%=65521))<<24|(65280&t)<<8|(255&(n%=65521))<<8|n>>8}}},O=function(a,s,o,f,u){if(!u&&(u={l:1},s.dictionary)){var c=s.dictionary.subarray(-32768),v=new t(c.length+a.length);v.set(c),v.set(a,c.length),a=v,u.w=c.length}return function(a,s,o,f,u,c){var v=c.z||a.length,d=new t(f+v+5*(1+Math.ceil(v/7e3))+u),g=d.subarray(f,d.length-u),w=c.l,p=7&(c.r||0);if(s){p&&(g[0]=c.r>>3);for(var y=U[s-1],M=y>>13,E=8191&y,z=(1<<o)-1,A=c.p||new n(32768),_=c.h||new n(z+1),x=Math.ceil(o/3),D=2*x,T=function(t){return(a[t]^a[t+1]<<x^a[t+2]<<D)&z},F=new r(25e3),I=new n(288),S=new n(32),L=0,O=0,j=c.i||0,q=0,B=c.w||0,G=0;j+2<v;++j){var H=T(j),J=32767&j,K=_[H];if(A[J]=K,_[H]=J,B<=j){var N=v-j;if((L>7e3||q>24576)&&(N>423||!w)){p=C(a,g,0,F,I,S,O,q,G,j-G,p),q=L=O=0,G=j;for(var P=0;P<286;++P)I[P]=0;for(P=0;P<30;++P)S[P]=0}var Q=2,R=0,V=E,W=J-K&32767;if(N>2&&H==T(j-W))for(var X=Math.min(M,N)-1,Y=Math.min(32767,j),Z=Math.min(258,N);W<=Y&&--V&&J!=K;){if(a[j+Q]==a[j+Q-W]){for(var $=0;$<Z&&a[j+$]==a[j+$-W];++$);if($>Q){if(Q=$,R=W,$>X)break;var tt=Math.min(W,$-2),nt=0;for(P=0;P<tt;++P){var rt=j-W+P&32767,et=rt-A[rt]&32767;et>nt&&(nt=et,K=rt)}}}W+=(J=K)-(K=A[J])&32767}if(R){F[q++]=268435456|h[Q]<<18|l[R];var it=31&h[Q],at=31&l[R];O+=e[it]+i[at],++I[257+it],++S[at],B=j+Q,++L}else F[q++]=a[j],++I[a[j]]}}for(j=Math.max(j,B);j<v;++j)F[q++]=a[j],++I[a[j]];p=C(a,g,w,F,I,S,O,q,G,j-G,p),w||(c.r=7&p|g[p/8|0]<<3,p-=7,c.h=_,c.p=A,c.i=j,c.w=B)}else{for(j=c.w||0;j<v+w;j+=65535){var st=j+65535;st>=v&&(g[p/8|0]=w,st=v),p=k(g,p+1,a.subarray(j,st))}c.i=v}return b(d,0,f+m(p)+u)}(a,null==s.level?6:s.level,null==s.mem?Math.ceil(1.5*Math.max(8,Math.min(13,Math.log(a.length)))):12+s.mem,o,f,u)},j=function(t,n,r){for(;r;++n)t[n]=r,r>>>=8},q=function(t,n){var r=n.filename;if(t[0]=31,t[1]=139,t[2]=8,t[8]=n.level<2?4:9==n.level?2:0,t[9]=3,0!=n.mtime&&j(t,4,Math.floor(new Date(n.mtime||Date.now())/1e3)),r){t[3]=8;for(var e=0;e<=r.length;++e)t[e+10]=r.charCodeAt(e)}},B=function(t){return 10+(t.filename?t.filename.length+1:0)},G=function(){function n(n,r){if("function"==typeof n&&(r=n,n={}),this.ondata=r,this.o=n||{},this.s={l:0,i:32768,w:32768,z:32768},this.b=new t(98304),this.o.dictionary){var e=this.o.dictionary.subarray(-32768);this.b.set(e,32768-e.length),this.s.i=32768-e.length}}return n.prototype.p=function(t,n){this.ondata(O(t,this.o,0,0,this.s),n)},n.prototype.push=function(n,r){this.ondata||E(5),this.s.l&&E(4);var e=n.length+this.s.z;if(e>this.b.length){if(e>2*this.b.length-32768){var i=new t(-32768&e);i.set(this.b.subarray(0,this.s.z)),this.b=i}var a=this.b.length-this.s.z;a&&(this.b.set(n.subarray(0,a),this.s.z),this.s.z=this.b.length,this.p(this.b,!1)),this.b.set(this.b.subarray(-32768)),this.b.set(n.subarray(a),32768),this.s.z=n.length-a+32768,this.s.i=32766,this.s.w=32768}else this.b.set(n,this.s.z),this.s.z+=n.length;this.s.l=1&r,(this.s.z>this.s.w+8191||r)&&(this.p(this.b,r||!1),this.s.w=this.s.i,this.s.i-=2)},n}();var H=function(){function t(t,n){this.c=L(),this.v=1,G.call(this,t,n)}return t.prototype.push=function(t,n){this.c.p(t),G.prototype.push.call(this,t,n)},t.prototype.p=function(t,n){var r=O(t,this.o,this.v&&(this.o.dictionary?6:2),n&&4,this.s);this.v&&(function(t,n){var r=n.level,e=0==r?0:r<6?1:9==r?3:2;if(t[0]=120,t[1]=e<<6|(n.dictionary&&32),t[1]|=31-(t[0]<<8|t[1])%31,n.dictionary){var i=L();i.p(n.dictionary),j(t,2,i.d())}}(r,this.o),this.v=0),n&&j(r,r.length-4,this.c.d()),this.ondata(r,n)},t}(),J="undefined"!=typeof TextEncoder&&new TextEncoder,K="undefined"!=typeof TextDecoder&&new TextDecoder;try{K.decode(F,{stream:!0})}catch(t){}var N=function(){function t(t){this.ondata=t}return t.prototype.push=function(t,n){this.ondata||E(5),this.d&&E(4),this.ondata(P(t),this.d=n||!1)},t}();function P(n,r){if(r){for(var e=new t(n.length),i=0;i<n.length;++i)e[i]=n.charCodeAt(i);return e}if(J)return J.encode(n);var a=n.length,s=new t(n.length+(n.length>>1)),o=0,f=function(t){s[o++]=t};for(i=0;i<a;++i){if(o+5>s.length){var h=new t(o+8+(a-i<<1));h.set(s),s=h}var l=n.charCodeAt(i);l<128||r?f(l):l<2048?(f(192|l>>6),f(128|63&l)):l>55295&&l<57344?(f(240|(l=65536+(1047552&l)|1023&n.charCodeAt(++i))>>18),f(128|l>>12&63),f(128|l>>6&63),f(128|63&l)):(f(224|l>>12),f(128|l>>6&63),f(128|63&l))}return b(s,0,o)}function Q(t){return function(t,n){n||(n={});var r=S(),e=t.length;r.p(t);var i=O(t,n,B(n),8),a=i.length;return q(i,n),j(i,a-8,r.d()),j(i,a-4,e),i}(P(t))}const R=new class{constructor(){this._init()}clear(){this._init()}addEvent(t){if(!t)throw new Error("Adding invalid event");const n=this._hasEvents?",":"";this.stream.push(n+t),this._hasEvents=!0}finish(){this.stream.push("]",!0);const t=function(t){let n=0;for(const r of t)n+=r.length;const r=new Uint8Array(n);for(let n=0,e=0,i=t.length;n<i;n++){const i=t[n];r.set(i,e),e+=i.length}return r}(this._deflatedData);return this._init(),t}_init(){this._hasEvents=!1,this._deflatedData=[],this.deflate=new H,this.deflate.ondata=(t,n)=>{this._deflatedData.push(t)},this.stream=new N(((t,n)=>{this.deflate.push(t,n)})),this.stream.push("[")}},V={clear:()=>{R.clear()},addEvent:t=>R.addEvent(t),finish:()=>R.finish(),compress:t=>Q(t)};addEventListener("message",(function(t){const n=t.data.method,r=t.data.id,e=t.data.arg;if(n in V&&"function"==typeof V[n])try{const t=V[n](e);postMessage({id:r,method:n,success:!0,response:t})}catch(t){postMessage({id:r,method:n,success:!1,response:t.message}),console.error(t)}})),postMessage({id:void 0,method:"init",success:!0,response:void 0});`;
  function e() {
    const e2 = new Blob([r]);
    return URL.createObjectURL(e2);
  }
  var EventBufferSizeExceededError = class extends Error {
    constructor() {
      super(`Event buffer exceeded maximum size of ${REPLAY_MAX_EVENT_BUFFER_SIZE}.`);
    }
  };
  var EventBufferArray = class {
    /** All the events that are buffered to be sent. */
    /** @inheritdoc */
    constructor() {
      this.events = [];
      this._totalSize = 0;
      this.hasCheckout = false;
    }
    /** @inheritdoc */
    get hasEvents() {
      return this.events.length > 0;
    }
    /** @inheritdoc */
    get type() {
      return "sync";
    }
    /** @inheritdoc */
    destroy() {
      this.events = [];
    }
    /** @inheritdoc */
    async addEvent(event) {
      const eventSize = JSON.stringify(event).length;
      this._totalSize += eventSize;
      if (this._totalSize > REPLAY_MAX_EVENT_BUFFER_SIZE) {
        throw new EventBufferSizeExceededError();
      }
      this.events.push(event);
    }
    /** @inheritdoc */
    finish() {
      return new Promise((resolve) => {
        const eventsRet = this.events;
        this.clear();
        resolve(JSON.stringify(eventsRet));
      });
    }
    /** @inheritdoc */
    clear() {
      this.events = [];
      this._totalSize = 0;
      this.hasCheckout = false;
    }
    /** @inheritdoc */
    getEarliestTimestamp() {
      const timestamp = this.events.map((event) => event.timestamp).sort()[0];
      if (!timestamp) {
        return null;
      }
      return timestampToMs(timestamp);
    }
  };
  var WorkerHandler = class {
    constructor(worker) {
      this._worker = worker;
      this._id = 0;
    }
    /**
     * Ensure the worker is ready (or not).
     * This will either resolve when the worker is ready, or reject if an error occured.
     */
    ensureReady() {
      if (this._ensureReadyPromise) {
        return this._ensureReadyPromise;
      }
      this._ensureReadyPromise = new Promise((resolve, reject) => {
        this._worker.addEventListener(
          "message",
          ({ data }) => {
            if (data.success) {
              resolve();
            } else {
              reject();
            }
          },
          { once: true }
        );
        this._worker.addEventListener(
          "error",
          (error) => {
            reject(error);
          },
          { once: true }
        );
      });
      return this._ensureReadyPromise;
    }
    /**
     * Destroy the worker.
     */
    destroy() {
      DEBUG_BUILD5 && logger2.info("Destroying compression worker");
      this._worker.terminate();
    }
    /**
     * Post message to worker and wait for response before resolving promise.
     */
    postMessage(method, arg) {
      const id = this._getAndIncrementId();
      return new Promise((resolve, reject) => {
        const listener = ({ data }) => {
          const response = data;
          if (response.method !== method) {
            return;
          }
          if (response.id !== id) {
            return;
          }
          this._worker.removeEventListener("message", listener);
          if (!response.success) {
            DEBUG_BUILD5 && logger2.error("Error in compression worker: ", response.response);
            reject(new Error("Error in compression worker"));
            return;
          }
          resolve(response.response);
        };
        this._worker.addEventListener("message", listener);
        this._worker.postMessage({ id, method, arg });
      });
    }
    /** Get the current ID and increment it for the next call. */
    _getAndIncrementId() {
      return this._id++;
    }
  };
  var EventBufferCompressionWorker = class {
    /** @inheritdoc */
    constructor(worker) {
      this._worker = new WorkerHandler(worker);
      this._earliestTimestamp = null;
      this._totalSize = 0;
      this.hasCheckout = false;
    }
    /** @inheritdoc */
    get hasEvents() {
      return !!this._earliestTimestamp;
    }
    /** @inheritdoc */
    get type() {
      return "worker";
    }
    /**
     * Ensure the worker is ready (or not).
     * This will either resolve when the worker is ready, or reject if an error occured.
     */
    ensureReady() {
      return this._worker.ensureReady();
    }
    /**
     * Destroy the event buffer.
     */
    destroy() {
      this._worker.destroy();
    }
    /**
     * Add an event to the event buffer.
     *
     * Returns true if event was successfuly received and processed by worker.
     */
    addEvent(event) {
      const timestamp = timestampToMs(event.timestamp);
      if (!this._earliestTimestamp || timestamp < this._earliestTimestamp) {
        this._earliestTimestamp = timestamp;
      }
      const data = JSON.stringify(event);
      this._totalSize += data.length;
      if (this._totalSize > REPLAY_MAX_EVENT_BUFFER_SIZE) {
        return Promise.reject(new EventBufferSizeExceededError());
      }
      return this._sendEventToWorker(data);
    }
    /**
     * Finish the event buffer and return the compressed data.
     */
    finish() {
      return this._finishRequest();
    }
    /** @inheritdoc */
    clear() {
      this._earliestTimestamp = null;
      this._totalSize = 0;
      this.hasCheckout = false;
      this._worker.postMessage("clear").then(null, (e2) => {
        DEBUG_BUILD5 && logger2.exception(e2, 'Sending "clear" message to worker failed', e2);
      });
    }
    /** @inheritdoc */
    getEarliestTimestamp() {
      return this._earliestTimestamp;
    }
    /**
     * Send the event to the worker.
     */
    _sendEventToWorker(data) {
      return this._worker.postMessage("addEvent", data);
    }
    /**
     * Finish the request and return the compressed data from the worker.
     */
    async _finishRequest() {
      const response = await this._worker.postMessage("finish");
      this._earliestTimestamp = null;
      this._totalSize = 0;
      return response;
    }
  };
  var EventBufferProxy = class {
    constructor(worker) {
      this._fallback = new EventBufferArray();
      this._compression = new EventBufferCompressionWorker(worker);
      this._used = this._fallback;
      this._ensureWorkerIsLoadedPromise = this._ensureWorkerIsLoaded();
    }
    /** @inheritdoc */
    get type() {
      return this._used.type;
    }
    /** @inheritDoc */
    get hasEvents() {
      return this._used.hasEvents;
    }
    /** @inheritdoc */
    get hasCheckout() {
      return this._used.hasCheckout;
    }
    /** @inheritdoc */
    set hasCheckout(value) {
      this._used.hasCheckout = value;
    }
    /** @inheritDoc */
    destroy() {
      this._fallback.destroy();
      this._compression.destroy();
    }
    /** @inheritdoc */
    clear() {
      return this._used.clear();
    }
    /** @inheritdoc */
    getEarliestTimestamp() {
      return this._used.getEarliestTimestamp();
    }
    /**
     * Add an event to the event buffer.
     *
     * Returns true if event was successfully added.
     */
    addEvent(event) {
      return this._used.addEvent(event);
    }
    /** @inheritDoc */
    async finish() {
      await this.ensureWorkerIsLoaded();
      return this._used.finish();
    }
    /** Ensure the worker has loaded. */
    ensureWorkerIsLoaded() {
      return this._ensureWorkerIsLoadedPromise;
    }
    /** Actually check if the worker has been loaded. */
    async _ensureWorkerIsLoaded() {
      try {
        await this._compression.ensureReady();
      } catch (error) {
        DEBUG_BUILD5 && logger2.exception(error, "Failed to load the compression worker, falling back to simple buffer");
        return;
      }
      await this._switchToCompressionWorker();
    }
    /** Switch the used buffer to the compression worker. */
    async _switchToCompressionWorker() {
      const { events, hasCheckout } = this._fallback;
      const addEventPromises = [];
      for (const event of events) {
        addEventPromises.push(this._compression.addEvent(event));
      }
      this._compression.hasCheckout = hasCheckout;
      this._used = this._compression;
      try {
        await Promise.all(addEventPromises);
        this._fallback.clear();
      } catch (error) {
        DEBUG_BUILD5 && logger2.exception(error, "Failed to add events when switching buffers.");
      }
    }
  };
  function createEventBuffer({
    useCompression,
    workerUrl: customWorkerUrl
  }) {
    if (useCompression && // eslint-disable-next-line no-restricted-globals
    window.Worker) {
      const worker = _loadWorker(customWorkerUrl);
      if (worker) {
        return worker;
      }
    }
    DEBUG_BUILD5 && logger2.info("Using simple buffer");
    return new EventBufferArray();
  }
  function _loadWorker(customWorkerUrl) {
    try {
      const workerUrl = customWorkerUrl || _getWorkerUrl();
      if (!workerUrl) {
        return;
      }
      DEBUG_BUILD5 && logger2.info(`Using compression worker${customWorkerUrl ? ` from ${customWorkerUrl}` : ""}`);
      const worker = new Worker(workerUrl);
      return new EventBufferProxy(worker);
    } catch (error) {
      DEBUG_BUILD5 && logger2.exception(error, "Failed to create compression worker");
    }
  }
  function _getWorkerUrl() {
    if (typeof __SENTRY_EXCLUDE_REPLAY_WORKER__ === "undefined" || !__SENTRY_EXCLUDE_REPLAY_WORKER__) {
      return e();
    }
    return "";
  }
  function hasSessionStorage() {
    try {
      return "sessionStorage" in WINDOW6 && !!WINDOW6.sessionStorage;
    } catch (e2) {
      return false;
    }
  }
  function clearSession(replay) {
    deleteSession();
    replay.session = void 0;
  }
  function deleteSession() {
    if (!hasSessionStorage()) {
      return;
    }
    try {
      WINDOW6.sessionStorage.removeItem(REPLAY_SESSION_KEY);
    } catch (e2) {
    }
  }
  function isSampled(sampleRate) {
    if (sampleRate === void 0) {
      return false;
    }
    return Math.random() < sampleRate;
  }
  function makeSession2(session) {
    const now = Date.now();
    const id = session.id || uuid4();
    const started = session.started || now;
    const lastActivity = session.lastActivity || now;
    const segmentId = session.segmentId || 0;
    const sampled = session.sampled;
    const previousSessionId = session.previousSessionId;
    return {
      id,
      started,
      lastActivity,
      segmentId,
      sampled,
      previousSessionId
    };
  }
  function saveSession(session) {
    if (!hasSessionStorage()) {
      return;
    }
    try {
      WINDOW6.sessionStorage.setItem(REPLAY_SESSION_KEY, JSON.stringify(session));
    } catch (e2) {
    }
  }
  function getSessionSampleType(sessionSampleRate, allowBuffering) {
    return isSampled(sessionSampleRate) ? "session" : allowBuffering ? "buffer" : false;
  }
  function createSession({ sessionSampleRate, allowBuffering, stickySession = false }, { previousSessionId } = {}) {
    const sampled = getSessionSampleType(sessionSampleRate, allowBuffering);
    const session = makeSession2({
      sampled,
      previousSessionId
    });
    if (stickySession) {
      saveSession(session);
    }
    return session;
  }
  function fetchSession() {
    if (!hasSessionStorage()) {
      return null;
    }
    try {
      const sessionStringFromStorage = WINDOW6.sessionStorage.getItem(REPLAY_SESSION_KEY);
      if (!sessionStringFromStorage) {
        return null;
      }
      const sessionObj = JSON.parse(sessionStringFromStorage);
      DEBUG_BUILD5 && logger2.infoTick("Loading existing session");
      return makeSession2(sessionObj);
    } catch (e2) {
      return null;
    }
  }
  function isExpired(initialTime, expiry, targetTime = +/* @__PURE__ */ new Date()) {
    if (initialTime === null || expiry === void 0 || expiry < 0) {
      return true;
    }
    if (expiry === 0) {
      return false;
    }
    return initialTime + expiry <= targetTime;
  }
  function isSessionExpired(session, {
    maxReplayDuration,
    sessionIdleExpire,
    targetTime = Date.now()
  }) {
    return (
      // First, check that maximum session length has not been exceeded
      isExpired(session.started, maxReplayDuration, targetTime) || // check that the idle timeout has not been exceeded (i.e. user has
      // performed an action within the last `sessionIdleExpire` ms)
      isExpired(session.lastActivity, sessionIdleExpire, targetTime)
    );
  }
  function shouldRefreshSession(session, { sessionIdleExpire, maxReplayDuration }) {
    if (!isSessionExpired(session, { sessionIdleExpire, maxReplayDuration })) {
      return false;
    }
    if (session.sampled === "buffer" && session.segmentId === 0) {
      return false;
    }
    return true;
  }
  function loadOrCreateSession({
    sessionIdleExpire,
    maxReplayDuration,
    previousSessionId
  }, sessionOptions) {
    const existingSession = sessionOptions.stickySession && fetchSession();
    if (!existingSession) {
      DEBUG_BUILD5 && logger2.infoTick("Creating new session");
      return createSession(sessionOptions, { previousSessionId });
    }
    if (!shouldRefreshSession(existingSession, { sessionIdleExpire, maxReplayDuration })) {
      return existingSession;
    }
    DEBUG_BUILD5 && logger2.infoTick("Session in sessionStorage is expired, creating new one...");
    return createSession(sessionOptions, { previousSessionId: existingSession.id });
  }
  function isCustomEvent(event) {
    return event.type === EventType.Custom;
  }
  function addEventSync(replay, event, isCheckout) {
    if (!shouldAddEvent(replay, event)) {
      return false;
    }
    _addEvent(replay, event, isCheckout);
    return true;
  }
  function addEvent(replay, event, isCheckout) {
    if (!shouldAddEvent(replay, event)) {
      return Promise.resolve(null);
    }
    return _addEvent(replay, event, isCheckout);
  }
  async function _addEvent(replay, event, isCheckout) {
    if (!replay.eventBuffer) {
      return null;
    }
    try {
      if (isCheckout && replay.recordingMode === "buffer") {
        replay.eventBuffer.clear();
      }
      if (isCheckout) {
        replay.eventBuffer.hasCheckout = true;
      }
      const replayOptions = replay.getOptions();
      const eventAfterPossibleCallback = maybeApplyCallback(event, replayOptions.beforeAddRecordingEvent);
      if (!eventAfterPossibleCallback) {
        return;
      }
      return await replay.eventBuffer.addEvent(eventAfterPossibleCallback);
    } catch (error) {
      const reason = error && error instanceof EventBufferSizeExceededError ? "addEventSizeExceeded" : "addEvent";
      replay.handleException(error);
      await replay.stop({ reason });
      const client = getClient();
      if (client) {
        client.recordDroppedEvent("internal_sdk_error", "replay");
      }
    }
  }
  function shouldAddEvent(replay, event) {
    if (!replay.eventBuffer || replay.isPaused() || !replay.isEnabled()) {
      return false;
    }
    const timestampInMs = timestampToMs(event.timestamp);
    if (timestampInMs + replay.timeouts.sessionIdlePause < Date.now()) {
      return false;
    }
    if (timestampInMs > replay.getContext().initialTimestamp + replay.getOptions().maxReplayDuration) {
      DEBUG_BUILD5 && logger2.infoTick(`Skipping event with timestamp ${timestampInMs} because it is after maxReplayDuration`);
      return false;
    }
    return true;
  }
  function maybeApplyCallback(event, callback) {
    try {
      if (typeof callback === "function" && isCustomEvent(event)) {
        return callback(event);
      }
    } catch (error) {
      DEBUG_BUILD5 && logger2.exception(error, "An error occured in the `beforeAddRecordingEvent` callback, skipping the event...");
      return null;
    }
    return event;
  }
  function isErrorEvent3(event) {
    return !event.type;
  }
  function isTransactionEvent2(event) {
    return event.type === "transaction";
  }
  function isReplayEvent(event) {
    return event.type === "replay_event";
  }
  function isFeedbackEvent(event) {
    return event.type === "feedback";
  }
  function handleAfterSendEvent(replay) {
    return (event, sendResponse) => {
      if (!replay.isEnabled() || !isErrorEvent3(event) && !isTransactionEvent2(event)) {
        return;
      }
      const statusCode = sendResponse && sendResponse.statusCode;
      if (!statusCode || statusCode < 200 || statusCode >= 300) {
        return;
      }
      if (isTransactionEvent2(event)) {
        handleTransactionEvent(replay, event);
        return;
      }
      handleErrorEvent(replay, event);
    };
  }
  function handleTransactionEvent(replay, event) {
    const replayContext = replay.getContext();
    if (event.contexts && event.contexts.trace && event.contexts.trace.trace_id && replayContext.traceIds.size < 100) {
      replayContext.traceIds.add(event.contexts.trace.trace_id);
    }
  }
  function handleErrorEvent(replay, event) {
    const replayContext = replay.getContext();
    if (event.event_id && replayContext.errorIds.size < 100) {
      replayContext.errorIds.add(event.event_id);
    }
    if (replay.recordingMode !== "buffer" || !event.tags || !event.tags.replayId) {
      return;
    }
    const { beforeErrorSampling } = replay.getOptions();
    if (typeof beforeErrorSampling === "function" && !beforeErrorSampling(event)) {
      return;
    }
    setTimeout2(async () => {
      try {
        await replay.sendBufferedReplayOrFlush();
      } catch (err) {
        replay.handleException(err);
      }
    });
  }
  function handleBeforeSendEvent(replay) {
    return (event) => {
      if (!replay.isEnabled() || !isErrorEvent3(event)) {
        return;
      }
      handleHydrationError(replay, event);
    };
  }
  function handleHydrationError(replay, event) {
    const exceptionValue = event.exception && event.exception.values && event.exception.values[0] && event.exception.values[0].value;
    if (typeof exceptionValue !== "string") {
      return;
    }
    if (
      // Only matches errors in production builds of react-dom
      // Example https://reactjs.org/docs/error-decoder.html?invariant=423
      // With newer React versions, the messages changed to a different website https://react.dev/errors/418
      exceptionValue.match(
        /(reactjs\.org\/docs\/error-decoder\.html\?invariant=|react\.dev\/errors\/)(418|419|422|423|425)/
      ) || // Development builds of react-dom
      // Error 1: Hydration failed because the initial UI does not match what was rendered on the server.
      // Error 2: Text content does not match server-rendered HTML. Warning: Text content did not match.
      exceptionValue.match(/(does not match server-rendered HTML|Hydration failed because)/i)
    ) {
      const breadcrumb = createBreadcrumb({
        category: "replay.hydrate-error",
        data: {
          url: getLocationHref()
        }
      });
      addBreadcrumbEvent(replay, breadcrumb);
    }
  }
  function handleBreadcrumbs(replay) {
    const client = getClient();
    if (!client) {
      return;
    }
    client.on("beforeAddBreadcrumb", (breadcrumb) => beforeAddBreadcrumb(replay, breadcrumb));
  }
  function beforeAddBreadcrumb(replay, breadcrumb) {
    if (!replay.isEnabled() || !isBreadcrumbWithCategory(breadcrumb)) {
      return;
    }
    const result = normalizeBreadcrumb(breadcrumb);
    if (result) {
      addBreadcrumbEvent(replay, result);
    }
  }
  function normalizeBreadcrumb(breadcrumb) {
    if (!isBreadcrumbWithCategory(breadcrumb) || [
      // fetch & xhr are handled separately,in handleNetworkBreadcrumbs
      "fetch",
      "xhr",
      // These two are breadcrumbs for emitted sentry events, we don't care about them
      "sentry.event",
      "sentry.transaction"
    ].includes(breadcrumb.category) || // We capture UI breadcrumbs separately
    breadcrumb.category.startsWith("ui.")) {
      return null;
    }
    if (breadcrumb.category === "console") {
      return normalizeConsoleBreadcrumb(breadcrumb);
    }
    return createBreadcrumb(breadcrumb);
  }
  function normalizeConsoleBreadcrumb(breadcrumb) {
    const args = breadcrumb.data && breadcrumb.data.arguments;
    if (!Array.isArray(args) || args.length === 0) {
      return createBreadcrumb(breadcrumb);
    }
    let isTruncated = false;
    const normalizedArgs = args.map((arg) => {
      if (!arg) {
        return arg;
      }
      if (typeof arg === "string") {
        if (arg.length > CONSOLE_ARG_MAX_SIZE) {
          isTruncated = true;
          return `${arg.slice(0, CONSOLE_ARG_MAX_SIZE)}\u2026`;
        }
        return arg;
      }
      if (typeof arg === "object") {
        try {
          const normalizedArg = normalize(arg, 7);
          const stringified = JSON.stringify(normalizedArg);
          if (stringified.length > CONSOLE_ARG_MAX_SIZE) {
            isTruncated = true;
            return `${JSON.stringify(normalizedArg, null, 2).slice(0, CONSOLE_ARG_MAX_SIZE)}\u2026`;
          }
          return normalizedArg;
        } catch (e2) {
        }
      }
      return arg;
    });
    return createBreadcrumb({
      ...breadcrumb,
      data: {
        ...breadcrumb.data,
        arguments: normalizedArgs,
        ...isTruncated ? { _meta: { warnings: ["CONSOLE_ARG_TRUNCATED"] } } : {}
      }
    });
  }
  function isBreadcrumbWithCategory(breadcrumb) {
    return !!breadcrumb.category;
  }
  function isRrwebError(event, hint) {
    if (event.type || !event.exception || !event.exception.values || !event.exception.values.length) {
      return false;
    }
    if (hint.originalException && hint.originalException.__rrweb__) {
      return true;
    }
    return false;
  }
  function addFeedbackBreadcrumb(replay, event) {
    replay.triggerUserActivity();
    replay.addUpdate(() => {
      if (!event.timestamp) {
        return true;
      }
      replay.throttledAddEvent({
        type: EventType.Custom,
        timestamp: event.timestamp * 1e3,
        data: {
          tag: "breadcrumb",
          payload: {
            timestamp: event.timestamp,
            type: "default",
            category: "sentry.feedback",
            data: {
              feedbackId: event.event_id
            }
          }
        }
      });
      return false;
    });
  }
  function shouldSampleForBufferEvent(replay, event) {
    if (replay.recordingMode !== "buffer") {
      return false;
    }
    if (event.message === UNABLE_TO_SEND_REPLAY) {
      return false;
    }
    if (!event.exception || event.type) {
      return false;
    }
    return isSampled(replay.getOptions().errorSampleRate);
  }
  function handleGlobalEventListener(replay) {
    return Object.assign(
      (event, hint) => {
        if (!replay.isEnabled() || replay.isPaused()) {
          return event;
        }
        if (isReplayEvent(event)) {
          delete event.breadcrumbs;
          return event;
        }
        if (!isErrorEvent3(event) && !isTransactionEvent2(event) && !isFeedbackEvent(event)) {
          return event;
        }
        const isSessionActive = replay.checkAndHandleExpiredSession();
        if (!isSessionActive) {
          return event;
        }
        if (isFeedbackEvent(event)) {
          replay.flush();
          event.contexts.feedback.replay_id = replay.getSessionId();
          addFeedbackBreadcrumb(replay, event);
          return event;
        }
        if (isRrwebError(event, hint) && !replay.getOptions()._experiments.captureExceptions) {
          DEBUG_BUILD5 && logger2.log("Ignoring error from rrweb internals", event);
          return null;
        }
        const isErrorEventSampled = shouldSampleForBufferEvent(replay, event);
        const shouldTagReplayId = isErrorEventSampled || replay.recordingMode === "session";
        if (shouldTagReplayId) {
          event.tags = { ...event.tags, replayId: replay.getSessionId() };
        }
        return event;
      },
      { id: "Replay" }
    );
  }
  function createPerformanceSpans(replay, entries) {
    return entries.map(({ type, start: start2, end, name, data }) => {
      const response = replay.throttledAddEvent({
        type: EventType.Custom,
        timestamp: start2,
        data: {
          tag: "performanceSpan",
          payload: {
            op: type,
            description: name,
            startTimestamp: start2,
            endTimestamp: end,
            data
          }
        }
      });
      return typeof response === "string" ? Promise.resolve(null) : response;
    });
  }
  function handleHistory(handlerData) {
    const { from, to } = handlerData;
    const now = Date.now() / 1e3;
    return {
      type: "navigation.push",
      start: now,
      end: now,
      name: to,
      data: {
        previous: from
      }
    };
  }
  function handleHistorySpanListener(replay) {
    return (handlerData) => {
      if (!replay.isEnabled()) {
        return;
      }
      const result = handleHistory(handlerData);
      if (result === null) {
        return;
      }
      replay.getContext().urls.push(result.name);
      replay.triggerUserActivity();
      replay.addUpdate(() => {
        createPerformanceSpans(replay, [result]);
        return false;
      });
    };
  }
  function shouldFilterRequest(replay, url) {
    if (DEBUG_BUILD5 && replay.getOptions()._experiments.traceInternals) {
      return false;
    }
    return isSentryRequestUrl(url, getClient());
  }
  function addNetworkBreadcrumb(replay, result) {
    if (!replay.isEnabled()) {
      return;
    }
    if (result === null) {
      return;
    }
    if (shouldFilterRequest(replay, result.name)) {
      return;
    }
    replay.addUpdate(() => {
      createPerformanceSpans(replay, [result]);
      return true;
    });
  }
  function getBodySize(body) {
    if (!body) {
      return void 0;
    }
    const textEncoder = new TextEncoder();
    try {
      if (typeof body === "string") {
        return textEncoder.encode(body).length;
      }
      if (body instanceof URLSearchParams) {
        return textEncoder.encode(body.toString()).length;
      }
      if (body instanceof FormData) {
        const formDataStr = _serializeFormData(body);
        return textEncoder.encode(formDataStr).length;
      }
      if (body instanceof Blob) {
        return body.size;
      }
      if (body instanceof ArrayBuffer) {
        return body.byteLength;
      }
    } catch (e2) {
    }
    return void 0;
  }
  function parseContentLengthHeader(header) {
    if (!header) {
      return void 0;
    }
    const size = parseInt(header, 10);
    return isNaN(size) ? void 0 : size;
  }
  function getBodyString(body) {
    try {
      if (typeof body === "string") {
        return [body];
      }
      if (body instanceof URLSearchParams) {
        return [body.toString()];
      }
      if (body instanceof FormData) {
        return [_serializeFormData(body)];
      }
      if (!body) {
        return [void 0];
      }
    } catch (error) {
      DEBUG_BUILD5 && logger2.exception(error, "Failed to serialize body", body);
      return [void 0, "BODY_PARSE_ERROR"];
    }
    DEBUG_BUILD5 && logger2.info("Skipping network body because of body type", body);
    return [void 0, "UNPARSEABLE_BODY_TYPE"];
  }
  function mergeWarning(info, warning) {
    if (!info) {
      return {
        headers: {},
        size: void 0,
        _meta: {
          warnings: [warning]
        }
      };
    }
    const newMeta = { ...info._meta };
    const existingWarnings = newMeta.warnings || [];
    newMeta.warnings = [...existingWarnings, warning];
    info._meta = newMeta;
    return info;
  }
  function makeNetworkReplayBreadcrumb(type, data) {
    if (!data) {
      return null;
    }
    const { startTimestamp, endTimestamp, url, method, statusCode, request, response } = data;
    const result = {
      type,
      start: startTimestamp / 1e3,
      end: endTimestamp / 1e3,
      name: url,
      data: dropUndefinedKeys({
        method,
        statusCode,
        request,
        response
      })
    };
    return result;
  }
  function buildSkippedNetworkRequestOrResponse(bodySize) {
    return {
      headers: {},
      size: bodySize,
      _meta: {
        warnings: ["URL_SKIPPED"]
      }
    };
  }
  function buildNetworkRequestOrResponse(headers, bodySize, body) {
    if (!bodySize && Object.keys(headers).length === 0) {
      return void 0;
    }
    if (!bodySize) {
      return {
        headers
      };
    }
    if (!body) {
      return {
        headers,
        size: bodySize
      };
    }
    const info = {
      headers,
      size: bodySize
    };
    const { body: normalizedBody, warnings } = normalizeNetworkBody(body);
    info.body = normalizedBody;
    if (warnings && warnings.length > 0) {
      info._meta = {
        warnings
      };
    }
    return info;
  }
  function getAllowedHeaders(headers, allowedHeaders) {
    return Object.entries(headers).reduce((filteredHeaders, [key, value]) => {
      const normalizedKey = key.toLowerCase();
      if (allowedHeaders.includes(normalizedKey) && headers[key]) {
        filteredHeaders[normalizedKey] = value;
      }
      return filteredHeaders;
    }, {});
  }
  function _serializeFormData(formData) {
    return new URLSearchParams(formData).toString();
  }
  function normalizeNetworkBody(body) {
    if (!body || typeof body !== "string") {
      return {
        body
      };
    }
    const exceedsSizeLimit = body.length > NETWORK_BODY_MAX_SIZE;
    const isProbablyJson = _strIsProbablyJson(body);
    if (exceedsSizeLimit) {
      const truncatedBody = body.slice(0, NETWORK_BODY_MAX_SIZE);
      if (isProbablyJson) {
        return {
          body: truncatedBody,
          warnings: ["MAYBE_JSON_TRUNCATED"]
        };
      }
      return {
        body: `${truncatedBody}\u2026`,
        warnings: ["TEXT_TRUNCATED"]
      };
    }
    if (isProbablyJson) {
      try {
        const jsonBody = JSON.parse(body);
        return {
          body: jsonBody
        };
      } catch (e2) {
      }
    }
    return {
      body
    };
  }
  function _strIsProbablyJson(str) {
    const first = str[0];
    const last = str[str.length - 1];
    return first === "[" && last === "]" || first === "{" && last === "}";
  }
  function urlMatches(url, urls) {
    const fullUrl = getFullUrl(url);
    return stringMatchesSomePattern(fullUrl, urls);
  }
  function getFullUrl(url, baseURI = WINDOW6.document.baseURI) {
    if (url.startsWith("http://") || url.startsWith("https://") || url.startsWith(WINDOW6.location.origin)) {
      return url;
    }
    const fixedUrl = new URL(url, baseURI);
    if (fixedUrl.origin !== new URL(baseURI).origin) {
      return url;
    }
    const fullUrl = fixedUrl.href;
    if (!url.endsWith("/") && fullUrl.endsWith("/")) {
      return fullUrl.slice(0, -1);
    }
    return fullUrl;
  }
  async function captureFetchBreadcrumbToReplay(breadcrumb, hint, options) {
    try {
      const data = await _prepareFetchData(breadcrumb, hint, options);
      const result = makeNetworkReplayBreadcrumb("resource.fetch", data);
      addNetworkBreadcrumb(options.replay, result);
    } catch (error) {
      DEBUG_BUILD5 && logger2.exception(error, "Failed to capture fetch breadcrumb");
    }
  }
  function enrichFetchBreadcrumb(breadcrumb, hint) {
    const { input, response } = hint;
    const body = input ? _getFetchRequestArgBody(input) : void 0;
    const reqSize = getBodySize(body);
    const resSize = response ? parseContentLengthHeader(response.headers.get("content-length")) : void 0;
    if (reqSize !== void 0) {
      breadcrumb.data.request_body_size = reqSize;
    }
    if (resSize !== void 0) {
      breadcrumb.data.response_body_size = resSize;
    }
  }
  async function _prepareFetchData(breadcrumb, hint, options) {
    const now = Date.now();
    const { startTimestamp = now, endTimestamp = now } = hint;
    const {
      url,
      method,
      status_code: statusCode = 0,
      request_body_size: requestBodySize,
      response_body_size: responseBodySize
    } = breadcrumb.data;
    const captureDetails = urlMatches(url, options.networkDetailAllowUrls) && !urlMatches(url, options.networkDetailDenyUrls);
    const request = captureDetails ? _getRequestInfo(options, hint.input, requestBodySize) : buildSkippedNetworkRequestOrResponse(requestBodySize);
    const response = await _getResponseInfo(captureDetails, options, hint.response, responseBodySize);
    return {
      startTimestamp,
      endTimestamp,
      url,
      method,
      statusCode,
      request,
      response
    };
  }
  function _getRequestInfo({ networkCaptureBodies, networkRequestHeaders }, input, requestBodySize) {
    const headers = input ? getRequestHeaders(input, networkRequestHeaders) : {};
    if (!networkCaptureBodies) {
      return buildNetworkRequestOrResponse(headers, requestBodySize, void 0);
    }
    const requestBody = _getFetchRequestArgBody(input);
    const [bodyStr, warning] = getBodyString(requestBody);
    const data = buildNetworkRequestOrResponse(headers, requestBodySize, bodyStr);
    if (warning) {
      return mergeWarning(data, warning);
    }
    return data;
  }
  async function _getResponseInfo(captureDetails, {
    networkCaptureBodies,
    networkResponseHeaders
  }, response, responseBodySize) {
    if (!captureDetails && responseBodySize !== void 0) {
      return buildSkippedNetworkRequestOrResponse(responseBodySize);
    }
    const headers = response ? getAllHeaders(response.headers, networkResponseHeaders) : {};
    if (!response || !networkCaptureBodies && responseBodySize !== void 0) {
      return buildNetworkRequestOrResponse(headers, responseBodySize, void 0);
    }
    const [bodyText, warning] = await _parseFetchResponseBody(response);
    const result = getResponseData(bodyText, {
      networkCaptureBodies,
      responseBodySize,
      captureDetails,
      headers
    });
    if (warning) {
      return mergeWarning(result, warning);
    }
    return result;
  }
  function getResponseData(bodyText, {
    networkCaptureBodies,
    responseBodySize,
    captureDetails,
    headers
  }) {
    try {
      const size = bodyText && bodyText.length && responseBodySize === void 0 ? getBodySize(bodyText) : responseBodySize;
      if (!captureDetails) {
        return buildSkippedNetworkRequestOrResponse(size);
      }
      if (networkCaptureBodies) {
        return buildNetworkRequestOrResponse(headers, size, bodyText);
      }
      return buildNetworkRequestOrResponse(headers, size, void 0);
    } catch (error) {
      DEBUG_BUILD5 && logger2.exception(error, "Failed to serialize response body");
      return buildNetworkRequestOrResponse(headers, responseBodySize, void 0);
    }
  }
  async function _parseFetchResponseBody(response) {
    const res = _tryCloneResponse(response);
    if (!res) {
      return [void 0, "BODY_PARSE_ERROR"];
    }
    try {
      const text = await _tryGetResponseText(res);
      return [text];
    } catch (error) {
      if (error instanceof Error && error.message.indexOf("Timeout") > -1) {
        DEBUG_BUILD5 && logger2.warn("Parsing text body from response timed out");
        return [void 0, "BODY_PARSE_TIMEOUT"];
      }
      DEBUG_BUILD5 && logger2.exception(error, "Failed to get text body from response");
      return [void 0, "BODY_PARSE_ERROR"];
    }
  }
  function _getFetchRequestArgBody(fetchArgs = []) {
    if (fetchArgs.length !== 2 || typeof fetchArgs[1] !== "object") {
      return void 0;
    }
    return fetchArgs[1].body;
  }
  function getAllHeaders(headers, allowedHeaders) {
    const allHeaders = {};
    allowedHeaders.forEach((header) => {
      if (headers.get(header)) {
        allHeaders[header] = headers.get(header);
      }
    });
    return allHeaders;
  }
  function getRequestHeaders(fetchArgs, allowedHeaders) {
    if (fetchArgs.length === 1 && typeof fetchArgs[0] !== "string") {
      return getHeadersFromOptions(fetchArgs[0], allowedHeaders);
    }
    if (fetchArgs.length === 2) {
      return getHeadersFromOptions(fetchArgs[1], allowedHeaders);
    }
    return {};
  }
  function getHeadersFromOptions(input, allowedHeaders) {
    if (!input) {
      return {};
    }
    const headers = input.headers;
    if (!headers) {
      return {};
    }
    if (headers instanceof Headers) {
      return getAllHeaders(headers, allowedHeaders);
    }
    if (Array.isArray(headers)) {
      return {};
    }
    return getAllowedHeaders(headers, allowedHeaders);
  }
  function _tryCloneResponse(response) {
    try {
      return response.clone();
    } catch (error) {
      DEBUG_BUILD5 && logger2.exception(error, "Failed to clone response body");
    }
  }
  function _tryGetResponseText(response) {
    return new Promise((resolve, reject) => {
      const timeout = setTimeout2(() => reject(new Error("Timeout while trying to read response body")), 500);
      _getResponseText(response).then(
        (txt) => resolve(txt),
        (reason) => reject(reason)
      ).finally(() => clearTimeout(timeout));
    });
  }
  async function _getResponseText(response) {
    return await response.text();
  }
  async function captureXhrBreadcrumbToReplay(breadcrumb, hint, options) {
    try {
      const data = _prepareXhrData(breadcrumb, hint, options);
      const result = makeNetworkReplayBreadcrumb("resource.xhr", data);
      addNetworkBreadcrumb(options.replay, result);
    } catch (error) {
      DEBUG_BUILD5 && logger2.exception(error, "Failed to capture xhr breadcrumb");
    }
  }
  function enrichXhrBreadcrumb(breadcrumb, hint) {
    const { xhr, input } = hint;
    if (!xhr) {
      return;
    }
    const reqSize = getBodySize(input);
    const resSize = xhr.getResponseHeader("content-length") ? parseContentLengthHeader(xhr.getResponseHeader("content-length")) : _getBodySize(xhr.response, xhr.responseType);
    if (reqSize !== void 0) {
      breadcrumb.data.request_body_size = reqSize;
    }
    if (resSize !== void 0) {
      breadcrumb.data.response_body_size = resSize;
    }
  }
  function _prepareXhrData(breadcrumb, hint, options) {
    const now = Date.now();
    const { startTimestamp = now, endTimestamp = now, input, xhr } = hint;
    const {
      url,
      method,
      status_code: statusCode = 0,
      request_body_size: requestBodySize,
      response_body_size: responseBodySize
    } = breadcrumb.data;
    if (!url) {
      return null;
    }
    if (!xhr || !urlMatches(url, options.networkDetailAllowUrls) || urlMatches(url, options.networkDetailDenyUrls)) {
      const request2 = buildSkippedNetworkRequestOrResponse(requestBodySize);
      const response2 = buildSkippedNetworkRequestOrResponse(responseBodySize);
      return {
        startTimestamp,
        endTimestamp,
        url,
        method,
        statusCode,
        request: request2,
        response: response2
      };
    }
    const xhrInfo = xhr[SENTRY_XHR_DATA_KEY];
    const networkRequestHeaders = xhrInfo ? getAllowedHeaders(xhrInfo.request_headers, options.networkRequestHeaders) : {};
    const networkResponseHeaders = getAllowedHeaders(getResponseHeaders(xhr), options.networkResponseHeaders);
    const [requestBody, requestWarning] = options.networkCaptureBodies ? getBodyString(input) : [void 0];
    const [responseBody, responseWarning] = options.networkCaptureBodies ? _getXhrResponseBody(xhr) : [void 0];
    const request = buildNetworkRequestOrResponse(networkRequestHeaders, requestBodySize, requestBody);
    const response = buildNetworkRequestOrResponse(networkResponseHeaders, responseBodySize, responseBody);
    return {
      startTimestamp,
      endTimestamp,
      url,
      method,
      statusCode,
      request: requestWarning ? mergeWarning(request, requestWarning) : request,
      response: responseWarning ? mergeWarning(response, responseWarning) : response
    };
  }
  function getResponseHeaders(xhr) {
    const headers = xhr.getAllResponseHeaders();
    if (!headers) {
      return {};
    }
    return headers.split("\r\n").reduce((acc, line) => {
      const [key, value] = line.split(": ");
      if (value) {
        acc[key.toLowerCase()] = value;
      }
      return acc;
    }, {});
  }
  function _getXhrResponseBody(xhr) {
    const errors = [];
    try {
      return [xhr.responseText];
    } catch (e2) {
      errors.push(e2);
    }
    try {
      return _parseXhrResponse(xhr.response, xhr.responseType);
    } catch (e2) {
      errors.push(e2);
    }
    DEBUG_BUILD5 && logger2.warn("Failed to get xhr response body", ...errors);
    return [void 0];
  }
  function _parseXhrResponse(body, responseType) {
    try {
      if (typeof body === "string") {
        return [body];
      }
      if (body instanceof Document) {
        return [body.body.outerHTML];
      }
      if (responseType === "json" && body && typeof body === "object") {
        return [JSON.stringify(body)];
      }
      if (!body) {
        return [void 0];
      }
    } catch (error) {
      DEBUG_BUILD5 && logger2.exception(error, "Failed to serialize body", body);
      return [void 0, "BODY_PARSE_ERROR"];
    }
    DEBUG_BUILD5 && logger2.info("Skipping network body because of body type", body);
    return [void 0, "UNPARSEABLE_BODY_TYPE"];
  }
  function _getBodySize(body, responseType) {
    try {
      const bodyStr = responseType === "json" && body && typeof body === "object" ? JSON.stringify(body) : body;
      return getBodySize(bodyStr);
    } catch (e2) {
      return void 0;
    }
  }
  function handleNetworkBreadcrumbs(replay) {
    const client = getClient();
    try {
      const {
        networkDetailAllowUrls,
        networkDetailDenyUrls,
        networkCaptureBodies,
        networkRequestHeaders,
        networkResponseHeaders
      } = replay.getOptions();
      const options = {
        replay,
        networkDetailAllowUrls,
        networkDetailDenyUrls,
        networkCaptureBodies,
        networkRequestHeaders,
        networkResponseHeaders
      };
      if (client) {
        client.on("beforeAddBreadcrumb", (breadcrumb, hint) => beforeAddNetworkBreadcrumb(options, breadcrumb, hint));
      }
    } catch (e2) {
    }
  }
  function beforeAddNetworkBreadcrumb(options, breadcrumb, hint) {
    if (!breadcrumb.data) {
      return;
    }
    try {
      if (_isXhrBreadcrumb(breadcrumb) && _isXhrHint(hint)) {
        enrichXhrBreadcrumb(breadcrumb, hint);
        captureXhrBreadcrumbToReplay(breadcrumb, hint, options);
      }
      if (_isFetchBreadcrumb(breadcrumb) && _isFetchHint(hint)) {
        enrichFetchBreadcrumb(breadcrumb, hint);
        captureFetchBreadcrumbToReplay(breadcrumb, hint, options);
      }
    } catch (e2) {
      DEBUG_BUILD5 && logger2.exception(e2, "Error when enriching network breadcrumb");
    }
  }
  function _isXhrBreadcrumb(breadcrumb) {
    return breadcrumb.category === "xhr";
  }
  function _isFetchBreadcrumb(breadcrumb) {
    return breadcrumb.category === "fetch";
  }
  function _isXhrHint(hint) {
    return hint && hint.xhr;
  }
  function _isFetchHint(hint) {
    return hint && hint.response;
  }
  function addGlobalListeners(replay) {
    const client = getClient();
    addClickKeypressInstrumentationHandler(handleDomListener(replay));
    addHistoryInstrumentationHandler(handleHistorySpanListener(replay));
    handleBreadcrumbs(replay);
    handleNetworkBreadcrumbs(replay);
    const eventProcessor = handleGlobalEventListener(replay);
    addEventProcessor(eventProcessor);
    if (client) {
      client.on("beforeSendEvent", handleBeforeSendEvent(replay));
      client.on("afterSendEvent", handleAfterSendEvent(replay));
      client.on("createDsc", (dsc) => {
        const replayId = replay.getSessionId();
        if (replayId && replay.isEnabled() && replay.recordingMode === "session") {
          const isSessionActive = replay.checkAndHandleExpiredSession();
          if (isSessionActive) {
            dsc.replay_id = replayId;
          }
        }
      });
      client.on("spanStart", (span) => {
        replay.lastActiveSpan = span;
      });
      client.on("spanEnd", (span) => {
        replay.lastActiveSpan = span;
      });
      client.on("beforeSendFeedback", (feedbackEvent, options) => {
        const replayId = replay.getSessionId();
        if (options && options.includeReplay && replay.isEnabled() && replayId) {
          if (feedbackEvent.contexts && feedbackEvent.contexts.feedback) {
            feedbackEvent.contexts.feedback.replay_id = replayId;
          }
        }
      });
    }
  }
  async function addMemoryEntry(replay) {
    try {
      return Promise.all(
        createPerformanceSpans(replay, [
          // @ts-expect-error memory doesn't exist on type Performance as the API is non-standard (we check that it exists above)
          createMemoryEntry(WINDOW6.performance.memory)
        ])
      );
    } catch (error) {
      return [];
    }
  }
  function createMemoryEntry(memoryEntry) {
    const { jsHeapSizeLimit, totalJSHeapSize, usedJSHeapSize } = memoryEntry;
    const time = Date.now() / 1e3;
    return {
      type: "memory",
      name: "memory",
      start: time,
      end: time,
      data: {
        memory: {
          jsHeapSizeLimit,
          totalJSHeapSize,
          usedJSHeapSize
        }
      }
    };
  }
  function debounce(func, wait, options) {
    let callbackReturnValue;
    let timerId;
    let maxTimerId;
    const maxWait = options && options.maxWait ? Math.max(options.maxWait, wait) : 0;
    function invokeFunc() {
      cancelTimers();
      callbackReturnValue = func();
      return callbackReturnValue;
    }
    function cancelTimers() {
      timerId !== void 0 && clearTimeout(timerId);
      maxTimerId !== void 0 && clearTimeout(maxTimerId);
      timerId = maxTimerId = void 0;
    }
    function flush2() {
      if (timerId !== void 0 || maxTimerId !== void 0) {
        return invokeFunc();
      }
      return callbackReturnValue;
    }
    function debounced() {
      if (timerId) {
        clearTimeout(timerId);
      }
      timerId = setTimeout2(invokeFunc, wait);
      if (maxWait && maxTimerId === void 0) {
        maxTimerId = setTimeout2(invokeFunc, maxWait);
      }
      return callbackReturnValue;
    }
    debounced.cancel = cancelTimers;
    debounced.flush = flush2;
    return debounced;
  }
  function getHandleRecordingEmit(replay) {
    let hadFirstEvent = false;
    return (event, _isCheckout) => {
      if (!replay.checkAndHandleExpiredSession()) {
        DEBUG_BUILD5 && logger2.warn("Received replay event after session expired.");
        return;
      }
      const isCheckout = _isCheckout || !hadFirstEvent;
      hadFirstEvent = true;
      if (replay.clickDetector) {
        updateClickDetectorForRecordingEvent(replay.clickDetector, event);
      }
      replay.addUpdate(() => {
        if (replay.recordingMode === "buffer" && isCheckout) {
          replay.setInitialState();
        }
        if (!addEventSync(replay, event, isCheckout)) {
          return true;
        }
        if (!isCheckout) {
          return false;
        }
        const session = replay.session;
        addSettingsEvent(replay, isCheckout);
        if (replay.recordingMode === "buffer" && session && replay.eventBuffer) {
          const earliestEvent = replay.eventBuffer.getEarliestTimestamp();
          if (earliestEvent) {
            DEBUG_BUILD5 && logger2.info(`Updating session start time to earliest event in buffer to ${new Date(earliestEvent)}`);
            session.started = earliestEvent;
            if (replay.getOptions().stickySession) {
              saveSession(session);
            }
          }
        }
        if (session && session.previousSessionId) {
          return true;
        }
        if (replay.recordingMode === "session") {
          void replay.flush();
        }
        return true;
      });
    };
  }
  function createOptionsEvent(replay) {
    const options = replay.getOptions();
    return {
      type: EventType.Custom,
      timestamp: Date.now(),
      data: {
        tag: "options",
        payload: {
          shouldRecordCanvas: replay.isRecordingCanvas(),
          sessionSampleRate: options.sessionSampleRate,
          errorSampleRate: options.errorSampleRate,
          useCompressionOption: options.useCompression,
          blockAllMedia: options.blockAllMedia,
          maskAllText: options.maskAllText,
          maskAllInputs: options.maskAllInputs,
          useCompression: replay.eventBuffer ? replay.eventBuffer.type === "worker" : false,
          networkDetailHasUrls: options.networkDetailAllowUrls.length > 0,
          networkCaptureBodies: options.networkCaptureBodies,
          networkRequestHasHeaders: options.networkRequestHeaders.length > 0,
          networkResponseHasHeaders: options.networkResponseHeaders.length > 0
        }
      }
    };
  }
  function addSettingsEvent(replay, isCheckout) {
    if (!isCheckout || !replay.session || replay.session.segmentId !== 0) {
      return;
    }
    addEventSync(replay, createOptionsEvent(replay), false);
  }
  function resetReplayIdOnDynamicSamplingContext() {
    const dsc = getCurrentScope().getPropagationContext().dsc;
    if (dsc) {
      delete dsc.replay_id;
    }
    const activeSpan = getActiveSpan();
    if (activeSpan) {
      const dsc2 = getDynamicSamplingContextFromSpan(activeSpan);
      delete dsc2.replay_id;
    }
  }
  function createReplayEnvelope(replayEvent, recordingData, dsn, tunnel) {
    return createEnvelope(
      createEventEnvelopeHeaders(replayEvent, getSdkMetadataForEnvelopeHeader(replayEvent), tunnel, dsn),
      [
        [{ type: "replay_event" }, replayEvent],
        [
          {
            type: "replay_recording",
            // If string then we need to encode to UTF8, otherwise will have
            // wrong size. TextEncoder has similar browser support to
            // MutationObserver, although it does not accept IE11.
            length: typeof recordingData === "string" ? new TextEncoder().encode(recordingData).length : recordingData.length
          },
          recordingData
        ]
      ]
    );
  }
  function prepareRecordingData({
    recordingData,
    headers
  }) {
    let payloadWithSequence;
    const replayHeaders = `${JSON.stringify(headers)}
`;
    if (typeof recordingData === "string") {
      payloadWithSequence = `${replayHeaders}${recordingData}`;
    } else {
      const enc = new TextEncoder();
      const sequence = enc.encode(replayHeaders);
      payloadWithSequence = new Uint8Array(sequence.length + recordingData.length);
      payloadWithSequence.set(sequence);
      payloadWithSequence.set(recordingData, sequence.length);
    }
    return payloadWithSequence;
  }
  async function prepareReplayEvent({
    client,
    scope,
    replayId: event_id,
    event
  }) {
    const integrations = typeof client._integrations === "object" && client._integrations !== null && !Array.isArray(client._integrations) ? Object.keys(client._integrations) : void 0;
    const eventHint = { event_id, integrations };
    client.emit("preprocessEvent", event, eventHint);
    const preparedEvent = await prepareEvent(
      client.getOptions(),
      event,
      eventHint,
      scope,
      client,
      getIsolationScope()
    );
    if (!preparedEvent) {
      return null;
    }
    preparedEvent.platform = preparedEvent.platform || "javascript";
    const metadata = client.getSdkMetadata();
    const { name, version } = metadata && metadata.sdk || {};
    preparedEvent.sdk = {
      ...preparedEvent.sdk,
      name: name || "sentry.javascript.unknown",
      version: version || "0.0.0"
    };
    return preparedEvent;
  }
  async function sendReplayRequest({
    recordingData,
    replayId,
    segmentId: segment_id,
    eventContext,
    timestamp,
    session
  }) {
    const preparedRecordingData = prepareRecordingData({
      recordingData,
      headers: {
        segment_id
      }
    });
    const { urls, errorIds, traceIds, initialTimestamp } = eventContext;
    const client = getClient();
    const scope = getCurrentScope();
    const transport = client && client.getTransport();
    const dsn = client && client.getDsn();
    if (!client || !transport || !dsn || !session.sampled) {
      return resolvedSyncPromise({});
    }
    const baseEvent = {
      type: REPLAY_EVENT_NAME,
      replay_start_timestamp: initialTimestamp / 1e3,
      timestamp: timestamp / 1e3,
      error_ids: errorIds,
      trace_ids: traceIds,
      urls,
      replay_id: replayId,
      segment_id,
      replay_type: session.sampled
    };
    const replayEvent = await prepareReplayEvent({ scope, client, replayId, event: baseEvent });
    if (!replayEvent) {
      client.recordDroppedEvent("event_processor", "replay", baseEvent);
      DEBUG_BUILD5 && logger2.info("An event processor returned `null`, will not send event.");
      return resolvedSyncPromise({});
    }
    delete replayEvent.sdkProcessingMetadata;
    const envelope = createReplayEnvelope(replayEvent, preparedRecordingData, dsn, client.getOptions().tunnel);
    let response;
    try {
      response = await transport.send(envelope);
    } catch (err) {
      const error = new Error(UNABLE_TO_SEND_REPLAY);
      try {
        error.cause = err;
      } catch (e2) {
      }
      throw error;
    }
    if (typeof response.statusCode === "number" && (response.statusCode < 200 || response.statusCode >= 300)) {
      throw new TransportStatusCodeError(response.statusCode);
    }
    const rateLimits = updateRateLimits({}, response);
    if (isRateLimited(rateLimits, "replay")) {
      throw new RateLimitError(rateLimits);
    }
    return response;
  }
  var TransportStatusCodeError = class extends Error {
    constructor(statusCode) {
      super(`Transport returned status code ${statusCode}`);
    }
  };
  var RateLimitError = class extends Error {
    constructor(rateLimits) {
      super("Rate limit hit");
      this.rateLimits = rateLimits;
    }
  };
  async function sendReplay(replayData, retryConfig = {
    count: 0,
    interval: RETRY_BASE_INTERVAL
  }) {
    const { recordingData, onError } = replayData;
    if (!recordingData.length) {
      return;
    }
    try {
      await sendReplayRequest(replayData);
      return true;
    } catch (err) {
      if (err instanceof TransportStatusCodeError || err instanceof RateLimitError) {
        throw err;
      }
      setContext("Replays", {
        _retryCount: retryConfig.count
      });
      if (onError) {
        onError(err);
      }
      if (retryConfig.count >= RETRY_MAX_COUNT) {
        const error = new Error(`${UNABLE_TO_SEND_REPLAY} - max retries exceeded`);
        try {
          error.cause = err;
        } catch (e2) {
        }
        throw error;
      }
      retryConfig.interval *= ++retryConfig.count;
      return new Promise((resolve, reject) => {
        setTimeout2(async () => {
          try {
            await sendReplay(replayData, retryConfig);
            resolve(true);
          } catch (err2) {
            reject(err2);
          }
        }, retryConfig.interval);
      });
    }
  }
  var THROTTLED = "__THROTTLED";
  var SKIPPED = "__SKIPPED";
  function throttle(fn, maxCount, durationSeconds) {
    const counter = /* @__PURE__ */ new Map();
    const _cleanup = (now) => {
      const threshold = now - durationSeconds;
      counter.forEach((_value, key) => {
        if (key < threshold) {
          counter.delete(key);
        }
      });
    };
    const _getTotalCount = () => {
      return [...counter.values()].reduce((a, b) => a + b, 0);
    };
    let isThrottled = false;
    return (...rest) => {
      const now = Math.floor(Date.now() / 1e3);
      _cleanup(now);
      if (_getTotalCount() >= maxCount) {
        const wasThrottled = isThrottled;
        isThrottled = true;
        return wasThrottled ? SKIPPED : THROTTLED;
      }
      isThrottled = false;
      const count = counter.get(now) || 0;
      counter.set(now, count + 1);
      return fn(...rest);
    };
  }
  var ReplayContainer = class _ReplayContainer {
    /**
     * Recording can happen in one of three modes:
     *   - session: Record the whole session, sending it continuously
     *   - buffer: Always keep the last 60s of recording, requires:
     *     - having replaysOnErrorSampleRate > 0 to capture replay when an error occurs
     *     - or calling `flush()` to send the replay
     */
    /**
     * The current or last active span.
     * This is only available when performance is enabled.
     */
    /**
     * These are here so we can overwrite them in tests etc.
     * @hidden
     */
    /** The replay has to be manually started, because no sample rate (neither session or error) was provided. */
    /**
     * Options to pass to `rrweb.record()`
     */
    /**
     * Timestamp of the last user activity. This lives across sessions.
     */
    /**
     * Is the integration currently active?
     */
    /**
     * Paused is a state where:
     * - DOM Recording is not listening at all
     * - Nothing will be added to event buffer (e.g. core SDK events)
     */
    /**
     * Have we attached listeners to the core SDK?
     * Note we have to track this as there is no way to remove instrumentation handlers.
     */
    /**
     * Function to stop recording
     */
    /**
     * Internal use for canvas recording options
     */
    constructor({
      options,
      recordingOptions
    }) {
      _ReplayContainer.prototype.__init.call(this);
      _ReplayContainer.prototype.__init2.call(this);
      _ReplayContainer.prototype.__init3.call(this);
      _ReplayContainer.prototype.__init4.call(this);
      _ReplayContainer.prototype.__init5.call(this);
      _ReplayContainer.prototype.__init6.call(this);
      this.eventBuffer = null;
      this.performanceEntries = [];
      this.replayPerformanceEntries = [];
      this.recordingMode = "session";
      this.timeouts = {
        sessionIdlePause: SESSION_IDLE_PAUSE_DURATION,
        sessionIdleExpire: SESSION_IDLE_EXPIRE_DURATION
      };
      this._lastActivity = Date.now();
      this._isEnabled = false;
      this._isPaused = false;
      this._requiresManualStart = false;
      this._hasInitializedCoreListeners = false;
      this._context = {
        errorIds: /* @__PURE__ */ new Set(),
        traceIds: /* @__PURE__ */ new Set(),
        urls: [],
        initialTimestamp: Date.now(),
        initialUrl: ""
      };
      this._recordingOptions = recordingOptions;
      this._options = options;
      this._debouncedFlush = debounce(() => this._flush(), this._options.flushMinDelay, {
        maxWait: this._options.flushMaxDelay
      });
      this._throttledAddEvent = throttle(
        (event, isCheckout) => addEvent(this, event, isCheckout),
        // Max 300 events...
        300,
        // ... per 5s
        5
      );
      const { slowClickTimeout, slowClickIgnoreSelectors } = this.getOptions();
      const slowClickConfig = slowClickTimeout ? {
        threshold: Math.min(SLOW_CLICK_THRESHOLD, slowClickTimeout),
        timeout: slowClickTimeout,
        scrollTimeout: SLOW_CLICK_SCROLL_TIMEOUT,
        ignoreSelector: slowClickIgnoreSelectors ? slowClickIgnoreSelectors.join(",") : ""
      } : void 0;
      if (slowClickConfig) {
        this.clickDetector = new ClickDetector(this, slowClickConfig);
      }
      if (DEBUG_BUILD5) {
        const experiments = options._experiments;
        logger2.setConfig({
          captureExceptions: !!experiments.captureExceptions,
          traceInternals: !!experiments.traceInternals
        });
      }
    }
    /** Get the event context. */
    getContext() {
      return this._context;
    }
    /** If recording is currently enabled. */
    isEnabled() {
      return this._isEnabled;
    }
    /** If recording is currently paused. */
    isPaused() {
      return this._isPaused;
    }
    /**
     * Determine if canvas recording is enabled
     */
    isRecordingCanvas() {
      return Boolean(this._canvas);
    }
    /** Get the replay integration options. */
    getOptions() {
      return this._options;
    }
    /** A wrapper to conditionally capture exceptions. */
    handleException(error) {
      DEBUG_BUILD5 && logger2.exception(error);
      if (this._options.onError) {
        this._options.onError(error);
      }
    }
    /**
     * Initializes the plugin based on sampling configuration. Should not be
     * called outside of constructor.
     */
    initializeSampling(previousSessionId) {
      const { errorSampleRate, sessionSampleRate } = this._options;
      const requiresManualStart = errorSampleRate <= 0 && sessionSampleRate <= 0;
      this._requiresManualStart = requiresManualStart;
      if (requiresManualStart) {
        return;
      }
      this._initializeSessionForSampling(previousSessionId);
      if (!this.session) {
        DEBUG_BUILD5 && logger2.exception(new Error("Unable to initialize and create session"));
        return;
      }
      if (this.session.sampled === false) {
        return;
      }
      this.recordingMode = this.session.sampled === "buffer" && this.session.segmentId === 0 ? "buffer" : "session";
      DEBUG_BUILD5 && logger2.infoTick(`Starting replay in ${this.recordingMode} mode`);
      this._initializeRecording();
    }
    /**
     * Start a replay regardless of sampling rate. Calling this will always
     * create a new session. Will log a message if replay is already in progress.
     *
     * Creates or loads a session, attaches listeners to varying events (DOM,
     * _performanceObserver, Recording, Sentry SDK, etc)
     */
    start() {
      if (this._isEnabled && this.recordingMode === "session") {
        DEBUG_BUILD5 && logger2.info("Recording is already in progress");
        return;
      }
      if (this._isEnabled && this.recordingMode === "buffer") {
        DEBUG_BUILD5 && logger2.info("Buffering is in progress, call `flush()` to save the replay");
        return;
      }
      DEBUG_BUILD5 && logger2.infoTick("Starting replay in session mode");
      this._updateUserActivity();
      const session = loadOrCreateSession(
        {
          maxReplayDuration: this._options.maxReplayDuration,
          sessionIdleExpire: this.timeouts.sessionIdleExpire
        },
        {
          stickySession: this._options.stickySession,
          // This is intentional: create a new session-based replay when calling `start()`
          sessionSampleRate: 1,
          allowBuffering: false
        }
      );
      this.session = session;
      this._initializeRecording();
    }
    /**
     * Start replay buffering. Buffers until `flush()` is called or, if
     * `replaysOnErrorSampleRate` > 0, an error occurs.
     */
    startBuffering() {
      if (this._isEnabled) {
        DEBUG_BUILD5 && logger2.info("Buffering is in progress, call `flush()` to save the replay");
        return;
      }
      DEBUG_BUILD5 && logger2.infoTick("Starting replay in buffer mode");
      const session = loadOrCreateSession(
        {
          sessionIdleExpire: this.timeouts.sessionIdleExpire,
          maxReplayDuration: this._options.maxReplayDuration
        },
        {
          stickySession: this._options.stickySession,
          sessionSampleRate: 0,
          allowBuffering: true
        }
      );
      this.session = session;
      this.recordingMode = "buffer";
      this._initializeRecording();
    }
    /**
     * Start recording.
     *
     * Note that this will cause a new DOM checkout
     */
    startRecording() {
      try {
        const canvasOptions = this._canvas;
        this._stopRecording = record({
          ...this._recordingOptions,
          // When running in error sampling mode, we need to overwrite `checkoutEveryNms`
          // Without this, it would record forever, until an error happens, which we don't want
          // instead, we'll always keep the last 60 seconds of replay before an error happened
          ...this.recordingMode === "buffer" ? { checkoutEveryNms: BUFFER_CHECKOUT_TIME } : (
            // Otherwise, use experimental option w/ min checkout time of 6 minutes
            // This is to improve playback seeking as there could potentially be
            // less mutations to process in the worse cases.
            //
            // checkout by "N" events is probably ideal, but means we have less
            // control about the number of checkouts we make (which generally
            // increases replay size)
            this._options._experiments.continuousCheckout && {
              // Minimum checkout time is 6 minutes
              checkoutEveryNms: Math.max(36e4, this._options._experiments.continuousCheckout)
            }
          ),
          emit: getHandleRecordingEmit(this),
          onMutation: this._onMutationHandler,
          ...canvasOptions ? {
            recordCanvas: canvasOptions.recordCanvas,
            getCanvasManager: canvasOptions.getCanvasManager,
            sampling: canvasOptions.sampling,
            dataURLOptions: canvasOptions.dataURLOptions
          } : {}
        });
      } catch (err) {
        this.handleException(err);
      }
    }
    /**
     * Stops the recording, if it was running.
     *
     * Returns true if it was previously stopped, or is now stopped,
     * otherwise false.
     */
    stopRecording() {
      try {
        if (this._stopRecording) {
          this._stopRecording();
          this._stopRecording = void 0;
        }
        return true;
      } catch (err) {
        this.handleException(err);
        return false;
      }
    }
    /**
     * Currently, this needs to be manually called (e.g. for tests). Sentry SDK
     * does not support a teardown
     */
    async stop({ forceFlush = false, reason } = {}) {
      if (!this._isEnabled) {
        return;
      }
      this._isEnabled = false;
      try {
        DEBUG_BUILD5 && logger2.info(`Stopping Replay${reason ? ` triggered by ${reason}` : ""}`);
        resetReplayIdOnDynamicSamplingContext();
        this._removeListeners();
        this.stopRecording();
        this._debouncedFlush.cancel();
        if (forceFlush) {
          await this._flush({ force: true });
        }
        this.eventBuffer && this.eventBuffer.destroy();
        this.eventBuffer = null;
        clearSession(this);
      } catch (err) {
        this.handleException(err);
      }
    }
    /**
     * Pause some replay functionality. See comments for `_isPaused`.
     * This differs from stop as this only stops DOM recording, it is
     * not as thorough of a shutdown as `stop()`.
     */
    pause() {
      if (this._isPaused) {
        return;
      }
      this._isPaused = true;
      this.stopRecording();
      DEBUG_BUILD5 && logger2.info("Pausing replay");
    }
    /**
     * Resumes recording, see notes for `pause().
     *
     * Note that calling `startRecording()` here will cause a
     * new DOM checkout.`
     */
    resume() {
      if (!this._isPaused || !this._checkSession()) {
        return;
      }
      this._isPaused = false;
      this.startRecording();
      DEBUG_BUILD5 && logger2.info("Resuming replay");
    }
    /**
     * If not in "session" recording mode, flush event buffer which will create a new replay.
     * Unless `continueRecording` is false, the replay will continue to record and
     * behave as a "session"-based replay.
     *
     * Otherwise, queue up a flush.
     */
    async sendBufferedReplayOrFlush({ continueRecording = true } = {}) {
      if (this.recordingMode === "session") {
        return this.flushImmediate();
      }
      const activityTime = Date.now();
      DEBUG_BUILD5 && logger2.info("Converting buffer to session");
      await this.flushImmediate();
      const hasStoppedRecording = this.stopRecording();
      if (!continueRecording || !hasStoppedRecording) {
        return;
      }
      if (this.recordingMode === "session") {
        return;
      }
      this.recordingMode = "session";
      if (this.session) {
        this._updateUserActivity(activityTime);
        this._updateSessionActivity(activityTime);
        this._maybeSaveSession();
      }
      this.startRecording();
    }
    /**
     * We want to batch uploads of replay events. Save events only if
     * `<flushMinDelay>` milliseconds have elapsed since the last event
     * *OR* if `<flushMaxDelay>` milliseconds have elapsed.
     *
     * Accepts a callback to perform side-effects and returns true to stop batch
     * processing and hand back control to caller.
     */
    addUpdate(cb) {
      const cbResult = cb();
      if (this.recordingMode === "buffer") {
        return;
      }
      if (cbResult === true) {
        return;
      }
      this._debouncedFlush();
    }
    /**
     * Updates the user activity timestamp and resumes recording. This should be
     * called in an event handler for a user action that we consider as the user
     * being "active" (e.g. a mouse click).
     */
    triggerUserActivity() {
      this._updateUserActivity();
      if (!this._stopRecording) {
        if (!this._checkSession()) {
          return;
        }
        this.resume();
        return;
      }
      this.checkAndHandleExpiredSession();
      this._updateSessionActivity();
    }
    /**
     * Updates the user activity timestamp *without* resuming
     * recording. Some user events (e.g. keydown) can be create
     * low-value replays that only contain the keypress as a
     * breadcrumb. Instead this would require other events to
     * create a new replay after a session has expired.
     */
    updateUserActivity() {
      this._updateUserActivity();
      this._updateSessionActivity();
    }
    /**
     * Only flush if `this.recordingMode === 'session'`
     */
    conditionalFlush() {
      if (this.recordingMode === "buffer") {
        return Promise.resolve();
      }
      return this.flushImmediate();
    }
    /**
     * Flush using debounce flush
     */
    flush() {
      return this._debouncedFlush();
    }
    /**
     * Always flush via `_debouncedFlush` so that we do not have flushes triggered
     * from calling both `flush` and `_debouncedFlush`. Otherwise, there could be
     * cases of mulitple flushes happening closely together.
     */
    flushImmediate() {
      this._debouncedFlush();
      return this._debouncedFlush.flush();
    }
    /**
     * Cancels queued up flushes.
     */
    cancelFlush() {
      this._debouncedFlush.cancel();
    }
    /** Get the current sesion (=replay) ID */
    getSessionId() {
      return this.session && this.session.id;
    }
    /**
     * Checks if recording should be stopped due to user inactivity. Otherwise
     * check if session is expired and create a new session if so. Triggers a new
     * full snapshot on new session.
     *
     * Returns true if session is not expired, false otherwise.
     * @hidden
     */
    checkAndHandleExpiredSession() {
      if (this._lastActivity && isExpired(this._lastActivity, this.timeouts.sessionIdlePause) && this.session && this.session.sampled === "session") {
        this.pause();
        return;
      }
      if (!this._checkSession()) {
        return false;
      }
      return true;
    }
    /**
     * Capture some initial state that can change throughout the lifespan of the
     * replay. This is required because otherwise they would be captured at the
     * first flush.
     */
    setInitialState() {
      const urlPath = `${WINDOW6.location.pathname}${WINDOW6.location.hash}${WINDOW6.location.search}`;
      const url = `${WINDOW6.location.origin}${urlPath}`;
      this.performanceEntries = [];
      this.replayPerformanceEntries = [];
      this._clearContext();
      this._context.initialUrl = url;
      this._context.initialTimestamp = Date.now();
      this._context.urls.push(url);
    }
    /**
     * Add a breadcrumb event, that may be throttled.
     * If it was throttled, we add a custom breadcrumb to indicate that.
     */
    throttledAddEvent(event, isCheckout) {
      const res = this._throttledAddEvent(event, isCheckout);
      if (res === THROTTLED) {
        const breadcrumb = createBreadcrumb({
          category: "replay.throttled"
        });
        this.addUpdate(() => {
          return !addEventSync(this, {
            type: ReplayEventTypeCustom,
            timestamp: breadcrumb.timestamp || 0,
            data: {
              tag: "breadcrumb",
              payload: breadcrumb,
              metric: true
            }
          });
        });
      }
      return res;
    }
    /**
     * This will get the parametrized route name of the current page.
     * This is only available if performance is enabled, and if an instrumented router is used.
     */
    getCurrentRoute() {
      const lastActiveSpan = this.lastActiveSpan || getActiveSpan();
      const lastRootSpan = lastActiveSpan && getRootSpan(lastActiveSpan);
      const attributes = lastRootSpan && spanToJSON(lastRootSpan).data || {};
      const source = attributes[SEMANTIC_ATTRIBUTE_SENTRY_SOURCE];
      if (!lastRootSpan || !source || !["route", "custom"].includes(source)) {
        return void 0;
      }
      return spanToJSON(lastRootSpan).description;
    }
    /**
     * Initialize and start all listeners to varying events (DOM,
     * Performance Observer, Recording, Sentry SDK, etc)
     */
    _initializeRecording() {
      this.setInitialState();
      this._updateSessionActivity();
      this.eventBuffer = createEventBuffer({
        useCompression: this._options.useCompression,
        workerUrl: this._options.workerUrl
      });
      this._removeListeners();
      this._addListeners();
      this._isEnabled = true;
      this._isPaused = false;
      this.startRecording();
    }
    /**
     * Loads (or refreshes) the current session.
     */
    _initializeSessionForSampling(previousSessionId) {
      const allowBuffering = this._options.errorSampleRate > 0;
      const session = loadOrCreateSession(
        {
          sessionIdleExpire: this.timeouts.sessionIdleExpire,
          maxReplayDuration: this._options.maxReplayDuration,
          previousSessionId
        },
        {
          stickySession: this._options.stickySession,
          sessionSampleRate: this._options.sessionSampleRate,
          allowBuffering
        }
      );
      this.session = session;
    }
    /**
     * Checks and potentially refreshes the current session.
     * Returns false if session is not recorded.
     */
    _checkSession() {
      if (!this.session) {
        return false;
      }
      const currentSession = this.session;
      if (shouldRefreshSession(currentSession, {
        sessionIdleExpire: this.timeouts.sessionIdleExpire,
        maxReplayDuration: this._options.maxReplayDuration
      })) {
        this._refreshSession(currentSession);
        return false;
      }
      return true;
    }
    /**
     * Refresh a session with a new one.
     * This stops the current session (without forcing a flush, as that would never work since we are expired),
     * and then does a new sampling based on the refreshed session.
     */
    async _refreshSession(session) {
      if (!this._isEnabled) {
        return;
      }
      await this.stop({ reason: "refresh session" });
      this.initializeSampling(session.id);
    }
    /**
     * Adds listeners to record events for the replay
     */
    _addListeners() {
      try {
        WINDOW6.document.addEventListener("visibilitychange", this._handleVisibilityChange);
        WINDOW6.addEventListener("blur", this._handleWindowBlur);
        WINDOW6.addEventListener("focus", this._handleWindowFocus);
        WINDOW6.addEventListener("keydown", this._handleKeyboardEvent);
        if (this.clickDetector) {
          this.clickDetector.addListeners();
        }
        if (!this._hasInitializedCoreListeners) {
          addGlobalListeners(this);
          this._hasInitializedCoreListeners = true;
        }
      } catch (err) {
        this.handleException(err);
      }
      this._performanceCleanupCallback = setupPerformanceObserver(this);
    }
    /**
     * Cleans up listeners that were created in `_addListeners`
     */
    _removeListeners() {
      try {
        WINDOW6.document.removeEventListener("visibilitychange", this._handleVisibilityChange);
        WINDOW6.removeEventListener("blur", this._handleWindowBlur);
        WINDOW6.removeEventListener("focus", this._handleWindowFocus);
        WINDOW6.removeEventListener("keydown", this._handleKeyboardEvent);
        if (this.clickDetector) {
          this.clickDetector.removeListeners();
        }
        if (this._performanceCleanupCallback) {
          this._performanceCleanupCallback();
        }
      } catch (err) {
        this.handleException(err);
      }
    }
    /**
     * Handle when visibility of the page content changes. Opening a new tab will
     * cause the state to change to hidden because of content of current page will
     * be hidden. Likewise, moving a different window to cover the contents of the
     * page will also trigger a change to a hidden state.
     */
    __init() {
      this._handleVisibilityChange = () => {
        if (WINDOW6.document.visibilityState === "visible") {
          this._doChangeToForegroundTasks();
        } else {
          this._doChangeToBackgroundTasks();
        }
      };
    }
    /**
     * Handle when page is blurred
     */
    __init2() {
      this._handleWindowBlur = () => {
        const breadcrumb = createBreadcrumb({
          category: "ui.blur"
        });
        this._doChangeToBackgroundTasks(breadcrumb);
      };
    }
    /**
     * Handle when page is focused
     */
    __init3() {
      this._handleWindowFocus = () => {
        const breadcrumb = createBreadcrumb({
          category: "ui.focus"
        });
        this._doChangeToForegroundTasks(breadcrumb);
      };
    }
    /** Ensure page remains active when a key is pressed. */
    __init4() {
      this._handleKeyboardEvent = (event) => {
        handleKeyboardEvent(this, event);
      };
    }
    /**
     * Tasks to run when we consider a page to be hidden (via blurring and/or visibility)
     */
    _doChangeToBackgroundTasks(breadcrumb) {
      if (!this.session) {
        return;
      }
      const expired = isSessionExpired(this.session, {
        maxReplayDuration: this._options.maxReplayDuration,
        sessionIdleExpire: this.timeouts.sessionIdleExpire
      });
      if (expired) {
        return;
      }
      if (breadcrumb) {
        this._createCustomBreadcrumb(breadcrumb);
      }
      void this.conditionalFlush();
    }
    /**
     * Tasks to run when we consider a page to be visible (via focus and/or visibility)
     */
    _doChangeToForegroundTasks(breadcrumb) {
      if (!this.session) {
        return;
      }
      const isSessionActive = this.checkAndHandleExpiredSession();
      if (!isSessionActive) {
        DEBUG_BUILD5 && logger2.info("Document has become active, but session has expired");
        return;
      }
      if (breadcrumb) {
        this._createCustomBreadcrumb(breadcrumb);
      }
    }
    /**
     * Update user activity (across session lifespans)
     */
    _updateUserActivity(_lastActivity = Date.now()) {
      this._lastActivity = _lastActivity;
    }
    /**
     * Updates the session's last activity timestamp
     */
    _updateSessionActivity(_lastActivity = Date.now()) {
      if (this.session) {
        this.session.lastActivity = _lastActivity;
        this._maybeSaveSession();
      }
    }
    /**
     * Helper to create (and buffer) a replay breadcrumb from a core SDK breadcrumb
     */
    _createCustomBreadcrumb(breadcrumb) {
      this.addUpdate(() => {
        this.throttledAddEvent({
          type: EventType.Custom,
          timestamp: breadcrumb.timestamp || 0,
          data: {
            tag: "breadcrumb",
            payload: breadcrumb
          }
        });
      });
    }
    /**
     * Observed performance events are added to `this.performanceEntries`. These
     * are included in the replay event before it is finished and sent to Sentry.
     */
    _addPerformanceEntries() {
      let performanceEntries = createPerformanceEntries(this.performanceEntries).concat(this.replayPerformanceEntries);
      this.performanceEntries = [];
      this.replayPerformanceEntries = [];
      if (this._requiresManualStart) {
        const initialTimestampInSeconds = this._context.initialTimestamp / 1e3;
        performanceEntries = performanceEntries.filter((entry) => entry.start >= initialTimestampInSeconds);
      }
      return Promise.all(createPerformanceSpans(this, performanceEntries));
    }
    /**
     * Clear _context
     */
    _clearContext() {
      this._context.errorIds.clear();
      this._context.traceIds.clear();
      this._context.urls = [];
    }
    /** Update the initial timestamp based on the buffer content. */
    _updateInitialTimestampFromEventBuffer() {
      const { session, eventBuffer } = this;
      if (!session || !eventBuffer || this._requiresManualStart) {
        return;
      }
      if (session.segmentId) {
        return;
      }
      const earliestEvent = eventBuffer.getEarliestTimestamp();
      if (earliestEvent && earliestEvent < this._context.initialTimestamp) {
        this._context.initialTimestamp = earliestEvent;
      }
    }
    /**
     * Return and clear _context
     */
    _popEventContext() {
      const _context = {
        initialTimestamp: this._context.initialTimestamp,
        initialUrl: this._context.initialUrl,
        errorIds: Array.from(this._context.errorIds),
        traceIds: Array.from(this._context.traceIds),
        urls: this._context.urls
      };
      this._clearContext();
      return _context;
    }
    /**
     * Flushes replay event buffer to Sentry.
     *
     * Performance events are only added right before flushing - this is
     * due to the buffered performance observer events.
     *
     * Should never be called directly, only by `flush`
     */
    async _runFlush() {
      const replayId = this.getSessionId();
      if (!this.session || !this.eventBuffer || !replayId) {
        DEBUG_BUILD5 && logger2.error("No session or eventBuffer found to flush.");
        return;
      }
      await this._addPerformanceEntries();
      if (!this.eventBuffer || !this.eventBuffer.hasEvents) {
        return;
      }
      await addMemoryEntry(this);
      if (!this.eventBuffer) {
        return;
      }
      if (replayId !== this.getSessionId()) {
        return;
      }
      try {
        this._updateInitialTimestampFromEventBuffer();
        const timestamp = Date.now();
        if (timestamp - this._context.initialTimestamp > this._options.maxReplayDuration + 3e4) {
          throw new Error("Session is too long, not sending replay");
        }
        const eventContext = this._popEventContext();
        const segmentId = this.session.segmentId++;
        this._maybeSaveSession();
        const recordingData = await this.eventBuffer.finish();
        await sendReplay({
          replayId,
          recordingData,
          segmentId,
          eventContext,
          session: this.session,
          timestamp,
          onError: (err) => this.handleException(err)
        });
      } catch (err) {
        this.handleException(err);
        this.stop({ reason: "sendReplay" });
        const client = getClient();
        if (client) {
          const dropReason = err instanceof RateLimitError ? "ratelimit_backoff" : "send_error";
          client.recordDroppedEvent(dropReason, "replay");
        }
      }
    }
    /**
     * Flush recording data to Sentry. Creates a lock so that only a single flush
     * can be active at a time. Do not call this directly.
     */
    __init5() {
      this._flush = async ({
        force = false
      } = {}) => {
        if (!this._isEnabled && !force) {
          return;
        }
        if (!this.checkAndHandleExpiredSession()) {
          DEBUG_BUILD5 && logger2.error("Attempting to finish replay event after session expired.");
          return;
        }
        if (!this.session) {
          return;
        }
        const start2 = this.session.started;
        const now = Date.now();
        const duration = now - start2;
        this._debouncedFlush.cancel();
        const tooShort = duration < this._options.minReplayDuration;
        const tooLong = duration > this._options.maxReplayDuration + 5e3;
        if (tooShort || tooLong) {
          DEBUG_BUILD5 && logger2.info(
            `Session duration (${Math.floor(duration / 1e3)}s) is too ${tooShort ? "short" : "long"}, not sending replay.`
          );
          if (tooShort) {
            this._debouncedFlush();
          }
          return;
        }
        const eventBuffer = this.eventBuffer;
        if (eventBuffer && this.session.segmentId === 0 && !eventBuffer.hasCheckout) {
          DEBUG_BUILD5 && logger2.info("Flushing initial segment without checkout.");
        }
        const _flushInProgress = !!this._flushLock;
        if (!this._flushLock) {
          this._flushLock = this._runFlush();
        }
        try {
          await this._flushLock;
        } catch (err) {
          this.handleException(err);
        } finally {
          this._flushLock = void 0;
          if (_flushInProgress) {
            this._debouncedFlush();
          }
        }
      };
    }
    /** Save the session, if it is sticky */
    _maybeSaveSession() {
      if (this.session && this._options.stickySession) {
        saveSession(this.session);
      }
    }
    /** Handler for rrweb.record.onMutation */
    __init6() {
      this._onMutationHandler = (mutations) => {
        const count = mutations.length;
        const mutationLimit = this._options.mutationLimit;
        const mutationBreadcrumbLimit = this._options.mutationBreadcrumbLimit;
        const overMutationLimit = mutationLimit && count > mutationLimit;
        if (count > mutationBreadcrumbLimit || overMutationLimit) {
          const breadcrumb = createBreadcrumb({
            category: "replay.mutations",
            data: {
              count,
              limit: overMutationLimit
            }
          });
          this._createCustomBreadcrumb(breadcrumb);
        }
        if (overMutationLimit) {
          this.stop({ reason: "mutationLimit", forceFlush: this.recordingMode === "session" });
          return false;
        }
        return true;
      };
    }
  };
  function getOption(selectors, defaultSelectors) {
    return [
      ...selectors,
      // sentry defaults
      ...defaultSelectors
    ].join(",");
  }
  function getPrivacyOptions({ mask, unmask, block, unblock, ignore }) {
    const defaultBlockedElements = ['base[href="/"]'];
    const maskSelector = getOption(mask, [".sentry-mask", "[data-sentry-mask]"]);
    const unmaskSelector = getOption(unmask, []);
    const options = {
      // We are making the decision to make text and input selectors the same
      maskTextSelector: maskSelector,
      unmaskTextSelector: unmaskSelector,
      blockSelector: getOption(block, [".sentry-block", "[data-sentry-block]", ...defaultBlockedElements]),
      unblockSelector: getOption(unblock, []),
      ignoreSelector: getOption(ignore, [".sentry-ignore", "[data-sentry-ignore]", 'input[type="file"]'])
    };
    return options;
  }
  function maskAttribute({
    el,
    key,
    maskAttributes,
    maskAllText,
    privacyOptions,
    value
  }) {
    if (!maskAllText) {
      return value;
    }
    if (privacyOptions.unmaskTextSelector && el.matches(privacyOptions.unmaskTextSelector)) {
      return value;
    }
    if (maskAttributes.includes(key) || // Need to mask `value` attribute for `<input>` if it's a button-like
    // type
    key === "value" && el.tagName === "INPUT" && ["submit", "button"].includes(el.getAttribute("type") || "")) {
      return value.replace(/[\S]/g, "*");
    }
    return value;
  }
  var MEDIA_SELECTORS = 'img,image,svg,video,object,picture,embed,map,audio,link[rel="icon"],link[rel="apple-touch-icon"]';
  var DEFAULT_NETWORK_HEADERS = ["content-length", "content-type", "accept"];
  var _initialized = false;
  var replayIntegration = (options) => {
    return new Replay(options);
  };
  var Replay = class _Replay {
    /**
     * @inheritDoc
     */
    static __initStatic() {
      this.id = "Replay";
    }
    /**
     * @inheritDoc
     */
    /**
     * Options to pass to `rrweb.record()`
     */
    /**
     * Initial options passed to the replay integration, merged with default values.
     * Note: `sessionSampleRate` and `errorSampleRate` are not required here, as they
     * can only be finally set when setupOnce() is called.
     *
     * @private
     */
    constructor({
      flushMinDelay = DEFAULT_FLUSH_MIN_DELAY,
      flushMaxDelay = DEFAULT_FLUSH_MAX_DELAY,
      minReplayDuration = MIN_REPLAY_DURATION,
      maxReplayDuration = MAX_REPLAY_DURATION,
      stickySession = true,
      useCompression = true,
      workerUrl,
      _experiments = {},
      maskAllText = true,
      maskAllInputs = true,
      blockAllMedia = true,
      mutationBreadcrumbLimit = 750,
      mutationLimit = 1e4,
      slowClickTimeout = 7e3,
      slowClickIgnoreSelectors = [],
      networkDetailAllowUrls = [],
      networkDetailDenyUrls = [],
      networkCaptureBodies = true,
      networkRequestHeaders = [],
      networkResponseHeaders = [],
      mask = [],
      maskAttributes = ["title", "placeholder"],
      unmask = [],
      block = [],
      unblock = [],
      ignore = [],
      maskFn,
      beforeAddRecordingEvent,
      beforeErrorSampling
    } = {}) {
      this.name = _Replay.id;
      const privacyOptions = getPrivacyOptions({
        mask,
        unmask,
        block,
        unblock,
        ignore
      });
      this._recordingOptions = {
        maskAllInputs,
        maskAllText,
        maskInputOptions: { password: true },
        maskTextFn: maskFn,
        maskInputFn: maskFn,
        maskAttributeFn: (key, value, el) => maskAttribute({
          maskAttributes,
          maskAllText,
          privacyOptions,
          key,
          value,
          el
        }),
        ...privacyOptions,
        // Our defaults
        slimDOMOptions: "all",
        inlineStylesheet: true,
        // Disable inline images as it will increase segment/replay size
        inlineImages: false,
        // collect fonts, but be aware that `sentry.io` needs to be an allowed
        // origin for playback
        collectFonts: true,
        errorHandler: (err) => {
          try {
            err.__rrweb__ = true;
          } catch (error) {
          }
        }
      };
      this._initialOptions = {
        flushMinDelay,
        flushMaxDelay,
        minReplayDuration: Math.min(minReplayDuration, MIN_REPLAY_DURATION_LIMIT),
        maxReplayDuration: Math.min(maxReplayDuration, MAX_REPLAY_DURATION),
        stickySession,
        useCompression,
        workerUrl,
        blockAllMedia,
        maskAllInputs,
        maskAllText,
        mutationBreadcrumbLimit,
        mutationLimit,
        slowClickTimeout,
        slowClickIgnoreSelectors,
        networkDetailAllowUrls,
        networkDetailDenyUrls,
        networkCaptureBodies,
        networkRequestHeaders: _getMergedNetworkHeaders(networkRequestHeaders),
        networkResponseHeaders: _getMergedNetworkHeaders(networkResponseHeaders),
        beforeAddRecordingEvent,
        beforeErrorSampling,
        _experiments
      };
      if (this._initialOptions.blockAllMedia) {
        this._recordingOptions.blockSelector = !this._recordingOptions.blockSelector ? MEDIA_SELECTORS : `${this._recordingOptions.blockSelector},${MEDIA_SELECTORS}`;
      }
      if (this._isInitialized && isBrowser()) {
        throw new Error("Multiple Sentry Session Replay instances are not supported");
      }
      this._isInitialized = true;
    }
    /** If replay has already been initialized */
    get _isInitialized() {
      return _initialized;
    }
    /** Update _isInitialized */
    set _isInitialized(value) {
      _initialized = value;
    }
    /**
     * Setup and initialize replay container
     */
    afterAllSetup(client) {
      if (!isBrowser() || this._replay) {
        return;
      }
      this._setup(client);
      this._initialize(client);
    }
    /**
     * Start a replay regardless of sampling rate. Calling this will always
     * create a new session. Will log a message if replay is already in progress.
     *
     * Creates or loads a session, attaches listeners to varying events (DOM,
     * PerformanceObserver, Recording, Sentry SDK, etc)
     */
    start() {
      if (!this._replay) {
        return;
      }
      this._replay.start();
    }
    /**
     * Start replay buffering. Buffers until `flush()` is called or, if
     * `replaysOnErrorSampleRate` > 0, until an error occurs.
     */
    startBuffering() {
      if (!this._replay) {
        return;
      }
      this._replay.startBuffering();
    }
    /**
     * Currently, this needs to be manually called (e.g. for tests). Sentry SDK
     * does not support a teardown
     */
    stop() {
      if (!this._replay) {
        return Promise.resolve();
      }
      return this._replay.stop({ forceFlush: this._replay.recordingMode === "session" });
    }
    /**
     * If not in "session" recording mode, flush event buffer which will create a new replay.
     * If replay is not enabled, a new session replay is started.
     * Unless `continueRecording` is false, the replay will continue to record and
     * behave as a "session"-based replay.
     *
     * Otherwise, queue up a flush.
     */
    flush(options) {
      if (!this._replay) {
        return Promise.resolve();
      }
      if (!this._replay.isEnabled()) {
        this._replay.start();
        return Promise.resolve();
      }
      return this._replay.sendBufferedReplayOrFlush(options);
    }
    /**
     * Get the current session ID.
     */
    getReplayId() {
      if (!this._replay || !this._replay.isEnabled()) {
        return;
      }
      return this._replay.getSessionId();
    }
    /**
     * Initializes replay.
     */
    _initialize(client) {
      if (!this._replay) {
        return;
      }
      this._maybeLoadFromReplayCanvasIntegration(client);
      this._replay.initializeSampling();
    }
    /** Setup the integration. */
    _setup(client) {
      const finalOptions = loadReplayOptionsFromClient(this._initialOptions, client);
      this._replay = new ReplayContainer({
        options: finalOptions,
        recordingOptions: this._recordingOptions
      });
    }
    /** Get canvas options from ReplayCanvas integration, if it is also added. */
    _maybeLoadFromReplayCanvasIntegration(client) {
      try {
        const canvasIntegration = client.getIntegrationByName("ReplayCanvas");
        if (!canvasIntegration) {
          return;
        }
        this._replay["_canvas"] = canvasIntegration.getOptions();
      } catch (e2) {
      }
    }
  };
  Replay.__initStatic();
  function loadReplayOptionsFromClient(initialOptions, client) {
    const opt = client.getOptions();
    const finalOptions = {
      sessionSampleRate: 0,
      errorSampleRate: 0,
      ...dropUndefinedKeys(initialOptions)
    };
    const replaysSessionSampleRate = parseSampleRate(opt.replaysSessionSampleRate);
    const replaysOnErrorSampleRate = parseSampleRate(opt.replaysOnErrorSampleRate);
    if (replaysSessionSampleRate == null && replaysOnErrorSampleRate == null) {
      consoleSandbox(() => {
        console.warn(
          "Replay is disabled because neither `replaysSessionSampleRate` nor `replaysOnErrorSampleRate` are set."
        );
      });
    }
    if (replaysSessionSampleRate != null) {
      finalOptions.sessionSampleRate = replaysSessionSampleRate;
    }
    if (replaysOnErrorSampleRate != null) {
      finalOptions.errorSampleRate = replaysOnErrorSampleRate;
    }
    return finalOptions;
  }
  function _getMergedNetworkHeaders(headers) {
    return [...DEFAULT_NETWORK_HEADERS, ...headers.map((header) => header.toLowerCase())];
  }

  // node_modules/@sentry/browser/build/npm/esm/tracing/request.js
  var responseToSpanId = /* @__PURE__ */ new WeakMap();
  var spanIdToEndTimestamp = /* @__PURE__ */ new Map();
  var defaultRequestInstrumentationOptions = {
    traceFetch: true,
    traceXHR: true,
    enableHTTPTimings: true,
    trackFetchStreamPerformance: false
  };
  function instrumentOutgoingRequests(client, _options) {
    const {
      traceFetch,
      traceXHR,
      trackFetchStreamPerformance,
      shouldCreateSpanForRequest,
      enableHTTPTimings,
      tracePropagationTargets
    } = {
      traceFetch: defaultRequestInstrumentationOptions.traceFetch,
      traceXHR: defaultRequestInstrumentationOptions.traceXHR,
      trackFetchStreamPerformance: defaultRequestInstrumentationOptions.trackFetchStreamPerformance,
      ..._options
    };
    const shouldCreateSpan = typeof shouldCreateSpanForRequest === "function" ? shouldCreateSpanForRequest : (_) => true;
    const shouldAttachHeadersWithTargets = (url) => shouldAttachHeaders(url, tracePropagationTargets);
    const spans = {};
    if (traceFetch) {
      client.addEventProcessor((event) => {
        if (event.type === "transaction" && event.spans) {
          event.spans.forEach((span) => {
            if (span.op === "http.client") {
              const updatedTimestamp = spanIdToEndTimestamp.get(span.span_id);
              if (updatedTimestamp) {
                span.timestamp = updatedTimestamp / 1e3;
                spanIdToEndTimestamp.delete(span.span_id);
              }
            }
          });
        }
        return event;
      });
      if (trackFetchStreamPerformance) {
        addFetchEndInstrumentationHandler((handlerData) => {
          if (handlerData.response) {
            const span = responseToSpanId.get(handlerData.response);
            if (span && handlerData.endTimestamp) {
              spanIdToEndTimestamp.set(span, handlerData.endTimestamp);
            }
          }
        });
      }
      addFetchInstrumentationHandler((handlerData) => {
        const createdSpan = instrumentFetchRequest(handlerData, shouldCreateSpan, shouldAttachHeadersWithTargets, spans);
        if (handlerData.response && handlerData.fetchData.__span) {
          responseToSpanId.set(handlerData.response, handlerData.fetchData.__span);
        }
        if (createdSpan) {
          const fullUrl = getFullURL2(handlerData.fetchData.url);
          const host = fullUrl ? parseUrl(fullUrl).host : void 0;
          createdSpan.setAttributes({
            "http.url": fullUrl,
            "server.address": host
          });
        }
        if (enableHTTPTimings && createdSpan) {
          addHTTPTimings(createdSpan);
        }
      });
    }
    if (traceXHR) {
      addXhrInstrumentationHandler((handlerData) => {
        const createdSpan = xhrCallback(handlerData, shouldCreateSpan, shouldAttachHeadersWithTargets, spans);
        if (enableHTTPTimings && createdSpan) {
          addHTTPTimings(createdSpan);
        }
      });
    }
  }
  function isPerformanceResourceTiming(entry) {
    return entry.entryType === "resource" && "initiatorType" in entry && typeof entry.nextHopProtocol === "string" && (entry.initiatorType === "fetch" || entry.initiatorType === "xmlhttprequest");
  }
  function addHTTPTimings(span) {
    const { url } = spanToJSON(span).data || {};
    if (!url || typeof url !== "string") {
      return;
    }
    const cleanup = addPerformanceInstrumentationHandler("resource", ({ entries }) => {
      entries.forEach((entry) => {
        if (isPerformanceResourceTiming(entry) && entry.name.endsWith(url)) {
          const spanData = resourceTimingEntryToSpanData(entry);
          spanData.forEach((data) => span.setAttribute(...data));
          setTimeout(cleanup);
        }
      });
    });
  }
  function extractNetworkProtocol(nextHopProtocol) {
    let name = "unknown";
    let version = "unknown";
    let _name = "";
    for (const char of nextHopProtocol) {
      if (char === "/") {
        [name, version] = nextHopProtocol.split("/");
        break;
      }
      if (!isNaN(Number(char))) {
        name = _name === "h" ? "http" : _name;
        version = nextHopProtocol.split(_name)[1];
        break;
      }
      _name += char;
    }
    if (_name === nextHopProtocol) {
      name = _name;
    }
    return { name, version };
  }
  function getAbsoluteTime2(time = 0) {
    return ((browserPerformanceTimeOrigin || performance.timeOrigin) + time) / 1e3;
  }
  function resourceTimingEntryToSpanData(resourceTiming) {
    const { name, version } = extractNetworkProtocol(resourceTiming.nextHopProtocol);
    const timingSpanData = [];
    timingSpanData.push(["network.protocol.version", version], ["network.protocol.name", name]);
    if (!browserPerformanceTimeOrigin) {
      return timingSpanData;
    }
    return [
      ...timingSpanData,
      ["http.request.redirect_start", getAbsoluteTime2(resourceTiming.redirectStart)],
      ["http.request.fetch_start", getAbsoluteTime2(resourceTiming.fetchStart)],
      ["http.request.domain_lookup_start", getAbsoluteTime2(resourceTiming.domainLookupStart)],
      ["http.request.domain_lookup_end", getAbsoluteTime2(resourceTiming.domainLookupEnd)],
      ["http.request.connect_start", getAbsoluteTime2(resourceTiming.connectStart)],
      ["http.request.secure_connection_start", getAbsoluteTime2(resourceTiming.secureConnectionStart)],
      ["http.request.connection_end", getAbsoluteTime2(resourceTiming.connectEnd)],
      ["http.request.request_start", getAbsoluteTime2(resourceTiming.requestStart)],
      ["http.request.response_start", getAbsoluteTime2(resourceTiming.responseStart)],
      ["http.request.response_end", getAbsoluteTime2(resourceTiming.responseEnd)]
    ];
  }
  function shouldAttachHeaders(targetUrl, tracePropagationTargets) {
    const href2 = WINDOW4.location && WINDOW4.location.href;
    if (!href2) {
      const isRelativeSameOriginRequest = !!targetUrl.match(/^\/(?!\/)/);
      if (!tracePropagationTargets) {
        return isRelativeSameOriginRequest;
      } else {
        return stringMatchesSomePattern(targetUrl, tracePropagationTargets);
      }
    } else {
      let resolvedUrl;
      let currentOrigin;
      try {
        resolvedUrl = new URL(targetUrl, href2);
        currentOrigin = new URL(href2).origin;
      } catch (e2) {
        return false;
      }
      const isSameOriginRequest = resolvedUrl.origin === currentOrigin;
      if (!tracePropagationTargets) {
        return isSameOriginRequest;
      } else {
        return stringMatchesSomePattern(resolvedUrl.toString(), tracePropagationTargets) || isSameOriginRequest && stringMatchesSomePattern(resolvedUrl.pathname, tracePropagationTargets);
      }
    }
  }
  function xhrCallback(handlerData, shouldCreateSpan, shouldAttachHeaders2, spans) {
    const xhr = handlerData.xhr;
    const sentryXhrData = xhr && xhr[SENTRY_XHR_DATA_KEY];
    if (!xhr || xhr.__sentry_own_request__ || !sentryXhrData) {
      return void 0;
    }
    const shouldCreateSpanResult = hasTracingEnabled() && shouldCreateSpan(sentryXhrData.url);
    if (handlerData.endTimestamp && shouldCreateSpanResult) {
      const spanId = xhr.__sentry_xhr_span_id__;
      if (!spanId) return;
      const span2 = spans[spanId];
      if (span2 && sentryXhrData.status_code !== void 0) {
        setHttpStatus(span2, sentryXhrData.status_code);
        span2.end();
        delete spans[spanId];
      }
      return void 0;
    }
    const fullUrl = getFullURL2(sentryXhrData.url);
    const host = fullUrl ? parseUrl(fullUrl).host : void 0;
    const hasParent = !!getActiveSpan();
    const span = shouldCreateSpanResult && hasParent ? startInactiveSpan({
      name: `${sentryXhrData.method} ${sentryXhrData.url}`,
      attributes: {
        type: "xhr",
        "http.method": sentryXhrData.method,
        "http.url": fullUrl,
        url: sentryXhrData.url,
        "server.address": host,
        [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.http.browser",
        [SEMANTIC_ATTRIBUTE_SENTRY_OP]: "http.client"
      }
    }) : new SentryNonRecordingSpan();
    xhr.__sentry_xhr_span_id__ = span.spanContext().spanId;
    spans[xhr.__sentry_xhr_span_id__] = span;
    const client = getClient();
    if (xhr.setRequestHeader && shouldAttachHeaders2(sentryXhrData.url) && client) {
      addTracingHeadersToXhrRequest(
        xhr,
        client,
        // If performance is disabled (TWP) or there's no active root span (pageload/navigation/interaction),
        // we do not want to use the span as base for the trace headers,
        // which means that the headers will be generated from the scope and the sampling decision is deferred
        hasTracingEnabled() && hasParent ? span : void 0
      );
    }
    return span;
  }
  function addTracingHeadersToXhrRequest(xhr, client, span) {
    const scope = getCurrentScope();
    const isolationScope = getIsolationScope();
    const { traceId, spanId, sampled, dsc } = {
      ...isolationScope.getPropagationContext(),
      ...scope.getPropagationContext()
    };
    const sentryTraceHeader = span && hasTracingEnabled() ? spanToTraceHeader(span) : generateSentryTraceHeader(traceId, spanId, sampled);
    const sentryBaggageHeader = dynamicSamplingContextToSentryBaggageHeader(
      dsc || (span ? getDynamicSamplingContextFromSpan(span) : getDynamicSamplingContextFromClient(traceId, client))
    );
    setHeaderOnXhr(xhr, sentryTraceHeader, sentryBaggageHeader);
  }
  function setHeaderOnXhr(xhr, sentryTraceHeader, sentryBaggageHeader) {
    try {
      xhr.setRequestHeader("sentry-trace", sentryTraceHeader);
      if (sentryBaggageHeader) {
        xhr.setRequestHeader(BAGGAGE_HEADER_NAME, sentryBaggageHeader);
      }
    } catch (_) {
    }
  }
  function getFullURL2(url) {
    try {
      const parsed = new URL(url, WINDOW4.location.origin);
      return parsed.href;
    } catch (e2) {
      return void 0;
    }
  }

  // node_modules/@sentry/browser/build/npm/esm/tracing/backgroundtab.js
  function registerBackgroundTabDetection() {
    if (WINDOW4 && WINDOW4.document) {
      WINDOW4.document.addEventListener("visibilitychange", () => {
        const activeSpan = getActiveSpan();
        if (!activeSpan) {
          return;
        }
        const rootSpan = getRootSpan(activeSpan);
        if (WINDOW4.document.hidden && rootSpan) {
          const cancelledStatus = "cancelled";
          const { op, status } = spanToJSON(rootSpan);
          if (DEBUG_BUILD3) {
            logger.log(`[Tracing] Transaction: ${cancelledStatus} -> since tab moved to the background, op: ${op}`);
          }
          if (!status) {
            rootSpan.setStatus({ code: SPAN_STATUS_ERROR, message: cancelledStatus });
          }
          rootSpan.setAttribute("sentry.cancellation_reason", "document.hidden");
          rootSpan.end();
        }
      });
    } else {
      DEBUG_BUILD3 && logger.warn("[Tracing] Could not set up background tab detection due to lack of global document");
    }
  }

  // node_modules/@sentry/browser/build/npm/esm/tracing/browserTracingIntegration.js
  var BROWSER_TRACING_INTEGRATION_ID = "BrowserTracing";
  var DEFAULT_BROWSER_TRACING_OPTIONS = {
    ...TRACING_DEFAULTS,
    instrumentNavigation: true,
    instrumentPageLoad: true,
    markBackgroundSpan: true,
    enableLongTask: true,
    enableLongAnimationFrame: true,
    enableInp: true,
    _experiments: {},
    ...defaultRequestInstrumentationOptions
  };
  var browserTracingIntegration = (_options = {}) => {
    registerSpanErrorInstrumentation();
    const {
      enableInp,
      enableLongTask,
      enableLongAnimationFrame,
      _experiments: { enableInteractions, enableStandaloneClsSpans },
      beforeStartSpan,
      idleTimeout,
      finalTimeout,
      childSpanTimeout,
      markBackgroundSpan,
      traceFetch,
      traceXHR,
      trackFetchStreamPerformance,
      shouldCreateSpanForRequest,
      enableHTTPTimings,
      instrumentPageLoad,
      instrumentNavigation
    } = {
      ...DEFAULT_BROWSER_TRACING_OPTIONS,
      ..._options
    };
    const _collectWebVitals = startTrackingWebVitals({ recordClsStandaloneSpans: enableStandaloneClsSpans || false });
    if (enableInp) {
      startTrackingINP();
    }
    if (enableLongAnimationFrame && GLOBAL_OBJ.PerformanceObserver && PerformanceObserver.supportedEntryTypes && PerformanceObserver.supportedEntryTypes.includes("long-animation-frame")) {
      startTrackingLongAnimationFrames();
    } else if (enableLongTask) {
      startTrackingLongTasks();
    }
    if (enableInteractions) {
      startTrackingInteractions();
    }
    const latestRoute = {
      name: void 0,
      source: void 0
    };
    function _createRouteSpan(client, startSpanOptions) {
      const isPageloadTransaction = startSpanOptions.op === "pageload";
      const finalStartSpanOptions = beforeStartSpan ? beforeStartSpan(startSpanOptions) : startSpanOptions;
      const attributes = finalStartSpanOptions.attributes || {};
      if (startSpanOptions.name !== finalStartSpanOptions.name) {
        attributes[SEMANTIC_ATTRIBUTE_SENTRY_SOURCE] = "custom";
        finalStartSpanOptions.attributes = attributes;
      }
      latestRoute.name = finalStartSpanOptions.name;
      latestRoute.source = attributes[SEMANTIC_ATTRIBUTE_SENTRY_SOURCE];
      const idleSpan = startIdleSpan(finalStartSpanOptions, {
        idleTimeout,
        finalTimeout,
        childSpanTimeout,
        // should wait for finish signal if it's a pageload transaction
        disableAutoFinish: isPageloadTransaction,
        beforeSpanEnd: (span) => {
          _collectWebVitals();
          addPerformanceEntries(span, { recordClsOnPageloadSpan: !enableStandaloneClsSpans });
        }
      });
      function emitFinish() {
        if (["interactive", "complete"].includes(WINDOW4.document.readyState)) {
          client.emit("idleSpanEnableAutoFinish", idleSpan);
        }
      }
      if (isPageloadTransaction && WINDOW4.document) {
        WINDOW4.document.addEventListener("readystatechange", () => {
          emitFinish();
        });
        emitFinish();
      }
      return idleSpan;
    }
    return {
      name: BROWSER_TRACING_INTEGRATION_ID,
      afterAllSetup(client) {
        let activeSpan;
        let startingUrl = WINDOW4.location && WINDOW4.location.href;
        client.on("startNavigationSpan", (startSpanOptions) => {
          if (getClient() !== client) {
            return;
          }
          if (activeSpan && !spanToJSON(activeSpan).timestamp) {
            DEBUG_BUILD3 && logger.log(`[Tracing] Finishing current root span with op: ${spanToJSON(activeSpan).op}`);
            activeSpan.end();
          }
          activeSpan = _createRouteSpan(client, {
            op: "navigation",
            ...startSpanOptions
          });
        });
        client.on("startPageLoadSpan", (startSpanOptions, traceOptions = {}) => {
          if (getClient() !== client) {
            return;
          }
          if (activeSpan && !spanToJSON(activeSpan).timestamp) {
            DEBUG_BUILD3 && logger.log(`[Tracing] Finishing current root span with op: ${spanToJSON(activeSpan).op}`);
            activeSpan.end();
          }
          const sentryTrace = traceOptions.sentryTrace || getMetaContent("sentry-trace");
          const baggage = traceOptions.baggage || getMetaContent("baggage");
          const propagationContext = propagationContextFromHeaders(sentryTrace, baggage);
          getCurrentScope().setPropagationContext(propagationContext);
          activeSpan = _createRouteSpan(client, {
            op: "pageload",
            ...startSpanOptions
          });
        });
        client.on("spanEnd", (span) => {
          const op = spanToJSON(span).op;
          if (span !== getRootSpan(span) || op !== "navigation" && op !== "pageload") {
            return;
          }
          const scope = getCurrentScope();
          const oldPropagationContext = scope.getPropagationContext();
          scope.setPropagationContext({
            ...oldPropagationContext,
            sampled: oldPropagationContext.sampled !== void 0 ? oldPropagationContext.sampled : spanIsSampled(span),
            dsc: oldPropagationContext.dsc || getDynamicSamplingContextFromSpan(span)
          });
        });
        if (WINDOW4.location) {
          if (instrumentPageLoad) {
            startBrowserTracingPageLoadSpan(client, {
              name: WINDOW4.location.pathname,
              // pageload should always start at timeOrigin (and needs to be in s, not ms)
              startTime: browserPerformanceTimeOrigin ? browserPerformanceTimeOrigin / 1e3 : void 0,
              attributes: {
                [SEMANTIC_ATTRIBUTE_SENTRY_SOURCE]: "url",
                [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.pageload.browser"
              }
            });
          }
          if (instrumentNavigation) {
            addHistoryInstrumentationHandler(({ to, from }) => {
              if (from === void 0 && startingUrl && startingUrl.indexOf(to) !== -1) {
                startingUrl = void 0;
                return;
              }
              if (from !== to) {
                startingUrl = void 0;
                startBrowserTracingNavigationSpan(client, {
                  name: WINDOW4.location.pathname,
                  attributes: {
                    [SEMANTIC_ATTRIBUTE_SENTRY_SOURCE]: "url",
                    [SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN]: "auto.navigation.browser"
                  }
                });
              }
            });
          }
        }
        if (markBackgroundSpan) {
          registerBackgroundTabDetection();
        }
        if (enableInteractions) {
          registerInteractionListener(idleTimeout, finalTimeout, childSpanTimeout, latestRoute);
        }
        if (enableInp) {
          registerInpInteractionListener();
        }
        instrumentOutgoingRequests(client, {
          traceFetch,
          traceXHR,
          trackFetchStreamPerformance,
          tracePropagationTargets: client.getOptions().tracePropagationTargets,
          shouldCreateSpanForRequest,
          enableHTTPTimings
        });
      }
    };
  };
  function startBrowserTracingPageLoadSpan(client, spanOptions, traceOptions) {
    client.emit("startPageLoadSpan", spanOptions, traceOptions);
    getCurrentScope().setTransactionName(spanOptions.name);
    const span = getActiveSpan();
    const op = span && spanToJSON(span).op;
    return op === "pageload" ? span : void 0;
  }
  function startBrowserTracingNavigationSpan(client, spanOptions) {
    getIsolationScope().setPropagationContext(generatePropagationContext());
    getCurrentScope().setPropagationContext(generatePropagationContext());
    client.emit("startNavigationSpan", spanOptions);
    getCurrentScope().setTransactionName(spanOptions.name);
    const span = getActiveSpan();
    const op = span && spanToJSON(span).op;
    return op === "navigation" ? span : void 0;
  }
  function getMetaContent(metaName) {
    const metaTag = getDomElement(`meta[name=${metaName}]`);
    return metaTag ? metaTag.getAttribute("content") : void 0;
  }
  function registerInteractionListener(idleTimeout, finalTimeout, childSpanTimeout, latestRoute) {
    let inflightInteractionSpan;
    const registerInteractionTransaction = () => {
      const op = "ui.action.click";
      const activeSpan = getActiveSpan();
      const rootSpan = activeSpan && getRootSpan(activeSpan);
      if (rootSpan) {
        const currentRootSpanOp = spanToJSON(rootSpan).op;
        if (["navigation", "pageload"].includes(currentRootSpanOp)) {
          DEBUG_BUILD3 && logger.warn(`[Tracing] Did not create ${op} span because a pageload or navigation span is in progress.`);
          return void 0;
        }
      }
      if (inflightInteractionSpan) {
        inflightInteractionSpan.setAttribute(SEMANTIC_ATTRIBUTE_SENTRY_IDLE_SPAN_FINISH_REASON, "interactionInterrupted");
        inflightInteractionSpan.end();
        inflightInteractionSpan = void 0;
      }
      if (!latestRoute.name) {
        DEBUG_BUILD3 && logger.warn(`[Tracing] Did not create ${op} transaction because _latestRouteName is missing.`);
        return void 0;
      }
      inflightInteractionSpan = startIdleSpan(
        {
          name: latestRoute.name,
          op,
          attributes: {
            [SEMANTIC_ATTRIBUTE_SENTRY_SOURCE]: latestRoute.source || "url"
          }
        },
        {
          idleTimeout,
          finalTimeout,
          childSpanTimeout
        }
      );
    };
    if (WINDOW4.document) {
      addEventListener("click", registerInteractionTransaction, { once: false, capture: true });
    }
  }

  // node_modules/govuk-frontend/dist/govuk/common/normalise-string.mjs
  function normaliseString(value, property) {
    const trimmedValue = value ? value.trim() : "";
    let output;
    let outputType = property == null ? void 0 : property.type;
    if (!outputType) {
      if (["true", "false"].includes(trimmedValue)) {
        outputType = "boolean";
      }
      if (trimmedValue.length > 0 && isFinite(Number(trimmedValue))) {
        outputType = "number";
      }
    }
    switch (outputType) {
      case "boolean":
        output = trimmedValue === "true";
        break;
      case "number":
        output = Number(trimmedValue);
        break;
      default:
        output = value;
    }
    return output;
  }

  // node_modules/govuk-frontend/dist/govuk/common/index.mjs
  function mergeConfigs(...configObjects) {
    const formattedConfigObject = {};
    for (const configObject of configObjects) {
      for (const key of Object.keys(configObject)) {
        const option = formattedConfigObject[key];
        const override = configObject[key];
        if (isObject(option) && isObject(override)) {
          formattedConfigObject[key] = mergeConfigs(option, override);
        } else {
          formattedConfigObject[key] = override;
        }
      }
    }
    return formattedConfigObject;
  }
  function extractConfigByNamespace(Component, dataset, namespace) {
    const property = Component.schema.properties[namespace];
    if ((property == null ? void 0 : property.type) !== "object") {
      return;
    }
    const newObject = {
      [namespace]: {}
    };
    for (const [key, value] of Object.entries(dataset)) {
      let current = newObject;
      const keyParts = key.split(".");
      for (const [index, name] of keyParts.entries()) {
        if (typeof current === "object") {
          if (index < keyParts.length - 1) {
            if (!isObject(current[name])) {
              current[name] = {};
            }
            current = current[name];
          } else if (key !== namespace) {
            current[name] = normaliseString(value);
          }
        }
      }
    }
    return newObject[namespace];
  }
  function getFragmentFromUrl(url) {
    if (!url.includes("#")) {
      return void 0;
    }
    return url.split("#").pop();
  }
  function getBreakpoint(name) {
    const property = `--govuk-frontend-breakpoint-${name}`;
    const value = window.getComputedStyle(document.documentElement).getPropertyValue(property);
    return {
      property,
      value: value || void 0
    };
  }
  function setFocus($element, options = {}) {
    var _options$onBeforeFocu;
    const isFocusable = $element.getAttribute("tabindex");
    if (!isFocusable) {
      $element.setAttribute("tabindex", "-1");
    }
    function onFocus() {
      $element.addEventListener("blur", onBlur, {
        once: true
      });
    }
    function onBlur() {
      var _options$onBlur;
      (_options$onBlur = options.onBlur) == null || _options$onBlur.call($element);
      if (!isFocusable) {
        $element.removeAttribute("tabindex");
      }
    }
    $element.addEventListener("focus", onFocus, {
      once: true
    });
    (_options$onBeforeFocu = options.onBeforeFocus) == null || _options$onBeforeFocu.call($element);
    $element.focus();
  }
  function isSupported($scope = document.body) {
    if (!$scope) {
      return false;
    }
    return $scope.classList.contains("govuk-frontend-supported");
  }
  function validateConfig(schema, config) {
    const validationErrors = [];
    for (const [name, conditions] of Object.entries(schema)) {
      const errors = [];
      if (Array.isArray(conditions)) {
        for (const {
          required,
          errorMessage
        } of conditions) {
          if (!required.every((key) => !!config[key])) {
            errors.push(errorMessage);
          }
        }
        if (name === "anyOf" && !(conditions.length - errors.length >= 1)) {
          validationErrors.push(...errors);
        }
      }
    }
    return validationErrors;
  }
  function isArray(option) {
    return Array.isArray(option);
  }
  function isObject(option) {
    return !!option && typeof option === "object" && !isArray(option);
  }

  // node_modules/govuk-frontend/dist/govuk/common/normalise-dataset.mjs
  function normaliseDataset(Component, dataset) {
    const out = {};
    for (const [field, property] of Object.entries(Component.schema.properties)) {
      if (field in dataset) {
        out[field] = normaliseString(dataset[field], property);
      }
      if ((property == null ? void 0 : property.type) === "object") {
        out[field] = extractConfigByNamespace(Component, dataset, field);
      }
    }
    return out;
  }

  // node_modules/govuk-frontend/dist/govuk/errors/index.mjs
  var GOVUKFrontendError = class extends Error {
    constructor(...args) {
      super(...args);
      this.name = "GOVUKFrontendError";
    }
  };
  var SupportError = class extends GOVUKFrontendError {
    /**
     * Checks if GOV.UK Frontend is supported on this page
     *
     * @param {HTMLElement | null} [$scope] - HTML element `<body>` checked for browser support
     */
    constructor($scope = document.body) {
      const supportMessage = "noModule" in HTMLScriptElement.prototype ? 'GOV.UK Frontend initialised without `<body class="govuk-frontend-supported">` from template `<script>` snippet' : "GOV.UK Frontend is not supported in this browser";
      super($scope ? supportMessage : 'GOV.UK Frontend initialised without `<script type="module">`');
      this.name = "SupportError";
    }
  };
  var ConfigError = class extends GOVUKFrontendError {
    constructor(...args) {
      super(...args);
      this.name = "ConfigError";
    }
  };
  var ElementError = class extends GOVUKFrontendError {
    constructor(messageOrOptions) {
      let message = typeof messageOrOptions === "string" ? messageOrOptions : "";
      if (typeof messageOrOptions === "object") {
        const {
          componentName,
          identifier,
          element,
          expectedType
        } = messageOrOptions;
        message = `${componentName}: ${identifier}`;
        message += element ? ` is not of type ${expectedType != null ? expectedType : "HTMLElement"}` : " not found";
      }
      super(message);
      this.name = "ElementError";
    }
  };

  // node_modules/govuk-frontend/dist/govuk/govuk-frontend-component.mjs
  var GOVUKFrontendComponent = class {
    constructor() {
      this.checkSupport();
    }
    checkSupport() {
      if (!isSupported()) {
        throw new SupportError();
      }
    }
  };

  // node_modules/govuk-frontend/dist/govuk/i18n.mjs
  var I18n = class _I18n {
    constructor(translations = {}, config = {}) {
      var _config$locale;
      this.translations = void 0;
      this.locale = void 0;
      this.translations = translations;
      this.locale = (_config$locale = config.locale) != null ? _config$locale : document.documentElement.lang || "en";
    }
    t(lookupKey, options) {
      if (!lookupKey) {
        throw new Error("i18n: lookup key missing");
      }
      let translation = this.translations[lookupKey];
      if (typeof (options == null ? void 0 : options.count) === "number" && typeof translation === "object") {
        const translationPluralForm = translation[this.getPluralSuffix(lookupKey, options.count)];
        if (translationPluralForm) {
          translation = translationPluralForm;
        }
      }
      if (typeof translation === "string") {
        if (translation.match(/%{(.\S+)}/)) {
          if (!options) {
            throw new Error("i18n: cannot replace placeholders in string if no option data provided");
          }
          return this.replacePlaceholders(translation, options);
        }
        return translation;
      }
      return lookupKey;
    }
    replacePlaceholders(translationString, options) {
      const formatter = Intl.NumberFormat.supportedLocalesOf(this.locale).length ? new Intl.NumberFormat(this.locale) : void 0;
      return translationString.replace(/%{(.\S+)}/g, function(placeholderWithBraces, placeholderKey) {
        if (Object.prototype.hasOwnProperty.call(options, placeholderKey)) {
          const placeholderValue = options[placeholderKey];
          if (placeholderValue === false || typeof placeholderValue !== "number" && typeof placeholderValue !== "string") {
            return "";
          }
          if (typeof placeholderValue === "number") {
            return formatter ? formatter.format(placeholderValue) : `${placeholderValue}`;
          }
          return placeholderValue;
        }
        throw new Error(`i18n: no data found to replace ${placeholderWithBraces} placeholder in string`);
      });
    }
    hasIntlPluralRulesSupport() {
      return Boolean("PluralRules" in window.Intl && Intl.PluralRules.supportedLocalesOf(this.locale).length);
    }
    getPluralSuffix(lookupKey, count) {
      count = Number(count);
      if (!isFinite(count)) {
        return "other";
      }
      const translation = this.translations[lookupKey];
      const preferredForm = this.hasIntlPluralRulesSupport() ? new Intl.PluralRules(this.locale).select(count) : this.selectPluralFormUsingFallbackRules(count);
      if (typeof translation === "object") {
        if (preferredForm in translation) {
          return preferredForm;
        } else if ("other" in translation) {
          console.warn(`i18n: Missing plural form ".${preferredForm}" for "${this.locale}" locale. Falling back to ".other".`);
          return "other";
        }
      }
      throw new Error(`i18n: Plural form ".other" is required for "${this.locale}" locale`);
    }
    selectPluralFormUsingFallbackRules(count) {
      count = Math.abs(Math.floor(count));
      const ruleset = this.getPluralRulesForLocale();
      if (ruleset) {
        return _I18n.pluralRules[ruleset](count);
      }
      return "other";
    }
    getPluralRulesForLocale() {
      const localeShort = this.locale.split("-")[0];
      for (const pluralRule in _I18n.pluralRulesMap) {
        const languages = _I18n.pluralRulesMap[pluralRule];
        if (languages.includes(this.locale) || languages.includes(localeShort)) {
          return pluralRule;
        }
      }
    }
  };
  I18n.pluralRulesMap = {
    arabic: ["ar"],
    chinese: ["my", "zh", "id", "ja", "jv", "ko", "ms", "th", "vi"],
    french: ["hy", "bn", "fr", "gu", "hi", "fa", "pa", "zu"],
    german: ["af", "sq", "az", "eu", "bg", "ca", "da", "nl", "en", "et", "fi", "ka", "de", "el", "hu", "lb", "no", "so", "sw", "sv", "ta", "te", "tr", "ur"],
    irish: ["ga"],
    russian: ["ru", "uk"],
    scottish: ["gd"],
    spanish: ["pt-PT", "it", "es"],
    welsh: ["cy"]
  };
  I18n.pluralRules = {
    arabic(n) {
      if (n === 0) {
        return "zero";
      }
      if (n === 1) {
        return "one";
      }
      if (n === 2) {
        return "two";
      }
      if (n % 100 >= 3 && n % 100 <= 10) {
        return "few";
      }
      if (n % 100 >= 11 && n % 100 <= 99) {
        return "many";
      }
      return "other";
    },
    chinese() {
      return "other";
    },
    french(n) {
      return n === 0 || n === 1 ? "one" : "other";
    },
    german(n) {
      return n === 1 ? "one" : "other";
    },
    irish(n) {
      if (n === 1) {
        return "one";
      }
      if (n === 2) {
        return "two";
      }
      if (n >= 3 && n <= 6) {
        return "few";
      }
      if (n >= 7 && n <= 10) {
        return "many";
      }
      return "other";
    },
    russian(n) {
      const lastTwo = n % 100;
      const last = lastTwo % 10;
      if (last === 1 && lastTwo !== 11) {
        return "one";
      }
      if (last >= 2 && last <= 4 && !(lastTwo >= 12 && lastTwo <= 14)) {
        return "few";
      }
      if (last === 0 || last >= 5 && last <= 9 || lastTwo >= 11 && lastTwo <= 14) {
        return "many";
      }
      return "other";
    },
    scottish(n) {
      if (n === 1 || n === 11) {
        return "one";
      }
      if (n === 2 || n === 12) {
        return "two";
      }
      if (n >= 3 && n <= 10 || n >= 13 && n <= 19) {
        return "few";
      }
      return "other";
    },
    spanish(n) {
      if (n === 1) {
        return "one";
      }
      if (n % 1e6 === 0 && n !== 0) {
        return "many";
      }
      return "other";
    },
    welsh(n) {
      if (n === 0) {
        return "zero";
      }
      if (n === 1) {
        return "one";
      }
      if (n === 2) {
        return "two";
      }
      if (n === 3) {
        return "few";
      }
      if (n === 6) {
        return "many";
      }
      return "other";
    }
  };

  // node_modules/govuk-frontend/dist/govuk/components/accordion/accordion.mjs
  var Accordion = class _Accordion extends GOVUKFrontendComponent {
    /**
     * @param {Element | null} $module - HTML element to use for accordion
     * @param {AccordionConfig} [config] - Accordion config
     */
    constructor($module, config = {}) {
      super();
      this.$module = void 0;
      this.config = void 0;
      this.i18n = void 0;
      this.controlsClass = "govuk-accordion__controls";
      this.showAllClass = "govuk-accordion__show-all";
      this.showAllTextClass = "govuk-accordion__show-all-text";
      this.sectionClass = "govuk-accordion__section";
      this.sectionExpandedClass = "govuk-accordion__section--expanded";
      this.sectionButtonClass = "govuk-accordion__section-button";
      this.sectionHeaderClass = "govuk-accordion__section-header";
      this.sectionHeadingClass = "govuk-accordion__section-heading";
      this.sectionHeadingDividerClass = "govuk-accordion__section-heading-divider";
      this.sectionHeadingTextClass = "govuk-accordion__section-heading-text";
      this.sectionHeadingTextFocusClass = "govuk-accordion__section-heading-text-focus";
      this.sectionShowHideToggleClass = "govuk-accordion__section-toggle";
      this.sectionShowHideToggleFocusClass = "govuk-accordion__section-toggle-focus";
      this.sectionShowHideTextClass = "govuk-accordion__section-toggle-text";
      this.upChevronIconClass = "govuk-accordion-nav__chevron";
      this.downChevronIconClass = "govuk-accordion-nav__chevron--down";
      this.sectionSummaryClass = "govuk-accordion__section-summary";
      this.sectionSummaryFocusClass = "govuk-accordion__section-summary-focus";
      this.sectionContentClass = "govuk-accordion__section-content";
      this.$sections = void 0;
      this.$showAllButton = null;
      this.$showAllIcon = null;
      this.$showAllText = null;
      if (!($module instanceof HTMLElement)) {
        throw new ElementError({
          componentName: "Accordion",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      this.$module = $module;
      this.config = mergeConfigs(_Accordion.defaults, config, normaliseDataset(_Accordion, $module.dataset));
      this.i18n = new I18n(this.config.i18n);
      const $sections = this.$module.querySelectorAll(`.${this.sectionClass}`);
      if (!$sections.length) {
        throw new ElementError({
          componentName: "Accordion",
          identifier: `Sections (\`<div class="${this.sectionClass}">\`)`
        });
      }
      this.$sections = $sections;
      this.initControls();
      this.initSectionHeaders();
      this.updateShowAllButton(this.areAllSectionsOpen());
    }
    initControls() {
      this.$showAllButton = document.createElement("button");
      this.$showAllButton.setAttribute("type", "button");
      this.$showAllButton.setAttribute("class", this.showAllClass);
      this.$showAllButton.setAttribute("aria-expanded", "false");
      this.$showAllIcon = document.createElement("span");
      this.$showAllIcon.classList.add(this.upChevronIconClass);
      this.$showAllButton.appendChild(this.$showAllIcon);
      const $accordionControls = document.createElement("div");
      $accordionControls.setAttribute("class", this.controlsClass);
      $accordionControls.appendChild(this.$showAllButton);
      this.$module.insertBefore($accordionControls, this.$module.firstChild);
      this.$showAllText = document.createElement("span");
      this.$showAllText.classList.add(this.showAllTextClass);
      this.$showAllButton.appendChild(this.$showAllText);
      this.$showAllButton.addEventListener("click", () => this.onShowOrHideAllToggle());
      if ("onbeforematch" in document) {
        document.addEventListener("beforematch", (event) => this.onBeforeMatch(event));
      }
    }
    initSectionHeaders() {
      this.$sections.forEach(($section, i) => {
        const $header = $section.querySelector(`.${this.sectionHeaderClass}`);
        if (!$header) {
          throw new ElementError({
            componentName: "Accordion",
            identifier: `Section headers (\`<div class="${this.sectionHeaderClass}">\`)`
          });
        }
        this.constructHeaderMarkup($header, i);
        this.setExpanded(this.isExpanded($section), $section);
        $header.addEventListener("click", () => this.onSectionToggle($section));
        this.setInitialState($section);
      });
    }
    constructHeaderMarkup($header, index) {
      const $span = $header.querySelector(`.${this.sectionButtonClass}`);
      const $heading = $header.querySelector(`.${this.sectionHeadingClass}`);
      const $summary = $header.querySelector(`.${this.sectionSummaryClass}`);
      if (!$heading) {
        throw new ElementError({
          componentName: "Accordion",
          identifier: `Section heading (\`.${this.sectionHeadingClass}\`)`
        });
      }
      if (!$span) {
        throw new ElementError({
          componentName: "Accordion",
          identifier: `Section button placeholder (\`<span class="${this.sectionButtonClass}">\`)`
        });
      }
      const $button = document.createElement("button");
      $button.setAttribute("type", "button");
      $button.setAttribute("aria-controls", `${this.$module.id}-content-${index + 1}`);
      for (const attr of Array.from($span.attributes)) {
        if (attr.name !== "id") {
          $button.setAttribute(attr.name, attr.value);
        }
      }
      const $headingText = document.createElement("span");
      $headingText.classList.add(this.sectionHeadingTextClass);
      $headingText.id = $span.id;
      const $headingTextFocus = document.createElement("span");
      $headingTextFocus.classList.add(this.sectionHeadingTextFocusClass);
      $headingText.appendChild($headingTextFocus);
      Array.from($span.childNodes).forEach(($child) => $headingTextFocus.appendChild($child));
      const $showHideToggle = document.createElement("span");
      $showHideToggle.classList.add(this.sectionShowHideToggleClass);
      $showHideToggle.setAttribute("data-nosnippet", "");
      const $showHideToggleFocus = document.createElement("span");
      $showHideToggleFocus.classList.add(this.sectionShowHideToggleFocusClass);
      $showHideToggle.appendChild($showHideToggleFocus);
      const $showHideText = document.createElement("span");
      const $showHideIcon = document.createElement("span");
      $showHideIcon.classList.add(this.upChevronIconClass);
      $showHideToggleFocus.appendChild($showHideIcon);
      $showHideText.classList.add(this.sectionShowHideTextClass);
      $showHideToggleFocus.appendChild($showHideText);
      $button.appendChild($headingText);
      $button.appendChild(this.getButtonPunctuationEl());
      if ($summary) {
        const $summarySpan = document.createElement("span");
        const $summarySpanFocus = document.createElement("span");
        $summarySpanFocus.classList.add(this.sectionSummaryFocusClass);
        $summarySpan.appendChild($summarySpanFocus);
        for (const attr of Array.from($summary.attributes)) {
          $summarySpan.setAttribute(attr.name, attr.value);
        }
        Array.from($summary.childNodes).forEach(($child) => $summarySpanFocus.appendChild($child));
        $summary.remove();
        $button.appendChild($summarySpan);
        $button.appendChild(this.getButtonPunctuationEl());
      }
      $button.appendChild($showHideToggle);
      $heading.removeChild($span);
      $heading.appendChild($button);
    }
    onBeforeMatch(event) {
      const $fragment = event.target;
      if (!($fragment instanceof Element)) {
        return;
      }
      const $section = $fragment.closest(`.${this.sectionClass}`);
      if ($section) {
        this.setExpanded(true, $section);
      }
    }
    onSectionToggle($section) {
      const nowExpanded = !this.isExpanded($section);
      this.setExpanded(nowExpanded, $section);
      this.storeState($section, nowExpanded);
    }
    onShowOrHideAllToggle() {
      const nowExpanded = !this.areAllSectionsOpen();
      this.$sections.forEach(($section) => {
        this.setExpanded(nowExpanded, $section);
        this.storeState($section, nowExpanded);
      });
      this.updateShowAllButton(nowExpanded);
    }
    setExpanded(expanded, $section) {
      const $showHideIcon = $section.querySelector(`.${this.upChevronIconClass}`);
      const $showHideText = $section.querySelector(`.${this.sectionShowHideTextClass}`);
      const $button = $section.querySelector(`.${this.sectionButtonClass}`);
      const $content = $section.querySelector(`.${this.sectionContentClass}`);
      if (!$content) {
        throw new ElementError({
          componentName: "Accordion",
          identifier: `Section content (\`<div class="${this.sectionContentClass}">\`)`
        });
      }
      if (!$showHideIcon || !$showHideText || !$button) {
        return;
      }
      const newButtonText = expanded ? this.i18n.t("hideSection") : this.i18n.t("showSection");
      $showHideText.textContent = newButtonText;
      $button.setAttribute("aria-expanded", `${expanded}`);
      const ariaLabelParts = [];
      const $headingText = $section.querySelector(`.${this.sectionHeadingTextClass}`);
      if ($headingText) {
        ariaLabelParts.push(`${$headingText.textContent}`.trim());
      }
      const $summary = $section.querySelector(`.${this.sectionSummaryClass}`);
      if ($summary) {
        ariaLabelParts.push(`${$summary.textContent}`.trim());
      }
      const ariaLabelMessage = expanded ? this.i18n.t("hideSectionAriaLabel") : this.i18n.t("showSectionAriaLabel");
      ariaLabelParts.push(ariaLabelMessage);
      $button.setAttribute("aria-label", ariaLabelParts.join(" , "));
      if (expanded) {
        $content.removeAttribute("hidden");
        $section.classList.add(this.sectionExpandedClass);
        $showHideIcon.classList.remove(this.downChevronIconClass);
      } else {
        $content.setAttribute("hidden", "until-found");
        $section.classList.remove(this.sectionExpandedClass);
        $showHideIcon.classList.add(this.downChevronIconClass);
      }
      this.updateShowAllButton(this.areAllSectionsOpen());
    }
    isExpanded($section) {
      return $section.classList.contains(this.sectionExpandedClass);
    }
    areAllSectionsOpen() {
      return Array.from(this.$sections).every(($section) => this.isExpanded($section));
    }
    updateShowAllButton(expanded) {
      if (!this.$showAllButton || !this.$showAllText || !this.$showAllIcon) {
        return;
      }
      this.$showAllButton.setAttribute("aria-expanded", expanded.toString());
      this.$showAllText.textContent = expanded ? this.i18n.t("hideAllSections") : this.i18n.t("showAllSections");
      this.$showAllIcon.classList.toggle(this.downChevronIconClass, !expanded);
    }
    /**
     * Get the identifier for a section
     *
     * We need a unique way of identifying each content in the Accordion.
     * Since an `#id` should be unique and an `id` is required for `aria-`
     * attributes `id` can be safely used.
     *
     * @param {Element} $section - Section element
     * @returns {string | undefined | null} Identifier for section
     */
    getIdentifier($section) {
      const $button = $section.querySelector(`.${this.sectionButtonClass}`);
      return $button == null ? void 0 : $button.getAttribute("aria-controls");
    }
    storeState($section, isExpanded) {
      if (!this.config.rememberExpanded) {
        return;
      }
      const id = this.getIdentifier($section);
      if (id) {
        try {
          window.sessionStorage.setItem(id, isExpanded.toString());
        } catch (exception) {
        }
      }
    }
    setInitialState($section) {
      if (!this.config.rememberExpanded) {
        return;
      }
      const id = this.getIdentifier($section);
      if (id) {
        try {
          const state = window.sessionStorage.getItem(id);
          if (state !== null) {
            this.setExpanded(state === "true", $section);
          }
        } catch (exception) {
        }
      }
    }
    getButtonPunctuationEl() {
      const $punctuationEl = document.createElement("span");
      $punctuationEl.classList.add("govuk-visually-hidden", this.sectionHeadingDividerClass);
      $punctuationEl.textContent = ", ";
      return $punctuationEl;
    }
  };
  Accordion.moduleName = "govuk-accordion";
  Accordion.defaults = Object.freeze({
    i18n: {
      hideAllSections: "Hide all sections",
      hideSection: "Hide",
      hideSectionAriaLabel: "Hide this section",
      showAllSections: "Show all sections",
      showSection: "Show",
      showSectionAriaLabel: "Show this section"
    },
    rememberExpanded: true
  });
  Accordion.schema = Object.freeze({
    properties: {
      i18n: {
        type: "object"
      },
      rememberExpanded: {
        type: "boolean"
      }
    }
  });

  // node_modules/govuk-frontend/dist/govuk/components/button/button.mjs
  var DEBOUNCE_TIMEOUT_IN_SECONDS = 1;
  var Button = class _Button extends GOVUKFrontendComponent {
    /**
     * @param {Element | null} $module - HTML element to use for button
     * @param {ButtonConfig} [config] - Button config
     */
    constructor($module, config = {}) {
      super();
      this.$module = void 0;
      this.config = void 0;
      this.debounceFormSubmitTimer = null;
      if (!($module instanceof HTMLElement)) {
        throw new ElementError({
          componentName: "Button",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      this.$module = $module;
      this.config = mergeConfigs(_Button.defaults, config, normaliseDataset(_Button, $module.dataset));
      this.$module.addEventListener("keydown", (event) => this.handleKeyDown(event));
      this.$module.addEventListener("click", (event) => this.debounce(event));
    }
    handleKeyDown(event) {
      const $target = event.target;
      if (event.key !== " ") {
        return;
      }
      if ($target instanceof HTMLElement && $target.getAttribute("role") === "button") {
        event.preventDefault();
        $target.click();
      }
    }
    debounce(event) {
      if (!this.config.preventDoubleClick) {
        return;
      }
      if (this.debounceFormSubmitTimer) {
        event.preventDefault();
        return false;
      }
      this.debounceFormSubmitTimer = window.setTimeout(() => {
        this.debounceFormSubmitTimer = null;
      }, DEBOUNCE_TIMEOUT_IN_SECONDS * 1e3);
    }
  };
  Button.moduleName = "govuk-button";
  Button.defaults = Object.freeze({
    preventDoubleClick: false
  });
  Button.schema = Object.freeze({
    properties: {
      preventDoubleClick: {
        type: "boolean"
      }
    }
  });

  // node_modules/govuk-frontend/dist/govuk/common/closest-attribute-value.mjs
  function closestAttributeValue($element, attributeName) {
    const $closestElementWithAttribute = $element.closest(`[${attributeName}]`);
    return $closestElementWithAttribute ? $closestElementWithAttribute.getAttribute(attributeName) : null;
  }

  // node_modules/govuk-frontend/dist/govuk/components/character-count/character-count.mjs
  var CharacterCount = class _CharacterCount extends GOVUKFrontendComponent {
    /**
     * @param {Element | null} $module - HTML element to use for character count
     * @param {CharacterCountConfig} [config] - Character count config
     */
    constructor($module, config = {}) {
      var _ref, _this$config$maxwords;
      super();
      this.$module = void 0;
      this.$textarea = void 0;
      this.$visibleCountMessage = void 0;
      this.$screenReaderCountMessage = void 0;
      this.lastInputTimestamp = null;
      this.lastInputValue = "";
      this.valueChecker = null;
      this.config = void 0;
      this.i18n = void 0;
      this.maxLength = void 0;
      if (!($module instanceof HTMLElement)) {
        throw new ElementError({
          componentName: "Character count",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      const $textarea = $module.querySelector(".govuk-js-character-count");
      if (!($textarea instanceof HTMLTextAreaElement || $textarea instanceof HTMLInputElement)) {
        throw new ElementError({
          componentName: "Character count",
          element: $textarea,
          expectedType: "HTMLTextareaElement or HTMLInputElement",
          identifier: "Form field (`.govuk-js-character-count`)"
        });
      }
      const datasetConfig = normaliseDataset(_CharacterCount, $module.dataset);
      let configOverrides = {};
      if ("maxwords" in datasetConfig || "maxlength" in datasetConfig) {
        configOverrides = {
          maxlength: void 0,
          maxwords: void 0
        };
      }
      this.config = mergeConfigs(_CharacterCount.defaults, config, configOverrides, datasetConfig);
      const errors = validateConfig(_CharacterCount.schema, this.config);
      if (errors[0]) {
        throw new ConfigError(`Character count: ${errors[0]}`);
      }
      this.i18n = new I18n(this.config.i18n, {
        locale: closestAttributeValue($module, "lang")
      });
      this.maxLength = (_ref = (_this$config$maxwords = this.config.maxwords) != null ? _this$config$maxwords : this.config.maxlength) != null ? _ref : Infinity;
      this.$module = $module;
      this.$textarea = $textarea;
      const textareaDescriptionId = `${this.$textarea.id}-info`;
      const $textareaDescription = document.getElementById(textareaDescriptionId);
      if (!$textareaDescription) {
        throw new ElementError({
          componentName: "Character count",
          element: $textareaDescription,
          identifier: `Count message (\`id="${textareaDescriptionId}"\`)`
        });
      }
      if (`${$textareaDescription.textContent}`.match(/^\s*$/)) {
        $textareaDescription.textContent = this.i18n.t("textareaDescription", {
          count: this.maxLength
        });
      }
      this.$textarea.insertAdjacentElement("afterend", $textareaDescription);
      const $screenReaderCountMessage = document.createElement("div");
      $screenReaderCountMessage.className = "govuk-character-count__sr-status govuk-visually-hidden";
      $screenReaderCountMessage.setAttribute("aria-live", "polite");
      this.$screenReaderCountMessage = $screenReaderCountMessage;
      $textareaDescription.insertAdjacentElement("afterend", $screenReaderCountMessage);
      const $visibleCountMessage = document.createElement("div");
      $visibleCountMessage.className = $textareaDescription.className;
      $visibleCountMessage.classList.add("govuk-character-count__status");
      $visibleCountMessage.setAttribute("aria-hidden", "true");
      this.$visibleCountMessage = $visibleCountMessage;
      $textareaDescription.insertAdjacentElement("afterend", $visibleCountMessage);
      $textareaDescription.classList.add("govuk-visually-hidden");
      this.$textarea.removeAttribute("maxlength");
      this.bindChangeEvents();
      window.addEventListener("pageshow", () => this.updateCountMessage());
      this.updateCountMessage();
    }
    bindChangeEvents() {
      this.$textarea.addEventListener("keyup", () => this.handleKeyUp());
      this.$textarea.addEventListener("focus", () => this.handleFocus());
      this.$textarea.addEventListener("blur", () => this.handleBlur());
    }
    handleKeyUp() {
      this.updateVisibleCountMessage();
      this.lastInputTimestamp = Date.now();
    }
    handleFocus() {
      this.valueChecker = window.setInterval(() => {
        if (!this.lastInputTimestamp || Date.now() - 500 >= this.lastInputTimestamp) {
          this.updateIfValueChanged();
        }
      }, 1e3);
    }
    handleBlur() {
      if (this.valueChecker) {
        window.clearInterval(this.valueChecker);
      }
    }
    updateIfValueChanged() {
      if (this.$textarea.value !== this.lastInputValue) {
        this.lastInputValue = this.$textarea.value;
        this.updateCountMessage();
      }
    }
    updateCountMessage() {
      this.updateVisibleCountMessage();
      this.updateScreenReaderCountMessage();
    }
    updateVisibleCountMessage() {
      const remainingNumber = this.maxLength - this.count(this.$textarea.value);
      const isError2 = remainingNumber < 0;
      this.$visibleCountMessage.classList.toggle("govuk-character-count__message--disabled", !this.isOverThreshold());
      this.$textarea.classList.toggle("govuk-textarea--error", isError2);
      this.$visibleCountMessage.classList.toggle("govuk-error-message", isError2);
      this.$visibleCountMessage.classList.toggle("govuk-hint", !isError2);
      this.$visibleCountMessage.textContent = this.getCountMessage();
    }
    updateScreenReaderCountMessage() {
      if (this.isOverThreshold()) {
        this.$screenReaderCountMessage.removeAttribute("aria-hidden");
      } else {
        this.$screenReaderCountMessage.setAttribute("aria-hidden", "true");
      }
      this.$screenReaderCountMessage.textContent = this.getCountMessage();
    }
    count(text) {
      if (this.config.maxwords) {
        var _text$match;
        const tokens = (_text$match = text.match(/\S+/g)) != null ? _text$match : [];
        return tokens.length;
      }
      return text.length;
    }
    getCountMessage() {
      const remainingNumber = this.maxLength - this.count(this.$textarea.value);
      const countType = this.config.maxwords ? "words" : "characters";
      return this.formatCountMessage(remainingNumber, countType);
    }
    formatCountMessage(remainingNumber, countType) {
      if (remainingNumber === 0) {
        return this.i18n.t(`${countType}AtLimit`);
      }
      const translationKeySuffix = remainingNumber < 0 ? "OverLimit" : "UnderLimit";
      return this.i18n.t(`${countType}${translationKeySuffix}`, {
        count: Math.abs(remainingNumber)
      });
    }
    isOverThreshold() {
      if (!this.config.threshold) {
        return true;
      }
      const currentLength = this.count(this.$textarea.value);
      const maxLength = this.maxLength;
      const thresholdValue = maxLength * this.config.threshold / 100;
      return thresholdValue <= currentLength;
    }
  };
  CharacterCount.moduleName = "govuk-character-count";
  CharacterCount.defaults = Object.freeze({
    threshold: 0,
    i18n: {
      charactersUnderLimit: {
        one: "You have %{count} character remaining",
        other: "You have %{count} characters remaining"
      },
      charactersAtLimit: "You have 0 characters remaining",
      charactersOverLimit: {
        one: "You have %{count} character too many",
        other: "You have %{count} characters too many"
      },
      wordsUnderLimit: {
        one: "You have %{count} word remaining",
        other: "You have %{count} words remaining"
      },
      wordsAtLimit: "You have 0 words remaining",
      wordsOverLimit: {
        one: "You have %{count} word too many",
        other: "You have %{count} words too many"
      },
      textareaDescription: {
        other: ""
      }
    }
  });
  CharacterCount.schema = Object.freeze({
    properties: {
      i18n: {
        type: "object"
      },
      maxwords: {
        type: "number"
      },
      maxlength: {
        type: "number"
      },
      threshold: {
        type: "number"
      }
    },
    anyOf: [{
      required: ["maxwords"],
      errorMessage: 'Either "maxlength" or "maxwords" must be provided'
    }, {
      required: ["maxlength"],
      errorMessage: 'Either "maxlength" or "maxwords" must be provided'
    }]
  });

  // node_modules/govuk-frontend/dist/govuk/components/checkboxes/checkboxes.mjs
  var Checkboxes = class extends GOVUKFrontendComponent {
    /**
     * Checkboxes can be associated with a 'conditionally revealed' content block
     * – for example, a checkbox for 'Phone' could reveal an additional form field
     * for the user to enter their phone number.
     *
     * These associations are made using a `data-aria-controls` attribute, which
     * is promoted to an aria-controls attribute during initialisation.
     *
     * We also need to restore the state of any conditional reveals on the page
     * (for example if the user has navigated back), and set up event handlers to
     * keep the reveal in sync with the checkbox state.
     *
     * @param {Element | null} $module - HTML element to use for checkboxes
     */
    constructor($module) {
      super();
      this.$module = void 0;
      this.$inputs = void 0;
      if (!($module instanceof HTMLElement)) {
        throw new ElementError({
          componentName: "Checkboxes",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      const $inputs = $module.querySelectorAll('input[type="checkbox"]');
      if (!$inputs.length) {
        throw new ElementError({
          componentName: "Checkboxes",
          identifier: 'Form inputs (`<input type="checkbox">`)'
        });
      }
      this.$module = $module;
      this.$inputs = $inputs;
      this.$inputs.forEach(($input) => {
        const targetId = $input.getAttribute("data-aria-controls");
        if (!targetId) {
          return;
        }
        if (!document.getElementById(targetId)) {
          throw new ElementError({
            componentName: "Checkboxes",
            identifier: `Conditional reveal (\`id="${targetId}"\`)`
          });
        }
        $input.setAttribute("aria-controls", targetId);
        $input.removeAttribute("data-aria-controls");
      });
      window.addEventListener("pageshow", () => this.syncAllConditionalReveals());
      this.syncAllConditionalReveals();
      this.$module.addEventListener("click", (event) => this.handleClick(event));
    }
    syncAllConditionalReveals() {
      this.$inputs.forEach(($input) => this.syncConditionalRevealWithInputState($input));
    }
    syncConditionalRevealWithInputState($input) {
      const targetId = $input.getAttribute("aria-controls");
      if (!targetId) {
        return;
      }
      const $target = document.getElementById(targetId);
      if ($target != null && $target.classList.contains("govuk-checkboxes__conditional")) {
        const inputIsChecked = $input.checked;
        $input.setAttribute("aria-expanded", inputIsChecked.toString());
        $target.classList.toggle("govuk-checkboxes__conditional--hidden", !inputIsChecked);
      }
    }
    unCheckAllInputsExcept($input) {
      const allInputsWithSameName = document.querySelectorAll(`input[type="checkbox"][name="${$input.name}"]`);
      allInputsWithSameName.forEach(($inputWithSameName) => {
        const hasSameFormOwner = $input.form === $inputWithSameName.form;
        if (hasSameFormOwner && $inputWithSameName !== $input) {
          $inputWithSameName.checked = false;
          this.syncConditionalRevealWithInputState($inputWithSameName);
        }
      });
    }
    unCheckExclusiveInputs($input) {
      const allInputsWithSameNameAndExclusiveBehaviour = document.querySelectorAll(`input[data-behaviour="exclusive"][type="checkbox"][name="${$input.name}"]`);
      allInputsWithSameNameAndExclusiveBehaviour.forEach(($exclusiveInput) => {
        const hasSameFormOwner = $input.form === $exclusiveInput.form;
        if (hasSameFormOwner) {
          $exclusiveInput.checked = false;
          this.syncConditionalRevealWithInputState($exclusiveInput);
        }
      });
    }
    handleClick(event) {
      const $clickedInput = event.target;
      if (!($clickedInput instanceof HTMLInputElement) || $clickedInput.type !== "checkbox") {
        return;
      }
      const hasAriaControls = $clickedInput.getAttribute("aria-controls");
      if (hasAriaControls) {
        this.syncConditionalRevealWithInputState($clickedInput);
      }
      if (!$clickedInput.checked) {
        return;
      }
      const hasBehaviourExclusive = $clickedInput.getAttribute("data-behaviour") === "exclusive";
      if (hasBehaviourExclusive) {
        this.unCheckAllInputsExcept($clickedInput);
      } else {
        this.unCheckExclusiveInputs($clickedInput);
      }
    }
  };
  Checkboxes.moduleName = "govuk-checkboxes";

  // node_modules/govuk-frontend/dist/govuk/components/error-summary/error-summary.mjs
  var ErrorSummary = class _ErrorSummary extends GOVUKFrontendComponent {
    /**
     * @param {Element | null} $module - HTML element to use for error summary
     * @param {ErrorSummaryConfig} [config] - Error summary config
     */
    constructor($module, config = {}) {
      super();
      this.$module = void 0;
      this.config = void 0;
      if (!($module instanceof HTMLElement)) {
        throw new ElementError({
          componentName: "Error summary",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      this.$module = $module;
      this.config = mergeConfigs(_ErrorSummary.defaults, config, normaliseDataset(_ErrorSummary, $module.dataset));
      if (!this.config.disableAutoFocus) {
        setFocus(this.$module);
      }
      this.$module.addEventListener("click", (event) => this.handleClick(event));
    }
    handleClick(event) {
      const $target = event.target;
      if ($target && this.focusTarget($target)) {
        event.preventDefault();
      }
    }
    focusTarget($target) {
      if (!($target instanceof HTMLAnchorElement)) {
        return false;
      }
      const inputId = getFragmentFromUrl($target.href);
      if (!inputId) {
        return false;
      }
      const $input = document.getElementById(inputId);
      if (!$input) {
        return false;
      }
      const $legendOrLabel = this.getAssociatedLegendOrLabel($input);
      if (!$legendOrLabel) {
        return false;
      }
      $legendOrLabel.scrollIntoView();
      $input.focus({
        preventScroll: true
      });
      return true;
    }
    getAssociatedLegendOrLabel($input) {
      var _document$querySelect;
      const $fieldset = $input.closest("fieldset");
      if ($fieldset) {
        const $legends = $fieldset.getElementsByTagName("legend");
        if ($legends.length) {
          const $candidateLegend = $legends[0];
          if ($input instanceof HTMLInputElement && ($input.type === "checkbox" || $input.type === "radio")) {
            return $candidateLegend;
          }
          const legendTop = $candidateLegend.getBoundingClientRect().top;
          const inputRect = $input.getBoundingClientRect();
          if (inputRect.height && window.innerHeight) {
            const inputBottom = inputRect.top + inputRect.height;
            if (inputBottom - legendTop < window.innerHeight / 2) {
              return $candidateLegend;
            }
          }
        }
      }
      return (_document$querySelect = document.querySelector(`label[for='${$input.getAttribute("id")}']`)) != null ? _document$querySelect : $input.closest("label");
    }
  };
  ErrorSummary.moduleName = "govuk-error-summary";
  ErrorSummary.defaults = Object.freeze({
    disableAutoFocus: false
  });
  ErrorSummary.schema = Object.freeze({
    properties: {
      disableAutoFocus: {
        type: "boolean"
      }
    }
  });

  // node_modules/govuk-frontend/dist/govuk/components/exit-this-page/exit-this-page.mjs
  var ExitThisPage = class _ExitThisPage extends GOVUKFrontendComponent {
    /**
     * @param {Element | null} $module - HTML element that wraps the Exit This Page button
     * @param {ExitThisPageConfig} [config] - Exit This Page config
     */
    constructor($module, config = {}) {
      super();
      this.$module = void 0;
      this.config = void 0;
      this.i18n = void 0;
      this.$button = void 0;
      this.$skiplinkButton = null;
      this.$updateSpan = null;
      this.$indicatorContainer = null;
      this.$overlay = null;
      this.keypressCounter = 0;
      this.lastKeyWasModified = false;
      this.timeoutTime = 5e3;
      this.keypressTimeoutId = null;
      this.timeoutMessageId = null;
      if (!($module instanceof HTMLElement)) {
        throw new ElementError({
          componentName: "Exit this page",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      const $button = $module.querySelector(".govuk-exit-this-page__button");
      if (!($button instanceof HTMLAnchorElement)) {
        throw new ElementError({
          componentName: "Exit this page",
          element: $button,
          expectedType: "HTMLAnchorElement",
          identifier: "Button (`.govuk-exit-this-page__button`)"
        });
      }
      this.config = mergeConfigs(_ExitThisPage.defaults, config, normaliseDataset(_ExitThisPage, $module.dataset));
      this.i18n = new I18n(this.config.i18n);
      this.$module = $module;
      this.$button = $button;
      const $skiplinkButton = document.querySelector(".govuk-js-exit-this-page-skiplink");
      if ($skiplinkButton instanceof HTMLAnchorElement) {
        this.$skiplinkButton = $skiplinkButton;
      }
      this.buildIndicator();
      this.initUpdateSpan();
      this.initButtonClickHandler();
      if (!("govukFrontendExitThisPageKeypress" in document.body.dataset)) {
        document.addEventListener("keyup", this.handleKeypress.bind(this), true);
        document.body.dataset.govukFrontendExitThisPageKeypress = "true";
      }
      window.addEventListener("pageshow", this.resetPage.bind(this));
    }
    initUpdateSpan() {
      this.$updateSpan = document.createElement("span");
      this.$updateSpan.setAttribute("role", "status");
      this.$updateSpan.className = "govuk-visually-hidden";
      this.$module.appendChild(this.$updateSpan);
    }
    initButtonClickHandler() {
      this.$button.addEventListener("click", this.handleClick.bind(this));
      if (this.$skiplinkButton) {
        this.$skiplinkButton.addEventListener("click", this.handleClick.bind(this));
      }
    }
    buildIndicator() {
      this.$indicatorContainer = document.createElement("div");
      this.$indicatorContainer.className = "govuk-exit-this-page__indicator";
      this.$indicatorContainer.setAttribute("aria-hidden", "true");
      for (let i = 0; i < 3; i++) {
        const $indicator = document.createElement("div");
        $indicator.className = "govuk-exit-this-page__indicator-light";
        this.$indicatorContainer.appendChild($indicator);
      }
      this.$button.appendChild(this.$indicatorContainer);
    }
    updateIndicator() {
      if (!this.$indicatorContainer) {
        return;
      }
      this.$indicatorContainer.classList.toggle("govuk-exit-this-page__indicator--visible", this.keypressCounter > 0);
      const $indicators = this.$indicatorContainer.querySelectorAll(".govuk-exit-this-page__indicator-light");
      $indicators.forEach(($indicator, index) => {
        $indicator.classList.toggle("govuk-exit-this-page__indicator-light--on", index < this.keypressCounter);
      });
    }
    exitPage() {
      if (!this.$updateSpan) {
        return;
      }
      this.$updateSpan.textContent = "";
      document.body.classList.add("govuk-exit-this-page-hide-content");
      this.$overlay = document.createElement("div");
      this.$overlay.className = "govuk-exit-this-page-overlay";
      this.$overlay.setAttribute("role", "alert");
      document.body.appendChild(this.$overlay);
      this.$overlay.textContent = this.i18n.t("activated");
      window.location.href = this.$button.href;
    }
    handleClick(event) {
      event.preventDefault();
      this.exitPage();
    }
    handleKeypress(event) {
      if (!this.$updateSpan) {
        return;
      }
      if (event.key === "Shift" && !this.lastKeyWasModified) {
        this.keypressCounter += 1;
        this.updateIndicator();
        if (this.timeoutMessageId) {
          window.clearTimeout(this.timeoutMessageId);
          this.timeoutMessageId = null;
        }
        if (this.keypressCounter >= 3) {
          this.keypressCounter = 0;
          if (this.keypressTimeoutId) {
            window.clearTimeout(this.keypressTimeoutId);
            this.keypressTimeoutId = null;
          }
          this.exitPage();
        } else {
          if (this.keypressCounter === 1) {
            this.$updateSpan.textContent = this.i18n.t("pressTwoMoreTimes");
          } else {
            this.$updateSpan.textContent = this.i18n.t("pressOneMoreTime");
          }
        }
        this.setKeypressTimer();
      } else if (this.keypressTimeoutId) {
        this.resetKeypressTimer();
      }
      this.lastKeyWasModified = event.shiftKey;
    }
    setKeypressTimer() {
      if (this.keypressTimeoutId) {
        window.clearTimeout(this.keypressTimeoutId);
      }
      this.keypressTimeoutId = window.setTimeout(this.resetKeypressTimer.bind(this), this.timeoutTime);
    }
    resetKeypressTimer() {
      if (!this.$updateSpan) {
        return;
      }
      if (this.keypressTimeoutId) {
        window.clearTimeout(this.keypressTimeoutId);
        this.keypressTimeoutId = null;
      }
      const $updateSpan = this.$updateSpan;
      this.keypressCounter = 0;
      $updateSpan.textContent = this.i18n.t("timedOut");
      this.timeoutMessageId = window.setTimeout(() => {
        $updateSpan.textContent = "";
      }, this.timeoutTime);
      this.updateIndicator();
    }
    resetPage() {
      document.body.classList.remove("govuk-exit-this-page-hide-content");
      if (this.$overlay) {
        this.$overlay.remove();
        this.$overlay = null;
      }
      if (this.$updateSpan) {
        this.$updateSpan.setAttribute("role", "status");
        this.$updateSpan.textContent = "";
      }
      this.updateIndicator();
      if (this.keypressTimeoutId) {
        window.clearTimeout(this.keypressTimeoutId);
      }
      if (this.timeoutMessageId) {
        window.clearTimeout(this.timeoutMessageId);
      }
    }
  };
  ExitThisPage.moduleName = "govuk-exit-this-page";
  ExitThisPage.defaults = Object.freeze({
    i18n: {
      activated: "Loading.",
      timedOut: "Exit this page expired.",
      pressTwoMoreTimes: "Shift, press 2 more times to exit.",
      pressOneMoreTime: "Shift, press 1 more time to exit."
    }
  });
  ExitThisPage.schema = Object.freeze({
    properties: {
      i18n: {
        type: "object"
      }
    }
  });

  // node_modules/govuk-frontend/dist/govuk/components/header/header.mjs
  var Header = class extends GOVUKFrontendComponent {
    /**
     * Apply a matchMedia for desktop which will trigger a state sync if the
     * browser viewport moves between states.
     *
     * @param {Element | null} $module - HTML element to use for header
     */
    constructor($module) {
      super();
      this.$module = void 0;
      this.$menuButton = void 0;
      this.$menu = void 0;
      this.menuIsOpen = false;
      this.mql = null;
      if (!$module) {
        throw new ElementError({
          componentName: "Header",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      this.$module = $module;
      const $menuButton = $module.querySelector(".govuk-js-header-toggle");
      if (!$menuButton) {
        return this;
      }
      const menuId = $menuButton.getAttribute("aria-controls");
      if (!menuId) {
        throw new ElementError({
          componentName: "Header",
          identifier: 'Navigation button (`<button class="govuk-js-header-toggle">`) attribute (`aria-controls`)'
        });
      }
      const $menu = document.getElementById(menuId);
      if (!$menu) {
        throw new ElementError({
          componentName: "Header",
          element: $menu,
          identifier: `Navigation (\`<ul id="${menuId}">\`)`
        });
      }
      this.$menu = $menu;
      this.$menuButton = $menuButton;
      this.setupResponsiveChecks();
      this.$menuButton.addEventListener("click", () => this.handleMenuButtonClick());
    }
    setupResponsiveChecks() {
      const breakpoint = getBreakpoint("desktop");
      if (!breakpoint.value) {
        throw new ElementError({
          componentName: "Header",
          identifier: `CSS custom property (\`${breakpoint.property}\`) on pseudo-class \`:root\``
        });
      }
      this.mql = window.matchMedia(`(min-width: ${breakpoint.value})`);
      if ("addEventListener" in this.mql) {
        this.mql.addEventListener("change", () => this.checkMode());
      } else {
        this.mql.addListener(() => this.checkMode());
      }
      this.checkMode();
    }
    checkMode() {
      if (!this.mql || !this.$menu || !this.$menuButton) {
        return;
      }
      if (this.mql.matches) {
        this.$menu.removeAttribute("hidden");
        this.$menuButton.setAttribute("hidden", "");
      } else {
        this.$menuButton.removeAttribute("hidden");
        this.$menuButton.setAttribute("aria-expanded", this.menuIsOpen.toString());
        if (this.menuIsOpen) {
          this.$menu.removeAttribute("hidden");
        } else {
          this.$menu.setAttribute("hidden", "");
        }
      }
    }
    handleMenuButtonClick() {
      this.menuIsOpen = !this.menuIsOpen;
      this.checkMode();
    }
  };
  Header.moduleName = "govuk-header";

  // node_modules/govuk-frontend/dist/govuk/components/notification-banner/notification-banner.mjs
  var NotificationBanner = class _NotificationBanner extends GOVUKFrontendComponent {
    /**
     * @param {Element | null} $module - HTML element to use for notification banner
     * @param {NotificationBannerConfig} [config] - Notification banner config
     */
    constructor($module, config = {}) {
      super();
      this.$module = void 0;
      this.config = void 0;
      if (!($module instanceof HTMLElement)) {
        throw new ElementError({
          componentName: "Notification banner",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      this.$module = $module;
      this.config = mergeConfigs(_NotificationBanner.defaults, config, normaliseDataset(_NotificationBanner, $module.dataset));
      if (this.$module.getAttribute("role") === "alert" && !this.config.disableAutoFocus) {
        setFocus(this.$module);
      }
    }
  };
  NotificationBanner.moduleName = "govuk-notification-banner";
  NotificationBanner.defaults = Object.freeze({
    disableAutoFocus: false
  });
  NotificationBanner.schema = Object.freeze({
    properties: {
      disableAutoFocus: {
        type: "boolean"
      }
    }
  });

  // node_modules/govuk-frontend/dist/govuk/components/password-input/password-input.mjs
  var PasswordInput = class _PasswordInput extends GOVUKFrontendComponent {
    /**
     * @param {Element | null} $module - HTML element to use for password input
     * @param {PasswordInputConfig} [config] - Password input config
     */
    constructor($module, config = {}) {
      super();
      this.$module = void 0;
      this.config = void 0;
      this.i18n = void 0;
      this.$input = void 0;
      this.$showHideButton = void 0;
      this.$screenReaderStatusMessage = void 0;
      if (!($module instanceof HTMLElement)) {
        throw new ElementError({
          componentName: "Password input",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      const $input = $module.querySelector(".govuk-js-password-input-input");
      if (!($input instanceof HTMLInputElement)) {
        throw new ElementError({
          componentName: "Password input",
          element: $input,
          expectedType: "HTMLInputElement",
          identifier: "Form field (`.govuk-js-password-input-input`)"
        });
      }
      if ($input.type !== "password") {
        throw new ElementError("Password input: Form field (`.govuk-js-password-input-input`) must be of type `password`.");
      }
      const $showHideButton = $module.querySelector(".govuk-js-password-input-toggle");
      if (!($showHideButton instanceof HTMLButtonElement)) {
        throw new ElementError({
          componentName: "Password input",
          element: $showHideButton,
          expectedType: "HTMLButtonElement",
          identifier: "Button (`.govuk-js-password-input-toggle`)"
        });
      }
      if ($showHideButton.type !== "button") {
        throw new ElementError("Password input: Button (`.govuk-js-password-input-toggle`) must be of type `button`.");
      }
      this.$module = $module;
      this.$input = $input;
      this.$showHideButton = $showHideButton;
      this.config = mergeConfigs(_PasswordInput.defaults, config, normaliseDataset(_PasswordInput, $module.dataset));
      this.i18n = new I18n(this.config.i18n, {
        locale: closestAttributeValue($module, "lang")
      });
      this.$showHideButton.removeAttribute("hidden");
      const $screenReaderStatusMessage = document.createElement("div");
      $screenReaderStatusMessage.className = "govuk-password-input__sr-status govuk-visually-hidden";
      $screenReaderStatusMessage.setAttribute("aria-live", "polite");
      this.$screenReaderStatusMessage = $screenReaderStatusMessage;
      this.$input.insertAdjacentElement("afterend", $screenReaderStatusMessage);
      this.$showHideButton.addEventListener("click", this.toggle.bind(this));
      if (this.$input.form) {
        this.$input.form.addEventListener("submit", () => this.hide());
      }
      window.addEventListener("pageshow", (event) => {
        if (event.persisted && this.$input.type !== "password") {
          this.hide();
        }
      });
      this.hide();
    }
    toggle(event) {
      event.preventDefault();
      if (this.$input.type === "password") {
        this.show();
        return;
      }
      this.hide();
    }
    show() {
      this.setType("text");
    }
    hide() {
      this.setType("password");
    }
    setType(type) {
      if (type === this.$input.type) {
        return;
      }
      this.$input.setAttribute("type", type);
      const isHidden = type === "password";
      const prefixButton = isHidden ? "show" : "hide";
      const prefixStatus = isHidden ? "passwordHidden" : "passwordShown";
      this.$showHideButton.innerText = this.i18n.t(`${prefixButton}Password`);
      this.$showHideButton.setAttribute("aria-label", this.i18n.t(`${prefixButton}PasswordAriaLabel`));
      this.$screenReaderStatusMessage.innerText = this.i18n.t(`${prefixStatus}Announcement`);
    }
  };
  PasswordInput.moduleName = "govuk-password-input";
  PasswordInput.defaults = Object.freeze({
    i18n: {
      showPassword: "Show",
      hidePassword: "Hide",
      showPasswordAriaLabel: "Show password",
      hidePasswordAriaLabel: "Hide password",
      passwordShownAnnouncement: "Your password is visible",
      passwordHiddenAnnouncement: "Your password is hidden"
    }
  });
  PasswordInput.schema = Object.freeze({
    properties: {
      i18n: {
        type: "object"
      }
    }
  });

  // node_modules/govuk-frontend/dist/govuk/components/radios/radios.mjs
  var Radios = class extends GOVUKFrontendComponent {
    /**
     * Radios can be associated with a 'conditionally revealed' content block –
     * for example, a radio for 'Phone' could reveal an additional form field for
     * the user to enter their phone number.
     *
     * These associations are made using a `data-aria-controls` attribute, which
     * is promoted to an aria-controls attribute during initialisation.
     *
     * We also need to restore the state of any conditional reveals on the page
     * (for example if the user has navigated back), and set up event handlers to
     * keep the reveal in sync with the radio state.
     *
     * @param {Element | null} $module - HTML element to use for radios
     */
    constructor($module) {
      super();
      this.$module = void 0;
      this.$inputs = void 0;
      if (!($module instanceof HTMLElement)) {
        throw new ElementError({
          componentName: "Radios",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      const $inputs = $module.querySelectorAll('input[type="radio"]');
      if (!$inputs.length) {
        throw new ElementError({
          componentName: "Radios",
          identifier: 'Form inputs (`<input type="radio">`)'
        });
      }
      this.$module = $module;
      this.$inputs = $inputs;
      this.$inputs.forEach(($input) => {
        const targetId = $input.getAttribute("data-aria-controls");
        if (!targetId) {
          return;
        }
        if (!document.getElementById(targetId)) {
          throw new ElementError({
            componentName: "Radios",
            identifier: `Conditional reveal (\`id="${targetId}"\`)`
          });
        }
        $input.setAttribute("aria-controls", targetId);
        $input.removeAttribute("data-aria-controls");
      });
      window.addEventListener("pageshow", () => this.syncAllConditionalReveals());
      this.syncAllConditionalReveals();
      this.$module.addEventListener("click", (event) => this.handleClick(event));
    }
    syncAllConditionalReveals() {
      this.$inputs.forEach(($input) => this.syncConditionalRevealWithInputState($input));
    }
    syncConditionalRevealWithInputState($input) {
      const targetId = $input.getAttribute("aria-controls");
      if (!targetId) {
        return;
      }
      const $target = document.getElementById(targetId);
      if ($target != null && $target.classList.contains("govuk-radios__conditional")) {
        const inputIsChecked = $input.checked;
        $input.setAttribute("aria-expanded", inputIsChecked.toString());
        $target.classList.toggle("govuk-radios__conditional--hidden", !inputIsChecked);
      }
    }
    handleClick(event) {
      const $clickedInput = event.target;
      if (!($clickedInput instanceof HTMLInputElement) || $clickedInput.type !== "radio") {
        return;
      }
      const $allInputs = document.querySelectorAll('input[type="radio"][aria-controls]');
      const $clickedInputForm = $clickedInput.form;
      const $clickedInputName = $clickedInput.name;
      $allInputs.forEach(($input) => {
        const hasSameFormOwner = $input.form === $clickedInputForm;
        const hasSameName = $input.name === $clickedInputName;
        if (hasSameName && hasSameFormOwner) {
          this.syncConditionalRevealWithInputState($input);
        }
      });
    }
  };
  Radios.moduleName = "govuk-radios";

  // node_modules/govuk-frontend/dist/govuk/components/service-navigation/service-navigation.mjs
  var ServiceNavigation = class extends GOVUKFrontendComponent {
    /**
     * @param {Element | null} $module - HTML element to use for header
     */
    constructor($module) {
      super();
      this.$module = void 0;
      this.$menuButton = void 0;
      this.$menu = void 0;
      this.menuIsOpen = false;
      this.mql = null;
      if (!$module) {
        throw new ElementError({
          componentName: "Service Navigation",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      this.$module = $module;
      const $menuButton = $module.querySelector(".govuk-js-service-navigation-toggle");
      if (!$menuButton) {
        return this;
      }
      const menuId = $menuButton.getAttribute("aria-controls");
      if (!menuId) {
        throw new ElementError({
          componentName: "Service Navigation",
          identifier: 'Navigation button (`<button class="govuk-js-service-navigation-toggle">`) attribute (`aria-controls`)'
        });
      }
      const $menu = document.getElementById(menuId);
      if (!$menu) {
        throw new ElementError({
          componentName: "Service Navigation",
          element: $menu,
          identifier: `Navigation (\`<ul id="${menuId}">\`)`
        });
      }
      this.$menu = $menu;
      this.$menuButton = $menuButton;
      this.setupResponsiveChecks();
      this.$menuButton.addEventListener("click", () => this.handleMenuButtonClick());
    }
    setupResponsiveChecks() {
      const breakpoint = getBreakpoint("tablet");
      if (!breakpoint.value) {
        throw new ElementError({
          componentName: "Service Navigation",
          identifier: `CSS custom property (\`${breakpoint.property}\`) on pseudo-class \`:root\``
        });
      }
      this.mql = window.matchMedia(`(min-width: ${breakpoint.value})`);
      if ("addEventListener" in this.mql) {
        this.mql.addEventListener("change", () => this.checkMode());
      } else {
        this.mql.addListener(() => this.checkMode());
      }
      this.checkMode();
    }
    checkMode() {
      if (!this.mql || !this.$menu || !this.$menuButton) {
        return;
      }
      if (this.mql.matches) {
        this.$menu.removeAttribute("hidden");
        this.$menuButton.setAttribute("hidden", "");
      } else {
        this.$menuButton.removeAttribute("hidden");
        this.$menuButton.setAttribute("aria-expanded", this.menuIsOpen.toString());
        if (this.menuIsOpen) {
          this.$menu.removeAttribute("hidden");
        } else {
          this.$menu.setAttribute("hidden", "");
        }
      }
    }
    handleMenuButtonClick() {
      this.menuIsOpen = !this.menuIsOpen;
      this.checkMode();
    }
  };
  ServiceNavigation.moduleName = "govuk-service-navigation";

  // node_modules/govuk-frontend/dist/govuk/components/skip-link/skip-link.mjs
  var SkipLink = class extends GOVUKFrontendComponent {
    /**
     * @param {Element | null} $module - HTML element to use for skip link
     * @throws {ElementError} when $module is not set or the wrong type
     * @throws {ElementError} when $module.hash does not contain a hash
     * @throws {ElementError} when the linked element is missing or the wrong type
     */
    constructor($module) {
      var _this$$module$getAttr;
      super();
      this.$module = void 0;
      if (!($module instanceof HTMLAnchorElement)) {
        throw new ElementError({
          componentName: "Skip link",
          element: $module,
          expectedType: "HTMLAnchorElement",
          identifier: "Root element (`$module`)"
        });
      }
      this.$module = $module;
      const hash = this.$module.hash;
      const href2 = (_this$$module$getAttr = this.$module.getAttribute("href")) != null ? _this$$module$getAttr : "";
      let url;
      try {
        url = new window.URL(this.$module.href);
      } catch (error) {
        throw new ElementError(`Skip link: Target link (\`href="${href2}"\`) is invalid`);
      }
      if (url.origin !== window.location.origin || url.pathname !== window.location.pathname) {
        return;
      }
      const linkedElementId = getFragmentFromUrl(hash);
      if (!linkedElementId) {
        throw new ElementError(`Skip link: Target link (\`href="${href2}"\`) has no hash fragment`);
      }
      const $linkedElement = document.getElementById(linkedElementId);
      if (!$linkedElement) {
        throw new ElementError({
          componentName: "Skip link",
          element: $linkedElement,
          identifier: `Target content (\`id="${linkedElementId}"\`)`
        });
      }
      this.$module.addEventListener("click", () => setFocus($linkedElement, {
        onBeforeFocus() {
          $linkedElement.classList.add("govuk-skip-link-focused-element");
        },
        onBlur() {
          $linkedElement.classList.remove("govuk-skip-link-focused-element");
        }
      }));
    }
  };
  SkipLink.moduleName = "govuk-skip-link";

  // node_modules/govuk-frontend/dist/govuk/components/tabs/tabs.mjs
  var Tabs = class extends GOVUKFrontendComponent {
    /**
     * @param {Element | null} $module - HTML element to use for tabs
     */
    constructor($module) {
      super();
      this.$module = void 0;
      this.$tabs = void 0;
      this.$tabList = void 0;
      this.$tabListItems = void 0;
      this.jsHiddenClass = "govuk-tabs__panel--hidden";
      this.changingHash = false;
      this.boundTabClick = void 0;
      this.boundTabKeydown = void 0;
      this.boundOnHashChange = void 0;
      this.mql = null;
      if (!$module) {
        throw new ElementError({
          componentName: "Tabs",
          element: $module,
          identifier: "Root element (`$module`)"
        });
      }
      const $tabs = $module.querySelectorAll("a.govuk-tabs__tab");
      if (!$tabs.length) {
        throw new ElementError({
          componentName: "Tabs",
          identifier: 'Links (`<a class="govuk-tabs__tab">`)'
        });
      }
      this.$module = $module;
      this.$tabs = $tabs;
      this.boundTabClick = this.onTabClick.bind(this);
      this.boundTabKeydown = this.onTabKeydown.bind(this);
      this.boundOnHashChange = this.onHashChange.bind(this);
      const $tabList = this.$module.querySelector(".govuk-tabs__list");
      const $tabListItems = this.$module.querySelectorAll("li.govuk-tabs__list-item");
      if (!$tabList) {
        throw new ElementError({
          componentName: "Tabs",
          identifier: 'List (`<ul class="govuk-tabs__list">`)'
        });
      }
      if (!$tabListItems.length) {
        throw new ElementError({
          componentName: "Tabs",
          identifier: 'List items (`<li class="govuk-tabs__list-item">`)'
        });
      }
      this.$tabList = $tabList;
      this.$tabListItems = $tabListItems;
      this.setupResponsiveChecks();
    }
    setupResponsiveChecks() {
      const breakpoint = getBreakpoint("tablet");
      if (!breakpoint.value) {
        throw new ElementError({
          componentName: "Tabs",
          identifier: `CSS custom property (\`${breakpoint.property}\`) on pseudo-class \`:root\``
        });
      }
      this.mql = window.matchMedia(`(min-width: ${breakpoint.value})`);
      if ("addEventListener" in this.mql) {
        this.mql.addEventListener("change", () => this.checkMode());
      } else {
        this.mql.addListener(() => this.checkMode());
      }
      this.checkMode();
    }
    checkMode() {
      var _this$mql;
      if ((_this$mql = this.mql) != null && _this$mql.matches) {
        this.setup();
      } else {
        this.teardown();
      }
    }
    setup() {
      var _this$getTab;
      this.$tabList.setAttribute("role", "tablist");
      this.$tabListItems.forEach(($item) => {
        $item.setAttribute("role", "presentation");
      });
      this.$tabs.forEach(($tab) => {
        this.setAttributes($tab);
        $tab.addEventListener("click", this.boundTabClick, true);
        $tab.addEventListener("keydown", this.boundTabKeydown, true);
        this.hideTab($tab);
      });
      const $activeTab = (_this$getTab = this.getTab(window.location.hash)) != null ? _this$getTab : this.$tabs[0];
      this.showTab($activeTab);
      window.addEventListener("hashchange", this.boundOnHashChange, true);
    }
    teardown() {
      this.$tabList.removeAttribute("role");
      this.$tabListItems.forEach(($item) => {
        $item.removeAttribute("role");
      });
      this.$tabs.forEach(($tab) => {
        $tab.removeEventListener("click", this.boundTabClick, true);
        $tab.removeEventListener("keydown", this.boundTabKeydown, true);
        this.unsetAttributes($tab);
      });
      window.removeEventListener("hashchange", this.boundOnHashChange, true);
    }
    onHashChange() {
      const hash = window.location.hash;
      const $tabWithHash = this.getTab(hash);
      if (!$tabWithHash) {
        return;
      }
      if (this.changingHash) {
        this.changingHash = false;
        return;
      }
      const $previousTab = this.getCurrentTab();
      if (!$previousTab) {
        return;
      }
      this.hideTab($previousTab);
      this.showTab($tabWithHash);
      $tabWithHash.focus();
    }
    hideTab($tab) {
      this.unhighlightTab($tab);
      this.hidePanel($tab);
    }
    showTab($tab) {
      this.highlightTab($tab);
      this.showPanel($tab);
    }
    getTab(hash) {
      return this.$module.querySelector(`a.govuk-tabs__tab[href="${hash}"]`);
    }
    setAttributes($tab) {
      const panelId = getFragmentFromUrl($tab.href);
      if (!panelId) {
        return;
      }
      $tab.setAttribute("id", `tab_${panelId}`);
      $tab.setAttribute("role", "tab");
      $tab.setAttribute("aria-controls", panelId);
      $tab.setAttribute("aria-selected", "false");
      $tab.setAttribute("tabindex", "-1");
      const $panel = this.getPanel($tab);
      if (!$panel) {
        return;
      }
      $panel.setAttribute("role", "tabpanel");
      $panel.setAttribute("aria-labelledby", $tab.id);
      $panel.classList.add(this.jsHiddenClass);
    }
    unsetAttributes($tab) {
      $tab.removeAttribute("id");
      $tab.removeAttribute("role");
      $tab.removeAttribute("aria-controls");
      $tab.removeAttribute("aria-selected");
      $tab.removeAttribute("tabindex");
      const $panel = this.getPanel($tab);
      if (!$panel) {
        return;
      }
      $panel.removeAttribute("role");
      $panel.removeAttribute("aria-labelledby");
      $panel.classList.remove(this.jsHiddenClass);
    }
    onTabClick(event) {
      const $currentTab = this.getCurrentTab();
      const $nextTab = event.currentTarget;
      if (!$currentTab || !($nextTab instanceof HTMLAnchorElement)) {
        return;
      }
      event.preventDefault();
      this.hideTab($currentTab);
      this.showTab($nextTab);
      this.createHistoryEntry($nextTab);
    }
    createHistoryEntry($tab) {
      const $panel = this.getPanel($tab);
      if (!$panel) {
        return;
      }
      const panelId = $panel.id;
      $panel.id = "";
      this.changingHash = true;
      window.location.hash = panelId;
      $panel.id = panelId;
    }
    onTabKeydown(event) {
      switch (event.key) {
        case "ArrowLeft":
        case "Left":
          this.activatePreviousTab();
          event.preventDefault();
          break;
        case "ArrowRight":
        case "Right":
          this.activateNextTab();
          event.preventDefault();
          break;
      }
    }
    activateNextTab() {
      const $currentTab = this.getCurrentTab();
      if (!($currentTab != null && $currentTab.parentElement)) {
        return;
      }
      const $nextTabListItem = $currentTab.parentElement.nextElementSibling;
      if (!$nextTabListItem) {
        return;
      }
      const $nextTab = $nextTabListItem.querySelector("a.govuk-tabs__tab");
      if (!$nextTab) {
        return;
      }
      this.hideTab($currentTab);
      this.showTab($nextTab);
      $nextTab.focus();
      this.createHistoryEntry($nextTab);
    }
    activatePreviousTab() {
      const $currentTab = this.getCurrentTab();
      if (!($currentTab != null && $currentTab.parentElement)) {
        return;
      }
      const $previousTabListItem = $currentTab.parentElement.previousElementSibling;
      if (!$previousTabListItem) {
        return;
      }
      const $previousTab = $previousTabListItem.querySelector("a.govuk-tabs__tab");
      if (!$previousTab) {
        return;
      }
      this.hideTab($currentTab);
      this.showTab($previousTab);
      $previousTab.focus();
      this.createHistoryEntry($previousTab);
    }
    getPanel($tab) {
      const panelId = getFragmentFromUrl($tab.href);
      if (!panelId) {
        return null;
      }
      return this.$module.querySelector(`#${panelId}`);
    }
    showPanel($tab) {
      const $panel = this.getPanel($tab);
      if (!$panel) {
        return;
      }
      $panel.classList.remove(this.jsHiddenClass);
    }
    hidePanel($tab) {
      const $panel = this.getPanel($tab);
      if (!$panel) {
        return;
      }
      $panel.classList.add(this.jsHiddenClass);
    }
    unhighlightTab($tab) {
      if (!$tab.parentElement) {
        return;
      }
      $tab.setAttribute("aria-selected", "false");
      $tab.parentElement.classList.remove("govuk-tabs__list-item--selected");
      $tab.setAttribute("tabindex", "-1");
    }
    highlightTab($tab) {
      if (!$tab.parentElement) {
        return;
      }
      $tab.setAttribute("aria-selected", "true");
      $tab.parentElement.classList.add("govuk-tabs__list-item--selected");
      $tab.setAttribute("tabindex", "0");
    }
    getCurrentTab() {
      return this.$module.querySelector(".govuk-tabs__list-item--selected a.govuk-tabs__tab");
    }
  };
  Tabs.moduleName = "govuk-tabs";

  // node_modules/govuk-frontend/dist/govuk/init.mjs
  function initAll(config) {
    var _config$scope;
    config = typeof config !== "undefined" ? config : {};
    if (!isSupported()) {
      console.log(new SupportError());
      return;
    }
    const components = [[Accordion, config.accordion], [Button, config.button], [CharacterCount, config.characterCount], [Checkboxes], [ErrorSummary, config.errorSummary], [ExitThisPage, config.exitThisPage], [Header], [NotificationBanner, config.notificationBanner], [PasswordInput, config.passwordInput], [Radios], [ServiceNavigation], [SkipLink], [Tabs]];
    const $scope = (_config$scope = config.scope) != null ? _config$scope : document;
    components.forEach(([Component, config2]) => {
      createAll(Component, config2, $scope);
    });
  }
  function createAll(Component, config, $scope = document) {
    const $elements = $scope.querySelectorAll(`[data-module="${Component.moduleName}"]`);
    return Array.from($elements).map(($element) => {
      try {
        return "defaults" in Component && typeof config !== "undefined" ? new Component($element, config) : new Component($element);
      } catch (error) {
        console.log(error);
        return null;
      }
    }).filter(Boolean);
  }

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

  // node_modules/@rails/ujs/app/assets/javascripts/rails-ujs.esm.js
  var linkClickSelector = "a[data-confirm], a[data-method], a[data-remote]:not([disabled]), a[data-disable-with], a[data-disable]";
  var buttonClickSelector = {
    selector: "button[data-remote]:not([form]), button[data-confirm]:not([form])",
    exclude: "form button"
  };
  var inputChangeSelector = "select[data-remote], input[data-remote], textarea[data-remote]";
  var formSubmitSelector = "form:not([data-turbo=true])";
  var formInputClickSelector = "form:not([data-turbo=true]) input[type=submit], form:not([data-turbo=true]) input[type=image], form:not([data-turbo=true]) button[type=submit], form:not([data-turbo=true]) button:not([type]), input[type=submit][form], input[type=image][form], button[type=submit][form], button[form]:not([type])";
  var formDisableSelector = "input[data-disable-with]:enabled, button[data-disable-with]:enabled, textarea[data-disable-with]:enabled, input[data-disable]:enabled, button[data-disable]:enabled, textarea[data-disable]:enabled";
  var formEnableSelector = "input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled, input[data-disable]:disabled, button[data-disable]:disabled, textarea[data-disable]:disabled";
  var fileInputSelector = "input[name][type=file]:not([disabled])";
  var linkDisableSelector = "a[data-disable-with], a[data-disable]";
  var buttonDisableSelector = "button[data-remote][data-disable-with], button[data-remote][data-disable]";
  var nonce = null;
  var loadCSPNonce = () => {
    const metaTag = document.querySelector("meta[name=csp-nonce]");
    return nonce = metaTag && metaTag.content;
  };
  var cspNonce = () => nonce || loadCSPNonce();
  var m = Element.prototype.matches || Element.prototype.matchesSelector || Element.prototype.mozMatchesSelector || Element.prototype.msMatchesSelector || Element.prototype.oMatchesSelector || Element.prototype.webkitMatchesSelector;
  var matches = function(element, selector) {
    if (selector.exclude) {
      return m.call(element, selector.selector) && !m.call(element, selector.exclude);
    } else {
      return m.call(element, selector);
    }
  };
  var EXPANDO = "_ujsData";
  var getData = (element, key) => element[EXPANDO] ? element[EXPANDO][key] : void 0;
  var setData = function(element, key, value) {
    if (!element[EXPANDO]) {
      element[EXPANDO] = {};
    }
    return element[EXPANDO][key] = value;
  };
  var $ = (selector) => Array.prototype.slice.call(document.querySelectorAll(selector));
  var isContentEditable = function(element) {
    var isEditable = false;
    do {
      if (element.isContentEditable) {
        isEditable = true;
        break;
      }
      element = element.parentElement;
    } while (element);
    return isEditable;
  };
  var csrfToken = () => {
    const meta = document.querySelector("meta[name=csrf-token]");
    return meta && meta.content;
  };
  var csrfParam = () => {
    const meta = document.querySelector("meta[name=csrf-param]");
    return meta && meta.content;
  };
  var CSRFProtection = (xhr) => {
    const token = csrfToken();
    if (token) {
      return xhr.setRequestHeader("X-CSRF-Token", token);
    }
  };
  var refreshCSRFTokens = () => {
    const token = csrfToken();
    const param = csrfParam();
    if (token && param) {
      return $('form input[name="' + param + '"]').forEach((input) => input.value = token);
    }
  };
  var AcceptHeaders = {
    "*": "*/*",
    text: "text/plain",
    html: "text/html",
    xml: "application/xml, text/xml",
    json: "application/json, text/javascript",
    script: "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
  };
  var ajax = (options) => {
    options = prepareOptions(options);
    var xhr = createXHR(options, function() {
      const response = processResponse(xhr.response != null ? xhr.response : xhr.responseText, xhr.getResponseHeader("Content-Type"));
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
    if (options.beforeSend && !options.beforeSend(xhr, options)) {
      return false;
    }
    if (xhr.readyState === XMLHttpRequest.OPENED) {
      return xhr.send(options.data);
    }
  };
  var prepareOptions = function(options) {
    options.url = options.url || location.href;
    options.type = options.type.toUpperCase();
    if (options.type === "GET" && options.data) {
      if (options.url.indexOf("?") < 0) {
        options.url += "?" + options.data;
      } else {
        options.url += "&" + options.data;
      }
    }
    if (!(options.dataType in AcceptHeaders)) {
      options.dataType = "*";
    }
    options.accept = AcceptHeaders[options.dataType];
    if (options.dataType !== "*") {
      options.accept += ", */*; q=0.01";
    }
    return options;
  };
  var createXHR = function(options, done) {
    const xhr = new XMLHttpRequest();
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
  var processResponse = function(response, type) {
    if (typeof response === "string" && typeof type === "string") {
      if (type.match(/\bjson\b/)) {
        try {
          response = JSON.parse(response);
        } catch (error) {
        }
      } else if (type.match(/\b(?:java|ecma)script\b/)) {
        const script = document.createElement("script");
        script.setAttribute("nonce", cspNonce());
        script.text = response;
        document.head.appendChild(script).parentNode.removeChild(script);
      } else if (type.match(/\b(xml|html|svg)\b/)) {
        const parser = new DOMParser();
        type = type.replace(/;.+/, "");
        try {
          response = parser.parseFromString(response, type);
        } catch (error1) {
        }
      }
    }
    return response;
  };
  var href = (element) => element.href;
  var isCrossDomain = function(url) {
    const originAnchor = document.createElement("a");
    originAnchor.href = location.href;
    const urlAnchor = document.createElement("a");
    try {
      urlAnchor.href = url;
      return !((!urlAnchor.protocol || urlAnchor.protocol === ":") && !urlAnchor.host || originAnchor.protocol + "//" + originAnchor.host === urlAnchor.protocol + "//" + urlAnchor.host);
    } catch (e2) {
      return true;
    }
  };
  var preventDefault;
  var { CustomEvent: CustomEvent2 } = window;
  if (typeof CustomEvent2 !== "function") {
    CustomEvent2 = function(event, params) {
      const evt = document.createEvent("CustomEvent");
      evt.initCustomEvent(event, params.bubbles, params.cancelable, params.detail);
      return evt;
    };
    CustomEvent2.prototype = window.Event.prototype;
    ({ preventDefault } = CustomEvent2.prototype);
    CustomEvent2.prototype.preventDefault = function() {
      const result = preventDefault.call(this);
      if (this.cancelable && !this.defaultPrevented) {
        Object.defineProperty(this, "defaultPrevented", {
          get() {
            return true;
          }
        });
      }
      return result;
    };
  }
  var fire = (obj, name, data) => {
    const event = new CustomEvent2(name, {
      bubbles: true,
      cancelable: true,
      detail: data
    });
    obj.dispatchEvent(event);
    return !event.defaultPrevented;
  };
  var stopEverything = (e2) => {
    fire(e2.target, "ujs:everythingStopped");
    e2.preventDefault();
    e2.stopPropagation();
    e2.stopImmediatePropagation();
  };
  var delegate = (element, selector, eventType, handler) => element.addEventListener(eventType, function(e2) {
    let { target } = e2;
    while (!!(target instanceof Element) && !matches(target, selector)) {
      target = target.parentNode;
    }
    if (target instanceof Element && handler.call(target, e2) === false) {
      e2.preventDefault();
      e2.stopPropagation();
    }
  });
  var toArray = (e2) => Array.prototype.slice.call(e2);
  var serializeElement = (element, additionalParam) => {
    let inputs = [element];
    if (matches(element, "form")) {
      inputs = toArray(element.elements);
    }
    const params = [];
    inputs.forEach(function(input) {
      if (!input.name || input.disabled) {
        return;
      }
      if (matches(input, "fieldset[disabled] *")) {
        return;
      }
      if (matches(input, "select")) {
        toArray(input.options).forEach(function(option) {
          if (option.selected) {
            params.push({
              name: input.name,
              value: option.value
            });
          }
        });
      } else if (input.checked || ["radio", "checkbox", "submit"].indexOf(input.type) === -1) {
        params.push({
          name: input.name,
          value: input.value
        });
      }
    });
    if (additionalParam) {
      params.push(additionalParam);
    }
    return params.map(function(param) {
      if (param.name) {
        return `${encodeURIComponent(param.name)}=${encodeURIComponent(param.value)}`;
      } else {
        return param;
      }
    }).join("&");
  };
  var formElements = (form, selector) => {
    if (matches(form, "form")) {
      return toArray(form.elements).filter((el) => matches(el, selector));
    } else {
      return toArray(form.querySelectorAll(selector));
    }
  };
  var handleConfirmWithRails = (rails) => function(e2) {
    if (!allowAction(this, rails)) {
      stopEverything(e2);
    }
  };
  var confirm = (message, element) => window.confirm(message);
  var allowAction = function(element, rails) {
    let callback;
    const message = element.getAttribute("data-confirm");
    if (!message) {
      return true;
    }
    let answer = false;
    if (fire(element, "confirm")) {
      try {
        answer = rails.confirm(message, element);
      } catch (error) {
      }
      callback = fire(element, "confirm:complete", [answer]);
    }
    return answer && callback;
  };
  var handleDisabledElement = function(e2) {
    const element = this;
    if (element.disabled) {
      stopEverything(e2);
    }
  };
  var enableElement = (e2) => {
    let element;
    if (e2 instanceof Event) {
      if (isXhrRedirect(e2)) {
        return;
      }
      element = e2.target;
    } else {
      element = e2;
    }
    if (isContentEditable(element)) {
      return;
    }
    if (matches(element, linkDisableSelector)) {
      return enableLinkElement(element);
    } else if (matches(element, buttonDisableSelector) || matches(element, formEnableSelector)) {
      return enableFormElement(element);
    } else if (matches(element, formSubmitSelector)) {
      return enableFormElements(element);
    }
  };
  var disableElement = (e2) => {
    const element = e2 instanceof Event ? e2.target : e2;
    if (isContentEditable(element)) {
      return;
    }
    if (matches(element, linkDisableSelector)) {
      return disableLinkElement(element);
    } else if (matches(element, buttonDisableSelector) || matches(element, formDisableSelector)) {
      return disableFormElement(element);
    } else if (matches(element, formSubmitSelector)) {
      return disableFormElements(element);
    }
  };
  var disableLinkElement = function(element) {
    if (getData(element, "ujs:disabled")) {
      return;
    }
    const replacement = element.getAttribute("data-disable-with");
    if (replacement != null) {
      setData(element, "ujs:enable-with", element.innerHTML);
      element.innerHTML = replacement;
    }
    element.addEventListener("click", stopEverything);
    return setData(element, "ujs:disabled", true);
  };
  var enableLinkElement = function(element) {
    const originalText = getData(element, "ujs:enable-with");
    if (originalText != null) {
      element.innerHTML = originalText;
      setData(element, "ujs:enable-with", null);
    }
    element.removeEventListener("click", stopEverything);
    return setData(element, "ujs:disabled", null);
  };
  var disableFormElements = (form) => formElements(form, formDisableSelector).forEach(disableFormElement);
  var disableFormElement = function(element) {
    if (getData(element, "ujs:disabled")) {
      return;
    }
    const replacement = element.getAttribute("data-disable-with");
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
  var enableFormElements = (form) => formElements(form, formEnableSelector).forEach((element) => enableFormElement(element));
  var enableFormElement = function(element) {
    const originalText = getData(element, "ujs:enable-with");
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
  var isXhrRedirect = function(event) {
    const xhr = event.detail ? event.detail[0] : void 0;
    return xhr && xhr.getResponseHeader("X-Xhr-Redirect");
  };
  var handleMethodWithRails = (rails) => function(e2) {
    const link = this;
    const method = link.getAttribute("data-method");
    if (!method) {
      return;
    }
    if (isContentEditable(this)) {
      return;
    }
    const href2 = rails.href(link);
    const csrfToken$1 = csrfToken();
    const csrfParam$1 = csrfParam();
    const form = document.createElement("form");
    let formContent = `<input name='_method' value='${method}' type='hidden' />`;
    if (csrfParam$1 && csrfToken$1 && !isCrossDomain(href2)) {
      formContent += `<input name='${csrfParam$1}' value='${csrfToken$1}' type='hidden' />`;
    }
    formContent += '<input type="submit" />';
    form.method = "post";
    form.action = href2;
    form.target = link.target;
    form.innerHTML = formContent;
    form.style.display = "none";
    document.body.appendChild(form);
    form.querySelector('[type="submit"]').click();
    stopEverything(e2);
  };
  var isRemote = function(element) {
    const value = element.getAttribute("data-remote");
    return value != null && value !== "false";
  };
  var handleRemoteWithRails = (rails) => function(e2) {
    let data, method, url;
    const element = this;
    if (!isRemote(element)) {
      return true;
    }
    if (!fire(element, "ajax:before")) {
      fire(element, "ajax:stopped");
      return false;
    }
    if (isContentEditable(element)) {
      fire(element, "ajax:stopped");
      return false;
    }
    const withCredentials = element.getAttribute("data-with-credentials");
    const dataType = element.getAttribute("data-type") || "script";
    if (matches(element, formSubmitSelector)) {
      const button = getData(element, "ujs:submit-button");
      method = getData(element, "ujs:submit-button-formmethod") || element.getAttribute("method") || "get";
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
    } else if (matches(element, buttonClickSelector) || matches(element, inputChangeSelector)) {
      method = element.getAttribute("data-method");
      url = element.getAttribute("data-url");
      data = serializeElement(element, element.getAttribute("data-params"));
    } else {
      method = element.getAttribute("data-method");
      url = rails.href(element);
      data = element.getAttribute("data-params");
    }
    ajax({
      type: method || "GET",
      url,
      data,
      dataType,
      beforeSend(xhr, options) {
        if (fire(element, "ajax:beforeSend", [xhr, options])) {
          return fire(element, "ajax:send", [xhr]);
        } else {
          fire(element, "ajax:stopped");
          return false;
        }
      },
      success(...args) {
        return fire(element, "ajax:success", args);
      },
      error(...args) {
        return fire(element, "ajax:error", args);
      },
      complete(...args) {
        return fire(element, "ajax:complete", args);
      },
      crossDomain: isCrossDomain(url),
      withCredentials: withCredentials != null && withCredentials !== "false"
    });
    stopEverything(e2);
  };
  var formSubmitButtonClick = function(e2) {
    const button = this;
    const { form } = button;
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
  var preventInsignificantClick = function(e2) {
    const link = this;
    const method = (link.getAttribute("data-method") || "GET").toUpperCase();
    const data = link.getAttribute("data-params");
    const metaClick = e2.metaKey || e2.ctrlKey;
    const insignificantMetaClick = metaClick && method === "GET" && !data;
    const nonPrimaryMouseClick = e2.button != null && e2.button !== 0;
    if (nonPrimaryMouseClick || insignificantMetaClick) {
      e2.stopImmediatePropagation();
    }
  };
  var Rails = {
    $,
    ajax,
    buttonClickSelector,
    buttonDisableSelector,
    confirm,
    cspNonce,
    csrfToken,
    csrfParam,
    CSRFProtection,
    delegate,
    disableElement,
    enableElement,
    fileInputSelector,
    fire,
    formElements,
    formEnableSelector,
    formDisableSelector,
    formInputClickSelector,
    formSubmitButtonClick,
    formSubmitSelector,
    getData,
    handleDisabledElement,
    href,
    inputChangeSelector,
    isCrossDomain,
    linkClickSelector,
    linkDisableSelector,
    loadCSPNonce,
    matches,
    preventInsignificantClick,
    refreshCSRFTokens,
    serializeElement,
    setData,
    stopEverything
  };
  var handleConfirm = handleConfirmWithRails(Rails);
  Rails.handleConfirm = handleConfirm;
  var handleMethod = handleMethodWithRails(Rails);
  Rails.handleMethod = handleMethod;
  var handleRemote = handleRemoteWithRails(Rails);
  Rails.handleRemote = handleRemote;
  var start = function() {
    if (window._rails_loaded) {
      throw new Error("rails-ujs has already been loaded!");
    }
    window.addEventListener("pageshow", function() {
      $(formEnableSelector).forEach(function(el) {
        if (getData(el, "ujs:disabled")) {
          enableElement(el);
        }
      });
      $(linkDisableSelector).forEach(function(el) {
        if (getData(el, "ujs:disabled")) {
          enableElement(el);
        }
      });
    });
    delegate(document, linkDisableSelector, "ajax:complete", enableElement);
    delegate(document, linkDisableSelector, "ajax:stopped", enableElement);
    delegate(document, buttonDisableSelector, "ajax:complete", enableElement);
    delegate(document, buttonDisableSelector, "ajax:stopped", enableElement);
    delegate(document, linkClickSelector, "click", preventInsignificantClick);
    delegate(document, linkClickSelector, "click", handleDisabledElement);
    delegate(document, linkClickSelector, "click", handleConfirm);
    delegate(document, linkClickSelector, "click", disableElement);
    delegate(document, linkClickSelector, "click", handleRemote);
    delegate(document, linkClickSelector, "click", handleMethod);
    delegate(document, buttonClickSelector, "click", preventInsignificantClick);
    delegate(document, buttonClickSelector, "click", handleDisabledElement);
    delegate(document, buttonClickSelector, "click", handleConfirm);
    delegate(document, buttonClickSelector, "click", disableElement);
    delegate(document, buttonClickSelector, "click", handleRemote);
    delegate(document, inputChangeSelector, "change", handleDisabledElement);
    delegate(document, inputChangeSelector, "change", handleConfirm);
    delegate(document, inputChangeSelector, "change", handleRemote);
    delegate(document, formSubmitSelector, "submit", handleDisabledElement);
    delegate(document, formSubmitSelector, "submit", handleConfirm);
    delegate(document, formSubmitSelector, "submit", handleRemote);
    delegate(document, formSubmitSelector, "submit", (e2) => setTimeout(() => disableElement(e2), 13));
    delegate(document, formSubmitSelector, "ajax:send", disableElement);
    delegate(document, formSubmitSelector, "ajax:complete", enableElement);
    delegate(document, formInputClickSelector, "click", preventInsignificantClick);
    delegate(document, formInputClickSelector, "click", handleDisabledElement);
    delegate(document, formInputClickSelector, "click", handleConfirm);
    delegate(document, formInputClickSelector, "click", formSubmitButtonClick);
    document.addEventListener("DOMContentLoaded", refreshCSRFTokens);
    document.addEventListener("DOMContentLoaded", loadCSPNonce);
    return window._rails_loaded = true;
  };
  Rails.start = start;
  if (typeof jQuery !== "undefined" && jQuery && jQuery.ajax) {
    if (jQuery.rails) {
      throw new Error("If you load both jquery_ujs and rails-ujs, use rails-ujs only.");
    }
    jQuery.rails = Rails;
    jQuery.ajaxPrefilter(function(options, originalOptions, xhr) {
      if (!options.crossDomain) {
        return CSRFProtection(xhr);
      }
    });
  }

  // app/javascript/suggestions.js
  function Input($module) {
    this.$module = $module;
  }
  Input.prototype.init = function() {
    this.$formGroup = this.$module.parentNode;
    var suggestionsSourceId = this.$module.getAttribute("data-suggestions");
    if (suggestionsSourceId) {
      this.suggestions = document.getElementById(suggestionsSourceId);
      this.$formGroup.setAttribute("role", "combobox");
      this.$formGroup.setAttribute("aria-haspopup", "listbox");
      this.$formGroup.setAttribute("aria-expanded", "false");
      this.$suggestionsHeader = document.createElement("h2");
      this.$suggestionsHeader.setAttribute("class", "govuk-input__suggestions-header");
      this.$suggestionsHeader.textContent = this.$module.getAttribute("data-suggestions-header") || "Suggestions";
      this.$suggestionsHeader.hidden = true;
      this.$ul = document.createElement("ul");
      this.$ul.setAttribute("id", this.$module.getAttribute("id") + "-suggestions");
      this.$ul.addEventListener("click", this.handleSuggestionClicked.bind(this));
      this.$ul.addEventListener("keydown", this.handleSuggestionsKeyDown.bind(this));
      this.$ul.hidden = true;
      this.$ul.setAttribute("class", "govuk-input__suggestions-list");
      this.$ul.setAttribute("role", "listbox");
      this.$formGroup.appendChild(this.$suggestionsHeader);
      this.$formGroup.appendChild(this.$ul);
      this.$module.removeAttribute("list");
      this.$module.setAttribute("aria-autocomplete", "list");
      this.$module.setAttribute("aria-controls", this.$module.getAttribute("id") + "-suggestions");
      this.$module.addEventListener("input", this.handleInputInput.bind(this));
      this.$module.addEventListener("keydown", this.handleInputKeyDown.bind(this));
    }
  };
  Input.prototype.handleInputInput = function(event) {
    this.updateSuggestions();
  };
  Input.prototype.updateSuggestions = function() {
    if (this.$module.value.trim().length < 2) {
      this.hideSuggestions();
      return;
    }
    var queryRegexes = this.$module.value.trim().replace(/['’]/g, "").replace(/[.,"/#!$%^&*;:{}=\-_~()]/g, " ").split(/\s+/).map(function(word) {
      return new RegExp("\\b" + word, "i");
    });
    var matchingOptions = [];
    for (var option of this.suggestions.getElementsByTagName("option")) {
      var optionTextAndSynonyms = [option.textContent];
      var synonyms = option.getAttribute("data-synonyms");
      if (synonyms) {
        optionTextAndSynonyms = optionTextAndSynonyms.concat(synonyms.split("|"));
      }
      if (optionTextAndSynonyms.find(function(name) {
        return queryRegexes.filter(function(regex) {
          return name.search(regex) >= 0;
        }).length === queryRegexes.length;
      })) {
        matchingOptions.push(option);
      }
    }
    if (matchingOptions.length === 0) {
      this.displayNoSuggestionsFound();
    } else if (matchingOptions.length === 1 && matchingOptions[0].textContent === this.$module.value.trim()) {
      this.hideSuggestions();
    } else {
      this.updateSuggestionsWithOptions(matchingOptions);
    }
  };
  Input.prototype.updateSuggestionsWithOptions = function(options) {
    this.$ul.textContent = "";
    for (var option of options) {
      var li = document.createElement("li");
      li.textContent = option.textContent;
      li.setAttribute("role", "option");
      li.setAttribute("tabindex", "-1");
      li.setAttribute("data-value", option.value);
      li.setAttribute("class", "govuk-input__suggestion");
      this.$ul.appendChild(li);
    }
    this.$ul.hidden = false;
    this.$suggestionsHeader.hidden = false;
    this.$formGroup.setAttribute("aria-expanded", "true");
  };
  Input.prototype.handleSuggestionClicked = function(event) {
    var suggestionClicked = event.target;
    this.selectSuggestion(suggestionClicked);
  };
  Input.prototype.selectSuggestion = function(option) {
    option.setAttribute("aria-selected", "true");
    this.$module.value = option.dataset.value;
    this.$module.focus();
    this.hideSuggestions();
  };
  Input.prototype.handleInputKeyDown = function(event) {
    switch (event.keyCode) {
      // Down
      case 40:
        if (this.$ul.hidden !== true) {
          if (this.$ul.querySelector('li[role="option"]')) {
            this.moveFocusToOptions();
          }
          event.preventDefault();
        }
        break;
      // Up
      case 38:
        if (this.$ul.hidden !== true) {
          if (this.$ul.querySelector('li[role="option"]')) {
            this.moveFocusToOptions(false);
          }
          event.preventDefault();
        }
        break;
      // Tab
      case 9:
        this.hideSuggestions();
        break;
    }
  };
  Input.prototype.handleSuggestionsKeyDown = function(event) {
    var optionSelected;
    switch (event.keyCode) {
      // Down
      case 40:
        optionSelected = this.$ul.querySelector("li:focus");
        if (optionSelected.nextSibling) {
          optionSelected.nextSibling.focus();
        }
        event.preventDefault();
        break;
      // Up
      case 38:
        optionSelected = this.$ul.querySelector("li:focus");
        if (optionSelected.previousSibling) {
          optionSelected.previousSibling.focus();
        } else {
          this.$module.focus();
        }
        event.preventDefault();
        break;
      // Enter
      case 13:
        optionSelected = this.$ul.querySelector("li:focus");
        this.selectSuggestion(optionSelected);
        event.preventDefault();
        break;
      default:
        this.$module.focus();
    }
  };
  Input.prototype.moveFocusToOptions = function() {
    this.$ul.getElementsByTagName("li")[0].focus();
  };
  Input.prototype.hideSuggestions = function() {
    this.$ul.hidden = true;
    this.$suggestionsHeader.hidden = true;
    this.$formGroup.setAttribute("aria-expanded", "false");
  };
  Input.prototype.displayNoSuggestionsFound = function() {
    this.$ul.hidden = true;
    this.$suggestionsHeader.hidden = true;
    this.$formGroup.setAttribute("aria-expanded", "false");
  };
  var suggestions_default = Input;

  // app/javascript/add-another.js
  var initAddAnother = () => {
    document.querySelectorAll('[data-module="add-another"]').forEach((addAnotherContainer) => {
      addAnotherContainer.querySelector('[data-add-another-role="add"]').addEventListener("click", () => {
        addAnother(addAnotherContainer);
      });
      const sectionList = addAnotherContainer.querySelector('[data-add-another-role="sectionList"]');
      setUpSections(sectionList);
      setUpAddButton(addAnotherContainer);
    });
  };
  var addAnother = (addAnotherContainer) => {
    const newSection = addAnotherContainer.querySelector('[data-add-another-role="template"]').firstChild.cloneNode(true);
    const sections = addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').querySelectorAll('[data-add-another-role="section"]');
    const counter = sections.length;
    addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').append(newSection);
    const newSectionHeader = newSection.querySelector("h2");
    if (newSectionHeader) {
      newSectionHeader.setAttribute("tabindex", "0");
      newSectionHeader.focus();
    }
    setUpSection(newSection, counter, { setUpSuggestions: true });
    setUpAddButton(addAnotherContainer);
  };
  var setUpSection = (section, counter, options) => {
    setUpRemoveButton(section);
    if (options && options.setUpSuggestions) {
      setUpSuggestions(section);
    }
    setNumbering(section, counter);
    setUpRadios(section);
  };
  var setUpRemoveButton = (section) => {
    const removeButton = section.querySelector('[data-add-another-role="remove"]');
    if (!removeButton) {
      return;
    }
    if (removeButton.dataset.removeListenerSet) {
      return;
    }
    removeButton.dataset.removeListenerSet = true;
    removeButton.addEventListener("click", () => {
      remove(section);
    });
  };
  var setUpSuggestions = (section) => {
    section.querySelectorAll('[data-module="govuk-input"]').forEach((input) => {
      new suggestions_default(input).init();
    });
  };
  var remove = (section) => {
    const sectionList = section.closest('[data-add-another-role="sectionList"]');
    showItemRemovedFeedback(section);
    updateErrorMessages(section, sectionList);
    section.remove();
    setUpSections(sectionList);
    setUpAddButton(sectionList.closest('[data-module="add-another"]'));
  };
  var showItemRemovedFeedback = (section) => {
    const topLevelElement = section.closest('[data-module="add-another"]');
    const feedback = document.createElement("div");
    feedback.className = "add-another-removed-feedback";
    feedback.setAttribute("tabindex", "0");
    const text = document.createElement("div");
    text.className = "add-another-removed-feedback-text govuk-body";
    text.innerHTML = topLevelElement.dataset.addAnotherRemovedFeedbackText;
    const button = document.createElement("button");
    button.className = "add-another-removed-feedback-button govuk-body";
    button.innerHTML = topLevelElement.dataset.addAnotherHideMessageText;
    feedback.append(text);
    feedback.append(button);
    section.after(feedback);
    feedback.focus();
    button.addEventListener("click", () => {
      feedback.remove();
    });
  };
  var updateErrorMessages = (sectionToRemove, sectionList) => {
    let reachedSectionToRemove = false;
    sectionList.querySelectorAll('[data-add-another-role="section"]').forEach((currentSection, index) => {
      const currentSectionCurrentPosition = index + 1;
      if (currentSection === sectionToRemove) {
        reachedSectionToRemove = true;
        document.querySelectorAll(`[data-add-another-role="errorMessage"][data-add-another-item-position="${currentSectionCurrentPosition}"]`).forEach((redundantErrorMessage) => {
          redundantErrorMessage.closest("li").remove();
        });
      } else if (reachedSectionToRemove) {
        const newPosition = index;
        document.querySelectorAll(`[data-add-another-role="errorMessage"][data-add-another-item-position="${currentSectionCurrentPosition}"]`).forEach((elementToUpdate) => {
          elementToUpdate.dataset.addAnotherItemPosition = newPosition;
          elementToUpdate.querySelectorAll('[data-add-another-role="errorPosition"]').forEach((positionText) => {
            positionText.innerHTML = newPosition;
          });
          elementToUpdate.closest("a").href = elementToUpdate.closest("a").href.replace(`-${currentSectionCurrentPosition}-`, `-${newPosition}-`);
        });
      }
    });
    document.querySelectorAll(".govuk-error-summary__list").forEach((summaryList) => {
      if (summaryList.childNodes.length === 0) {
        summaryList.closest(".govuk-error-summary").remove();
      }
    });
  };
  var setUpSections = (sectionList) => {
    sectionList.querySelectorAll('[data-add-another-role="section"]').forEach((section, index) => {
      setUpSection(section, index);
    });
  };
  var setNumbering = (section, counter) => {
    const counterElement = section.querySelector('[data-add-another-role="counter"]');
    if (counterElement) {
      counterElement.innerHTML = counter + 1;
    }
    section.querySelectorAll("[data-add-another-dynamic-elements]").forEach((element) => {
      element.dataset.addAnotherDynamicElements.split(",").forEach((pairString) => {
        const parts = pairString.split(":");
        element.setAttribute(parts[0], parts[1].replace("ID", counter + 1));
      });
    });
  };
  var setUpRadios = (section) => {
    if (section.querySelector('input[type="radio"]')) {
      const radios = new Radios(section);
    }
  };
  var setUpAddButton = (addAnotherContainer) => {
    const button = addAnotherContainer.querySelector('[data-add-another-role="add"]');
    if (button.dataset.addAnotherMaximum) {
      const sections = addAnotherContainer.querySelector('[data-add-another-role="sectionList"]').querySelectorAll('[data-add-another-role="section"]');
      if (button.dataset.addAnotherMaximum <= sections.length) {
        button.classList.add("add-another-hidden");
      } else {
        button.classList.remove("add-another-hidden");
      }
    }
  };
  var add_another_default = initAddAnother;

  // app/javascript/feedback.js
  var initFeedback = () => {
    onClickElementWithRole("initial-trigger", () => {
      showSection("message");
      document.querySelector('[data-feedback-role="text-input"]').focus();
    });
    onClickElementWithRole("submit-text", (e2) => {
      const finalMessageElement = document.querySelector('[data-feedback-role="final-message"]');
      if (textBlank()) {
        e2.preventDefault();
        showSection(e2.target.dataset.feedbackSectionIfBlank);
        if (finalMessageElement) {
          finalMessageElement.focus();
        }
        showSectionNotification("blank");
      } else {
        showSection("final");
        finalMessageElement.focus();
      }
    });
    onClickElementWithRole("cancel", () => {
      showSection("initial");
      showSectionNotification("cancel");
    });
    onClickElementWithRole("skip", () => {
      showSection("final");
      document.querySelector('[data-feedback-role="final-message"]').focus();
    });
    document.querySelectorAll('[data-feedback-role="satisfaction-form"]').forEach((element) => {
      element.addEventListener("ajax:success", (e2) => {
        document.querySelectorAll('[data-feedback-role="comment-form"]').forEach((form) => {
          form.action = `/feedbacks/${e2.detail[0].id}`;
        });
      });
    });
  };
  var onClickElementWithRole = (role, callback) => {
    document.querySelectorAll(`[data-feedback-role="${role}"]`).forEach((element) => {
      element.addEventListener("click", callback);
    });
  };
  var textBlank = () => {
    const freetextField = document.querySelector('[data-feedback-role="text-input"]');
    return freetextField.value.replace(/\s+/g, "") === "";
  };
  var showSection = (sectionArea) => {
    ["initial", "message", "final"].forEach((section) => {
      const sectionElement = document.querySelector(`[data-feedback-section="${section}"]`);
      if (sectionElement) {
        sectionElement.hidden = section !== sectionArea;
      }
    });
  };
  var showSectionNotification = (section) => {
    const sectionElement = document.querySelector(`[data-feedback-section="${section}"]`);
    const blankSectionElement = document.querySelector('[data-feedback-section="blank"]');
    const cancelSectionElement = document.querySelector('[data-feedback-section="cancel"]');
    if (sectionElement) {
      if (section === "blank") {
        blankSectionElement.hidden = false;
        cancelSectionElement.hidden = true;
        document.querySelector('[data-feedback-role="blank-message"]').focus();
      } else {
        blankSectionElement.hidden = true;
        cancelSectionElement.hidden = false;
        document.querySelector('[data-feedback-role="cancel-message"]').focus();
      }
    }
  };
  var feedback_default = initFeedback;

  // app/javascript/instant-download.js
  var initInstantDownload = () => {
    document.querySelectorAll('[data-module="instant-download"]').forEach((link) => {
      link.click();
    });
  };
  var instant_download_default = initInstantDownload;

  // app/javascript/application.js
  var sentryDsn = document.querySelector("body").dataset.sentryDsn;
  if (sentryDsn) {
    init({
      dsn: sentryDsn,
      integrations: [browserTracingIntegration(), replayIntegration()],
      // All errors are captured
      sampleRate: 1,
      // All erroring sessions are replayable
      replaysOnErrorSampleRate: 1,
      // No non-erroring sessions are captured for performance monitoring
      tracesSampleRate: 0,
      // No non-erroring sessions are replayable
      replaysSessionSampleRate: 0
    });
  }
  add_another_default();
  document.querySelectorAll('[data-module="govuk-input"]').forEach((input) => {
    new suggestions_default(input).init();
  });
  document.querySelectorAll('a[data-behaviour="browser-back"]').forEach((link) => {
    link.addEventListener("click", (event) => {
      event.preventDefault();
      history.back();
    });
  });
  if (!window._rails_loaded) {
    Rails.start();
  }
  initAll();
  results_default();
  feedback_default();
  instant_download_default();
})();
/*! Bundled license information:

govuk-frontend/dist/govuk/components/accordion/accordion.mjs:
  (**
   * Accordion component
   *
   * This allows a collection of sections to be collapsed by default, showing only
   * their headers. Sections can be expanded or collapsed individually by clicking
   * their headers. A "Show all sections" button is also added to the top of the
   * accordion, which switches to "Hide all sections" when all the sections are
   * expanded.
   *
   * The state of each section is saved to the DOM via the `aria-expanded`
   * attribute, which also provides accessibility.
   *
   * @preserve
   *)

govuk-frontend/dist/govuk/components/button/button.mjs:
  (**
   * JavaScript enhancements for the Button component
   *
   * @preserve
   *)

govuk-frontend/dist/govuk/components/character-count/character-count.mjs:
  (**
   * Character count component
   *
   * Tracks the number of characters or words in the `.govuk-js-character-count`
   * `<textarea>` inside the element. Displays a message with the remaining number
   * of characters/words available, or the number of characters/words in excess.
   *
   * You can configure the message to only appear after a certain percentage
   * of the available characters/words has been entered.
   *
   * @preserve
   *)

govuk-frontend/dist/govuk/components/checkboxes/checkboxes.mjs:
  (**
   * Checkboxes component
   *
   * @preserve
   *)

govuk-frontend/dist/govuk/components/error-summary/error-summary.mjs:
  (**
   * Error summary component
   *
   * Takes focus on initialisation for accessible announcement, unless disabled in
   * configuration.
   *
   * @preserve
   *)

govuk-frontend/dist/govuk/components/exit-this-page/exit-this-page.mjs:
  (**
   * Exit this page component
   *
   * @preserve
   *)

govuk-frontend/dist/govuk/components/header/header.mjs:
  (**
   * Header component
   *
   * @preserve
   *)

govuk-frontend/dist/govuk/components/notification-banner/notification-banner.mjs:
  (**
   * Notification Banner component
   *
   * @preserve
   *)

govuk-frontend/dist/govuk/components/password-input/password-input.mjs:
  (**
   * Password input component
   *
   * @preserve
   *)

govuk-frontend/dist/govuk/components/radios/radios.mjs:
  (**
   * Radios component
   *
   * @preserve
   *)

govuk-frontend/dist/govuk/components/service-navigation/service-navigation.mjs:
  (**
   * Service Navigation component
   *
   * @preserve
   *)

govuk-frontend/dist/govuk/components/skip-link/skip-link.mjs:
  (**
   * Skip link component
   *
   * @preserve
   *)

govuk-frontend/dist/govuk/components/tabs/tabs.mjs:
  (**
   * Tabs component
   *
   * @preserve
   *)
*/
//
