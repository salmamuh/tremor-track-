import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
class Result extends StatelessWidget {
  const Result({
    super.key,required this.result,required this.image,required this.title,required this.advice,required this.color
  });
  final String result;
final String image;
final Color color;
final String title;
final String advice;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        Text(result,style: TextStyle(color: color,fontWeight: FontWeight.bold,fontSize: 25),)
        ,Container(
          width: 160,
          child: Image.asset(image),

        ),
        const SizedBox(height: 25,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.mainColor,
            ),

          ),
        ),
        Center(
          child: Container(
              width :390,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  border: Border.all(
                    color:AppColors.mainColor, // Border color
                    width: 3.5, // Border width
                  ),
                  borderRadius: BorderRadius.circular(25)
              ),
              child:Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(advice

                  ,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500),),
              )
          ),
        ),

      ],
      ),
    );
  }
}