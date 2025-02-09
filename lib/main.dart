import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'services/api_service.dart';
import 'models/club_model.dart';

//Clubs
List<Club> clubs = [
    //Knight Hacks
    Club(name: 'Knight Hacks', imagePath: 'assets/knightHacks-logo.png', id: '66996fb9d1e5f37302826f54'),
    //UCF
    Club(name: 'UCF General', imagePath: 'assets/club_logo.png', id: '66996984d1e5f37302826f32'),
    //Knights Experimental Rocketry
    Club(name: 'Knights Experimental Rocketry', imagePath: 'assets/kxr-logo.png', id: '66996f05d1e5f37302826f3f'),
    //Society of Hispanic Professional Engineers
    Club(name: 'Society of Hispanic Professional Engineers', imagePath: 'assets/shpelogo.png', id: '66996f34d1e5f37302826f46'),
    //AI @ UCF
    Club(name: 'AI @ UCF', imagePath: 'assets/aiUCF-logo.png', id: '66996f8dd1e5f37302826f4d'),
    //Knights Racing BAJA
    Club(name: 'Knights Racing BAJA', imagePath: 'assets/bajalogo.png', id: '6699701bd1e5f37302826f5b'),
    //VR Knights
    Club(name: 'VR Knights', imagePath: 'assets/vrknightslogo.png', id: '66997067d1e5f37302826f68'),
    //Institute of Electrical and Electronics Engineers @ UCF
    Club(name: 'Institute of Electrical and Electronics Engineers @ UCF', imagePath: 'assets/ieeelogo.png', id: '669970add1e5f37302826f6f'),
    //National Society of Black Engineers
    Club(name: 'National Society of Black Engineers', imagePath: 'assets/nsbelogo.png', id: '66997110d1e5f37302826f76'),
    //4EVER KNIGHTS
    Club(name: '4EVER KNIGHTS', imagePath: 'assets/4everknights.jpg', id: '669df5fdd8f0e8751612dcea'),
    //Air Force ROTC
    Club(name: 'Air Force ROTC', imagePath: 'assets/AFROTC.jpg', id: '669df61ed8f0e8751612dcef'),
    //American Society of Mechanical Engineers
    Club(name: 'American Society of Mechanical Engineers', imagePath: 'assets/asme-logo.png', id: '669df643d8f0e8751612dcf4'),
    //Asian Student Association
    Club(name: 'Asian Student Association', imagePath: 'assets/asa-logo.jpg', id: '669df68ed8f0e8751612dcf9'),
    //Esports at UCF
    Club(name: 'Esports at UCF', imagePath: 'assets/esports-ucf.png', id: '669df6ead8f0e8751612dcfe'),
    //Florida Engineering Society
    Club(name: 'Florida Engineering Society', imagePath: 'assets/fes-logo.jpg', id: '669df6ffd8f0e8751612dd03'),
    //Knights Powerlifting
    Club(name: 'Knights Powerlifting', imagePath: 'assets/powerlifting-logo.png', id: '669df74ad8f0e8751612dd08'),
    //Knights Satellite Club
    Club(name: 'Knights Satellite Club', imagePath: 'assets/satellite-logo.png', id: '669df765d8f0e8751612dd0d'),
    //Out in Science, Technology, Engineering, and Mathematics
    Club(name: 'Out in Science, Technology, Engineering, and Mathematics', imagePath: 'assets/oSTEM-logo.png', id: '669df799d8f0e8751612dd12'),
  ];

String userID = '';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(baseUrl: 'https://ucf-club-and-event-manager-1c53fb944ab8.herokuapp.com/api/v1/users'),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter MERN App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          hintColor: Colors.blueAccent,
          fontFamily: 'Montserrat',
          textTheme: const TextTheme(
            headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            headlineSmall: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
            bodyMedium: TextStyle(fontSize: 14.0),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.yellow,
          ),
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;
  // ignore: unused_field
  Map<String, dynamic>? _userInfo;
  List<Widget> _screens = [];

  void _handleLogin(String email) async {
  final apiService = Provider.of<ApiService>(context, listen: false);
  try {
    final userInfo = await apiService.getUserInfo(email);
    // Sort events by date
    List<dynamic> sortedEvents = List.from(userInfo['eventList'] ?? []);
    sortedEvents.sort((a, b) => (a['date'] ?? '').compareTo(b['date'] ?? ''));

    setState(() {
      _isLoggedIn = true;
      _userInfo = userInfo;
      _screens = [
        const ClubsScreen(),
        const SearchScreen(),
        EventsScreen(events: sortedEvents),
        ProfileScreen(userInfo: userInfo),
      ];
    });
  } catch (e) {
    // Handle error
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn
        ? Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              selectedItemColor: Color.fromARGB(255, 227, 174, 40),
              unselectedItemColor: Colors.black,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.event),
                  label: 'Events',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          )
        : AuthScreen(onLogin: _handleLogin);
  }
}

class AuthScreen extends StatefulWidget {
  final void Function(String email) onLogin;

  const AuthScreen({super.key, required this.onLogin});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showLogin = true;

  void _toggleAuthMode() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showLogin ? 'Login' : 'Register'),
        actions: [
          TextButton(
            onPressed: _toggleAuthMode,
            child: Text(
              _showLogin ? 'Register' : 'Login',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _showLogin
          ? LoginPage(onLogin: widget.onLogin)
          : RegisterPage(onLogin: widget.onLogin),
    );
  }
}

class RegisterPage extends StatefulWidget {
  final void Function(String email) onLogin;

  const RegisterPage({super.key, required this.onLogin});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final email = _emailController.text;
      final password = _passwordController.text;

      final response = await apiService.registerUser({
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        widget.onLogin(email);
      } else {
        // Handle registration error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: _register,
              child: const Text('Register', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final void Function(String email) onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UCF Club and Event Manager'),
      ),
      body: _LoginPage(onLogin: onLogin),
    );
  }
}

class _LoginPage extends StatefulWidget {
  final void Function(String email) onLogin;

  const _LoginPage({super.key, required this.onLogin});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final email = _emailController.text;
      final password = _passwordController.text;

      final response = await apiService.loginUser({
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        widget.onLogin(email);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'UCF Club and Event Manager',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 227, 174, 40),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: _login,
              child: const Text('Login', style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

class ClubsScreen extends StatelessWidget {
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming the first 2 clubs are 'featured' and the next 4 clubs are 'new'
    List<Club> featuredClubs = clubs.sublist(0, 2);
    List<Club> newClubs = clubs.sublist(2, 6);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Knights Events & Clubs Portal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Featured Clubs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: featuredClubs.length,
                itemBuilder: (context, index) {
                  Club club = featuredClubs[index];
                  return FeaturedClubCard(
                    name: club.name,
                    imagePath: club.imagePath,
                    clubId: club.id,
                    onJoin: () async {
                      print('User $userID is joining club ${club.name}');
                      ApiService apiService = Provider.of<ApiService>(context, listen: false);
                      var response = await apiService.joinClub(userID, club.id);
                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joined ${club.name} successfully!')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to join ${club.name}')));
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'New Clubs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: newClubs.length,
                itemBuilder: (context, index) {
                  return ClubCard(
                    name: newClubs[index].name,
                    imagePath: newClubs[index].imagePath,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClubCard extends StatelessWidget {
  final String name;
  final String imagePath;

  const ClubCard({required this.name, required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 227, 174, 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 50,
              width: 50,
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedClubCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final String clubId;
  final VoidCallback onJoin;

  const FeaturedClubCard({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.clubId,
    required this.onJoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Card tapped for club $name!');
      },
      child: Card(
        color: Color.fromARGB(255, 227, 174, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     onJoin();
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue, // background (button) color
            //   ),
            //   child: const Text('Join'),
            // )
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Club> filteredClubs = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredClubs = clubs; // Initialize with all clubs
  }

  void filterClubs(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredClubs = clubs;
      });
    } else {
      setState(() {
        filteredClubs = clubs.where((club) {
          return club.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Clubs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search for a club',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    filterClubs('');
                  },
                ),
              ),
              onChanged: filterClubs,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredClubs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(filteredClubs[index].imagePath),
                  title: Text(filteredClubs[index].name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EventsScreen extends StatelessWidget {
  final List<dynamic> events;

  const EventsScreen({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...events.map((event) {
              final eventDetails = (event['eventDetail'] as List<dynamic>).isNotEmpty
                ? event['eventDetail'][0]
                : {'topic': 'No topic', 'describe': 'No description available'};
              return EventCard(
                date: event['date'] ?? 'Unknown Date',
                title: event['Ename'] ?? 'Untitled Event',
                location: event['location'] ?? 'Unknown Location',
                description: "${eventDetails['topic']}: ${eventDetails['describe']}",
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String date;
  final String title;
  final String location;
  final String description;

  const EventCard({
    required this.date,
    required this.title,
    required this.location,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Format date and time
    final dateTime = DateTime.tryParse(date) ?? DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    final formattedTime = DateFormat('HH:mm').format(dateTime);

    return Card(
      color: Color.fromARGB(255, 227, 174, 40),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(formattedTime, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 5),
            Text(location, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  const ProfileScreen({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    final firstName = userInfo['firstName'] ?? 'First Name';
    final lastName = userInfo['lastName'] ?? 'Last Name';
    final userID = userInfo['_id'] ?? 'No ID';
    final clubs = userInfo['clubList']?.map((club) => club['name']).toList() ?? [];
    final events = userInfo['eventList']?.map((event) {
      final eventDetails = (event['eventDetail'] as List<dynamic>).isNotEmpty
        ? event['eventDetail'][0]
        : {'topic': 'No topic', 'describe': 'No details available'};
      return {
        'date': event['date'] ?? 'Unknown Date',
        'location': event['location'] ?? 'No Location',
        'title': event['Ename'] ?? 'Untitled Event',
        'description': eventDetails['describe'],
        'topic': eventDetails['topic'],
      };
    }).toList() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$firstName $lastName', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Your Clubs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            clubs.isNotEmpty
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: clubs.length,
                    itemBuilder: (context, index) {
                      return ClubCard(
                        name: clubs[index],
                        imagePath: 'assets/club_logo.png',
                      );
                    },
                  )
                : const Text('No clubs found'),
            const SizedBox(height: 20),
            const Text('Your Events', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            events.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return EventCard(
                        date: events[index]['date'],
                        title: events[index]['title'],
                        location: events[index]['location'],
                        description: "${events[index]['topic']}: ${events[index]['description']}",
                      );
                    },
                  )
                : const Text('No events found'),
          ],
        ),
      ),
    );
  }
}