part of 'user_bloc.dart';

/// Business Logic Component User Events
@freezed
class UserEvent with _$UserEvent {
  const UserEvent._();

  /// Create
  const factory UserEvent.create({required ItemData itemData}) =
      CreateUserEvent;

  /// Fetch
  const factory UserEvent.fetch({required int id}) = FetchUserEvent;

  /// Update
  const factory UserEvent.update({required Item item}) = UpdateUserEvent;

  /// Delete
  const factory UserEvent.delete({required Item item}) = DeleteUserEvent;
}
