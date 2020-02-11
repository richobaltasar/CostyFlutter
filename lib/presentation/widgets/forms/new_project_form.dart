import 'package:costy/presentation/widgets/other/currency_dropdown_field.dart';
import 'package:costy/presentation/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc.dart';
import '../../bloc/currency_bloc.dart';
import '../../bloc/currency_state.dart';
import '../../bloc/project_bloc.dart';

class NewProjectForm extends StatefulWidget {
  @override
  _NewProjectFormState createState() => _NewProjectFormState();
}

class _NewProjectFormState extends State<NewProjectForm> {
  final _nameController = TextEditingController();
  var _defaultCurrency;

  final _formKey = GlobalKey<FormState>();

  void _submitData() {
    if (_formKey.currentState.validate()) {
      final enteredName = _nameController.text;

      BlocProvider.of<ProjectBloc>(context).add(AddProjectEvent(
          projectName: enteredName, defaultCurrency: _defaultCurrency));
      BlocProvider.of<ProjectBloc>(context).add(GetProjectsEvent());

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    BlocProvider.of<CurrencyBloc>(context).add(GetCurrenciesEvent());
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<CurrencyBloc, CurrencyState>(
          bloc: BlocProvider.of<CurrencyBloc>(context),
          builder: (context, state) {
            return Card(
              elevation: 0,
              color: Theme.of(context).backgroundColor,
              child: Container(
                padding: EdgeInsets.only(
                  top: 5,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 5,
                ),
                child: _buildForm(context, state),
              ),
            );
          }),
    );
  }

  Widget _buildForm(BuildContext context, CurrencyState state) {
    if (state is CurrencyLoaded) {
      return _showForm(context, state);
    } else {
      return new Container();
    }
  }

  Widget _showForm(BuildContext context, CurrencyLoaded state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          CustomTextField(
            icon: Icons.text_fields,
            hintText: 'Enter project name',
            labelText: 'Project name',
            controller: _nameController,
            validator: (val) => val.isEmpty ? 'Project name is required' : null,
          ),
          const SizedBox(
            height: 10,
          ),
          CurrencyDropdownField(
              currencies: state.currencies,
              label: 'Default currency',
              callback: (newValue) {
                setState(() {
                  _defaultCurrency = newValue;
                });
              }),
          const SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: const Text('Add Project'),
            onPressed: _submitData,
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).textTheme.button.color,
          )
        ],
      ),
    );
  }
}
