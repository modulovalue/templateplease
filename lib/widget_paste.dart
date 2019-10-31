import 'package:flutter/material.dart';
import 'package:templateplease/main.dart';

Widget paste({
  @required TextEditingController sourceController,
}) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ...makeHeader(
          "Paste your recipe ",
          more: [
            const SizedBox(width: 4.0),
            RaisedButton(
              color: const Color(0xFF333333),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                "or import a recipe from GitHub Gist",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
        TextField(
          decoration: const InputDecoration(
            helperText: "Paste (Ctrl/Cmd + V) your recipe here",
            border: OutlineInputBorder(),
          ),
          controller: sourceController,
        ),
      ],
    ),
  );
}
