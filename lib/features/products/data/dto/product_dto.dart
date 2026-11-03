import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

double readDouble(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  throw FormatException('Expected a number, got $value');
}

@JsonSerializable()
class ProductDto extends Equatable {
  const ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    this.brand,
    this.images = const [],
  });

  final int id;
  final String title;
  final String description;
  final String category;

  @JsonKey(fromJson: readDouble)
  final double price;

  @JsonKey(fromJson: readDouble)
  final double rating;

  final int stock;
  final String thumbnail;
  final String? brand;

  @JsonKey(defaultValue: <String>[])
  final List<String> images;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    price,
    rating,
    stock,
    thumbnail,
    brand,
    images,
  ];
}

@JsonSerializable(explicitToJson: true)
class ProductPageDto extends Equatable {
  const ProductPageDto({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<ProductDto> products;
  final int total;
  final int skip;
  final int limit;

  factory ProductPageDto.fromJson(Map<String, dynamic> json) =>
      _$ProductPageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductPageDtoToJson(this);

  @override
  List<Object?> get props => [products, total, skip, limit];
}
