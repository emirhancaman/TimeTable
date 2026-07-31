import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/models/plan.dart';

void main() {
  group('Plan', () {
    test('uses stable defaults', () {
      final plan = Plan(
        id: 'plan-1',
        title: 'Review timetable',
        createdAt: DateTime(2026, 7, 31),
        category: 'work',
      );

      expect(plan.isCompleted, isFalse);
      expect(plan.priority, 2);
      expect(plan.planType, PlanType.oneTime);
      expect(plan.emoji, '📋');
    });

    test('copyWith updates values and can clear nullable fields', () {
      final original = Plan(
        id: 'plan-1',
        title: 'Original',
        description: 'Details',
        createdAt: DateTime(2026, 7, 31),
        dueDate: DateTime(2026, 8, 1),
        category: 'work',
        subCategory: 'Deep work',
        repeatDays: const [1, 3, 5],
      );

      final updated = original.copyWith(
        title: 'Updated',
        description: null,
        dueDate: null,
        subCategory: null,
        repeatDays: null,
      );

      expect(updated.title, 'Updated');
      expect(updated.description, isNull);
      expect(updated.dueDate, isNull);
      expect(updated.subCategory, isNull);
      expect(updated.repeatDays, isNull);
      expect(original.description, 'Details');
    });
  });
}
