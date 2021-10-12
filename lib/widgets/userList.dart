
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/models/friendModel.dart';
import 'package:myapp/screens/profilePage.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ListUser extends StatelessWidget {
  List<User> users;
  bool isForSearch;
  ListUser({ Key? key , required this.users, required this.isForSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var friends = context.watch<FriendsModel>();
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: this.users.isEmpty ? 0 : this.users.length,
      itemBuilder: (BuildContext context, int index) {
        int friendId = isFriend(this.users[index].name, friends);
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(10.0),
          child: Material(
            color: kPrimaryColor,
            child: Column(children: <Widget>[
              ListTile(
                focusColor: Colors.grey[50],
                dense: false,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(this.users[index].image),
                  radius: 27,
                ),
                title: Text(this.users[index].name, style: TextStyle(color: textPrimaryColor),),
                trailing: isForSearch ? IconButton(onPressed: (){}, icon:  (friendId != -1) ? Icon(Icons.message_sharp, color: Colors.blue.shade700,): 
                  (users[index].name.toLowerCase() == currentUser.name.toLowerCase() ? 
                    Icon(Icons.account_box_rounded, color: Colors.blue.shade700,) : Icon(Icons.person_add, color: Colors.blue.shade700)
                  )
                ) : null,
                onTap: (){
                  if(this.users[index].name == currentUser.name){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return ProfilePage(
                          person: currentUser);
                          }
                        )
                    );
                  }
                  else if(this.users[index].name.toLowerCase() != currentUser.name.toLowerCase() &&  (friendId == -1)){ 
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return ProfilePage(
                          icon: Icon(Icons.add),
                          person: this.users[index],);
                          }
                        )
                    );}
                  else if (friendId != -1){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){ return ProfilePage(
                      chatId: friends.friends[friendId].chatId,
                      icon: Icon(Icons.message),
                      person: this.users[index],
                      friend: "Message",
                      friendConnected: friends.friends[friendId].connected);})
                  );
                  }
                }
              ), 
            ]),
          ),
        );
      },
    );
  }

   int isFriend(String name, FriendsModel friends){
    return friends.friends.indexWhere((element) => element.name == name);
  }
  
}