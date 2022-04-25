import 'package:flutter/material.dart';
import 'package:newsound_admin/Services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  //controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //foucs nodes that are used later to change the focus to different fields
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
    return const CircleAvatar(
      radius: 70,
      backgroundImage: AssetImage(
        "lib/Images/logo.png",
      ),
      // foregroundImage: AssetImage(
      //   "lib/Images/pasters.png",
      // ),
    );
  }

  Widget buildEmail() {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          focusNode: focusNode_email,
          keyboardType: TextInputType.emailAddress,
          //autovalidateMode: AutovalidateMode.onUserInteraction,
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
            const pattern =
                r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
            final regExp = RegExp(pattern);

            if (value!.isEmpty) {
              return "write admin email";
            } else if (!regExp.hasMatch(value)) {
              return "Enter valid email";
            }

            return null;
          },
          onSaved: (value) {},
        ),
        const SizedBox(
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
                ? const Icon(Icons.lock)
                : isPasswordVisible
                    ? IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.visibility_off),
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
        const SizedBox(
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

        final isValid = formKey.currentState!.validate();
        if (isValid) {
          formKey.currentState!.save();
          AuthServive().signInWithEmail(
              emailController.text.trim(), passwordController.text.trim());

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );
        }
      },
      child: const Text(
        "Sign In",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildSignInOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              AuthServive().signInWithGoogle();

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    Center(child: CircularProgressIndicator()),
              );
            },
            icon: FaIcon(
              FontAwesomeIcons.google,
              size: 30.0,
            )),
        IconButton(
            onPressed: () {},
            icon: FaIcon(
              FontAwesomeIcons.apple,
              size: 30.0,
            )),
      ],
    );
  }

  Widget buildForgotPassword() {
    return TextButton(
      onPressed: () {},
      child: const Text("Forgot Password?"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Admin Login"))),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
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
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.all(10.0)),
                        const Text(
                          "Sign in as Admin",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30.0),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        buildEmail(),
                        buildPassword(),
                        buildSignInButton(),
                        buildSignInOptions(),
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
