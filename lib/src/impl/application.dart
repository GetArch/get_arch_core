import 'package:get_arch_core/get_arch_core.dart';

class GetArchCoreApplication extends GetArchCorePackage
    with MxAppRun<GetArchCoreConfig> {
  GetArchCoreApplication({
    this.packages = const [],
    this.onBeforeAppInit,
    this.onBeforeAppRun,
    this.onApplicationRun,
    this.onAfterAppRun,
    this.onAppError,
    this.onAppFinally,
  });

  @override
  final Future<void> Function(GetIt getIt, GetArchCoreConfig config)?
      onApplicationRun;

  @override
  final Future<void> Function()? onAfterAppRun;

  @override
  final Future<void> Function(Object e, StackTrace s)? onAppError;

  @override
  final Future<void> Function()? onAppFinally;

  @override
  final Future<void> Function(GetIt getIt, GetArchCoreConfig config)? onBeforeAppInit;

  @override
  final Iterable<IPackage<IConfig>> packages;

  @override
  final Future<void> Function()? onBeforeAppRun;
}
