/** Astro BASE_URL ends in '/' by default; remove leading slashes from routes. */
export function sitePath(path = ''): string {
  const base = import.meta.env.BASE_URL;
  return `${base.endsWith('/') ? base : `${base}/`}${path.replace(/^\/+/, '')}`;
}

export const elementSymbols: Record<string, string> = {
  火: '✺', 水: '≋', 雷: 'ϟ', 冰: '❄', 風: '✧', 岩: '◇', 草: '❀',
};
export const elementClass: Record<string, string> = {
  火: 'pyro', 水: 'hydro', 雷: 'electro', 冰: 'cryo', 風: 'anemo', 岩: 'geo', 草: 'dendro',
};
