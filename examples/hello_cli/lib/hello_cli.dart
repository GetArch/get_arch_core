import 'package:get_arch_core/get_arch_core.dart';
import 'package:hello_cli/src/application/service.dart';
import 'package:hello_cli/src/config/injector.dart';

class HelloCliPackage extends BaseSimplePackage {
  HelloCliPackage()
      : super.build(
          pkgConfig: SimplePackageConfig.package(
            name: "HelloCliPackage",
            version: "0.0.0",
            packAt: DateTime(2022, 2, 14),
          ),
          onPackageInit: initPackageDI,
        );
}

Future<void> main(List<String> arguments) async {
  await GetArchApplication.run(
    GetArchCoreConfig.sign(EnvSign.test),
    packages: [
      HelloCliPackage(),
    ],
  );

  /// logic
  sl<ServiceFoo>().multiplication(2, 3);
}
