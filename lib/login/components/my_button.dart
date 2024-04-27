import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{

final Function()? onTap;

  const MyButton({super.key, required this.onTap,});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 66, 31, 126),
          borderRadius: BorderRadius.circular(70),
          ),
        child: Center(
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16
              ),
            ),
            ),
      ),
    );
  }
}