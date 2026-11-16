import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

const characters = defineCollection({
  loader: glob({ base: './wiki/characters', pattern: '**/*.md' }),
  schema: z.object({
    name: z.string().min(1),
    slug: z.string().regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/),
    rarity: z.union([z.literal(4), z.literal(5)]),
    element: z.enum(['火', '水', '雷', '冰', '風', '岩', '草']),
    weapon: z.enum(['單手劍', '雙手劍', '長柄武器', '法器', '弓']),
    region: z.string().min(1),
    affiliation: z.string().default(''),
    tagline: z.string().min(1),
    summary: z.string().min(1),
    updatedAt: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
    status: z.enum(['draft', 'verified']),
    spoilers: z.boolean().default(false),
    relations: z.array(z.object({
      slug: z.string(),
      label: z.string().min(1),
    })).default([]),
    sources: z.array(z.object({
      title: z.string().min(1),
      url: z.string().url(),
      checkedAt: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
    })).min(1),
  }),
});

export const collections = { characters };
