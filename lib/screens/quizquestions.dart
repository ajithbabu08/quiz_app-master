
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/homepage.dart';
import 'package:quiz_app/screens/result_page.dart';

import '../data/questions_listpage.dart';

class Quiz_Screen extends StatefulWidget {
  const Quiz_Screen({Key? key}) : super(key: key);

  @override
  _QuizzScreenState createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<Quiz_Screen> {
  int question_pos = 0;
  int score = 0;
  bool btnPressed = false;
  PageController? _controller;
  String btnText = "Next Question";
  bool answered = false;
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: PageView.builder(
                controller: _controller!,
                onPageChanged: (page) {
                  if (page == questions.length - 1) {
                    setState(() {
                      btnText = "Finish Quiz";
                    });
                  }
                  setState(() {
                    answered = false;
                  });
                },
                physics: new NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Question ${index + 1}/25",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),

                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "${questions[index].question}",textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      for (int i = 0; i < questions[index].answers!.length; i++)
                        Container(
                          width: double.infinity,
                          height: 70,
                          margin: EdgeInsets.only(
                              bottom: 12.0, left: 12.0, right: 12.0),
                          child: RawMaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            fillColor: btnPressed
                                ? questions[index].answers!.values.toList()[i]
                                ? Colors.green
                                : Colors.red
                                : Colors.blueAccent,
                            onPressed: !answered
                                ? () {
                              if (questions[index]
                                  .answers!
                                  .values
                                  .toList()[i]) {
                                score++;
                                print("yes");
                              } else {
                                print("no");
                              }
                              setState(() {
                                btnPressed = true;
                                answered = true;
                              });
                            }
                                : null,
                            child: Text(questions[index].answers!.keys.toList()[i],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                )),
                          ),
                        ),
                      SizedBox(
                        height: 5.0,
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          if (_controller!.page?.toInt() == questions.length - 1) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultScreen(score)));
                          } else {
                            _controller!.nextPage(
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeInExpo);

                            setState(() {
                              btnPressed = false;
                            });
                          }
                        },
                        shape: StadiumBorder(),
                        fillColor: Colors.blue,
                        padding: EdgeInsets.all(8.0),
                        elevation: 0.0,
                        child: Text(
                          btnText,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: questions.length,
              )),
            Positioned(
              top: 10,
              right: 10,
              child: TextButton(
                onPressed: () async {
                  bool confirmQuit = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        // title: Text('Quit Quiz'),
                        content: Text('Are you sure you want to quit ?',style: TextStyle(fontWeight: FontWeight.bold),),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text('Quit'),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirmQuit == true) {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => quizHome()));
                  }
                },
                child: Text("Quit Quiz ?"),
              ),
            ),
      ],
        ),
      ),
    );
  }
}