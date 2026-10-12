import { Prisma } from '@prisma/client'
import type { KnowledgeEntry } from './rag-document.types'

export const ragMenuItemSelect = {
  id: true,
  name: true,
  description: true,
  basePrice: true,
  isPopular: true,
  category: { select: { name: true } },
  restaurant: { select: { name: true, cuisineTypes: true, city: true } },
} satisfies Prisma.MenuItemSelect

export const ragRestaurantSelect = {
  id: true,
  name: true,
  description: true,
  cuisineTypes: true,
  priceRange: true,
  rating: true,
  city: true,
  prepTimeAvgMinutes: true,
  addressLine: true,
} satisfies Prisma.RestaurantSelect

type RagMenuItemSource = Prisma.MenuItemGetPayload<{ select: typeof ragMenuItemSelect }>
type RagRestaurantSource = Prisma.RestaurantGetPayload<{ select: typeof ragRestaurantSelect }>

export function mapMenuItemToKnowledgeEntry(item: RagMenuItemSource): KnowledgeEntry {
  return {
    docType: 'menu',
    locale: 'es',
    title: `Plato ${item.name} — ${item.restaurant.name}`,
    content: [
      `Nombre del plato: ${item.name}`,
      item.description ? `Descripción: ${item.description}` : null,
      `Precio: S/ ${Number(item.basePrice).toLocaleString('es-PE')}`,
      `Categoría: ${item.category.name}`,
      `Restaurante: ${item.restaurant.name}`,
      item.restaurant.cuisineTypes.length
        ? `Tipo de cocina: ${item.restaurant.cuisineTypes.join(', ')}`
        : null,
      `Zona: ${item.restaurant.city}`,
      item.isPopular ? 'Este es un plato popular que muchos clientes piden.' : null,
    ].filter(Boolean).join('\n'),
    sourceId: item.id,
  }
}

export function mapRestaurantToKnowledgeEntry(restaurant: RagRestaurantSource): KnowledgeEntry {
  return {
    docType: 'restaurant',
    locale: 'es',
    title: `Restaurante ${restaurant.name}`,
    content: [
      `Nombre: ${restaurant.name}`,
      restaurant.description ? `Descripción: ${restaurant.description}` : null,
      restaurant.cuisineTypes.length ? `Tipo de cocina: ${restaurant.cuisineTypes.join(', ')}` : null,
      `Rango de precios: ${restaurant.priceRange}`,
      `Calificación: ${Number(restaurant.rating).toFixed(1)}/5`,
      `Tiempo promedio de preparación: ${restaurant.prepTimeAvgMinutes} minutos`,
      `Dirección: ${restaurant.addressLine}, ${restaurant.city}`,
    ].filter(Boolean).join('\n'),
    sourceId: restaurant.id,
  }
}
