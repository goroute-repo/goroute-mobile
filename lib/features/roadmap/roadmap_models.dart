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
    this.skills = const [],
    this.skillTracks = const [],
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
  final List<String> skills;
  final List<SkillTrack> skillTracks;

  bool get isLocked => state == 'locked';
  bool get canStart => state == 'available' || state == 'recommended';
  bool get canComplete => state == 'in_progress';

  factory RoadmapNodeDetail.fromJson(Map<String, dynamic> json) {
    final prereqs = json['prerequisites'];
    final skills = json['skills'];
    final tracks = json['skillTracks'];
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
      skills: skills is List
          ? skills
              .whereType<Map>()
              .map((e) => e['label'])
              .whereType<String>()
              .toList()
          : const [],
      skillTracks: tracks is List
          ? tracks.map(SkillTrack.tryParse).whereType<SkillTrack>().toList()
          : const [],
    );
  }
}

class SkillResource {
  const SkillResource({required this.kind, required this.title, required this.url});

  final String kind;
  final String title;
  final String url;

  static SkillResource? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final title = raw['title'];
    final url = raw['url'];
    if (title is! String || url is! String || url.isEmpty) return null;
    return SkillResource(kind: (raw['kind'] as String?) ?? 'doc', title: title, url: url);
  }
}

class SkillProject {
  const SkillProject({required this.title, required this.brief, required this.criteria});

  final String title;
  final String brief;
  final List<String> criteria;

  static SkillProject? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final title = raw['title'];
    if (title is! String || title.isEmpty) return null;
    final ac = raw['acceptanceCriteria'];
    return SkillProject(
      title: title,
      brief: (raw['brief'] as String?) ?? '',
      criteria: ac is List ? ac.whereType<String>().toList() : const [],
    );
  }
}

/// Trilha de uma skill do cargo: cursos + Learn by Doing por nível.
class SkillTrack {
  const SkillTrack({
    required this.slug,
    required this.label,
    this.resources = const [],
    this.projects = const {},
  });

  final String slug;
  final String label;
  final List<SkillResource> resources;

  /// Chaves: beginner, intermediate, advanced.
  final Map<String, SkillProject> projects;

  static SkillTrack? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final slug = raw['slug'];
    final label = raw['label'];
    if (slug is! String || label is! String) return null;
    final res = raw['resources'];
    final prj = raw['projects'];
    final projects = <String, SkillProject>{};
    if (prj is Map) {
      for (final level in const ['beginner', 'intermediate', 'advanced']) {
        final p = SkillProject.tryParse(prj[level]);
        if (p != null) projects[level] = p;
      }
    }
    return SkillTrack(
      slug: slug,
      label: label,
      resources: res is List
          ? res.map(SkillResource.tryParse).whereType<SkillResource>().toList()
          : const [],
      projects: projects,
    );
  }
}
