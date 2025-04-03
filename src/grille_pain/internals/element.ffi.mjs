import * as gleam from '../../gleam.mjs'

export function create(tag) {
  if (typeof document === 'undefined') return new gleam.Error()
  return new gleam.Ok(document.createElement(tag))
}

export function attachShadow(element) {
  if (element.attachShadow === undefined) return new gleam.Error()
  return new gleam.Ok(element.attachShadow({ mode: 'open' }))
}

export function appendChild(root, child) {
  root.appendChild(child)
  return new gleam.Ok(root)
}

export function body() {
  if (typeof document === 'undefined') return new gleam.Error()
  return new gleam.Ok(document.body)
}

export function addStyles(shadowRoot) {
  try {
    if (typeof CSSStyleSheet === 'undefined') return new gleam.Error()
    const stylesheet = new CSSStyleSheet()
    stylesheet.replaceSync(styles)
    shadowRoot.adoptedStyleSheets.push(stylesheet)
    return new gleam.Ok(shadowRoot)
  } catch (error) {
    return new gleam.Error()
  }
}

const styles = `
@keyframes progress_bar {
  from { width: 100%; }
  to { width: 0%; }
}

:host {
  --info: #3498db;
  --success: #07bc0c;
  --warning: #f1c40f;
  --error: #e74c3c;
  --color-transparent: #ffffffb3;
  --light-transparent: #000000b3;
  --dark-transparent: #ffffffb3;
  --dark: #121212;
  --light: #fff;
}

.toast-wrapper {
  padding: 12px;
  position: fixed;
  z-index: 1000000;
}

.toast-wrapper-right {
  transition: right 0.7s;
}

.toast-wrapper-all {
  transition: right 0.7s, top 0.7s;
}

.toast {
  display: flex;
  flex-direction: column;
  width: var(--grille_pain-toast-width, 320px);
  min-height: var(--grille_pain-toast-min-height, 64px);
  max-height: var(--grille_pain-toast-max-height, 800px);
  border-radius: var(--grille_pain-toast-border-radius, 6px);
  box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  cursor: pointer;
}

.toast-content {
  display: flex;
  align-items: center;
  flex: 1;
  padding: 8px 16px;
  font-size: 14px;
}

.progress-bar {
  animation-timing-function: linear;
  animation-delay: 0s;
  animation-name: progress_bar;
  animation-fill-mode: forwards;
  height: 5px;
}
`
