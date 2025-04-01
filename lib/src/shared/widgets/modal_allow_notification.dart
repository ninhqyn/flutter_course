import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class ModalAllowNotification extends StatelessWidget{
  const ModalAllowNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8)
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/images/notification.png',
            width: MediaQuery.of(context).size.width/3,
            height: MediaQuery.of(context).size.width/3,
            fit: BoxFit.fill,),
          const Text('App would like to send you notifications.',style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold
          ),),
          const Text('Notification may include alerts, sounds, and icon badges. These'
              ' can be configured in Settings',textAlign: TextAlign.center,style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400
          ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){
            },style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6)
              )
            ),
              child: const Text('Allow'
                ,textAlign: TextAlign.center,
                style: TextStyle(
                color: Colors.white,
                fontSize:17,
                fontWeight: FontWeight.bold
              ),),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){
              },style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: const BorderSide(
                      width: 1
                    )
                )
            ),
              child: const Text('Allow'
                ,textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize:17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
            ),
          ),
        ],
      ),
    );
  }

}