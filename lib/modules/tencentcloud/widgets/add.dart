import 'package:bk_app/modules/tencentcloud/utils/constants.dart';

import '../models/common.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({Key? key, required this.onClick}) : super(key: key);

  final Function(Port) onClick;

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _descpritionController = TextEditingController();
  final List<DropdownMenuItem<String>> _protocolSelectItems = defProtocol
      .entries
      .map((e) =>
          DropdownMenuItem(child: Text(e.key), value: e.value.toString()))
      .toList();
  String _selectedProtocol = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: "Port"),
                keyboardType: TextInputType.number,
                controller: _portController,
              ),
              const SizedBox(height: 12.0),
              DropdownButton<String>(
                hint: const Text("Select Protocol"),
                isExpanded: true,
                items: _protocolSelectItems,
                onChanged: (value) {
                  setState(() {
                    _selectedProtocol = value as String;
                  });
                },
                value: _selectedProtocol == "" ? null : _selectedProtocol,
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: _descpritionController,
                decoration: const InputDecoration(labelText: "Describe"),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: Text('Add'),
                onPressed: () {
                  final tmp = int.tryParse(_portController.text) ?? -1;
                  if (tmp < 0 || tmp > 65535) {
                    return;
                  } else if (_selectedProtocol == "") {
                    return;
                  } else {
                    widget.onClick(Port(
                      port: _portController.text,
                      protocol: _selectedProtocol,
                      description: _descpritionController.text,
                      status: actionAccept,
                    ));
                  }
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: ElevatedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
