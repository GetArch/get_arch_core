import 'package:get_arch_core/get_arch_core.dart';

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
