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

export function addKeyframe(shadowRoot) {
  try {
    if (typeof CSSStyleSheet === 'undefined') return new gleam.Error()
    const stylesheet = new CSSStyleSheet()
    stylesheet.replaceSync(progressBar)
    shadowRoot.adoptedStyleSheets.push(stylesheet)
    return new gleam.Ok(shadowRoot)
  } catch (error) {
    return new gleam.Error()
  }
}

const progressBar = `
@keyframes progress_bar {
  from { width: 100%; }
  to { width: 0%; }
}
`
