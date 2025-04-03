## v1.1.3 - 2025-04-03

- Drop `setTimeout` in favour of `requestAnimationFrame` everywhere in the app.
  Algorithm of toast placement have been rewritten, and every toast always have
  their own, correct position at any moment! Toasts are now snappy and
  performant!
- Drop `sketch` & `birl` dependency, to have a more and more lightweight
  grille-pain!

## v1.1.2 - 2025-02-12

- Put back every FFI files at root, to workaround FFI files bugs in Gleam
  v1.8.0.

## v1.1.1 - 2025-02-12

- Add targets everywhere to remove warnings on JavaScript & Erlang.
- Bump Sketch version to 4.0.0.

## v1.1.0 - 2024-07-27

- Add support for sticky toasts! Sticky toasts are a way to display a toast that
  stay on screen until it's hidden by the application. Use it to display a
  loader, or to indicate something specific.

## v1.0.1 - 2024-05-21

- Add `cursor: pointer` in toasts, to indicate that they're clickable.

## v1.0.0 - 2024-05-20

- First release!
