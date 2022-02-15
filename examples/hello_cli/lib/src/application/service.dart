import 'package:get_arch_core/get_arch_core.dart';

@lazySingleton
class DeepThought {
  printSome(Object some) {
    print("DeepThought: $some");
    return some;
  }
}

@lazySingleton
class ServiceFoo {
  final DeepThought foo;

  ServiceFoo(this.foo);

  input(List<String> some) {
    return foo.printSome(some.first.split(" ").join().length);
  }

  multiplication(int a, int b) {
    return foo.printSome(a * b);
  }
}
