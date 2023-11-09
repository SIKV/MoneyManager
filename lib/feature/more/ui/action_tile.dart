import 'package:flutter/material.dart';

class ActionTile extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  final String title;
  final String? subtitle;

  const ActionTile({Key? key,
    this.onTap,
    this.leadingIcon,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: leadingIcon != null ? Icon(leadingIcon) : null,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle ?? '') : null,
      trailing: onTap != null ? const Icon(Icons.arrow_forward_ios_rounded, size: 16) : null,
    );
  }
}
