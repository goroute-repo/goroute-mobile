import 'package:flutter_test/flutter_test.dart';
import 'package:goroute_mobile/features/roadmap/roadmap_models.dart';

void main() {
  test('RoadmapSnapshot.fromJson maps timeMachine, nodes and recommended', () {
    final snap = RoadmapSnapshot.fromJson({
      'nodes': [
        {'id': 'a', 'label': 'A', 'slug': 'a', 'state': 'completed'},
        {'id': 'b', 'label': 'B', 'slug': 'b', 'state': 'recommended'},
      ],
      'timeMachine': {'percentDone': 40, 'weeksToGoal': 12},
      'targetRoleLabel': 'Pleno',
      'recommendedNext': {'slug': 'react', 'label': 'React', 'demandScore': 9},
    });
    expect(snap.nodesCount, 2);
    expect(snap.nodes.first.state, 'completed');
    expect(snap.percentDone, 40);
    expect(snap.weeksToGoal, 12);
    expect(snap.targetRoleLabel, 'Pleno');
    expect(snap.recommendedLabel, 'React');
    expect(snap.recommendedNext?.slug, 'react');
  });

  test('RoadmapNodeDetail.fromJson maps prerequisites and actions flags', () {
    final detail = RoadmapNodeDetail.fromJson({
      'id': 'n1',
      'label': 'React',
      'slug': 'react',
      'state': 'available',
      'description': 'Learn React',
      'prerequisites': [
        {'slug': 'js', 'label': 'JS', 'satisfied': true},
        {'slug': 'html', 'label': 'HTML', 'satisfied': false},
      ],
    });
    expect(detail.canStart, isTrue);
    expect(detail.canComplete, isFalse);
    expect(detail.prerequisites, hasLength(2));
    expect(detail.prerequisites.first.satisfied, isTrue);
  });
}
