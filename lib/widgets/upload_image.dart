import 'package:flutter/material.dart';


class UploadImagec extends StatelessWidget {
  const UploadImagec({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
          children: [
            const SizedBox(height: 60,),
            Image.asset(('assets/download.png'),width: 50,),
            const SizedBox(height: 10,),
            const Text("Select image",style: TextStyle(fontSize: 15,color: Colors.grey,),)
          ],
        );
  }
}