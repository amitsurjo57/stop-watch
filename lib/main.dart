import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          headlineLarge: TextStyle(
            color: Colors.white,
          ),
          displayLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int hours = 0, minuit = 0, second = 0, milli = 0;

  String localHour = '00';
  String localMinuit = '00';
  String localSecond = '00';
  String localMilli = '00';

  String mainTimer = '00:00:00:00';

  bool watchIsStarted = false;

  Timer? timer;

  List<String> timerList = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[800],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Stopwatch app',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mainTimer,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 52),
            lapList(),
            const SizedBox(height: 52),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                startButton(),
                addLap(),
                resetButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container lapList() {
    return Container(
      width: 350,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: timerList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Lap ",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            Text(
              timerList[index],
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  MaterialButton startButton() {
    return MaterialButton(
      onPressed: watchIsStarted ? onPause : onStart,
      color: watchIsStarted ? Colors.yellow : Colors.green,
      child: watchIsStarted ? const Text('Pause') : const Text('Start'),
    );
  }

  MaterialButton addLap() {
    return MaterialButton(
      onPressed: onAddLap,
      color: Colors.white,
      child: const Text("Lap"),
    );
  }

  MaterialButton resetButton(BuildContext context) {
    return MaterialButton(
      onPressed: onReset,
      color: Colors.red,
      child: const Text('Reset'),
    );
  }

  void onStart() {
    timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (_) {
        setState(() {
          watchIsStarted = true;
          milli++;
          if (milli == 100) {
            second++;
            milli = 0;
          }
          if (second == 60) {
            minuit++;
            second = 0;
          }
          if (minuit == 60) {
            hours++;
            minuit = 0;
          }

          hours < 10 ? localHour = '0$hours' : localHour = '$hours';

          minuit < 10 ? localMinuit = '0$minuit' : localMinuit = '$minuit';

          second < 10 ? localSecond = '0$second' : localSecond = '$second';

          milli < 10 ? localMilli = "0$milli" : localMilli = '$milli';

          mainTimer = '$localHour:$localMinuit:$localSecond:$localMilli';
        });
      },
    );
  }

  void onPause() {
    setState(() {
      timer!.cancel();
      watchIsStarted = false;
    });
  }

  void onReset() {
    setState(() {
      timer!.cancel();
      timerList.clear();
      hours = 0;
      minuit = 0;
      second = 0;
      milli = 0;
      mainTimer = '00:00:00:00';
      watchIsStarted = false;
    });
  }

  void onAddLap() {
    setState(() {
      timerList.add(mainTimer);
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }
}
