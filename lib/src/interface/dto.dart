// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/6/12
// Time  : 18:35
/// Dto类实现该接口
abstract class IDto {
  const IDto();

  Map<String, dynamic> toJson();

  @override
  String toString() => toJson().toString();
}
