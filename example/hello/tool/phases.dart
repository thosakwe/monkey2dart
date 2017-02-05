import 'package:build_runner/build_runner.dart';
import 'package:monkey2dart/build.dart';

final PhaseGroup phases = new PhaseGroup.singleAction(
    const Monkey2DartBuilder(),
    new InputSet('monkey_hello', const ['lib/*.monkey']));
