// import 'dart:html';

// import 'package:dio/dio.dart' as dio;
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:async/async.dart';

// import 'package:http_parser/http_parser.dart';
// import 'package:persian_number_utility/src/extensions.dart';

// import 'Detail.dart';
// import 'package:flutter/material.dart';
// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:video_player/video_player.dart';
// import 'package:image_picker/image_picker.dart';

// class TestImage extends StatefulWidget {
//   @override
//   _TestImageState createState() => _TestImageState();
// }

// class _TestImageState extends State<TestImage> {
//   List multiImageLis = [];
//   dio.Dio _dio = dio.Dio();
//   XFile? imageProfile;

//   Future<void> get_MultiImage() async {
//     final ImagePicker _picker = ImagePicker();

//     imageProfile = await _picker.pickImage(source: ImageSource.gallery);
//   }

//   Future<void> uploadImage(XFile? file) async {
//     String fileNameProfile = file!.path.split('/').last as String;

//     var byte = await file.readAsBytes() as List<int>;

//     print(fileNameProfile);

//     MultipartFile multipartFile = await MultipartFile.fromBytes(byte,
//         filename: fileNameProfile.toEnglishDigit(),
//         contentType: MediaType("image", "png"));

//     dio.FormData formdata =
//         dio.FormData.fromMap({"image": multipartFile, "user": 14});

//     print(formdata.files);

//     print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
//     var response = await _dio.post("$host/api/TestImage/", data: formdata);

//     print('jjjjjjjjjjjjjjjjjjjjj');
//     print(response.statusCode);
//   }

//   // Future<void> gettttttt(Asset pathFile) async {
//   //   //create multipart request for POST or PATCH method
//   //   var request =
//   //       await http.MultipartRequest("POST", Uri.parse("$host/api/TestImage/"));
//   //   print(request.fields);

//   //   ByteData bytedata = await pathFile.getByteData();
//   //   List<int> imageData = bytedata.buffer.asUint8List();
//   //   //add text fields
//   //   request.fields["name"] = 'hiiiii';
//   //   //create multipart using filepath, string or bytes

//   //   http.MultipartFile pic = http.MultipartFile.fromBytes('icon', imageData,
//   //       filename: pathFile.name, contentType: MediaType("image", "jpeg"));

//   //   print('----------------------------------------------');
//   //   print(pic);
//   //   print('###################################');

//   //   // //add multipart to request
//   //   await request.send().then((response) {
//   //     if (response.statusCode != 200) print(response.statusCode);
//   //   });

//   //   print('hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');

//   //   // // //Get the response from the server
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         GestureDetector(
//           child: Container(width: 100, height: 100, color: Colors.red),
//           onTap: () => get_MultiImage(),
//         ),
//         GestureDetector(
//             child: Container(width: 100, height: 100, color: Colors.blue),
//             onTap: () {
//               uploadImage(imageProfile);
//             }),
//       ],
//     ));
//   }
// }

// class SamplePlayer extends StatefulWidget {
//   @override
//   _SamplePlayerState createState() => _SamplePlayerState();
// }

// class _SamplePlayerState extends State<SamplePlayer> {
//   late FlickManager flickManager;
//   @override
//   void initState() {
//     super.initState();
//     flickManager = FlickManager(
//       videoPlayerController: VideoPlayerController.network(
//           "https://varnaboum.com/media/Trailer/81e5ea1c14f0a9e5164bde02b1898d0e38322858-144p.mp4"),
//     );
//   }

//   @override
//   void dispose() {
//     flickManager.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: FlickVideoPlayer(flickManager: flickManager),
//       ),
//     );
//   }
// }
