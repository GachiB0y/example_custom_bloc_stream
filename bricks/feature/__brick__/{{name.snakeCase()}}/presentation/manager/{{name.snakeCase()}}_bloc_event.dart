part of '{{name.snakeCase()}}_bloc.dart';

/// Business Logic Component {{name.pascalCase()}} Events
@freezed
class {{name.pascalCase()}}Event with _${{name.pascalCase()}}Event {
  const {{name.pascalCase()}}Event._();

  /// Create
  const factory {{name.pascalCase()}}Event.create({required ItemData itemData}) = Create{{name.pascalCase()}}Event;

  /// Fetch
  const factory {{name.pascalCase()}}Event.fetch({required int id}) = Fetch{{name.pascalCase()}}Event;

  /// Update
  const factory {{name.pascalCase()}}Event.update({required Item item}) = Update{{name.pascalCase()}}Event;

  /// Delete
  const factory {{name.pascalCase()}}Event.delete({required Item item}) = Delete{{name.pascalCase()}}Event;

}
