// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/6/12
// Time  : 18:35
/// Dto类实现该接口
abstract class IDto {
  const IDto();

  @Deprecated('toMap, Will be removed in GetArchCore v4.0')
  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap();

  @override
  String toString() => toMap().toString();
}
