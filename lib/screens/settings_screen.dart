import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/premium_provider.dart';
import '../widgets/hud_widgets.dart';
import '../utils/constants.dart';
import 'premium_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final premium = context.watch<PremiumProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('AJUSTES')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            HUDPanel(
              title: 'Premium',
              icon: Icons.workspace_premium,
              accentColor: AppConstants.hudAmber,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        premium.isPremium
                            ? Icons.verified
                            : Icons.workspace_premium_outlined,
                        color: premium.isPremium
                            ? AppConstants.hudAmber
                            : Colors.grey,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              premium.isPremium
                                  ? 'PREMIUM ACTIVADO'
                                  : 'PREMIUM',
                              style: TextStyle(
                                color: premium.isPremium
                                    ? AppConstants.hudAmber
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              premium.isPremium
                                  ? 'Todas las funciones desbloqueadas'
                                  : 'Desbloquea todas las funciones',
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!premium.isPremium) ...[
                    const SizedBox(height: 16),
                    HUDButton(
                      label: 'ACTUALIZAR A PREMIUM',
                      icon: Icons.workspace_premium,
                      color: AppConstants.hudAmber,
                      isOutlined: true,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PremiumScreen()),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            HUDPanel(
              title: 'Información',
              icon: Icons.info_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('App', AppConstants.appName),
                  _infoRow('Versión', AppConstants.appVersion),
                  _infoRow('Estilo', 'Futurista Sci-Fi HUD'),
                  _infoRow('Plataforma', 'Android 10+'),
                  _infoRow('Framework', 'Flutter + Material 3'),
                ],
              ),
            ),
            HUDPanel(
              title: 'Renderizado',
              icon: Icons.display_settings,
              child: Column(
                children: [
                  _settingRow(
                    context,
                    'AMOLED Mode',
                    'Optimizado para pantallas AMOLED',
                    Icons.dark_mode,
                    true,
                  ),
                  const Divider(height: 1),
                  _settingRow(
                    context,
                    'Alta calidad',
                    'Renderizado en máxima calidad',
                    Icons.high_quality,
                    true,
                  ),
                  const Divider(height: 1),
                  _settingRow(
                    context,
                    'Animaciones',
                    'Animaciones de interfaz suaves',
                    Icons.animation,
                    true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          Text(value, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _settingRow(BuildContext context, String title, String subtitle,
      IconData icon, bool enabled) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: AppConstants.neonBlue, size: 22),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle:
          Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 11)),
      trailing: Switch(
        value: enabled,
        onChanged: (_) {},
      ),
    );
  }
}
