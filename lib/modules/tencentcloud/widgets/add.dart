import '../utils/constants.dart';

import '../models/common.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration:
                InputDecoration(labelText: AppLocalizations.of(context)!.port),
            keyboardType: TextInputType.number,
            controller: _portController,
          ),
          const SizedBox(height: 12.0),
          DropdownButton<String>(
            hint: Text(AppLocalizations.of(context)!.selectProtocol),
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
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.description),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.add),
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
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
