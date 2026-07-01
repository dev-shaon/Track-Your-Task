import 'package:flutter/material.dart';

class TimerFinishedDialog extends StatelessWidget {
  const TimerFinishedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF013220),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset(
            //   Assets.images.conratulationGif.path,
            //   height: 140,
            //   fit: BoxFit.contain,
            // ),

            const Icon(
              Icons.timer_off,
              size: 60,
              color: Colors.greenAccent,
            ),

            const SizedBox(height: 15),

            const Text(
              "Time's Up!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Your timer has finished.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        ),
      ),
    );
  }
}