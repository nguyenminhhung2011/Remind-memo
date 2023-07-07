enum TypeTransaction {
  lend,
  loan;

  bool get isLend => this == TypeTransaction.lend;

  int get toInt => switch (this) { TypeTransaction.lend => 0, _ => 1 };
}
