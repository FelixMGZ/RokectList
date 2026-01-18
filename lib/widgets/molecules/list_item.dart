import 'package:flutter/material.dart';
import '../atoms/custom_text.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final int icon;
  final int iconColor;
  final VoidCallback onTap;
  
  final double progress; 
  final String progressText;

  const ListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.progress = 0.0,
    this.progressText = "",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(iconColor).withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                IconData(icon, fontFamily: 'MaterialIcons'),
                color: Color(iconColor),
                size: 28,
              ),
            ),
            const SizedBox(width: 15),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    type: TextType.h2,
                  ),
                  const SizedBox(height: 4),
                  

                  if (progressText.isEmpty || progressText == "0/0")
                    CustomText(
                      subtitle,
                      type: TextType.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              subtitle,
                              type: TextType.caption,
                            ),
                            CustomText(
                              progressText,
                              type: TextType.caption,
                              color: Color(iconColor),
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(Color(iconColor)),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            
            const SizedBox(width: 10),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}