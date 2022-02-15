import 'package:get_arch_core/get_arch_core.dart';

import 'injector.dart';

///
/// [GetArchCorePackage]只用于代码示例和打印logo, 没有业务逻辑
class GetArchCorePackage extends BasePackage<GetArchCoreConfig> {
  GetArchCorePackage({
    Future<void> Function(GetIt g, GetArchCoreConfig c)? onBeforePkgInit,
    Future<void> Function(GetIt g, GetArchCoreConfig config)? onAfterPkgInit,
    Future<void> Function(GetArchCoreConfig config, Object e, StackTrace s)?
        onPkgInitError,
    Future<void> Function(GetArchCoreConfig config)? onPkgInitFinally,
  }) : super.build(
          onBeforePkgInit: onBeforePkgInit,
          onAfterPkgInit: onAfterPkgInit,
          onPkgInitError: onPkgInitError,
          onPkgInitFinally: onPkgInitFinally,
          onPackageInit: initPackageDI,
        );
}

//   @override
//   Map<String, String> specificConfigInfoWithEnvConfig(EnvConfig? config) => {
//         'Frame Version':
//             '$version at ${DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toString().split(' ').first}',
//         'App      Name': '${config?.appName}',
//         'Lib   Version': '${config?.libVersion}',
//         'Build    Time': '${config?.packTime}',
//         'Runtime   Env': '${config?.envSign}',
//       };
// }
