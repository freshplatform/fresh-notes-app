import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/notes/universal/s_universal_notes.dart';
import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../utils/dialog/w_yes_cancel_dialog.dart';
import '../save_note/s_save_note.dart';
import 'models/m_navigation_item.dart';
import 'w_logout.dart';
import 'widgets/notes_list/w_notes_list.dart';
import 'widgets/w_about.dart';
import 'widgets/w_drawer.dart';
import 'widgets/w_settings.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _navigationItems = [
    NavigationItem(
      title: 'Manage notes',
      label: 'Notes',
      icon: const Icon(Icons.notes),
      body: const NotesListPage(),
      actionsBuilder: (context) {
        return [
          IconButton(
            tooltip: 'Toggle using grid item',
            onPressed: () {
              final settingsBloc = context.read<SettingsCubit>();
              settingsBloc.updateSettings(
                settingsBloc.state.copyWith(
                  useNoteGridItem: !settingsBloc.state.useNoteGridItem,
                ),
              );
            },
            icon: const Icon(Icons.list),
          ),
          const LogoutIconButton(),
          IconButton(
            tooltip: 'Delete All',
            onPressed: () async {
              final deletedAllConfirmed = await showYesCancelDialog(
                context: context,
                options: const YesOrCancelDialogOptions(
                  title: 'Delete all notes',
                  message:
                      'Are you sure you want to delete all of your notes??',
                  yesLabel: 'Delete all',
                ),
              );
              if (!deletedAllConfirmed) {
                return;
              }
              UniversalNotesService.getInstance().deleteAll();
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ];
      },
      actionButtonBuilder: (context) {
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              SaveNoteScreen.routeName,
              arguments: const SaveNoteScreenArgs(),
            );
          },
          child: const Icon(Icons.add),
        );
      },
    ),
    const NavigationItem(
      title: 'Change the settings',
      label: 'Settings',
      icon: Icon(Icons.settings),
      body: SettingsPage(),
    ),
    const NavigationItem(
      title: 'About the App',
      label: 'About',
      icon: Icon(Icons.info),
      body: AboutPage(),
    ),
  ];

  var _selectedNavItemIndex = 0;
  final _pageController = PageController();

  bool _isNavRailBar(Size size) {
    return size.width >= 480;
  }

  void _onDestinationSelected(int newPageIndex) {
    _pageController.jumpToPage(newPageIndex);
    setState(() => _selectedNavItemIndex = newPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    final actions =
        _navigationItems[_selectedNavItemIndex].actionsBuilder?.call(context);
    final actionButton = _navigationItems[_selectedNavItemIndex]
        .actionButtonBuilder
        ?.call(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _navigationItems[_selectedNavItemIndex].title,
        ),
        actions: actions,
      ),
      drawer: const DashboardDrawer(),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            final size = MediaQuery.sizeOf(context);
            final widget = PageView(
              controller: _pageController,
              children:
                  _navigationItems.map((e) => Center(child: e.body)).toList(),
              onPageChanged: (newPageIndex) {
                setState(() => _selectedNavItemIndex = newPageIndex);
              },
            );
            if (!_isNavRailBar(size)) {
              return widget;
            }
            return Row(
              children: [
                NavigationRail(
                  onDestinationSelected: _onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: _navigationItems.map((e) {
                    return NavigationRailDestination(
                      icon: e.icon,
                      label: Text(e.label),
                      selectedIcon: e.selectedIcon,
                      // tooltip: e.tooltip,
                      // key: ValueKey(e.label),
                    );
                  }).toList(),
                  selectedIndex: _selectedNavItemIndex,
                ),
                Expanded(
                  child: widget,
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton: actionButton,
      bottomNavigationBar: Builder(
        builder: (context) {
          final size = MediaQuery.sizeOf(context);
          if (_isNavRailBar(size)) {
            return const SizedBox.shrink();
          }
          return NavigationBar(
            selectedIndex: _selectedNavItemIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: _navigationItems.map((e) {
              return NavigationDestination(
                icon: e.icon,
                label: e.label,
                selectedIcon: e.selectedIcon,
                tooltip: e.tooltip,
                key: ValueKey(e.label),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
