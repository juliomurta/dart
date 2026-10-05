class Forth {
  List<int> stack = [];

  Set<(String, List<String>)> _userDefinedWords = {};
  List<String> _operators = ['+', '-', '*', '/'];
  List<String> _moves = ['dup', 'drop', 'swap', 'over'];

  void evaluate(String input) {
    final parts = input.trim().toLowerCase().split(RegExp(r'\s+'));

    if (parts[0] == ':' && parts[parts.length - 1] == ';') {
      if (int.tryParse(parts[1]) != null) {
        throw Exception('Invalid definition');
      }
      
      if (_userDefinedWords.any((word) => word.$1 == parts[1])) {
        var existingWord = _userDefinedWords.firstWhere((word) => word.$1 == parts[1]);
        if (int.tryParse(existingWord.$2[0]) == null) {          
          _userDefinedWords.remove(existingWord);      
        }
      }
      _userDefinedWords.add((parts[1], parts.sublist(2, parts.length - 1)));
    } else {
      parts.forEach((s) {
        if (_userDefinedWords.any((word) => word.$1 == s)) {       
          _userDefinedWords.forEach((word) {
            if (word.$1 == s) {
              performBuiltInOperations(word);
            }
          });
        } else if (_operators.contains(s)) {
          var result = performOperation(s);
          stack.removeRange(stack.length - 2, stack.length);
          stack.add(result);
        } else if (_moves.contains(s)) {
          performMove(s);
        } else if (int.tryParse(s) != null) {
          stack.add(int.parse(s));
        } else {
          throw Exception('Unknown command');
        }          
      });
    }
  }

  int performOperation(String operator) {
    if (stack.length  < 2) {
      throw Exception('Stack empty');
    } 

    var a = stack[stack.length - 2];
    var b = stack[stack.length - 1];

    switch (operator) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        if (b == 0) {
          throw Exception('Division by zero');
        }
        return a ~/ b; 
      default:
        return 0;
    }
  }

  void performMove(String move) {
    if (((move == 'dup' || move == 'drop') && stack.length == 0) || 
        ((move == 'swap' || move == 'over') && stack.length < 2)) {
      throw Exception('Stack empty');
    } 
    switch(move) {
      case 'dup':
        stack.add(stack[stack.length - 1]);
      case 'drop':      
        stack.removeLast();
      case 'swap': 
        var aux = stack[stack.length - 1];
        stack[stack.length - 1] = stack[stack.length - 2];
        stack[stack.length - 2] = aux;
      case 'over': 
        stack.add(stack[stack.length - 2]);   
      break;
    }
  }

  void performBuiltInOperations((String, List<String>) definition) { 
    definition.$2.forEach((element) {
      if (_moves.contains(element)) {
        performMove(element);
      } else if (_operators.contains(element)) {
        var result = performOperation(element);
        stack.removeRange(stack.length - 2, stack.length);
        stack.add(result);
      } else if (int.tryParse(element) != null) {
        stack.add(int.parse(element));
      };
    });
  }

  void performOperations(String element) { 
   if (_operators.contains(element)) {
      var result = performOperation(element);
      stack.removeRange(stack.length - 2, stack.length);
      stack.add(result);
    } else if (_moves.contains(element)) {
      performMove(element);
    } else if (int.tryParse(element) != null) {
      stack.add(int.parse(element));
    } else {
      throw Exception('Unknown command');
    }
  }
}
