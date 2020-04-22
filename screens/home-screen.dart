import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsmania/screens/news_details.dart';
import 'package:newsmania/utils/news_util.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Map<String, Object> seededData = new LinkedHashMap();
  List<dynamic> articles = new List();
  Map<String, Object> articleMeta = new LinkedHashMap();
  NewsUtil newsRepo = new NewsUtil();

  _getLatestNews() async {
    print("latest news method");
    seededData = await newsRepo.getNews();
    articles = seededData['articles'];
  }

  _showDialog(){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Unavailable"),
            content: Text("Coming Soon....."),
          );
        }
    );
  }


  Widget _getListView(String author, String title, String date, int index, Map<String, Object> map, String image) {
    String one = '';
    String time = date.substring(0, 10);
    if (title.length >= 20) {
      one = title.substring(0, 20);
    }
    return Container(
        child: Column(children: <Widget>[
      Container(
          child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 10),
              leading: image != null
                  ? new CircleAvatar(
                radius: 30,
                      backgroundImage: new NetworkImage('$image'),
                    )
                  : new CircleAvatar(
                  radius: 30,
                      backgroundImage: new NetworkImage(
                          "https://s3.cointelegraph.com/storage/uploads/view/30ce0426f94941bda9a136c8a5389034.jpg")),
              title: Text(
                "$author",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor * 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              subtitle: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "$one....",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 16,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Icon(
                              Icons.date_range,
                              size: 15,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            "$time",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      height: MediaQuery.of(context).size.height / 20,
                      width: MediaQuery.of(context).size.width / 5,
                      child: GestureDetector(
                        onTap: () {
                          //_openFeed(url);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewsDetails(
                                        meta: map,
                                        index: index,
                                      )));
                        },
                        child: Text(
                          "more >>",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ))
          )
      )
    ]));
  }

  // Drawer: username and emailId are static for now
  Widget _getSideNavMeta(String name, String emailId) {
    return Column(
      children: <Widget>[
        new UserAccountsDrawerHeader(
          accountName: new Text("Welcome :  $name"),
          accountEmail: new Text("$emailId"),
          currentAccountPicture: new CircleAvatar(
            backgroundImage: new NetworkImage('http://i.pravatar.cc/300'),
          ),
        ),
        Container(
          child: GestureDetector(
            onTap: () {
              _getLatestNews();
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text(
                "Home",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black))),
        ),
        Container(
          child: GestureDetector(
            onTap: () {
              print("Inside Cat");
              Navigator.pop(context);
              _showDialog();
              //Navigator.pop(context);
            },
            child: ListTile(
              title: Text(
                "Categories",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _getLatestNews(),
        // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              return Scaffold(
                drawer: new Drawer(
                    child: _getSideNavMeta("Ramit", "r.joshi.2610@gmail.com")),
                body: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      expandedHeight: 70.0,
                      floating: true,
                      backgroundColor: Colors.blue,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text('News Feed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            )),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Container(
                          child: Container(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: ListView.separated(
                            itemCount: articles.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, i) {
                              articleMeta = articles[i];
                              if (articleMeta['author'] == null) {
                                articleMeta['author'] = 'Unknown author';
                              }
                              return _getListView(
                                  articleMeta['author'],
                                  articleMeta['title'],
                                  articleMeta['publishedAt'],
                                  i,
                                  articleMeta,
                                  articleMeta['urlToImage']);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider();
                            }),
                      )),
                    ])),
                  ],
                ),
              );
            }
          }
        });
  }
}
