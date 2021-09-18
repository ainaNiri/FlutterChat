import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/widgets/userList.dart';

class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String _searchText = "";
  List <User> filteredNames = [];
  TextEditingController _filter = TextEditingController();

  _function() {
    if (_filter.text.isEmpty) {
      setState(() {
        _searchText = "";
      });
    } else {
      setState(() {
        _searchText = _filter.text;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _filter.addListener(() { _function();});
  }

  @override
  void dispose(){
    _filter.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: _buildBar(context),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      return FutureBuilder(
        future: FirebaseDatabase.instance.reference().child('users').child("users_profile").once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot){
          if(snapshot.hasData && snapshot.data?.value != null ){
            Map<dynamic, dynamic> values = snapshot.data!.value;
            filteredNames.clear();
            values.forEach((key, value) {
              if(value['name'].toLowerCase().contains(_searchText.toLowerCase()))
                filteredNames.add(User(
                  id: value['id'],
                  name: value['name'],
                  image: value['image'],
                )
                );
            });           
            //filteredNames.shuffle();
            return ListUser(users: filteredNames, isForSearch: true,);
          }
          return Container();
        }
      );
    }
    return Container();
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      backgroundColor: kSecondaryColor,
      elevation: 4,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),color: Colors.blue, onPressed: () { Navigator.pop(context);},
      ),
      title: TextField(
        style: TextStyle(color: textPrimaryColor),
        autofocus: true,
        controller: _filter,
        decoration:  InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: textSecondaryColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)
         )
        )
      ),
    );
  }
}