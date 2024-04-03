import 'package:flutter/material.dart';
import '../page/streamers.dart';
import '../src/rust/api/streamer_model.dart';

class CategoryWidget extends StatelessWidget {
  final StreamerType type;
  final String image;

  const CategoryWidget({super.key, required this.type, required this.image});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StreamersPage(category: type,))),
      child : SizedBox(
        height: 200,
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                  left: 16,
                  bottom: 16,
                  child: Text(
                    type.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ))
            ],
          ),
        )));
  }
}
