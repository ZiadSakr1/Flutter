import 'package:age_calculator/age_calculator.dart';
import 'package:age_calculator1/date_deteails.dart';

class DateCalculator {
  late DateTime birthDate, todayDate;

  DateCalculator(this.birthDate, this.todayDate);

  DateDetails age() {
    DateDuration duration;
    duration =
        AgeCalculator.dateDifference(fromDate: birthDate, toDate: todayDate);
    DateDetails dateDetails =
        DateDetails.filled(duration.years, duration.months, duration.days);

    return dateDetails;
  }

  nextBirthDate() {
    if (birthDate.month > todayDate.month) {
      birthDate = DateTime(todayDate.year, birthDate.month, birthDate.day);
    } else {
      birthDate = DateTime(todayDate.year+1, birthDate.month, birthDate.day);
    }

    DateDuration duration;
    duration =
        AgeCalculator.dateDifference(fromDate: todayDate, toDate: birthDate);
    DateDetails dateDetails =
        DateDetails.filled(duration.years, duration.months, duration.days);
    return dateDetails;
  }
}
