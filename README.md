# SmartFridge-QR-Control-IoT-Sync

### Разработчики 
1. Баваев Глеб
2. Ломакин Егор
3. Морозова Виолетта
4. Ольчадаевский Сергей
5. Карымов Евгений

### Основной функционал
- В приложении есть возможность добавлять в список и удалять из него продукты, которые хранятся в холодильнике путем сканирования соответствующего QR-кода.
- Приложение хранит и отображает название и категорию, даты изготовления и окончания срока годности, вес и объём, пищевую ценность находящихся в холодильнике продуктов, а также информацию об аллергенах в них.
- Приложение сообщает о приближении окончания срока годности продукта путём отправки уведомления.
- Приложение позволяет пользователям создавать список покупок перед следующим походом в магазин.
- Приложение хранит статистику об удаленных и добавленных продуктах.

### Установка
> [!IMPORTANT]
> Для запуска приложения на устройстве нужен компьютер с установленной MacOS и телефон/эмулятор работающий под управлением операционной системы iOS
Для установки приложения необходимо выполнить следующие шаги:

<details><summary>1. Скачивание репозитория на локальный компьютер</summary>
  
  - Открыть терминал
  - Ввести следующие команды:
    + cd путь_к_папке_в_которую_нужно_скопировать
    + git clone https://github.com/kupriyanovNik/MyFridge.git
  - Закрыть терминал (опционально)
</details>

<details><summary>2. Открытие и подготовка к запуску проекта</summary>
  
 - Запустить [Xcode](https://developer.apple.com/xcode/)
  - Одновременно нажать cmd + shift + 1
  - Нажать "Open Existing Project..."
  - Найти в файловой системе компьютера скопированную папку
  - В папке выделить файл "MyFridge.xcodeproj"
  - Нажать кнопку "Open" / нажать "return" или "Enter" на клавиатуре (зависит от раскладки клавиатуры)
  - Следующие шаги раздела необходимы **только** для запуска на физическом устройстве
     - Перейти в Project Navigator (одновременно нажать cmd + 1)
     - Нажать на корневой элемент в файловой системе проекта (иконка Xcode, справа от которой будет написано MyFridge)
     - В появившемся окне выбрать вкладку "Signing & Capabilities"
     - Поменять [Bundle ID](https://developer.apple.com/documentation/appstoreconnectapi/bundle_ids) на собственный
</details>

<details><summary>3. <a href="https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device">Запуск проекта на физическом устройстве или в симуляторе</a></summary>

  - Одновременно нажать cmd + shift + 2
  - Выбрать симулятор или физическое устройство в качестве Run Destination
  - Закрыть окно выбора Run Destination (красная кнопка слева сверху / одновременно нажать cmd + w)
  - Запустить (в верхнем меню Product -> Run / одновременно нажать cmd + r)
</details>

Демонстрация работы проекта: Demo
