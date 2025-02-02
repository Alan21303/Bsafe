import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/news_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetyResourcesScreen extends StatefulWidget {
  const SafetyResourcesScreen({super.key});

  @override
  State<SafetyResourcesScreen> createState() => _SafetyResourcesScreenState();
}

class _SafetyResourcesScreenState extends State<SafetyResourcesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Fetch news when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchCrimeNews();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: true,
            elevation: 0,
            stretch: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navyBlue, AppColors.crimsonRed],
                ),
              ),
              child: const FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Safety Resources',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.navyBlue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.navyBlue,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Latest News'),
                  Tab(text: 'Emergency'),
                  Tab(text: 'Guidelines'),
                ],
              ),
            ),
            pinned: true,
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildNewsTab(),
            _buildEmergencyTab(),
            _buildGuidelinesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsTab() {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.navyBlue),
            ),
          );
        }

        if (newsProvider.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    newsProvider.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => newsProvider.fetchCrimeNews(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navyBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (newsProvider.articles.isEmpty) {
          return const Center(
            child: Text('No news articles available'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => newsProvider.fetchCrimeNews(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: newsProvider.articles.length,
            itemBuilder: (context, index) {
              final article = newsProvider.articles[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: article.isSafetyRelated
                      ? const BorderSide(color: AppColors.crimsonRed, width: 1)
                      : BorderSide.none,
                ),
                child: InkWell(
                  onTap: () => launchUrl(Uri.parse(article.url)),
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.image.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              article.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported, 
                                        size: 40, 
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (article.isSafetyRelated) ...[
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.crimsonRed.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.warning_rounded,
                                          size: 14,
                                          color: AppColors.crimsonRed,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Safety Alert',
                                          style: TextStyle(
                                            color: AppColors.crimsonRed,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                            Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              article.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                if (article.author.isNotEmpty) ...[
                                  Icon(
                                    Icons.person_outline,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      article.author,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(article.published),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatDate(String publishedDate) {
    try {
      final date = DateTime.parse(publishedDate);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes} minutes ago';
        }
        return '${difference.inHours} hours ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      }

      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return publishedDate;
    }
  }

  Widget _buildEmergencyTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildEmergencyCard(
          'Police',
          Icons.local_police,
          'Call local law enforcement',
          '911',
          Colors.blue,
        ),
        _buildEmergencyCard(
          'Ambulance',
          Icons.healing,
          'Medical emergency services',
          '911',
          Colors.red,
        ),
        _buildEmergencyCard(
          'Fire Department',
          Icons.fire_truck,
          'Fire emergency services',
          '911',
          Colors.orange,
        ),
        _buildEmergencyCard(
          'Crisis Helpline',
          Icons.support_agent,
          '24/7 Crisis support',
          '1-800-273-8255',
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildGuidelinesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildGuidelineCard(
          'Personal Safety Tips',
          Icons.security,
          [
            'Stay aware of your surroundings',
            'Walk in well-lit areas',
            'Keep emergency contacts handy',
            'Trust your instincts',
            'Share your location with trusted contacts',
          ],
        ),
        _buildGuidelineCard(
          'Home Safety',
          Icons.home,
          [
            'Install security systems',
            'Keep doors and windows locked',
            'Use outdoor lighting',
            'Know your neighbors',
            'Have an emergency plan',
          ],
        ),
        _buildGuidelineCard(
          'Digital Safety',
          Icons.phone_android,
          [
            'Use strong passwords',
            'Enable two-factor authentication',
            'Be careful with personal information',
            'Update your devices regularly',
            'Use security apps',
          ],
        ),
      ],
    );
  }

  Widget _buildEmergencyCard(
    String title,
    IconData icon,
    String description,
    String number,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: () => launchUrl(Uri.parse('tel:$number')),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
          ),
          child: Text(number),
        ),
      ),
    );
  }

  Widget _buildGuidelineCard(String title, IconData icon, List<String> tips) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(icon, color: AppColors.navyBlue),
        title: Text(title),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tips
                  .map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle,
                                size: 16, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(child: Text(tip)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
} 