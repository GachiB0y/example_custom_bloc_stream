# bloc_stream

Как работать с mason.

1.  Добавляем зависмиость на ПК
    В MacOS

```
# 🍺 Or install from https://brew.sh
brew tap felangel/mason
brew install mason
```

2. Создадим папку bricks в корне проекта.
3. Используем команду для генерации нового брика .

```
mason new brick_name
```

4. Пропишем в mason.yaml путь к нашему брику

```
bricks:
  brick_name:
    path: bricks/brick_name
```

5.  В папке **brick** создаим нужный нам шаблон
6.  Добавим наш шаблон в mason

```
mason add -g brick_name --path bricks/brick_name

```

7. Сгенерируем код по шаблону mason

```
mason make brick_name --name #your name future#

#Example

mason make brick_bloc --name user

```

8. Код из примера сгенерирует папку блок, в которой лежит UserBloc, готовый к использованию!
