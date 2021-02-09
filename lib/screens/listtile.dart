import 'package:ChatApp/screens/chatScreen.dart';
import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  final String username;
  final String sender, reciever, img, recieverToken;
  Tile(
      {this.username,
      this.sender,
      this.reciever,
      this.img,
      this.recieverToken});
  @override
  _TileState createState() => _TileState(
      username: username,
      reciever: reciever,
      img: img,
      sender: sender,
      recieverToken: recieverToken);
}

class _TileState extends State<Tile> {
  final String username;
  final String sender, reciever, img, recieverToken;
  String lastMsg;
  _TileState(
      {this.username,
      this.sender,
      this.reciever,
      this.img,
      this.recieverToken});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatScreen(
            sender: sender,
            reciever: reciever,
            img: img,
            dispName: username,
            recieverToken: recieverToken,
          );
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          border: Border.all(color: Colors.black54),
        ),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          title: Text(username),
          subtitle: Text('Something'),
          leading: Container(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5000),
              child: img != null
                  ? Image.network(
                      img,
                      fit: BoxFit.scaleDown,
                    )
                  : Image.asset('assets/images/man.png'),
            ),
          ),
          trailing: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.yellow,
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(40),
            ),
            padding: EdgeInsets.all(0),
            child: Image.asset('assets/images/arrow.png'),
          ),
        ),
      ),
    );
  }
}
