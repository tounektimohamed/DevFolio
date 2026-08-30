import 'package:flutter/material.dart';
import 'package:folio/configs/configs.dart';
import 'package:folio/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppTheme.c!.backgroundSub,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.withOpacity(0.25)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.c!.shadowSub!,
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 84,
                  width: 84,
                  decoration: BoxDecoration(
                    color: AppTheme.c!.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.edit_note, size: 46, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  'Portfolio Studio',
                  style: AppText.h1b,
                ),
                const SizedBox(height: 6),
                Text(
                  'Créez votre compte et personnalisez votre portfolio',
                  textAlign: TextAlign.center,
                  style: AppText.l1?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => AuthService.instance.signInWithGoogle(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.c!.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.mark_email_read_outlined, size: 22),
                    label: Text('Continuer avec Google', style: AppText.b1b),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Se connecter permet de créer un compte local. Vos données sont enregistrées de façon privée.\n'
                  'Vous pourrez ensuite générer un lien public partageable.',
                  textAlign: TextAlign.center,
                  style: AppText.l2?.copyWith(
                    color: AppTheme.c!.textSub2,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}