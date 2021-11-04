import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unsplash_demo_one/model/photo_url.dart';
import 'package:unsplash_demo_one/screens/full_image_screen.dart';
import 'package:unsplash_demo_one/util/constants.dart';
import '../model/topic.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var selectedIndex = 0;
  late StreamController _streamController;
  late Stream _stream;

  late StreamController _streamControllerTopic;
  late Stream _streamTopic;

  Future getTopics() async {
    _streamControllerTopic.add('loading');
    var response = await http.get(Uri.parse(Constants.getTopicsUrl));
    if (response.statusCode == 200) {
      List jsonTopics = json.decode(response.body);

      List<Topic> topics = [];
      for (var jsonTopic in jsonTopics) {
        topics.add(Topic.fromJson(jsonTopic));
      }

      _streamControllerTopic.add(topics);
      getPhotos(topics[0].photos);
      return topics;
    } else {
      _streamControllerTopic.add('wrong');
    }
  }

  Future getPhotos(String topic) async {
    _streamController.add('loading');

    var response =
        await http.get(Uri.parse(Constants.getPhotosByTopicUrl(topic)));

    if (response.statusCode == 200) {
      List jsonPhotos = json.decode(response.body);

      List<PhotoUrl> photoUrls = [];
      for (var jsonPhoto in jsonPhotos) {
        photoUrls.add(PhotoUrl.fromJson(jsonPhoto['urls']));
      }

      _streamController.add(photoUrls);
    } else {
      _streamController.add('wrong');
    }
  }

  @override
  void initState() {
    _streamControllerTopic = StreamController();
    _streamTopic = _streamControllerTopic.stream;
    getTopics();
    _streamController = StreamController();
    _stream = _streamController.stream;
    _streamController.add('loading');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WallFu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trending',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: StreamBuilder(
                stream: _streamTopic,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == 'loading') {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data == 'wrong') {
                      return const Center(
                        child: Text('Something went wrong'),
                      );
                    } else {
                      List<Topic> topics = snapshot.data as List<Topic>;

                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: topics.length,
                          itemBuilder: (context, index) {
                            print('stream topic  executed');
                            Topic topic = topics[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  getPhotos(topic.photos);
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    topic.title,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: selectedIndex == index
                                            ? Colors.green
                                            : Colors.white),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Photos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  print('stream builder executed');
                  if (snapshot.hasData) {
                    if (snapshot.data == 'loading') {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data == 'wrong') {
                      return const Center(
                        child: Text('Something went wrong'),
                      );
                    } else {
                      List<PhotoUrl> photoUrls =
                          snapshot.data as List<PhotoUrl>;

                      return GridView.builder(
                          itemCount: photoUrls.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                                childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            PhotoUrl photoUrl = photoUrls[index];
                            return InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context){

                                  return FullImageScreen(photoUrl: photoUrl);
                                }));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          photoUrl.small,
                                        ))),
                              ),
                            );
                          });
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
