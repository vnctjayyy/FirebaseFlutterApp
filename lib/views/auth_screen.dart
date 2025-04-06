import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  // Function to clear the text fields
  void _clearTextFields() {
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _signIn() async {
    final user = await _authController.signIn(
      _emailController.text,
      _passwordController.text,
    );
    if (user != null) {
      print('User signed in: ${user.uid}');
      _clearTextFields(); // Clear text fields after successful login
    }
  }

  Future<void> _signUp() async {
    final user = await _authController.signUp(
      _emailController.text,
      _passwordController.text,
    );
    if (user != null) {
      print('User registered: ${user.uid}');
      final newUser = UserModel(email: _emailController.text);
      await _authController.addUserToFirestore(newUser);
      _clearTextFields(); // Clear text fields after successful registration
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Light background
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Title
                Text(
                  'Firebase Auth & Firestore',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 16),

                // Authentication Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Email Field
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),

                        // Sign In Button
                        ElevatedButton(
                          onPressed: _signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              Text('Sign In', style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 10),

                        // Sign Up Button
                        ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              Text('Sign Up', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Users List
                Text(
                  'Registered Users',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                StreamBuilder<List<UserModel>>(
                  stream: _authController.getUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No users found');
                    }

                    // Get the list of users
                    final users = snapshot.data!;

                    // Sort users by timestamp (newest first)
                    users.sort((a, b) {
                      return (b.timestamp ?? DateTime.now())
                          .compareTo(a.timestamp ?? DateTime.now());
                    });

                    return Container(
                      height: 200, // Fixed height for scrollable list
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              leading: Icon(Icons.person, color: Colors.blue),
                              title: Text(user.email),
                              subtitle: Text(
                                  user.timestamp?.toString() ?? 'No timestamp'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
