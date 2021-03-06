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
  // 用于打印package配置时排除重复项
  static Iterable<String> globalFields = ['sign', 'filter', 'echoCall'];

  EnvSign get sign;

  set sign(EnvSign s);

  EnvironmentFilter get filter;

  set filter(EnvironmentFilter f);

  set echoCall(EchoCall c);
}
mixin IPkgConfig implements IDto, IEchoCall {
  String get name;

  String get version;

  DateTime get packAt;

  DependencyInjectCall? get manualInject;
}

///
/// 配置包信息, toJson, 信息打印回调
mixin IConfig implements IPkgConfig, IGlobalConfig {}

///
mixin IAppEchoDelegate on IEchoCall {
  Iterable<String> echoOnBeforeAppInit({Iterable<String>? msg});

  Iterable<String> echoOnAfterAppInit({Iterable<String>? msg});

  Iterable<String> echoOnAppRunError(Object e, StackTrace s,
      {Iterable<String>? msg});

  Iterable<String> echoOnAppRunFinally({Iterable<String>? msg});
}
