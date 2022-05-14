import 'package:firebase_database/firebase_database.dart';

class CategoryManager {
  CategoryManager() {
    fetchCategories();
  }
  List<Category> _categories = [];
  final _databaseRef = FirebaseDatabase.instance;
  Future<void> fetchCategories() async {
    final _snap = await _databaseRef.ref("categories").ref.orderByKey().get();
    if (_snap.value == null) {
      throw Exception('Category Not Found');
    }
    final Map cat = _snap.value as Map;
    _categories = [];
    cat.forEach((key, value) {
      _categories.add(
        Category.fromMap(
          {
            'title': key,
            'image': value['image'],
          },
        ),
      );
    });
  }

  List<Category> get categories {
    var _a = _categories;
    _a.sort((first, second) {
      return first.title.toLowerCase().compareTo(second.title.toLowerCase());
    });
    return _a;
  }

  Future<void> addCategory(String title, String image,
      [Category? catToUpdate]) async {
    await _databaseRef.ref("categories").child(title.trim()).set({
      'image': image,
    });
    if (catToUpdate != null) {
      _categories.remove(catToUpdate);
    }
    _categories.add(Category(
      title: title,
      image: image,
    ));
  }

  Future<void> deleteCategory(
    Category cat,
  ) async {
    await _databaseRef.ref('categories').child(cat.title).remove();
    _categories.remove(cat);
  }
}

class Category {
  final String title;
  final String image;

  Category({
    required this.title,
    required this.image,
  });

  Category copyWith({
    String? title,
    String? image,
  }) {
    return Category(
      title: title ?? this.title,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'image': image});

    return result;
  }

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        title: map['title'] ?? '',
        image: map['image'] ?? '',
      );

  @override
  String toString() => 'Category(title: $title, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category && other.title == title && other.image == image;
  }

  @override
  int get hashCode => title.hashCode ^ image.hashCode;
}
