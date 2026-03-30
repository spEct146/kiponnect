import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiponnect/core/constants/app_colors.dart';
import 'package:kiponnect/domain/entities/post_entity.dart';
import 'package:kiponnect/presentation/providers/local_data_provider.dart';
import 'package:kiponnect/presentation/widgets/common/burger_menu.dart';
import 'package:kiponnect/presentation/widgets/common/post_card.dart';
import 'package:kiponnect/presentation/widgets/navigation/kiponnect_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    // Simulate adding a new post
    final localDataProvider = Provider.of<LocalDataProvider>(context, listen: false);
    localDataProvider.addPost(
      authorName: 'New User',
      content: 'Fresh post from the timeline refresh!',
    );
  }

  void _navigationTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Handle different navigation targets
    switch (index) {
      case 0:
        // Home - already here
        break;
      case 1:
        // Search/Academic
        Navigator.of(context).pushNamed('/academic');
        break;
      case 2:
        // Create
        _showCreateMenu();
        break;
      case 3:
        // Chats
        Navigator.of(context).pushNamed('/messenger');
        break;
      case 4:
        // Profile
        Navigator.of(context).pushNamed('/profile');
        break;
    }
  }

  void _showCreateMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create New',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 24),
            _CreateOptionTile(
              icon: Icons.edit,
              label: 'Post',
              onTap: () {
                Navigator.pop(context);
                _createPost();
              },
            ),
            SizedBox(height: 12),
            _CreateOptionTile(
              icon: Icons.question_answer,
              label: 'Ask Question',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ask question feature coming soon!')),
                );
              },
            ),
            SizedBox(height: 12),
            _CreateOptionTile(
              icon: Icons.note_add,
              label: 'Share Notes',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Share notes feature coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  Future<void> _createPost() async {
    final TextEditingController contentController = TextEditingController();
    XFile? selectedImage;
    
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Create Post',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(color: AppColors.borderColor),
              SizedBox(height: 16),
              
              // Content Input Area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Text Field with Paperclip
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.darkSurfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryOrange),
                        ),
                        child: Column(
                          children: [
                            // Text Field
                            TextField(
                              controller: contentController,
                              maxLines: 5,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'What\'s on your mind?',
                                hintStyle: TextStyle(color: AppColors.textSecondary),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) => setState(() {}),
                            ),
                            // Image Preview or Paperclip Button
                            if (selectedImage != null) ...[
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border(top: BorderSide(color: AppColors.borderColor)),
                                ),
                                child: Row(
                                  children: [
                                    // Thumbnail
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.darkSurfaceVariant,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.image,
                                          color: AppColors.primaryOrange,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Image attached',
                                        style: TextStyle(color: AppColors.textSecondary),
                                      ),
                                    ),
                                    // Remove button
                                    IconButton(
                                      icon: Icon(Icons.close, color: AppColors.errorRed, size: 20),
                                      onPressed: () => setState(() => selectedImage = null),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              // Paperclip Button
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border(top: BorderSide(color: AppColors.borderColor)),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.attach_file, color: AppColors.primaryOrange),
                                      onPressed: () async {
                                        try {
                                          final ImagePicker picker = ImagePicker();
                                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                          if (image != null) {
                                            setState(() => selectedImage = image);
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Failed to pick image: $e')),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                    Text(
                                      'Attach photo',
                                      style: TextStyle(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Post Button
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: contentController.text.trim().isNotEmpty
                    ? () {
                        try {
                          final localDataProvider = Provider.of<LocalDataProvider>(context, listen: false);
                          localDataProvider.addPost(
                            authorName: 'You',
                            content: contentController.text.trim(),
                            imageUrls: selectedImage != null ? [selectedImage!.path] : null,
                          );
                          Navigator.pop(context);
                          // Show snackbar after a short delay to ensure context is still valid
                          Future.delayed(Duration(milliseconds: 100), () {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Post created successfully!')),
                              );
                            }
                          });
                        } catch (e) {
                          print('Error creating post: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to create post: $e')),
                          );
                        }
                      }
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: contentController.text.trim().isNotEmpty
                      ? AppColors.primaryOrange
                      : AppColors.darkSurfaceVariant,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: contentController.text.trim().isNotEmpty
                        ? Colors.white
                        : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentsModal(BuildContext context, Post post) {
    final TextEditingController commentController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Comments (${post.commentsCount})',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(color: AppColors.borderColor),
              // Comments List
              Expanded(
                child: post.comments.isEmpty
                  ? Center(
                      child: Text(
                        'No comments yet. Be the first!',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: post.comments.length,
                      itemBuilder: (context, index) {
                        final comment = post.comments[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.darkSurfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryOrange,
                                    ),
                                    child: Center(
                                      child: Text(
                                        comment.authorName.substring(0, 1).toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    comment.authorName,
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Spacer(),
                                  Text(
                                    _formatTimestamp(comment.createdAt),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                comment.content,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
              // Add Comment Input
              Container(
                padding: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.borderColor)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: AppColors.primaryOrange),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: AppColors.primaryOrange),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryOrange,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          if (commentController.text.trim().isNotEmpty) {
                            final localDataProvider = Provider.of<LocalDataProvider>(context, listen: false);
                            localDataProvider.addComment(
                              post.id,
                              'You', // In a real app, this would come from user profile
                              commentController.text.trim(),
                            );
                            commentController.clear();
                            // Close and reopen to refresh comments
                            Navigator.pop(context);
                            _showCommentsModal(context, post);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.darkBackground,
      drawer: BurgerMenu(),
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryOrange,
            ),
            child: Center(
              child: Text(
                'K',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        title: Text('Kiponnect'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ],
      ),
      body: Consumer<LocalDataProvider>(
        builder: (context, localDataProvider, child) {
          return RefreshIndicator(
            key: _refreshKey,
            onRefresh: _handleRefresh,
            color: AppColors.primaryOrange,
            backgroundColor: AppColors.darkSurface,
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: localDataProvider.posts.length,
              itemBuilder: (context, index) {
                final post = localDataProvider.posts[index];
                return PostCard(
                  authorName: post.authorName,
                  timestamp: _formatTimestamp(post.createdAt),
                  content: post.content,
                  imageUrls: post.imageUrls,
                  likesCount: post.likesCount,
                  commentsCount: post.commentsCount,
                  sharesCount: post.sharesCount,
                  isLiked: post.isLiked,
                  onLike: () {
                    if (!mounted) return;
                    final provider = Provider.of<LocalDataProvider>(context, listen: false);
                    provider.toggleLike(post.id);
                  },
                  onComment: () {
                    if (!mounted) return;
                    final provider = Provider.of<LocalDataProvider>(context, listen: false);
                    _showCommentsModal(context, post);
                  },
                  onShare: () {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Share feature coming soon!')),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: KiponnectBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _navigationTapped,
        items: [
          NavBarItem(
            icon: Icons.home,
            label: 'Home',
          ),
          NavBarItem(
            icon: Icons.search,
            label: 'Search',
          ),
          NavBarItem(
            icon: Icons.add,
            label: 'Create',
          ),
          NavBarItem(
            icon: Icons.chat,
            label: 'Chats',
          ),
          NavBarItem(
            icon: Icons.person,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _CreateOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CreateOptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkSurfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryOrange,
              size: 28,
            ),
            SizedBox(width: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
