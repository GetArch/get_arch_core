import 'package:get_arch_core/get_arch_core.dart';
import 'package:get_arch_core/src/constants/pubspec.yaml.g.dart' as spec;

typedef DependencyInjectCall = Future<GetIt> Function(
  GetIt get, {
  EnvironmentFilter? environmentFilter,
  String? environment,
});

typedef EchoCall = Iterable<String> Function(Iterable<String> lines);

mixin IEchoCall {
  EchoCall get echoCall;
}

class PrintEchoCall implements IEchoCall {
  @override
  Iterable<String> Function(Iterable<String> lines) get echoCall =>
      (lines) => lines.map((line) {
            print(line);
            return line;
          });
}

mixin IPkgEchoDelegate on IEchoCall {
  Iterable<String> Function(EchoCall echo) get echoOnBeforePkgInit;

  Iterable<String> Function(EchoCall echo) get echoOnAfterPkgInit;

  Iterable<String> Function(EchoCall echo, Object e, StackTrace s)
      get echoOnPkgInitError;

  Iterable<String> Function(EchoCall echo) get echoOnPkgInitFinally;
}

mixin IPkgConfig implements IDto, IEchoCall {
// abstract class IPkgConfig implements IDto, IPkgEchoDelegate {
  String get name;

  String get version;

  DateTime get packAt;

  EnvSign get sign;

  EnvironmentFilter get filter;

  DependencyInjectCall? get manualInject;
}

/// 一个程序中可以有多个[IPackage]
abstract class IPackage<C extends IPkgConfig> {
  Future<void> packageInit(GetIt getIt, {C? config});

  Future<void> Function(GetIt getIt, C config)? get onPackageInit;

  Future<void> Function(C config)? get onBeforePkgInit;

  Future<void> Function(C config)? get onAfterPkgInit;

  Future<void> Function(C config, Object e, StackTrace s)? get onPkgInitError;

  Future<void> Function(C config)? get onPkgInitFinally;
}

///
mixin IAppEchoDelegate on IEchoCall {
// abstract class IAppEchoDelegate implements IPkgEchoDelegate {
  Iterable<String> Function() get echoOnBeforeAppInit;

  Iterable<String> Function() get echoOnAfterAppInit;

  Iterable<String> Function(Object e, StackTrace s) get echoOnAppRunError;

  Iterable<String> Function() get echoOnAppRunFinally;
}

// mixin IAppConfig implements IPkgConfig, IAppEchoDelegate {}
// abstract class IConfigExt implements IAppEchoDelegate {}

///
/// 一个程序中可以有多个[IPackage],但只能有一个[IApplication]
abstract class IApplication<C extends IPkgConfig> implements IPackage<C> {
  // App 的config 不能为空
  Future<void> run(GetIt getIt, C config);

  Future<void> Function()? get onBeforeAppRun;

  Future<void> Function(GetIt getIt, C config)? get onApplicationRun;

  Iterable<IPackage> get packages;

  Future<void> Function()? get onAfterAppRun;

  Future<void> Function(Object e, StackTrace s)? get onAppRunError;

  Future<void> Function()? get onAppRunFinally;
}

///
/// 实现

class PrintPkgEchoDelegate implements IPkgEchoDelegate {
  @override
  final EchoCall echoCall;

  PrintPkgEchoDelegate(this.echoCall);

  @override
  Iterable<String> Function(EchoCall onEcho) get echoOnBeforePkgInit =>
      (echo) => echo([
            '╠╬═════════════════════════════════════════════════════',
            '╠╣  [[$runtimeType]]',
            '╠╣  ',
          ]);

  @override
  Iterable<String> Function(EchoCall echo) get echoOnAfterPkgInit =>
      (echo) => echo([
            '╠╬══ Package Loaded Successfully ══════════════════════',
          ]);

  @override
  Iterable<String> Function(EchoCall echo, Object e, StackTrace s)
      get echoOnPkgInitError => (echo, e, s) => echo([
            '╠╬══ Package Init Error ═══════════════════════════════',
            '    [[$runtimeType]] ',
            '    [Error Info]:',
            '\n$e\n',
            '    [StackTrace]:',
            '\n$s\n',
            '╠╬══ Package Error Info End ═══════════════════════════',
          ]);

  @override
  Iterable<String> Function(EchoCall echo) get echoOnPkgInitFinally =>
      (echo) => echo([
            '╚╚══ Package Info End ═════════════════════════════════',
          ]);
}

class PrintAppEchoDelegate implements IAppEchoDelegate {
  @override
  final Iterable<String> Function(Iterable<String> lines) echoCall;

  PrintAppEchoDelegate(this.echoCall);

  @override
  Iterable<String> Function() get echoOnAfterAppInit => () => [
        '╔╔═════════════════════════════════════════════════════',
        '╠╬══ Get Arch Application Starting ... ════════════════',
      ];

  @override
  Iterable<String> Function(Object e, StackTrace s) get echoOnAppRunError =>
      (e, s) => [
            '╠╬══ Application Init Error ═══════════════════════════',
            '    [[$runtimeType]] ',
            '    [Error Info]:',
            '\n$e\n',
            '    [StackTrace]:',
            '\n$s\n',
            '╚╚══ Application Loaded ═══════════════════════════════',
          ];

  @override
  Iterable<String> Function() get echoOnBeforeAppInit => () => [
        '╠╬══ Application Have Been Loaded ═════════════════════',
      ];

  @override
  Iterable<String> Function() get echoOnAppRunFinally => () => [
        '╚╚══ Application Info End ═════════════════════════════',
      ];
}

// @JsonSerializable(createFactory: false)
// class GetArchCorePkgConfig   {
class BasePkgConfig extends PrintEchoCall implements IPkgConfig {
  BasePkgConfig({
    required EnvSign sign,
    required String name,
    required String version,
    required DateTime packAt,
    EnvironmentFilter? filter,
    DependencyInjectCall? manualInject,
  }) : this.build(
          sign: sign,
          name: name,
          version: version,
          packAt: packAt,
          filter: filter ?? NoEnvOrContains(sign.name),
          manualInject: manualInject,
        );

  BasePkgConfig.build({
    required this.sign,
    required this.name,
    required this.version,
    required this.packAt,
    required this.filter,
    this.manualInject,
  });

  @override
  final EnvSign sign;

  @override
  final String name;

  @override
  final String version;

  @override
  final DateTime packAt;
  @override
  final EnvironmentFilter filter;

  @override
  final DependencyInjectCall? manualInject;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'sign': sign.name,
        'name': name,
        'version': version,
        'packAt': packAt.toIso8601String(),
      };
}

class GetArchCorePkgConfig extends BasePkgConfig {
  GetArchCorePkgConfig({
    required EnvSign sign,
    EnvironmentFilter? filter,
    DependencyInjectCall? manualInject,
  }) : super(
          sign: sign,
          name: "GetArchCore",
          version: spec.version,
          packAt: DateTime.fromMillisecondsSinceEpoch(spec.timestamp * 1000),
          filter: filter,
          manualInject: manualInject,
        );

  Iterable<String> get logo => [
        r"╔╔═════════════════════════════════════════════════════",
        r"   _____      _                       _     ",
        r"  / ____|    | |       /\            | |    ",
        r" | |  __  ___| |_     /  \   _ __ ___| |__  ",
        r" | | |_ |/ _ \ __|   / /\ \ | '__ / __ | '_\ ",
        r" | |__| |  __/ |_   / ____ \| | | (__| | | |",
        r"  \_____|\___|\__| /_/    \_\_|  \___|_| |_| " "   v$version",
        r" ",
      ];
}

mixin BasePackageMx<C extends IPkgConfig> implements IPackage<C> {
  late IPkgEchoDelegate pkgEcho;
  late GetIt realGetIt;

  // 不使用 late, 防止 config在不为空的情况下, 被realConfig覆盖后,又初始化出错
  // 导致finally无法打印信息的情况
  C? realConfig;

  @override
  Future<void> packageInit(GetIt get, {C? config}) async {
    try {
      // 如果 [config] 为空, 那么[get]中一定在其他包中已经注入过了[config],否则报错
      if (config == null) {
        realConfig = get.isRegistered<C>()
            ? realGetIt<C>()
            : (throw BaseException(
                '包[$runtimeType]初始化失败,请检查配置类[$C]是否已经注入到容器中'));
      } else {
        realGetIt = await config.manualInject?.call(
              get,
              environmentFilter: config.filter,
              environment: config.sign.name,
            ) ??
            get;
        // 查询是否有手动覆盖注入的配置
        realConfig = realGetIt.isRegistered<C>() ? realGetIt<C>() : config;
      }
      //
      pkgEcho = sl.isRegistered<IPkgEchoDelegate>()
          ? sl<IPkgEchoDelegate>()
          : PrintPkgEchoDelegate(realConfig!.echoCall);
      // BeforeInit
      pkgEcho.echoOnBeforePkgInit(realConfig!.echoCall);
      await onBeforePkgInit?.call(realConfig!);
      // Init
      await onPackageInit?.call(realGetIt, realConfig!);
      // AfterInit
      pkgEcho.echoOnAfterPkgInit(realConfig!.echoCall);
      await onAfterPkgInit?.call(realConfig!);
    } catch (e, s) {
      pkgEcho.echoOnPkgInitError((realConfig ?? config)!.echoCall, e, s);
      onPkgInitError?.call((realConfig ?? config)!, e, s);
    } finally {
      pkgEcho.echoOnPkgInitFinally((realConfig ?? config)!.echoCall);
      await onPkgInitFinally?.call((realConfig ?? config)!);
    }
  }
}

///
/// 注意, 如果你想让Package可以 Application继承, 这里务必使用`T extends 配置类`,
/// 否则Application将继承失败.
/// ```dart
/// class GetArchCorePackage<T extends GetArchCorePkgConfig>{
///   // ...
/// }
/// class GetArchCoreApplication extends GetArchCorePackage<GetArchCoreAppConfig>
///     implements IApplication<GetArchCoreAppConfig> {
///   // ...
/// }
/// ```
class GetArchCorePackage<T extends GetArchCorePkgConfig>
    with BasePackageMx<T>
    implements IPackage<T> {
  @override
  final Future<void> Function(GetArchCorePkgConfig c)? onBeforePkgInit;

  @override
  final Future<void> Function(GetArchCorePkgConfig config)? onAfterPkgInit;

  @override
  final Future<void> Function(
      GetArchCorePkgConfig config, Object e, StackTrace s)? onPkgInitError;

  @override
  final Future<void> Function(GetArchCorePkgConfig config)? onPkgInitFinally;

  @override
  final Future<void> Function(GetIt getIt, GetArchCorePkgConfig config)?
      onPackageInit;

  GetArchCorePackage({
    this.onBeforePkgInit,
    this.onAfterPkgInit,
    this.onPkgInitError,
    this.onPkgInitFinally,
    this.onPackageInit,
  });
}

// class GetArchCoreAppConfig extends GetArchCorePkgConfig
//     with PrintPkgEchoDelegateMx, PrintAppEchoDelegateMx
//     implements IConfigExt {
//   GetArchCoreAppConfig({
//     required EnvSign sign,
//     DependencyInjectCall? manualInject,
//   }) : super(
//           sign: sign,
//           manualInject: manualInject,
//         );
// }

///
mixin BaseApplicationMx<C extends IPkgConfig> on BasePackageMx<C>
    implements IApplication<C> {
  late IAppEchoDelegate appEcho;

  @override
  Future<void> run(GetIt getIt, C config) async {
    try {
      await onBeforeAppRun?.call();

      appEcho = sl.isRegistered<IAppEchoDelegate>()
          ? sl<IAppEchoDelegate>()
          : PrintAppEchoDelegate(config.echoCall);

      /// Init ------------------------------------------------------------
      appEcho.echoOnBeforeAppInit();
      // Init 自身(以及 manualInject)
      await packageInit(getIt, config: config);
      // 查询是否有手动覆盖注入的配置
      realConfig = realGetIt.isRegistered<C>() ? realGetIt<C>() : config;

      // Init Packages
      for (final pkg in packages) {
        await pkg.packageInit(getIt, config: realConfig!);
      }
      // Init结束
      appEcho.echoOnAfterAppInit();

      /// App run ---------------------------------------------------------
      await onApplicationRun?.call(getIt, realConfig!);

      /// App run end
      await onAfterAppRun?.call();
    } catch (e, s) {
      appEcho.echoOnAppRunError(e, s);
      onAppRunError?.call(e, s);
    } finally {
      appEcho.echoOnAppRunFinally();
      onAppRunFinally?.call();
    }
  }
}

class GetArchCoreApplication extends GetArchCorePackage<GetArchCorePkgConfig>
    with
        BasePackageMx<GetArchCorePkgConfig>,
        BaseApplicationMx<GetArchCorePkgConfig>
    implements IApplication<GetArchCorePkgConfig> {
  GetArchCoreApplication({
    this.packages = const [],
    this.onBeforeAppRun,
    this.onApplicationRun,
    this.onAfterAppRun,
    this.onAppRunError,
    this.onAppRunFinally,
  });

  @override
  final Future<void> Function(GetIt getIt, GetArchCorePkgConfig config)?
      onApplicationRun;

  @override
  final Future<void> Function()? onAfterAppRun;

  @override
  final Future<void> Function(Object e, StackTrace s)? onAppRunError;

  @override
  final Future<void> Function()? onAppRunFinally;

  @override
  final Future<void> Function()? onBeforeAppRun;

  @override
  final Iterable<IPackage<IPkgConfig>> packages;
}

/// 提供一个通用入口
/// 供没有Application实现的Package测试使用
class GetArchApplication {
  static late IApplication proxyApplication;

  static Future run(
    GetArchCorePkgConfig config, {
    GetIt? getIt,
    Iterable<IPackage> packages = const [],
    onBeforeAppRun,
    onApplicationRun,
    onAfterAppRun,
    onAppRunError,
    onAppRunFinally,
  }) async {
    proxyApplication = GetArchCoreApplication(
      packages: packages,
      onBeforeAppRun: onBeforeAppRun,
      onApplicationRun: onApplicationRun,
      onAfterAppRun: onAfterAppRun,
      onAppRunError: onAppRunError,
      onAppRunFinally: onAppRunFinally,
    );
    return await proxyApplication.run(getIt ?? sl, config);
  }
}
