import 'package:flutter/material.dart';

class FullScreenImagePage extends StatefulWidget {

  final String imgPath;
  FullScreenImagePage(this.imgPath);

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  final LinearGradient backgroundGradient = new LinearGradient(
      colors: [new Color(0x10000000), new Color(0x30000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(gradient: backgroundGradient),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: widget.imgPath,
                child:Image.asset(
                  "assets/${widget.imgPath}",
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.darken,
                ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppBar(
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Icon(Icons.delete, color: Colors.black),
                              ),
                               Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Icon(Icons.add, color: Colors.black),
                              ),
                               Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Icon(Icons.update, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: new Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        onPressed: () => print("Refresh"),
      ),
    );
  }
}
