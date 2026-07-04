enum MathOperation { addition, subtraction }

class MathQuestion {
  final int operand1;
  final int operand2;
  final MathOperation operation;
  final List<int> options;
  final int correctIndex;

  // This constructor creates a new "MathQuestion" object whenever we need one.
  MathQuestion({
    required this.operand1,
    required this.operand2,
    required this.operation,
    required this.options,
    required this.correctIndex,
  });

  // This method calculates the result so we don't have to do it in the UI.
  int get answer => operation == MathOperation.addition
      ? operand1 + operand2
      : operand1 - operand2;
}
