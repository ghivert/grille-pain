export function computeBottomPosition(root) {
  const [...nodes] = root.querySelectorAll('.grille_pain-toast')
  return nodes.reduce((acc, node) => {
    if (node.classList.contains('grille_pain-toast-hidden')) return acc
    const dimensions = node.getBoundingClientRect()
    return acc + dimensions.height - 12
  }, 0)
}

export function computeToastSize(id, root) {
  const node = root.querySelectorAll(`.grille_pain-toast-${id}`)
  if (node && node[0]) {
    if (node[0].classList.contains('grille_pain-toast-visible'))
      return node[0].getBoundingClientRect().height - 12
  }
  return 0
}

export function uuid() {
  return crypto.randomUUID()
}
