import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tremor_track/screens/health_record_view.dart';

import '../constants/app_colors.dart';
import '../widgets/result.dart';
class ResultView extends StatelessWidget {
  final String result;
  final File? image;
  // late String lastResult;
  final String? audioPath;
  ResultView({required this.result,  this.image,this.audioPath}){
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: Color(0xFFF4FFFE),
          appBar: AppBar(
            title:  Row(children:[Text('Result'),
            ]),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                result=="Healthy"?
                Result(color: Color(0xFF458C55),image: 'assets/Green (1).png',title: "Parkinson's Disease Risk Reduction: Lifestyle Choices That Matter",advice: '1. Go Organic and Local: Avoid pesticides and herbicides, support local farmers.\n\n'
                    '2. Eat Fresh, Raw Vegetables: Increase intake of folic acid-rich veggies like broccoli.\n\n'
                    '3. Incorporate Omega-3 Fatty Acids: Include fish, eggs, and walnuts in your diet.\n\n'
                    '4. Vitamin D3: Maintain adequate levels through sunlight exposure or supplements.\n\n'
                    '5. Green Tea: Contains antioxidants that protect brain cells and sustain dopamine levels.\n\n'
                    '6. Regular Aerobic Exercise: Reduces brain inflammation and improves cognitive health.\n\n'
                    '7. CoQ10 Supplementation: Slows Parkinson\'s progression and prevents dopamine loss.\n\n'
                    '8. Reduce Stress: Manage physical, emotional, and chemical stress to prevent inflammation.',result: result,)
                    :Result(result:result , image: "assets/Red (1).png", title: "Keeping well", advice: "It's important to do what you can to stay physically and mentally healthy if you have Parkinson's disease.\n\n"
                    "Exercise and healthy eating\n"
                    "Regular exercise is particularly important in helping relieve muscle stiffness, improving your mood, and relieving stress.\n"
                    "There are many activities you can do to help keep yourself fit. If you're newly diagnosed or your symptoms are mild, you could try vigorous activities like team sports, cycling, and running.\n"
                    "If your symptoms are complex or progressing, you can try less strenuous activities such as walking, or simple stretching and strengthening exercises.\n"
                    "You should also try to eat a balanced diet containing all the food groups to give your body the nutrition it needs to stay healthy.", color: Colors.red),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: () {print(result);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HealthRecord(  ),
                      ),

                    );

                  },
                  child: Container(

                    width: MediaQuery.of(context).size.width - 240,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      border: Border.all(
                        color: Color(0xFF458C55), // Border color
                        width: 4, // Border width
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      "Health Record",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),

              ],
            ),
          )
      );

    }
  }


