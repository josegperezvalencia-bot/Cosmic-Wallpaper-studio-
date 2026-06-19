enum EffectType {
  spaceParticles('Partículas Espaciales', false),
  animatedStars('Estrellas Animadas', false),
  nebula('Nebulosas', false),
  neonGlow('Brillo Neón', true),
  floatingPlanets('Planetas Flotantes', true),
  meteorShower('Lluvia de Meteoritos', true);

  final String label;
  final bool isPremium;

  const EffectType(this.label, this.isPremium);
}
