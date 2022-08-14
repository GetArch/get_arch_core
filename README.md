# get_arch_core

GetArch core package

## 目录结构指导

### 总体目录结构

- lib
  - src
    - core 包（依赖get_arch框架；被app以及其他feat包引用）
    - 其他feat包 （依赖框架，core包；被app包引用）
    - app  包（依赖框架，core包，其他feat包；）
      - package.dart (每个项目只有一个，实现GetArchPackage)
  - main.dart

### 分包目录结构
以 core 包为例
- core (feat名称)
  - application (应用层)
  - domain (领域层)
  - inter  (接口层)
  - infra  (基础设施层)
  - config (配置文件，常量等)


## 快速开始

以 `examples/hello_cli` 为例

### 0 添加依赖

```yaml
dependencies:
  get_arch_core:  # 必须> 3.0.0

dev_dependencies:
  build_runner:         # 用于生成代码
  injectable_generator: # 生成DI代码
```

### 1 配置依赖注入

请拷贝下面的**全部**内容到你的项目中, 然后在命令行中运行 `dart run build_runner build`命令 即可在改文件的相同路径下生成 `./injector.config.dart`,
文件内包含 `$initGetIt`方法

```dart
import 'package:get_arch_core/get_arch_core.dart';
import './injector.config.dart';

///
/// Please copy this file to your project and rename it to `injector.dart`
/// run `dart run build_runner build` to generate `./injector.config.dart`
/// do not edit method name `initPackageDI`
@InjectableInit()
Future initPackageDI(GetIt getIt, IConfig config) async =>
    await $initGetIt(getIt, environmentFilter: config.filter);
```

### 2 实现 IGetArchPackage (继承 BaseGetArchPackage)

导入`injector.dart`文件,然后将`initPackageDI`方法作为参数传入 `onPackageInit`

```dart
/// import your `injector.dart` file, and pass `initPackageDI` to `onPackageInit`
class HelloCliPackage extends BasePackage {
  HelloCliPackage() : super.build(onPackageInit: initPackageDI);
}
```

### 3 注入依赖

只需要添加 `@lazySingleton`注解, 即可单例注入实例. 相关注入代码将会通过 `dart run build_runner build`在 `./injector.config.dart` 中生成

```dart
@lazySingleton
class ServiceFoo {
  printSome(Object some) {
    print("ServiceFoo: $some");
    return some;
  }
}

@lazySingleton
class ServiceBar {
  final ServiceFoo foo;

  ServiceBar(this.foo);

  calculate(int a, int b) {
    return foo.printSome(a + b);
  }
}
```

### 4 生成注入代码并运行

在运行代码之前, 使用 1 中的 `dart run build_runner build` 命令,再次生成 `./injector.config.dart`
> 还可以使用 `dart run build_runner watch` 持续生成代码, 无需频繁手动运行 build命令

#### A 嵌入业务逻辑到`onApplicationRun`中

(无需在run方法前添加 await)

```dart
void main(List<String> arguments) {
  GetArchApplication.run(
    GetArchCoreConfig.sign(EnvSign.dev),
    packages: [
      HelloCliPackage(),
    ],
    onBeforeAppRun: () async {
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
```

#### B 在GetArchApplication之外运行业务逻辑

(务必在run方法前使用 await)

```dart
Future<void> main(List<String> arguments) async {
  await GetArchApplication.run(
    GetArchCoreConfig.sign(EnvSign.dev),
    packages: [
      HelloCliPackage(),
    ],
  );

  /// logic
  sl<ServiceFoo>().multiplication(2, 3);
}
```

## 将Package包装为Application运行

以 `MindBase` App为例

```dart
import 'package:get_arch_core/get_arch_core.dart';

// 1 创建XxxConfig
class MindBaseConfig extends BaseConfig {
  MindBaseConfig({
    required EnvSign sign,
    required String name,
    required String version,
    required DateTime packAt,
  }) : super(sign: sign, name: name, version: version, packAt: packAt);
}

// 2 创建 XxxPackage
class MindBasePackage extends BasePackage<MindBaseConfig> {
  MindBasePackage({
    Future<void> Function(GetIt g, MindBaseConfig c)? onBeforePkgInit,
    Future<void> Function(GetIt g, MindBaseConfig config)? onAfterPkgInit,
    Future<void> Function(MindBaseConfig config, Object e, StackTrace s)?
    onPkgInitError,
    Future<void> Function(MindBaseConfig config)? onPkgInitFinally,
    Future<void> Function(GetIt getIt, MindBaseConfig config)? onPackageInit,
  }) : super(onBeforePkgInit, onAfterPkgInit, onPkgInitError, onPkgInitFinally,
      onPackageInit);
}

// 3 创建 XxxApplication
class MindBaseApplication extends MindBasePackage
    with MxAppRun<MindBaseConfig> {
  @override
  final Future<void> Function()? onAfterAppRun;

  @override
  final Future<void> Function(Object e, StackTrace s)? onAppError;

  @override
  final Future<void> Function()? onAppFinally;

  @override
  final Future<void> Function(GetIt getIt, MindBaseConfig config)?
  onApplicationRun;

  @override
  final Future<void> Function(GetIt getIt, MindBaseConfig config)?
  onBeforeAppInit;

  @override
  final Future<void> Function()? onBeforeAppRun;

  @override
  final Iterable<IPackage<IConfig>> packages;

  MindBaseApplication({
    this.packages = const [],
    this.onBeforeAppInit,
    this.onBeforeAppRun,
    this.onApplicationRun,
    this.onAfterAppRun,
    this.onAppError,
    this.onAppFinally,
  });
}
```

// main.dart file
```dart
void main() {
  MindBaseApplication(
    onBeforeAppInit: (g, c) async => WidgetsFlutterBinding.ensureInitialized(),
    onApplicationRun: (g, c) async => runApp(const MyApp()),
  ).run(
    GetIt.I,
    MindBaseConfig(
        sign: EnvSign.dev,
        name: "MindBase",
        version: "0.0.1",
        packAt: DateTime(2022, 3, 8)),
  );
}
```

## 运行流程

### Package

抽象类 [IPackage]::packageInit 包含 prePkgInit 和 pkgInit 实现混合
[MxPrePkgMx]::prePkgInit
[MxSimplePrePkgMx]::prePkgInit
[MxPkgInit]::pkgInit

基础实现类(可直接继承使用)
[BasePackage]需要创建对应的[IConfig]配置类
[BaseSimplePackage] 直接使用[SimplePackageConfig]作为配置类

实现类(供参考)
[GetArchCorePackage]

### Application

接口类 [IApplication]
实现混合 [MxAppRun]::run

实现类(供参考)
[GetArchCoreApplication]

## Git依赖版本指南

以下内容仅针对使用 git依赖的项目

> 版本号规则:
>
> 基于 "语义版本号"进行适当修改制定
>
> - 注意:  仅包含1个分隔点的版本号代表某稳定版本的最新分支.
    >   - 例如 v1.2 分支始终指向 v1.1.x版本, 其中, x代表最新版本, 如 v1.1.5为当前最新版本, 则 v1.2指向v1.1.5
> - 3位版本号含义: v主版本号.次版本号.修订号
    >   - 主版本号 公共 API 出现重大变更时递增。
    >

- 次版本号 在 API出现向不兼容的新功能出现时递增

> - 修订号 在只做了向下兼容的修正时才递增。为了减少其他模块适配工作量, 这里的修正不仅指的针对不正确结果而进行的内部修改, 还包括不影响已有功能的新增修改

## GetArch宇宙

### get_arch_storage_hive_starter

https://github.com/GetArch/get_arch_storage_hive_starter