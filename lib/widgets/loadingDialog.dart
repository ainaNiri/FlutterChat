import 'package:flutter/material.dart';

void showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          backgroundColor: Colors.black87,
          content: Container(
            padding: EdgeInsets.all(16),
            color: Colors.black87,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                  'Please wait …',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ]
            )
          )
        )
      );
    },
  );
}