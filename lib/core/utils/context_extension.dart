import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ContextExtension on BuildContext {
  bool get isTablet => ScreenUtil().screenWidth >= 600;
}
