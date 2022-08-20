
import 'package:beat_sheet/Classes/project_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
//import 'models/user.dart';

class AddUserDialog extends StatefulWidget {

  final Function(ProjectModel) addUser;

  AddUserDialog(this.addUser);

  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {


  @override
  Widget build(BuildContext context) {

    Widget buildTextField(String hint,TextEditingController controller) {
      return Container(
        margin: EdgeInsets.all(4),
        child: TextField(
          decoration: InputDecoration(
            labelText: hint,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black38,
              ),
            ),
          ),
          controller: controller,
        ),
      );
    }

    var project_titleController = TextEditingController();
    var dateController = TextEditingController();
    var project_linkController = TextEditingController();
    var more_iconController = TextEditingController();
    //var phoneNoController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(8),
      height: 350,
      width: 400,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Add project',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.blueGrey,
              ),
            ),
            buildTextField('Project_title', project_titleController),
            buildTextField('Date', dateController),
            buildTextField('Project_link', project_linkController),
            buildTextField('More_icon', more_iconController),
            ElevatedButton(
              onPressed: () {

                final user = ProjectModel(project_titleController.text, dateController.text,
                  project_linkController.text,more_iconController.text);
                widget.addUser(user);
                Navigator.of(context).pop();

              },
              child: Text('Add Project'),
            ),
          ],
        ),
      ),
    );
  }
}


