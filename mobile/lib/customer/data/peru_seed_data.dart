import 'package:flutter/material.dart';
import '../../shared/models/menu_item.dart';

/// Seed data and catalog constants for Plaza 4 Quick-Commerce (Peru).
///
/// Features authentic Peruvian Spanish naming, genuine strip-store categories,
/// realistic Soles (PEN) pricing, and popular Lima quick-commerce search tags.
class PeruSeedData {
  PeruSeedData._();

  static const String storeName = 'Plaza 4 Express';
  static const String defaultLocation = 'Av. Larco 450, Miraflores, Lima';
  static const String deliveryEtaBadge = 'Entrega en 15 min';
  static const double standardDeliveryFee = 6.00; // S/ 6.00 as requested
  static const double freeDeliveryThreshold = 35.00;
  static const double ecoBagFee = 0.80; // S/ 0.80 bolsa ecológica

  /// Quick commerce categories tailored for a Peruvian strip store
  static final List<PeruCategory> categories = [
    const PeruCategory(
      id: 'abarrotes',
      name: 'Abarrotes',
      subtitle: 'Arroz, aceite, fideos',
      icon: Icons.kitchen_rounded,
      badge: 'Básicos',
      color: Color(0xFF00A86B),
    ),
    const PeruCategory(
      id: 'frutas_verduras',
      name: 'Frutas y Verduras',
      subtitle: 'Paltas, limones, ajíes',
      icon: Icons.eco_rounded,
      badge: 'Fresco',
      color: Color(0xFF4CAF50),
    ),
    const PeruCategory(
      id: 'comida_caliente',
      name: 'Comida al Toque',
      subtitle: 'Lomo saltado, pollo',
      icon: Icons.restaurant_menu_rounded,
      badge: 'Al wok',
      color: Color(0xFFE53935),
    ),
    const PeruCategory(
      id: 'panaderia',
      name: 'Panadería',
      subtitle: 'Pan francés, ciabatta',
      icon: Icons.bakery_dining_rounded,
      badge: 'Del día',
      color: Color(0xFFF57C00),
    ),
    const PeruCategory(
      id: 'bebidas',
      name: 'Bebidas y Licores',
      subtitle: 'Inca Kola, Cusqueña',
      icon: Icons.local_bar_rounded,
      badge: 'Heladitas',
      color: Color(0xFF1E88E5),
    ),
    const PeruCategory(
      id: 'lacteos_embutidos',
      name: 'Lácteos y Huevos',
      subtitle: 'Gloria, quesos, jamón',
      icon: Icons.egg_outlined,
      badge: null,
      color: Color(0xFF8E24AA),
    ),
    const PeruCategory(
      id: 'snacks',
      name: 'Snacks y Dulces',
      subtitle: 'Piqueos, chocolates',
      icon: Icons.cookie_rounded,
      badge: null,
      color: Color(0xFFFFB300),
    ),
    const PeruCategory(
      id: 'farmacia_aseo',
      name: 'Aseo y Farmacia',
      subtitle: 'Papel, analgésicos',
      icon: Icons.medical_services_rounded,
      badge: null,
      color: Color(0xFF00ACC1),
    ),
  ];

  /// Popular searches in Peru
  static const List<String> trendingSearchesPeru = [
    'Inca Kola 1.5L',
    'Palta Fuerte',
    'Lomo Saltado',
    'Pan Francés',
    'Leche Gloria Azul',
    'Pollo a la Brasa',
    'Arroz Costeño',
    'Cerveza Cusqueña',
    'Galletas Casino',
    'Ají Amarillo',
  ];

  /// Realistic catalog of Peruvian products
  static final List<MenuItemModel> allProducts = [
    // Comida Caliente
    MenuItemModel(
      id: 'prod-lomo-saltado',
      restaurantId: 'plaza4-express',
      name: 'Lomo Saltado Clásico',
      description:
          'Trozos de lomo fino salteados al wok con cebolla morada, tomate, ají amarillo y culantro. Servido con papas fritas crocantes y arroz con choclo.',
      price: 24.90,
      category: 'comida_caliente',
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
      optionGroups: [
        ItemOptionGroup(
          id: 'opt-termino',
          name: 'Término de la carne',
          required: true,
          options: [
            ItemOption(id: 'term-medio', name: 'Término medio', price: 0.0),
            ItemOption(id: 'term-3-4', name: 'Tres cuartos', price: 0.0),
            ItemOption(id: 'term-cocido', name: 'Bien cocido', price: 0.0),
          ],
        ),
        ItemOptionGroup(
          id: 'opt-salsas',
          name: 'Salsas y Ají',
          type: 'multi',
          required: false,
          options: [
            ItemOption(id: 'salsa-aji', name: 'Ají pollero de la casa', price: 0.0),
            ItemOption(id: 'salsa-mayo', name: 'Mayonesa casera', price: 0.0),
            ItemOption(id: 'salsa-rocoto', name: 'Crema de rocoto', price: 1.0),
          ],
        ),
      ],
    ),
    MenuItemModel(
      id: 'prod-pollo-brasa',
      restaurantId: 'plaza4-express',
      name: '1/4 Pollo a la Brasa con Papas',
      description:
          'Cuarto de pollo marinado en hierbas peruanas y cerveza negra, horneado a las brasas. Incluye papas fritas nativas y ensalada fresca.',
      price: 18.90,
      category: 'comida_caliente',
      imageUrl:
          'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
      optionGroups: [
        ItemOptionGroup(
          id: 'opt-pieza',
          name: 'Pieza de pollo',
          required: true,
          options: [
            ItemOption(id: 'pieza-pechuga', name: 'Pechuga + Ala', price: 0.0),
            ItemOption(id: 'pieza-pierna', name: 'Pierna + Encuentro', price: 0.0),
          ],
        ),
      ],
    ),
    MenuItemModel(
      id: 'prod-arroz-chaufa',
      restaurantId: 'plaza4-express',
      name: 'Arroz Chaufa Especial de Pollo',
      description:
          'Salteado criollo al wok con sillao oriental, trozos de pollo tierno, tortilla de huevo y cebollita china fresca.',
      price: 21.50,
      category: 'comida_caliente',
      imageUrl:
          'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),

    // Frutas y Verduras
    MenuItemModel(
      id: 'prod-palta-fuerte',
      restaurantId: 'plaza4-express',
      name: 'Palta Fuerte Hass x 1 kg',
      description:
          'Paltas seleccionadas de valles peruanos, textura cremosa inigualable. Maduras listas para tu desayuno o ensalada.',
      price: 9.80,
      category: 'frutas_verduras',
      imageUrl:
          'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),
    MenuItemModel(
      id: 'prod-aji-amarillo',
      restaurantId: 'plaza4-express',
      name: 'Ají Amarillo Fresco x 500g',
      description:
          'El alma de la gastronomía peruana. Vainas firmes, aroma intenso y picor balanceado.',
      price: 3.50,
      category: 'frutas_verduras',
      imageUrl:
          'https://images.unsplash.com/photo-1588252303782-cb80119abd6d?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),
    MenuItemModel(
      id: 'prod-limon-sutil',
      restaurantId: 'plaza4-express',
      name: 'Limón Sutil Peruano x 1 kg',
      description:
          'Limones jugosos de Chulucanas con acidez perfecta para ceviche, chilcano y aderezos.',
      price: 5.90,
      category: 'frutas_verduras',
      imageUrl:
          'https://images.unsplash.com/photo-1534940562386-d3c52e4693a1?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),

    // Bebidas
    MenuItemModel(
      id: 'prod-inca-kola-15',
      restaurantId: 'plaza4-express',
      name: 'Inca Kola 1.5L No Retornable',
      description:
          'La bebida de sabor nacional. Bien helada, el acompañamiento perfecto para cualquier comida peruana.',
      price: 7.50,
      category: 'bebidas',
      imageUrl:
          'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),
    MenuItemModel(
      id: 'prod-cusquena-trigo',
      restaurantId: 'plaza4-express',
      name: 'Cerveza Cusqueña Trigo 310ml Pack x 6',
      description:
          'Cerveza premium de malta y trigo selecto de los Andes. Notas cítricas y cuerpo refrescante.',
      price: 32.50,
      category: 'bebidas',
      imageUrl:
          'https://images.unsplash.com/photo-1608270119293-1b058a55ce24?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),
    MenuItemModel(
      id: 'prod-chicha-morada',
      restaurantId: 'plaza4-express',
      name: 'Chicha Morada Artesanal 1L',
      description:
          'Hervida con maíz morado peruano, piña, manzana criolla, canela y clavo de olor, con toque de limón.',
      price: 8.50,
      category: 'bebidas',
      imageUrl:
          'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),

    // Panadería
    MenuItemModel(
      id: 'prod-pan-frances',
      restaurantId: 'plaza4-express',
      name: 'Pan Francés Artesanal x 10 und',
      description:
          'Recién horneado en Plaza 4. Crocante por fuera con miga suave y aireada. Listo para rellenar con palta o chicharrón.',
      price: 4.50,
      category: 'panaderia',
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),
    MenuItemModel(
      id: 'prod-pan-ciabatta',
      restaurantId: 'plaza4-express',
      name: 'Pan Ciabatta con Aceituna x 6 und',
      description:
          'Elaborado con masa madre y trozos de aceituna negra de Botija de Ica.',
      price: 6.20,
      category: 'panaderia',
      imageUrl:
          'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),

    // Abarrotes
    MenuItemModel(
      id: 'prod-arroz-costeno',
      restaurantId: 'plaza4-express',
      name: 'Arroz Costeño Extra 1 kg',
      description:
          'Grano largo seleccionado, no se bate ni se quema. Rinde mucho más para toda la familia.',
      price: 4.90,
      category: 'abarrotes',
      imageUrl:
          'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),
    MenuItemModel(
      id: 'prod-aceite-primor',
      restaurantId: 'plaza4-express',
      name: 'Aceite Vegetal Primor Premium 1L',
      description:
          'Aceite 100% puro vegetal con vitamina E. Ideal para frituras crocantes y aderezos.',
      price: 11.50,
      category: 'abarrotes',
      imageUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),
    MenuItemModel(
      id: 'prod-fideos-don-vittorio',
      restaurantId: 'plaza4-express',
      name: 'Fideos Don Vittorio Spaghetti 500g',
      description:
          'Pasta de sémola de trigo durum, queda al dente siempre.',
      price: 3.80,
      category: 'abarrotes',
      imageUrl:
          'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),

    // Lácteos
    MenuItemModel(
      id: 'prod-leche-gloria',
      restaurantId: 'plaza4-express',
      name: 'Leche Evaporada Gloria Azul 400g',
      description:
          'La leche tradicional del Perú. Fortificada con vitaminas A y D para el desayuno.',
      price: 4.20,
      category: 'lacteos_embutidos',
      imageUrl:
          'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),
    MenuItemModel(
      id: 'prod-queso-andino',
      restaurantId: 'plaza4-express',
      name: 'Queso Andino Tradicional Tajado 250g',
      description:
          'Queso madurado de Cajamarca, sabor suave y textura mantecosa.',
      price: 12.90,
      category: 'lacteos_embutidos',
      imageUrl:
          'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),

    // Snacks
    MenuItemModel(
      id: 'prod-galletas-casino',
      restaurantId: 'plaza4-express',
      name: 'Galletas Casino Menta x 6 paquetes',
      description:
          'Galletas peruanas de chocolate rellenas con crema de menta refrescante.',
      price: 5.20,
      category: 'snacks',
      imageUrl:
          'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),
    MenuItemModel(
      id: 'prod-piqueo-snax',
      restaurantId: 'plaza4-express',
      name: 'Piqueo Snax Familiar 160g',
      description:
          'Mix de chifles norteños, papas al hilo, tortees y chicharrones.',
      price: 6.80,
      category: 'snacks',
      imageUrl:
          'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=600&auto=format&fit=crop&q=80',
      isAvailable: true,
    ),
  ];

  /// Flash Deals (Ofertas Relámpago) with countdown and deep discounts
  static final List<FlashDealItem> flashDeals = [
    FlashDealItem(
      product: allProducts.firstWhere((p) => p.id == 'prod-lomo-saltado'),
      discountPercent: 17,
      originalPrice: 29.90,
      dealPrice: 24.90,
      badgeText: '¡Ahorras S/ 5.00!',
      endsInHours: 2,
    ),
    FlashDealItem(
      product: allProducts.firstWhere((p) => p.id == 'prod-palta-fuerte'),
      discountPercent: 25,
      originalPrice: 13.00,
      dealPrice: 9.80,
      badgeText: '¡25% DSCTO!',
      endsInHours: 4,
    ),
    FlashDealItem(
      product: allProducts.firstWhere((p) => p.id == 'prod-inca-kola-15'),
      discountPercent: 21,
      originalPrice: 9.50,
      dealPrice: 7.50,
      badgeText: 'Combo Express',
      endsInHours: 1,
    ),
    FlashDealItem(
      product: allProducts.firstWhere((p) => p.id == 'prod-pollo-brasa'),
      discountPercent: 15,
      originalPrice: 22.00,
      dealPrice: 18.90,
      badgeText: 'Brasa Caliente',
      endsInHours: 3,
    ),
  ];
}

class PeruCategory {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final String? badge;
  final Color color;

  const PeruCategory({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    this.badge,
    required this.color,
  });
}

class FlashDealItem {
  final MenuItemModel product;
  final int discountPercent;
  final double originalPrice;
  final double dealPrice;
  final String badgeText;
  final int endsInHours;

  const FlashDealItem({
    required this.product,
    required this.discountPercent,
    required this.originalPrice,
    required this.dealPrice,
    required this.badgeText,
    required this.endsInHours,
  });
}
