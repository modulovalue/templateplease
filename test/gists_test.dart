import 'package:flutter_test/flutter_test.dart';
import 'package:templateplease/util/util.dart';

void main() {
  test("gist id parser", () {
    expect(gistIDFromString("https://gist.github.com/modulovalue/a366237e9878c47edc1b6280df5a46cb"),
        "a366237e9878c47edc1b6280df5a46cb");
    expect(gistIDFromString("gist.github.com/modulovalue/a366237e9878c47edc1b6280df5a46cb"),
        "a366237e9878c47edc1b6280df5a46cb");
    expect(gistIDFromString("a366237e9878c47edc1b6280df5a46cb"),
        "a366237e9878c47edc1b6280df5a46cb");
  });
}
