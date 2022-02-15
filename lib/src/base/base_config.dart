import 'package:get_arch_core/get_arch_core_interface.dart';

///
/// 直接打印日志等信息
class PrintEchoCallMx implements IEchoCall {
  @override
  Iterable<String> Function(Iterable<String> lines) get echoCall => (lines) {
        lines.forEach(print);
        return lines;
      };
}

class GlobalConfig implements IGlobalConfig {
  @override
  final EchoCall echoCall;
  @override
  final EnvSign sign;
  @override
  final EnvironmentFilter filter;

  GlobalConfig(this.echoCall, this.filter, this.sign);

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'sign': sign.name,
        'EnvironmentFilter': "${filter.runtimeType}",
      };
}

///
/// [PrintEchoCallMx]直接通过 print 输出日志
class BaseConfig extends PrintEchoCallMx implements IConfig {
  BaseConfig({
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

  BaseConfig.build({
    required this.sign,
    required this.name,
    required this.version,
    required this.packAt,
    required this.filter,
    this.manualInject,
  });

  @override
  EnvSign sign;

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

///
/// 为不需要复杂配置的简单Package 提供一个默认的Config类
class SimplePackageConfig extends BaseConfig {
  SimplePackageConfig.package({
    required String name,
    required String version,
    required DateTime packAt,
  }) : super.build(
          // sign和filter将被 application中的配置覆盖
          sign: EnvSign.dev,
          filter: NoEnvOrContains(EnvSign.dev.name),
          name: name,
          version: version,
          packAt: packAt,
        );

  SimplePackageConfig(
      {required EnvSign sign,
      required String name,
      required String version,
      required DateTime packAt})
      : super(sign: sign, name: name, version: version, packAt: packAt);
}

class PrintPkgEchoDelegate implements IPkgEchoDelegate {
  @override
  IConfig config;

  @override
  EchoCall get echoCall => config.echoCall;

  String get pkgName => config.name;

  PrintPkgEchoDelegate(this.config);

  @override
  Iterable<String> echoOnBeforePkgInit({Iterable<String>? msg}) => echoCall([
        '╠╬═════════════════════════════════════════════════════',
        '╠╣  [[$pkgName]]',
        ...?msg,
      ]);

  @override
  Iterable<String> echoOnAfterPkgInit({Iterable<String>? msg}) => echoCall([
        ...?msg,
        '╠╬══ Package Loaded Successfully ══════════════════════',
      ]);

  @override
  Iterable<String> echoOnPkgInitError(Object e, StackTrace s,
          {Iterable<String>? msg}) =>
      echoCall([
        '╠╬══ Package Init Error ═══════════════════════════════',
        '     Package: [$pkgName] ',
        ...?msg,
        '    [Error Info]:',
        '\n$e\n',
        '    [StackTrace]:',
        '\n$s\n',
        '╠╬══ Package Error Info End ═══════════════════════════',
      ]);

  @override
  Iterable<String> echoOnPkgInitFinally({Iterable<String>? msg}) => echoCall([
        ...?msg,
        '╚╚══ Package Info End ═════════════════════════════════',
      ]);
}

class PrintAppEchoDelegate implements IAppEchoDelegate {
  final IConfig config;

  @override
  Iterable<String> Function(Iterable<String> lines) get echoCall =>
      config.echoCall;

  String get appName => config.name;

  PrintAppEchoDelegate(this.config);

  @override
  Iterable<String> echoOnBeforeAppInit({Iterable<String>? msg}) => echoCall([
        '╔╔═════════════════════════════════════════════════════',
        '╠╬══ Get Arch Application Starting ... ════════════════',
        ...?msg,
      ]);

  @override
  Iterable<String> echoOnAfterAppInit({Iterable<String>? msg}) => echoCall([
        ...?msg,
        '╠╬══ Application Initialization Complete ══════════════',
        '',
      ]);

  @override
  Iterable<String> echoOnAppRunError(Object e, StackTrace s,
          {Iterable<String>? msg}) =>
      echoCall([
        '╠╬══ Application Init Error ═══════════════════════════',
        '    [[$appName]] ',
        ...?msg,
        '    [Error Info]:',
        '\n$e\n',
        '    [StackTrace]:',
        '\n$s\n',
        '╚╚══ Application Loaded ═══════════════════════════════',
      ]);

  @override
  Iterable<String> echoOnAppRunFinally({Iterable<String>? msg}) => echoCall([
        ...?msg,
        '',
        '╚╚══ Application Info End ═════════════════════════════',
      ]);
}