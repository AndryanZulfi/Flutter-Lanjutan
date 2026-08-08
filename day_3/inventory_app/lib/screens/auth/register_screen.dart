import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../list/helper.dart';
import 'auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const Text("Register", style: TextStyle(fontSize: 26)),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Masukkan nama anda",
                    ),
                    onChanged: (value) {
                      readProvider.name = value.trim();
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Nama tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
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
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Masukkan konfirmasi password anda",
                    ),
                    onChanged: (value) {
                      readProvider.confirmPassword = value.trim();
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Konfirmasi password tidak boleh kosong";
                      }
                      if (value.trim() != readProvider.password) {
                        return "Konfirmasi password tidak cocok";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  watchProvider.isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              if (readProvider.formKey.currentState!
                                  .validate()) {
                                actionRegister(readProvider, context);
                              }
                            },
                            child: const Text("Register"),
                          ),
                        ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun? Silahkan masuk "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "disini",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void actionRegister(AuthProvider readProvider, BuildContext context) async {
  try {
    final response = await readProvider.register();
    if (!context.mounted) return;

    if (response?.status == "success" || response?.data?.user != null) {
      Helper.showSnackBar(
        context,
        response?.message ?? "Register berhasil!",
        color: Colors.green,
      );
      Navigator.pop(context);
    } else {
      Helper.showSnackBar(
        context,
        response?.message ?? "Register gagal!",
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
