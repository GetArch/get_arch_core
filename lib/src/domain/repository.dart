// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/7/24
// Time  : 19:07

import 'package:get_arch_core/get_arch_core.dart';

///
/// 仓库抽象类
mixin IRepo<T, Id> {
  // 返回Entity的类型
  Type get entityType => T.runtimeType;
}

///
/// 同步仓库
mixin ICrudRepo<T, Id> on IRepo<T, Id> {
  ///
  /// Saves a given entity. Use the returned instance for further operations as the save operation might have changed the
  /// entity instance completely.
  T save(T entity);

  ///
  /// Saves all given entities.
  Iterable<T> saveAll(Iterable<T> entities);

  ///
  /// Retrieves an entity by its id.
  T? findById(Id id);

  ///
  /// Returns whether an entity with the given id exists.
  bool existsById(Id id);

  ///
  /// Returns all instances of the type.
  ///
  /// @return all entities
  Iterable<T> findAll();

  ///
  /// Returns all instances of the type {@code T} with the given Ids.
  /// <p>
  /// If some or all ids are not found, no entities are returned for these Ids.
  /// <p>
  /// Note that the order of elements in the result is not guaranteed.
  ///
  /// @return guaranteed to be not {@literal null}. The size can be equal or less than the number of given
  ///         {@literal ids}.
  Iterable<T?> findAllById(Iterable<Id> ids);

  ///
  /// Returns the number of entities available.
  ///
  /// @return the number of entities.
  int count();

  ///
  /// Deletes the entity with the given id.
  ///
  /// @param id must not be {@literal null}.
  /// @throws IllegalArgumentException in case the given {@literal id} is {@literal null}
  void deleteById(Id id);

  ///
  /// Deletes a given entity.
  ///
  /// @param entity must not be {@literal null}.
  /// @throws IllegalArgumentException in case the given entity is {@literal null}.
  void delete(T entity);

  ///
  /// Deletes all instances of the type {@code T} with the given Ids.
  ///
  /// @param ids must not be {@literal null}. Must not contain {@literal null} elements.
  /// @throws IllegalArgumentException in case the given {@literal ids} or one of its elements is {@literal null}.
  /// @since 2.5
  void deleteAllById(Iterable<Id> ids);

  ///
  /// Deletes all entities managed by the repository.
  void deleteAll();
}

/// 异步仓库
mixin IAsyncCrudRepo<Ag extends IAgg<Id>, Id> on IRepo<Ag, Id> {
  // Returns the number of entities available
  Future<int> count();

  // Deletes a given entity.
  Future<void> delete(Ag entity);

  // if [entities] == null, Deletes all entities managed by the repository.
  // else Deletes the given entities.
  Future<void> deleteAll(Iterable<Ag>? entities);

  // Deletes the given entities supplied by a Publisher.
  Stream<void> deleteAllAsync(Stream<Ag> entityStream);

  // Deletes all instances of the type T with the given Ids.
  Future<void> deleteAllById(Iterable<Id> ids);

  // Deletes the entity with the given id.
  Future<void> deleteById(Id id);

  // Deletes the entity with the given id supplied by a Publisher.
  Future<void> deleteByIdAsync(Future<Id> id);

  // Returns whether an entity with the given id exists.
  Future<bool> existsById(Id id);

  // Returns whether an entity with the given id, supplied by a Publisher, exists.
  Future<bool> existsByIdAsync(Future<Id> id);

  // Returns all instances of the type.
  Stream<Ag> findAll();

  // Returns all instances of the type Ag with the given Ids.
  Stream<Ag?> findAllById(Iterable<Id> ids);

  // Returns all instances of the type Ag with the given Ids supplied by a Publisher.
  Stream<Ag?> findAllByIdAsync(Stream<Id> idStream);

  // Retrieves an entity by its id.
  Future<Ag?> findById(Id id);

  // Retrieves an entity by its id supplied by a Publisher.
  Future<Ag?> findByIdAsync(Future<Id> id);

  // Saves a given entity.
  Future<Ag> save(Ag entity);

  // Saves all given entities.
  Stream<Ag> saveAll(Iterable<Ag> entities);

  // Saves all given entities.
  Stream<Ag> saveAllAsync(Stream<Ag> entityStream);
}
