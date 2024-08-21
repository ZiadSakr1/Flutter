class DateDetails {
  int years = 0, months = 0, days = 0;

  DateDetails();

  DateDetails.filled(this.years, this.months, this.days);

  bool isNotZeros() {
    if (years == months && years == days && years == 0) return false;
    return true;
  }
}
