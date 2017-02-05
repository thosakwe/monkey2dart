import 'package:code_builder/code_builder.dart';
import 'package:monkey_lang/ast/ast.dart';

class Monkey2DartCompiler {
  const Monkey2DartCompiler();

  String compile(Program program) =>
      prettyToSource(compileProgram(program).buildAst());

  LibraryBuilder compileProgram(Program program) {
    var lib = new LibraryBuilder();
    var main = new MethodBuilder('main');
    main.addStatements(program.statements.map(compileStatement));
    return lib..addMember(main);
  }

  StatementBuilder compileStatement(Statement statement) {
    if (statement is BlockStatement) {
      var fn = new MethodBuilder.closure()
        ..addStatements(statement.statements.map(compileStatement));
      return fn.call([]);
    }

    if (statement is ExpressionStatement)
      return compileExpression(statement.expression).asStatement();

    if (statement is LetStatement) {
      return varField(statement.name.value,
          value: compileExpression(statement.value));
    }

    if (statement is ReturnStatement)
      return compileExpression(statement.returnValue).asReturn();

    return reference('print')
        .call([literal('TODO: Compile ${statement.runtimeType}')]);
  }

  ExpressionBuilder compileExpression(Expression expression) {
    if (expression is ArrayLiteral)
      return list(expression.elements.map(compileExpression));

    if (expression is BooleanLiteral) return literal(expression.value);

    if (expression is CallExpression)
      return resolveBuiltin(expression.function)
          .call(expression.arguments.map(compileExpression));

    if (expression is FunctionLiteral) {
      var fn = new MethodBuilder.closure();
      for (var p in expression.parameters) fn.addPositional(parameter(p.value));
      return fn
        ..addStatements(expression.body.statements.map(compileStatement));
    }

    if (expression is HashLiteral) {
      return map(expression.pairs.keys
          .fold({}, (map, key) => map..[key] = expression.pairs[key]));
    }

    if (expression is Identifier) return reference(expression.value);

    if (expression is IndexExpression)
      return compileExpression(expression.left)[
          compileExpression(expression.index)];

    if (expression is IntegerLiteral) return literal(expression.value);

    if (expression is StringLiteral) return literal(expression.value);

    return literal('TODO: Compile ${expression.runtimeType}');
  }

  ExpressionBuilder resolveBuiltin(Expression expression) {
    if (expression is Identifier) {
      switch (expression.value) {
        case 'puts':
          return reference('print');
      }
    }

    return compileExpression(expression);
  }
}
