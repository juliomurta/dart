class GradeSchool {

  List<(String, int)> _students = []; 

  List<String> roster() {
   _students.sort((a, b) {
      final byGrade = a.$2.compareTo(b.$2);
      if (byGrade != 0) return byGrade;
      return a.$1.compareTo(b.$1);
    });

    return _students
            .map((e) => e.$1)
            .toList();
  }

  List<bool> add(List<(String, int)> students) {
    List<bool> results = [];
    students.forEach((student) {
      if (!_students.any((s) => s.$1 == student.$1)) {
        _students.add(student);
        results.add(true);
      } else {
        results.add(false);
      }
    });
    return results;
  }

  List<String> grade(int grade) {
    List<String> names = [];
    _students.forEach((student) {
      if (student.$2 == grade) {
        names.add(student.$1);
      }
    });
    names.sort((a, b) => a.compareTo(b));
    return names;
  }
}
