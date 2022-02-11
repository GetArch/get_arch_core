library get_arch_core;

import 'package:get_it/get_it.dart' as get_it;

export 'package:get_it/get_it.dart';
export 'package:equatable/equatable.dart';
export 'package:dartz/dartz.dart'
    show Either, Unit, left, right, Left, Right, Tuple2, Tuple3;
export 'package:rxdart/rxdart.dart';
export 'package:meta/meta.dart';
export 'package:injectable/injectable.dart';

export 'src/domain/value_object.dart';
export 'src/domain/entity.dart';
export 'src/domain/aggregate.dart';
export 'src/domain/repository.dart';
export 'src/domain/failure.dart';
export 'src/domain/extensions.dart';
export 'src/domain/exceptions.dart';
export 'src/domain/validators.dart';

export 'src/application/application_service.dart';

export 'src/interface/dto.dart';
export 'src/interface/do.dart';

export 'src/config/env_config.dart';
export 'src/config/get_arch_package.dart';
export 'src/config/get_arch_application.dart';

// service locator
final sl = get_it.GetIt.I;
