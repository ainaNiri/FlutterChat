import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/models/constants.dart';
import 'package:myapp/models/listModel.dart';
import 'package:provider/provider.dart';

  // ignore: must_be_immutable
class WidgetOption extends StatefulWidget{
  int index;
  IconData icon;
  String section;

  WidgetOption({required this.index, required this.icon, required this.section});
  
  @override
  _WidgetOptionState createState() => _WidgetOptionState();

}

class _WidgetOptionState extends State<WidgetOption>{
  bool _animate = false;

  static bool _isStart = true;

  @override
  void initState() {
    super.initState();
    _isStart
        ? Future.delayed(Duration(milliseconds: widget.index * 100), () {
            setState(() {
              _animate = true;
              //_isStart = false;
            });
          })
        : _animate = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
     return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      opacity: _animate ? 1 : 0,
      curve: Curves.easeInOutQuart,
      child: AnimatedPadding(
        duration: Duration(milliseconds: 1000),
        padding: _animate
            ? const EdgeInsets.all(4.0)
            : const EdgeInsets.only(top: 10),
        child: Card(
          elevation: 1,
          color: kSecondaryColor, 
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(widget.icon, color: iconSecondaryColor,),
                    SizedBox(width: 10,),
                    Expanded(child: Text(widget.section, style: TextStyle(color: textPrimaryColor,fontWeight: FontWeight.w500, fontSize: 25))),
                    IconButton(icon: Icon(Icons.edit),color: iconSecondaryColor, onPressed: () =>
                        showBottomSheet(context: context, builder: (ctx) => buildEditPage(ctx, widget.section))                  
                    )
                  ]
                ),
                Consumer<ListModel>(builder :(context, list, child) => Text(list.at(widget.index), style: TextStyle(color: textSecondaryColor)))
              ]
            )
          )
        )
      )
     );
  }

  Widget buildEditPage(BuildContext context, String section) {
    TextEditingController _inputController = TextEditingController();
    return Container(
      padding: EdgeInsets.all(15),
      height: 450,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ListTile(title: Text("Change your ${section.toLowerCase()}", style: TextStyle(color: textPrimaryColor))),
          TextField(
            controller: _inputController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "${widget.section}...",
            ),
          ),
          SizedBox(height: 30,),
          ElevatedButton(
            onPressed:() async {
              await FirebaseDatabase.instance.reference().child('users').child(currentUser.id).child('about').update({
                widget.section.toLowerCase() : _inputController.text
              });
              context.read<ListModel>().setData(widget.index, _inputController.text);
              Navigator.pop(context);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
              backgroundColor: MaterialStateProperty.resolveWith(getColor),
              fixedSize: MaterialStateProperty.all(Size(350, 50))
            ), 
            child: Text("Save",)
          )
        ]
      )
    );
  }
}
