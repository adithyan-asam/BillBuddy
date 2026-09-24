class SavedBiller {
  final String id;
  final String billerId;
  final String nickname;
  final Map<String, String> fields;

  const SavedBiller({
    required this.id,
    required this.billerId,
    required this.nickname,
    required this.fields,
  });
}