import 'package:falconclubapp/feature/exercise/domain/entities/exercise_player.dart';
import 'package:falconclubapp/shared/domain/entities/exercise.dart';
import 'package:falconclubapp/shared/domain/entities/player_position.dart';
import 'package:falconclubapp/shared/domain/entities/subscription.dart';
import 'package:flutter_test/flutter_test.dart';

const Subscription _active = Subscription(isPurchased: true, remainingDays: 30);
const Subscription _expired = Subscription(isPurchased: true, remainingDays: 0);
const Subscription _never = Subscription.none;

Exercise _exercise({required bool isPaid}) =>
    Exercise(id: '1', title: 'تمرين السرعة', isPaid: isPaid);

void main() {
  group('exercise locking', () {
    // `isPaid` was parsed onto the model and read by NOTHING — a paid exercise
    // was indistinguishable from a free one.
    test('a paid exercise is locked for an unsubscribed user', () {
      expect(_exercise(isPaid: true).isLockedFor(_never), isTrue);
    });

    test('a paid exercise is open to a subscriber', () {
      expect(_exercise(isPaid: true).isLockedFor(_active), isFalse);
    });

    // The whole reason entitlement goes through Subscription.isActive: an
    // expired plan is not a plan.
    test('an EXPIRED subscription does not unlock a paid exercise', () {
      expect(_exercise(isPaid: true).isLockedFor(_expired), isTrue);
    });

    test('a free exercise is never locked, for anyone', () {
      for (final Subscription subscription in <Subscription>[
        _active,
        _expired,
        _never,
      ]) {
        expect(_exercise(isPaid: false).isLockedFor(subscription), isFalse);
      }
    });

    // Every exercise in the live GetAllExercises sample has isPaid: false, so
    // nothing is locked today. The rule still has to be right for when one is.
    test('the live payload default (isPaid absent) is unlocked', () {
      const Exercise exercise = Exercise(id: '1', title: 'x');

      expect(exercise.isPaid, isFalse);
      expect(exercise.isLockedFor(_never), isFalse);
    });
  });

  group('ExercisePlayer.ageLabel', () {
    ExercisePlayer player(int? age) => ExercisePlayer(
      id: 'p',
      name: 'أحمد',
      position: PlayerPosition.unknown,
      attemptCount: 0,
      age: age,
    );

    // The live roster returns "age": 0 for most players — it means "unknown",
    // not "newborn". Rendering "0" states something false.
    test('zero is unknown, not an age', () {
      expect(player(0).ageLabel, '-');
    });

    test('a missing age is unknown too', () {
      expect(player(null).ageLabel, '-');
    });

    test('a real age is shown as-is', () {
      expect(player(10).ageLabel, '10');
      expect(player(16).ageLabel, '16');
    });
  });
}
