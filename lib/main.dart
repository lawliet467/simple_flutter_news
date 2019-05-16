import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MyApp());

final String apiAddr = 'http://v.juhe.cn/toutiao/index';
final String apiKey = 'fcb8734cadabdf19eda077b2b25f3b33';
final List tabs = [
  {'type': 'top', 'title': '头条'},
  {'type': 'shehui', 'title': '社会'},
  {'type': 'guonei', 'title': '国内'},
  {'type': 'guoji', 'title': '国际'},
  {'type': 'yule', 'title': '娱乐'},
  {'type': 'tiyu', 'title': '体育'},
  {'type': 'junshi', 'title': '军事'},
  {'type': 'keji', 'title': '科技'},
  {'type': 'caijing', 'title': '财经'},
  {'type': 'shishang', 'title': '时尚'},
];

class MyApp extends StatelessWidget {
  final String title = '头条新闻';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: title),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var tabController;

  List<Widget> buildTabs() {
    List<Widget> tabWidgets = [];
    for (var item in tabs) {
      Widget tab = Tab(text: item['title']);
      tabWidgets.add(tab);
    }
    return tabWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 10,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            bottom: TabBar(
                controller: this.tabController,
                isScrollable: true,
                tabs: buildTabs()),
          ),
          body: TabBarView(
            controller: this.tabController,
            children: tabs.map((item) {
                return NewsList(item['type']);
              }).toList()
          ),
        ));
  }
}

class NewsList extends StatefulWidget {
  final String type;
  NewsList(this.type);
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List newsList = [];
  void getNews() async {
    try {
      print(widget.type);
    Response response = await Dio().get(apiAddr, queryParameters: {'type': widget.type, 'key': apiKey});

      var data = response.data['result']['data'];
//      var data = [
//        {
//          'uniquekey': '567eef80fde173c0b55fa0418936dccc',
//          'title': '益阳市公路建设养护中心举办健康知识讲座',
//          'date': '2019-05-15 15:04',
//          'category': '国内',
//          'author_name': '红网益阳站',
//          'url': 'http://mini.eastday.com/mobile/190515150416695.html',
//          'thumbnail_pic_s':
//          'http://01imgmini.eastday.com/mobile/20190515/20190515150416_3c52d7075d83b8e0f3918acf6277823d_1_mwpm_03200403.jpg',
//          'thumbnail_pic_s02':
//          'http://01imgmini.eastday.com/mobile/20190515/20190515150416_3c52d7075d83b8e0f3918acf6277823d_2_mwpm_03200403.jpg'
//        }
//      ];
      setState(() {
        this.newsList = data;
      });
      print(this.newsList);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.newsList.length,
      itemBuilder: (context, index) {
        var newsItem = this.newsList[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(newsItem['thumbnail_pic_s']),
          ),
          title: Text(newsItem['title']),
          subtitle: Text(newsItem['date']),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebviewScaffold(
                      url: '${newsItem['url']}',
                      appBar:
                      AppBar(title: Text(newsItem['title'])),
                    )
                )
              );
          },
        );
      }
    );
  }
}




