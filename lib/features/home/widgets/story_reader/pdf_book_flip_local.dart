// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
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
    _loadPages();
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final fit = widget.fitCover ? BoxFit.cover : BoxFit.contain;
        final scaledWidth = width * widget.scale;
        final scaledHeight = height * widget.scale;

        final fullBleedPages = pages.map((img) {
          return SizedBox.expand(
            child: Stack(
              children: [
                FittedBox(
                  fit: fit,
                  alignment: widget.alignment,
                  child: SizedBox(
                    width: scaledWidth,
                    height: scaledHeight,
                    child: img,
                  ),
                ),
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
        }).toList();

        return PageFlipWidget(key: _controller, children: fullBleedPages);
      },
    );
  }
}
