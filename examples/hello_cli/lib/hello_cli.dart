import 'package:get_arch_core/get_arch_core.dart';
import 'package:hello_cli/src/application/service.dart';
import 'package:hello_cli/src/config/injector.dart';

class HelloCliPackage extends BaseGetArchPackage {
  @override
  InitPackageDI? get initPackageDI => configureDependencies;
}

Future<void> main(List<String> arguments) async {
  await GetArchApplication.run(
    EnvConfig.sign(EnvSign.dev, appName: 'Hello CLI'),
    packages: [
      HelloCliPackage(),
    ],
  );

  sl<ServiceBar>().calculate(2, 3);
}
