// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginWelcomeBack => 'Bienvenido de nuevo';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'Ingresa tu correo electrónico';

  @override
  String get emailRequired => 'Por favor ingresa tu correo electrónico';

  @override
  String get emailInvalid => 'Correo electrónico inválido';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordHint => 'Ingresa tu contraseña';

  @override
  String get passwordRequired => 'Por favor ingresa tu contraseña';

  @override
  String get passwordMinLength =>
      'Usa de 8 a 72 caracteres con mayúsculas, minúsculas y un número';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordTitle => 'Recuperar contraseña';

  @override
  String get forgotPasswordContent =>
      'Contáctanos por correo electrónico para restablecer tu contraseña.';

  @override
  String get close => 'Cerrar';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get noAccount => '¿No tienes una cuenta?';

  @override
  String get registerLink => 'Regístrate';

  @override
  String get registerAsDriver => 'Regístrate como repartidor';

  @override
  String get driverLoginTitle => 'Plaza 4 Repartidor';

  @override
  String get driverLoginSubtitle =>
      'Inicia sesión para empezar a aceptar pedidos';

  @override
  String get driverLoginInvalidCredentials =>
      'El correo o la contraseña son incorrectos.';

  @override
  String get driverLoginUnavailable =>
      'No se pudo iniciar sesión en este momento. Inténtalo de nuevo.';

  @override
  String get driverProfileUnavailable =>
      'No se pudo cargar el perfil del repartidor. Inténtalo de nuevo.';

  @override
  String get driverKycStatusUnavailable =>
      'No se pudo verificar el estado de validación. Inténtalo de nuevo.';

  @override
  String get driverAvailabilityUnavailable =>
      'No se pudo actualizar la disponibilidad. Inténtalo de nuevo.';

  @override
  String get registerTitle => 'Registro';

  @override
  String get registerCreateAccount => 'Crea una cuenta nueva';

  @override
  String get registerSubtitle =>
      'Completa tus datos para empezar a usar Plaza 4';

  @override
  String get fullNameLabel => 'Nombre completo';

  @override
  String get fullNameHint => 'Ingresa tu nombre completo';

  @override
  String get fullNameRequired => 'Por favor ingresa tu nombre completo';

  @override
  String get fullNameMinLength => 'El nombre debe tener al menos 2 caracteres';

  @override
  String get phoneLabel => 'Número de celular';

  @override
  String get phoneHint => 'Ingresa tu número de celular';

  @override
  String get phoneRequired => 'Por favor ingresa tu número de celular';

  @override
  String get phoneInvalid => 'Número de celular inválido';

  @override
  String get passwordHintLong =>
      'De 8 a 72 caracteres con mayúsculas, minúsculas y un número';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get confirmPasswordHint => 'Vuelve a ingresar tu contraseña';

  @override
  String get confirmPasswordRequired => 'Por favor confirma tu contraseña';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden';

  @override
  String get registerAs => '¿Registrarse como?';

  @override
  String get roleCustomer => 'Cliente';

  @override
  String get roleDriver => 'Repartidor';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get hasAccount => '¿Ya tienes una cuenta?';

  @override
  String get greetingAnonymous => '¡Hola!';

  @override
  String greetingNamed(String name) {
    return '¡Hola, $name!';

  @override
  String get homeQuestion => '¿Qué quieres comer hoy?';

  @override
  String get locating => 'Ubicando...';

  @override
  String get currentLocationLabel => 'Ubicación actual';

  @override
  String get searchHint => 'Busca comida, restaurantes...';

  @override
  String get nearbyRestaurants => 'Restaurantes cercanos';

  @override
  String get viewAll => 'Ver todos';

  @override
  String get loadingRestaurants => 'Buscando restaurantes cercanos...';

  @override
  String get noRestaurantsTitle => 'No se encontraron restaurantes';

  @override
  String get noRestaurantsSubtitle => 'Prueba ampliando tu zona de búsqueda';

  @override
  String get reload => 'Recargar';

  @override
  String get navHome => 'Inicio';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navCart => 'Carrito';

  @override
  String get navOrders => 'Pedidos';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navEarnings => 'Ganancias';

  @override
  String get cuisineAll => 'Todo';

  @override
  String get cuisineFastFood => 'Comida rápida';

  @override
  String get cuisineVietnamese => 'Vietnamita';

  @override
  String get cuisineJapanese => 'Japonesa';

  @override
  String get cuisineKorean => 'Coreana';

  @override
  String get cuisineChinese => 'China';

  @override
  String get cuisineItalian => 'Italiana';

  @override
  String get cuisineDessert => 'Postres';

  @override
  String get cuisineDrinks => 'Bebidas';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get defaultUser => 'Usuario';

  @override
  String get statsOrders => 'Pedidos';

  @override
  String get statsReviews => 'Reseñas';

  @override
  String get statsAddresses => 'Direcciones';

  @override
  String get statsPoints => 'Puntos';

  @override
  String get myAddresses => 'Mis direcciones';

  @override
  String get myAddressesSubtitle => 'Gestiona tus direcciones de entrega';

  @override
  String get profileLoyalty => 'Recompensas de lealtad';

  @override
  String get profileLoyaltySubtitle => 'Ver puntos y canjear';

  @override
  String get profileWallet => 'Mi billetera';

  @override
  String get profileWalletSubtitle => 'Saldo y movimientos';

  @override
  String get profileReferral => 'Invita amigos';

  @override
  String get profileReferralSubtitle => 'Gana recompensas por referir';

  @override
  String get profileHelp => 'Ayuda y preguntas frecuentes';

  @override
  String get profileHelpSubtitle => 'Preguntas comunes + contacto';

  @override
  String get paymentMethods => 'Métodos de pago';

  @override
  String get paymentMethodsSubtitle => 'Agrega o cambia tu método de pago';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsSubtitle => 'Gestiona las notificaciones push';

  @override
  String get notificationsReadAll => 'Marcar todas como leídas';

  @override
  String get notificationsAll => 'Todas';

  @override
  String get notificationsOrders => 'Pedidos';

  @override
  String get notificationsPromotions => 'Promociones';

  @override
  String get notificationsSystem => 'Sistema';

  @override
  String get notificationsEmptyTitle => 'Sin notificaciones';

  @override
  String get notificationsEmptySubtitle => 'Aún no tienes notificaciones.';

  @override
  String get favorites => 'Favoritos';

  @override
  String get favoritesSubtitle => 'Tus platos favoritos';

  @override
  String get support => 'Soporte';

  @override
  String get supportSubtitle => 'Centro de ayuda';

  @override
  String get aboutApp => 'Acerca de Plaza 4';

  @override
  String get aboutSubtitle => 'Versión 1.0.0';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutConfirm => '¿Seguro que quieres cerrar sesión?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonErrorTitle => 'Algo salió mal';

  @override
  String get commonErrorMessage => 'Por favor inténtalo de nuevo.';

  @override
  String get commonEmptyTitle => 'No hay datos disponibles';

  @override
  String get restaurantClosed => 'Cerrado';

  @override
  String get foodSoldOut => 'Agotado';

  @override
  String get driverProfileTitle => 'Perfil';

  @override
  String get defaultDriver => 'Repartidor';

  @override
  String get vehicleInfo => 'Información del vehículo';

  @override
  String get vehicleType => 'Tipo de vehículo';

  @override
  String get vehiclePlate => 'Número de placa';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get totalDeliveries => 'Entregas totales';

  @override
  String get totalEarnings => 'Ganancias totales';

  @override
  String get languageTitle => 'Idioma';

  @override
  String get languageVi => 'Tiếng Việt';

  @override
  String get languageEn => 'English';

  @override
  String get languageJa => '日本語';

  String get languageEs => 'Español';

  @override
  String get orderStatusPending => 'Pendiente';

  @override
  String get orderStatusConfirmed => 'Confirmado';

  @override
  String get orderStatusPreparing => 'En preparación';

  @override
  String get orderStatusPickedUp => 'En camino';

  @override
  String get orderStatusDelivered => 'Entregado';

  @override
  String get orderStatusCancelled => 'Cancelado';

  @override
  String get cartTitle => 'Carrito';

  @override
  String get cartEmpty => 'Tu carrito está vacío';

  @override
  String get cartEmptySubtitle => 'Agrega algo de comida para empezar';

  @override
  String get cartClearTitle => '¿Vaciar el carrito?';

  @override
  String get cartClearContent =>
      '¿Seguro que quieres eliminar todos los productos de tu carrito?';

  @override
  String get cartKeep => 'Conservar';

  @override
  String get cartClearAll => 'Vaciar todo';

  @override
  String get cartPromoCode => 'Código promocional';

  @override
  String get cartPromoHint => 'Ingresa el código de descuento';

  @override
  String get cartPromoRemove => 'Quitar';

  @override
  String get cartPromoApply => 'Aplicar';

  @override
  String cartPromoApplied(String code) {
    return 'Código $code aplicado';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartDeliveryFee => 'Costo de envío';

  @override
  String get cartDeliveryFeeLoading => 'Cargando desde el servidor…';

  @override
  String get cartDeliveryFeeUnavailable => 'No disponible';

  @override
  String get cartFreeDelivery => 'Gratis';

  @override
  String get cartDiscountLabel => 'Descuento';

  @override
  String get cartGrandTotal => 'Total';

  @override
  String get cartViewCart => 'Ver carrito';

  @override
  String cartAddedItem(String name) {
    return '$name agregado al carrito';
  }

  @override
  String get cartDelete => 'Eliminar';

  @override
  String get checkoutTitle => 'Finalizar pedido';

  @override
  String get checkoutDeliveryAddress => 'Dirección de entrega';

  @override
  String get checkoutNoAddress => 'No tienes direcciones guardadas';

  @override
  String get checkoutNoAddressSubtitle =>
      'Agrega una dirección para continuar con tu pedido';

  @override
  String get checkoutAddAddress => 'Agregar nueva dirección';

  @override
  String get checkoutPaymentMethod => 'Método de pago';

  @override
  String get checkoutPaymentCash => 'Efectivo';

  @override
  String get checkoutPaymentCashSubtitle => 'Paga al recibir';

  @override
  String get checkoutPaymentWallet => 'Billetera electrónica';

  @override
  String get checkoutNoteForDriver => 'Nota para el repartidor';

  @override
  String get checkoutNoteHint => 'Agrega una nota...';

  @override
  String get checkoutOrderSummary => 'Resumen del pedido';

  @override
  String get checkoutSelectAddress =>
      'Por favor selecciona una dirección de entrega';

  @override
  String get checkoutOrderFailed => 'El pedido falló';

  @override
  String get addressDefault => 'Predeterminada';

  @override
  String get restaurantListTitle => 'Cercanos';

  @override
  String get restaurantViewList => 'Lista';

  @override
  String get restaurantViewMap => 'Mapa';

  @override
  String get restaurantNoResults => 'No se encontraron restaurantes';

  @override
  String get restaurantNoResultsSubtitle => 'Prueba con otro filtro';

  @override
  String get restaurantLocationRequired =>
      'Permite el acceso a tu ubicación para encontrar restaurantes cercanos.';

  @override
  String get restaurantLoadFailed =>
      'No se pudieron cargar los restaurantes. Inténtalo de nuevo.';

  @override
  String get restaurantDetailLoadFailed =>
      'No se pudieron cargar los detalles del restaurante. Inténtalo de nuevo.';

  @override
  String get restaurantMenuLoadFailed =>
      'No se pudo cargar este menú. Inténtalo de nuevo.';

  @override
  String get restaurantMenuTab => 'Menú';

  @override
  String get restaurantReviewsTab => 'Reseñas';

  @override
  String get restaurantInfoTab => 'Info';

  @override
  String get restaurantMenuEmpty => 'Menú en actualización';

  @override
  String get restaurantMenuEmptySubtitle => 'Aún no hay productos en este menú';

  @override
  String get restaurantNoReviews => 'Aún no hay reseñas';

  @override
  String get restaurantInfoTitle => 'Información del restaurante';

  @override
  String get restaurantReviewFood => 'Comida';

  @override
  String get restaurantReviewDelivery => 'Envío';

  @override
  String get restaurantReviewCountLabel => 'Reseñas';

  @override
  String get foodPopular => 'Populares';

  @override
  String get foodSpecialNote => 'Instrucciones especiales';

  @override
  String get foodNoteHint => 'ej. sin cebolla, poco picante...';

  @override
  String get foodRequired => '(Obligatorio)';

  @override
  String get foodAddToCart => 'Agregar al carrito';

  @override
  String get trackingOrderStatus => 'Estado del pedido';

  @override
  String get trackingStepPending => 'Esperando confirmación';

  @override
  String get trackingStepPreparing => 'En preparación';

  @override
  String get trackingStepDelivering => 'En camino';

  @override
  String get trackingStepDelivered => 'Entregado';

  @override
  String get trackingOrderInProgress => 'Tu pedido está en camino';

  @override
  String get trackingCallDriver => 'Llamar';

  @override
  String get trackingMessageDriver => 'Mensaje';

  @override
  String get trackingMarkerRestaurant => 'Restaurante';

  @override
  String get trackingMarkerDriver => 'Repartidor';

  @override
  String get trackingMarkerDestination => 'Destino';

  @override
  String get orderHistoryTitle => 'Mis pedidos';

  @override
  String orderHistoryTabActive(int count) {
    return 'Activos ($count)';

  @override
  String orderHistoryTabCompleted(int count) {
    return 'Completados ($count)';

  @override
  String orderHistoryTabCancelled(int count) {
    return 'Cancelados ($count)';

  @override
  String get orderHistoryNoActive => 'No tienes pedidos activos';

  @override
  String get orderHistoryNoCompleted => 'Aún no tienes pedidos completados';

  @override
  String get orderHistoryNoCancelled => 'No tienes pedidos cancelados';

  @override
  String get orderHistoryEmptySubtitle => 'Tus pedidos aparecerán aquí';

  @override
  String get orderHistoryTrack => 'Rastrear';

  @override
  String get addressManagementTitle => 'Mis direcciones';

  @override
  String get addressAdd => 'Agregar dirección';

  @override
  String get addressLoading => 'Cargando direcciones...';

  @override
  String get addressEmpty => 'No tienes direcciones guardadas';

  @override
  String get addressEmptySubtitle =>
      'Agrega una dirección para empezar a pedir';

  @override
  String get addressSetDefault => 'Marcar como predeterminada';

  @override
  String get addressEdit => 'Editar';

  @override
  String get addressDeleteTitle => '¿Eliminar dirección?';

  @override
  String addressDeleteContent(String label) {
    return '¿Eliminar "$label"?';

  @override
  String get addressAddSuccess => 'Dirección agregada';

  @override
  String get addressUpdateSuccess => 'Dirección actualizada';

  @override
  String get addressDeleteSuccess => 'Dirección eliminada';

  @override
  String get addressSave => 'Guardar';

  @override
  String get addressLabelField => 'Etiqueta';

  @override
  String get addressFieldLabel => 'Dirección';

  @override
  String get addressFieldHint => 'Ingresa la dirección detallada';

  @override
  String get addressRequired => 'Por favor ingresa una dirección';

  @override
  String get addressAddDialogTitle => 'Agregar nueva dirección';

  @override
  String get addressEditDialogTitle => 'Editar dirección';

  @override
  String get addressAddFailed => 'No se pudo agregar la dirección';

  @override
  String get addressLocationRequired =>
      'Elige una ubicación válida en el mapa.';

  @override
  String get addressLocationInvalid =>
      'La ubicación de la dirección no es válida. Elígela de nuevo en el mapa.';

  @override
  String get addressUpdateFailed => 'No se pudo actualizar la dirección';

  @override
  String get addressDeleteFailed => 'No se pudo eliminar la dirección';

  @override
  String get addressDeleteAction => 'Eliminar';

  @override
  String get addressHomeLabel => 'Casa';

  @override
  String get addressWorkLabel => 'Trabajo';

  @override
  String get addressOtherLabel => 'Otro';

  @override
  String get supportConnecting => 'Conectando...';

  @override
  String get supportDriverOnline => 'En línea';

  @override
  String get supportAiHeader =>
      'Soporte con IA — respuestas rápidas a preguntas comunes';

  @override
  String get supportNoMessages => 'Aún no hay mensajes';

  @override
  String get supportNoMessagesSubtitle =>
      'Envía tu primer mensaje para empezar a chatear';

  @override
  String get supportMessageHint => 'Escribe un mensaje...';

  @override
  String get reviewTitle => 'Califica tu pedido';

  @override
  String get reviewFoodQuality => 'Calidad de la comida';

  @override
  String get reviewDeliveryQuality => 'Calidad del envío';

  @override
  String get reviewComment => 'Tus comentarios';

  @override
  String get reviewCommentHint =>
      'Comparte tu experiencia con la comida y el servicio de entrega...';

  @override
  String get reviewSubmit => 'Enviar reseña';

  @override
  String get reviewSuccess => '¡Reseña enviada!';

  @override
  String get reviewError => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get reviewRatingExcellent => '¡Excelente!';

  @override
  String get reviewRatingGood => 'Bueno';

  @override
  String get reviewRatingAverage => 'Regular';

  @override
  String get reviewRatingPoor => 'Malo';

  @override
  String get reviewRatingBad => 'Muy malo';

  @override
  String get driverDashboardToday => 'Hoy';

  @override
  String get driverDashboardOrders => 'Pedidos recientes';

  @override
  String get driverDashboardNoOrders => 'Aún no hay pedidos';

  @override
  String get driverActiveOrderTitle => 'Pedido activo';

  @override
  String get driverStatEarnings => 'Ganancias';

  @override
  String get driverStatOnline => 'En línea';

  @override
  String get driverStatusTitle => 'Estado de disponibilidad';

  @override
  String get driverStatusPauseTitle => 'Pausar recepción de pedidos';

  @override
  String get driverStatusPauseSubtitle =>
      'Pausa por un tiempo definido y vuelve en línea automáticamente.';

  @override
  String driverStatusPauseMinutes(int minutes) {
    return '$minutes min';

  @override
  String driverStatusPauseHours(int hours) {
    return '$hours h';

  @override
  String get driverStatusResumeNow => 'Volver a recibir pedidos ahora';

  @override
  String get driverStatusToday => 'Hoy';

  @override
  String get driverStatusOnlineTime => 'Tiempo en línea';

  @override
  String driverStatusDurationMinutes(int minutes) {
    return '$minutesm';

  @override
  String driverStatusDurationHoursMinutes(int hours, int minutes) {
    return '$hoursh $minutesm';

  @override
  String get driverStatusInfoText =>
      'Cuando estés en línea, recibirás alertas de nuevos pedidos en tu zona activa.';

  @override
  String get driverOnlineStatusOnline => 'En línea';

  @override
  String get driverOnlineStatusPaused => 'En pausa';

  @override
  String get driverOnlineStatusOffline => 'Desconectado';

  @override
  String get driverOnlineStatusDelivering => 'Entregando';

  @override
  String get driverOnlineReady => 'Listo para recibir pedidos';

  @override
  String get driverOnlineEnable => 'Actívate para recibir pedidos';

  @override
  String get driverDeliveryGpsActive => 'El GPS está compartiendo tu ubicación';

  @override
  String get driverDeliveryGpsResume => 'Conéctate para reanudar el GPS';

  @override
  String get driverOnlineAutoOffline =>
      'Vuelve a desconectarse automáticamente al terminar la pausa';

  @override
  String get driverDateToday => 'Hoy';

  @override
  String get driverDateLastSevenDays => 'Últimos 7 días';

  @override
  String get driverDateLastThirtyDays => 'Últimos 30 días';

  @override
  String get driverDateCustom => 'Personalizado';

  @override
  String get driverDateClear => 'Limpiar';

  @override
  String driverDateFrom(String date) {
    return 'Desde el $date';

  @override
  String driverDateTo(String date) {
    return 'Hasta el $date';

  @override
  String get driverStepRestaurant => 'Restaurante';

  @override
  String get driverStepPickup => 'Recoger';

  @override
  String get driverStepDeliver => 'Entregar';

  @override
  String get driverStepComplete => 'Completar';

  @override
  String get driverPeakTitle => 'Horas pico';

  @override
  String driverPeakProgress(int completed, int target) {
    return '$completed/$target pedidos';

  @override
  String driverPeakRewardEarned(String amount) {
    return 'Recompensa ganada: $amount';

  @override
  String driverPeakRewardRemaining(int count, String amount) {
    return 'Completa $count pedidos más para ganar $amount';

  @override
  String get driverEarningsDaily => 'Ganancias del día';

  @override
  String driverDaysCount(int count) {
    return '$count días';

  @override
  String driverRatingsReviewCount(int count) {
    return '$count reseñas';

  @override
  String get driverEarningsTitle => 'Ganancias';

  @override
  String get driverEarningsPeriodToday => 'Hoy';

  @override
  String get driverEarningsPeriodWeek => 'Esta semana';

  @override
  String get driverEarningsPeriodMonth => 'Este mes';

  @override
  String get driverEarningsTotal => 'Ganancias totales';

  @override
  String get driverEarningsAverage => 'Promedio por pedido';

  @override
  String get driverEarningsHistory => 'Historial de entregas';

  @override
  String get driverEarningsEmpty => 'Aún no hay datos de ganancias';

  @override
  String get driverEarningsChartError =>
      'No se pudo cargar el gráfico de ganancias';

  @override
  String get driverEarningsChartRetry => 'Reintentar';

  @override
  String get driverRatingsTitle => 'Historial de calificaciones';

  @override
  String get driverRatingsAll => 'Todas';

  @override
  String driverRatingsStars(int count) {
    return '$count estrellas';

  @override
  String get driverRatingsEmpty => 'Aún no tienes calificaciones';

  @override
  String get driverRatingsError => 'No se pudieron cargar las calificaciones.';

  @override
  String get driverRatingsRetry => 'Reintentar';

  @override
  String driverRatingsOrder(String code) {
    return 'Pedido: $code';

  @override
  String get driverRatingsToday => 'Hoy';

  @override
  String get driverRatingsYesterday => 'Ayer';

  @override
  String driverHistoryTodayAt(String time) {
    return 'Hoy, $time';

  @override
  String driverHistoryYesterdayAt(String time) {
    return 'Ayer, $time';

  @override
  String get driverTripDetailTitle => 'Detalles del viaje';

  @override
  String get driverTripDetailSegments => 'Tramos de la ruta';

  @override
  String get driverTripDetailRetry => 'Reintentar';

  @override
  String get driverTripDetailNoRoute =>
      'Aún no hay datos de ruta para este viaje';

  @override
  String get driverTripDetailLoadError => 'No se pudo cargar la ruta del viaje';

  @override
  String driverTripDetailOrder(String code) {
    return 'Pedido: $code';

  @override
  String get driverTripSummaryDistance => 'Distancia';

  @override
  String get driverTripSummaryDuration => 'Duración';

  @override
  String get driverTripSummaryAvgSpeed => 'Velocidad prom.';

  @override
  String get driverTripSummaryEarnings => 'Ganancias';

  @override
  String get driverTripSummaryCustomerRating => 'Calificación del cliente';

  @override
  String driverTripSummaryMinutes(int minutes) {
    return '$minutes min';

  @override
  String get driverRouteReplayTooltip => 'Reproducir ruta';

  @override
  String get driverRouteReplayPlaying => 'Reproduciendo...';

  @override
  String get driverRouteReplayReady => 'Toca para reproducir';

  @override
  String get driverRouteReplayCompleted => 'Reproducción terminada';

  @override
  String get driverRouteReplayEstimated =>
      'Solo ruta planificada — repetición GPS no disponible';

  @override
  String get driverRouteReplayEstimatedTooltip =>
      'La telemetría GPS no está disponible para este viaje';

  @override
  String get driverKycTitle => 'Verificación KYC';

  @override
  String get driverKycUploadTitle => 'Subir documentos';

  @override
  String get driverKycUploadSubtitle => 'Sube todos los documentos requeridos';

  @override
  String get driverKycCccdFront => 'DNI (anverso)';

  @override
  String get driverKycCccdBack => 'DNI (reverso)';

  @override
  String get driverKycDriverLicense => 'Licencia de conducir';

  @override
  String get driverKycVehicleReg => 'Tarjeta de propiedad del vehículo';

  @override
  String get driverKycTakePhoto => 'Tomar foto';

  @override
  String get driverKycGallery => 'Elegir de la galería';

  @override
  String get driverKycUploadHint => 'Toma una foto o súbela';

  @override
  String get driverKycSubmit => 'ENVIAR SOLICITUD';

  @override
  String get driverKycNote =>
      'Solicitud revisada en 24-48 h. Te avisaremos cuando sea aprobada.';

  @override
  String get driverKycSubmitFailed =>
      'No se pudo enviar la solicitud. Inténtalo de nuevo.';

  @override
  String get driverKycUploadFailed =>
      'No se pudo subir este documento. Inténtalo de nuevo.';

  @override
  String get driverKycUnsupportedImage =>
      'Usa una imagen válida en JPEG, PNG o WebP.';

  @override
  String get driverKycFileTooSmall =>
      'Esta imagen está incompleta o es muy pequeña. Captura el documento de nuevo.';

  @override
  String get driverKycFileTooLarge => 'Cada documento debe pesar 4 MB o menos.';

  @override
  String get driverKycInvalidUploadGrant =>
      'La sesión de subida segura no es válida. Inténtalo de nuevo.';

  @override
  String get driverKycSubmittedTitle => 'Solicitud enviada';

  @override
  String get driverKycSubmittedMessage =>
      'Tus documentos privados están guardados de forma segura y en espera de revisión. No podrás conectarte hasta la aprobación.';

  @override
  String get driverKycGoHome => 'Ir al inicio del repartidor';

  @override
  String get driverHistoryTitle => 'Historial de entregas';

  @override
  String get driverHistoryFilterDate => 'Filtrar por fecha';

  @override
  String get driverHistoryEmpty => 'Sin historial de entregas';

  @override
  String get driverHistoryLoadError =>
      'No se pudo cargar el historial de entregas. Inténtalo de nuevo.';

  @override
  String get driverHistoryRetry => 'Intentar de nuevo';

  @override
  String get driverHistoryOrderNumberLabel => 'Pedido';

  @override
  String get driverHistoryDeliveryAddressLabel => 'Dirección de entrega';

  @override
  String get driverHistoryNoteLabel => 'Nota';

  @override
  String get driverHistoryDeliveryFee => 'Costo de envío';

  @override
  String get locationPermissionTitle => 'Permite el acceso a tu ubicación';

  @override
  String get locationPermissionSubtitle =>
      'Plaza 4 necesita tu ubicación para encontrar restaurantes cercanos y entregar con precisión.';

  @override
  String get locationPermissionAllow => 'Permitir';

  @override
  String get locationPermissionManual => 'Ingresar dirección manualmente';

  @override
  String get driverNavTitle => 'Entrega';

  @override
  String get driverNavNoOrder => 'Sin pedido activo';

  @override
  String get driverNavRestaurant => 'Restaurante';

  @override
  String get driverNavCallRestaurant => 'Llamar al restaurante';

  @override
  String get driverNavDeliveryAddress => 'Dirección de entrega';

  @override
  String get driverNavArrivedAtRestaurant => 'LLEGUÉ AL RESTAURANTE';

  @override
  String get driverNavPreparingFood => 'Preparando la comida';

  @override
  String get driverNavItemsToPickup => 'Productos por recoger';

  @override
  String get driverNavConfirmPickup => 'CONFIRMAR RECOJO';

  @override
  String get driverNavEta => 'ETA - Llegada estimada';

  @override
  String driverNavEtaMinutes(int minutes) {
    return 'Aprox. $minutes min';

  @override
  String get driverNavEtaUnavailable => 'Esperando el ETA de la ruta';

  @override
  String get driverNavCustomerAddress => 'Dirección del cliente';

  @override
  String get driverNavCallCustomer => 'Llamar al cliente';

  @override
  String get driverNavConfirmDelivery => 'CONFIRMAR ENTREGA';

  @override
  String get driverNavDeliverySuccess => '¡Entrega exitosa!';

  @override
  String get driverNavOrderTotal => 'Total del pedido';

  @override
  String get driverNavYouEarned => 'Ganaste';

  @override
  String get driverNavGoHome => 'IR AL INICIO';

  @override
  String get driverPickupTitle => 'Confirmar recojo';

  @override
  String get driverPickupRestaurantNoteTitle => 'Nota del restaurante';

  @override
  String get driverPickupHint => 'Revisa cada producto antes de confirmar';

  @override
  String get driverPickupReportIssue => 'Reportar un problema';

  @override
  String get driverPickupReportSupportMessage =>
      'Soporte se conectará de inmediato.';

  @override
  String get driverPickupMissingTitle =>
      'No hay datos del pedido para confirmar.';

  @override
  String get driverPickupMissingDescription =>
      'Abre esta pantalla desde un pedido activo.';

  @override
  String get driverDeliveryCompleteSubtitle =>
      'Gracias por completar esta entrega';

  @override
  String get driverDeliveryTripEarnings => 'Ganancias del viaje';

  @override
  String get driverDeliveryBonus => 'Bono';

  @override
  String get driverDeliveryContinue => 'SEGUIR ACEPTANDO PEDIDOS';

  @override
  String get driverDeliveryMissingTitle =>
      'No hay datos de ganancias del viaje.';

  @override
  String get driverDeliveryMissingDescription =>
      'Abre esta pantalla desde un pedido completado.';

  @override
  String get driverNavPhoneError => 'No se puede abrir el marcador';

  @override
  String get driverNavOpenDirections => 'Abrir direcciones';

  @override
  String get driverNavDirectionsUnavailable =>
      'No hay direcciones disponibles para esta parada';

  @override
  String get driverDispatchNewOrderTitle => '¡Nuevo pedido!';

  @override
  String get driverDispatchNewOrderSubtitle => 'Acepta para empezar la entrega';

  @override
  String get driverDispatchRestaurantLabel => 'Restaurante';

  @override
  String get driverDispatchDeliveryLabel => 'Entregar en';

  @override
  String driverDispatchCountdownDecision(int seconds) {
    return 'Quedan $seconds segundos para decidir';

  @override
  String get driverDispatchCountdownUrgent => '¡Casi sin tiempo!';

  @override
  String get driverDispatchReject => 'Rechazar';

  @override
  String get driverDispatchAccept => 'Aceptar pedido';

  @override
  String get cartPlaceOrder => 'Hacer pedido';

  @override
  String get checkoutConfirmOrder => 'Confirmar pedido';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingGetStarted => 'Empezar';

  @override
  String get onboardingWelcomeTitle => 'Bienvenido a Plaza 4';

  @override
  String get onboardingWelcomeSubtitle =>
      'Pide tu comida favorita, entregada rápido en tu puerta';

  @override
  String get onboardingLocationTitle => 'Encuentra restaurantes cerca de ti';

  @override
  String get onboardingLocationSubtitle =>
      'Permite el acceso a tu ubicación para descubrir los mejores restaurantes a tu alrededor';

  @override
  String get onboardingNotificationTitle =>
      'Actualizaciones del pedido en tiempo real';

  @override
  String get onboardingNotificationSubtitle =>
      'Recibe avisos cuando tu pedido sea confirmado y esté en camino';

  @override
  String get loyaltyTitle => 'Puntos de lealtad';

  @override
  String get loyaltyPointsBalance => 'Saldo actual';

  @override
  String loyaltyPoints(int count) {
    return '$count pts';

  @override
  String get loyaltyTierBronze => 'Bronce';

  @override
  String get loyaltyTierSilver => 'Plata';

  @override
  String get loyaltyTierGold => 'Oro';

  @override
  String get loyaltyTierPlatinum => 'Platino';

  @override
  String get loyaltyNextTier => 'Siguiente nivel';

  @override
  String loyaltyPointsToNextTier(int points) {
    return 'Te faltan $points puntos para subir de nivel';

  @override
  String get loyaltyHistory => 'Historial de puntos';

  @override
  String get loyaltyHistoryEmpty => 'Aún no tienes historial de puntos';

  @override
  String get loyaltyRedeem => 'Canjear puntos';

  @override
  String get walletTitle => 'Billetera';

  @override
  String get walletBalance => 'Saldo';

  @override
  String get walletTopUp => 'Recargar';

  @override
  String get walletWithdraw => 'Retirar';

  @override
  String get walletTransactionHistory => 'Historial de movimientos';

  @override
  String get walletTransactionEmpty => 'Aún no hay movimientos';

  @override
  String get walletTopUpTitle => 'Recargar billetera';

  @override
  String get walletSelectAmount => 'Selecciona el monto';

  @override
  String get walletConfirmTopUp => 'Confirmar recarga';

  @override
  String get walletDebit => 'Débito';

  @override
  String get walletCredit => 'Crédito';

  @override
  String get walletReasonOrderPayment => 'Pago del pedido';

  @override
  String get walletReasonOrderRefund => 'Reembolso del pedido';

  @override
  String get walletReasonWithdrawal => 'Retiro';

  @override
  String get walletReasonAdjustment => 'Ajuste de billetera';

  @override
  String get referralTitle => 'Refiere a un amigo';

  @override
  String get referralSubtitle =>
      'Comparte tu código de referido y gana recompensas';

  @override
  String get referralCode => 'Tu código de referido';

  @override
  String get referralCopyCode => 'Copiar código';

  @override
  String get referralCodeCopied => '¡Código copiado!';

  @override
  String get referralShareCode => 'Compartir código';

  @override
  String get referralShareFailed =>
      'No se pudo abrir el menú de compartir. Inténtalo de nuevo.';

  @override
  String get referralShareSheetTitle => 'Compartir código de referido';

  @override
  String referralShareMessage(String code) {
    return '¡Usa el código $code y obtén un premio en tu primer pedido de Plaza 4!';

  @override
  String referralInviteCount(int count) {
    return 'Invitaste a $count amigos';

  @override
  String get referralBonusEarned => 'Bono ganado';

  @override
  String get referralHowItWorks => 'Cómo funciona';

  @override
  String get referralStep1 => 'Comparte tu código de referido';

  @override
  String get referralStep2 => 'Tu amigo se registra y hace su primer pedido';

  @override
  String get referralStep3 =>
      'Las recompensas elegibles aparecen tras la verificación';

  @override
  String get helpTitle => 'Centro de ayuda';

  @override
  String get helpSearchHint => 'Buscar preguntas...';

  @override
  String get helpFaq => 'Preguntas frecuentes';

  @override
  String get helpFaqEmpty => 'No se encontraron preguntas';

  @override
  String get helpChatSupport => 'Chat de soporte';

  @override
  String get helpCallSupport => 'Llamar a soporte';

  @override
  String get helpEmailSupport => 'Soporte por correo';

  @override
  String get helpCategories => 'Categorías';

  @override
  String get helpCategoryOrders => 'Pedidos';

  @override
  String get helpCategoryPayment => 'Pagos';

  @override
  String get helpCategoryDelivery => 'Envíos';

  @override
  String get helpCategoryAccount => 'Cuenta';

  @override
  String get filterTitle => 'Filtros';

  @override
  String get filterApply => 'Aplicar';

  @override
  String get filterReset => 'Limpiar';

  @override
  String get filterRating => 'Calificación';

  @override
  String get filterDeliveryTime => 'Tiempo de entrega';

  @override
  String get filterPriceRange => 'Rango de precios';

  @override
  String filterMinutes(int min) {
    return '$min min';

  @override
  String get filterFreeDelivery => 'Envío gratis';

  @override
  String get filterOpenNow => 'Abierto ahora';

  @override
  String get addressPickerTitle => 'Seleccionar dirección';

  @override
  String get addressPickerSearchHint => 'Buscar dirección...';

  @override
  String get addressPickerUseCurrentLocation => 'Usar ubicación actual';

  @override
  String get addressPickerSaved => 'Direcciones guardadas';

  @override
  String get addressPickerNoSaved => 'No tienes direcciones guardadas';

  @override
  String get addressPickerConfirm => 'Confirmar esta dirección';

  @override
  String get driver_onboarding_vehicle_title => 'Información del vehículo';

  @override
  String get driver_onboarding_vehicle_subtitle =>
      'Cuéntanos sobre tu vehículo';

  @override
  String get driver_onboarding_vehicle_type_label => 'Tipo de vehículo';

  @override
  String get driver_onboarding_vehicle_type_bike => 'Bicicleta';

  @override
  String get driver_onboarding_vehicle_type_motorbike => 'Moto';

  @override
  String get driver_onboarding_vehicle_type_car => 'Auto';

  @override
  String get driver_onboarding_license_label =>
      'Número de licencia de conducir';

  @override
  String get driver_onboarding_license_hint => 'Ingresa tu número de licencia';

  @override
  String get driver_onboarding_license_required =>
      'Por favor ingresa tu número de licencia';

  @override
  String get driver_onboarding_license_invalid =>
      'Usa de 5 a 50 letras, números, puntos, barras o guiones';

  @override
  String get driver_onboarding_plate_label => 'Placa';

  @override
  String get driver_onboarding_plate_hint => 'Ingresa la placa';

  @override
  String get driver_onboarding_plate_required => 'Por favor ingresa la placa';

  @override
  String get driver_onboarding_plate_invalid =>
      'Usa de 5 a 20 letras, números, puntos o guiones';

  @override
  String get driver_onboarding_next => 'Siguiente';

  @override
  String get driver_onboarding_documents_title => 'Documentos requeridos';

  @override
  String get driver_onboarding_documents_subtitle =>
      'Sube todos los documentos requeridos para revisión';

  @override
  String get driver_onboarding_agreement_title => 'Términos del repartidor';

  @override
  String get driver_onboarding_agreement_subtitle =>
      'Lee y acepta los términos para empezar';

  @override
  String get driver_onboarding_agreement_read =>
      'He leído y acepto los Términos del servicio';

  @override
  String get driver_onboarding_agreement_accept => 'Aceptar y continuar';

  @override
  String get driver_onboarding_agreement_submit => 'ENVIAR SOLICITUD';

  @override
  String get driver_onboarding_agreement_note =>
      'Solicitud revisada en 24-48 h. Te avisaremos cuando sea aprobada.';

  @override
  String get driver_onboarding_agreement_terms =>
      '1. Servicio de repartidor de Plaza 4\n\nAl registrarte como repartidor de Plaza 4, aceptas brindar servicios de entrega en tu zona operativa aprobada.\n\n2. Requisitos\n\n• Mantén una licencia de conducir válida y los documentos vehiculares requeridos.\n• Usa un vehículo seguro y asegurado que coincida con tu perfil registrado.\n• Mantén una calificación profesional y respeta las normas de tránsito.\n• Mantén confidenciales los datos de clientes, restaurantes y pedidos.\n\n3. Ganancias y liquidación\n\nLas ganancias se calculan a partir de los pedidos completados, la distancia, los incentivos y los ajustes aprobados. La liquidación semanal se paga a la cuenta bancaria guardada en Plaza 4.\n\n4. Normas de conducta\n\nLos repartidores deben comportarse profesionalmente con clientes, restaurantes y soporte. El fraude, el abuso, la entrega insegura o los reportes falsos pueden suspender o terminar la cuenta.\n\n5. Terminación\n\nPlaza 4 puede suspender o terminar el acceso del repartidor cuando se violen estos términos, las normas de seguridad o los requisitos legales.';

  @override
  String get driver_onboarding_agreement_failed =>
      'No se pudo guardar el acuerdo. Inténtalo de nuevo.';

  @override
  String get driver_incentives_title => 'Incentivos';

  @override
  String get driver_incentives_active => 'Activos';

  @override
  String get driver_incentives_completed => 'Completados';

  @override
  String driver_incentives_progress(int current, int target) {
    return '$current/$target pedidos';

  @override
  String driver_incentives_reward(String amount) {
    return 'Recompensa: $amount';

  @override
  String get driver_incentives_empty => 'No hay incentivos disponibles';

  @override
  String get driver_incentives_error => 'No se pudieron cargar los incentivos';

  @override
  String get driver_incentives_retry => 'Reintentar';

  @override
  String driver_incentives_expires(String date) {
    return 'Vence: $date';

  @override
  String get driver_heatmap_title => 'Mapa de demanda';

  @override
  String get driver_heatmap_subtitle =>
      'Zonas con alta demanda de entregas ahora mismo';

  @override
  String get driver_heatmap_high => 'Demanda alta';

  @override
  String get driver_heatmap_medium => 'Demanda media';

  @override
  String get driver_heatmap_low => 'Demanda baja';

  @override
  String get driver_heatmap_legend => 'Leyenda de colores';

  @override
  String get driver_heatmap_window_now => 'Ahora';

  @override
  String get driver_heatmap_window_next_hour => 'Próx. 1 h';

  @override
  String get driver_heatmap_window_next_three_hours => 'Próx. 3 h';

  @override
  String get driver_heatmap_window_today => 'Hoy';

  @override
  String get driver_heatmap_missing_location_title =>
      'Ubicación del repartidor no disponible';

  @override
  String get driver_heatmap_missing_location_description =>
      'Conéctate o espera a que el GPS se actualice para ver la demanda cerca de tu ubicación real.';

  @override
  String get driver_heatmap_empty_title => 'Aún no hay datos de demanda';

  @override
  String get driver_heatmap_empty_description =>
      'Los datos de demanda aparecen cuando hay pedidos disponibles cerca de tu zona.';

  @override
  String driver_heatmap_order_count(int count) {
    return '$count pedidos';

  @override
  String driver_heatmap_avg_payout(String amount) {
    return 'Promedio de $amount/pedido';

  @override
  String get driver_bank_title => 'Cuenta bancaria';

  @override
  String get driver_bank_subtitle =>
      'Agrega una cuenta para recibir pagos semanales';

  @override
  String get driver_bank_name_label => 'Nombre del banco';

  @override
  String get driver_bank_name_hint => 'Selecciona el banco';

  @override
  String get driver_bank_account_label => 'Número de cuenta';

  @override
  String get driver_bank_account_hint => 'Ingresa el número de cuenta';

  @override
  String get driver_bank_account_required =>
      'Por favor ingresa el número de cuenta';

  @override
  String get driver_bank_save => 'Guardar cuenta';

  @override
  String get driver_bank_saved => 'Cuenta bancaria guardada';

  @override
  String get driver_bank_verify => 'Verificar cuenta';

  @override
  String get driver_bank_add_title => 'Agregar cuenta bancaria';

  @override
  String get driver_bank_name_required => 'Por favor selecciona un banco';

  @override
  String get driver_bank_holder_label => 'Titular de la cuenta';

  @override
  String get driver_bank_holder_hint => 'JUAN PEREZ';

  @override
  String get driver_bank_holder_required =>
      'Por favor ingresa el nombre del titular';

  @override
  String get driver_bank_linked_title => 'Cuentas vinculadas';

  @override
  String get driver_bank_default_badge => 'Predeterminada';

  @override
  String get driver_bank_add_button => 'Agregar cuenta bancaria';

  @override
  String get driver_bank_save_failed =>
      'No se pudo actualizar la cuenta bancaria. Inténtalo de nuevo.';

  @override
  String get driver_bank_delete_tooltip => 'Eliminar cuenta bancaria';

  @override
  String get driver_bank_delete_title => '¿Eliminar cuenta bancaria?';

  @override
  String get driver_bank_delete_message =>
      'Esto quita la cuenta de pagos de tu perfil de repartidor.';

  @override
  String get driver_bank_delete_confirm => 'Eliminar';

  @override
  String get driver_bank_cancel => 'Cancelar';

  @override
  String get driver_bank_retry => 'Reintentar';

  @override
  String get driver_tip_title => 'Ajuste de propina';

  @override
  String get driver_tip_header_title =>
      '¿El cliente agregó propina en efectivo?';

  @override
  String get driver_tip_order_prefix => 'Pedido de';

  @override
  String get driver_tip_customer_prefix => 'Cliente';

  @override
  String get driver_tip_picker_title => 'Elige el monto de la propina';

  @override
  String get driver_tip_custom_title => 'O ingresa otro monto';

  @override
  String get driver_tip_custom_hint => 'Ingresa el monto (PEN)';

  @override
  String get driver_tip_skip => 'Omitir';

  @override
  String get driver_tip_confirm => 'Confirmar';

  @override
  String get driver_tip_success_snackbar => 'Reporte de propina guardado';

  @override
  String get driver_tip_success_message =>
      'Reporte de propina guardado para auditoría. La liquidación no cambia automáticamente.';

  @override
  String get driver_tip_submit_failed =>
      'No se pudo guardar el reporte de propina. Inténtalo de nuevo.';

  @override
  String get driver_notifications_read_all => 'Marcar todas como leídas';

  @override
  String get driver_notifications_all => 'Todas';

  @override
  String get driver_notifications_orders => 'Pedidos';

  @override
  String get driver_notifications_rewards => 'Recompensas';

  @override
  String get driver_notifications_system => 'Sistema';

  @override
  String get driver_notifications_empty_title => 'Sin notificaciones';

  @override
  String get driver_notifications_empty_subtitle =>
      'Aún no tienes notificaciones de repartidor.';

  @override
  String get driver_notifications_load_failed =>
      'No se pudieron cargar las notificaciones';

  @override
  String get driver_notifications_now => 'ahora';

  @override
  String get driver_notifications_minute_suffix => 'min';

  @override
  String get driver_notifications_hour_suffix => 'h';

  @override
  String get driver_notifications_day_suffix => 'd';

  @override
  String get driver_support_title => 'Soporte al repartidor';

  @override
  String get driver_support_subtitle => 'Siempre estamos aquí para ayudarte';

  @override
  String get driver_support_faq => 'Preguntas frecuentes';

  @override
  String get driver_support_contact => 'Contactar soporte';

  @override
  String get driver_support_chat => 'Chat en vivo';

  @override
  String get driver_support_email => 'Enviar correo';

  @override
  String get driver_support_phone => 'Línea directa: 1800-xxxx';

  @override
  String get driver_support_faq_q1 => '¿Cuándo me pagan?';

  @override
  String get driver_support_faq_a1 =>
      'Tus ganancias se transfieren a tu cuenta bancaria cada lunes.';

  @override
  String get driver_support_faq_q2 => '¿Cómo cambio mi zona de entrega?';

  @override
  String get driver_support_faq_a2 =>
      'Ve a Ajustes > Zonas activas para cambiar tu zona de entrega.';

  @override
  String get driver_settings_title => 'Ajustes';

  @override
  String get driver_settings_notifications_section => 'Notificaciones';

  @override
  String get driver_settings_general_section => 'General';

  @override
  String get driver_settings_notifications => 'Notificaciones push';

  @override
  String get driver_settings_notifications_subtitle =>
      'Recibe alertas de nuevos pedidos';

  @override
  String get driver_settings_language => 'Idioma';

  @override
  String get driver_settings_language_subtitle => 'Español';

  @override
  String get driver_settings_privacy => 'Política de privacidad';

  @override
  String get driver_settings_about => 'Acerca de la app';

  @override
  String get driver_settings_logout => 'Cerrar sesión';

  @override
  String get driver_settings_logout_confirm =>
      '¿Seguro que quieres cerrar sesión?';

  @override
  String get driver_settings_sound => 'Sonido de notificación';

  @override
  String get driver_settings_sound_subtitle =>
      'Reproducir sonido al llegar un nuevo pedido';

  @override
  String driver_settings_version(String version) {
    return 'Versión $version';

  @override
  String get favoritesTitle => 'Favoritos';

  @override
  String get favoritesEmpty => 'Aún no tienes restaurantes favoritos';

  @override
  String get favoritesEmptySubtitle =>
      'Explora y agrega restaurantes a tus favoritos';

  @override
  String get favoritesEmptyCta => 'Explorar restaurantes';

  @override
  String get searchInputHint => 'Busca comida, restaurantes...';

  @override
  String get searchButtonLabel => 'Buscar';

  @override
  String get searchRecentLabel => 'Búsquedas recientes';

  @override
  String get searchClearAll => 'Borrar todo';

  @override
  String get searchEmptyTitle => 'Busca comida, restaurantes';

  @override
  String get searchEmptySubtitle =>
      'Escribe el nombre de un plato o restaurante';

  @override
  String searchNoResults(String query) {
    return 'Sin resultados para "$query"';

  @override
  String get searchNoResultsSubtitle =>
      'Prueba con otras palabras o cambia los filtros';

  @override
  String get searchClosedBadge => 'Cerrado';

  @override
  String get searchFilterNearest => 'Más cercanos';

  @override
  String get searchFilterTopRated => 'Mejor calificados';

  @override
  String get searchFilterPriceLowHigh => 'Precio: menor a mayor';

  @override
  String get searchFilterOpenNow => 'Abierto ahora';

  @override
  String get searchLoadFailed => 'No se pudo buscar ahora. Inténtalo de nuevo.';

  @override
  String get vouchersTitle => 'Ofertas y cupones';

  @override
  String get vouchersTabMine => 'Mis cupones';

  @override
  String get vouchersTabAvailable => 'Disponibles';

  @override
  String get vouchersTabExpired => 'Vencidos';

  @override
  String get vouchersCodeCopied => 'Código copiado';

  @override
  String get vouchersEmptyMine => 'Aún no tienes cupones';

  @override
  String get vouchersEmptyAvailable => 'No hay cupones disponibles';

  @override
  String get vouchersEmptyAvailableSubtitle =>
      'Explora los cupones disponibles';

  @override
  String get vouchersEmptyExpired => 'No hay cupones vencidos';

  @override
  String get vouchersEmptyExpiredSubtitle =>
      'Los cupones vencidos aparecerán aquí';

  @override
  String get vouchersUseNow => 'Usar ahora';

  @override
  String vouchersPercentOff(int percent) {
    return '$percent% de descuento';

  @override
  String vouchersMinOrder(String amount) {
    return 'Pedido mín. $amount';

  @override
  String vouchersExpiresAt(String date) {
    return 'Vence: $date';

  @override
  String get cancelOrderTitle => 'Cancelar pedido';

  @override
  String get cancelOrderSuccess => 'Pedido cancelado con éxito';

  @override
  String get cancelOrderFailed => 'No se pudo cancelar el pedido';

  @override
  String get cancelOrderInfoHeader => 'Información del pedido';

  @override
  String get cancelOrderReasonHeader => 'Selecciona el motivo de cancelación';

  @override
  String get cancelOrderReasonSubtitle => 'Lamentamos si algo no estuvo bien';

  @override
  String get cancelOrderReasonSlow => 'El restaurante tardó mucho';

  @override
  String get cancelOrderReasonChanged => 'Cambié de opinión';

  @override
  String get cancelOrderReasonWrong => 'Pedí por error';

  @override
  String get cancelOrderReasonOther => 'Otro';

  @override
  String get cancelOrderNoteHint => 'Nota adicional (opcional)';

  @override
  String get cancelOrderRefundNote => 'Reembolso en 3 a 5 días hábiles';

  @override
  String get cancelOrderConfirmCta => 'Confirmar cancelación';

  @override
  String get helpCenterSearchHint => 'Buscar preguntas...';

  @override
  String get helpCenterChatCta => 'Chatear con soporte';

  @override
  String get helpCenterNoResults => 'No se encontraron preguntas';

  @override
  String get helpFaqCancelOrderQ => '¿Cómo cancelo un pedido?';

  @override
  String get helpFaqCancelOrderA =>
      'Puedes cancelar un pedido dentro de los 2 minutos de haberlo hecho. Ve a "Pedidos" → selecciona el pedido → toca "Cancelar".';

  @override
  String get helpFaqLateDeliveryQ => '¿Qué hago si mi pedido llega tarde?';

  @override
  String get helpFaqLateDeliveryA =>
      'Contáctanos por el chat de soporte para verificarlo directamente con el repartidor.';

  @override
  String get helpFaqPaymentMethodsQ => '¿Qué métodos de pago aceptan?';

  @override
  String get helpFaqPaymentMethodsA =>
      'Actualmente aceptamos pago en efectivo al recibir y la billetera electrónica de Plaza 4.';

  @override
  String get helpFaqTopUpWalletQ => '¿Cómo recargo mi billetera?';

  @override
  String get helpFaqTopUpWalletA =>
      'Ve a "Perfil" → "Billetera" → toca "Recargar" y selecciona el monto deseado.';

  @override
  String get helpFaqAddAddressQ => '¿Cómo agrego una dirección de entrega?';

  @override
  String get helpFaqAddAddressA =>
      'Ve a "Perfil" → "Mis direcciones" → toca "Agregar dirección" e ingresa los datos.';

  @override
  String get helpFaqMissingOrderQ => 'No recibí mi pedido, ¿qué hago?';

  @override
  String get helpFaqMissingOrderA =>
      'Si el repartidor marcó el pedido como entregado pero no lo recibiste, contacta a soporte de inmediato.';

  @override
  String get helpFaqRewardPointsQ => '¿Cómo se ganan los puntos de recompensa?';

  @override
  String get helpFaqRewardPointsA =>
      'Tu saldo se calcula del registro de lealtad confirmado. Las recompensas activas o por referidos aparecen cuando Plaza 4 las registra.';

  @override
  String get helpFaqTrackOrderQ => '¿Cómo rastreo mi pedido en tiempo real?';

  @override
  String get helpFaqTrackOrderA =>
      'Después de hacer tu pedido, ve a "Pedidos" → selecciona el pedido activo → toca "Rastrear".';

}