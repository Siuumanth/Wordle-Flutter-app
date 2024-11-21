DateTime date = DateTime.now();
DateTime dateutc = DateTime.now().toUtc();

void main() {
  //print(" Date = ${date.toString().substring(0, 16)}");
  print(" Date = ${dateutc.toString().substring(0, 16)}");
}
