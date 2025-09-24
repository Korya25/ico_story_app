// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:page_flip/page_flip.dart';
import 'package:pdfx/pdfx.dart';

class PdfBookFlipLocal extends StatefulWidget {
  const PdfBookFlipLocal({
    super.key,
    required this.pdfPath,
    this.fitCover = true,
    this.scale = 1.0,
    this.alignment = Alignment.center,
  });

  final String pdfPath;
  final bool fitCover;
  final double scale;
  final Alignment alignment;

  @override
  State<PdfBookFlipLocal> createState() => _PdfBookFlipLocalState();
}

class _PdfBookFlipLocalState extends State<PdfBookFlipLocal> {
  final _controller = GlobalKey<PageFlipWidgetState>();
  List<Image> pages = [];

  @override
  void initState() {
    super.initState();
    // إخفاء status bar و navigation bar للشاشة الكاملة
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _loadPages();
  }

  @override
  void dispose() {
    // إرجاع النظام إلى الوضع الطبيعي عند الخروج
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _loadPages() async {
    final doc = await PdfDocument.openAsset(widget.pdfPath);

    for (int i = 1; i <= doc.pagesCount; i++) {
      final page = await doc.getPage(i);

      final pageImage = await page.render(
        width: page.width,
        height: page.height,
        format: PdfPageImageFormat.png,
      );

      if (pageImage != null) {
        pages.add(Image.memory(pageImage.bytes));
      }

      await page.close();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.white)),
      );
    }

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: SizedBox.expand(
          child: PageFlipWidget(
            key: _controller,
            children: pages.map((img) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // الصورة بملء الشاشة الكامل
                    Positioned.fill(
                      child: Image(
                        image: img.image,
                        fit: BoxFit
                            .cover, // أو BoxFit.fill لملء كامل بدون احتفاظ بنسبة العرض للارتفاع
                        alignment: widget.alignment,
                      ),
                    ),
                    // الـ gradient العلوي (اختياري - يمكن إزالته)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primary.withOpacity(0.85),
                              AppColors.primary.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
