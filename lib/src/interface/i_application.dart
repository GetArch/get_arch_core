import 'package:get_arch_core/get_arch_core_interface.dart';

///
/// 一个程序中可以有多个[IPackage],但只能有一个[IApplication]
abstract class IApplication<C extends IConfig> implements IPackage<C> {
  Future<void> Function(GetIt getIt, C config)? get onBeforeAppInit;

  Iterable<IPackage> get packages;

  // App 的config 不能为空
  Future<void> run(GetIt getIt, C config);

  Future<void> Function(GetIt g)? get onBeforeAppRun;

  Future<void> Function(GetIt getIt, C config)? get onApplicationRun;

  Future<void> Function()? get onAfterAppRun;

  Future<void> Function(Object e, StackTrace s)? get onAppError;

  Future<void> Function()? get onAppFinally;
}
