export function computeBottomPosition(root, id) {
  const [...nodes] = root.querySelectorAll('.grille_pain-toast')
  const result = nodes.reduce((acc, node) => {
    if (node.classList.contains('grille_pain-toast-will-hide')) return acc
    const nodeId = parseInt(node.getAttribute('data-id'))
    if (nodeId >= id) return acc
    const dimensions = node.getBoundingClientRect()
    return acc + dimensions.height - 12
  }, 0)
  return result
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
