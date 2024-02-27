import 'package:flutter/material.dart';

class CurrentLocIcon extends StatefulWidget {
  const CurrentLocIcon({Key? key}) : super(key: key);

  @override
  State<CurrentLocIcon> createState() => _CurrentLocIconState();
}

class _CurrentLocIconState extends State<CurrentLocIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 1));
    sizeAnimation = Tween<double>(
      begin: 30,
      end: 50,
    ).animate(animationController);
    animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sizeAnimation,
      builder: (context,widget){    
    return Container(
        width: 80,
        height: 80,
        child: 
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
        width: sizeAnimation.value,
        height: sizeAnimation.value,
        decoration: BoxDecoration(color: Colors.green.withOpacity(0.3), shape: BoxShape.circle)
        ),
        Container(
        width: 50,
        height: 50,
        child: IconButton(
          icon: Image.asset(
            "images/icon/current_loc.png",
            width: 40,
            height: 40,
            color: Colors.green,
          ),
          onPressed: () {
            print("touched me");
          },
        ),
        )
        ],
        )
        );
      },
      
      );
  }
}
