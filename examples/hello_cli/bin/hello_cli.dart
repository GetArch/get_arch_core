import 'package:get_arch_core/get_arch_core.dart';
import 'package:hello_cli/hello_cli.dart';
import 'package:hello_cli/src/application/service.dart';

void main(List<String> arguments) {
  GetArchApplication.run(
    EnvConfig.sign(EnvSign.dev, appName: 'Hello CLI'),
    packages: [
      HelloCliPackage(),
    ],
  );

  sl<ServiceBar>().calculate(
    int.parse(arguments[0]),
    int.parse(arguments[1]),
  );
}
