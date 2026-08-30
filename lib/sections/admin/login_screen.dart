import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folio/configs/configs.dart';
import 'package:folio/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _signIn() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await AuthService.instance.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'operation-not-allowed':
          msg = 'Le fournisseur Google est désactivé. Activez-le dans la '
              'console Firebase : Authentication → Sign-in method → Google.';
          break;
        case 'unauthorized-domain':
        case 'fromUrlDenylisted':
        case 'unsupported-domain':
          msg = 'Ce domaine n’est pas autorisé pour la connexion Google. '
              'Ajoutez « dev-folio-azure.vercel.app » dans la console Firebase : '
              'Authentication → Settings → Authorized domains.';
          break;
        case 'popup-blocked':
          msg = 'Le popup Google a été bloqué par le navigateur. '
              'Autorisez les fenêtres popup pour ce site, puis réessayez.';
          break;
        case 'popup-closed-by-user':
          msg = 'Fenêtre de connexion fermée. Vous pouvez réessayer.';
          break;
        case 'network-request-failed':
          msg = 'Erreur réseau. Vérifiez votre connexion et réessayez.';
          break;
        default:
          msg = 'La connexion a échoué : ${e.code}\n${e.message ?? ''}';
      }
      if (mounted) setState(() => _error = msg);
    } on MissingPluginException {
      if (mounted) {
        setState(() => _error = 'Google Sign-In indisponible ici (web requis).');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Erreur inattendue : $e');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

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
                    color: AppTheme.c!.primary!,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.edit_note,
                      size: 46, color: Colors.white),
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
                    onPressed: _busy ? null : _signIn,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.c!.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: _busy
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.mark_email_read_outlined, size: 22),
                    label: Text(
                      _busy ? 'Connexion…' : 'Continuer avec Google',
                      style: AppText.b1b,
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.c!.primary!.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.c!.primary!.withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      _error!,
                      style: AppText.l1?.copyWith(height: 1.4),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Text(
                  'Se connecter permet de créer un compte local. Vos données sont '
                  'enregistrées de façon privée.\n'
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