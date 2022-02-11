// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/7/3
// Time  : 23:46

import 'package:get_arch_core/get_arch_core.dart';

typedef InitPackageDI = Future Function({
  required EnvConfig config,
  EnvironmentFilter? filter,
});

abstract class IGetArchPackage {
  /// 可空, 除了在构造时传入 pkgEnv, 还可以在 init() 中传入 masterEnv
  final EnvConfig? pkgEnv;

  /// 是否隐藏包配置信息, 以防止敏感信息谢林; null 表示自动配置,详见[BaseGetArchPackage]
  bool? hideSpecificConfigInfo;

  IGetArchPackage(this.pkgEnv);

  ///
  /// [masterEnv] 主环境, 必填
  /// [printConfig] 是否打印相关日志
  /// [filter] 根据主环境标志,选择性注入依赖
  ///   如果项目中只有一个 [GetArchPackage] 则可以为空
  ///   如果项目中有多个 [GetArchPackage] 则只有首个开始注入的[GetArchPackage]可以为空
  ///     否则将导致异常抛出,注入失败
  Future<void> init(
    EnvConfig masterEnv,
    bool printConfig,
    EnvironmentFilter? environmentFilter,
  );

  // 打印Package内接口实现的开关状态
  @protected
  Map<Type, bool?>? get interfaceImplRegisterStatus;

  /// 打印其他类型的Package配置信息
  Map<String, String>? specificConfigInfoWithEnvConfig(EnvConfig config);

  /// 初始化DI之前
  Future<void> beforeInitDI(EnvConfig config);

  /// 初始化包依赖注入
  /// 如果一个项目中同时使用了多个[IGetArchPackage],则务必使用 [gh]参数
  /// 因为同一个项目, 只能有唯一的[gh], 否则会导致DI失败
  InitPackageDI? get initPackageDI;

  /// 初始化DI之后
  Future<void> afterInitDI(EnvConfig config);

  /// DI出错
  Future<void> onInitError(Object e, StackTrace s);

  /// DI结束(无论是否出错都会被执行)
  Future<void> onFinally(EnvConfig config);
}

///
/// All GetArch packages must implement this class
/// 所有的GetArch包都必须实现本类
abstract class BaseGetArchPackage extends IGetArchPackage {
  BaseGetArchPackage([EnvConfig? pkgEnv]) : super(pkgEnv);

  ///
  /// [masterEnv] 主环境, 必填
  /// [printConfig] 是否打印相关日志
  /// [filter] 根据主环境标志,选择性注入依赖
  ///   如果项目中只有一个 [GetArchPackage] 则可以为空
  ///   如果项目中有多个 [GetArchPackage] 则只有首个开始注入的[GetArchPackage]可以为空
  ///     否则将导致异常抛出,注入失败
  @override
  Future<void> init(
    EnvConfig masterEnv,
    bool printConfig,
    EnvironmentFilter? environmentFilter,
  ) async {
    final EnvConfig env = pkgEnv ?? masterEnv;

    try {
      await beforeInitDI(env);
      await initPackageDI?.call(config: env, filter: environmentFilter);
      await afterInitDI(env);
    } catch (e, s) {
      await onInitError(e, s);
    } finally {
      await onFinally(env);
      // 打印配置信息
      if (printConfig) _printConf(env);
    }
  }

  // 起止行4个空格,信息内容行6个空格
  void _printConf(EnvConfig config, {bool? hideSpecificConfigInfo}) {
    // 如果类在创建时指定了不为空,则不再接受外部参数
    this.hideSpecificConfigInfo ??=
        hideSpecificConfigInfo ?? config.envSign == EnvSign.prod;
    final startLns = [
      '╠╬═════════════════════════════════════════════════════',
      '╠╣  [[$runtimeType]]',
      '╠╣  ',
    ];
    final maskEndLn = [
      '╚╚══ Package Config info hidden ═══════════════════════',
    ];
    const endLn = [
      '╚╚══ Package Config Loaded ════════════════════════════',
    ];
    final mainInfoLns = interfaceImplRegisterStatus?.entries
            .map((kv) =>
                '  <${kv.key}>Implement: ${kv.value == null ? "ERROR! Please check package's EnvConfig !" : kv.value! ? 'ON' : 'OFF'}')
            .toList() ??
        [];

    final specificConfigInfoLns = specificConfigInfoWithEnvConfig(config)
            ?.entries
            .map((kv) => '  ${kv.key} : ${kv.value}')
            .toList() ??
        [];

    final specificConfigInfo = this.hideSpecificConfigInfo!
        ? maskEndLn
        : specificConfigInfoLns + endLn;
    for (final ln in startLns + mainInfoLns + specificConfigInfo) {
      print(ln);
    }
  }

  // 打印Package内接口实现的开关状态
  @override
  @protected
  Map<Type, bool?>? get interfaceImplRegisterStatus => null;

  /// 打印其他类型的Package配置信息
  @override
  Map<String, String>? specificConfigInfoWithEnvConfig(EnvConfig config) =>
      null;

  /// 初始化DI之前
  @override
  Future<void> beforeInitDI(EnvConfig config) => Future.value();

  /// 初始化包依赖注入
  /// 如果一个项目中同时使用了多个[BaseGetArchPackage],则务必使用 [gh]参数
  /// 因为同一个项目, 只能有唯一的[gh], 否则会导致DI失败
  @override
  InitPackageDI? get initPackageDI;

  /// 初始化DI之后
  @override
  Future<void> afterInitDI(EnvConfig config) => Future.value();

  /// DI出错
  @override
  Future<void> onInitError(Object e, StackTrace s) async =>
      print('[$runtimeType].init ### Error: [\n$e\n]\nStackTrace[\n$s\n]');

  /// DI结束(无论是否出错都会被执行)
  @override
  Future<void> onFinally(EnvConfig config) => Future.value();
}

///
/// 指定配置文件类型的 BaseGetArchPackage
/// 将会自动打印配置信息
abstract class BaseConfigurableGetArchPackage<C extends IDto>
    extends BaseGetArchPackage {
  @override
  Map<String, String>? specificConfigInfoWithEnvConfig(EnvConfig config) {
    final key = "ConfigClass";
    if (sl.isRegistered<C>()) {
      final configJs = sl<C>().toJson();
      final r = configJs.map<String, String>(
          (key, value) => MapEntry('  $key', value.toString()));
      return {key: "[$C] register success"}..addAll(r);
    } else {
      return {
        key: "[$C] register failure. "
            "Try move your Main Package to first line in GetArchApplication.run(),"
            "Or check config class[$C] is register correct"
      };
    }
  }
}
