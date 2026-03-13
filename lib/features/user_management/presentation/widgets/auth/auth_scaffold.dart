import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthScaffold extends StatefulWidget {
  final Widget child;

  const AuthScaffold({super.key, required this.child});

  @override
  State<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends State<AuthScaffold> {
  @override
  void initState() {
    super.initState();
    // 📱 EDGE TO EDGE (Draw behind bars)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    // Restore default if needed
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Prevent keyboard from shifting the entire screen layout
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            // 🎨 BACKGROUND LAYER
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Theme.of(context).colorScheme.surface
                      : const Color(0xFFFFF4E1),
                  gradient: isDark
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.surface,
                            Theme.of(context).colorScheme.primaryContainer
                                .withValues(alpha: 0.1),
                          ],
                        )
                      : null, // Solid color for light mode matching onboarding
                ),
              ),
            ),

            // ✨ DECORATIVE SHAPES
            Positioned(
              top: -100.h,
              right: -100.w,
              child: Container(
                width: 300.w,
                height: 300.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.05)
                      : Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
            Positioned(
              bottom: -50.h,
              left: -50.w,
              child: Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.05)
                      : Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),

            // 📄 CONTENT LAYER
            LayoutBuilder(
              builder: (context, constraints) {
                final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          alignment: Alignment.center,
                          child: widget.child,
                        ),
                      ),
                      // ⌨️ KEYBOARD SPACER
                      // Adds space at the bottom only when keyboard is up,
                      // allowing user to scroll up but NOT forcing the content
                      // to re-center or jump when it first appears.
                      SizedBox(height: keyboardHeight),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
