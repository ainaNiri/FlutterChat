import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/models/friendModel.dart';
import 'package:myapp/screens/profilePage.dart';
import 'package:provider/provider.dart';

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

  int isFriend(String name, FriendsModel friends){
    for(int i = 0; i < friends.length(); i++){
      if(friends.friends[i].name == name)
        {
          return i;         
        }
    }
    return -1;
  }

  @override
  void initState() {
    super.initState();
    _filter.addListener(() { _function();});
  }

  Widget build(BuildContext context) {
    var _friends = context.watch<FriendsModel>();
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(_friends),
      ),
    );
  }

  Widget _buildList(FriendsModel friends) {
    if (_searchText.isNotEmpty) {
      return FutureBuilder(
        future: FirebaseDatabase.instance.reference().child('users').orderByChild('name').once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot){
          if(snapshot.hasData && snapshot.data?.value != null ){
            Map<dynamic, dynamic> values = snapshot.data!.value;
            filteredNames.clear();
            values.forEach((key, value) {
              if(value['user']['name'].toLowerCase().contains(_searchText.toLowerCase()))
                filteredNames.add(User(
                  id: value['user']['id'],
                  name: value['user']['name'],
                  image: value['user']['image'],
                )
                );
            });           
            filteredNames.shuffle();
            return ListView.builder(
              itemCount: filteredNames.isEmpty ? 0 : filteredNames.length,
              itemBuilder: (BuildContext context, int index) {
                int friendId = isFriend(filteredNames[index].name, friends);
                return Column(children: <Widget>[
                  ListTile(
                    dense: false,
                    title: Text(filteredNames[index].name),
                    trailing: IconButton(onPressed: (){}, icon:  (friendId != -1) ? Icon(Icons.message_sharp): (filteredNames[index].name.toLowerCase() == currentUser.name.toLowerCase() ? Icon(Icons.account_box_rounded) : Icon(Icons.person_add))),
                    onTap: (){if(filteredNames[index].name.toLowerCase() != currentUser.name.toLowerCase() &&  (friendId == -1)){ 
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){
                          return ProfilePage(
                            icon: Icon(Icons.add),
                            person: filteredNames[index],);
                            }
                          )
                      );}
                      else if (friendId != 1){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){ return ProfilePage(
                          chatId: friends.friends[friendId].chatId,
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