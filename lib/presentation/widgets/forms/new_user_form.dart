import 'package:costy/data/models/user.dart';
import 'package:costy/presentation/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/project.dart';
import '../../bloc/bloc.dart';
import '../../bloc/user_bloc.dart';

class NewUserForm extends StatefulWidget {
  final Project project;
  final User userToModify;

  const NewUserForm({Key key, @required this.project, this.userToModify})
      : super(key: key);

  @override
  _NewUserFormState createState() => _NewUserFormState();
}

class _NewUserFormState extends State<NewUserForm> {
  final _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.userToModify != null) {
      _nameController.text = widget.userToModify.name;
    }
    super.initState();
  }

  void _submitData() {
    if (_formKey.currentState.validate()) {
      final enteredName = _nameController.text;

      if (widget.userToModify == null) {
        BlocProvider.of<UserBloc>(context)
            .add(AddUserEvent(enteredName, widget.project));
      } else {
        final User edited = User(id: widget.userToModify.id, name: enteredName);
        BlocProvider.of<UserBloc>(context).add(ModifyUserEvent(edited));
      }

      BlocProvider.of<UserBloc>(context).add(GetUsersEvent(widget.project));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
      elevation: 0,
      color: Theme.of(context).backgroundColor,
      child: Container(
        padding: EdgeInsets.only(
          top: 5,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 5,
        ),
        child: _showForm(context),
      ),
    ));
  }

  Widget _showForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          CustomTextField(
            icon: Icons.person,
            hintText: "Enter user's name",
            labelText: 'Name',
            controller: _nameController,
            validator: (val) => val.isEmpty ? "User's name is required" : null,
          ),
          const SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: widget.userToModify == null
                ? const Text('Add User')
                : const Text('Edit User'),
            onPressed: _submitData,
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).textTheme.button.color,
          )
        ],
      ),
    );
  }
}