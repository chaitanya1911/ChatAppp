import 'package:ChatApp/screens/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MesssageTile extends StatelessWidget {
  final String msg, imgurl;
  final String time, date;
  final Alignment align;
  final Color color1;
  final Color color2;
  final double left, right;
  MesssageTile(
      {this.imgurl,
      this.msg,
      this.time,
      this.date,
      this.align,
      this.color1,
      this.color2,
      this.left,
      this.right});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            constraints:
                BoxConstraints(minWidth: 50, maxWidth: 300, minHeight: 50),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 21),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color1, color2]),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(
                    20,
                  ),
                  bottomLeft: Radius.circular(left),
                  bottomRight: Radius.circular(right)),
            ),
            child: imgurl == null
                ? Text(
                    msg,
                    style: TextStyle(fontSize: 20),
                  )
                : FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ImageViewer(url: imgurl);
                      }));
                    },
                    child: Image.network(imgurl)),
          ),
          Positioned(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    right: 2,
                  ),
                  child: Text(
                    '$time',
                    style: TextStyle(fontSize: 9, color: Colors.black45),
                  ),
                  color: Colors.transparent,
                ),
                Container(
                  padding: EdgeInsets.only(
                    right: 2,
                  ),
                  child: Text(
                    '$date',
                    style: TextStyle(fontSize: 9, color: Colors.black45),
                  ),
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
