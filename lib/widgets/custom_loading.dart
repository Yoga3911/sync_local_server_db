import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _spinkit = SpinKitCubeGrid(
      itemBuilder: (BuildContext context, int index) => DecoratedBox(
        decoration:
            BoxDecoration(color: index.isEven ? const Color(0xFF9d39ff) : const Color(0xFF28c8fd)),
      ),
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: _size.height * 0.2,
          height: _size.height * 0.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _spinkit,
              const Text(
                "Loading ...",
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
        )
      ],
    );
  }
}