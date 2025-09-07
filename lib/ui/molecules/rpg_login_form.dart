import 'package:flutter/material.dart';
import '../atoms/rpg_card.dart';
import '../atoms/rpg_text.dart';

class RPGLoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final List<Widget> actions;
  final String? title;

  const RPGLoginForm({
    super.key,
    required this.formKey,
    required this.fields,
    required this.actions,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return RPGCard(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            if (title != null) ...[
              RPGText(
                title!,
                style: RPGTextStyle.title,
                textAlign: TextAlign.center,
                withShadow: true,
              ),
              const SizedBox(height: 30),
            ],
            ...fields.map((field) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: field,
            )),
            const SizedBox(height: 10),
            ...actions.map((action) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: action,
            )),
          ],
        ),
      ),
    );
  }
}
