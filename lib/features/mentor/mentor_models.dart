class MentorAnswer {
  const MentorAnswer({
    required this.source,
    required this.summary,
    this.scope,
    this.intro,
    this.diagnosis = const [],
    this.immediateAction,
    this.roadmapLink,
    this.warning,
  });

  final String source;
  final String summary;
  final String? scope;
  final String? intro;
  final List<String> diagnosis;
  final String? immediateAction;
  final String? roadmapLink;
  final String? warning;

  factory MentorAnswer.fromJson(Map<String, dynamic> json) {
    final diag = json['diagnosis'];
    return MentorAnswer(
      source: (json['source'] as String?) ?? 'heuristic',
      summary: (json['summary'] as String?) ?? '',
      scope: json['scope'] as String?,
      intro: json['intro'] as String?,
      diagnosis: diag is List
          ? diag.map((e) => e.toString()).toList()
          : const [],
      immediateAction: json['immediateAction'] as String?,
      roadmapLink: json['roadmapLink'] as String?,
      warning: json['warning'] as String?,
    );
  }

  String get displayText {
    final buf = StringBuffer();
    if (intro != null && intro!.isNotEmpty) {
      buf.writeln(intro);
      buf.writeln();
    }
    if (summary.isNotEmpty) buf.writeln(summary);
    if (diagnosis.isNotEmpty) {
      buf.writeln();
      for (final d in diagnosis) {
        buf.writeln('• $d');
      }
    }
    if (immediateAction != null && immediateAction!.isNotEmpty) {
      buf.writeln();
      buf.writeln(immediateAction);
    }
    if (warning != null && warning!.isNotEmpty) {
      buf.writeln();
      buf.writeln(warning);
    }
    return buf.toString().trim();
  }
}

class MentorChatMessage {
  const MentorChatMessage({
    required this.role,
    required this.text,
    this.scope,
  });

  final String role; // user | mentor
  final String text;
  final String? scope;

  Map<String, dynamic> toJson() => {
        'role': role,
        'text': text,
        if (scope != null) 'scope': scope,
      };

  factory MentorChatMessage.fromJson(Map<String, dynamic> json) {
    return MentorChatMessage(
      role: (json['role'] as String?) ?? 'mentor',
      text: (json['text'] as String?) ?? '',
      scope: json['scope'] as String?,
    );
  }
}

/// Optional seed when opening mentor from a node/job/home.
class MentorRouteExtra {
  const MentorRouteExtra({this.prefillQuestion, this.contextLabel});

  final String? prefillQuestion;
  final String? contextLabel;
}
