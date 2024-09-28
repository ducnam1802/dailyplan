import 'package:daily_planner/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'components/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 110),
          Text(
            'Chào mừng trở lại với DL !!!',
            textAlign: TextAlign.center,
            style: GoogleFonts.pacifico(
              color: Colors.black,
              fontSize: 30,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Account
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 360,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.people,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Password
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 360,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            obscureText: !passwordVisible,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Mật khẩu',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        } else {
                          print('Vui lòng kiểm tra lại thông tin nhập.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(letterSpacing: 4),
                      )),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Đăng nhập bằng tài khoản Microsoft',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ))
                    ],
                  ),
                ],
              ))
        ],
      ),
    )));
  }
}
