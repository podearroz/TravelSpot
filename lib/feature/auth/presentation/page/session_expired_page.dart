import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelspot/core/theme/app_theme.dart';
import 'package:travelspot/generated/l10n/app_localizations.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_event.dart';

class SessionExpiredPage extends StatelessWidget {
  const SessionExpiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone de alerta
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.paletteOf(Theme.of(context))
                      .warning()
                      .withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_clock,
                  size: 64,
                  color: AppTheme.paletteOf(Theme.of(context)).warning(),
                ),
              ),

              const SizedBox(height: 32),

              // Título
              Text(
                AppLocalizations.of(context).sessionExpired,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.paletteOf(Theme.of(context)).textPrimary(),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Descrição
              Text(
                AppLocalizations.of(context).sessionExpiredDescription,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                AppLocalizations.of(context).pleaseLoginAgain,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.paletteOf(Theme.of(context)).textSecondary(),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Botão de fazer login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _handleLogin(context),
                  icon: const Icon(Icons.login),
                  label: Text(AppLocalizations.of(context).loginButton),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    // Fazer logout primeiro para limpar sessão antiga
    context.read<AuthBloc>().add(LogoutRequested());

    // Navegar para tela de login
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }
}
