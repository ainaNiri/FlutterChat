import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/colorModel.dart';
import 'package:path/path.dart' as path;
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/screens/actualityPage.dart';
import 'dart:io';

final FirebaseAuth _auth = FirebaseAuth.instance;
final _formKey = GlobalKey<FormState>();

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
  bool _animateOpacity = false;

  static bool _isStart = true;

  late File _image;
  final picker = ImagePicker();

  Future <void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  Future<String> uploadPic() async {
    String url= " ";
   FirebaseStorage storage =  FirebaseStorage.instance;
   // ignore: await_only_futures
   Reference ref = await storage.ref().child("profile/"+path.basename(_image.toString()));
   UploadTask uploadTask = ref.putFile(_image);
   url = await(await uploadTask).ref.getDownloadURL();
    print(_image);
    return url;
} 

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    if(_isStart){
      Future.delayed(Duration(milliseconds: 3000), () {
        setState(() {
          _animateOpacity = true;
          //_isStart = false;
        });
      });
      //  Future.delayed(Duration(milliseconds: 800), () {
      //   setState(() {
      //     _animateOpacity = true;
      //     //_isStart = false;
      //   });
      // });
    }
    else{
      _animateOpacity = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
            key: _formKey,
            child: ScaleTransition(
              scale: _animation,
                child: Card(
                elevation: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width-40,
                  height: signIn ? 450 : 520,
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AnimatedOpacity(
                  duration: Duration(milliseconds: 2000),
                  opacity: _animateOpacity ? 1 : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(signIn ?'Login' : 'Register', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 40)),
                    SizedBox(height: 30,),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          prefixIcon: Icon(Icons.mail_outline, color: Colors.grey),
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        
                        ),                        
                      ),
                      SizedBox(height: 10,),
                      if(!signIn)TextFormField(
                        style: TextStyle(color: Colors.black),
                        controller: nameController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          prefixIcon: Icon(Icons.person_sharp, color: Colors.grey),
                          hintText: "Name",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          
                        )
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please enter a password";
                          }
                          
                          return null;
                        },
                        controller: passwordController,
                        obscureText: !this._showPassword,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          prefixIcon: Icon(Icons.security,color: Colors.grey,),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: this._showPassword ? Colors.blue : Colors.grey
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
                      if(!signIn)
                      ElevatedButton.icon(
                        onPressed: (){
                          _getImage();
                        },
                        icon: Icon(Icons.photo_album, size: 25,), 
                        label: Text("Add photo", style: TextStyle(fontSize: 17, fontFamily: "ubuntu")),
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(Size(180, 30)),
                        )
                      ),
                      SizedBox(height: 25),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final snackBar = SnackBar(
                            content : Text("Process data ... ")
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          signIn ? _signIn() : _register();                  
                        },
                        icon: Icon(Icons.login_outlined, color: Colors.white,), 
                        label: Text(signIn ? "Login" : "Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          backgroundColor: MaterialStateProperty.resolveWith(getColor),
                          fixedSize: MaterialStateProperty.all(Size(350, 50))
                        )
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
            ),
            )
        )
      )
    );
  }

  Future<void> _register() async{
    try{    
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      currentUser['id'] = userCredential.user!.uid;
      currentUser['image'] = await uploadPic();
      await _addUser();
      Navigator.push(context, MaterialPageRoute(builder: (context) => ActualityPage(index: 0)));
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
    // catch(e){
    // print(e);
    // }
  }
  Future<void> _addUser() async{
     await FirebaseDatabase.instance.reference().child('users').child(currentUser['id'].toString()).child('user').set({
      'id': currentUser['id'],
      'image': currentUser['image'],
      'name': nameController.text}
    );
    FirebaseDatabase.instance.reference().child('users').child(currentUser['id'].toString()).child('about').set({
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
      currentUser['id'] = userCredential.user!.uid;
      await FirebaseDatabase.instance.reference().child('users').child(currentUser['id'].toString()).child('user').once().then((value){currentUser['name'] = value.value['name'];currentUser['image'] = value.value['image'];});                    
      Navigator.push(context, MaterialPageRoute(builder: (context) => ActualityPage(index: 0)));  
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    catch(e){
      print(e);
    }
  }

}
