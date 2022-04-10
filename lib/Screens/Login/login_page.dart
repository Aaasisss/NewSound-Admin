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

  final focusNode_email = FocusNode();
  final focusNode_password = FocusNode();
  final focusNode_signInButton = FocusNode();
  //to control password visibility and this icons accordingly
  bool isPasswordVisible = false;

  @override
  initState() {
    super.initState();

    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  Widget buildLogo() {
    return CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage(
        "lib/Images/logo.png",
      ),
    );
  }

  Widget buildEmail() {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          focusNode: focusNode_email,
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
          onFieldSubmitted: (value) {
            //changes focus to password field
            FocusScope.of(context).requestFocus(focusNode_password);
          },
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
          focusNode: focusNode_password,
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
          onFieldSubmitted: (value) {
            //changes the focus to sign in Button
            FocusScope.of(context).requestFocus(focusNode_signInButton);
          },
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
      focusNode: focusNode_signInButton,
      onPressed: () {
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
      appBar: AppBar(title: Center(child: Text("Admin Login"))),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(10.0),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildLogo(),
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
      ),
    );
  }
}
