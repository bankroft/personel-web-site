import 'package:bk_app/modules/modules.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8.0),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemBuilder: _itemBuilder,
      separatorBuilder: (_, __) => const Divider(),
      itemCount: allmodulesList.length,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: allmodulesList[index].icon != null
            ? Image.asset(
                allmodulesList[index].icon!,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.no_accounts_outlined),
              )
            : const Icon(Icons.no_accounts_outlined),
      ),
      title: Text(allmodulesList[index].name()),
      subtitle: allmodulesList[index].description != null
          ? Text(allmodulesList[index].description!())
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pushNamed(context, allmodulesList[index].route);
      },
    );
  }
}
