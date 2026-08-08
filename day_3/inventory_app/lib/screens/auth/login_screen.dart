import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../list/helper.dart';
import 'auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final readProvider = context.read<AuthProvider>();
    final watchProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: readProvider.formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Text("Login", style: TextStyle(fontSize: 26)),
                const SizedBox(height: 24),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Masukkan email anda",
                  ),
                  onChanged: (value) {
                    readProvider.email = value.trim();
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Masukkan password anda",
                  ),
                  onChanged: (value) {
                    readProvider.password = value.trim();
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Password tidak boleh kosong";
                    }
                    if (value.trim().length < 8) {
                      return "Password kurang dari 8 karakter";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                watchProvider.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (readProvider.formKey.currentState!.validate()) {
                              actionLogin(readProvider, context);
                            }
                          },
                          child: const Text("Login"),
                        ),
                      ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? Silahkan daftar "),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen()));
                        },
                        child: const Text("disini",
                            style: TextStyle(color: Colors.blue)))
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

void actionLogin(AuthProvider readProvider, BuildContext context) async {
  try {
    final response = await readProvider.login();
    if (!context.mounted) return;

    if (response?.status == "success" || response?.data?.token != null) {
      Helper.showSnackBar(
        context,
        response?.message ?? "Login berhasil!",
        color: Colors.green,
      );
    } else {
      Helper.showSnackBar(
        context,
        response?.message ?? "Login gagal!",
        color: Colors.red,
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    Helper.showSnackBar(
      context,
      e.toString().replaceAll("Exception: ", ""),
      color: Colors.red,
    );
  }
}
