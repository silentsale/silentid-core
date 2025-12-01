import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/data/help_center_data.dart';

/// Help Article screen
/// Level 7 Gamification + Level 7 Interactivity
/// Displays a single help article with formatted content
class HelpArticleScreen extends StatefulWidget {
  final String categorySlug;
  final String articleSlug;

  const HelpArticleScreen({
    super.key,
    required this.categorySlug,
    required this.articleSlug,
  });

  @override
  State<HelpArticleScreen> createState() => _HelpArticleScreenState();
}

class _HelpArticleScreenState extends State<HelpArticleScreen>
    with SingleTickerProviderStateMixin {
  // Level 7: Animation controller
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Level 7: Initialize animations
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final article = HelpCenterData.getArticleBySlug(widget.categorySlug, widget.articleSlug);
    final category = HelpCenterData.getCategoryBySlug(widget.categorySlug);

    if (article == null) {
      return Scaffold(
        backgroundColor: AppTheme.pureWhite,
        appBar: AppBar(
          backgroundColor: AppTheme.pureWhite,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.deepBlack),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.article_outlined,
                size: 64,
                color: AppTheme.neutralGray300,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Article not found',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () => context.go('/help'),
                child: const Text('Back to Help Center'),
              ),
            ],
          ),
        ),
      );
    }

    // Get prev/next articles
    final articles = category?.articles ?? [];
    final currentIndex = articles.indexWhere((a) => a.slug == widget.articleSlug);
    final prevArticle = currentIndex > 0 ? articles[currentIndex - 1] : null;
    final nextArticle = currentIndex < articles.length - 1 ? articles[currentIndex + 1] : null;

    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.deepBlack),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new, color: AppTheme.primaryPurple),
            onPressed: () async {
              final url = Uri.parse(
                '${HelpCenterData.webUrl}/${article.categorySlug}/${article.slug}',
              );
              try {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } catch (e) {
                // Ignore errors
              }
            },
            tooltip: 'Open in browser',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/help'),
                    child: Text(
                      'Help Center',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  ),
                  Text(
                    ' / ',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/help/${widget.categorySlug}'),
                    child: Text(
                      article.category,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                article.title,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.deepBlack,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                article.summary,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppTheme.neutralGray700,
                  height: 1.5,
                ),
              ),
            ),

            // Screen path if available
            if (article.screenPath != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.softLilac,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.navigation_outlined,
                        size: 14,
                        color: AppTheme.primaryPurple,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        article.screenPath!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.lg),

            // Divider
            Divider(height: 1, color: AppTheme.neutralGray300),

            const SizedBox(height: AppSpacing.lg),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _buildContent(article.content),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Prev/Next navigation
            if (prevArticle != null || nextArticle != null)
              _buildNavigation(context, prevArticle, nextArticle),

            const SizedBox(height: AppSpacing.lg),

            // Contact support
            _buildContactSupport(),

            const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(String content) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    bool inTable = false;
    List<String> tableRows = [];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Handle tables
      if (line.startsWith('|')) {
        if (!inTable) {
          inTable = true;
          tableRows = [];
        }
        tableRows.add(line);
        continue;
      } else if (inTable) {
        // End of table
        widgets.add(_buildTable(tableRows));
        widgets.add(const SizedBox(height: AppSpacing.md));
        inTable = false;
        tableRows = [];
      }

      // H2 headers
      if (line.startsWith('## ')) {
        widgets.add(const SizedBox(height: AppSpacing.md));
        widgets.add(Text(
          line.substring(3),
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.deepBlack,
          ),
        ));
        widgets.add(const SizedBox(height: AppSpacing.sm));
        continue;
      }

      // Bold lines starting with **
      if (line.startsWith('**') && line.endsWith('**')) {
        widgets.add(Text(
          line.substring(2, line.length - 2),
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
            height: 1.6,
          ),
        ));
        widgets.add(const SizedBox(height: AppSpacing.xs));
        continue;
      }

      // Bullet points
      if (line.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '•  ',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppTheme.primaryPurple,
                  height: 1.6,
                ),
              ),
              Expanded(
                child: _buildFormattedText(line.substring(2)),
              ),
            ],
          ),
        ));
        widgets.add(const SizedBox(height: AppSpacing.xxs));
        continue;
      }

      // Numbered lists
      final numberedMatch = RegExp(r'^(\d+)\. (.*)$').firstMatch(line);
      if (numberedMatch != null) {
        final number = numberedMatch.group(1)!;
        final text = numberedMatch.group(2)!;
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  '$number.',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
                    height: 1.6,
                  ),
                ),
              ),
              Expanded(
                child: _buildFormattedText(text),
              ),
            ],
          ),
        ));
        widgets.add(const SizedBox(height: AppSpacing.xxs));
        continue;
      }

      // Indented items (sub-bullets)
      if (line.startsWith('   - ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '◦  ',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.neutralGray700,
                  height: 1.6,
                ),
              ),
              Expanded(
                child: _buildFormattedText(line.substring(5)),
              ),
            ],
          ),
        ));
        widgets.add(const SizedBox(height: AppSpacing.xxs));
        continue;
      }

      // Empty lines
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: AppSpacing.sm));
        continue;
      }

      // Regular paragraph
      widgets.add(_buildFormattedText(line));
      widgets.add(const SizedBox(height: AppSpacing.xs));
    }

    // Handle any remaining table
    if (inTable && tableRows.isNotEmpty) {
      widgets.add(_buildTable(tableRows));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildFormattedText(String text) {
    // Handle inline formatting: **bold** and inline text
    final spans = <TextSpan>[];
    final boldPattern = RegExp(r'\*\*([^*]+)\*\*');

    int lastEnd = 0;
    for (final match in boldPattern.allMatches(text)) {
      // Add text before match
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: GoogleFonts.inter(
            fontSize: 15,
            color: AppTheme.neutralGray700,
            height: 1.6,
          ),
        ));
      }
      // Add bold text
      spans.add(TextSpan(
        text: match.group(1),
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppTheme.deepBlack,
          height: 1.6,
        ),
      ));
      lastEnd = match.end;
    }
    // Add remaining text
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: GoogleFonts.inter(
          fontSize: 15,
          color: AppTheme.neutralGray700,
          height: 1.6,
        ),
      ));
    }

    if (spans.isEmpty) {
      return Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 15,
          color: AppTheme.neutralGray700,
          height: 1.6,
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildTable(List<String> rows) {
    if (rows.isEmpty) return const SizedBox.shrink();

    // Parse header
    final header = rows[0].split('|').where((c) => c.trim().isNotEmpty).map((c) => c.trim()).toList();

    // Skip separator row (row with dashes)
    final dataRows = rows
        .skip(2)
        .map((row) => row.split('|').where((c) => c.trim().isNotEmpty).map((c) => c.trim()).toList())
        .where((row) => row.isNotEmpty)
        .toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.neutralGray300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(color: AppTheme.neutralGray300),
            verticalInside: BorderSide(color: AppTheme.neutralGray300),
          ),
          children: [
            // Header row
            TableRow(
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
              ),
              children: header.map((cell) => Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Text(
                  cell,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
                  ),
                ),
              )).toList(),
            ),
            // Data rows
            ...dataRows.map((row) => TableRow(
              children: row.map((cell) => Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Text(
                  cell,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              )).toList(),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigation(
    BuildContext context,
    HelpArticle? prevArticle,
    HelpArticle? nextArticle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          if (prevArticle != null)
            Expanded(
              child: _buildNavButton(
                context,
                'Previous',
                prevArticle.title,
                Icons.chevron_left,
                () => context.go('/help/${prevArticle.categorySlug}/${prevArticle.slug}'),
                isLeft: true,
              ),
            )
          else
            const Spacer(),
          const SizedBox(width: AppSpacing.sm),
          if (nextArticle != null)
            Expanded(
              child: _buildNavButton(
                context,
                'Next',
                nextArticle.title,
                Icons.chevron_right,
                () => context.go('/help/${nextArticle.categorySlug}/${nextArticle.slug}'),
                isLeft: false,
              ),
            )
          else
            const Spacer(),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String label,
    String title,
    IconData icon,
    VoidCallback onTap, {
    required bool isLeft,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppTheme.neutralGray300.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLeft) Icon(icon, size: 16, color: AppTheme.primaryPurple),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!isLeft) Icon(icon, size: 16, color: AppTheme.primaryPurple),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.deepBlack,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: isLeft ? TextAlign.left : TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSupport() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppTheme.neutralGray300.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: AppTheme.neutralGray700,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Still need help?',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.deepBlack,
                    ),
                  ),
                  Text(
                    'Contact our support team',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                final url = Uri.parse(
                  'mailto:support@silentid.co.uk?subject=Help%20with:%20${widget.articleSlug}',
                );
                try {
                  await launchUrl(url);
                } catch (e) {
                  // Ignore errors
                }
              },
              child: Text(
                'Contact',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
