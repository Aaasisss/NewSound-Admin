import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:newsound_admin/Screens/Home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //to control password visibility and this icons accordingly
  bool isPasswordVisible = false;

  @override
  initState() {
    super.initState();

    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  Widget buildEmail() {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Email",
            hintText: "example1@gmail.com",
            suffixIcon: emailController.text.isEmpty
                ? Icon(Icons.email)
                : IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => emailController.clear(),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "write admin email";
            }
          },
          onSaved: (value) {},
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      children: [
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffixIcon: passwordController.text.isEmpty
                ? Icon(Icons.lock)
                : isPasswordVisible
                    ? IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
          ),
          obscureText: !isPasswordVisible,
          autocorrect: false,
          enableSuggestions: false,
          validator: (value) {
            if (value!.isEmpty) {
              return "write admin password";
            }
          },
          onSaved: (value) {},
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Widget buildSignInButton() {
    return ElevatedButton(
      onPressed: () {
        //Navigator.pushNamed(context, '/home');
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => HomePage()));
        print(emailController.text);
        print(passwordController.text);
      },
      child: Text("Sign In"),
    );
  }

  Widget buildForgotPassword() {
    return TextButton(
      onPressed: () {},
      child: Text("Forgot Password?"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Login")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0x665ac18e),
              Color(0x995ac18e),
              Color(0xcc5ac18e),
              Color(0xff5ac18e),
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Form(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.all(10.0)),
                      Text(
                        "Sign in as Admin",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      buildEmail(),
                      buildPassword(),
                      buildSignInButton(),
                      buildForgotPassword(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
