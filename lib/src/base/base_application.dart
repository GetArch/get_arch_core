import 'package:get_arch_core/get_arch_core_interface.dart';

///
/// onBeforeAppInit()
/// onBeforeAppRun()
/// onApplicationRun()
/// onAfterAppRun()
/// .. onAppError()
/// onAppFinally()
mixin MxAppRun<C extends IConfig> on MxPrePkgMx<C> implements IApplication<C> {
  late IAppEchoDelegate Function() appEcho;

  @override
  Future<void> run(GetIt getIt, C config) async {
    try {
      await onBeforeAppInit?.call(getIt, config);

      // 注入 [IAppEchoDelegate]
      if (!getIt.isRegistered<IAppEchoDelegate>()) {
        getIt.registerSingleton<IAppEchoDelegate>(
            PrintAppEchoDelegate(pkgConfig ?? config));
      }
      appEcho = getIt<IAppEchoDelegate>;

      appEcho().echoOnBeforeAppInit();

      /// App Init ------------------------------------------------------------
      pkgGetIt ??= getIt;
      // 查询是否有手动覆盖注入的配置, 有则覆盖
      pkgConfig = (pkgGetIt!).isRegistered<C>() ? (pkgGetIt!)<C>() : config;

      // 注册GlobalConfig
      if (!getIt.isRegistered<GlobalConfig>()) {
        getIt.registerSingleton<GlobalConfig>(GlobalConfig.of(pkgConfig!));
      }

      /// Init 自身(以及 manualInject)
      await packageInit(getIt, config: pkgConfig);

      // Init Packages
      for (final pkg in packages) {
        await pkg.packageInit(getIt);
      }
      // Init结束
      appEcho().echoOnAfterAppInit();

      /// App run ---------------------------------------------------------
      await onBeforeAppRun?.call(getIt);

      await onApplicationRun?.call(getIt, pkgConfig!);

      await onAfterAppRun?.call();
    } catch (e, s) {
      onAppError?.call(e, s);
      appEcho().echoOnAppRunError(e, s);
    } finally {
      appEcho().echoOnAppRunFinally(); // 防止echo出错
      onAppFinally?.call();
    }
  }
}
