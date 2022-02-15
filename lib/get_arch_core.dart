library get_arch_core;

import 'package:get_it/get_it.dart' as get_it;

// interface / base
export 'get_arch_core_interface.dart';

// other dependencies
export 'package:rxdart/rxdart.dart';
export 'package:meta/meta.dart';

// implementation
export 'src/impl/config.dart';
export 'src/impl/package.dart';
export 'src/impl/application.dart';
export 'src/impl/application.dart';

export 'src/get_arch_application.dart';

// service locator
final sl = get_it.GetIt.I;
