final class PizzaModel {
  static const tableName = 'pizza';
  static const columnId = '_id';
  static const columnName = 'name';
  static const columnPrice = 'price';
  static const columnImage = 'image';
}

class Pizza {
  int ?id;
  int ?price;
  String ?name;
  String ?image;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      PizzaModel.columnId: id,
      PizzaModel.columnName: name,
      PizzaModel.columnPrice: price,
      PizzaModel.columnImage: image,
    };
  }

  Pizza();

  Pizza.fromMap(Map<String, Object?> map) {
    id = map[PizzaModel.columnId] as int;
    price = map[PizzaModel.columnPrice] as int;
    name = map[PizzaModel.columnName] as String;
    image = map[PizzaModel.columnImage] as String;
  }
}
