class QueryFilters {
  final Map<String, dynamic> values;

  const QueryFilters(this.values);

  bool get isEmpty => values.isEmpty;

  Map<String, String> toQuery() {
    return values.map(
          (key, value) => MapEntry(key, value.toString()),
    );
  }
}
