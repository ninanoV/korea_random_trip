class Division {
  final String name;
  final List<Division> children;

  const Division({
    required this.name,
    this.children = const [],
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Division &&
        other.name == name &&
        other.children == children;
  }

  @override
  int get hashCode => name.hashCode ^ children.hashCode;

  @override
  String toString() => 'Division(name: $name, children: ${children.length})';
}
