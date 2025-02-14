/// Model class representing Savings data
class Savings {
  final int id;
  final double compA;
  final double compB;
  final double initialCompA;
  final double initialCompB;
  final double totalSavings;
  final double withdrawnCompA;
  final double withdrawnCompB;
  final String year;

  /// Constructor to initialize Savings object
  Savings({
    required this.id,
    required this.compA,
    required this.compB,
    required this.initialCompA,
    required this.initialCompB,
    required this.totalSavings,
    required this.withdrawnCompA,
    required this.withdrawnCompB,
    required this.year,
  });

  /// Converts Savings object to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'compA': compA,
      'compB': compB,
      'initialCompA': initialCompA,
      'initialCompB': initialCompB,
      'totalSavings': totalSavings,
      'withdrawnCompA': withdrawnCompA,
      'withdrawnCompB': withdrawnCompB,
      'year': year,
    };
  }

  /// Factory constructor to create a Savings object from a Map
  factory Savings.fromMap(Map<String, dynamic> map) {
    return Savings(
      id: map['id'],
      compA: map['compA'],
      compB: map['compB'],
      initialCompA: map['initialCompA'],
      initialCompB: map['initialCompB'],
      totalSavings: map['totalSavings'],
      withdrawnCompA: map['withdrawnCompA'],
      withdrawnCompB: map['withdrawnCompB'],
      year: map['year'],
    );
  }
}
