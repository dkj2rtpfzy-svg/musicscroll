
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/service/auth/auth_service.dart';

enum AuthMode {
  signIn,
  signUp,
  resetPassword,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  AuthMode _mode = AuthMode.signIn;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _title {
    switch (_mode) {
      case AuthMode.signIn:
        return 'Bienvenue sur MusicScroll';
      case AuthMode.signUp:
        return 'Créer un compte';
      case AuthMode.resetPassword:
        return 'Mot de passe oublié';
    }
  }

  String get _buttonLabel {
    switch (_mode) {
      case AuthMode.signIn:
        return 'Se connecter';
      case AuthMode.signUp:
        return 'Créer mon compte';
      case AuthMode.resetPassword:
        return 'Envoyer le lien';
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      switch (_mode) {
        case AuthMode.signIn:
          await AuthService.signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );

          _showMessage('Connexion réussie. Bienvenue !');
          break;

        case AuthMode.signUp:
          final response = await AuthService.signUp(
            email: _emailController.text,
            password: _passwordController.text,
          );

          if (response.session == null) {
            _showMessage(
              'Un e-mail de confirmation vient de vous être envoyé. '
              'Consultez votre boîte de réception.',
            );
          } else {
            _showMessage('Votre compte MusicScroll est créé !');
          }
          break;

        case AuthMode.resetPassword:
          await AuthService.resetPassword(_emailController.text);

          _showMessage(
            'Si cette adresse est enregistrée, '
            'vous recevrez un e-mail de réinitialisation.',
          );

          setState(() => _mode = AuthMode.signIn);
          break;
      }
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (error) {
      _showMessage(
        'Une erreur est survenue. Vérifiez votre connexion internet.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir votre adresse e-mail';
    }

    final email = value.trim();

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Adresse e-mail invalide';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (_mode == AuthMode.resetPassword) return null;

    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre mot de passe';
    }

    if (_mode == AuthMode.signUp && value.length < 8) {
      return '8 caractères minimum';
    }

    return null;
  }

  String? _validateConfirmation(String? value) {
    if (_mode != AuthMode.signUp) return null;

    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null;
  }

  void _changeMode(AuthMode mode) {
    setState(() {
      _mode = mode;
      _formKey.currentState?.reset();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.music_note_rounded,
                      size: 64,
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'MusicScroll',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),

                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Adresse e-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateEmail,
                    ),

                    if (_mode != AuthMode.resetPassword) ...[
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: _mode == AuthMode.signUp
                            ? TextInputAction.next
                            : TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                    ],

                    if (_mode == AuthMode.signUp) ...[
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirmer le mot de passe',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateConfirmation,
                      ),
                    ],

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _submit,
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(_buttonLabel),
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (_mode == AuthMode.signIn) ...[
                      TextButton(
                        onPressed: () => _changeMode(AuthMode.resetPassword),
                        child: const Text('Mot de passe oublié ?'),
                      ),

                      TextButton(
                        onPressed: () => _changeMode(AuthMode.signUp),
                        child: const Text('Créer un nouveau compte'),
                      ),
                    ],

                    if (_mode == AuthMode.signUp)
                      TextButton(
                        onPressed: () => _changeMode(AuthMode.signIn),
                        child: const Text('Déjà un compte ? Se connecter'),
                      ),

                    if (_mode == AuthMode.resetPassword)
                      TextButton(
                        onPressed: () => _changeMode(AuthMode.signIn),
                        child: const Text('Retour à la connexion'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
