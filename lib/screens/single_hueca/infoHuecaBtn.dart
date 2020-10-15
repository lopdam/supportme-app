import 'package:flutter/material.dart';
import 'package:supportme_app/Models/hueca_model.dart';
import 'package:supportme_app/Variables/AppColors.dart';

class InfoBtn extends StatefulWidget {
  HuecaModel _hueca;

  InfoBtn(this._hueca);

  @override
  _InfoBtn createState() {
    return _InfoBtn(_hueca);
  }
}

class _InfoBtn extends State<InfoBtn> {
  HuecaModel _hueca;
  BuildContext _context;
  _InfoBtn(this._hueca);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return RawMaterialButton(
      elevation: 4,
      fillColor: Colors.white,
      padding: EdgeInsets.all(8.0),
      shape: CircleBorder(),
      onPressed: _showInfo,
      child: Icon(
        Icons.info_outline,
        color: AppColors.mainColor,
        size: 32,
      ),
    );
  }

  void _showInfo() {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(_hueca.name),
      content: RichText(
        text: TextSpan(
          text: _hueca.description + "\n\n",
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
                text: 'Dirección: ' + _hueca.address,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
