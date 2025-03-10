import 'package:flutter/material.dart';

class PlanForm extends StatefulWidget {
  final Function(String, String, DateTime, String) onSubmit;

  PlanForm(this.onSubmit);

  @override
  _PlanFormState createState() => _PlanFormState();
}

class _PlanFormState extends State<PlanForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedPriority = 'Medium';

  void _submitData() {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }
    widget.onSubmit(
      _nameController.text,
      _descriptionController.text,
      _selectedDate,
      _selectedPriority,
    );
    Navigator.of(context).pop();
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create Plan"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Plan Name")),
          TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description")),
          Row(
            children: [
              Text("Date: ${_selectedDate.toLocal()}".split(' ')[0]),
              TextButton(onPressed: _pickDate, child: Text("Choose Date")),
            ],
          ),
          DropdownButton<String>(
            value: _selectedPriority,
            items: ["Low", "Medium", "High"]
                .map((priority) =>
                    DropdownMenuItem(value: priority, child: Text(priority)))
                .toList(),
            onChanged: (value) => setState(() => _selectedPriority = value!),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: _submitData, child: Text("Add Plan")),
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
      ],
    );
  }
}
