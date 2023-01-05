import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tugas_paa/provider/state_provide.dart';
import 'package:tugas_paa/provider/user_provider.dart';
import 'package:tugas_paa/widgets/custom_loading.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late TextEditingController _emailLogin;
  late TextEditingController _passLogin;
  late TextEditingController _usernameRegis;
  late TextEditingController _emailRegis;
  late TextEditingController _pass1Regis;
  late TextEditingController _pass2Regis;

  @override
  void initState() {
    _emailLogin = TextEditingController();
    _passLogin = TextEditingController();
    _usernameRegis = TextEditingController();
    _emailRegis = TextEditingController();
    _pass1Regis = TextEditingController();
    _pass2Regis = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailLogin.dispose();
    _passLogin.dispose();
    _usernameRegis.dispose();
    _emailRegis.dispose();
    _pass1Regis.dispose();
    _pass2Regis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserProvier>(context, listen: false);
    final state = Provider.of<MyState>(context);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFF9d39ff),
                  Color(0xFF7967ff),
                  Color(0xFF28c8fd),
                ],
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: size.width * 0.85,
                    height: size.height * 0.95,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 237, 237, 237),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                      ),
                    ),
                    child: ListView(
                      children: [
                        const SizedBox(height: 30),
                        Center(
                          child: SvgPicture.asset(
                            "assets/images/book_logo.svg",
                            fit: BoxFit.cover,
                            width: size.width * 0.2,
                            height: size.height * 0.2,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            "Welcome",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 50, 50, 50),
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        if (state.isLogin)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 50, 50, 50),
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                cursorColor: const Color(0xFF9d39ff),
                                controller: _emailLogin,
                                decoration: InputDecoration(
                                  label: const Text("Email"),
                                  labelStyle:
                                      const TextStyle(color: Color(0xFF9d39ff)),
                                  prefixIcon: const Icon(
                                    Icons.email_rounded,
                                    color: Color(0xFF9d39ff),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF9d39ff),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                obscureText:
                                    (state.isVisibleLogin) ? false : true,
                                cursorColor: const Color(0xFF9d39ff),
                                controller: _passLogin,
                                decoration: InputDecoration(
                                  label: const Text("Password"),
                                  labelStyle:
                                      const TextStyle(color: Color(0xFF9d39ff)),
                                  prefixIcon: const Icon(
                                    Icons.lock_rounded,
                                    color: Color(0xFF9d39ff),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      state.isVisibleLogin =
                                          !state.isVisibleLogin;
                                      setState(() {});
                                    },
                                    icon: (state.isVisibleLogin)
                                        ? const Icon(
                                            Icons.visibility_rounded,
                                            color: Color(0xFF9d39ff),
                                          )
                                        : const Icon(
                                            Icons.visibility_off_rounded,
                                            color: Color(0xFF9d39ff),
                                          ),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF9d39ff),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (_) => const CustomLoading(),
                                    );
                                    auth.login(
                                      email: _emailLogin.text,
                                      password: _passLogin.text,
                                      context: context,
                                    );
                                    // _emailLogin.text = "";
                                    // _passLogin.text = "";
                                  },
                                  child: const Text("Login"),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF9d39ff),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.only(
                                      left: 30,
                                      right: 30,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 50, 50, 50),
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                cursorColor: const Color(0xFF9d39ff),
                                controller: _usernameRegis,
                                decoration: InputDecoration(
                                  label: const Text("Username"),
                                  labelStyle:
                                      const TextStyle(color: Color(0xFF9d39ff)),
                                  prefixIcon: const Icon(
                                    Icons.person_rounded,
                                    color: Color(0xFF9d39ff),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF9d39ff),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                cursorColor: const Color(0xFF9d39ff),
                                controller: _emailRegis,
                                decoration: InputDecoration(
                                  label: const Text("Email"),
                                  labelStyle:
                                      const TextStyle(color: Color(0xFF9d39ff)),
                                  prefixIcon: const Icon(
                                    Icons.email_rounded,
                                    color: Color(0xFF9d39ff),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF9d39ff),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                obscureText:
                                    (state.isVisibleLogin) ? false : true,
                                cursorColor: const Color(0xFF9d39ff),
                                controller: _pass1Regis,
                                decoration: InputDecoration(
                                  label: const Text("Password"),
                                  labelStyle:
                                      const TextStyle(color: Color(0xFF9d39ff)),
                                  prefixIcon: const Icon(
                                    Icons.lock_rounded,
                                    color: Color(0xFF9d39ff),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      state.isVisibleLogin =
                                          !state.isVisibleLogin;
                                      setState(() {});
                                    },
                                    icon: (state.isVisibleLogin)
                                        ? const Icon(
                                            Icons.visibility_rounded,
                                            color: Color(0xFF9d39ff),
                                          )
                                        : const Icon(
                                            Icons.visibility_off_rounded,
                                            color: Color(0xFF9d39ff),
                                          ),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF9d39ff),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                obscureText:
                                    (state.isVisibleLogin) ? false : true,
                                cursorColor: const Color(0xFF9d39ff),
                                controller: _pass2Regis,
                                decoration: InputDecoration(
                                  label: const Text("Retype Password"),
                                  labelStyle:
                                      const TextStyle(color: Color(0xFF9d39ff)),
                                  prefixIcon: const Icon(
                                    Icons.lock_rounded,
                                    color: Color(0xFF9d39ff),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      state.isVisibleLogin =
                                          !state.isVisibleLogin;
                                      setState(() {});
                                    },
                                    icon: (state.isVisibleLogin)
                                        ? const Icon(
                                            Icons.visibility_rounded,
                                            color: Color(0xFF9d39ff),
                                          )
                                        : const Icon(
                                            Icons.visibility_off_rounded,
                                            color: Color(0xFF9d39ff),
                                          ),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF9d39ff),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Consumer<UserProvier>(
                                builder: (_, val, __) => Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (_) => const CustomLoading(),
                                      );
                                      if (_pass1Regis.text !=
                                          _pass2Regis.text) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Password tidak sama",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                      state.setMyState = StateCondition.loading;
                                      auth.register(
                                        username: _usernameRegis.text,
                                        email: _emailRegis.text,
                                        password: _pass1Regis.text,
                                        context: context,
                                      );
                                      _usernameRegis.text = "";
                                      _emailRegis.text = "";
                                      _pass1Regis.text = "";
                                      _pass2Regis.text = "";
                                    },
                                    child: const Text("Register"),
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFF9d39ff),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.only(
                                        left: 30,
                                        right: 30,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.925, 0),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            state.isLogin = !state.isLogin;
                            setState(() {});
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RotatedBox(
                                quarterTurns: 3,
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: (state.isLogin)
                                        ? Colors.white
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              (state.isLogin)
                                  ? Container(
                                      height: 40,
                                      width: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            state.isLogin = !state.isLogin;
                            setState(() {});
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RotatedBox(
                                quarterTurns: 3,
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: (state.isLogin)
                                        ? Colors.grey
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              (state.isLogin)
                                  ? const SizedBox()
                                  : Container(
                                      height: 40,
                                      width: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
