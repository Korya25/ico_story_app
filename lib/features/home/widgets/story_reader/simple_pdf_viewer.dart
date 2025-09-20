import 'package:flutter/material.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:page_flip/page_flip.dart';
import 'package:pdfx/pdfx.dart';

class SimplePdfViewer extends StatefulWidget {
  final String pdfPath;
  final Function(int currentPage, int totalPages)? onPageChanged;

  const SimplePdfViewer({super.key, required this.pdfPath, this.onPageChanged});

  @override
  State<SimplePdfViewer> createState() => _SimplePdfViewerState();
}

class _SimplePdfViewerState extends State<SimplePdfViewer> {
  final _controller = GlobalKey<PageFlipWidgetState>();
  List<Image> pages = [];
  int currentPage = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  Future<void> _loadPages() async {
    try {
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

      widget.onPageChanged?.call(currentPage + 1, pages.length);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.white),
      );
    }

    if (pages.isEmpty) {
      return const Center(
        child: Text(
          'خطأ في تحميل PDF',
          style: TextStyle(color: AppColors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: _nextPage,
      child: PageFlipWidget(
        key: _controller,
        children: pages.map((img) {
          return SizedBox.expand(
            child: FittedBox(fit: BoxFit.cover, child: img),
          );
        }).toList(),
      ),
    );
  }

  void _nextPage() {
    if (currentPage < pages.length - 1) {
      currentPage++;
    } else {
      currentPage = 0;
    }
    widget.onPageChanged?.call(currentPage + 1, pages.length);
  }
}
