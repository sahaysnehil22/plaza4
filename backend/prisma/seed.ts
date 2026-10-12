import { PrismaClient } from '@prisma/client'
import * as bcrypt from 'bcrypt'
import { SeedPriceRange, toDatabasePriceRange } from './seed-database-values'
import { ensureDemoOrdersAndTickets } from './seed-demo-content'

const prisma = new PrismaClient()

let seedState = 0x1234abcd

function seededRandom(): number {
  seedState = (seedState * 1664525 + 1013904223) >>> 0
  return seedState / 0x100000000
}

function chance(probability: number): boolean {
  return seededRandom() < probability
}

async function main() {
  if (process.env.NODE_ENV === 'production') {
    throw new Error(
      'Refusing to run prisma/seed.ts in production because it creates demo users, restaurants, drivers, customers, and sample orders. Use a reviewed production data import/bootstrap instead.',
    )
  }

  console.log('Seeding Plaza 4 database...')

  // ── Admin User ──
  const adminHash = await bcrypt.hash('Admin@123', 12)
  const admin = await prisma.user.upsert({
    where: { email: 'admin@plaza4.pe' },
    update: {},
    create: {
      email: 'admin@plaza4.pe',
      passwordHash: adminHash,
      fullName: 'Plaza 4 Admin',
      role: 'admin',
      phone: '990000000',
      isActive: true,
    },
  })
  console.log(`Admin: ${admin.email}`)

  // ── Restaurant Owners + Restaurants ──
  const restaurants = [
    { name: 'Pollería El Buen Sabor', slug: 'polleria-el-buen-sabor', cuisine: ['Peruvian'], price: 'low', lat: -12.0464, lng: -77.0428, prep: 15, minOrder: 20 },
    { name: 'Cevichería Mar y Tierra', slug: 'cevicheria-mar-y-tierra', cuisine: ['Peruvian', 'Seafood'], price: 'medium', lat: -12.0500, lng: -77.0380, prep: 20, minOrder: 25 },
    { name: 'Anticuchos Doña Rosa', slug: 'anticuchos-dona-rosa', cuisine: ['Peruvian', 'Street Food'], price: 'low', lat: -12.0550, lng: -77.0350, prep: 10, minOrder: 15 },
    { name: 'Pizzería La Toscana', slug: 'pizzeria-la-toscana', cuisine: ['Italian'], price: 'medium', lat: -12.0600, lng: -77.0300, prep: 20, minOrder: 30 },
    { name: 'Sushi Nikkei Lima', slug: 'sushi-nikkei-lima', cuisine: ['Japanese', 'Peruvian'], price: 'high', lat: -12.0650, lng: -77.0250, prep: 25, minOrder: 50 },
    { name: 'Hamburguesería El Faro', slug: 'hamburgueseria-el-faro', cuisine: ['Fast Food'], price: 'medium', lat: -12.0700, lng: -77.0400, prep: 12, minOrder: 25 },
    { name: 'Chifa Cantón', slug: 'chifa-canton', cuisine: ['Chinese', 'Peruvian'], price: 'low', lat: -12.0750, lng: -77.0450, prep: 15, minOrder: 20 },
    { name: 'Parrilla Don Pepe', slug: 'parrilla-don-pepe', cuisine: ['Peruvian', 'Grill'], price: 'high', lat: -12.0800, lng: -77.0500, prep: 30, minOrder: 60 },
  ]

  const createdRestaurants: Array<{ id: string; lat: number; lng: number }> = []

  for (let i = 0; i < restaurants.length; i++) {
    const r = restaurants[i]
    const ownerEmail = `restaurant${i + 1}@plaza4.pe`
    const ownerHash = await bcrypt.hash('Partner@123', 12)

    const owner = await prisma.user.upsert({
      where: { email: ownerEmail },
      update: {},
      create: {
        email: ownerEmail,
        passwordHash: ownerHash,
        fullName: `${r.name} Manager`,
        role: 'restaurant',
        phone: `9900000${10 + i}`,
      },
    })

    const restaurant = await prisma.$executeRawUnsafe(
      `INSERT INTO restaurants (id, name, slug, description, logo_url, cover_url, location, address_line, city, district, phone, cuisine_types, price_range, rating, total_reviews, is_open, is_active, prep_time_avg_minutes, min_order_amount, created_at)
       VALUES (gen_random_uuid(), $1, $2, $3, $4, $5, ST_SetSRID(ST_MakePoint($6, $7), 4326), $8, 'Lima', 'Miraflores', $9, $10::text[], $11::"PriceRange", 4.5, ${50 + i * 23}, true, true, $12, $13, NOW())
       RETURNING id`,
      r.name, r.slug, `${r.name} - Sabor peruano todos los días`,
      `https://picsum.photos/seed/${r.slug}/200/200`,
      `https://picsum.photos/seed/${r.slug}-cover/800/400`,
      r.lng, r.lat,
      `Av. Larco ${100 + i}, Miraflores, Lima`,
      `99000001${i}`,
      `{${r.cuisine.join(',')}}`,
      toDatabasePriceRange(r.price as SeedPriceRange),
      r.prep, r.minOrder,
    )

    // Get the created restaurant
    const created = await prisma.restaurant.findFirst({ where: { slug: r.slug } })
    if (created) {
      // Standard local fixtures should exercise the same public routes as a
      // live, approved restaurant rather than remaining in the schema default.
      await prisma.restaurant.update({
        where: { id: created.id },
        data: { approvalStatus: 'approved' },
      })
      createdRestaurants.push({ id: created.id, lat: r.lat, lng: r.lng })

      await prisma.restaurantProfile.upsert({
        where: { userId: owner.id },
        update: {},
        create: { userId: owner.id, restaurantId: created.id },
      })

      // Opening hours (7am - 9pm every day)
      for (let day = 0; day < 7; day++) {
        await prisma.restaurantOpeningHour.create({
          data: { restaurantId: created.id, dayOfWeek: day, openTime: '07:00', closeTime: '21:00' },
        })
      }
    }
  }
  console.log(`${restaurants.length} restaurants seeded`)

  // ── Drivers ──
  const driverNames = ['Juan Pérez', 'María Torres', 'Carlos Quispe', 'Rosa Huamán', 'Luis Fernández']
  const driverIds: string[] = []

  for (let i = 0; i < driverNames.length; i++) {
    const driverHash = await bcrypt.hash('Driver@123', 12)
    const email = `driver${i + 1}@plaza4.pe`

    const driver = await prisma.user.upsert({
      where: { email },
      update: {},
      create: {
        email,
        passwordHash: driverHash,
        fullName: driverNames[i],
        role: 'driver',
        phone: `9900002${10 + i}`,
      },
    })

    await prisma.driverProfile.upsert({
      where: { userId: driver.id },
      update: {},
      create: {
        userId: driver.id,
        licenseNumber: `LIC-${10000 + i}`,
        vehicleType: 'motorbike',
        vehiclePlate: `59A1-${10000 + i}`,
        isVerified: true,
        rating: 4.0 + seededRandom() * 1.0,
        totalDeliveries: 50 + i * 30,
        totalEarnings: 800 + i * 300,
      },
    })
    driverIds.push(driver.id)
  }
  console.log(`${driverNames.length} drivers seeded`)

  // ── Customers ──
  for (let i = 0; i < 5; i++) {
    const customerHash = await bcrypt.hash('Customer@123', 12)
    const email = `customer${i + 1}@plaza4.pe`

    const customer = await prisma.user.upsert({
      where: { email },
      update: {},
      create: {
        email,
        passwordHash: customerHash,
        fullName: `Cliente ${i + 1}`,
        role: 'customer',
        phone: `9900003${10 + i}`,
      },
    })

    await prisma.customerProfile.upsert({
      where: { userId: customer.id },
      update: {},
      create: { userId: customer.id, totalOrders: i * 5 },
    })

    // Add addresses (raw SQL — Address has PostGIS Unsupported column)
    const aLat = -12.0550 + seededRandom() * 0.01
    const aLng = -77.0350 + seededRandom() * 0.01
    await prisma.$executeRawUnsafe(
      `INSERT INTO addresses (id, user_id, label, address_line, location, is_default, created_at)
       VALUES (gen_random_uuid(), $1::uuid, $2, $3, ST_SetSRID(ST_MakePoint($4, $5), 4326), true, NOW())`,
      customer.id, 'Casa', `Av. Arequipa ${100 + i * 10}, Miraflores, Lima`, aLng, aLat,
    )
  }
  console.log('5 customers seeded')

  // Update address locations with raw SQL (PostGIS points)
  await prisma.$executeRawUnsafe(`
    UPDATE addresses SET location = ST_SetSRID(ST_MakePoint(-77.0295, -12.0464), 4326)
    WHERE location IS NULL
  `)

  // ── Menu Items ──
  const menuData: Record<string, Array<{ cat: string; items: Array<{ name: string; price: number; desc: string }> }>> = {
    'polleria-el-buen-sabor': [
      { cat: 'Pollos a la brasa', items: [
        { name: '1/4 pollo + papas', price: 18, desc: 'Cuarto de pollo a la brasa con papas fritas y ensalada' },
        { name: '1/2 pollo + papas', price: 32, desc: 'Medio pollo a la brasa con papas fritas familiares' },
        { name: 'Pollo entero + papas', price: 58, desc: 'Pollo entero a la brasa con 2 porciones de papas' },
      ]},
      { cat: 'Criollos', items: [
        { name: 'Chaufa de pollo', price: 16, desc: 'Arroz chaufa con pollo a la brasa deshilachado' },
        { name: 'Salchipapas', price: 12, desc: 'Papas fritas con hot dog y salsas' },
      ]},
      { cat: 'Bebidas', items: [
        { name: 'Inca Kola 500ml', price: 6, desc: 'Gaseosa personal' },
        { name: 'Chicha morada 1L', price: 10, desc: 'Chicha morada casera' },
      ]},
    ],
    'cevicheria-mar-y-tierra': [
      { cat: 'Ceviches', items: [
        { name: 'Ceviche clásico', price: 28, desc: 'Corvina fresca, limón, cebolla, camote y choclo' },
        { name: 'Ceviche mixto', price: 32, desc: 'Pescado, calamar, camarón y pulpo' },
        { name: 'Leche de tigre', price: 15, desc: 'Jugo del ceviche con trozos de pescado' },
      ]},
      { cat: 'Fritos', items: [
        { name: 'Jalea mixta', price: 32, desc: 'Pescado y mariscos fritos con yuca' },
        { name: 'Chicharrón de pescado', price: 26, desc: 'Trozos de pescado frito con salsa criolla' },
      ]},
      { cat: 'Arroces', items: [
        { name: 'Arroz con mariscos', price: 30, desc: 'Arroz con mixtura de mariscos al estilo norteño' },
      ]},
    ],
    'anticuchos-dona-rosa': [
      { cat: 'Anticuchos', items: [
        { name: 'Anticucho de corazón', price: 12, desc: '2 palitos de corazón de res a la parrilla' },
        { name: 'Rachi', price: 14, desc: 'Pancita de res a la parrilla con papas' },
        { name: 'Mollejitas', price: 13, desc: 'Mollejitas doradas con ocopa' },
      ]},
      { cat: 'Para compartir', items: [
        { name: 'Anticuchada mixta', price: 25, desc: 'Anticucho, rachi y mollejitas con papas y choclo' },
        { name: 'Choclo con queso', price: 8, desc: 'Choclo sancochado con queso fresco' },
      ]},
    ],
    'pizzeria-la-toscana': [
      { cat: 'Pizzas', items: [
        { name: 'Margarita', price: 35, desc: 'Salsa de tomate, mozzarella fior di latte y albahaca' },
        { name: 'Pepperoni', price: 42, desc: 'Pepperoni, mozzarella y salsa de tomate' },
        { name: 'Cuatro quesos', price: 48, desc: 'Mozzarella, gorgonzola, parmesano y fontina' },
      ]},
      { cat: 'Pastas', items: [
        { name: 'Spaghetti al pesto', price: 32, desc: 'Pesto genovese con parmesano' },
        { name: 'Lasagna de la casa', price: 38, desc: 'Capas de pasta con ragú y bechamel' },
      ]},
    ],
    'sushi-nikkei-lima': [
      { cat: 'Makis', items: [
        { name: 'Maki acevichado x10', price: 38, desc: 'Relleno de pescado con salsa acevichada' },
        { name: 'Maki parrillero x10', price: 40, desc: 'Salmón a la parrilla con salsa nikkei' },
      ]},
      { cat: 'Nikkei', items: [
        { name: 'Tiradito nikkei', price: 36, desc: 'Láminas de pescado con salsa de ají amarillo y soja' },
        { name: 'Nigiri mixto x6', price: 42, desc: 'Salmón, atún y langostino sobre arroz' },
        { name: 'Causa nikkei', price: 28, desc: 'Causa limeña con tartar de atún nikkei' },
      ]},
    ],
    'hamburgueseria-el-faro': [
      { cat: 'Hamburguesas', items: [
        { name: 'Clásica de la casa', price: 22, desc: 'Carne 180g, queso, lechuga, tomate y salsa faro' },
        { name: 'Doble queso', price: 28, desc: 'Doble carne, doble queso cheddar y tocino' },
        { name: 'Crispy chicken', price: 24, desc: 'Pollo crocante, col slaw y miel mostaza' },
      ]},
      { cat: 'Acompañamientos', items: [
        { name: 'Papas fritas', price: 10, desc: 'Papas nativas crocantes con sal de maras' },
        { name: 'Aros de cebolla', price: 12, desc: 'Aros apanados con salsa tártara' },
      ]},
      { cat: 'Bebidas y postres', items: [
        { name: 'Milkshake de lúcuma', price: 14, desc: 'Batido cremoso de lúcuma' },
      ]},
    ],
    'chifa-canton': [
      { cat: 'Chaufas', items: [
        { name: 'Chaufa de pollo', price: 16, desc: 'Arroz frito con pollo, huevo y cebolla china' },
        { name: 'Chaufa especial', price: 22, desc: 'Pollo, chancho, langostino y huevo' },
        { name: 'Chaufa de chancho', price: 18, desc: 'Arroz frito con cerdo asado cantonés' },
      ]},
      { cat: 'Tallarines', items: [
        { name: 'Tallarín saltado de pollo', price: 20, desc: 'Tallarín salteado al wok con pollo y verduras' },
        { name: 'Tallarín con chancho', price: 22, desc: 'Tallarín en salsa de ostión con cerdo' },
      ]},
      { cat: 'Wantanes', items: [
        { name: 'Wantán frito x8', price: 14, desc: 'Wantanes rellenos de cerdo con salsa de tamarindo' },
        { name: 'Sopa wantán', price: 12, desc: 'Caldo cantonés con wantanes y fideos' },
      ]},
    ],
    'parrilla-don-pepe': [
      { cat: 'Parrillas', items: [
        { name: 'Parrilla personal', price: 45, desc: 'Bife, chorizo, morcilla, anticucho y papas' },
        { name: 'Piqueo parrillero', price: 55, desc: 'Selección de cortes para 2 personas' },
        { name: 'Bife a lo pobre', price: 42, desc: 'Bife con plátano frito, huevo y papas' },
      ]},
      { cat: 'Criollos a la parrilla', items: [
        { name: 'Lomo saltado', price: 38, desc: 'Lomo fino salteado con papas fritas y arroz' },
        { name: 'Anticuchos premium', price: 28, desc: 'Corazón Angus a la parrilla con ocopa' },
      ]},
    ],
  }

  let totalItems = 0
  for (const [slug, categories] of Object.entries(menuData)) {
    const restaurant = await prisma.restaurant.findUnique({ where: { slug } })
    if (!restaurant) continue

    for (let ci = 0; ci < categories.length; ci++) {
      const cat = categories[ci]
      const category = await prisma.category.create({
        data: { restaurantId: restaurant.id, name: cat.cat, sortOrder: ci },
      })

      for (const item of cat.items) {
        await prisma.menuItem.create({
          data: {
            restaurantId: restaurant.id,
            categoryId: category.id,
            name: item.name,
            description: item.desc,
            basePrice: item.price,
            imageUrl: `https://picsum.photos/seed/${slug}-${item.name.toLowerCase().replace(/\s/g, '-')}/400/400`,
            isPopular: chance(0.3),
          },
        })
        totalItems++
      }
    }
  }
  console.log(`${totalItems} menu items seeded`)

  // ── Promotions ──
  await prisma.promotion.createMany({
    data: [
      { code: 'WELCOME20', type: 'percentage', value: 20, minOrderAmount: 50, maxDiscount: 25, usageLimit: 1000, usageCount: 0, startsAt: new Date('2026-01-01'), expiresAt: new Date('2026-12-31'), isActive: true },
      { code: 'FREESHIP', type: 'fixed', value: 6, minOrderAmount: 60, maxDiscount: 6, usageLimit: 500, usageCount: 0, startsAt: new Date('2026-01-01'), expiresAt: new Date('2026-12-31'), isActive: true },
      { code: 'PLAZA50', type: 'percentage', value: 50, minOrderAmount: 120, maxDiscount: 60, usageLimit: 200, usageCount: 0, startsAt: new Date('2026-01-01'), expiresAt: new Date('2026-12-31'), isActive: true },
    ],
    skipDuplicates: true,
  })
  console.log('3 promotions seeded')

  // ── Demo order + support ticket (Admin Support + Restaurant kanban) ──
  const demo = await ensureDemoOrdersAndTickets(prisma as never)
  console.log(
    `Demo content: order=${demo.orderId ?? 'skipped'} ticket=${demo.ticketId ?? 'skipped'}`,
  )
  console.log('Seed complete!')
}

main()
  .then(() => prisma.$disconnect())
  .catch((e) => { console.error(e); process.exit(1) })
