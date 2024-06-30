import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/gradient_text.dart';
import 'package:intl/intl.dart';
import 'components/gradient_icon.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelompok 5',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tugas Kelompok 5'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _temperature = 0.0;
  int _humidity = 0;
  double _wind = 0.0;
  double _visibility = 0.0;
  String _date = DateFormat('d MMMM yyyy').format(DateTime.now());
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future<void> _fetchWeather() async {
    const apiKey = 'fdf45a6d4c3f2e02080743c8bd2743cf';
    const city = 'Depok';
    const countryCode = 'ID';
    const apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city,$countryCode&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = data['main']['temp'];
          _humidity = data['main']['humidity'];
          _wind = data['wind']['speed'];
          _visibility = data['visibility'] / 1000;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFF86a9e6),
                Color(0xFF6072d9),
              ],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            child: Text(_date),
                          ),
                          const SizedBox(height: 8.0),
                          const DefaultTextStyle(
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              child: Text('Depok, Indonesia'))
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 64.0),
                  Column(
                    children: [
                      DefaultTextStyle(
                        style: const TextStyle(),
                        child: GradientText(
                          '$_temperature°',
                          style: const TextStyle(
                              fontSize: 164,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -8),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFe1e8f7),
                              Color(0xFF768fe0),
                            ],
                            begin:
                                Alignment.topCenter, // Vertical gradient start
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Transform(
                        transform: Matrix4.translationValues(0, -110, 0),
                        child: Image.asset(
                          'assets/images/cloud.png',
                          width: 250, // Set the width of the image
                          height: 250,
                        ),
                      ) // Add some space between text and image
                      ,
                      Transform(
                        transform: Matrix4.translationValues(0, -110, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: -10,
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Card(
                            color: Colors.white,
                            shadowColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const RadiantGradientMask(
                                        child: Icon(
                                          CupertinoIcons.wind,
                                          size: 30.0,
                                          color: Color(0xFF91ace6),
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      DefaultTextStyle(
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          child: Text('$_wind km/h')),
                                      const SizedBox(height: 4.0),
                                      const DefaultTextStyle(
                                          style: TextStyle(fontSize: 14),
                                          child: Text('Wind'))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const RadiantGradientMask(
                                        child: Icon(
                                          CupertinoIcons.drop,
                                          size: 30.0,
                                          color: Color(0xFF91ace6),
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      DefaultTextStyle(
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          child: Text('$_humidity%')),
                                      const SizedBox(height: 4.0),
                                      const DefaultTextStyle(
                                          style: TextStyle(fontSize: 14),
                                          child: Text('Humidity'))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const RadiantGradientMask(
                                        child: Icon(
                                          CupertinoIcons.eye,
                                          size: 30.0,
                                          color: Color(0xFF91ace6),
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      DefaultTextStyle(
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          child: Text('$_visibility km')),
                                      const SizedBox(height: 4.0),
                                      const DefaultTextStyle(
                                          style: TextStyle(fontSize: 14),
                                          child: Text('Visibility'))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Transform(
            //   transform: Matrix4.translationValues(0, -100, 0),
            //   child: const Card(
            //     color: Colors.white,
            //     shadowColor: Colors.transparent,
            //     child: Padding(
            //       padding: EdgeInsets.all(16.0),
            //       child: Column(
            //         children: [
            //           Row(
            //             children: [
            //               DefaultTextStyle(
            //                   style: TextStyle(fontWeight: FontWeight.bold),
            //                   child: Text('Today'))
            //             ],
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // )
          ],
        ));
  }
}
