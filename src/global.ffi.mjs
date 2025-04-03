export function setTimeout(timeout, fn) {
  window.setTimeout(fn, timeout)
}

export function requestAnimationFrame(callback) {
  return window.requestAnimationFrame(() => {
    callback()
  })
}

export function now() {
  return Date.now()
}
