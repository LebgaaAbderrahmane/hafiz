import 'package:flutter/material.dart';

/// Provides an [openDrawer] callback that reaches the shell's Scaffold drawer,
/// even through nested Scaffolds in child views.
class DrawerScope extends InheritedWidget {
  const DrawerScope({
    super.key,
    required this.openDrawer,
    required super.child,
  });

  final VoidCallback openDrawer;

  static VoidCallback? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DrawerScope>()
        ?.openDrawer;
  }

  @override
  bool updateShouldNotify(DrawerScope oldWidget) =>
      openDrawer != oldWidget.openDrawer;
}

/// Hamburger icon button that opens the shell's drawer.
///
/// Must be used inside a [DrawerScope] (provided by the AdminShell).
class DrawerIconButton extends StatelessWidget {
  const DrawerIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: DrawerScope.of(context),
    );
  }
}
