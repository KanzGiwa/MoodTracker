import 'package:flutter/material.dart';


class MoodTracker extends StatefulWidget {
  final void Function(bool) toggleTheme;
  final bool isDarkTheme;


  const MoodTracker({
    super.key,
    required this.toggleTheme,
    required this.isDarkTheme,
  });


  @override
  // ignore: library_private_types_in_public_api
  _MoodTrackerState createState() => _MoodTrackerState();
}
class SignInPage extends StatefulWidget {
  final void Function() onSignIn;


  const SignInPage({super.key, required this.onSignIn});


  @override
  // ignore: library_private_types_in_public_api
  _SignInPageState createState() => _SignInPageState();
}


class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;


  void _signIn() {
    final email = _emailController.text;
    final password = _passwordController.text;


    // Here you can add authentication logic (Firebase, etc.)
    if (email == 'test@test.com' && password == 'password') {
      widget.onSignIn();
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
              ),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
class _MoodTrackerState extends State<MoodTracker> {
  final List<Map<String, dynamic>> _weekMoods = [];
  final List<String> _questions = [
    "Did you exercise today?",
    "Did you sleep well?",
    "How was your diet?"
  ];
  final Map<String, String> _answers = {};
  String? _selectedMood;
  int _selectedIndex = 0;


  // Function to save mood immediately
  void _selectMood(String mood) {
    setState(() {
      _selectedMood = mood;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mood "$mood" selected! Now answer the daily questions.')),
      );
    });
  }


  // Function to add mood and answers once all questions are answered
  void _submitMoodAndAnswers() {
    setState(() {
      // ignore: unnecessary_null_comparison
      if (_selectedMood != null && _answers.values.every((answer) => answer != null)) {
        _weekMoods.add({
          'mood': _selectedMood,
          'answers': Map.from(_answers),
        });
        _answers.clear();
        _selectedMood = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mood and answers saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all questions and select a mood.')),
        );
      }
    });
  }


  List<String> _getAnswerOptions(String question) {
    if (question == "How was your diet?") {
      return ['Good', 'Mediocre', 'Bad'];
    } else {
      return ['Yes', 'No', 'Maybe'];
    }
  }


  void _refreshDailyEntry() {
    setState(() {
      _answers.clear();
      _selectedMood = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daily entry refreshed!')),
      );
    });
  }


  void _refreshWeekReports() {
    setState(() {
      _weekMoods.clear(); // Clear all moods and answers
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Week reports refreshed!')),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker App'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select your mood for today:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectMood('Happy'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, // Black text
                    ),
                    child: const Text('Happy'),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectMood('Sad'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, // Black text
                    ),
                    child: const Text('Sad'),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectMood('Angry'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, // Black text
                    ),
                    child: const Text('Angry'),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectMood('Neutral'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, // Black text
                    ),
                    child: const Text('Neutral'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Daily Questions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ..._questions.map((question) => Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(question, style: Theme.of(context).textTheme.bodyMedium),
                          DropdownButton<String>(
                            value: _answers[question],
                            hint: const Text('Select an answer'),
                            items: _getAnswerOptions(question)
                                .map((answer) => DropdownMenuItem(
                                      value: answer,
                                      child: Text(answer),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _answers[question] = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitMoodAndAnswers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Submit Mood and Answers',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _refreshDailyEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Refresh Daily Entry',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _refreshWeekReports,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Refresh Week Reports',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your moods for the week:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (_weekMoods.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _weekMoods.length,
                  itemBuilder: (context, index) {
                    final entry = _weekMoods[index];
                    final mood = entry['mood'];
                    final answers = entry['answers'];
                    return ListTile(
                      title: Text('Day ${index + 1}: Mood - $mood'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: answers.entries
                            .map<Widget>((entry) => Text('${entry.key}: ${entry.value}'))
                            .toList(),
                      ),
                    );
                  },
                )
              else
                const Text('No moods recorded yet.'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Mood Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == _selectedIndex) return;


          setState(() {
            _selectedIndex = index;
          });


          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReportsPage(weekMoods: _weekMoods),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(
                  toggleTheme: widget.toggleTheme,
                  isDarkTheme: widget.isDarkTheme,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}


class SettingsPage extends StatelessWidget {
  final void Function(bool) toggleTheme;
  final bool isDarkTheme;


  const SettingsPage({
    super.key,
    required this.toggleTheme,
    required this.isDarkTheme,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkTheme,
              onChanged: (value) => toggleTheme(value),
            ),
          ],
        ),
      ),
    );
  }
}


class ReportsPage extends StatefulWidget {
  final List<Map<String, dynamic>> weekMoods;

  const ReportsPage({super.key, required this.weekMoods});

  @override
  // ignore: library_private_types_in_public_api
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _advice = '';

  // Function to generate generic advice based on mood reports
  String _generateAdvice() {
    // Simple logic for generating advice based on moods
    int happyCount = widget.weekMoods.where((entry) => entry['mood'] == 'Happy').length;
    int sadCount = widget.weekMoods.where((entry) => entry['mood'] == 'Sad').length;
    int angryCount = widget.weekMoods.where((entry) => entry['mood'] == 'Angry').length;
    
    if (happyCount > sadCount && happyCount > angryCount) {
      return 'Great job maintaining a positive mood! Keep engaging in activities that make you happy.';
    } else if (sadCount > happyCount && sadCount > angryCount) {
      return 'It seems like you’ve been feeling sad. Consider talking to someone or engaging in a fun activity.';
    } else if (angryCount > happyCount && angryCount > sadCount) {
      return 'Feeling angry can be tough. Try practicing relaxation techniques like deep breathing or meditation.';
    } else {
      return 'You’ve experienced a mix of emotions. It’s normal to feel a range of feelings—be kind to yourself!';
    }
  }

  void _getAdvice() {
    setState(() {
      _advice = _generateAdvice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Report'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: widget.weekMoods.isNotEmpty
                  ? ListView.builder(
                      itemCount: widget.weekMoods.length,
                      itemBuilder: (context, index) {
                        final entry = widget.weekMoods[index];
                        final mood = entry['mood'];
                        final answers = entry['answers'];
                        return ListTile(
                          title: Text('Day ${index + 1}: Mood - $mood'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: answers.entries
                                .map<Widget>((entry) => Text('${entry.key}: ${entry.value}'))
                                .toList(),
                          ),
                        );
                      },
                    )
                  : const Text('No data available for this week.'),
            ),
            ElevatedButton(
              onPressed: _getAdvice,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                'Get Advice',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            if (_advice.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Advice: $_advice',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
