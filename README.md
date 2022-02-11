# get_arch_core

GetArch core package

## 快速开始

### 0 添加依赖

```yaml
dependencies:
  get_arch_core:

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
/// Please copy this file to your project and rename it to `injector.dart` ,
/// and run `dart run build_runner build` to generate `./injector.config.dart`
@InjectableInit()
Future configureDependencies({
  required EnvConfig config,
  EnvironmentFilter? filter,
}) async =>
    await $initGetIt(
      sl,
      environment: config.envSign.name,
      environmentFilter: filter,
    );
```

### 2 实现 IGetArchPackage (继承 BaseGetArchPackage)

```dart
class HelloCliPackage extends BaseGetArchPackage {
  /// 在这里 import `injector.dart` 中的 `configureDependencies`方法
  @override
  InitPackageDI? get initPackageDI => configureDependencies;

/// 更多配置请参考 BaseGetArchPackage源代码, 手动实现 IGetArchPackage
}
```

### 3 注入依赖

只需要添加 `@lazySingleton`注解, 即可单例注入实例.
相关注入代码将会通过 `dart run build_runner build`在 `./injector.config.dart` 中生成

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

```dart
Future<void> main(List<String> arguments) async {
  /// 务必添加 `await`
  await GetArchApplication.run(
    EnvConfig.sign(EnvSign.dev, appName: 'Hello CLI'),
    packages: [
      HelloCliPackage(),
    ],
  );

  // 在任意未知使用 `sl<已注入的类>`获取注入类的实例
  sl<ServiceBar>().calculate(2, 3);
}
```

## 版本指南

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
