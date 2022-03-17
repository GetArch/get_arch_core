import 'package:get_arch_core/get_arch_core.dart';
import 'package:hello_cli/hello_cli.dart';
import 'package:hello_cli/src/application/service.dart';

void main(List<String> arguments) {
  GetArchApplication.run(
    GetArchCoreConfig.sign(EnvSign.test),
    packages: [
      HelloCliPackage(),
    ],
    onBeforeAppRun: (g) async {
      // set example
      if (arguments.isEmpty) {
        arguments = ["the Answer to Life, the Universe and Everything is"];
      }
      print(arguments);
    },
    // if you not use `await` on `run` method,
    // please put your logic code in `onApplicationRun`
    onApplicationRun: (g, c) async {
      final bar = g<ServiceFoo>();
      bar.input(arguments);
    },
  );
}
