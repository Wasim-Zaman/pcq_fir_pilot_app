import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Available action types for gate pass operations
enum ActionType {
  checkOut('CHECK_OUT', 'Check Out'),
  checkIn('CHECK_IN', 'Check In'),
  returnOut('RETURN_OUT', 'Return Out'),
  returnIn('RETURN_IN', 'Return In');

  final String value;
  final String displayName;

  const ActionType(this.value, this.displayName);
}

/// Notifier to manage the selected action type state
/// This state will persist and be used across different providers
class ActionTypeNotifier extends Notifier<ActionType> {
  @override
  ActionType build() {
    // Default to CHECK_OUT
    return ActionType.checkOut;
  }

  /// Update the selected action type
  void setActionType(ActionType actionType) {
    state = actionType;
  }
}

/// Provider to manage the selected action type state
final actionTypeProvider = NotifierProvider<ActionTypeNotifier, ActionType>(() {
  return ActionTypeNotifier();
});

/// Provider for the list of available action types
final actionTypeListProvider = Provider<List<ActionType>>((ref) {
  return ActionType.values;
});
