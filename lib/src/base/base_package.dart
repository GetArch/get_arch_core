import 'package:get_arch_core/get_arch_core_interface.dart';

mixin MxPkgInit<C extends IConfig> implements IPackage<C> {
  IPkgEchoDelegate Function()? fetchPkgEcho;

  @override
  Future<void> pkgInit(GetIt getIt, C config) async {
    try {
      // 注入 [IPkgEchoDelegate], 并set config
      if (!getIt.isRegistered<IPkgEchoDelegate>()) {
        getIt.registerSingleton<IPkgEchoDelegate>(PrintPkgEchoDelegate(config));
      }
      fetchPkgEcho = getIt<IPkgEchoDelegate>;
      fetchPkgEcho!().config = config;

      // BeforeInit
      await onBeforePkgInit?.call(getIt, config);
      fetchPkgEcho!().echoOnBeforePkgInit();
      // Init
      await onPackageInit?.call(getIt, config);
      // AfterInit
      await onAfterPkgInit?.call(getIt, config);
      fetchPkgEcho!().echoOnAfterPkgInit();
    } catch (e, s) {
      onPkgInitError?.call(config, e, s);
      if (fetchPkgEcho != null) {
        fetchPkgEcho!().echoOnPkgInitError(e, s);
      } else {
        rethrow;
      }
    } finally {
      fetchPkgEcho?.call().echoOnPkgInitFinally();
      await onPkgInitFinally?.call(config);
    }
  }
}

///
/// [pkgPreInit] 中会从容器查询 [IPkgEchoDelegate],
///   如果为空,则会新建并注入 [PrintPkgEchoDelegate] 实例到容器中
mixin MxPrePkgMx<C extends IConfig> on MxPkgInit<C> implements IPackage<C> {
  GetIt? pkgGetIt;

  // 不使用 late, 防止 config在不为空的情况下, 被realConfig覆盖后,又初始化出错
  // 导致finally无法打印信息的情况
  @override
  C? get pkgConfig;

  set pkgConfig(C? pkg);

  @override
  Future<Tuple2<GetIt, C>> pkgPreInit(GetIt getIt, {C? config}) async {
    /// 检查配置类
    if ("$C" == "$IConfig") {
      throw BaseException(
          "Package[$runtimeType] must add generics[$IConfig], Or extends [$BaseSimplePackage]");
    }
    // 如果 [config] 为空, 那么[get]中一定在其他包中已经注入过了[config],否则报错
    if (config == null) {
      // 检查是否添加了配置类, 对[SimplePackageConfig]单独处理
      pkgConfig ??= getIt.isRegistered<C>()
          ? getIt<C>()
          : throw BaseException(
              'Package[$runtimeType] init fail,Please check if [$C] is registered successfully');
    } else {
      pkgGetIt = await config.manualInject?.call(
            getIt,
            environmentFilter: config.filter,
            environment: config.sign.name,
          ) ??
          getIt;
      // 查询是否有手动覆盖注入的配置
      pkgConfig ??= pkgGetIt!.isRegistered<C>() ? pkgGetIt!<C>() : config;
    }
    return Tuple2(pkgGetIt!, pkgConfig!);
  }
}

///  extends [IConfig] or [BaseConfig]
class BasePackage<C extends IConfig> extends IPackage<C>
    with MxPkgInit<C>, MxPrePkgMx<C> {
  @override
  C? pkgConfig;

  @override
  final Future<void> Function(GetIt g, C c)? onBeforePkgInit;

  @override
  final Future<void> Function(GetIt g, C config)? onAfterPkgInit;

  @override
  final Future<void> Function(C config, Object e, StackTrace s)? onPkgInitError;

  @override
  final Future<void> Function(C config)? onPkgInitFinally;

  @override
  final Future<void> Function(GetIt getIt, C config)? onPackageInit;

  BasePackage.build({
    Future<void> Function(GetIt g, C c)? onBeforePkgInit,
    Future<void> Function(GetIt g, C config)? onAfterPkgInit,
    Future<void> Function(C config, Object e, StackTrace s)? onPkgInitError,
    Future<void> Function(C config)? onPkgInitFinally,
    final Future<void> Function(GetIt getIt, C config)? onPackageInit,
  }) : this(
          onBeforePkgInit,
          onAfterPkgInit,
          onPkgInitError,
          onPkgInitFinally,
          onPackageInit,
        );

  BasePackage(
    this.onBeforePkgInit,
    this.onAfterPkgInit,
    this.onPkgInitError,
    this.onPkgInitFinally,
    this.onPackageInit,
  );
}

///
/// [pkgPreInit] 中会从容器查询 [IPkgEchoDelegate],
///   如果为空,则会新建并注入 [PrintPkgEchoDelegate] 实例到容器中
mixin MxSimplePrePkgMx<C extends SimplePackageConfig> on MxPkgInit<C>
    implements IPackage<C> {
  late GetIt pkgGetIt;

  // 不使用 late, 防止 config在不为空的情况下, 被realConfig覆盖后,又初始化出错
  // 导致finally无法打印信息的情况
  @override
  C? get pkgConfig;

  set pkgConfig(C? pkg);

  String get configInstanceName;

  @override
  Future<Tuple2<GetIt, C>> pkgPreInit(GetIt getIt, {C? config}) async {
    if ("$C" != "$SimplePackageConfig") {
      throw BaseException(
          "Package[$runtimeType] mixed[$MxSimplePrePkgMx],must add generics[$SimplePackageConfig]");
    }
    // 如果 [config] 为空, 那么[get]中一定在其他包中已经注入过了[config],否则报错
    if (config == null) {
      // 检查是否添加了配置类, 对[SimplePackageConfig]单独处理
      pkgConfig ??= getIt.isRegistered<C>(instanceName: configInstanceName)
          ? getIt<C>(instanceName: configInstanceName)
          : throw BaseException(
              'Package[$runtimeType] get config fail,Please check if [$SimplePackageConfig] with the name [$configInstanceName] is registered successfully');
    } else {
      pkgConfig = config;
    }
    pkgGetIt = await pkgConfig!.manualInject?.call(
          getIt,
          environmentFilter: pkgConfig!.filter,
          environment: pkgConfig!.sign.name,
        ) ??
        getIt;
    // 查询是否有手动覆盖注入的配置 (注意, 这里查询的是带有实例名的实例)
    pkgConfig ??= pkgGetIt.isRegistered<C>(instanceName: configInstanceName)
        ? pkgGetIt<C>(instanceName: configInstanceName)
        : config;
    return Tuple2(pkgGetIt, pkgConfig!);
  }
}

class BaseSimplePackage extends IPackage<SimplePackageConfig>
    with MxPkgInit<SimplePackageConfig>, MxSimplePrePkgMx<SimplePackageConfig> {
  @override
  SimplePackageConfig? pkgConfig;

  BaseSimplePackage.build({
    SimplePackageConfig? pkgConfig,
    Future<void> Function(GetIt g, SimplePackageConfig c)? onBeforePkgInit,
    Future<void> Function(GetIt g, SimplePackageConfig config)? onAfterPkgInit,
    Future<void> Function(SimplePackageConfig config, Object e, StackTrace s)?
        onPkgInitError,
    Future<void> Function(SimplePackageConfig config)? onPkgInitFinally,
    final Future<void> Function(GetIt getIt, SimplePackageConfig config)?
        onPackageInit,
  }) : this(
          pkgConfig,
          onBeforePkgInit,
          onAfterPkgInit,
          onPkgInitError,
          onPkgInitFinally,
          onPackageInit,
        );

  BaseSimplePackage(
    this.pkgConfig,
    this.onBeforePkgInit,
    this.onAfterPkgInit,
    this.onPkgInitError,
    this.onPkgInitFinally,
    this.onPackageInit,
  );

  @override
  String get configInstanceName => "$runtimeType";

  @override
  final Future<void> Function(GetIt g, SimplePackageConfig c)? onBeforePkgInit;

  @override
  final Future<void> Function(GetIt g, SimplePackageConfig config)?
      onAfterPkgInit;

  @override
  final Future<void> Function(
      SimplePackageConfig config, Object e, StackTrace s)? onPkgInitError;

  @override
  final Future<void> Function(SimplePackageConfig config)? onPkgInitFinally;

  @override
  final Future<void> Function(GetIt getIt, SimplePackageConfig config)?
      onPackageInit;
}
