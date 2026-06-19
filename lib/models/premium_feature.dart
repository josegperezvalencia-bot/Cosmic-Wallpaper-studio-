enum PremiumFeature {
  export4K('Exportación 4K', 'Exporta tus wallpapers en resolución 4K'),
  allEffects('Todos los Efectos', 'Accede a todos los efectos premium'),
  noAds('Sin Anuncios', 'Disfruta de la app sin anuncios'),
  aiGeneration('Generación IA', 'Ilimitada generación con IA'),
  gifExport('Exportación GIF', 'Exporta como GIF animado'),
  mp4Export('Exportación MP4', 'Exporta como video MP4');

  final String label;
  final String description;

  const PremiumFeature(this.label, this.description);
}
