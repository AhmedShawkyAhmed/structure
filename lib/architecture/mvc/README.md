An MVC (Model-View-Controller) pattern in Flutter separates the application into three distinct parts:
1. Model:
   Represents the data and business logic of the application.
   It is independent of the user interface.
   Examples include user data, product information, or any data structure your app manipulates.
2. View:
   Represents the user interface (UI) of the application.
   It displays the data from the Model and allows user interaction.
   In Flutter, this typically involves StatelessWidget or StatefulWidget classes.
3. Controller:
   Acts as an intermediary between the Model and the View.
   Handles user input, updates the Model based on those inputs, and instructs the View to update its display when the Model changes.

lib/
├── main.dart
├── model/
│   └── counter_model.dart
├── view/
│   └── counter_view.dart
└── controller/
└── counter_controller.dart