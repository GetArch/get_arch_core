library get_arch_core_interface;

// base dependencies
export 'package:get_it/get_it.dart';
export 'package:equatable/equatable.dart';
export 'package:injectable/injectable.dart';
export 'package:dartz/dartz.dart'
    show Either, Unit, left, right, Left, Right, Tuple2, Tuple3;

// domain
export 'src/domain/value_object.dart';
export 'src/domain/entity.dart';
export 'src/domain/aggregate.dart';
export 'src/domain/repository.dart';
export 'src/domain/failure.dart';
export 'src/domain/extensions.dart';
export 'src/domain/exceptions.dart';
export 'src/domain/validators.dart';
export 'src/domain/utils.dart';

// interfaces
export 'src/interface/i_config.dart';
export 'src/interface/i_package.dart';
export 'src/interface/i_application.dart';
export 'src/interface/i_value_object.dart';

export 'src/interface/dto.dart';
export 'src/interface/do.dart';
export 'src/interface/application_service.dart';

// base/mixin
export 'src/base/base_config.dart';
export 'src/base/base_package.dart';
export 'src/base/base_application.dart';
export 'src/base/base_value_object.dart';
