enum EDateRange {
  oneDay('24H', 1),
  sevenDays('7D', 7),
  fifteenDays('15D', 15),
  oneMonth('1M', 30),
  threeMonths('3M', 90),
  sixMonths('6M', 180),
  oneYear('1Y', 365);

  final String label;
  final int days;

  const EDateRange(this.label, this.days);
}