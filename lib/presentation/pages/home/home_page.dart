import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:tody_app/bloc/user/user_notifier.dart';
import 'package:tody_app/core/constants/routes.dart';
import 'package:tody_app/core/theme/theme_ext.dart';
import 'package:tody_app/features/category/presentation/bloc/category_list/category_list_bloc.dart';
import 'package:tody_app/features/category/presentation/views/user_category_list.dart';
import 'package:tody_app/presentation/dialogs/list_creation/list_creation_dialog.dart';
import 'package:tody_app/presentation/pages/home/widgets/static_category_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserNotifier>().user;

    return BlocProvider(
      create: (context) => GetIt.instance.get<CategoryListBloc>()
        ..add(
          CategoryListRequested(),
        ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: context.colors.surface,
            body: SafeArea(
              child: Column(
                children: [
                  Column(
                    children: [
                      if (user != null)
                        ListTile(
                          contentPadding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            right: 10,
                            left: 20,
                          ),
                          leading: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                Routes.settings.path,
                                arguments: context.read<UserNotifier>(),
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: context.colors.primary,
                              child: Text(
                                user.avatarLabel ?? 'N/A',
                                style: context.typography.bodyMedium,
                              ),
                            ),
                          ),
                          title: Text(
                            user.fullName,
                            style: context.typography.titleMedium,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                            color: context.colors.primary,
                          ),
                        ),
                      StaticCategoryItem(
                        prefix: Icon(
                          Icons.star_rate,
                          color: context.colors.error,
                        ),
                        title: AppLocalizations.of(context).important,
                        onTap: () {},
                      ),
                      StaticCategoryItem(
                        prefix: Icon(
                          Icons.house_siding,
                          color: context.colors.primary,
                        ),
                        title: AppLocalizations.of(context).tasks,
                      ),
                    ],
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  const UserCategoryList(),
                  InkWell(
                    onTap: () {
                      ListCreationDialog.show(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 32,
                        top: 10,
                        bottom: 10,
                        right: 36,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: context.colors.primary,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'New List',
                            style: context.typography.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
