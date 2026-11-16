import { defineConfig } from 'astro/config';

// GitHub Pages project site: https://username.github.io/repository/
// BASE_PATH may be set in GitHub Actions Variables. Locally defaults to '/'.
const normalized = (value) => {
  if (!value || value === '/') return '/';
  return `/${value.replace(/^\/+|\/+$/g, '')}`;
};
const base = normalized(process.env.BASE_PATH);

export default defineConfig({
  output: 'static',
  site: process.env.SITE_URL || 'https://example.github.io',
  base,
  trailingSlash: 'always',
});
