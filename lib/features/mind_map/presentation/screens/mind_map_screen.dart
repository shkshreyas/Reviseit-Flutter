import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:reviseitai/core/theme/app_theme.dart';
import 'package:reviseitai/core/widgets/glass_container.dart';

class MindMapScreen extends StatefulWidget {
  const MindMapScreen({super.key});

  @override
  State<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends State<MindMapScreen> {
  final List<MindMapNode> _nodes = [
    MindMapNode(
      id: '1',
      title: 'Machine Learning',
      children: [
        MindMapNode(
          id: '1.1',
          title: 'Supervised Learning',
          children: [
            MindMapNode(id: '1.1.1', title: 'Classification'),
            MindMapNode(id: '1.1.2', title: 'Regression'),
          ],
        ),
        MindMapNode(
          id: '1.2',
          title: 'Unsupervised Learning',
          children: [
            MindMapNode(id: '1.2.1', title: 'Clustering'),
            MindMapNode(id: '1.2.2', title: 'Dimensionality Reduction'),
          ],
        ),
      ],
    ),
  ];

  MindMapNode? _selectedNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        GlassContainer(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mind Maps',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Visualize your learning concepts',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  // TODO: Implement zoom controls
                },
                icon: const Icon(Icons.zoom_out_map, color: Colors.white),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),

        // Mind Map Content
        Expanded(
          child: Stack(
            children: [
              // Background Grid
              CustomPaint(size: Size.infinite, painter: GridPainter()),

              // Mind Map Nodes
              InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(100),
                minScale: 0.5,
                maxScale: 2.0,
                child: Center(child: _buildMindMapNode(_nodes[0], 0)),
              ),
            ],
          ),
        ),

        // Selected Node Details
        if (_selectedNode != null)
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedNode!.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Click on nodes to explore related concepts',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildMindMapNode(MindMapNode node, int level) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNode = node;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedNode?.id == node.id
              ? AppTheme.primaryColor
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedNode?.id == node.id
                ? AppTheme.primaryColor
                : Colors.white.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              node.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16 - (level * 2),
                fontWeight: FontWeight.w600,
              ),
            ),
            if (node.children.isNotEmpty) ...[
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: node.children.map((child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildMindMapNode(child, level + 1),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MindMapNode {
  final String id;
  final String title;
  final List<MindMapNode> children;

  MindMapNode({
    required this.id,
    required this.title,
    this.children = const [],
  });
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    const spacing = 20.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
