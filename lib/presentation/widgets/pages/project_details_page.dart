import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/forms/new_expense_form.dart';
import 'package:costy/presentation/widgets/pages/user_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../forms/new_user_form.dart';
import 'expenses_list_page.dart';
import 'report_page.dart';

class ProjectDetailsPage extends StatefulWidget {
  static navigate(BuildContext buildContext, Project project) {
    Navigator.of(buildContext).push(platformPageRoute(
      context: buildContext,
      builder: (BuildContext context) => ProjectDetailsPage(project: project),
    ));
  }

  final Project project;

  ProjectDetailsPage({Key key, this.project}) : super(key: key);

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage>
    with SingleTickerProviderStateMixin {
  PlatformTabController _tabController;

  final items = (BuildContext context) => [
        BottomNavigationBarItem(
          title: Text(AppLocalizations.of(context)
              .translate('project_details_page_users')),
          icon: Icon(context.platformIcons.group),
        ),
        BottomNavigationBarItem(
          title: Text(AppLocalizations.of(context)
              .translate('project_details_page_expenses')),
          icon: Icon(context.platformIcons.shoppingCart),
        ),
        BottomNavigationBarItem(
          title: Text(AppLocalizations.of(context)
              .translate('project_details_page_report')),
          icon: Icon(context.platformIcons.mail),
        ),
      ];

  @override
  void initState() {
    _tabController = PlatformTabController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddUserForm(BuildContext ctx, Project project) {
    showPlatformModalSheet(
      context: ctx,
      builder: (_) {
        return NewUserForm(project: project);
      },
    );
  }

  void _showAddExpenseForm(BuildContext ctx, Project project) {
    showPlatformModalSheet(
      context: ctx,
      builder: (_) {
        return NewExpenseForm(project: project);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildProjectDetailsPage(widget.project, context);
  }

  Widget buildProjectDetailsPage(Project project, BuildContext context) {
    return PlatformTabScaffold(
      iosContentPadding: true,
      tabController: _tabController,
      appBarBuilder: (_, index) => PlatformAppBar(
        title: Text(project.name),
        trailingActions: _actionButtons(project, context, index),
        ios: (_) => CupertinoNavigationBarData(
            title: items(context)[index].title,
            leading: CupertinoNavigationBarBackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
            automaticallyImplyLeading: true),
      ),
      bodyBuilder: (context, index) => _body(project, context, index),
      items: items(context),
    );
  }

  List<Widget> _actionButtons(Project project, BuildContext ctx, int index) {
    switch (index) {
      case 0:
        return [
          PlatformIconButton(
            onPressed: () => _showAddUserForm(ctx, project),
            icon: Icon(context.platformIcons.personAdd),
          )
        ];
      case 1:
        return [
          PlatformIconButton(
            onPressed: () => _showAddExpenseForm(ctx, project),
            icon: Icon(context.platformIcons.add),
          )
        ];
      case 2:
        return [
          PlatformIconButton(
            onPressed: () => _shareReport(ctx, project),
            icon: Icon(context.platformIcons.share),
          )
        ];
      default:
        return null;
    }
  }

  Widget _body(Project project, BuildContext ctx, int index) {
    switch (index) {
      case 0:
        return Center(child: UserListPage(project: project));
      case 1:
        return Center(child: ExpensesListPage(project: project));
      case 2:
        return Center(child: ReportPage(project: project));
      default:
        return null;
    }
  }

  _shareReport(BuildContext ctx, Project project) {
    BlocProvider.of<ReportBloc>(context).add(ShareReportEvent(project, ctx));
    BlocProvider.of<ReportBloc>(context).add(GetReportEvent(project));
  }
}
