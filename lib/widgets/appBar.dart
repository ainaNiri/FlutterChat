import 'package:flutter/material.dart';
import 'package:myapp/screens/searchPage.dart';
import 'package:myapp/screens/settingPage.dart';
import 'package:myapp/widgets/drawer.dart';

PreferredSizeWidget buildAppBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[Colors.indigo.shade600, Colors.indigo.shade300])
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed:(){
                      scaffoldKey.currentState!.openDrawer();
                    } , 
                    icon: Icon(Icons.menu, color: Colors.white,)
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){ return SearchPage();})
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.only(top: 13, left: 25),
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: <Color>[Colors.indigo.shade400, Colors.indigo.shade300]),
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: Text(
                          "Search ...",
                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)
                        )
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){ return SettingPage();})
                      );
                    },
                     icon: Icon(Icons.settings, color: Colors.white)
                  )
                ],
              )
            ),
          ],
        ),     
      )
    );
  }

class BuildDrawer {
}
