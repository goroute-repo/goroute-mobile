import 'package:flutter/material.dart';
import 'package:goroute_mobile/core/theme/app_theme.dart';

/// Soft brand wash behind dashboard headers (light + dark).
class BrandHeaderBackground extends StatelessWidget {
  const BrandHeaderBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
                  Color(0xFF0E1412),
                  Color(0xFF132820),
                  Color(0xFF0E1412),
                ]
              : [
                  AppTheme.seed.withValues(alpha: 0.14),
                  const Color(0xFFF4F7F6),
                  const Color(0xFFF4F7F6),
                ],
        ),
      ),
      child: child,
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.emphasized = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = emphasized ? scheme.primaryContainer : scheme.surface;
    final fg = emphasized ? scheme.onPrimaryContainer : scheme.onSurface;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.7),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: emphasized ? scheme.primary : fg, size: 26),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.percent,
    this.size = 88,
  });

  final int percent;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final value = (percent.clamp(0, 100)) / 100;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 8,
            backgroundColor: scheme.surfaceContainerHighest,
            color: scheme.primary,
          ),
          Text(
            '$percent%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

/// Where a node sits relative to "hoje" na trilha.
enum TrailMarkerState { done, current, upcoming }

class TrailNode {
  const TrailNode({required this.label, required this.state});

  final String label;
  final TrailMarkerState state;
}

/// Visualização "Trilha": o roadmap como caminho percorrido, não como um
/// número abstrato. Cada nó é um marco; o marco atual acende em âmbar
/// (conquista), os percorridos em verde (avanço), os futuros ficam neutros.
/// Ao abrir a tela, o caminho se revela da esquerda até o ponto atual —
/// o único movimento aqui tem o propósito de mostrar "até onde você chegou".
class RoadmapTrail extends StatefulWidget {
  const RoadmapTrail({
    super.key,
    required this.nodes,
    required this.percent,
    this.maxVisible = 6,
  });

  final List<TrailNode> nodes;
  final int percent;
  final int maxVisible;

  @override
  State<RoadmapTrail> createState() => _RoadmapTrailState();
}

class _RoadmapTrailState extends State<RoadmapTrail>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _reveal;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _reveal = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final visible = widget.nodes.take(widget.maxVisible).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    final row = Row(
      children: [
        for (var i = 0; i < visible.length; i++) ...[
          _TrailDot(node: visible[i], scheme: scheme),
          if (i != visible.length - 1)
            Expanded(
              child: Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: visible[i].state == TrailMarkerState.done
                      ? scheme.primary
                      : scheme.outlineVariant.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
        const SizedBox(width: 10),
        _PercentBadge(percent: widget.percent, scheme: scheme),
      ],
    );

    if (MediaQuery.of(context).disableAnimations) return row;
    return SizeTransition(
      sizeFactor: _reveal,
      axis: Axis.horizontal,
      axisAlignment: -1,
      child: row,
    );
  }
}

class _TrailDot extends StatelessWidget {
  const _TrailDot({required this.node, required this.scheme});

  final TrailNode node;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    switch (node.state) {
      case TrailMarkerState.done:
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: scheme.primary,
            shape: BoxShape.circle,
          ),
        );
      case TrailMarkerState.current:
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: scheme.tertiary,
            shape: BoxShape.circle,
            border: Border.all(color: scheme.tertiaryContainer, width: 3),
          ),
        );
      case TrailMarkerState.upcoming:
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: scheme.surface,
            shape: BoxShape.circle,
            border: Border.all(color: scheme.outlineVariant, width: 1.5),
          ),
        );
    }
  }
}

class _PercentBadge extends StatelessWidget {
  const _PercentBadge({required this.percent, required this.scheme});

  final int percent;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$percent%',
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.primary,
          ),
    );
  }
}
