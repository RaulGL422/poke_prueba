class Pokemon {
  Pokemon({
    required this.numPokedex,
    required this.name,
    required this.photo,
    required this.habilities,
  });

  int numPokedex;
  String name;
  String photo;
  List<String> habilities;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pokemon && other.numPokedex == numPokedex;
  }

  @override
  int get hashCode => numPokedex.hashCode;
}