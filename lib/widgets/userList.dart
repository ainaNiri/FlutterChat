
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/providers/friendModel.dart';
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
                trailing: isForSearch ? IconButton(onPressed: (){}, icon:  (friendId != -1) ? Container(
                    padding: EdgeInsets.all(5) ,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFF5B9FDE), width: 1)
                    ),
                    child: Icon(Icons.message_outlined, size: 20, color: Colors.blue.shade700,)
                  ): 
                  (users[index].name.toLowerCase() == currentUser.name.toLowerCase() ? 
                    Container(
                      padding: EdgeInsets.all(5) ,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF5B9FDE), width: 1)
                      ),
                      child: Icon(Icons.account_box_outlined, size: 20, color: Colors.blue.shade700,)
                    ) : 
                    Container(
                      padding: EdgeInsets.all(5) ,
                      decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFF5B9FDE), width: 1)
                      ),
                      child: Icon(Icons.person_add_outlined, size: 20, color: Colors.blue.shade700)
                    )
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
              Divider() 
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