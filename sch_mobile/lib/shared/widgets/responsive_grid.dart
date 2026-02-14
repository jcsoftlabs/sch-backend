import 'package:flutter/material.dart';
import '../responsive/breakpoints.dart';

/// A responsive grid that adjusts columns based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
  });

  @override
  Widget build(BuildContext context) {
    final columns = Breakpoints.getValue(
      context,
      mobile: mobileColumns ?? 1,
      tablet: tabletColumns ?? 2,
      desktop: desktopColumns ?? 3,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}

/// A responsive list/grid that switches between list and grid based on screen size
class ResponsiveListGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveListGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.tabletColumns,
    this.desktopColumns,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      // Mobile: List view
      return ListView.separated(
        padding: context.responsivePadding,
        itemCount: children.length,
        separatorBuilder: (context, index) => SizedBox(height: spacing),
        itemBuilder: (context, index) => children[index],
      );
    } else {
      // Tablet/Desktop: Grid view
      return SingleChildScrollView(
        padding: context.responsivePadding,
        child: ResponsiveGrid(
          spacing: spacing,
          runSpacing: spacing,
          tabletColumns: tabletColumns,
          desktopColumns: desktopColumns,
          children: children,
        ),
      );
    }
  }
}
