## Инициализация приложения + DI Container (без гет итов и прочих не нужных библиотек)

1. Фаил main
   Самов важное здесь указать runZoneGuarded, он помогает отловить все ошики, которые полетели мимио обработчиков **try..catch**. Так же ловит ошибки Flutter.
   Если изолят не обернуть в зону при инициализации приложения, то ошибка, которая полетит в него убьет изолят и ваше приложение крашниться.
   В качестве примера в зону вместо **print()** можно использовать любой логгер.
   **InheritedDependencies** инхерит виджет, которы йсодержит зависимости, которые можно достать из context.

```dart
void main() {
  runZonedGuarded<void>(
    () async {
      /// create initProgress
      /// where progreess this % of initialization
      /// and message this now initializing
      final initializationProgress =
          ValueNotifier<({int progress, String message})>(
              (progress: 0, message: ''));

      /// this show custom splash screen6 where show progress initialization
      /* runApp(SplashScreen(progress: initializationProgress)); */

      /// initializeApp with onProgress and onSuccess and onError
      /// where onProgress we set progress step and message
      /// and onSuccess we set dependencies
      /// onSuccess contains inherited Widget where we get dependencies from context
      $initializeApp(
        onProgress: (progress, message) => initializationProgress.value =
            (progress: progress, message: message),
        onSuccess: (dependencies) => runApp(
          InheritedDependencies(
            dependencies: dependencies,
            child: App(controller: ValueNotifier<List<Page<Object?>>>([])),
          ),
        ),
        onError: (error, stackTrace) {
          runApp(AppError(error: error));

          /// This we instead of print() write logger
          (error, stackTrace) =>
              print('Error with initialization: $error\n$stackTrace');
        },
      ).ignore();
    },

    /// This we instead of print() write logger
    // ignore: avoid_print
    (error, stackTrace) => print('Top level exception: $error\n$stackTrace'),
  );
}

```

2. Создаем файлик с инициализацией, который содержит **$initializeApp**. Переменная **\_$initializeApp**

```dart
Future<Dependencies>? _$initializeApp;

 _$initializeApp ??= Future<Dependencies>(() async { ... });
```

Нам нужна для того, если бует запущено несколько раз  **main()** (такое можно увидеть в ингетрационных тестах), то состояине кэшируется и у вас мейн не дублируеться. Кэшируем Future и не позволяем сделать initializeApp в однои изоляте более одного раза.

- Далее создаем вдижет биндинг, тоже самое происходит и в методе **runApp()**.
  Связывает Флаттер и Флаттер движок, для испоьзвоание последующих биндингов.
  Виндинги - синглтоны, можем вызывать сколько угодно раз. Дублируем, потому что может быть в начале кто то не делает **runApp(SpashScreen())**.
  **deferFirstFrame** позволяет задержать первый кадр и показать наш сплеш скрин, если не используешь свой сплеш скрин, можешь не делать этот метод и будет виден белый экран, т.к после инициализации биндингов, флаттер готов отображать контент, но по факту у вас еще нет нигде **runApp()**, значит будет виден пустой экран .

```dart
     final   binding = WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();

```

- Следующий шаг - ловим ошибки через **onError**. Важно понимать, что он не взаимоисключает **runZoneGuarded**.
  Перехватывает все корневые ошибки Флаттера и не крашит его.
  Любая Флаттер ошибка летит в:

```dart
   final sourceFlutterError = FlutterError.onError;

    /// Interceptor on FlutterError
    FlutterError.onError = (final details) {
      debugPrint(
          'FLUTTER ERROR\r\n: ${details.exception}\n${details.stack ?? StackTrace.current}');

      // FlutterError.presentError(details);
      sourceFlutterError?.call(details);
    };
```

В **FlutterError.onError = (final details){...}** летят флаттер ошибки, мы их ловим, обрабатываем логгером и дальше делаем метод **call()**, чтобы вызвать  логику ошибки и залогировать нашим логером.

- Далее инициализируем зависимости и передаем в onSuccess:

```dart
         await $initializeDependencies(onProgress: onProgress)
                .timeout(const Duration(minutes: 7));
        await onSuccess?.call(dependencies);
```

Помним что onSuccess инициализирует наш **App()** с зависимостями через инхерит виджет.

-Финальным действие разрешаем первый фрейм и обнуляем переменную инициализации:

```dart
   binding.addPostFrameCallback((_) {
          // Closes splash screen, and show the app layout.
          binding.allowFirstFrame();
          //final context = binding.renderViewElement;
        });
        _$initializeApp = null;
```

## Dependencies вместо GetIt

# Следующим шагом рассмотрим как можно сделать DIContainer без сторонних библиотек

1. Нам нужна следующая функция:

```dart
Future<Dependencies> $initializeDependencies({
  void Function(int progress, String message)? onProgress,
}) async {
  final dependencies = Dependencies();

  final totalSteps = _initializationSteps.length;
  var currentStep = 0;
  for (final step in _initializationSteps.entries) {
    try {
      currentStep++;

      /// need from show progress % in spash screen and message
      /// step.key - message
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);

      onProgress?.call(percent, step.key);

      /// This we instead of print() write logger
      debugPrint(
          'Initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');

    //In each step we pass our DI Container
      await step.value(dependencies);
    } on Object catch (error, stackTrace) {
      /// This we instead of print() write logger
      debugPrint(
        'Initialization failed at step "${step.key}": $error\nStackTrace: $stackTrace',
      );
      Error.throwWithStackTrace(
          'Initialization failed at step "${step.key}": $error', stackTrace);
    }
  }
  return dependencies;
}

```

2. Обычна хэш таблица. Где ключ - описание что инициализируется **String**, значение **FutureOr<void> Function(Dependencies dependencies)**
   это сама инициализация зависимости и запись ее в свойства класса Dependencies.

```dart
typedef _InitializationStep = FutureOr<void> Function(
    Dependencies dependencies);
final Map<String, _InitializationStep> _initializationSteps =
    <String, _InitializationStep>{
  'Platform pre-initialization': (_) => $platformInitialization(),
  'Rest Client': (dependencies) {
    dependencies.restClient = RestClient(
      baseUrl: 'https://example.com',
    );
  },
  'Color Api client': (dependencies) async {
    dependencies.colorApiClient =
        await ColorApiClient(httpClient: dependencies.restClient);
  },
  'Colors Repository': (dependencies) {
    dependencies.colorsRepository = ColorsRepositoryImpl(
      apiClient: dependencies.colorApiClient,
    );
  },
  'Color box BLoC': (dependencies) {
    final colorBoxBLoC = ColorBoxBloc(
      repository: dependencies.colorsRepository,
    )..fetch();
    dependencies.colorBoxBloc = colorBoxBLoC;
  },
  'Initialize localization': (_) {},
  'Migrate app from previous version': (_) {},
  'Collect logs': (_) {},
  'Log app initialized': (_) {},
};

```

Рассмотри что из себя представляет хэш таблица. Здесь на каждый шаг мы можем что т осделать, например сделать инициализацию **Firebase**,**Platform pre-initialization**.
Сама табличка помогает удобно делать шаги. Например наш  **ColorBoxBloc** принимает **ColorsRepositoryImpl**, репозиторий в свою очеред принимает **ColorApiClient**, а сам клиент фичи принимает общий **RestClient** на проект. И мы видим что все идет друг за другои и пошагу. Огромный плюс в том, что мы все видим, зависимости не скрыты в тонне нагенерированных файлов, тут ничего не потеряется при инициализации приложения, мы шаг за шагом создали все зависимости для  **ColorBoxBloc**.
Это очень удобно, и не нужен никакой GetIt + Injectable.
Например если нам нужен репозиторий то мы его создали на предыдущем шаге и можем вытащить на текущем через **dependencies.colorsRepository**. И так далее, если **RestClient** нам будет нужен на следующих шагах инициализации, то мы просто его вытащим из **dependencies.restClient**.
Так же плюс для новых разработчиков, при подключении к проекту у нас есть одно место где прописанны все зависимости. К тому же мало проектов, где кол-во зависимостей перевалит за 150-200, а их мы потихноьку добавляем по мере развитяи проекта и это намного удобнее использования стороних пакетов или инициализации через функции в main().

Теперь разберемся с функцией, в ней инициализриуем класс Dependencies, который будет содержать необходимые звисимости.
Для примера возьмем обычный **RestClient** - клиент для всех апишек, **IColorBoxClient** - апишка для фичи Color которая принимает в себя **RestClient**, **IRepositoryColorBox** - репозиторий, который принимает в себя клиент фичи, **ColorBoxBLoC** - бизнес логика, которая принимает в себя один/несколько репозиториев.
**Но стоит учесть, что бизнес логику можно ии нужно инициализировать по Scope, для экрана. Как пример сойдет.**
Для получения зависимостей из контекста создаем метод:

```dart
// create method get dependencies from context
  factory Dependencies.of(BuildContext context) =>
      InheritedDependencies.of(context);

// Get dependencies from context
final colorBoxBLoC = Dependencies.of(context).colorBoxBloc;
```

Взгялнем на наш получившийся класс **Dependencies**.

```dart

class Dependencies {
  Dependencies();

  /// The state from the closest instance of this class.
  factory Dependencies.of(BuildContext context) =>
      InheritedDependencies.of(context);

  /// Rest client
  late final RestClient restClient;

  /// Color Api client
  late final  IColorApiClient colorApiClient;

  /// Repository ColorBox
  late final IColorBoxRepository colorBoxRepository;

  /// ColorBoxBloc
  late final ColorBoxBloc colorBoxBloc;
}

```

Далее в функции **$initializeDependencies** проходимся по всей хэш табличке с помощью цикла **for**.
Это нам нужно чтобы на каждый шаг инициализации (Например шаг инициализации **RestClient**, потом шаг инициализации **IColorBoxClient** для Фичи  **Color** и т.д.)
нам нужно посчитать проценты percent, **step.key** - это **String** из хэш таблички, содержит описание шага инициализации, и передать все в **onProgress** для логирования.

```dart

 currentStep++;

      /// need from show progress % in spash screen and message
      /// step.key - message
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);

      onProgress?.call(percent, step.key);

```

Далее в вызывает у каждоого шага из хэш таблички метод инициализации и передает туда наш DI Container (**Dependencies**)

```dart
   //In each step we pass our DI Container
      await step.value(dependencies);
```

Итого мы сделали инициализацию приложения, в которой можно сделать кастомный спплеш скрин и он будет показывать проценты инициализации приложения, во время самого процесса. Так же у нас есть класс **Dependencies**, который реализует DI Container, где наглядно видно сами шаги, что за чем создается и наши зависимости мы можем получть из контекста инзерит виджета.
