import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/utilities/function.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/screens/actualityPage.dart';
import 'package:myapp/utilities/constants.dart';
import 'dart:io';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInAndRegisterPage extends StatefulWidget {

  @override
  _SignInAndRegisterPage createState() => _SignInAndRegisterPage();
}


class _SignInAndRegisterPage extends State<SignInAndRegisterPage>with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  bool signIn = true;
  late final emailController = TextEditingController();
  late final passwordController = TextEditingController();
  late final nameController = TextEditingController();
  late bool _showPassword = false;

  late File _image;
  final picker = ImagePicker();
  OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: inputColor),
    borderRadius: BorderRadius.circular(25),
  );

  bool _error1 = false;
  bool _error2 = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(230, 230, 230, 1),
        body: SingleChildScrollView(
          child:Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(250, 250, 250, 1),
                Color.fromRGBO(230, 230, 230, 1)
              ],
              begin: Alignment.topCenter, end: Alignment.bottomCenter)
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 35,),
                Container(
                  height: MediaQuery.of(context).size.height/3-20,
                  child: Image.asset("assets/images/3531375.jpg")
                ),
                SizedBox(height: 10,),
                Form(
                key: _formKey,
                child: ScaleTransition(
                  scale: _animation,
                    child: Container(
                      width: MediaQuery.of(context).size.width-40,
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                      children: <Widget>[
                        SizedBox(height: signIn ? 70 : 35,),
                          _buildInput("Email",Icons.mail_outlined, emailController, true),
                          if(!signIn)
                            SizedBox(height: 20,),
                          if(!signIn)
                            _buildInput("Name",Icons.person_outlined,  nameController, false),
                          SizedBox(height: 20,),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if(value!.isEmpty){
                                return "Please enter a password";
                              }
                              else if(_error2)
                                return "Wrong password";
                              
                              return null;
                            },
                            controller: passwordController,
                            obscureText: !this._showPassword,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: inputColor,
                              enabledBorder: border,
                              focusedBorder: border,
                              errorBorder: border,
                              focusedErrorBorder: border,
                              prefixIcon: Icon(Icons.security_outlined, color: iconColor),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[400]),                                     
                              suffixIcon: IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: this._showPassword ? Colors.blue : iconColor
                                ),
                                onPressed: () => setState(() => this._showPassword = !this._showPassword),
                                splashRadius: 15,
                              ),
                              
                            ),
                          ),
                          SizedBox(height: 10,),
                          if(signIn)Align(
                            alignment: Alignment.bottomRight,
                            child: Text("Forgotten password?", style: TextStyle(fontFamily: "arial", color: Colors.blueAccent)),
                          ),
                          if(!signIn) SizedBox(height: 10,),
                          if(!signIn)
                          ElevatedButton.icon(
                            onPressed: () async{
                              _image = await getImage();
                            },
                            icon: Icon(Icons.photo_album, size: 25,), 
                            label: Text("Add photo", style: TextStyle(fontSize: 17, fontFamily: "ubuntu")),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                              backgroundColor: MaterialStateProperty.resolveWith(getColor),
                              fixedSize: MaterialStateProperty.all(Size(350, 50))
                            )
                          ),
                          SizedBox(height: 25),
                          ElevatedButton.icon(
                            onPressed: () async {
                              // final snackBar = SnackBar(
                              //   content : Text("Process data ... ")
                              // );
                              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              signIn ? await _signIn() : await _register();
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ActualityPage(index: 0)));
                              }                  
                            },
                            icon: Icon(Icons.login_outlined, color: Colors.white,), 
                            label: Text(signIn ? "Login" : "Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                            style: buttonStyle
                          ),
                          SizedBox(height: 20,),
                          if(signIn)Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have an account? "),
                              TextButton(
                                child: Text("Sign Up", style: TextStyle(color: Colors.red)),
                                onPressed: () => setState(() => signIn = false),
                              ),
                            ]
                          )else
                          TextButton(
                            child: Text("Sign In", style: TextStyle(color: Colors.red)),
                            onPressed: () => setState(() => signIn = true),
                          ),
                        ]               
                      )                
                  )
                )
              )
            ]
          )
        )
      )
    );
  }

  Widget _buildInput(String text, IconData icon, TextEditingController controller, bool isforMail)
  {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      controller: controller,
      validator: (value) {
        if(isforMail){ 
          if(value!.isEmpty){
            return "Please enter an email";
          }
          else if(_error1)
            return "Email not found";
        }
        else{
          if(value!.isEmpty){
            return "Please enter a name";
          }
        }
        
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: inputColor,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
        prefixIcon: Icon(icon, color: iconColor),
        hintText: text,
        hintStyle: TextStyle(color: hintColor),
      
      ),              
    );
  }
  Future<void> _register() async{
    try{    
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      currentUser.id = userCredential.user!.uid;
      currentUser.image = await uploadPic(_image, "profile");
      await _addUser();
      Navigator.push(context, MaterialPageRoute(builder: (context) => ActualityPage(index: 0)));
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
  }

  Future<void> _addUser() async{
    await FirebaseDatabase.instance.reference().child('users/users_profile').child(currentUser.id.toString()).set({
      'id': currentUser.id,
      'image': currentUser.image,
      'name': nameController.text}
    );
    FirebaseDatabase.instance.reference().child('users/users_about').child(currentUser.id.toString()).set({
      'hobby': ' ',
      'location': ' ',
      'profile': ' ',
      'school': ' '}
    );
  }

  Future<void>_signIn() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
      );
      currentUser.id = userCredential.user!.uid;
      await FirebaseDatabase.instance.reference().child('users/users_profile').child(currentUser.id).once().then((value){currentUser.name = value.value['name'];currentUser.image = value.value['image'];});                      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        setState(() {
          _error1 = true;
        });
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        setState(() {
          _error2 = true;
        });
      }
    }
  }
}
