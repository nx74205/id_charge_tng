enum ChargeProvider {

  home(title: 'Zuhause'),
  enbw(title: 'EnBw'),
  ionity(title: 'Ionity'),
  eweGo(title: 'EWE Go'),
  sonstige(title: 'Sonstige');

  final String title;

  const ChargeProvider({required this.title});

}