import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daycare App',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _userType = 'parent'; // Default user type is parent

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButton<String>(
              value: _userType,
              onChanged: (String? newValue) {
                setState(() {
                  _userType = newValue!;
                });
              },
              items: <String>['parent', 'caregiver']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      bool authenticated =
          await authenticateUser(username, password, _userType);

      if (authenticated) {
        if (_userType == 'parent') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ParentFormPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CaretakerFormPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid username or password'),
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter username and password'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  Future<bool> authenticateUser(
      String username, String password, String userType) async {
    final Database db = await initDatabase();
    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM users WHERE username = ? AND password = ? AND userType = ?',
      [username, password, userType],
    );

    return result.isNotEmpty;
  }

  Future<Database> initDatabase() async {
    String pathDB = await getDatabasesPath();
    return openDatabase(
      path.join(pathDB, 'daycare.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT, userType TEXT)',
        );
        db.execute(
          'INSERT INTO users(username, password, userType) VALUES("parent1", "password1", "parent")',
        );
        db.execute(
          'INSERT INTO users(username, password, userType) VALUES("caregiver1", "password1", "caregiver")',
        );
      },
      version: 1,
    );
  }
}

class ParentFormPage extends StatefulWidget {
  const ParentFormPage({super.key});

  @override
  _ParentFormPageState createState() => _ParentFormPageState();
}

class _ParentFormPageState extends State<ParentFormPage> {
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _childAgeController = TextEditingController();

  Future<Database> _initDatabase() async {
    String pathDB = await getDatabasesPath();
    return openDatabase(
      path.join(pathDB, 'daycare.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE child_data(id INTEGER PRIMARY KEY, child_name TEXT, child_age INTEGER)',
        );
      },
      version: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Child Data', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: _childNameController,
              decoration: const InputDecoration(labelText: 'Child Name'),
            ),
            TextField(
              controller: _childAgeController,
              decoration: const InputDecoration(labelText: 'Child Age'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveChildData();
              },
              child: const Text('Add Child Data'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChildData() async {
    final Database db = await _initDatabase();
    await db.rawInsert(
      'INSERT INTO child_data(child_name, child_age) VALUES (?, ?)',
      [_childNameController.text, _childAgeController.text],
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Child data successfully added'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

class CaretakerFormPage extends StatefulWidget {
  const CaretakerFormPage({super.key});

  @override
  _CaretakerFormPageState createState() => _CaretakerFormPageState();
}

class _CaretakerFormPageState extends State<CaretakerFormPage> {
  List<Map<String, dynamic>> _childData = [];

  Future<Database> _initDatabase() async {
    String pathDB = await getDatabasesPath();
    return openDatabase(
      path.join(pathDB, 'daycare.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE child_data(id INTEGER PRIMARY KEY, child_name TEXT, child_age INTEGER)',
        );
      },
      version: 1,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }

  Future<void> _loadChildData() async {
    final Database db = await _initDatabase();
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM child_data');
    setState(() {
      _childData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caretaker Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Child Data', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _childData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_childData[index]['child_name']),
                  subtitle: Text(_childData[index]['child_age'].toString()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
