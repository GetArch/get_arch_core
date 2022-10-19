// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/6/12
// Time  : 18:35
/// Data Transfer Object
abstract class IDto {
  const IDto();

  Map<String, dynamic> toMap();

  @override
  String toString() => toMap().toString();
}
