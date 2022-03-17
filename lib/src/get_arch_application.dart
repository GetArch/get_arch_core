import 'package:get_arch_core/get_arch_core.dart';

/// 提供一个通用入口
/// 供没有[IApplication]实现的[IPackage]测试使用
class GetArchApplication {
  static late IApplication proxyApplication;

  static Future run(GetArchCoreConfig config,
      {GetIt? getIt,
      Iterable<IPackage<IConfig>> packages = const [],
      Future<void> Function(GetIt getIt, GetArchCoreConfig config)?
          onBeforeAppInit,
      Future<void> Function(GetIt g)? onBeforeAppRun,
      Future<void> Function(GetIt getIt, GetArchCoreConfig config)?
          onApplicationRun,
      Future<void> Function()? onAfterAppRun,
      Future<void> Function(Object e, StackTrace s)? onAppRunError,
      Future<void> Function()? onAppRunFinally}) async {
    proxyApplication = GetArchCoreApplication(
      packages: packages,
      onBeforeAppInit: onBeforeAppInit,
      onBeforeAppRun: onBeforeAppRun,
      onApplicationRun: onApplicationRun,
      onAfterAppRun: onAfterAppRun,
      onAppError: onAppRunError,
      onAppFinally: onAppRunFinally,
    );
    return await proxyApplication.run(getIt ?? sl, config);
  }
}
