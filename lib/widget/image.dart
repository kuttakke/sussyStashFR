import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheImageWidget extends StatelessWidget {
  final String imageUrl;
  
  final bool isCircle;

  const CacheImageWidget({super.key, required this.imageUrl, this.isCircle = false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: DefaultCacheManager().getSingleFile(imageUrl),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator(),),
          );
          // return const CircularProgressIndicator(); // 显示加载指示器
        } else if (snapshot.hasError) {
          return const Icon(Icons.error);
        } else {
          if (isCircle) {
            return CircleAvatar(backgroundImage: FileImage(snapshot.data!),minRadius: 20, maxRadius: 120,);
          }
          // debugPrint(snapshot.data!.path);
          if (snapshot.data!.path.endsWith(".svg")){
            return Image.asset("asset/audio-only.png", fit: BoxFit.cover,);
          }
          return Image.file(snapshot.data!, fit: BoxFit.cover); // 显示图片
        }
      },
    );
  }
}
