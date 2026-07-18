class JobMatch {
  const JobMatch({
    required this.jobId,
    required this.title,
    required this.companyName,
    required this.matchScore,
    required this.fullyQualified,
    this.locationLabel,
    this.city,
    this.state,
  });

  final String jobId;
  final String title;
  final String companyName;
  final int matchScore;
  final bool fullyQualified;
  final String? locationLabel;
  final String? city;
  final String? state;

  factory JobMatch.fromJson(Map<String, dynamic> json) {
    return JobMatch(
      jobId: (json['jobId'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      companyName: (json['companyName'] as String?) ?? '',
      matchScore: (json['matchScore'] as num?)?.toInt() ?? 0,
      fullyQualified: json['fullyQualified'] == true,
      locationLabel: json['locationLabel'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
    );
  }

  String get locationDisplay {
    if (locationLabel != null && locationLabel!.isNotEmpty) return locationLabel!;
    final parts = [city, state].whereType<String>().where((e) => e.isNotEmpty);
    return parts.join(', ');
  }
}

class JobDetail {
  const JobDetail({
    required this.id,
    required this.title,
    required this.description,
    this.locationLabel,
    this.city,
    this.state,
    this.skills = const [],
  });

  final String id;
  final String title;
  final String description;
  final String? locationLabel;
  final String? city;
  final String? state;
  final List<JobSkillReq> skills;

  factory JobDetail.fromJson(Map<String, dynamic> json) {
    final rawSkills = json['skills'];
    return JobDetail(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      locationLabel: json['locationLabel'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      skills: rawSkills is List
          ? rawSkills
              .whereType<Map>()
              .map((e) => JobSkillReq.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

class JobSkillReq {
  const JobSkillReq({required this.slug, required this.minLevel});

  final String slug;
  final String minLevel;

  factory JobSkillReq.fromJson(Map<String, dynamic> json) {
    return JobSkillReq(
      slug: (json['slug'] as String?) ?? '',
      minLevel: (json['minLevel'] as String?) ?? '',
    );
  }
}

class JobApplyResult {
  const JobApplyResult({
    required this.ok,
    required this.applicationId,
    required this.jobId,
  });

  final bool ok;
  final String applicationId;
  final String jobId;

  factory JobApplyResult.fromJson(Map<String, dynamic> json) {
    return JobApplyResult(
      ok: json['ok'] == true,
      applicationId: (json['applicationId'] as String?) ?? '',
      jobId: (json['jobId'] as String?) ?? '',
    );
  }
}

class JobMatchNarrative {
  const JobMatchNarrative({
    required this.jobId,
    required this.title,
    required this.matchScore,
    required this.fullyQualified,
    required this.source,
    required this.summary,
    this.closingSkills = const [],
  });

  final String jobId;
  final String title;
  final int matchScore;
  final bool fullyQualified;
  final String source;
  final String summary;
  final List<ClosingSkill> closingSkills;

  factory JobMatchNarrative.fromJson(Map<String, dynamic> json) {
    final raw = json['closingSkills'];
    return JobMatchNarrative(
      jobId: (json['jobId'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      matchScore: (json['matchScore'] as num?)?.toInt() ?? 0,
      fullyQualified: json['fullyQualified'] == true,
      source: (json['source'] as String?) ?? 'heuristic',
      summary: (json['summary'] as String?) ?? '',
      closingSkills: raw is List
          ? raw
              .whereType<Map>()
              .map((e) => ClosingSkill.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

class ClosingSkill {
  const ClosingSkill({
    required this.slug,
    required this.label,
    required this.minLevel,
  });

  final String slug;
  final String label;
  final String minLevel;

  factory ClosingSkill.fromJson(Map<String, dynamic> json) {
    return ClosingSkill(
      slug: (json['slug'] as String?) ?? '',
      label: (json['label'] as String?) ?? '',
      minLevel: (json['minLevel'] as String?) ?? '',
    );
  }
}
