MVP components
Model: Holds the data and business logic. It has no knowledge of the View or Presenter.
View: The user interface. It is passive, simply displaying data provided by the Presenter and forwarding user interactions back to the Presenter.
Presenter: An intermediary that contains the business logic. It responds to user input from the View, manipulates the Model, and updates the View with new data