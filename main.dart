import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Maker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LectureInfo(title: 'TEAM MAKER'),
    );
  }
}

class LectureInfo extends StatefulWidget {
  const LectureInfo({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LectureInfo createState() => _LectureInfo();
}

class _LectureInfo extends State<LectureInfo> {
  late SharedPreferences _prefs;
  String selectedLecture = 'Basic Project Lab';
  String selectedClass = '00';

  final List<String> lectures = ['Basic Project Lab', 'Adventure Design'];
  final List<String> classes = [
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10'
  ];
  @override
  void initState() {
    super.initState();
    loadSelectedInfo();
  }
  Future<void> loadSelectedInfo() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLecture = _prefs.getString('selectedLecture') ?? selectedLecture;
      selectedClass = _prefs.getString('selectedClass') ?? selectedClass;
    });
  }

  Future<void> saveSelectedInfo() async {
    await _prefs.setString('selectedLecture', selectedLecture);
    await _prefs.setString('selectedClass', selectedClass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: selectedLecture,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLecture = newValue!;
                });
              },
              items: lectures.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: selectedClass,
              onChanged: (String? newValue) {
                setState(() {
                  selectedClass = newValue!;
                });
              },
              items: classes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            ElevatedButton(
              onPressed: () async {
                await saveSelectedInfo();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      title: "학생정보입력",
                      selectedLecture: selectedLecture,
                      selectedClass: selectedClass,
                    ),
                  ),
                );
              },
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.title,
    required this.selectedLecture,
    required this.selectedClass,
  }) : super(key: key);

  final String title;
  final String selectedLecture;
  final String selectedClass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TEAM MAKER"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '선택해주세요.',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfessorPage(
                      selectedLecture: selectedLecture,
                      selectedClass: selectedClass,
                    ),
                  ),
                );
              },
              child: Text('교수'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 학생용 페이지로 이동하는 코드 작성
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentPage(
                      title: "학생정보입력",
                      selectedLecture: selectedLecture,
                      selectedClass: selectedClass,
                    ),
                  ),
                );
              },
              child: Text('학생'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('MBTI 테스트하기'),
                content: Text('간단한 MBTI 테스트를 진행하시겠습니까?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('확인'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MBTITestPage(), // MBTI 테스트 화면으로 이동
                        ),
                      );
                    },
                  ),
                  TextButton(
                    child: Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // FloatingActionButton을 오른쪽 아래 구석으로 이동
    );
  }
}

class MBTITestPage extends StatefulWidget {
  @override
  _MBTITestPageState createState() => _MBTITestPageState();
}

class _MBTITestPageState extends State<MBTITestPage> {
  String? energyDirection;
  String? informationPerception;
  String? decisionMaking;
  String? lifestylePattern;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MBTI 테스트'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '문제가 생겼을 때 당신의 대처법은?',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('1. '),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: energyDirection == 'I',
                  onChanged: (value) {
                    setState(() {
                      energyDirection = value! ? 'I' : null;
                    });
                  },
                ),
                SizedBox(width: 10),
                Text('생각이 많아짐'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: energyDirection == 'E',
                  onChanged: (value) {
                    setState(() {
                      energyDirection = value! ? 'E' : null;
                    });
                  },
                ),
                SizedBox(width: 10),
                Text('말이 많아짐'),
              ],
            ),
            SizedBox(height: 20),
            Text('2. '),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: informationPerception == 'N',
                  onChanged: (value) {
                    setState(() {
                      informationPerception = value! ? 'N' : null;
                    });
                  },
                ),
                SizedBox(width: 10),
                Text('어떻게 그럴 수 있지'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: informationPerception == 'S',
                  onChanged: (value) {
                    setState(() {
                      informationPerception = value! ? 'S' : null;
                    });
                  },
                ),
                SizedBox(width: 10),
                Text('그럴 수 있지'),
              ],
            ),
            SizedBox(height: 20),
            Text('3. '),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: decisionMaking == 'T',
                  onChanged: (value) {
                    setState(() {
                      decisionMaking = value! ? 'T' : null;
                    });
                  },
                ),
                SizedBox(width: 10),
                Text('이해가 돼야 공감을 하든 말든'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: decisionMaking == 'F',
                  onChanged: (value) {
                    setState(() {
                      decisionMaking = value! ? 'F' : null;
                    });
                  },
                ),
                SizedBox(width: 10),
                Text('선 공감 후 이해'),
              ],
            ),
            SizedBox(height: 20),
            Text('4. '),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: lifestylePattern == 'J',
                  onChanged: (value) {
                    setState(() {
                      lifestylePattern = value! ? 'J' : null;
                    });
                  },
                ),
                SizedBox(width: 10),
                Text('(바로)처리함'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: lifestylePattern == 'P',
                  onChanged: (value) {
                    setState(() {
                      lifestylePattern = value! ? 'P' : null;
                    });
                  },
                ),
                SizedBox(width: 10),
                Text('(닥쳐서)처리함'),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (energyDirection != null &&
                    informationPerception != null &&
                    decisionMaking != null &&
                    lifestylePattern != null) {
                  String mbti =
                      energyDirection! + informationPerception! + decisionMaking! + lifestylePattern!;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('결과'),
                        content: Text('당신의 MBTI는 $mbti 입니다.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('오류'),
                        content: Text('선택하지 않은 항목이 있습니다.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentPage extends StatefulWidget {
  const StudentPage({
    Key? key,
    required this.title,
    required this.selectedLecture,
    required this.selectedClass,
  }) : super(key: key);

  final String title;
  final String selectedLecture;
  final String selectedClass;

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late SharedPreferences _prefs;
  late DatabaseReference _databaseRef;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _studentIdController = TextEditingController();
  TextEditingController _mbtiController = TextEditingController();
  String? _selectedMbti;
  String? _selectedGender;
  late String selectedLecture; // Updated to non-final variable
  late String selectedClass; // Updated to non-final variable

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.reference().child('users');
    loadSelectedInfo();
  }


  Future<void> loadSelectedInfo() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLecture = _prefs.getString('selectedLecture') ?? '';
      selectedClass = _prefs.getString('selectedClass') ?? '';
    });
  }
  Future<void> saveSelectedInfo() async {
    await _prefs.setString('selectedLecture', widget.selectedLecture);
    await _prefs.setString('selectedClass', widget.selectedClass);
  }

  Future<void> _saveData() async {
    String name = _nameController.text.trim();
    String studentId = _studentIdController.text;
    String mbti = _selectedMbti ?? '';
    String gender = _selectedGender ?? '';

    // 이름에 대체 문자를 적용하여 Firebase 키 제한 사항을 준수

    _prefs = await SharedPreferences.getInstance(); // Initialize _prefs variable

    DatabaseReference databaseReference =
    FirebaseDatabase.instance.reference().child('users');
    DatabaseReference userReference = databaseReference
        .child(widget.selectedLecture) // Use the selected lecture as a child node
        .child(widget.selectedClass) // Use the selected class as a child node
        .child(name); // Use the sanitized name as the child node

    // Set the student's details
    userReference.set({
      'name': name,
      'studentId': studentId,
      'gender': gender,
      'mbti': mbti,
      'lecture': widget.selectedLecture, // Use the passed selectedLecture value
      'class': widget.selectedClass, // Use the passed selectedClass value
    }).then((_) {
      _nameController.clear();
      _studentIdController.clear();
      _mbtiController.clear(); // _mbtiController 초기화 추가
      setState(() {
        _selectedMbti = null;
        _selectedGender = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('등록완료')),
      );
      /*
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MbtiTeamListPage()),
      );

       */
    }).catchError((error) {
      print(error.toString()); // 콘솔에 오류 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('다시 시도해주세요')),
      );
      setState(() {
        _selectedMbti = null;
        _selectedGender = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("학생 정보 입력"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(labelText: '학번'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(labelText: '성별'),
              items: [
                DropdownMenuItem<String>(
                  value: 'Male',
                  child: Text('남자'),
                ),
                DropdownMenuItem<String>(
                  value: 'Female',
                  child: Text('여자'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            TextField(
              controller: _mbtiController,
              decoration: InputDecoration(labelText: 'MBTI'),
              onChanged: (value) {
                setState(() {
                  _selectedMbti = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('등록'),
            ),
          ],
        ),
      ),
    );
  }
}
class TeamListPage extends StatefulWidget {
  const TeamListPage({
    Key? key,
  }) : super(key: key);

  @override
  _TeamListPageState createState() => _TeamListPageState();
}

class _TeamListPageState extends State<TeamListPage> {
  late DatabaseReference _databaseRef;
  List<String> _teamList = [];

  @override
  void initState() {
    super.initState();
    loadSelectedInfo();
  }

  Future<void> loadSelectedInfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      String? selectedLecture = _prefs.getString('selectedLecture');
      String? selectedClass = _prefs.getString('selectedClass');
      int maxTeamCount = _prefs.getInt('maxTeamCount') ?? 0;
      int teamSize = _prefs.getInt('teamSize') ?? 0;

      if (selectedLecture != null && selectedClass != null) {
        _databaseRef = FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(selectedLecture)
            .child(selectedClass);
        _generateTeamList(maxTeamCount, teamSize);
      }
    });
  }

  Future<void> _generateTeamList(int maxTeamCount, int teamSize) async {
    // Fetch all students from the database
    DataSnapshot snapshot = (await _databaseRef.once()).snapshot;
    Map<dynamic, dynamic>? snapshotValue =
    snapshot.value as Map<dynamic, dynamic>?;
    Map<dynamic, dynamic> studentData =
    Map<dynamic, dynamic>.from(snapshotValue ?? {});

    // Extract names from the fetched data
    List<MapEntry<String, String>> students = studentData.entries
        .map((entry) => MapEntry(
        entry.value['studentId'] as String, entry.value['name'] as String))
        .toList();

    // Sort names in ascending order
    students.sort((a, b) => a.key.compareTo(b.key));

    // Determine the number of teams and the number of students per team
    int teamCount = maxTeamCount;
    int studentsPerTeam = teamSize;
    int totalStudents = students.length;
    int studentsPerGroup = (totalStudents / teamCount).ceil();

    // Initialize team lists
    List<List<String>> teams = List.generate(teamCount, (_) => []);

    // Distribute names evenly among teams
    for (int i = 0; i < totalStudents; i++) {
      int teamIndex = i % teamCount;
      teams[teamIndex].add(students[i].value);
    }

    // Pad the teams with empty slots if necessary
    for (int i = 0; i < teamCount; i++) {
      int remainingSlots = studentsPerTeam - teams[i].length;
      if (remainingSlots > 0) {
        for (int j = 0; j < remainingSlots; j++) {
          teams[i].add('');
        }
      }
    }

    // Update the teamList state
    setState(() {
      _teamList = teams.map((team) => team.join(', ')).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('팀리스트'),
      ),
      body: ListView.builder(
        itemCount: _teamList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('팀 [${index + 1}]'),
            subtitle: Text(_teamList[index]),
          );
        },
      ),
    );
  }
}
class MbtiTeamListPage extends StatefulWidget {
  const MbtiTeamListPage({
    Key? key,
  }) : super(key: key);

  @override
  _MbtiTeamListPageState createState() => _MbtiTeamListPageState();
}

class _MbtiTeamListPageState extends State<MbtiTeamListPage> {
  late DatabaseReference _databaseRef;
  List<String> _teamList = [];

  @override
  void initState() {
    super.initState();
    loadSelectedInfo();
  }

  Future<void> loadSelectedInfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      String? selectedLecture = _prefs.getString('selectedLecture');
      String? selectedClass = _prefs.getString('selectedClass');
      int maxTeamCount = _prefs.getInt('maxTeamCount') ?? 0;
      int teamSize = _prefs.getInt('teamSize') ?? 0;

      if (selectedLecture != null && selectedClass != null) {
        _databaseRef = FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(selectedLecture)
            .child(selectedClass);
        _generateTeamList(maxTeamCount, teamSize);
      }
    });
  }

  Future<void> _generateTeamList(int maxTeamCount, int teamSize) async {
    // Fetch all students from the database
    DataSnapshot snapshot = (await _databaseRef.once()).snapshot;
    Map<dynamic, dynamic>? snapshotValue =
    snapshot.value as Map<dynamic, dynamic>?;
    Map<dynamic, dynamic> studentData =
    Map<dynamic, dynamic>.from(snapshotValue ?? {});

    // Extract names from the fetched data
    List<MapEntry<String, String>> students = studentData.entries
        .map((entry) =>
        MapEntry(
            entry.value['mbti'] as String, entry.value['name'] as String))
        .toList();

    // Sort students based on mbti, with 'E' first
    students.sort((a, b) {
      if (a.key == 'E' && b.key == 'I') {
        return -1;
      } else if (a.key == 'I' && b.key == 'E') {
        return 1;
      } else {
        return 0;
      }
    });

    // Determine the number of teams and the number of students per team
    int teamCount = maxTeamCount;
    int studentsPerTeam = teamSize;
    int totalStudents = students.length;
    int studentsPerGroup = (totalStudents / teamCount).ceil();

    // Initialize team lists
    List<List<String>> teams = List.generate(teamCount, (_) => []);

    // Distribute names evenly among teams
    for (int i = 0; i < totalStudents; i++) {
      int teamIndex = i % teamCount;
      teams[teamIndex].add(students[i].value);
    }

    // Pad the teams with empty slots if necessary
    for (int i = 0; i < teamCount; i++) {
      int remainingSlots = studentsPerTeam - teams[i].length;
      if (remainingSlots > 0) {
        for (int j = 0; j < remainingSlots; j++) {
          teams[i].add('');
        }
      }
    }

    // Update the teamList state
    setState(() {
      _teamList = teams.map((team) => team.join(', ')).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('팀리스트'),
      ),
      body: ListView.builder(
        itemCount: _teamList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Team [${index + 1}]'),
            subtitle: Text(_teamList[index]),
          );
        },
      ),
    );
  }
}

class GenderTeamListPage extends StatefulWidget {
  const GenderTeamListPage({
    Key? key,
  }) : super(key: key);

  @override
  _GenderTeamListPageState createState() => _GenderTeamListPageState();
}

class _GenderTeamListPageState extends State<GenderTeamListPage> {
  late DatabaseReference _databaseRef;
  List<String> _teamList = [];

  @override
  void initState() {
    super.initState();
    loadSelectedInfo();
  }

  Future<void> loadSelectedInfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      String? selectedLecture = _prefs.getString('selectedLecture');
      String? selectedClass = _prefs.getString('selectedClass');
      int maxTeamCount = _prefs.getInt('maxTeamCount') ?? 0;
      int teamSize = _prefs.getInt('teamSize') ?? 0;

      if (selectedLecture != null && selectedClass != null) {
        _databaseRef = FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(selectedLecture)
            .child(selectedClass);
        _generateTeamList(maxTeamCount, teamSize);
      }
    });
  }

  Future<void> _generateTeamList(int maxTeamCount, int teamSize) async {
    // Fetch all students from the database
    DataSnapshot snapshot = (await _databaseRef.once()).snapshot;
    Map<dynamic, dynamic>? snapshotValue =
    snapshot.value as Map<dynamic, dynamic>?;
    Map<dynamic, dynamic> studentData =
    Map<dynamic, dynamic>.from(snapshotValue ?? {});

    // Extract names from the fetched data
    List<MapEntry<String, String>> students = studentData.entries
        .map((entry) =>
        MapEntry(entry.key as String, entry.value['name'] as String))
        .toList();


    // Sort students based on mbti, with 'E' first
    students.sort((a, b) {
      if (a.key == 'Female' && b.key == 'Male') {
        return -1;
      } else if (a.key == 'Male' && b.key == 'Female') {
        return 1;
      } else {
        return 0;
      }
    });
    // Determine the number of teams and the number of students per team
    int teamCount = maxTeamCount;
    int studentsPerTeam = teamSize;
    int totalStudents = students.length;
    int studentsPerGroup = (totalStudents / teamCount).ceil();

    // Initialize team lists
    List<List<String>> teams = List.generate(teamCount, (_) => []);

    // Distribute names evenly among teams
    for (int i = 0; i < totalStudents; i++) {
      int teamIndex = i % teamCount;
      teams[teamIndex].add(students[i].value);
    }

    // Pad the teams with empty slots if necessary
    for (int i = 0; i < teamCount; i++) {
      int remainingSlots = studentsPerTeam - teams[i].length;
      if (remainingSlots > 0) {
        for (int j = 0; j < remainingSlots; j++) {
          teams[i].add('');
        }
      }
    }

    // Update the teamList state
    setState(() {
      _teamList = teams.map((team) => team.join(', ')).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('팀리스트'),
      ),
      body: ListView.builder(
        itemCount: _teamList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Team [${index + 1}]',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(height: 1, color: Colors.grey),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _teamList[index]
                        .split(', ')
                        .map((member) => Chip(
                      label: Text(member),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
class ProfessorPage extends StatefulWidget {
  final String selectedLecture;
  final String selectedClass;

  const ProfessorPage({
    Key? key,
    required this.selectedLecture,
    required this.selectedClass,
  }) : super(key: key);

  @override
  _ProfessorPageState createState() => _ProfessorPageState();
}

class _ProfessorPageState extends State<ProfessorPage> {
  late DatabaseReference _databaseRef;
  List<String> studentNames = [];
  bool showStudentNames = false;

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.reference().child('users');
  }

  void _fetchStudentNames() {
    _databaseRef
        .child(widget.selectedLecture)
        .child(widget.selectedClass)
        .onValue
        .listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        final students = snapshot.value as Map<dynamic, dynamic>;
        final names = students.values.map<String>((student) {
          String name = student['name'] ?? '';
          String studentId = student['studentId'] ?? '';
          String gender = student['gender'] ?? '';
          String mbti = student['mbti'] ?? '';
          return '$name - $studentId - $gender - $mbti';
        }).toList();
        setState(() {
          studentNames = names;
        });
      }
    }, onError: (error) {
      print('오류: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TEAM MAKER"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showStudentNames = true;
                        });
                        _fetchStudentNames();
                      },
                      child: Text('학생 현황 보기'),
                    ),
                    SizedBox(width: 10),
                    if (showStudentNames)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TeamMakeInfo(
                                  selectedLecture: widget.selectedLecture,
                                  selectedClass: widget.selectedClass,
                                  studentNames: studentNames,
                                )),
                          );
                        },
                        child: Text('배정 정보 입력'),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                if (showStudentNames)
                  Column(
                    children: [
                      Text(
                        '학생정보:',
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 500, // Set a fixed height for the container
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: studentNames.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(studentNames[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class TeamMakeInfo extends StatefulWidget {
  final String selectedLecture;
  final String selectedClass;
  final List<String> studentNames;

  const TeamMakeInfo({
    Key? key,
    required this.selectedLecture,
    required this.selectedClass,
    required this.studentNames,
  }) : super(key: key);

  @override
  _TeamMakeInfoState createState() => _TeamMakeInfoState();
}

class _TeamMakeInfoState extends State<TeamMakeInfo> {
  int maxTeamCount = 0;
  int teamSize = 0;
  String? selectedComposition;

  final _formKey = GlobalKey<FormState>();

  List<String> teamMembers = [];
  late DatabaseReference _databaseRef;

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.reference().child('users');
  }

  void _assignTeams() {
    if (_formKey.currentState?.validate() ?? false) {
      if (selectedComposition == 'Gender') {
        _navigateToGenderPage();
      } else if (selectedComposition == 'MBTI') {
        _navigateToMbtiPage();
      } else if (selectedComposition == 'StudentId') {
        _navigateToStudentIdPage();
      }
    }
  }

  void _navigateToGenderPage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('maxTeamCount', maxTeamCount);
    await prefs.setInt('teamSize', teamSize);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenderTeamListPage(),
      ),
    );
  }

  void _navigateToMbtiPage()  async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('maxTeamCount', maxTeamCount);
    await prefs.setInt('teamSize', teamSize);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MbtiTeamListPage(),
      ),
    );
  }

  void _navigateToStudentIdPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('maxTeamCount', maxTeamCount);
    await prefs.setInt('teamSize', teamSize);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamListPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("팀 구성 정보"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '팀 개수',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      maxTeamCount = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  '팀당 팀원 수',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      teamSize = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  '배정 기준 고르기',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: selectedComposition,
                  onChanged: (value) {
                    setState(() {
                      selectedComposition = value;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'Gender',
                      child: Text('성별'),
                    ),
                    DropdownMenuItem(
                      value: 'MBTI',
                      child: Text('MBTI'),
                    ),
                    DropdownMenuItem(
                      value: 'StudentId',
                      child: Text('학번'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: _assignTeams,
                  child: Text('팀 배정하기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



