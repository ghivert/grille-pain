export function isDark() {
  const matches = matchMedia('(prefers-color-scheme: dark)')
  return matches.matches
}
