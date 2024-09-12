## Декларативная навигация в приложение через Navigator 2.0. Без всяких пакетов ролтон.

1. Во Flutter появилась полность декларативная навигация с добовлением Navigator 2.0. Стоить различать Navigator и Router. Это два разных класса и у них разны йпринцип работы. Сегодня поговорим про Navigator 2.0 - декларативный навиагтор. Для его применения мы так же обращаемся к классу Navigator.

```dart
List<Page<dynamic>> pages = const <Page<dynamic>>[];

 bool _onPopPage(Route<Object?> route, Object? result) {
   if(!route.didPop(result)) return false;
   if(_page.length > 1){
    _pages.removeLast();
    return true;
   }
    return false;
  }

 Navigator(
        pages: pages,
        onPopPage: _onPopPage,
      );
```

Для нас все такк же в корне MaterialApp размещаем навигатор в метод builder. В Navigator передать List<Page<dynamic>> pages, который будет меняться в зависимости от того, что нам нужно, а так же переопределить метод onPopPage - что будет происходить при pop().

2. Создадим класс для навигации по приложению.

```dart
class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key, required this.home, required this.controller});

  /// Экран  при пустом стаке страниц
  final Page<Object?> home;

  /// Контроллер для навигации по страницам декаларативно
  final ValueNotifier<List<Page<Object?>>>? controller;

  /// Метод для декларативной навигации по страницам
  static void change(BuildContext context,
      List<Page<Object?>> Function(List<Page<Object?>>) fn) {
    context.findAncestorStateOfType<_AppNavigatorState>()?.change(fn);
  }

  /// Метод для получения текущих страниц в навигаторе
  /// Например для использования хлебных крошек
  static List<Page<Object?>> pagesOf(BuildContext context) =>
      context
          .findAncestorStateOfType<_AppNavigatorState>()
          ?._controller
          .value
          .toList(growable: false) ??
      <Page<Object?>>[];

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  late ValueNotifier<List<Page<Object?>>> _controller;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        ValueNotifier<List<Page<Object?>>>(<Page<Object?>>[widget.home]);
    if (_controller.value.isEmpty) {
      _controller.value = <Page<Object?>>[widget.home];
    }
    _controller.addListener(_onStateChanged);
  }

  @override
  void didUpdateWidget(covariant AppNavigator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(_controller, widget.controller)) {
      _controller.removeListener(_onStateChanged);
      _controller = widget.controller ??
          ValueNotifier<List<Page<Object?>>>(<Page<Object?>>[widget.home]);
      if (_controller.value.isEmpty)
        // ignore: curly_braces_in_flow_control_structures
        _controller.value = <Page<Object?>>[widget.home];
      _controller.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    super.dispose();
  }

  /// Декларативное изменение страниц
  void change(List<Page<Object?>> Function(List<Page<Object?>>) fn) {
    final pages = fn(_controller.value);
    if (identical(pages, _controller.value)) return;

    /// Если состояние ( стек ) страниц не изменилось, то выходим без имзенений
    /// Далее идет проверка на дубликаты и на null ключ
    final set = <LocalKey>{};
    final newPages = <Page<Object?>>[];
    for (var i = pages.length - 1; i >= 0; i--) {
      final page = pages[i];
      final key = page.key;
      if (set.contains(page.key) || key == null) continue;

      /// Если есть дубликат или ключ null, то выходим без имзенений
      set.add(key);

      /// Т.к. это стек, то добавляем в начало
      newPages.insert(0, page);
    }
    if (newPages.isEmpty) newPages.add(widget.home);

    /// Возвращаем иммутабельный список новых страниц
    _controller.value = UnmodifiableListView<Page<Object?>>(newPages);
  }

  @protected
  void _onStateChanged() => setState(() {});

  @protected
  bool _onPopPage(Route<Object?> route, Object? result) {
    if (!route.didPop(result)) return false;
    final pages = _controller.value;
    if (pages.length <= 1) return false;
    // Здесь можно разместить вашу кастомную обработку метода onPopPage
    _controller.value =
        UnmodifiableListView<Page<Object?>>(pages.sublist(0, pages.length - 1));
    return true;
  }

  @override
  Widget build(BuildContext context) => Navigator(
        pages: _controller.value.toList(growable: false),
        onPopPage: _onPopPage,
      );
}
```

**AppNavigator** - виджет, в билд методе этого виджета создаем **Navigator** и передаем туда pages и переопределем **onPopPage**.
Navigator работает с классом **Pages** и это не виджет, это одна из причин почему не стоит экраны называть как page. Насызвайе их screen.
HomeScreen, LoginScreen и т.д. иначе возникает коллизия имен. Класс **Pages** задает настройки роутера для навигатора внутри экрана.

Переменная pages - в данном случае это контроллер **ValueNotifier<List<Page<Object?>>>? controller**. Можно использовать просто **List<Page<Object?>>**, главное чтобы вы понимали как будете разруливать список нужных вам страниц.

3. Метод для изменения списка страниц.

Назовем его **change**, в себя он принимает функцию которая дает текущий спиок страниц, и возвращает модернизированный список страниц.

```dart

  static void change(BuildContext context,
      List<Page<Object?>> Function(List<Page<Object?>>) fn) {
    context.findAncestorStateOfType<_AppNavigatorState>()?.change(fn);
  }
```

Пример простой реализации метода **change**, пердположим в состоянии вы используете список \_pages:

```dart
List<Page<Object?>> _pages = <Page<Object?>> [];

void change(List<Page<Object?>> Function(List<Page<Object?>>) fn){
    if(!mounted) return;
    final newPAges = fn(_pages);//  вы можете использовать свйо список List<Page<Object?>> _pages или контроллер _controller.value
    if (identical(pages, _pages)) return;// Сравниваем, если список не поменялся просто  выходим
    if (listEquals(pages, _pages)) return;
    setState(()=> _pages = newPAges);// Список поменялся - применим изменени

}

```

4. Как использовать наш метод **change**

Чтобы перейти на новый экран, нам нужно вызвать наш навигатор, у него метод **change**, в него передаем context, чтобы могли найти наш навигатор по дереву вверх, а так же функцию, которая дает нам текущие страницы в навигаторе, и возвращает модернизированный список в который мы вложили текущие страницы
(..pages) + наш **HomeScreen** обернутый в **MaterialPage**. В MaterialPage передаем **key** - чтобы навигатор понимал что экраны уникальны.

```dart

onTap:() => AppNavigator.change(
    context,
    (pages)=> <Page<Object?>>[
        ...pages,
        const с<Object?>(
            key: ValueKey<String>('home_screen'),
            child:HomeScreen(),

        ),
    ],
),


```

5. Создадим обертку над **MaterialPage**, чтобы у нас были роуты все в одном месте.

Создаем **enum AppPages** .
В методе page делаем обертку из MaterialPage. Здесь я решил, что если страницы одинаковые, например мы пушим CatalogScreen несколько раз, но с разными аргументами, то аргумент и будет ключом **arguments == null ? this : arguments.values.first**.

А так получисля +- похожий на генератор страниц из любой популярной библы.

```dart
enum AppPages {
  home('home', title: 'Home'),
  login('profile', title: 'Profile');


  const AppPages(this.name, {this.title});

  final String name;

  final String? title;

  // Метод для получения страницы с передачей аргументов
  Page<Object?> page({Map<String, String>? arguments}) => MaterialPage<Object?>(
        key:
            ValueKey<Object>(arguments == null ? this : arguments.values.first),
        child: Builder(builder: (context) {
          return builder(context, arguments);
        }),
      );

  // Обновленный метод builder с поддержкой аргументов
  Widget builder(BuildContext context, Map<String, String>? arguments) {
    switch (this) {
      case AppPages.home:
        return const HomeScreen();
      case AppPages.profile:
        return const ProfileScreen();
    }
  }
}


```

6. Глянем как нам теперь использовать метод **change**

Как пример, в аргументы прокинем переменную username.
Получили запись короче и лаконичнее, а главное теперь мы храним в одном месте все наши роуты.

```dart
  onTap: () => AppNavigator.change(
                      context,
                      (pages) => [
                        ...pages,
                        AppPages.profile
                            .page(arguments: {'profile': username}),
                      ],
                ),
```

7. Теперь у нас есть полность декларативный роутер, который позволит без всяких пактов Роултонов делат навигацию в приложение, такую как мы захотим.
   Нам не нужно шаблонизировать и хардкодить каждое из возможных состояний прилодения. Мы сами меняем это состояние через функцию change и передаем туда нам нужный список страниц.

   Важно понимать, что выше написанное не 100% истина, код я писал под себя для своих проекто. Пробуйте и улучшайте этот код под себя, всячески модернизируйте его и т.д.
