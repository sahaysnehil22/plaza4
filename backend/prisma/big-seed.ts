import { OrderStatus, PaymentMethod, PrismaClient, VehicleType } from '@prisma/client'
import * as bcrypt from 'bcrypt'
import { SeedPriceRange, toDatabasePriceRange } from './seed-database-values'

const prisma = new PrismaClient()

// ─── Lima districts with real coordinates ───
const DISTRICTS = [
  { name: 'Miraflores', lat: -12.1196, lng: -77.0295 },
  { name: 'San Isidro', lat: -12.0931, lng: -77.0465 },
  { name: 'Surco', lat: -12.1392, lng: -76.9934 },
  { name: 'La Molina', lat: -12.0772, lng: -76.9270 },
  { name: 'Barranco', lat: -12.1462, lng: -77.0208 },
  { name: 'Jesús María', lat: -12.0741, lng: -77.0521 },
  { name: 'Lince', lat: -12.0833, lng: -77.0303 },
  { name: 'Pueblo Libre', lat: -12.0772, lng: -77.0627 },
  { name: 'San Miguel', lat: -12.0872, lng: -77.0872 },
  { name: 'Callao', lat: -12.0553, lng: -77.1183 },
  { name: 'Los Olivos', lat: -11.9734, lng: -77.0722 },
  { name: 'Villa El Salvador', lat: -12.2106, lng: -76.9372 },
]

const STREETS = [
  'Av. Larco', 'Av. Arequipa', 'Av. Benavides', 'Av. Pardo', 'Calle Schell',
  'Av. Grau', 'Av. Brasil', 'Av. La Marina', 'Av. Universitaria',
  'Av. Javier Prado', 'Av. Angamos', 'Malecón Cisneros', 'Av. del Ejército',
  'Calle Berlín', 'Av. Tacna', 'Jr. de la Unión',
]

// ─── Peruvian restaurant demo data ───
const RESTAURANT_TEMPLATES = [
  { name: 'Pollería El Buen Sabor', cuisine: ['Peruvian'], price: 'low', prep: 15, slug: 'polleria-el-buen-sabor' },
  { name: 'Cevichería Mar y Tierra', cuisine: ['Peruvian', 'Seafood'], price: 'medium', prep: 20, slug: 'cevicheria-mar-y-tierra' },
  { name: 'Anticuchos Doña Rosa', cuisine: ['Peruvian', 'Street Food'], price: 'low', prep: 10, slug: 'anticuchos-dona-rosa' },
  { name: 'Pizzería La Toscana', cuisine: ['Italian'], price: 'medium', prep: 20, slug: 'pizzeria-la-toscana' },
  { name: 'Sushi Nikkei Lima', cuisine: ['Japanese', 'Peruvian'], price: 'high', prep: 25, slug: 'sushi-nikkei-lima' },
  { name: 'Hamburguesería El Faro', cuisine: ['Fast Food'], price: 'medium', prep: 12, slug: 'hamburgueseria-el-faro' },
  { name: 'Chifa Cantón', cuisine: ['Chinese', 'Peruvian'], price: 'low', prep: 15, slug: 'chifa-canton' },
  { name: 'Parrilla Don Pepe', cuisine: ['Peruvian', 'Grill'], price: 'high', prep: 30, slug: 'parrilla-don-pepe' },
  { name: 'Tacu Tacu La Esquina', cuisine: ['Peruvian'], price: 'low', prep: 12, slug: 'tacu-tacu-la-esquina' },
  { name: 'Lomo Saltado El Wok', cuisine: ['Peruvian', 'Chinese'], price: 'low', prep: 15, slug: 'lomo-saltado-el-wok' },
  { name: 'Causa Limeña Gourmet', cuisine: ['Peruvian'], price: 'medium', prep: 10, slug: 'causa-limena-gourmet' },
  { name: 'Rocoto Relleno Arequipa', cuisine: ['Peruvian'], price: 'medium', prep: 20, slug: 'rocoto-relleno-arequipa' },
  { name: 'Ají de Gallina Casero', cuisine: ['Peruvian'], price: 'low', prep: 12, slug: 'aji-de-gallina-casero' },
  { name: 'Papa a la Huancaína Express', cuisine: ['Peruvian'], price: 'low', prep: 8, slug: 'papa-huancaina-express' },
  { name: 'Seco de Cordero Norteño', cuisine: ['Peruvian'], price: 'medium', prep: 25, slug: 'seco-de-cordero-norteno' },
  { name: 'Arroz con Pollo Criollo', cuisine: ['Peruvian'], price: 'low', prep: 15, slug: 'arroz-con-pollo-criollo' },
  { name: 'Tallarines Verdes Pesto', cuisine: ['Peruvian', 'Italian'], price: 'low', prep: 12, slug: 'tallarines-verdes-pesto' },
  { name: 'Sopa Criolla Caliente', cuisine: ['Peruvian'], price: 'low', prep: 10, slug: 'sopa-criolla-caliente' },
  { name: 'Chicharrón de Cerdo', cuisine: ['Peruvian'], price: 'medium', prep: 18, slug: 'chicharron-de-cerdo' },
  { name: 'Pachamanca Andina', cuisine: ['Peruvian'], price: 'high', prep: 40, slug: 'pachamanca-andina' },
  { name: 'Tiradito Nikkei Fusión', cuisine: ['Peruvian', 'Japanese'], price: 'medium', prep: 15, slug: 'tiradito-nikkei-fusion' },
  { name: 'Jalea Mixta del Puerto', cuisine: ['Peruvian', 'Seafood'], price: 'medium', prep: 20, slug: 'jalea-mixta-del-puerto' },
  { name: 'Arroz Chaufa Oriental', cuisine: ['Chinese', 'Peruvian'], price: 'low', prep: 12, slug: 'arroz-chaufa-oriental' },
  { name: 'Aeropuerto Chifa Fusión', cuisine: ['Chinese', 'Peruvian'], price: 'medium', prep: 15, slug: 'aeropuerto-chifa-fusion' },
  { name: 'Pollo a la Brasa El Carbón', cuisine: ['Peruvian', 'Grill'], price: 'low', prep: 20, slug: 'pollo-a-la-brasa-el-carbon' },
  { name: 'Broaster Crocante', cuisine: ['Fast Food'], price: 'low', prep: 10, slug: 'broaster-crocante' },
  { name: 'Empanadas La Abuela', cuisine: ['Peruvian', 'Street Food'], price: 'low', prep: 8, slug: 'empanadas-la-abuela' },
  { name: 'Tamales Piuranos', cuisine: ['Peruvian'], price: 'low', prep: 10, slug: 'tamales-piuranos' },
  { name: 'Humitas Dulces', cuisine: ['Peruvian', 'Desserts'], price: 'low', prep: 8, slug: 'humitas-dulces' },
  { name: 'Picarones Doña Meche', cuisine: ['Peruvian', 'Desserts'], price: 'low', prep: 8, slug: 'picarones-dona-meche' },
  { name: 'Suspiro Limeño Dulcería', cuisine: ['Peruvian', 'Desserts'], price: 'medium', prep: 10, slug: 'suspiro-limeno-dulceria' },
  { name: 'Mazamorra Morada Bar', cuisine: ['Peruvian', 'Desserts'], price: 'low', prep: 5, slug: 'mazamorra-morada-bar' },
  { name: 'Juguería La Cosecha', cuisine: ['Drinks'], price: 'low', prep: 5, slug: 'jugueria-la-cosecha' },
  { name: 'Café Orgánico Cusco', cuisine: ['Drinks', 'Peruvian'], price: 'low', prep: 5, slug: 'cafe-organico-cusco' },
  { name: 'Emoliente Caliente', cuisine: ['Drinks', 'Peruvian'], price: 'low', prep: 5, slug: 'emoliente-caliente' },
  { name: 'Chicha Morada El Jarro', cuisine: ['Drinks'], price: 'low', prep: 5, slug: 'chicha-morada-el-jarro' },
  { name: 'Pizza Artesanal Napoli', cuisine: ['Italian'], price: 'high', prep: 20, slug: 'pizza-artesanal-napoli' },
  { name: 'Trattoria Bella Vista', cuisine: ['Italian'], price: 'medium', prep: 18, slug: 'trattoria-bella-vista' },
  { name: 'Ramen Fusión Lima', cuisine: ['Japanese'], price: 'medium', prep: 12, slug: 'ramen-fusion-lima' },
  { name: 'Makis Acevichados', cuisine: ['Japanese', 'Peruvian'], price: 'medium', prep: 15, slug: 'makis-acevichados' },
  { name: 'Sanguchería El Encuentro', cuisine: ['Fast Food', 'Peruvian'], price: 'low', prep: 8, slug: 'sangucheria-el-encuentro' },
  { name: 'Salchipapa El Trome', cuisine: ['Fast Food'], price: 'low', prep: 10, slug: 'salchipapa-el-trome' },
  { name: 'Tacos al Pastor CDMX', cuisine: ['Mexican'], price: 'medium', prep: 12, slug: 'tacos-al-pastor-cdmx' },
  { name: 'Heladería Artesanal Fresa', cuisine: ['Desserts'], price: 'low', prep: 5, slug: 'heladeria-artesanal-fresa' },
]

// ─── Menu data by restaurant type ───
type SeedMenuTemplate = {
  cat: string
  items: Array<{ name: string; price: number }>
}

const MENU_DATA: Record<string, SeedMenuTemplate> = {
  polleria: {
    cat: 'Pollería', items: [
      { name: 'Pollo a la brasa entero', price: 55 }, { name: 'Medio pollo a la brasa', price: 32 },
      { name: 'Cuarto de pollo + papas', price: 18 }, { name: 'Alitas BBQ x8', price: 22 },
      { name: 'Papas fritas familiares', price: 12 }, { name: 'Ensalada fresca', price: 10 },
    ]
  },
  cevicheria: {
    cat: 'Cevichería', items: [
      { name: 'Ceviche clásico', price: 28 }, { name: 'Ceviche mixto', price: 32 },
      { name: 'Tiradito de pescado', price: 26 }, { name: 'Jalea mixta', price: 30 },
      { name: 'Arroz con mariscos', price: 34 }, { name: 'Leche de tigre', price: 12 },
    ]
  },
  criolla: {
    cat: 'Criolla', items: [
      { name: 'Anticuchos x3', price: 12 }, { name: 'Rachi frito', price: 10 },
      { name: 'Mollejitas al palo', price: 12 }, { name: 'Choclo con queso', price: 8 },
      { name: 'Papa rellena', price: 9 },
    ]
  },
  pizzeria: {
    cat: 'Pizzería', items: [
      { name: 'Pizza margarita', price: 32 }, { name: 'Pizza pepperoni', price: 38 },
      { name: 'Pizza hawaiana', price: 36 }, { name: 'Pizza cuatro quesos', price: 42 },
      { name: 'Pizza napolitana', price: 34 },
    ]
  },
  nikkei: {
    cat: 'Nikkei', items: [
      { name: 'Maki acevichado x10', price: 32 }, { name: 'Nigiri mixto x6', price: 28 },
      { name: 'Tiradito nikkei', price: 26 }, { name: 'Yakimeshi de pollo', price: 24 },
      { name: 'Gohan especial', price: 22 },
    ]
  },
  hamburgueseria: {
    cat: 'Hamburguesas', items: [
      { name: 'Clásica de la casa', price: 18 }, { name: 'Doble queso', price: 24 },
      { name: 'BBQ tocino', price: 22 }, { name: 'Papas fritas', price: 10 },
      { name: 'Nuggets x10', price: 12 },
    ]
  },
  chifa: {
    cat: 'Chifa', items: [
      { name: 'Arroz chaufa de pollo', price: 16 }, { name: 'Tallarín saltado', price: 18 },
      { name: 'Pollo tipakay', price: 22 }, { name: 'Wantán frito x8', price: 12 },
      { name: 'Sopa wantán', price: 10 },
    ]
  },
  parrilla: {
    cat: 'Parrilla', items: [
      { name: 'Parrillada personal', price: 45 }, { name: 'Lomo fino 300g', price: 55 },
      { name: 'Bife de chorizo', price: 48 }, { name: 'Anticucho premium', price: 25 },
    ]
  },
  criolla_casera: {
    cat: 'Criolla', items: [
      { name: 'Lomo saltado', price: 24 }, { name: 'Ají de gallina', price: 20 },
      { name: 'Seco de cordero', price: 26 }, { name: 'Arroz con pollo', price: 18 },
      { name: 'Causa limeña', price: 14 }, { name: 'Tacu tacu con lomo', price: 26 },
    ]
  },
  postres: {
    cat: 'Postres', items: [
      { name: 'Picarones x4', price: 8 }, { name: 'Suspiro limeño', price: 12 },
      { name: 'Mazamorra morada', price: 7 }, { name: 'Helado artesanal', price: 10 },
      { name: 'Torta de chocolate', price: 14 },
    ]
  },
  bebidas: {
    cat: 'Bebidas', items: [
      { name: 'Chicha morada 1L', price: 10 }, { name: 'Inca Kola 1.5L', price: 9 },
      { name: 'Limonada frozen', price: 8 }, { name: 'Jugo surtido', price: 9 },
      { name: 'Café pasado', price: 5 }, { name: 'Emoliente caliente', price: 6 },
    ]
  },
  sangucheria: {
    cat: 'Sanguchería', items: [
      { name: 'Butifarra', price: 12 }, { name: 'Chicharrón', price: 14 },
      { name: 'Pollo deshilachado', price: 12 }, { name: 'Triple play', price: 10 },
    ]
  },
}

const CATEGORY_MAP: Record<string, string[]> = {
  polleria: ['Pollería', 'Bebidas'],
  cevicheria: ['Cevichería', 'Bebidas'],
  criolla: ['Criolla', 'Bebidas'],
  pizzeria: ['Pizzería', 'Bebidas'],
  nikkei: ['Nikkei', 'Bebidas'],
  hamburgueseria: ['Hamburguesas', 'Bebidas'],
  chifa: ['Chifa', 'Bebidas'],
  parrilla: ['Parrilla', 'Bebidas'],
  criolla_casera: ['Criolla', 'Bebidas'],
  postres: ['Postres', 'Bebidas'],
  bebidas: ['Bebidas', 'Postres'],
  sangucheria: ['Sanguchería', 'Bebidas'],
}
// ─── Driver Peruvian names ───
const DRIVER_LAST_NAMES = ['Pérez', 'Torres', 'Quispe', 'Huamán', 'Fernández', 'García', 'Rojas', 'Mendoza', 'Aguilar', 'Castillo', 'Vargas', 'Ramos', 'Flores', 'Gutiérrez', 'Chávez', 'Paredes']
const DRIVER_MIDDLE_NAMES = ['del', 'de la', 'San', 'Santa', 'del Valle']
const DRIVER_FIRST_NAMES = ['Juan', 'María', 'Carlos', 'Rosa', 'Luis', 'Ana', 'Pedro', 'Carmen', 'Jorge', 'Lucía', 'Miguel', 'Elena', 'Diego', 'Sofía', 'Andrés', 'Valeria', 'Raúl', 'Daniela', 'Oscar', 'Paola']

let seedState = 0x5f3759df

function seededRandom(): number {
  seedState = (seedState * 1664525 + 1013904223) >>> 0
  return seedState / 0x100000000
}

function chance(probability: number): boolean {
  return seededRandom() < probability
}

function rand(min: number, max: number): number { return min + seededRandom() * (max - min) }
function randInt(min: number, max: number): number { return Math.floor(rand(min, max + 1)) }
function pick<T>(arr: T[]): T { return arr[Math.floor(seededRandom() * arr.length)] }
function jitter(base: number, pct: number): number { return base * (1 + (seededRandom() - 0.5) * 2 * pct / 100) }

type CanonicalAiOrder = {
  orderCode: string
  status: OrderStatus
  total: number
  driverId?: string
  createdMinutesAgo: number
  note: string
}

const ACTIVE_DRIVER_ORDER_STATUSES = new Set<OrderStatus>([
  OrderStatus.driver_assigned,
  OrderStatus.driver_arriving_restaurant,
  OrderStatus.picked_up,
  OrderStatus.delivering,
])

async function upsertCanonicalAiSmokeOrders(
  restaurantIds: string[],
  driverIds: string[],
): Promise<number> {
  const customer = await prisma.user.findUnique({
    where: { email: 'customer1@plaza4.pe' },
    select: { id: true },
  })
  const restaurantId = restaurantIds[0]
  const smokeDriverIds = driverIds.slice(0, 6)
  if (!customer || !restaurantId || smokeDriverIds.length !== 6 || new Set(smokeDriverIds).size !== 6) {
    throw new Error('Canonical AI smoke seed requires customer1, one restaurant, and six distinct drivers')
  }

  const address = await prisma.address.findFirst({
    where: { userId: customer.id },
    select: { id: true },
  })
  const menuItem = await prisma.menuItem.findFirst({
    where: { restaurantId, isAvailable: true },
    orderBy: { createdAt: 'asc' },
    select: { id: true, name: true, basePrice: true },
  })
  if (!address || !menuItem) {
    throw new Error('Canonical AI smoke seed requires one customer address and one menu item')
  }

  const orders: CanonicalAiOrder[] = [
    { orderCode: 'FF-001', status: OrderStatus.delivering, total: 85_000, driverId: smokeDriverIds[0], createdMinutesAgo: 24, note: 'AI smoke: status happy path' },
    { orderCode: 'FF-002', status: OrderStatus.delivering, total: 120_000, driverId: smokeDriverIds[1], createdMinutesAgo: 75, note: 'AI smoke: delayed angry escalation' },
    { orderCode: 'FF-003', status: OrderStatus.completed, total: 92_000, driverId: smokeDriverIds[2], createdMinutesAgo: 5, note: 'AI smoke: short delay refund ineligible' },
    { orderCode: 'FF-004', status: OrderStatus.delivering, total: 68_000, driverId: smokeDriverIds[3], createdMinutesAgo: 18, note: 'AI smoke: multi-turn retention' },
    { orderCode: 'FF-006', status: OrderStatus.preparing, total: 50_000, createdMinutesAgo: 12, note: 'AI smoke: eligible partial refund grounding' },
    { orderCode: 'FF-007', status: OrderStatus.delivering, total: 110_000, driverId: smokeDriverIds[4], createdMinutesAgo: 45, note: 'AI smoke: driver unreachable escalation' },
    { orderCode: 'FF-008', status: OrderStatus.preparing, total: 73_000, createdMinutesAgo: 8, note: 'AI smoke: cancellation safety' },
    { orderCode: 'FF-009', status: OrderStatus.delivering, total: 77_000, driverId: smokeDriverIds[5], createdMinutesAgo: 16, note: 'AI smoke: English language match' },
    { orderCode: 'FF-010', status: OrderStatus.preparing, total: 64_000, createdMinutesAgo: 6, note: 'AI smoke: allergy support priority' },
  ]

  const activeDriverIds = orders
    .filter(order => ACTIVE_DRIVER_ORDER_STATUSES.has(order.status))
    .map(order => order.driverId)
  if (activeDriverIds.some(driverId => !driverId) || new Set(activeDriverIds).size !== activeDriverIds.length) {
    throw new Error('Canonical AI smoke seed must assign one distinct driver to each active order')
  }

  for (const canonical of orders) {
    const createdAt = new Date(Date.now() - canonical.createdMinutesAgo * 60_000)
    const deliveryFee = 10_000
    const subtotal = canonical.total - deliveryFee
    const itemQuantity = Math.max(1, Math.round(subtotal / Number(menuItem.basePrice)))
    const existing = await prisma.order.findUnique({
      where: { orderCode: canonical.orderCode },
      select: { id: true },
    })

    if (existing) {
      await prisma.orderItem.deleteMany({ where: { orderId: existing.id } })
      await prisma.order.update({
        where: { id: existing.id },
        data: {
          customerId: customer.id,
          restaurantId,
          driverId: canonical.driverId ?? null,
          deliveryAddressId: address.id,
          status: canonical.status,
          subtotal,
          deliveryFee,
          promotionDiscount: 0,
          total: canonical.total,
          paymentMethod: PaymentMethod.cash,
          notes: canonical.note,
          estimatedPrepTimeMinutes: 15,
          estimatedDeliveryTimeMinutes: 30,
          createdAt,
          updatedAt: createdAt,
          orderItems: {
            create: [{
              menuItemId: menuItem.id,
              nameSnapshot: menuItem.name,
              quantity: itemQuantity,
              unitPrice: menuItem.basePrice,
              selectedOptions: [],
            }],
          },
        },
      })
    } else {
      await prisma.order.create({
        data: {
          orderCode: canonical.orderCode,
          customerId: customer.id,
          restaurantId,
          driverId: canonical.driverId ?? null,
          deliveryAddressId: address.id,
          status: canonical.status,
          subtotal,
          deliveryFee,
          promotionDiscount: 0,
          total: canonical.total,
          paymentMethod: PaymentMethod.cash,
          notes: canonical.note,
          estimatedPrepTimeMinutes: 15,
          estimatedDeliveryTimeMinutes: 30,
          createdAt,
          updatedAt: createdAt,
          orderItems: {
            create: [{
              menuItemId: menuItem.id,
              nameSnapshot: menuItem.name,
              quantity: itemQuantity,
              unitPrice: menuItem.basePrice,
              selectedOptions: [],
            }],
          },
        },
      })
    }
  }

  const driverOrder = await prisma.order.findUnique({
    where: { orderCode: 'FF-007' },
    select: { id: true, driverId: true },
  })
  if (driverOrder?.driverId) {
    await prisma.$executeRawUnsafe(
      'DELETE FROM driver_location_history WHERE driver_id = $1::uuid AND order_id = $2::uuid',
      driverOrder.driverId,
      driverOrder.id,
    )
    await prisma.$executeRawUnsafe(
      `INSERT INTO driver_location_history (driver_id, order_id, location, recorded_at)
       VALUES ($1::uuid, $2::uuid, ST_SetSRID(ST_MakePoint($3, $4), 4326)::geography, NOW())`,
      driverOrder.driverId,
      driverOrder.id,
      106.7004,
      10.7757,
    )
  }

  return orders.length
}

async function main() {
  if (process.env.NODE_ENV === 'production') {
    throw new Error(
      'Refusing to run prisma/big-seed.ts in production because it creates demo identities and synthetic business data. Use a reviewed production data import/bootstrap instead.',
    )
  }

  console.log('🌱 Plaza 4 BIG SEED — generating rich data...\n')

  // ─── 1. Admin ───
  const adminHash = await bcrypt.hash('Admin@123', 12)
  await prisma.user.upsert({
    where: { email: 'admin@plaza4.pe' },
    update: {}, create: { email: 'admin@plaza4.pe', passwordHash: adminHash, fullName: 'Plaza 4 Admin', role: 'admin', phone: '990000000', isActive: true },
  })
  console.log('✅ Admin created')

  // ─── 2. Restaurants (50+) ───
  const restaurantIds: string[] = []
  const restaurantLocations: Array<{ id: string; lat: number; lng: number; name: string; prep: number }> = []

  for (let i = 0; i < RESTAURANT_TEMPLATES.length; i++) {
    const t = RESTAURANT_TEMPLATES[i]
    const district = pick(DISTRICTS)
    const lat = jitter(district.lat, 2)
    const lng = jitter(district.lng, 2)
    const streetNum = randInt(1, 500)
    const street = pick(STREETS)
    const slug = `${t.slug}-${i}`

    // Create owner
    const ownerHash = await bcrypt.hash('Partner@123', 12)
    const ownerEmail = `restaurant${i + 1}@plaza4.pe`
    const owner = await prisma.user.upsert({
      where: { email: ownerEmail },
      update: {},
      create: { email: ownerEmail, passwordHash: ownerHash, fullName: `Gerente ${t.name}`, role: 'restaurant', phone: `9${String(10000000 + i).slice(-8)}`, isActive: true },
    })

    // Create restaurant with PostGIS point
    await prisma.$executeRawUnsafe(
      `INSERT INTO restaurants (id, name, slug, description, logo_url, cover_url, location, address_line, city, district, phone, cuisine_types, price_range, rating, total_reviews, is_open, is_active, prep_time_avg_minutes, min_order_amount, created_at)
       VALUES (gen_random_uuid(), $1, $2, $3, $4, $5, ST_SetSRID(ST_MakePoint($6, $7), 4326), $8, 'Lima', $9, $10, $11::text[], $12::"PriceRange", $13, $14, true, true, $15, $16, NOW())
       ON CONFLICT (slug) DO UPDATE SET
         name = EXCLUDED.name,
         description = EXCLUDED.description,
         logo_url = EXCLUDED.logo_url,
         cover_url = EXCLUDED.cover_url,
         location = EXCLUDED.location,
         address_line = EXCLUDED.address_line,
         city = EXCLUDED.city,
         district = EXCLUDED.district,
         phone = EXCLUDED.phone,
         cuisine_types = EXCLUDED.cuisine_types,
         price_range = EXCLUDED.price_range,
         rating = EXCLUDED.rating,
         total_reviews = EXCLUDED.total_reviews,
         is_open = EXCLUDED.is_open,
         is_active = EXCLUDED.is_active,
         prep_time_avg_minutes = EXCLUDED.prep_time_avg_minutes,
         min_order_amount = EXCLUDED.min_order_amount`,
      t.name, slug, `${t.name} - Sabor peruano todos los días en ${district.name}`,
      `https://picsum.photos/seed/${slug}/200/200`, `https://picsum.photos/seed/${slug}-cover/800/400`,
      lng, lat,
      `${streetNum} ${street}, ${district.name}`,
      district.name,
      `9${String(10000000 + i).slice(-8)}`,
      `{${t.cuisine.join(',')}}`,
      toDatabasePriceRange(t.price as SeedPriceRange),
      jitter(4.0, 20), randInt(10, 500),
      t.prep, randInt(0, 3) * 10,
    )

    // Public restaurant routes and the dynamic RAG index intentionally include
    // only approved partners. Make the repeatable E2E fixture represent a live
    // marketplace, including rows inserted before approvalStatus was added.
    await prisma.restaurant.update({
      where: { slug },
      data: { approvalStatus: 'approved' },
    })

    const restaurant = await prisma.restaurant.findUnique({ where: { slug } })
    if (!restaurant) { console.log(`  ⚠️ Restaurant ${slug} not found`); continue }
    restaurantIds.push(restaurant.id)
    restaurantLocations.push({ id: restaurant.id, lat, lng, name: t.name, prep: t.prep })

    // Create restaurant profile
    await prisma.restaurantProfile.upsert({
      where: { userId: owner.id }, update: {},
      create: { userId: owner.id, restaurantId: restaurant.id },
    })

    // Opening hours (6AM-10PM, some close earlier on Sunday)
    const openingHoursCount = await prisma.restaurantOpeningHour.count({ where: { restaurantId: restaurant.id } })
    if (openingHoursCount === 0) {
      for (let day = 0; day < 7; day++) {
        const isSunday = day === 0
        await prisma.restaurantOpeningHour.create({
          data: { restaurantId: restaurant.id, dayOfWeek: day, openTime: '06:00', closeTime: isSunday ? '21:00' : '22:00' },
        })
      }
    }

    // Menu items
    const existingMenuItems = await prisma.menuItem.count({ where: { restaurantId: restaurant.id } })
    if (existingMenuItems === 0) {
      const cuisineType = t.cuisine[0]
      let menuType = 'criolla_casera'
      if (t.slug.includes('polleria') || t.slug.includes('broaster') || t.slug.includes('pollo-a-la-brasa')) menuType = 'polleria'
      else if (t.slug.includes('cevicheria') || t.slug.includes('jalea') || t.slug.includes('tiradito')) menuType = 'cevicheria'
      else if (t.slug.includes('anticucho') || t.slug.includes('sangucheria') || t.slug.includes('tacu') || t.slug.includes('empanada') || t.slug.includes('tamal')) menuType = 'criolla'
      else if (t.slug.includes('pizzeria') || t.slug.includes('trattoria')) menuType = 'pizzeria'
      else if (t.slug.includes('sushi') || t.slug.includes('nikkei') || t.slug.includes('maki') || t.slug.includes('ramen')) menuType = 'nikkei'
      else if (t.slug.includes('hamburgueseria') || t.slug.includes('salchipapa')) menuType = 'hamburgueseria'
      else if (t.slug.includes('chifa') || t.slug.includes('chaufa') || t.slug.includes('wok') || t.slug.includes('tallarin')) menuType = 'chifa'
      else if (t.slug.includes('parrilla')) menuType = 'parrilla'
      else if (t.slug.includes('picarones') || t.slug.includes('suspiro') || t.slug.includes('mazamorra') || t.slug.includes('heladeria') || t.slug.includes('humitas')) menuType = 'postres'
      else if (t.slug.includes('jugueria') || t.slug.includes('cafe') || t.slug.includes('emoliente') || t.slug.includes('chicha')) menuType = 'bebidas'

      const menuTemplate = MENU_DATA[menuType] ?? MENU_DATA.criolla_casera
      const cats = CATEGORY_MAP[menuType] ?? ['Plato principal', 'Bebidas']

      for (let ci = 0; ci < cats.length; ci++) {
        const category = await prisma.category.create({
          data: { restaurantId: restaurant.id, name: cats[ci], sortOrder: ci },
        })

        const itemsForCat = ci === 0 ? menuTemplate.items : (MENU_DATA.drinks?.items ?? [])
        for (const item of itemsForCat.slice(0, ci === 0 ? randInt(3, 7) : randInt(1, 3))) {
          await prisma.menuItem.create({
            data: {
              restaurantId: restaurant.id, categoryId: category.id,
              name: item.name, basePrice: jitter(item.price, 15),
              description: `${item.name} thơm ngon, nguyên liệu tươi sống`,
              imageUrl: `https://picsum.photos/seed/${slug}-${item.name.toLowerCase().replace(/\s/g, '-')}/400/400`,
              isPopular: chance(0.4),
            },
          })
        }
      }
    }
  }
  console.log(`✅ ${RESTAURANT_TEMPLATES.length} restaurants with menus created`)

  // ─── 3. Drivers (50+) ───
  const driverIds: string[] = []
  for (let i = 0; i < 50; i++) {
    const lastName = pick(DRIVER_LAST_NAMES)
    const middleName = pick(DRIVER_MIDDLE_NAMES)
    const firstName = pick(DRIVER_FIRST_NAMES)
    const fullName = `${lastName} ${middleName} ${firstName}`
    const driverHash = await bcrypt.hash('Driver@123', 12)
    const email = `driver${i + 1}@plaza4.pe`

    const driver = await prisma.user.upsert({
      where: { email }, update: {},
      create: { email, passwordHash: driverHash, fullName, role: 'driver', phone: `9${String(20000000 + i).slice(-8)}`, isActive: true },
    })

    const dist = pick(DISTRICTS)
    const profileData = {
      licenseNumber: `LIC-${String(100000 + i)}`,
      vehicleType: chance(0.9) ? VehicleType.motorbike : VehicleType.car,
      vehiclePlate: `${String.fromCharCode(65 + randInt(0, 25))}${String.fromCharCode(65 + randInt(0, 25))}${String.fromCharCode(65 + randInt(0, 25))}-${String(100 + i).slice(-3)}`,
      isVerified: i < 10 || chance(0.85),
      rating: jitter(4.2, 20),
      totalDeliveries: randInt(20, 2000),
      totalEarnings: randInt(2000, 80000),
      currentLat: jitter(dist.lat, 3),
      currentLng: jitter(dist.lng, 3),
    }
    await prisma.driverProfile.upsert({
      where: { userId: driver.id },
      update: profileData,
      create: { userId: driver.id, ...profileData },
    })
    driverIds.push(driver.id)
  }
  console.log(`✅ 50 drivers created`)

  // ─── 4. Customers (100+) ───
  const customerIds: string[] = []
  for (let i = 0; i < 100; i++) {
    const lastName = pick(DRIVER_LAST_NAMES)
    const firstName = pick(DRIVER_FIRST_NAMES)
    const fullName = `${lastName} ${firstName}`
    const customerHash = await bcrypt.hash('Customer@123', 12)
    const email = `customer${i + 1}@plaza4.pe`

    const customer = await prisma.user.upsert({
      where: { email }, update: {},
      create: { email, passwordHash: customerHash, fullName, role: 'customer', phone: `9${String(30000000 + i).slice(-8)}`, isActive: true },
    })

    await prisma.customerProfile.upsert({
      where: { userId: customer.id }, update: {},
      create: { userId: customer.id, totalOrders: randInt(0, 100) },
    })

    // 1-3 addresses per customer
    const existingAddresses = await prisma.address.count({ where: { userId: customer.id } })
    if (existingAddresses === 0) {
    const numAddresses = randInt(1, 3)
    for (let a = 0; a < numAddresses; a++) {
      const dist = pick(DISTRICTS)
      const addrLat = jitter(dist.lat, 3)
      const addrLng = jitter(dist.lng, 3)
      const labels = ['Casa', 'Oficina', 'Casa de un amigo']
      await prisma.$executeRawUnsafe(
        `INSERT INTO addresses (id, user_id, label, address_line, location, is_default, created_at)
         VALUES (gen_random_uuid(), $1::uuid, $2, $3, ST_SetSRID(ST_MakePoint($4, $5), 4326), $6, NOW())`,
        customer.id, a < labels.length ? labels[a] : `Dirección ${a + 1}`,
        `${randInt(1, 500)} ${pick(STREETS)}, ${dist.name}`,
        addrLng, addrLat, a === 0,
      )
    }
    }
    customerIds.push(customer.id)
  }
  console.log(`✅ 100 customers with addresses created`)

  // ─── 5. Promotions ───
  const promos = [
    { code: 'WELCOME20', type: 'percentage', value: 20, minOrder: 30, maxDiscount: 20, limit: 1000 },
    { code: 'WELCOME30', type: 'percentage', value: 30, minOrder: 50, maxDiscount: 25, limit: 500 },
    { code: 'FREESHIP', type: 'fixed', value: 6, minOrder: 40, maxDiscount: 6, limit: 1000 },
    { code: 'SUMMER50', type: 'percentage', value: 50, minOrder: 80, maxDiscount: 40, limit: 200 },
    { code: 'NEWYEAR25', type: 'percentage', value: 25, minOrder: 60, maxDiscount: 30, limit: 300 },
    { code: 'LUNCH10', type: 'fixed', value: 5, minOrder: 25, maxDiscount: 5, limit: 2000 },
    { code: 'DINNER20', type: 'percentage', value: 20, minOrder: 80, maxDiscount: 25, limit: 500 },
    { code: 'DRINKFREE', type: 'fixed', value: 6, minOrder: 35, maxDiscount: 6, limit: 800 },
    { code: 'RAIN50', type: 'percentage', value: 50, minOrder: 25, maxDiscount: 18, limit: 100 },
    { code: 'BIGORDER', type: 'percentage', value: 15, minOrder: 120, maxDiscount: 40, limit: 300 },
  ]
  for (const p of promos) {
    await prisma.$executeRawUnsafe(
      `INSERT INTO promotions (id, code, type, value, min_order_amount, max_discount, usage_limit, usage_count, starts_at, expires_at, is_active)
       VALUES (gen_random_uuid(), $1, $2::"PromotionType", $3, $4, $5, $6, $7, $8, $9, $10)
       ON CONFLICT (code) DO UPDATE SET
         type = EXCLUDED.type,
         value = EXCLUDED.value,
         min_order_amount = EXCLUDED.min_order_amount,
         max_discount = EXCLUDED.max_discount,
         usage_limit = EXCLUDED.usage_limit,
         usage_count = EXCLUDED.usage_count,
         starts_at = EXCLUDED.starts_at,
         expires_at = EXCLUDED.expires_at,
         is_active = EXCLUDED.is_active`,
      p.code, p.type, p.value, p.minOrder, p.maxDiscount, p.limit, chance(0.7) ? randInt(0, p.limit) : 0,
      new Date('2026-01-01'), new Date('2026-12-31'), chance(0.8),
    )
  }
  console.log(`✅ ${promos.length} promotions created`)

  // ─── 6. Historical Orders (500+) ───
  const HISTORICAL_ORDER_STATUSES: OrderStatus[] = [
    OrderStatus.completed,
    OrderStatus.completed,
    OrderStatus.completed,
    OrderStatus.completed,
    OrderStatus.completed,
    OrderStatus.cancelled,
    OrderStatus.completed,
    OrderStatus.completed,
    OrderStatus.completed,
    OrderStatus.cancelled,
  ]
  let ordersCreated = 0

  for (let i = 0; i < 500; i++) {
    const customerId = pick(customerIds)
    const restaurant = pick(restaurantLocations)
    const driverId = pick(driverIds)
    const status = pick(HISTORICAL_ORDER_STATUSES)

    // Get a random address for this customer
    const address = await prisma.address.findFirst({
      where: { userId: customerId },
      select: { id: true },
    })
    if (!address) continue

    // Get menu items for this restaurant
    const items = await prisma.menuItem.findMany({
      where: { restaurantId: restaurant.id, isAvailable: true },
      take: randInt(1, 4),
    })
    if (items.length === 0) continue

    const orderCode = `FD${String(i + 1).padStart(10, '0')}`
    const existingOrder = await prisma.order.findUnique({
      where: { orderCode },
      select: { id: true, status: true },
    })
    if (existingOrder) {
      if (ACTIVE_DRIVER_ORDER_STATUSES.has(existingOrder.status)) {
        await prisma.order.update({
          where: { id: existingOrder.id },
          data: { status: OrderStatus.completed },
        })
      }
      continue
    }

    const selectedItems = items.map(item => ({ item, quantity: randInt(1, 3) }))
    const subtotal = selectedItems.reduce(
      (sum, { item, quantity }) => sum + Number(item.basePrice) * quantity,
      0,
    )
    const deliveryFee = randInt(4, 10)
    const promotionDiscount = chance(0.3) ? randInt(3, 15) : 0
    const total = subtotal + deliveryFee - promotionDiscount
    const daysAgo = randInt(0, 60)
    const createdAt = new Date(Date.now() - daysAgo * 86400000 - randInt(0, 86400000))

    await prisma.order.create({
      data: {
        orderCode,
        customerId,
        restaurantId: restaurant.id,
        driverId,
        deliveryAddressId: address.id,
        status,
        subtotal,
        deliveryFee,
        promotionDiscount,
        total,
        paymentMethod: PaymentMethod.cash,
        estimatedPrepTimeMinutes: restaurant.prep || 15,
        createdAt,
        updatedAt: createdAt,
        orderItems: {
          create: selectedItems.map(({ item, quantity }) => ({
            menuItemId: item.id,
            nameSnapshot: item.name,
            quantity,
            unitPrice: item.basePrice,
            selectedOptions: [],
          })),
        },
      },
    })
    ordersCreated++
  }
  console.log(`✅ ${ordersCreated} historical orders created`)

  const canonicalAiOrdersCreated = await upsertCanonicalAiSmokeOrders(restaurantIds, driverIds)
  console.log(`✅ ${canonicalAiOrdersCreated} canonical AI smoke orders upserted`)

  // ─── 7. Reviews ───
  const completedOrders = await prisma.$queryRawUnsafe<Array<{ id: string; customer_id: string; restaurant_id: string; driver_id: string | null }>>(
    `SELECT id, customer_id, restaurant_id, driver_id FROM orders WHERE status = 'completed' LIMIT 200`,
  ) as Array<{ id: string; customer_id: string; restaurant_id: string; driver_id: string | null }>

  let reviewsCreated = 0
  const reviewComments = [
    'Ngon, giao nhanh!', 'Đồ ăn ngon, đóng gói cẩn thận', 'Hơi nguội nhưng vẫn ngon',
    'Tuyệt vời!', 'Sẽ đặt lại', 'Giao hơi chậm nhưng đồ ăn ngon',
    'Rất hài lòng', 'Đồ ăn đúng mô tả', 'Tài xế thân thiện',
    'Ngon, giá hợp lý', 'Quán làm nhanh, giao đúng giờ',
  ]
  for (const order of completedOrders) {
    if (chance(0.4)) continue
    const existingReview = await prisma.review.findUnique({
      where: { orderId: order.id },
      select: { id: true },
    })
    if (existingReview) continue

    await prisma.review.create({
      data: {
        orderId: order.id, customerId: order.customer_id,
        restaurantId: order.restaurant_id, driverId: order.driver_id,
        foodRating: randInt(3, 5), deliveryRating: randInt(3, 5),
        comment: pick(reviewComments),
      },
    })
    reviewsCreated++
  }
  console.log(`✅ ${reviewsCreated} reviews created`)

  console.log(`\n🎉 BIG SEED COMPLETE!`)
  console.log(`   ${RESTAURANT_TEMPLATES.length} restaurants · 50 drivers · 100 customers`)
  console.log(`   ${ordersCreated} orders · ${reviewsCreated} reviews · ${promos.length} promotions`)
  console.log(`   Run: docker compose up -d && pnpm db:big-seed`)
}

main().then(() => prisma.$disconnect()).catch(e => { console.error(e); process.exit(1) })
