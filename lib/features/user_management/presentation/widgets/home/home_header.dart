import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:eduflow/config/routes/app_routes.dart';
import 'package:eduflow/features/user_management/presentation/bloc/user_bloc.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      buildWhen: (prev, curr) =>
          curr.status == UserStatus.authenticated &&
          (prev.status != UserStatus.authenticated ||
              prev.user?.name != curr.user?.name ||
              prev.user?.photoUrl != curr.user?.photoUrl),
      builder: (context, state) {
        if (state.status != UserStatus.authenticated || state.user == null) {
          return const SizedBox.shrink();
        }

        final user = state.user!;
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        final hour = DateTime.now().hour;
        final greeting = hour < 12
            ? 'Good morning'
            : hour < 17
            ? 'Good afternoon'
            : hour < 21
            ? 'Good evening'
            : 'Good night';

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: InkWell(
            onTap: () => context.pushNamed(AppRouteNames.profile),
            borderRadius: BorderRadius.circular(22),
            child: Ink(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: [
                    colors.primary.withValues(alpha: 0.10),
                    colors.secondary.withValues(alpha: 0.08),
                  ],
                ),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// AVATAR
                  Container(
                    height: 46,
                    width: 46,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: user.photoUrl != null
                        ? CachedNetworkImage(
                            imageUrl: user.photoUrl!,
                            fit: BoxFit.cover,
                            width: 46,
                            height: 46,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: colors.primary.withValues(alpha: 0.1),
                              highlightColor: colors.primary.withValues(
                                alpha: 0.05,
                              ),
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                _buildInitials(theme, user, colors),
                          )
                        : _buildInitials(theme, user, colors),
                  ),

                  const SizedBox(width: 14),

                  /// TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.chevron_right_rounded,
                    color: colors.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInitials(ThemeData theme, dynamic user, ColorScheme colors) {
    return Center(
      child: Text(
        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: colors.primary,
        ),
      ),
    );
  }
}
