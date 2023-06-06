import 'dart:math';

String idGenerator() {
  Random r = Random();
  String randomString = [
    for (int numb in List<int>.generate(12, (int index) => r.nextInt(10)))
      numb.toString(),
  ].join('');
  return randomString;
}
