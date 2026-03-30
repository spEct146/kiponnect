import 'package:flutter/material.dart';
import 'package:kiponnect/core/constants/app_colors.dart';

class PostCard extends StatefulWidget {
  final String authorName;
  final String? authorAvatar;
  final String timestamp;
  final String content;
  final List<String>? imageUrls;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final bool isLiked;

  const PostCard({
    Key? key,
    required this.authorName,
    this.authorAvatar,
    required this.timestamp,
    required this.content,
    this.imageUrls,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.onLike,
    this.onComment,
    this.onShare,
    this.isLiked = false,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(20),
          border: _isPressed
              ? Border.all(color: AppColors.primaryOrange, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryOrange,
                  ),
                  child: Center(
                    child: Text(
                      widget.authorName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.authorName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        widget.timestamp,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, color: AppColors.textSecondary),
              ],
            ),
            SizedBox(height: 12),
            // Content
            Text(
              widget.content,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            // Images if any
            if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty) ...[
              SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 200,
                  color: AppColors.darkSurfaceVariant,
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: AppColors.textTertiary,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 12),
            // Footer - Reactions
            Row(
              children: [
                _ReactionButton(
                  icon: Icons.favorite,
                  label: '${widget.likesCount}',
                  isActive: widget.isLiked,
                  onTap: widget.onLike,
                ),
                SizedBox(width: 16),
                _ReactionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${widget.commentsCount}',
                  onTap: widget.onComment,
                ),
                SizedBox(width: 16),
                _ReactionButton(
                  icon: Icons.share,
                  label: '${widget.sharesCount}',
                  onTap: widget.onShare,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReactionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const _ReactionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

  @override
  State<_ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<_ReactionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.darkSurfaceVariant : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 20,
              color: widget.isActive ? AppColors.primaryOrange : AppColors.textSecondary,
            ),
            SizedBox(width: 6),
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: widget.isActive ? AppColors.primaryOrange : AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
