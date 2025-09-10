// lib/utils/icon_mapper.dart
import 'package:flutter/material.dart';

/// Trả về IconData tương ứng với tên icon (string) từ Firestore.
/// Nếu không tìm thấy sẽ trả về Icons.help_outline.
IconData iconFromString(String name) {
  // chuẩn hoá
  final key = name.trim().toLowerCase();

  const map = {
    'emoji_events': Icons.emoji_events,
    'school': Icons.school,
    'verified': Icons.verified,
    'code': Icons.code,
    'phone_iphone': Icons.phone_iphone,
    'palette': Icons.palette,
    'workspace_premium': Icons.workspace_premium,
    'verified_user': Icons.verified_user,
    'calendar_today': Icons.calendar_today,
    'language': Icons.public,
    'smartphone_outlined': Icons.smartphone_outlined,
    'flash_on': Icons.flash_on,
    'favorite_border': Icons.favorite_border,
    'star': Icons.star,
    'work': Icons.work,
    'email': Icons.email_outlined,
    'chat': Icons.chat_bubble_outline,
    'phone': Icons.phone,
    'analytics': Icons.insights,
    // thêm các tên thường dùng khác (mở rộng khi cần)
  };

  return map[key] ?? Icons.help_outline;
}
