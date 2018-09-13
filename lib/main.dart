import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Radical Illumination',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Radical Illumination'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _LightingSetupData {
  num _lumens = 1.0;
  num _ledBeamAngle = 5;
  num _distance = 1;

  num getLux() {
    final beamArea = (2 * pi * _distance * _distance) *
        (1 - cos(degreeToRadians(_ledBeamAngle / 2)));
    return this._lumens / beamArea;
  }

  num degreeToRadians(num degree) {
    return (pi / 180) * degree;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _lumensTextInputController =
      new TextEditingController(text: "1");
  _LightingSetupData _state = new _LightingSetupData();

  @override
  void initState() {
    super.initState();
    _lumensTextInputController.addListener(changeLumensInState);
  }

  @override
  void dispose() {
    _lumensTextInputController.removeListener(changeLumensInState);
    _lumensTextInputController.dispose();
    super.dispose();
  }

  void changeLumensInState() {
    setState(() {
      this._state._lumens =
          double.tryParse(_lumensTextInputController.text) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Column(
          children: <Widget>[
            new ListTile(
              title: new TextField(
                keyboardType: TextInputType.number,
                controller: _lumensTextInputController,
                decoration: new InputDecoration(labelText: 'Lumens'),
              ),
            ),
            new ListTile(
              title: new Text('LED beam angle: ${_state._ledBeamAngle}°'),
              subtitle: new Slider(
                  label: 'LED beam angle',
                  value: _state._ledBeamAngle.toDouble(),
                  min: 5.0,
                  max: 120.0,
                  onChanged: (double value) {
                    setState(() {
                      _state._ledBeamAngle = value.toInt();
                    });
                  }),
            ),
            new ListTile(
              title: new Text('Distance: ${_state._distance}m'),
              subtitle: new Slider(
                  label: 'Distance',
                  value: _state._distance.toDouble(),
                  min: 1.0,
                  max: 500.0,
                  onChanged: (double value) {
                    setState(() {
                      _state._distance = value.toInt();
                    });
                  }),
            ),
            new ListTile(
              title: new Text('Lux'),
              subtitle: new Text(_state.getLux().toStringAsFixed(2)),
            ),
          ],
        ));
  }
}
