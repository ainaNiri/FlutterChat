import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/chatUsersModel.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/providers/listModel.dart';
import 'package:provider/provider.dart';

  // ignore: must_be_immutable
class WidgetOption extends StatefulWidget{
  int index;
  IconData icon;
  String section;
  bool isMe;
  String? text;

  WidgetOption({required this.index, required this.icon, required this.section, required this.isMe, this.text});
  
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
          color: kSecondaryColor,
          elevation: 0.5,
          child: Container(
            color: kSecondaryColor,
            padding: EdgeInsets.fromLTRB(20, 20, 7, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFF5B9FDE),
                                ),
                                child: Icon(widget.icon, color: kPrimaryColor, size: 15,)
                              ),
                              SizedBox(width: 10,),
                              Text(widget.section, style: TextStyle(color: Color(0xFF5B9FDE),fontWeight: FontWeight.w300, fontSize: 15)),
                            ]
                          ),
                          // SizedBox(height: 5,),
                          // Container(height: 1, color: Color(0xFF5B9FDE), width: 2 * MediaQuery.of(context).size.width/3,),
                        ],
                      ),
                    ),
                    if(widget.isMe)
                      IconButton(icon: Icon(Icons.edit), iconSize: 16, color: iconSecondaryColor, onPressed: () =>
                        showModalBottomSheet(context: context, builder: (ctx) => _buildEditPage(ctx, widget.section))                  
                    )
                  ],
                ),
                SizedBox(height: 5,),
                if(widget.isMe)
                  Consumer<ListModel>(builder :(context, list, child) => Text(list.at(widget.index), style: TextStyle(fontSize: 15, color: textSecondaryColor, fontWeight: FontWeight.w400)))
                else
                  Text(widget.text ?? "", style: TextStyle(fontSize: 15, color: textSecondaryColor, fontWeight: FontWeight.w400))
              ]
            )
          ),
        )
      )
     );
  }

  Widget _buildEditPage(BuildContext context, String section) {
    TextEditingController _inputController = TextEditingController();
    return Container(
      color: kPrimaryColor,
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
              labelStyle: TextStyle(color: textSecondaryColor),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textPrimaryColor)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: textPrimaryColor))  
            ),
            style: TextStyle(color: textPrimaryColor),
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
