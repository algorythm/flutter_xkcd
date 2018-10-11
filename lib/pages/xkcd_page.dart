import 'package:flutter/material.dart';
import 'dart:async';

import 'package:xkcd_app/utils/Xkcd.dart';
import 'package:xkcd_app/utils/xkcdReader.dart';

class XkcdPage extends StatefulWidget {
  State createState() => new XkcdPageState();
}

class XkcdPageState extends State<XkcdPage> {
  Xkcd _currentXkcd;
  XkcdReader _xkcdReader = new XkcdReader();

  Image _image;
  bool _loading = true;

  // void initState() async {
  //   _currentXkcd = await _xkcdReader.fetchLatestXkcd();
  //   _image = new Image.network(_currentXkcd.img);
  // }

  @override
  void initState() {
    super.initState();
    _xkcdReader.fetchLatestXkcd().then((xkcd) {
      setState(() {
        _currentXkcd = xkcd;
        _image = new Image.network(xkcd.img);
        setImageListener();
      });
    });
  }

  void setImageListener() {
    _image.image.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          // Set _loading to false when the image is fully loaded
          _loading = false;
        });
      }
    });
  }

  void loadNextXkcd() async {
    _loading = false;
    Xkcd xkcd = await _xkcdReader.nextXkcd();

    setState(() {
      if (xkcd == null) return;
      _currentXkcd = xkcd;
      _image = new Image.network(xkcd.img);
      setImageListener();
    });
  }

  void loadPreviousXkcd() async {
    _loading = false;
    Xkcd xkcd = await _xkcdReader.previousXkcd();

    setState(() {
      if (xkcd == null) return;
      _currentXkcd = xkcd;
      _image = new Image.network(xkcd.img);
      setImageListener();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _currentXkcd == null
        ? new Center(child: new CircularProgressIndicator())
        : SingleChildScrollView(
          child: new Card(
            margin: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  title: new Text(_currentXkcd.title),
                  subtitle: new Text(_currentXkcd.alt),
                ),
                _loading ? new CircularProgressIndicator() : _image,
                new ButtonTheme.bar(
                    child: new ButtonBar(
                  children: <Widget>[
                    new FlatButton(
                      child: const Text("BACK"),
                      onPressed: () => loadPreviousXkcd(),
                    ),
                    new FlatButton(
                      child: const Text("NEXT"),
                      onPressed: () => loadNextXkcd(),
                    )
                  ],
                ))
              ],
            )));
  }
}
