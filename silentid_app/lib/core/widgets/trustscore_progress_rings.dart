import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// TrustScore Progress Rings Widget (Section 50.3.2)
///
/// Gamifies the TrustScore by showing progress rings for each category:
/// - Identity (200 max)
/// - Evidence (300 max)
/// - Behaviour (300 max)
/// - Peer Verification (200 max)
///
/// Also supports nudges for pending actions.
class TrustScoreProgressRings extends StatelessWidget {
  final int identityScore;
  final int evidenceScore;
  final int behaviourScore;
  final int peerScore;
  final int? pendingVerifications;
  final int? pendingConnections;
  final VoidCallback? onIdentityTap;
  final VoidCallback? onEvidenceTap;
  final VoidCallback? onBehaviourTap;
  final VoidCallback? onPeerTap;

  const TrustScoreProgressRings({
    super.key,
    required this.identityScore,
    required this.evidenceScore,
    required this.behaviourScore,
    required this.peerScore,
    this.pendingVerifications,
    this.pendingConnections,
    this.onIdentityTap,
    this.onEvidenceTap,
    this.onBehaviourTap,
    this.onPeerTap,
  });

  int get totalScore => identityScore + evidenceScore + behaviourScore + peerScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Score Breakdown',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.deepBlack,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$totalScore pts',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Progress rings grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProgressRing(
                label: 'Identity',
                score: identityScore,
                maxScore: 200,
                color: AppTheme.primaryPurple,
                icon: Icons.shield_outlined,
                onTap: onIdentityTap,
              ),
              _buildProgressRing(
                label: 'Evidence',
                score: evidenceScore,
                maxScore: 300,
                color: AppTheme.warningAmber,
                icon: Icons.folder_outlined,
                onTap: onEvidenceTap,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProgressRing(
                label: 'Behaviour',
                score: behaviourScore,
                maxScore: 300,
                color: AppTheme.successGreen,
                icon: Icons.trending_up,
                onTap: onBehaviourTap,
              ),
              _buildProgressRing(
                label: 'Peer',
                score: peerScore,
                maxScore: 200,
                color: const Color(0xFF3B82F6), // Blue
                icon: Icons.people_outline,
                onTap: onPeerTap,
                badge: pendingVerifications != null && pendingVerifications! > 0
                    ? pendingVerifications.toString()
                    : null,
              ),
            ],
          ),

          // Nudges section
          if (_hasNudges) ...[
            const SizedBox(height: 20),
            _buildNudgesSection(),
          ],
        ],
      ),
    );
  }

  bool get _hasNudges =>
      (pendingVerifications != null && pendingVerifications! > 0) ||
      (pendingConnections != null && pendingConnections! > 0);

  Widget _buildProgressRing({
    required String label,
    required int score,
    required int maxScore,
    required Color color,
    required IconData icon,
    VoidCallback? onTap,
    String? badge,
  }) {
    final progress = score / maxScore;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Background ring
              SizedBox(
                width: 80,
                height: 80,
                child: CustomPaint(
                  painter: _RingPainter(
                    progress: 1.0,
                    color: color.withValues(alpha: 0.15),
                    strokeWidth: 8,
                  ),
                ),
              ),
              // Progress ring
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return SizedBox(
                    width: 80,
                    height: 80,
                    child: CustomPaint(
                      painter: _RingPainter(
                        progress: value,
                        color: color,
                        strokeWidth: 8,
                      ),
                    ),
                  );
                },
              ),
              // Center content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$score',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepBlack,
                    ),
                  ),
                ],
              ),
              // Badge
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppTheme.dangerRed,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        badge,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.neutralGray700,
            ),
          ),
          Text(
            '$score/$maxScore',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.neutralGray700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNudgesSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.softLilac.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (pendingVerifications != null && pendingVerifications! > 0)
            _buildNudgeItem(
              icon: Icons.people,
              text: 'You have $pendingVerifications pending verification${pendingVerifications! > 1 ? 's' : ''}',
              color: const Color(0xFF3B82F6),
            ),
          if (pendingConnections != null && pendingConnections! > 0) ...[
            if (pendingVerifications != null && pendingVerifications! > 0)
              const SizedBox(height: 8),
            _buildNudgeItem(
              icon: Icons.link,
              text: 'Complete your remaining connections to boost your score',
              color: AppTheme.warningAmber,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNudgeItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.neutralGray900,
            ),
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.neutralGray700,
          size: 14,
        ),
      ],
    );
  }
}

/// Custom painter for progress ring
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw arc from top (-90 degrees)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Sweep angle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
