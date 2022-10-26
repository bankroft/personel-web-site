import 'package:bk_app/widgets/mcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:html/parser.dart" show parse;

import '../services/httprequestservice.dart';
import 'weibo_webview.dart';

class HotSearch extends StatefulWidget {
  const HotSearch({Key? key}) : super(key: key);

  @override
  State<HotSearch> createState() => _HotSearchState();
}

class _HotSearchState extends State<HotSearch> {
  final List<_HotSearchDataItem> _data = [];
  @override
  void initState() {
    super.initState();
    _getHotSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.modules_weibo_desp),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async => _getHotSearch(),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return MCard(
            child: ListTile(
              leading: Text("${_data[index].rank}"),
              title: Text(_data[index].title),
              subtitle: Text(_data[index].number.toString()),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _openUrl(_data[index].url, _data[index].title),
            ),
          );
        },
        itemCount: _data.length,
      ),
    );
  }

  Future<void> _getHotSearch() async {
    _data.clear();
    final data = await HTTPRequestService()
        .get(url: "https://s.weibo.com/top/summary?cate=realtimehot");
    final html = parse(data.data);
    final test = html.querySelectorAll("td.td-01.ranktop");
    for (var element in test) {
      if (element.parent == null) {
        continue;
      }
      final rank = int.tryParse(element.text);
      if (rank == null) {
        continue;
      }
      _data.add(_HotSearchDataItem(
        rank: rank,
        title: element.parent!.getElementsByTagName("a")[0].text,
        url:
            "https://s.weibo.com${element.parent!.getElementsByTagName("a")[0].attributes["href"]}",
        number: element.parent!.getElementsByTagName("span")[0].text,
      ));
    }
    setState(() {});
  }

  _openUrl(String url, String title) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => WeiboWebView(
                  url: url,
                  title: title,
                )));
  }
}

class _HotSearchDataItem {
  _HotSearchDataItem({
    required this.rank,
    required this.title,
    required this.url,
    required this.number,
  });
  int rank;
  String title;
  String url;
  String number;
}
