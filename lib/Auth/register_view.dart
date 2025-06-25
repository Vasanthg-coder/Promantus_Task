import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AppContatants/images.dart';
import 'auth_provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(Images.registerLogo, height: 120),
                SizedBox(height: 20),
                Text(
                  "Get Started",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                buildInputField(
                  controller: provider.usernameController,
                  hint: "Username",
                  icon: Icons.account_circle,
                  validator: (value) => value == null || value.isEmpty ? "Username required" : null,
                ),
                SizedBox(height: 15),
                buildInputField(
                  controller: provider.nameController,
                  hint: "Name",
                  icon: Icons.person,
                  validator: (value) => value == null || value.isEmpty ? "Name required" : null,
                ),
                SizedBox(height: 15),
                buildInputField(
                  controller: provider.emailController,
                  hint: "Email",
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Email required";
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    return emailRegex.hasMatch(value) ? null : "Enter valid email";
                  },
                ),
                SizedBox(height: 15),
                buildInputField(
                  controller: provider.passwordController,
                  hint: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty ? "Password required" : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blueAccent,
    minimumSize: Size(double.infinity, 50),
  ),
  onPressed: provider.isLoading
      ? null
      : () async {
          if (_formKey.currentState!.validate()) {
            await provider.saveToPrefs(context);
          }
        },
  child: provider.isLoading
      ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
      : Text("Sign Up",style: TextStyle(color: Colors.white),),
),

                SizedBox(height: 15),
                Text("Or Continue with", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialIcon(Images.googleLogo),
                    SizedBox(width: 16),
                    socialIcon(Images.appleLogo),
                    SizedBox(width: 16),
                    socialIcon(Images.faceBookLogo),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account ?", style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Log in", style: TextStyle(color: Colors.blueAccent)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget socialIcon(String path) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white,
      child: Image.asset(path, height: 20),
    );
  }
}
