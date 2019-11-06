import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yoga_guru/inference.dart';
import 'package:yoga_guru/yoga_card.dart';

class Poses extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;
  final List<String> asanas;
  final Color color;

  const Poses({this.cameras, this.title, this.model, this.asanas, this.color});
  @override
  PosesState createState()=>new PosesState();
}
class PosesState extends State<Poses> {
  int groupvalue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 500,
              child: Swiper(
                itemCount: 3,
                loop: false,
                viewportFraction: 0.8,
                scale: 0.82,
                outer: true,
                onTap: (index) => _onSelect(context, widget.asanas[index]),
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Container(
                      height: 360,
                      child: YogaCard(
                        asana: widget.asanas[index],
                        color: widget.color,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              color: widget.color,
              height: 100,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Text("Which camera to use?", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 0,
                        groupValue: groupvalue,
                        onChanged: (int c)=>radioButtonChanges(c),
                        activeColor: Colors.black,
                      ),
                      Text("Back Camera",style: TextStyle(fontSize: 20),),
                      SizedBox(width: 20,),
                      Radio(
                        value: 1,
                        groupValue: groupvalue,
                        onChanged: (int c)=>radioButtonChanges(c),
                        activeColor: Colors.black,
                      ),
                      Text("Front Camera",style: TextStyle(fontSize: 20),),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onSelect(BuildContext context, String customModelName) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InferencePage(
          cameras: widget.cameras,
          title: customModelName,
          model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
          customModel: customModelName,
          cameraType: groupvalue,
        ),
      ),
    );
  }
  void radioButtonChanges(int c){
  setState((){
    if(c==0){
      groupvalue=0;
    }
    else{
      groupvalue=1;
    }
  });
}
}

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:yoga_guru/inference.dart';
// import 'package:yoga_guru/yoga_card.dart';
// import 'package:tflite/tflite.dart';
// import 'package:yoga_guru/bndbox.dart';
// import 'package:yoga_guru/camera.dart';
// import 'dart:math' as math;

// class Poses extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   final String title;
//   final String model;
//   final List<String> asanas;
//   final Color color;

//   const Poses({this.cameras, this.title, this.model, this.asanas, this.color});
//   @override
//   PosesState createState()=>new PosesState();
// }
// class PosesState extends State<Poses>{
//     List<dynamic> _recognitions;
//   int _imageHeight = 0;
//   int _imageWidth = 0;
// String _model = "", _customModel="";
//   loadModel() async {
//     String res;
//     res = await Tflite.loadModel(
//         // model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
//         // model: "assets/model.tflite");
//         model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite");
//     print(res);
//   }

//   onSelect(model,customModel) {
//     setState(() {
//       _model = model;
//       _customModel=customModel;
//     });
//     loadModel();
//   }

//   setRecognitions(recognitions, imageHeight, imageWidth) {
//     setState(() {
//       _recognitions = recognitions;
//       _imageHeight = imageHeight;
//       _imageWidth = imageWidth;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//         Size screen = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.grey[900],
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         centerTitle: true,
//         title: Text(widget.title),
//       ),
//       body: _model == ""?
//       Center(
//         child: Container(
//           height: 500,
//           child: Swiper(
//             itemCount: widget.asanas.length,
//             loop: false,
//             viewportFraction: 0.8,
//             scale: 0.82,
//             outer: true,
//             pagination: SwiperPagination(
//               alignment: Alignment.bottomCenter,
//               margin: EdgeInsets.all(32.0),
//             ),
//             onTap: (index) => onSelect("posenet", widget.asanas[index]),
//             itemBuilder: (BuildContext context, int index) {
//               return Center(
//                 child: Container(
//                   height: 360,
//                   child: YogaCard(
//                     asana: widget.asanas[index],
//                     color: widget.color,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ):
//       Stack(
//         children: <Widget>[
//           Camera(
//             cameras: widget.cameras,
//             setRecognitions: setRecognitions,
//           ),
//           BndBox(
//             results: _recognitions == null ? [] : _recognitions,
//             previewH: math.max(_imageHeight, _imageWidth),
//             previewW: math.min(_imageHeight, _imageWidth),
//             screenH: screen.height,
//             screenW: screen.width,
//             customModel: _customModel,
//           )
//         ]
//     ));
//   }

//   void _onSelect(BuildContext context, String customModelName) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => InferencePage(
//           cameras: widget.cameras,
//           title: customModelName,
//           model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
//           customModel: customModelName,
//         ),
//       ),
//     );
//   }
// }
