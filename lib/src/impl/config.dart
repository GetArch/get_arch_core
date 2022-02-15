import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:get_arch_core/src/constants/pubspec.yaml.g.dart' as spec;

class GetArchCoreConfig extends BaseConfig {
  GetArchCoreConfig.sign(
    EnvSign sign, {
    EnvironmentFilter? filter,
    DependencyInjectCall? manualInject,
  }) : this(
          sign: sign,
          filter: filter,
          manualInject: manualInject,
        );

  /// 自动配置[version], [packAt]
  GetArchCoreConfig({
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
}

class GetArchCoreEchoDelegate extends PrintPkgEchoDelegate {
  GetArchCoreEchoDelegate(IConfig config) : super(config);

  String get version => config.version;

  Iterable<String> get logo => [
        r"╔╔═════════════════════════════════════════════════════",
        r"   _____      _                       _     ",
        r"  / ____|    | |       /\            | |    ",
        r" | |  __  ___| |_     /  \   _ __ ___| |__  ",
        r" | | |_ |/ _ \ __|   / /\ \ | '__ / __ | '_\ ",
        r" | |__| |  __/ |_   / ____ \| | | (__| | | |",
        r"  \_____|\___|\__| /_/    \_\_|  \___|_| |_|    " "v$version",
        r" ",
      ];

  @override
  Iterable<String> echoOnBeforePkgInit({Iterable<String>? msg}) => echoCall([
        ...logo,
        '╠╬═════════════════════════════════════════════════════',
        '╠╣  [[$pkgName]]',
        '╠╣  ',
        ...?msg,
      ]);
}
