# monkey2dart
Compiles the Monkey programming language into equivalent Dart.

Still missing:
* `IfExpression`
* `InfixExpression`
* `PrefixExpression`
* `print` is currently the only available built-in

# Installation
```yaml
dev_dependencies:
    monkey2dart: ^1.0.0-alpha
```

Then, in your command-line:

```bash
$ pub get
```

# Usage
Requires [`package:build_runner`](https://pub.dartlang.org/packages/build_runner).

```dart
// tool/phases.dart
import 'package:build_runner/build_runner.dart';
import 'package:monkey2dart/build.dart';

final PhaseGroup phases = new PhaseGroup.singleAction(
    const Monkey2DartBuilder(),
    new InputSet('monkey_hello', const ['lib/*.monkey']));

// tool/build.dart
import 'package:build_runner/build_runner.dart';
import 'phases.dart';

main() => build(phases, deleteFilesByDefault: true);
```

```bash
$ dart tool/build.dart
```