import 'package:get_arch_core/get_arch_core.dart';
import './injector.config.dart';

///
/// Please copy this file to your project and rename it to injector.dart
///
/// run `dart run build_runner build` to generate `./injector.config.dart`
@InjectableInit()
Future configureDependencies({
  required EnvConfig config,
  EnvironmentFilter? filter,
}) async =>
    await $initGetIt(
      sl,
      environment: filter == null ? config.envSign.name : null,
      environmentFilter: filter,
    );
