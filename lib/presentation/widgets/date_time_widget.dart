import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.headingtext,
    required this.OnTap,
  });

  final IconData icon;
  final String text;
  final String headingtext;
  final VoidCallback OnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headingtext,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(6),
        Material(
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: OnTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(icon),
                    const Gap(10),
                    Text(text),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
