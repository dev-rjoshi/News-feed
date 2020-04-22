import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetails extends StatefulWidget {
  int index;
  Map<String, Object> meta = new LinkedHashMap();

  NewsDetails({Key key, @required this.index, @required this.meta}) : super(key: key);

  @override
  NewsDetailsState createState()=> NewsDetailsState(this.index, this.meta);
}

class NewsDetailsState extends State<NewsDetails>{
  int index;
  Map<String, Object> meta = new LinkedHashMap();

  NewsDetailsState(int num, Map<String, Object> resp){
    index = num;
    meta = resp;
    print("this is meta ##############");
    print(meta['author']);
    print(index);
  }

  //opens hyperlink in browser
  Future<void> _openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Error while opening feed");
    }
  }

  Widget getHyperLink(String url){
    return Container(height: MediaQuery.of(context).size.height / 10,
      padding: EdgeInsets.fromLTRB(20, 0, 15, 0),
      child: GestureDetector(
        onTap: ()=> _openFeed(url),
        child:  Text("$url", style: TextStyle(color: Colors.blue),),
      )
    );
  }

  Widget _viewFullDetails(String image, String author, String title, String description){
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height/3.5,
          width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new NetworkImage("$image"),
                  fit: BoxFit.fill,
                )
            )
        ),
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(20, 0, 15, 0),
          title: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              title: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      "$author",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Container(
                margin: EdgeInsets.only(top: 5),
                child: Container(
                  child: Text(
                    "$title",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
          subtitle: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    "$description",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 70.0,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 50,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text('Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
                _viewFullDetails(meta['urlToImage'],meta['author'], meta['title'], meta['description']),
                 Container(padding: EdgeInsets.fromLTRB(20,10,0,10),
                   child: Text("Full Article"),),
                 getHyperLink(meta['url'])
              ])),
        ],
      ),
    );
  }
}