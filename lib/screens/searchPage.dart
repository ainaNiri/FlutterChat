import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatMessageModel.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/screens/profilePage.dart';

class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String _searchText = "";
  List <Map> filteredNames = [];
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      return FutureBuilder(
        future: FirebaseDatabase.instance.reference().child('users').orderByChild('name').once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot){
          if(snapshot.hasData && snapshot.data?.value != null ){
            Map<dynamic, dynamic> values = snapshot.data!.value;
            filteredNames.clear();
            values.forEach((key, value) {
              if(value['user']['name'].toLowerCase().contains(_searchText.toLowerCase()))
                filteredNames.add(value['user']);
            });           
            filteredNames.shuffle();
            return ListView.builder(
              itemCount: filteredNames.isEmpty ? 0 : filteredNames.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(children: <Widget>[
                  ListTile(
                    dense: false,
                    title: Text(filteredNames[index]['name']),
                    trailing: IconButton(onPressed: (){}, icon:  isFriend(filteredNames[index]['name'], friend) ? Icon(Icons.message_sharp): (filteredNames[index]['name'].toLowerCase() == currentUser['name'].toLowerCase() ? Icon(Icons.account_box_rounded) : Icon(Icons.person_add))),
                    onTap: (){if(filteredNames[index]['name'].toLowerCase() != currentUser['name'].toLowerCase() && !isFriend(filteredNames[index]['name'], friend)){ 
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){
                          return ProfilePage(
                            icon: Icon(Icons.add),
                            person: filteredNames[index],);
                            }
                          )
                      );}
                      else if (isFriend(filteredNames[index]['name'], friend)){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){ return ProfilePage(
                          icon: Icon(Icons.message),
                          person: filteredNames[index],
                          friend: "Message");})
                      );
                      }
                    }
                  ), 
                  Divider()
                ]);
              },
            );
          }
          return Container();
        }
      );
    }
    return Container();
  }

PreferredSizeWidget _buildBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.grey[200],
    elevation: 4,
    leading: IconButton(
      icon: Icon(Icons.arrow_back),color: Colors.blue, onPressed: () { Navigator.pop(context);},
    ),
    title: TextField(
      autofocus: true,
      controller: _filter,
      decoration:  InputDecoration(
        hintText: 'Search...',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)
        )
        )
      ),
    );
  }
}