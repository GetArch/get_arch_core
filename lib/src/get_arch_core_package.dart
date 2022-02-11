
import 'package:get_arch_core/get_arch_core.dart';

import 'constants/pubspec.yaml.g.dart';

class GetArchCorePackage extends BaseGetArchPackage {
  // GetArchCore只接受全局EnvConfig
  GetArchCorePackage() : super(null) {
    super.hideSpecificConfigInfo = false;
  }

  @override
  InitPackageDI get initPackageDI => ({
    required EnvConfig config,
    EnvironmentFilter? filter,
  }) async =>
      GetItHelper(
        GetIt.I,
        filter != null ? null : config.envSign.name,
        filter,
      ).singleton<EnvConfig>(config);

  @override
  Map<String, String> specificConfigInfoWithEnvConfig(EnvConfig? config) => {
    'Frame Version':
    '$version at ${DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toString().split(' ').first}',
    'App      Name': '${config?.appName}',
    'Lib   Version': '${config?.libVersion}',
    'Build    Time': '${config?.packTime}',
    'Runtime   Env': '${config?.envSign}',
  };
}