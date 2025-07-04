import 'package:flutter/material.dart';
import 'package:sign_in/HomeScreen/homeScreen.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final String correctEmail = 'siddiq@gmail.com';
  final String correctPassword = '1234';
  bool _obscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.arrow_back, size: 30),
              SizedBox(height: 20),
              Text(
                'Sign In',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Text(
                'Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 238, 238, 238),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 238, 238, 238),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 125, 125, 125),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        String enteredEmail = emailController.text.trim();
                        String enteredPassword = passwordController.text.trim();
                        if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill in all fields'),
                              backgroundColor: Colors.black,
                            ),
                          );
                        } else if (enteredEmail == correctEmail &&
                            enteredPassword == correctPassword) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Homescreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Invalid email or password'),
                              backgroundColor: Colors.black,
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_forward, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
