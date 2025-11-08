import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/configuracoes_viewmodel.dart';
import '../ui/screens/templates/app_template.dart';
import '../ui/atoms/rpg_text.dart';

/// View para configurações usando arquitetura MVVM
class ConfiguracoesView extends StatefulWidget {
  const ConfiguracoesView({super.key});

  @override
  State<ConfiguracoesView> createState() => _ConfiguracoesViewState();
}

class _ConfiguracoesViewState extends State<ConfiguracoesView> {
  @override
  void initState() {
    super.initState();
    // Carrega configurações quando a tela inicia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfiguracoesViewModel>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfiguracoesViewModel>(
      builder: (context, configViewModel, child) {
        if (configViewModel.isLoading) {
          return AppTemplate(
            title: 'Configurações',
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.amber),
                  SizedBox(height: 16),
                  RPGText('Carregando configurações...', style: RPGTextStyle.body),
                ],
              ),
            ),
          );
        }

        return AppTemplate(
          title: 'Configurações',
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Seção Aparência
              _buildSectionCard(
                title: 'Aparência',
                icon: Icons.palette,
                children: [
                  _buildSwitchTile(
                    title: 'Modo Escuro',
                    subtitle: 'Usar tema escuro na aplicação',
                    value: configViewModel.isDarkMode,
                    onChanged: configViewModel.toggleDarkMode,
                    icon: Icons.dark_mode,
                  ),
                  _buildSwitchTile(
                    title: 'Seguir Sistema',
                    subtitle: 'Usar configuração do sistema operacional',
                    value: configViewModel.useSystemTheme,
                    onChanged: configViewModel.toggleSystemTheme,
                    icon: Icons.settings_system_daydream,
                  ),
                  _buildSliderTile(
                    title: 'Velocidade de Animação',
                    subtitle: 'Ajustar velocidade das animações',
                    value: configViewModel.animationSpeed,
                    min: 0.5,
                    max: 2.0,
                    divisions: 3,
                    onChanged: configViewModel.setAnimationSpeed,
                    icon: Icons.speed,
                    valueLabel: '${(configViewModel.animationSpeed * 100).toInt()}%',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Seção Notificações
              _buildSectionCard(
                title: 'Notificações',
                icon: Icons.notifications,
                children: [
                  _buildSwitchTile(
                    title: 'Notificações',
                    subtitle: 'Receber notificações do aplicativo',
                    value: configViewModel.enableNotifications,
                    onChanged: configViewModel.toggleNotifications,
                    icon: Icons.notifications_active,
                  ),
                  _buildSwitchTile(
                    title: 'Efeitos Sonoros',
                    subtitle: 'Reproduzir sons do aplicativo',
                    value: configViewModel.enableSoundEffects,
                    onChanged: configViewModel.toggleSoundEffects,
                    icon: Icons.volume_up,
                  ),
                  _buildSwitchTile(
                    title: 'Vibração',
                    subtitle: 'Vibrar em interações importantes',
                    value: configViewModel.enableVibration,
                    onChanged: configViewModel.toggleVibration,
                    icon: Icons.vibration,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Seção Jogo
              _buildSectionCard(
                title: 'Jogo',
                icon: Icons.games,
                children: [
                  _buildSwitchTile(
                    title: 'Tutorial',
                    subtitle: 'Mostrar dicas e tutoriais',
                    value: configViewModel.showTutorial,
                    onChanged: configViewModel.toggleTutorial,
                    icon: Icons.help_outline,
                  ),
                  _buildSwitchTile(
                    title: 'Salvamento Automático',
                    subtitle: 'Salvar automaticamente as alterações',
                    value: configViewModel.autoSaveEnabled,
                    onChanged: configViewModel.toggleAutoSave,
                    icon: Icons.save,
                  ),
                  _buildDropdownTile(
                    title: 'Idioma',
                    subtitle: 'Idioma da aplicação',
                    value: configViewModel.language,
                    items: configViewModel.availableLanguages
                        .map((lang) => DropdownMenuItem(
                              value: lang['code'],
                              child: Text(lang['name']!),
                            ))
                        .toList(),
                    onChanged: configViewModel.setLanguage,
                    icon: Icons.language,
                    displayValue: configViewModel.currentLanguageName,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Seção Avançado
              _buildSectionCard(
                title: 'Avançado',
                icon: Icons.settings_applications,
                children: [
                  _buildSwitchTile(
                    title: 'Modo Debug',
                    subtitle: 'Mostrar informações de debug',
                    value: configViewModel.enableDebugMode,
                    onChanged: configViewModel.toggleDebugMode,
                    icon: Icons.bug_report,
                  ),
                  _buildSwitchTile(
                    title: 'Recursos Beta',
                    subtitle: 'Habilitar recursos experimentais',
                    value: configViewModel.enableBetaFeatures,
                    onChanged: configViewModel.toggleBetaFeatures,
                    icon: Icons.science,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Seção Ações
              _buildSectionCard(
                title: 'Ações',
                icon: Icons.settings_backup_restore,
                children: [
                  _buildActionTile(
                    title: 'Exportar Configurações',
                    subtitle: 'Fazer backup das suas configurações',
                    icon: Icons.file_upload,
                    onTap: () => _exportSettings(configViewModel),
                  ),
                  _buildActionTile(
                    title: 'Importar Configurações',
                    subtitle: 'Restaurar configurações de um backup',
                    icon: Icons.file_download,
                    onTap: () => _importSettings(configViewModel),
                  ),
                  _buildActionTile(
                    title: 'Restaurar Padrões',
                    subtitle: 'Voltar às configurações originais',
                    icon: Icons.restore,
                    onTap: () => _resetToDefaults(configViewModel),
                    isDestructive: true,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Informações do app
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const RPGText(
                        'RPG Character Manager',
                        style: RPGTextStyle.subtitle,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 8),
                      const Text('Versão 1.0.0'),
                      const SizedBox(height: 4),
                      Text(
                        'Desenvolvido com ❤️ para RPG players',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.amber),
                const SizedBox(width: 8),
                RPGText(
                  title,
                  style: RPGTextStyle.subtitle,
                  color: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.amber,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
    required IconData icon,
    required String valueLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey),
          title: Text(title),
          subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          trailing: Text(valueLabel, style: const TextStyle(color: Colors.amber)),
          contentPadding: EdgeInsets.zero,
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: Colors.amber,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String) onChanged,
    required IconData icon,
    required String displayValue,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: DropdownButton<String>(
        value: value,
        items: items,
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        underline: Container(),
        dropdownColor: Theme.of(context).cardColor,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _exportSettings(ConfiguracoesViewModel viewModel) {
    final settings = viewModel.exportSettings();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurações Exportadas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Suas configurações foram exportadas com sucesso!'),
            const SizedBox(height: 16),
            Text(
              'Exportado em: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _importSettings(ConfiguracoesViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Importar Configurações'),
        content: const Text('Esta funcionalidade estará disponível em breve. Você poderá restaurar suas configurações de um arquivo de backup.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults(ConfiguracoesViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar Configurações'),
        content: const Text('Tem certeza que deseja restaurar todas as configurações para os valores padrão? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await viewModel.resetToDefaults();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configurações restauradas para o padrão'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Restaurar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}