let storeDispatcher_ = null

export function register(dispatcher) {
  if (storeDispatcher_ !== null)
    throw new Error('You should not instanciate two grille_pain instance')
  storeDispatcher_ = dispatcher
  return dispatcher
}

export function call(callback) {
  if (storeDispatcher_ === null)
    throw new Error('You should instanciate grille_pain')
  return callback(storeDispatcher_)
}
