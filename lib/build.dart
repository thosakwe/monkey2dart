import 'dart:async';
import 'package:build/build.dart';
import 'package:monkey_lang/lexer/lexer.dart';
import 'package:monkey_lang/parser/parser.dart';
import 'monkey2dart.dart';

class Monkey2DartBuilder implements Builder {
  final Monkey2DartCompiler compiler = const Monkey2DartCompiler();

  const Monkey2DartBuilder();

  @override
  List<AssetId> declareOutputs(AssetId inputId) =>
      [inputId.changeExtension('.g.dart')];

  @override
  Future build(BuildStep buildStep) async {
    var text = await buildStep.readAsString(buildStep.inputId);
    var program = new Parser(new Lexer(text)).parseProgram();
    var compiled = compiler.compile(program);
    buildStep.writeAsString(
        buildStep.inputId.changeExtension('.g.dart'), compiled);
  }
}
