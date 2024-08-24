class Pokemon {
  Pokemon({
    required this.name,
    required this.url
  });

  bool loadedDetails = false;

  String url;
  int numPokedex = -1;
  String name;
  String photo = "";
  List<String> habilities = [];
  List<String> types = [];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pokemon && other.numPokedex == numPokedex;
  }

  @override
  int get hashCode => numPokedex.hashCode;
}