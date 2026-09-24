enum BillerCategory {
  electricity,
  water,
  gas,
  broadband,
  mobile,
  dth,
  creditCard,
}

class BillerField {
  final String key;
  final String label;
  final String regex;

  const BillerField({
    required this.key,
    required this.label,
    required this.regex,
  });

  factory BillerField.fromJson(Map<String, Object?> json) {
    return BillerField(
      key: json['key'] as String,
      label: json['label'] as String,
      regex: json['regex'] as String,
    );
  }
}

class Biller {
  final String id;
  final String name;
  final BillerCategory category;
  final String state;
  final List<BillerField> fields;
  final bool allowsPartial;

  const Biller({
    required this.id,
    required this.name,
    required this.category,
    required this.state,
    required this.fields,
    required this.allowsPartial,
  });

  factory Biller.fromJson(Map<String, Object?> json) {
    final fieldsJson =
        json['fields'] as List<Object?>;

    return Biller(
      id: json['id'] as String,
      name: json['name'] as String,
      category: BillerCategory.values.firstWhere(
        (category) =>
            category.name == json['category'],
      ),
      state: json['state'] as String,
      fields: fieldsJson
          .map(
            (field) => BillerField.fromJson(
              field as Map<String, Object?>,
            ),
          )
          .toList(),
      allowsPartial: json['allowsPartial'] as bool,
    );
  }
}