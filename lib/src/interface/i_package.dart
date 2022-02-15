import 'package:get_arch_core/get_arch_core_interface.dart';

/// 一个程序中可以有多个[IPackage]
abstract class IPackage<C extends IConfig> {
  // IApp中将会调用
  Future<void> packageInit(GetIt getIt, {C? config}) async {
    final tp = await pkgPreInit(getIt, config: config);
    return await pkgInit(tp.value1, tp.value2);
  }

  /// Package持有的配置类,可以为空(从容器获取)
  C? get pkgConfig;

  Future<void> Function(GetIt getIt, C config)? get onBeforePkgInit;

  /// 加载/处理[config]
  /// [config] 只有在作为Application的时候,才会被传入参数
  Future<Tuple2<GetIt, C>> pkgPreInit(GetIt getIt, {C? config});

  /// [config]来自 [pkgPreInit]返回值
  Future<void> pkgInit(GetIt getIt, C config);

  Future<void> Function(GetIt getIt, C config)? get onPackageInit;

  Future<void> Function(GetIt getIt, C config)? get onAfterPkgInit;

  Future<void> Function(C config, Object e, StackTrace s)? get onPkgInitError;

  Future<void> Function(C config)? get onPkgInitFinally;
}
