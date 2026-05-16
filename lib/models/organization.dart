class Organization {
  const Organization({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdBy,
  });

  factory Organization.fromFirestore(String id, Map<String, dynamic> data) {
    return Organization(
      id: id,
      name: (data['name'] as String?) ?? 'Untitled Organization',
      slug: (data['slug'] as String?) ?? id,
      createdBy: (data['createdBy'] as String?) ?? '',
    );
  }

  final String id;
  final String name;
  final String slug;
  final String createdBy;
}

String organizationSlugFromName(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}
