// class Friends {
//   Map<dynamic, dynamic> _friends = Map();

//   Friends(){
//     _friends = new Map<dynamic, dynamic>();
//   }
//   //UnmodifiableListView<dynamic> get lastMessages => UnmodifiableListView(_lastMessages);
//   int length() {
//     return _friends.length;
//   }

//   int getRange(int index){
//     return index;
//   }

//   void clear(){
//     _friends.clear();
//   }

//   dynamic data( dynamic id, dynamic data){
//      return _friends[id][data];
//   }
//   String message( String id, dynamic data){
//      return _friends[id]["lastMessages"][data];
//   }

//   void add(String id, dynamic data){
//     _friends[id] = data;   
//   }
//   void addWith(dynamic id, dynamic index, dynamic data){
//     _friends[id][index] = data;
//   }
//   String at(int index){
//     return _friends.keys.elementAt(index);
//   }

//   void setData(dynamic index, dynamic data){
//      _friends[index]['lastMessages']["content"] = data;
//      _friends[index]['lastMessages']["time"] = data;
//   }

  bool isFriend(String name, Map lists){
    bool friend = false;
    lists.forEach((key, value) {
      if(value['name'] == name)
        {
          friend = true;         
        }
    });
    return friend;
  
// addFriend(dynamic friend) async{
//     _friends[friend["id"]] = friend;
//     // ignore: await_only_futures
//     final db =  await FirebaseDatabase.instance.reference();
//     await db.child('users').child(currentUser['id']).child('friends').child(friend['id']).set({
//       'image': friend['image'],
//       'lastMessages': {'content': " ", 'time': " "},
//       'name': friend['name']
//     });
//      await db.child('users').child(friend['id']).child('friends').child(currentUser['id']).set({
//       'image': currentUser['image'],
//       'lastMessages': {'content': " ", 'time': " "},
//       'name': currentUser['name']
//     });
//     notifyListeners();
//   }
 }