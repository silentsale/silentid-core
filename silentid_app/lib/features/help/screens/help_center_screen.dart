import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/data/help_center_data.dart';

/// Help Center main screen
/// Level 7 Gamification + Level 7 Interactivity
/// Displays all categories and search functionality
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  // Level 7: Animation controller
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  List<HelpArticle> _searchResults = [];
  bool _isSearching = false;

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
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    } else {
      setState(() {
        _searchResults = HelpCenterData.searchArticles(query);
        _isSearching = true;
      });
    }
  }

  Future<void> _openWebHelp() async {
    final Uri url = Uri.parse(HelpCenterData.webUrl);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open help center website'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.deepBlack),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Help Center',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new, color: AppTheme.primaryPurple),
            onPressed: _openWebHelp,
            tooltip: 'Open in browser',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Search bar
            Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search for help...',
                hintStyle: GoogleFonts.inter(
                  color: AppTheme.neutralGray700,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.neutralGray700,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.neutralGray300.withValues(alpha: 0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),

            // Content
            Expanded(
              child: _isSearching ? _buildSearchResults() : _buildCategories(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppTheme.neutralGray300,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No results found',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.neutralGray700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Try different keywords',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final article = _searchResults[index];
        return _buildArticleCard(article);
      },
    );
  }

  Widget _buildArticleCard(HelpArticle article) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.neutralGray300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        title: Text(
          article.title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xxs),
            Text(
              article.summary,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.neutralGray700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                article.category,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppTheme.neutralGray700,
        ),
        onTap: () {
          context.push('/help/${article.categorySlug}/${article.slug}');
        },
      ),
    );
  }

  Widget _buildCategories() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        // Quick help section
        _buildQuickHelpSection(),

        const SizedBox(height: AppSpacing.lg),

        // Categories header
        Text(
          'BROWSE BY TOPIC',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Category grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
          ),
          itemCount: HelpCenterData.categories.length,
          itemBuilder: (context, index) {
            final category = HelpCenterData.categories[index];
            return _buildCategoryCard(category);
          },
        ),

        const SizedBox(height: AppSpacing.xl),

        // Contact support section
        _buildContactSection(),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildQuickHelpSection() {
    final popularArticles = [
      HelpCenterData.getArticleBySlug('getting-started', 'what-is-silentid'),
      HelpCenterData.getArticleBySlug('trustscore', 'how-it-works'),
      HelpCenterData.getArticleBySlug('login-security', 'passwordless-explained'),
    ].whereType<HelpArticle>().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'POPULAR ARTICLES',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...popularArticles.map((article) => _buildQuickLink(article)),
      ],
    );
  }

  Widget _buildQuickLink(HelpArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppTheme.softLilac.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          Icons.article_outlined,
          color: AppTheme.primaryPurple,
          size: 20,
        ),
        title: Text(
          article.title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.deepBlack,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppTheme.primaryPurple,
          size: 20,
        ),
        onTap: () {
          context.push('/help/${article.categorySlug}/${article.slug}');
        },
      ),
    );
  }

  Widget _buildCategoryCard(HelpCategory category) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.neutralGray300),
      ),
      child: InkWell(
        onTap: () {
          context.push('/help/${category.slug}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.softLilac,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  category.icon,
                  color: AppTheme.primaryPurple,
                  size: 22,
                ),
              ),
              const Spacer(),
              Text(
                category.title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${category.articles.length} articles',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.neutralGray700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryPurple.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent,
            color: AppTheme.primaryPurple,
            size: 40,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "Can't find what you need?",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepBlack,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Our support team is here to help',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.neutralGray700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final Uri url = Uri.parse(
                  'mailto:support@silentid.co.uk?subject=SilentID%20Support%20Request',
                );
                try {
                  await launchUrl(url);
                } catch (e) {
                  // Ignore errors
                }
              },
              icon: const Icon(Icons.email_outlined),
              label: const Text('Contact Support'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
