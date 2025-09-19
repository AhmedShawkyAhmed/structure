The core layers
Presentation Layer: Handles the user interface (UI) and user interactions. It uses a state management solution like BLoC, Cubit, or Riverpod to manage the UI state.
Components: Screens, widgets, and the state management logic (e.g., Cubits or BLoCs).
Responsibility: To receive user input and display data by reacting to state changes. It is unaware of where the data comes from.
Domain Layer: Contains the core business logic of the application. It is the most abstract and independent layer, with no dependencies on other layers.
Components:
Entities: Pure Dart objects representing your core business models (e.g., UserEntity). They are typically immutable and defined in this layer.
Use Cases (Interactors): Classes that encapsulate specific business rules and orchestrate data flow. They use repositories to get data and define application-specific features (e.g., GetUsersUseCase).
Repositories (Abstract): Interfaces that define contracts for the data layer to implement. The domain layer only knows about these contracts, not their implementation.
Data Layer: Responsible for data retrieval and persistence from external sources like APIs or databases. It implements the repository interfaces defined in the domain layer.
Components:
Models: Data models (e.g., UserModel) that often extend domain entities and include methods for parsing data from JSON or databases.
Data Sources: Classes for remote data (API calls, e.g., UserRemoteDataSource) and local data (database, e.g., UserLocalDataSource).
Repositories (Concrete): Implementations of the repository contracts defined in the domain layer. They coordinate data from one or more data sources and map it to domain entities