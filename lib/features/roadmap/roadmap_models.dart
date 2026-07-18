/// Graph node from `GET /api/roadmap/me`.
class RoadmapNodeSummary {
  const RoadmapNodeSummary({
    required this.id,
    required this.label,
    this.slug,
    this.state,
    this.description,
    this.estimatedHours,
    this.hoursLogged,
  });

  final String id;
  final String label;
  final String? slug;
  final String? state;
  final String? description;
  final int? estimatedHours;
  final int? hoursLogged;

  factory RoadmapNodeSummary.fromJson(Map<String, dynamic> json) {
    return RoadmapNodeSummary(
      id: (json['id'] as String?) ?? '',
      label: (json['label'] as String?) ?? '',
      slug: json['slug'] as String?,
      state: json['state'] as String?,
      description: json['description'] as String?,
      estimatedHours: (json['estimatedHours'] as num?)?.toInt(),
      hoursLogged: (json['hoursLogged'] as num?)?.toInt(),
    );
  }

  bool get isLocked => state == 'locked';
  bool get canStart => state == 'available' || state == 'recommended';
  bool get canComplete => state == 'in_progress';
}

class RoadmapRecommended {
  const RoadmapRecommended({
    required this.slug,
    required this.label,
    this.demandScore,
  });

  final String slug;
  final String label;
  final num? demandScore;

  factory RoadmapRecommended.fromJson(Map<String, dynamic> json) {
    return RoadmapRecommended(
      slug: (json['slug'] as String?) ?? '',
      label: (json['label'] as String?) ?? '',
      demandScore: json['demandScore'] as num?,
    );
  }
}

class RoadmapSnapshot {
  const RoadmapSnapshot({
    required this.nodes,
    required this.percentDone,
    required this.weeksToGoal,
    this.targetRoleLabel,
    this.recommendedNext,
  });

  final List<RoadmapNodeSummary> nodes;
  final int percentDone;
  final int weeksToGoal;
  final String? targetRoleLabel;
  final RoadmapRecommended? recommendedNext;

  int get nodesCount => nodes.length;

  String? get recommendedLabel => recommendedNext?.label;

  factory RoadmapSnapshot.fromJson(Map<String, dynamic> json) {
    final rawNodes = json['nodes'];
    final nodes = rawNodes is List
        ? rawNodes
            .whereType<Map>()
            .map((e) => RoadmapNodeSummary.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <RoadmapNodeSummary>[];
    final tm = json['timeMachine'] as Map<String, dynamic>? ?? {};
    final recommended = json['recommendedNext'] as Map<String, dynamic>?;
    return RoadmapSnapshot(
      nodes: nodes,
      percentDone: (tm['percentDone'] as num?)?.toInt() ?? 0,
      weeksToGoal: (tm['weeksToGoal'] as num?)?.toInt() ?? 0,
      targetRoleLabel: json['targetRoleLabel'] as String?,
      recommendedNext: recommended == null
          ? null
          : RoadmapRecommended.fromJson(recommended),
    );
  }
}

class RoadmapPrerequisite {
  const RoadmapPrerequisite({
    required this.slug,
    required this.label,
    required this.satisfied,
  });

  final String slug;
  final String label;
  final bool satisfied;

  factory RoadmapPrerequisite.fromJson(Map<String, dynamic> json) {
    return RoadmapPrerequisite(
      slug: (json['slug'] as String?) ?? '',
      label: (json['label'] as String?) ?? '',
      satisfied: json['satisfied'] == true,
    );
  }
}

class RoadmapNodeDetail {
  const RoadmapNodeDetail({
    required this.id,
    required this.label,
    this.slug,
    this.state,
    this.description,
    this.estimatedHours,
    this.hoursLogged,
    this.notes,
    this.startedAt,
    this.completedAt,
    this.prerequisites = const [],
  });

  final String id;
  final String label;
  final String? slug;
  final String? state;
  final String? description;
  final int? estimatedHours;
  final int? hoursLogged;
  final String? notes;
  final String? startedAt;
  final String? completedAt;
  final List<RoadmapPrerequisite> prerequisites;

  bool get isLocked => state == 'locked';
  bool get canStart => state == 'available' || state == 'recommended';
  bool get canComplete => state == 'in_progress';

  factory RoadmapNodeDetail.fromJson(Map<String, dynamic> json) {
    final prereqs = json['prerequisites'];
    return RoadmapNodeDetail(
      id: (json['id'] as String?) ?? '',
      label: (json['label'] as String?) ?? '',
      slug: json['slug'] as String?,
      state: json['state'] as String?,
      description: json['description'] as String?,
      estimatedHours: (json['estimatedHours'] as num?)?.toInt(),
      hoursLogged: (json['hoursLogged'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      startedAt: json['startedAt'] as String?,
      completedAt: json['completedAt'] as String?,
      prerequisites: prereqs is List
          ? prereqs
              .whereType<Map>()
              .map(
                (e) =>
                    RoadmapPrerequisite.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList()
          : const [],
    );
  }
}
