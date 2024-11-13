enum ChargeType {

  ac(title: 'AC'),
  wallBox(title: 'Wallbox'),
  ccs50kw(title: 'CCS 50kw'),
  ccs150kw(title: 'CCS 150 kw'),
  ccsHpc(title: 'CCS HPC');

  final String title;

  const ChargeType({required this.title});

}