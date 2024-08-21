import 'package:age_calculator1/date_calculator.dart';
import 'package:age_calculator1/date_deteails.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
      //theme: _buildThemeData(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _todayDateController = TextEditingController();
  DateTime ageInputDetails = DateTime(0, 0, 0);
  DateTime nextBirthInputDetails = DateTime(0, 0, 0);
  DateDetails ageOutputDetails = DateDetails();
  DateDetails nextBirthOutputDetails = DateDetails();



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Age Calculator'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _heading("Birth Date"),
                _birthDateInputField(),
                _emptyArea(),
                _heading("Today Date"),
                _todayDateInputField(),
                _emptyArea(),
                _clearCalculateRow(),
                _emptyArea(),
                _heading("Age is"),
                _emptyArea(),
                _yearsMonthsDaysRow(ageOutputDetails.years,
                    ageOutputDetails.months, ageOutputDetails.days),
                _emptyArea(),
                _heading("Next BirthDay After"),
                _emptyArea(),
                _yearsMonthsDaysRow(nextBirthOutputDetails.years,
                    nextBirthOutputDetails.months, nextBirthOutputDetails.days)
              ],
            ),
          ),
        ),
      ),
    );
  }
  //Reused Functions
  Future<void> _birthDateSelect() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        ageInputDetails = pickedDate;
        _birthDateController.text =
        "${ageInputDetails.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _todayDateSelect() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        nextBirthInputDetails = pickedDate;
        _todayDateController.text =
        "${nextBirthInputDetails.toLocal()}".split(' ')[0];
      });
    }
  }

  _yearsMonthsDaysRow(int years, months, days) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _outputField("Years", years),
        _outputField("Months", months),
        _outputField("Days", days),
      ],
    );
  }

  _clearCalculateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [_button("Clear", Icons.delete, _clearButtonFunction), _button("Calculate", Icons.calculate_outlined, _calcButtonFunction)],
    );
  }

  _emptyArea() {
    return const SizedBox(
      height: 25,
    );
  }

  _birthDateInputField() {
    return TextFormField(
      controller: _birthDateController,
      decoration: InputDecoration(
        labelText: "Select Date",
        hintText: "${DateTime.now().toLocal()}".split(' ')[0],
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () {
        _birthDateSelect();
      },
    );
  }

  _todayDateInputField() {
    return TextFormField(
      controller: _todayDateController,
      decoration: InputDecoration(
        labelText: "Select Date",
        hintText: "${DateTime.now().toLocal()}".split(' ')[0],
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () {
        _todayDateSelect();
      },
    );
  }

  _heading(String head) {
    return Text(
      head,
      style: const TextStyle(
          color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  _calcButtonFunction() {
    FocusScope.of(context).unfocus();
    if (_birthDateController.text.isEmpty || _todayDateController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Missing Input',style: TextStyle(color: Colors.red),),
            content: const Text('Please select both dates before calculating.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK',style: TextStyle(color: Colors.green),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        DateCalculator myAge =
        DateCalculator(ageInputDetails, nextBirthInputDetails);
        ageOutputDetails = myAge.age();
        nextBirthOutputDetails = myAge.nextBirthDate();
      });
    }
  }
  _button(String label, IconData icon, void Function() buttonFunction) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      label: Text(
        label,
        style: const TextStyle(fontSize: 20),
      ),
      onPressed: buttonFunction,
    );
  }

  _clearButtonFunction() {
      FocusScope.of(context).unfocus();
      if (_birthDateController.text.isEmpty ||
          _todayDateController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            showCloseIcon: true,
            duration: Duration(seconds: 2),
            content: Text('Already Cleared',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          _birthDateController.text = "";
          _todayDateController.text = "";
          ageInputDetails = DateTime(0, 0, 0);
          nextBirthInputDetails = DateTime(0, 0, 0);
          ageOutputDetails = DateDetails.filled(0, 0, 0);
          nextBirthOutputDetails = DateDetails.filled(0, 0, 0);
        });
      }
  }

  _outputField(String head, int num) {
    return Container(
      width: 100,
      height: 60,
      color: Colors.grey,
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.green,
              child: Center(
                child: Text(
                  head,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  num.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/*
ThemeData _buildThemeData() {
  return ThemeData(
    primaryColor: Colors.blue,
    primarySwatch: Colors.lightBlue,
    hintColor: Colors.grey,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.blue),
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}

 */