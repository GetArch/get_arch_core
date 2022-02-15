import 'package:get_arch_core/get_arch_core_interface.dart';

typedef DependencyInjectCall = Future<GetIt> Function(
  GetIt get, {
  EnvironmentFilter? environmentFilter,
  String? environment,
});

typedef EchoCall = Iterable<String> Function(Iterable<String> lines);

mixin IEchoCall {
  EchoCall get echoCall;
}

mixin IPkgEchoDelegate on IEchoCall {
  IConfig get config;

  set config(IConfig c);

  Iterable<String> echoOnBeforePkgInit({Iterable<String>? msg});

  Iterable<String> echoOnAfterPkgInit({Iterable<String>? msg});

  Iterable<String> echoOnPkgInitError(Object e, StackTrace s,
      {Iterable<String>? msg});

  Iterable<String> echoOnPkgInitFinally({Iterable<String>? msg});
}

///
/// 如果项目中存在多个[IPackage]
/// 将只有实现了[IApplication]的[IPackage]所对应的[IGlobalConfig]生效
mixin IGlobalConfig implements IDto, IEchoCall {
  EnvSign get sign;

  EnvironmentFilter get filter;
}

///
/// 配置包信息, toJson, 信息打印回调
mixin IConfig implements IGlobalConfig {
  String get name;

  String get version;

  DateTime get packAt;

  DependencyInjectCall? get manualInject;
}

///

///
mixin IAppEchoDelegate on IEchoCall {
// abstract class IAppEchoDelegate implements IPkgEchoDelegate {
  Iterable<String> echoOnBeforeAppInit({Iterable<String>? msg});

  Iterable<String> echoOnAfterAppInit({Iterable<String>? msg});

  Iterable<String> echoOnAppRunError(Object e, StackTrace s,
      {Iterable<String>? msg});

  Iterable<String> echoOnAppRunFinally({Iterable<String>? msg});
}
