import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
