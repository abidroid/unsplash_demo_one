import 'dart:io';

import 'package:flutter/material.dart';
import 'package:unsplash_demo_one/model/photo_url.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class FullImageScreen extends StatefulWidget {
  final PhotoUrl photoUrl;

  const FullImageScreen({Key? key, required this.photoUrl}) : super(key: key);

  @override
  _FullImageScreenState createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              widget.photoUrl.full,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Row(
              mainAxisAlignment: Platform.isAndroid ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {

                    // show progress dialog
                     var response = await GallerySaver.saveImage(widget.photoUrl.full + '.jpg');


                     if( response == true){
                       print('Downloaded');
                     }else{
                       print('Failed');
                     }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                ),

                Visibility(
                  visible: Platform.isAndroid,
                  child: OutlinedButton.icon(

                    onPressed: () async {

                      if( Platform.isAndroid){

                        File cachedimage = (await DefaultCacheManager().getSingleFile(widget.photoUrl.full));  //image file

                        int location = WallpaperManagerFlutter.HOME_SCREEN;  //Choose screen type

                        WallpaperManagerFlutter().setwallpaperfromFile(cachedimage, location);   // Wrap with try catch for error management.


                      }

                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Set as Wallpaper'),
                  ),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }
}
