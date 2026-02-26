import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../theme.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../contact_config.dart';
import '../strings.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    const to = contactEmail;
    final subject = Uri.encodeComponent(_subjectController.text.trim());
    final body = Uri.encodeComponent('Name: ${_nameController.text.trim()}\nEmail: ${_emailController.text.trim()}\n\n${_messageController.text.trim()}');
    final mailto = 'mailto:$to?subject=$subject&body=$body';

    try {
      await launchUrlString(mailto);
    } catch (e) {
      // ignore - fallback will still show confirmation
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: kikiOrange.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: kikiOrange, size: 36),
              ),
              const SizedBox(height: 20),
              const Text(
                Strings.contactDialogSent,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kikiDeep),
              ),
              const SizedBox(height: 8),
              Text(
                Strings.contactDialogThanks,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                  child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(Strings.contactDialogClose),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroBanner(
            title: Strings.contactTitle,
            subtitle: Strings.contactSubtitle,
            ctaText: Strings.contactCta,
            assetPath: 'assets/images/cat_phone.svg',
          ),

          const SizedBox(height: 32),
          Row(
            children: [
              Container(
                width: 3,
                height: 22,
                decoration: BoxDecoration(color: kikiOrange, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 10),
              Text(Strings.contactSectionGetInTouch, style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 14),

          _ContactInfo(),

          const SizedBox(height: 40),
          Row(
            children: [
              Container(
                width: 3,
                height: 22,
                decoration: BoxDecoration(color: kikiOrange, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 10),
              Text(Strings.contactSectionSendMessage, style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 20),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: Strings.contactLabelName),
                      textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().isEmpty) ? Strings.contactValidationName : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: Strings.contactLabelEmail),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return Strings.contactValidationEmail;
                        if (!_emailRegex.hasMatch(v.trim())) return Strings.contactValidationEmailValid;
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(labelText: Strings.contactLabelSubject),
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty) ? Strings.contactValidationSubject : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: Strings.contactLabelMessage,
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      validator: (v) => (v == null || v.trim().isEmpty) ? Strings.contactValidationMessage : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(Strings.contactSendMessageButton),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContactTile(icon: Icons.email_outlined, label: contactEmail, color: kikiOrange),
        SizedBox(height: 12),
        _ContactTile(icon: Icons.location_on_outlined, label: Strings.contactLocation, color: Color(0xFF6B7280)),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ContactTile({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563))),
      ],
    );
  }
}
