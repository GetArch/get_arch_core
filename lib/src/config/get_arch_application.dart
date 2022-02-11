// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/6/17
// Time  : 0:17

import 'package:get_arch_core/get_arch_core.dart';
import 'package:get_arch_core/src/constants/pubspec.yaml.g.dart';

/// App运行
/// 在main()中,必须先执行 WidgetsFlutterBinding.ensureInitialized();
///
/// ```dart
/// main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await GetArchApplication.run(EnvConfig(...), packages: [...]);
///   runApp(MyApp());
/// }
/// ```
/// [globalConfig] 全局环境配置
/// [printConfig] 在Flutter中建议设置该值为 !kReleaseMode
/// [packages] 其他实现了[IGetArchPackage / BaseGetArchPackage]的类
/// [mockDI] 该函数提供了一个 GetIt实例参数, 用于在单元测试中注册用于调试的依赖

// 打印GetArgLogo和版本
List<String> getArchLogo(EnvConfig env) => [
      r"╔╔═════════════════════════════════════════════════════",
      r"   _____      _                       _     ",
      r"  / ____|    | |       /\            | |    ",
      r" | |  __  ___| |_     /  \   _ __ ___| |__  ",
      r" | | |_ |/ _ \ __|   / /\ \ | '__ / __ | '_\ ",
      r" | |__| |  __/ |_   / ____ \| | | (__| | | |",
      r"  \_____|\___|\__| /_/    \_\_|  \___|_| |_| " "   v$version",
      r" ",
    ];

typedef DependencyInjection = Future<GetIt> Function(
  GetIt get, {
  EnvironmentFilter? environmentFilter,
  String? environment,
});

class GetArchApplication {
  static const _endIns = [
    '╠╬══ All configurations have been loaded ══════════════',
    '╚╚═════════════════════════════════════════════════════',
  ];

  static Future run(
    EnvConfig masterEnv, {
    bool printConfig = true,
    required List<IGetArchPackage>? packages,
    DependencyInjection? manualInject,
    List<String> Function(EnvConfig env) logo = getArchLogo,
    void Function(Object e, StackTrace s)? onInitError,
  }) async {
    try {
      for (final ln in logo(masterEnv)) {
        print(ln);
      }
      final filter = NoEnvOrContains(masterEnv.envSign.name);

      // 预先注册环境标志, 防止多GetItHelper冲突
      // 多GH冲突的原因可能就是 注册的是 <Set<String?> 可实际检测的却是<Set<String>>导致的
      // 单GH无法发现, 目前只能用预先注册的方式通过通过检测
      GetIt.I.registerSingleton<Set<String>>(
        filter.environments.map<String>((e) => e.toString()).toSet(),
        instanceName: kEnvironmentsName,
      );
      GetIt.I.registerSingleton<Set<String?>>(
        filter.environments,
        instanceName: kEnvironmentsName,
      );
      await GetArchCorePackage().init(masterEnv, printConfig, filter);
      await manualInject?.call(GetIt.I, environmentFilter: filter);
      if (packages != null) {
        for (final pkg in packages) {
          await pkg.init(masterEnv, printConfig, filter);
        }
      }
      for (final ln in _endIns) {
        print(ln);
      }
    } catch (e, s) {
      onInitError?.call(e, s);
      print('GetArchApplication.run #### Init Error: [$e]\nStackTrace[\n$s\n]');
    }
  }
}
