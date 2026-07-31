import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import '../models/plan.dart';

class HomeWidgetService {
  static const String androidWidgetName = 'HomeWidgetProvider';

  static Future<void> updateWidget(List<Plan> plans) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    // Find next upcoming active plan
    final now = DateTime.now();

    // Filter active plans
    final activePlans = plans.where((p) {
      if (p.isCompleted) return false;

      // Logic for different types
      // 1. One Time: Must be today or future
      if (p.planType == PlanType.oneTime) {
        return p.dueDate != null && p.dueDate!.isAfter(now);
      }

      // 2. Weekly / Selected Days: specific repeat days
      // If we are just showing "Next Plan", does it have to be today?
      // For simplicity in a widget, let's focus on Today's remaining tasks or closest future one.
      // Implementing full recurrence logic for "Next 7 days" is complex.
      // Let's stick to "Today's Active Plans".

      if (p.repeatDays != null && p.repeatDays!.isNotEmpty) {
        // Check if today matches one of the repeat days
        return p.repeatDays!.contains(now.weekday);
      }

      // Weekly default (if no specific days set but weekly type):
      // Maybe check if creation/due date weekday matches today?
      if (p.planType == PlanType.weekly && p.dueDate != null) {
        return p.dueDate!.weekday == now.weekday;
      }

      return false;
    }).toList();

    // Sort by time
    activePlans.sort((a, b) {
      // Using Modulo time or similar for recurring?
      // For recurring, we might rely on the "Time" component of dueDate if exists
      // If dueDate is just date, priority?
      // Let's assume dueDate handles the time.
      if (a.dueDate == null || b.dueDate == null) return 0;

      final aTime = a.dueDate!.hour * 60 + a.dueDate!.minute;
      final bTime = b.dueDate!.hour * 60 + b.dueDate!.minute;

      // If both are today, sort by time
      return aTime.compareTo(bTime);
    });

    // Filter out passed times for today
    final remainingToday = activePlans.where((p) {
      if (p.dueDate == null) return true;
      // If it's a recurring task active today, check if its time has passed
      final pTime = p.dueDate!.hour * 60 + p.dueDate!.minute;
      final nowTime = now.hour * 60 + now.minute;
      return pTime > nowTime;
    }).toList();

    final String title;
    final String message;

    if (remainingToday.isNotEmpty) {
      final nextPlan = remainingToday.first;
      title = nextPlan.title;
      final dateStr = nextPlan.dueDate != null
          ? DateFormat('HH:mm').format(nextPlan.dueDate!)
          : 'Bugün'; // Localization? Widget runs in background, might default to EN or system.

      message = 'Bugün $dateStr';
    } else {
      // Fallback to general upcoming "One Time" plans if no recurring today
      // Or just show empty
      final futureOneTime = plans
          .where(
            (p) =>
                p.planType == PlanType.oneTime &&
                p.dueDate != null &&
                p.dueDate!.isAfter(now),
          )
          .toList();
      futureOneTime.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

      if (futureOneTime.isNotEmpty) {
        final next = futureOneTime.first;
        title = next.title;
        final f = DateFormat('d MMM HH:mm', 'tr_TR');
        message = f.format(next.dueDate!);
      } else {
        title = 'Plan Yok';
        message = 'Bugün için başka planınız yok.';
      }
    }

    try {
      await HomeWidget.saveWidgetData<String>('title', title);
      await HomeWidget.saveWidgetData<String>('message', message);

      await HomeWidget.updateWidget(name: androidWidgetName);
    } catch (error, stackTrace) {
      debugPrint('Home widget update failed: $error\n$stackTrace');
    }
  }
}
