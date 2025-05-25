
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tremor_track/constants/app_colors.dart'; // Adjust the import to your actual path

class HealthRecord extends StatefulWidget {
  final String? rId;

  const HealthRecord({Key? key, this.rId}) : super(key: key);

  @override
  State<HealthRecord> createState() => _HealthRecordState();
}

class _HealthRecordState extends State<HealthRecord> {

  List<dynamic>? _testData;
  late AudioPlayer audioPlayer;
  final User? user = FirebaseAuth.instance.currentUser;
  String? userId;
  int? currentlyPlayingIndex;


  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    if(widget.rId != null){userId = widget?.rId;}
    else
    userId = user?.uid;
    _loadTestData();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadTestData() async {
    try {
      // Fetch the user's data from Firestore
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      // Get the 'tests' array from the user's data
      List<dynamic> tests = userData.get('tests');

      setState(() {
        _testData = tests;
      });
    } catch (e) {
      print('Error fetching test data: $e');
    }
  }

  Future<void> playAudio(String audioUrl) async {
    await audioPlayer.play(UrlSource(audioUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4FFFE),
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Container(
          width: 40,
          child: Image.asset('assets/logo.png'),
        ),
        centerTitle: true,
      ),
      body: _testData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Text(
              "Health Record",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              child: Row(
                children: [
                  Text("Test"),
                  Spacer(flex: 2),
                  Text("Case"),
                  Spacer(flex: 1),
                  Text("Date"),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _testData!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.0),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                if (_testData![index]["image_url"] != null)
                          GestureDetector(
                          onTap: () {
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                    return Dialog(
                    child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                    image: DecorationImage(
                    image: NetworkImage(_testData![index]["image_url"]),
                    fit: BoxFit.cover,
                    ),
                    ),
                    ),
                    );
                    },
                    );
                    },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.mainColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          _testData![index]["image_url"],
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,),),)
,
                                if (_testData![index]["audio_url"] != null)
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(25),
                                          onTap: () {
                                            setState(() {
                                              if (currentlyPlayingIndex == index) {
                                                currentlyPlayingIndex = null;
                                              } else {
                                                currentlyPlayingIndex = index;
                                              }
                                            });

                                              // Code to play audio
                                              playAudio(_testData![index]["audio_url"]);

                                          },


                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              currentlyPlayingIndex == index ? Icons.stop : Icons.play_arrow,
                                              color: Colors.white,
                                            ),


                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                Spacer(flex: 3),
                                Text(_testData![index]["result"]),
                                Spacer(flex: 1),
                                Text(_testData![index]["date_time"].substring(0, 11)),
                              ],
                            ),],),),),);},),),
          ],
        ),
      ),
    );
  }
}


// class HealthRecord extends StatefulWidget {
//   final List<dynamic>? record;
//   final File? image;
//   final String? audioPath;
//
//    HealthRecord({Key? key, required this.record,  this.image,this.audioPath}) : super(key: key);
//   @override
//
//
//   State<HealthRecord> createState() => _HealthRecordState();
// }
//
// class _HealthRecordState extends State<HealthRecord> {
//   @override
//   late AudioPlayer audioPlayer;
//   void initState() {
//     super.initState();
//     audioPlayer = AudioPlayer();
//
//   }
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }
//
//   void playAudio() async {
//     final urlSource = UrlSource(widget.audioPath!);
//     await audioPlayer.play(urlSource);
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlue[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white70,
//         title: Container(
//           width: 40,
//           child: Image.asset('assets/logo.png'),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Column(
//           children: [
//             Text(
//               "Health Record",
//               style: TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.mainColor,
//               ),
//             ),
//             Padding(
//
//                   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
//
//                   child: Row(
//                 children: [
//                   Text("Test"),
//                   Spacer(flex: 2),
//                   Text("Case"),
//                   Spacer(flex: 1),
//                   Text("Date"),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: widget.record!.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 7.0),
//                     child: Container(
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 if (widget.image != null)
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: AppColors.mainColor,
//                                         width: 2,
//                                       ),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Image.file(
//                                       widget.image!,
//                                       width: 70,
//                                       height: 70,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 if (widget.audioPath != null)
//                                   Padding(
//                                     padding: const EdgeInsets.all(15),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.grey, // Button color
//                                       ),
//                                       child: Material(
//                                         color: Colors.transparent,
//                                         child: InkWell(
//                                           borderRadius: BorderRadius.circular(25),
//                                           onTap: playAudio, // Your playAudio function
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Icon(
//                                               Icons.play_arrow,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 Spacer(flex: 3),
//                                 Text(widget.record![index]["result"]),
//                                 Spacer(flex: 1),
//                                 Text(widget.record![index]["date_time"].substring(0, 11)),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//


// class HealthRecord extends StatefulWidget {
//   final List<Map>? record;
//   final File? image;
//   const HealthRecord({super.key,required this.record,required this.image,});
//
//   @override
//   State<HealthRecord> createState() => _HealthRecordState();
// }
//
// class _HealthRecordState extends State<HealthRecord> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightBlue[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white70,
//
//         title: Container(
//           width: 40,
//           child: Image.asset('assets/logo.png'),
//         ),
//         centerTitle: true, // like this!
//       ),
//       body:Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Health Record",
//               style: TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.mainColor,
//               ),
//             ),
//             Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(children: [
//
//               Text("Test"),
//               Spacer(flex: 2,),
//               Text("Case"),
//               Spacer(flex: 1,),
//               Text("Date"),
//
//             ]
//             ),
//           ),
//             Container(
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//
//               ),
//
//               child:Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Row(
//                 children: [
//
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: AppColors.mainColor, // Border color
//                             width: 2, // Border width
//                           ),
//                           borderRadius: BorderRadius.circular(8), // Border radius
//                         ),
//                         child: Image.file(
//                           widget.image!, // Adjust the fit as needed
//                           width: 70,
//                           height: 70,
//                           fit: BoxFit.cover,
//                         ),
//                       ),Spacer(flex: 3,),
//                   Text(widget.record?["result"]),
//                   Spacer(flex: 1,),
//                   Text(widget.record?["date_time"].substring(0, 11))
//                 ],
//                             ),
//               ),
//         ),],),
//       )
//     );
//   }
// }
