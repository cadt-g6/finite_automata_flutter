import 'package:finite_automata_flutter/services/toast_service.dart';
import 'package:flutter/material.dart';

class FaFeatureCard extends StatelessWidget {
  const FaFeatureCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    required this.enable,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final bool enable;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          if (enable) {
            onPressed();
          } else {
            ToastService.showSnackbar(
              context: context,
              title: "Save this FA to try unlock the feature!",
              error: true,
            );
          }
        },
        child: Card(
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        ),
      ),
    );
  }
}
