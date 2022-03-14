class BaseException implements Exception {
  final String msg; // 直接向用户展示
  final String debugInfo; // 用于问题反馈，帮助定位BUG的信息，可以用stacktrace填充

  BaseException(this.msg, {this.debugInfo = ''});

  @override
  String toString({int maxInfoLen = 100}) =>
      '[$runtimeType]{msg: $msg, debugInfo: ${(debugInfo.length > maxInfoLen) ? '${debugInfo.substring(0, maxInfoLen)}...' : debugInfo}}';
}

/// 参数错误
class IllegalArgumentException extends BaseException {
  IllegalArgumentException(String msg) : super(msg);
}

/// 参数错误- 找不到指定实例, 例如通过id找不到对应的车间
class InstanceNotFoundException extends IllegalArgumentException {
  InstanceNotFoundException(String msg) : super('找不到实例: $msg');
}

/// 参数错误- 值对象验证出错
class ValidationException extends IllegalArgumentException {
  ValidationException(String msg) : super(msg);
}

/// 状态错误
/// 设置状态时发生错误, 例如仓库存储数量小于0
/// 或者在用例中的前提条件错误, 例如某用例只有在生产线为idle时才能调用
class InvalidStateException extends BaseException {
  InvalidStateException(String msg) : super('状态异常: $msg');
}

/// 状态错误- 功能正在开发
class FeatDeveloping extends InvalidStateException {
  FeatDeveloping(String msg) : super(msg);
}
