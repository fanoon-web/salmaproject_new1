import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home_page/home_page.dart';
import '../login_page/snakbar.dart';



class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final supabase = Supabase.instance.client;

  Future<void> signUp() async {
    setState(() => isLoading = true);
    try {
      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      if (response.user != null) {
        showAppSnackBar(context,
            message: "Account created successfully ✅", isSuccess: true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userEmail: emailController.text.trim()),
          ),
        );
      }

    } on AuthException catch (e) {
      if (!mounted) return;
      showAppSnackBar(context, message: "Error : ${e.message}", isSuccess: false);
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(context, message: "Something went wrong: $e", isSuccess: false);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.blue[700],
                ),
                onPressed: isLoading ? null : signUp,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
