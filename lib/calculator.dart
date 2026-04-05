class EmissionResults {
  final String ktvCoal;
  final String etvCoal;
  final String ktvMazut;
  final String etvMazut;
  final String ktvGas;
  final String etvGas;

  EmissionResults({
    required this.ktvCoal,
    required this.etvCoal,
    required this.ktvMazut,
    required this.etvMazut,
    required this.ktvGas,
    required this.etvGas,
  });
}

class EmissionCalculator {

  static const double QCoal = 20.47;      // Теплота згоряння вугілля, МДж/кг
  static const double ACoal = 25.20;       // Зольність вугілля, %
  static const double GvunCoal = 1.5;       // Вміст горючих речовин у виносі вугілля, %
  static const double GvunMazut = 0;         // Вміст горючих речовин у виносі мазуту, %
  static const double WMazut = 2;            // Вологість мазуту, %
  static const double QMazut = 40.40;        // Теплота згоряння мазуту, МДж/кг
  static const double AMazut = 0.15;          // Зольність мазуту, %
  static const double nzu = 0.985;            // ККД золоуловлювача
  static const double ktvs = 0;                // Коефіцієнт
  static const double avunCoal = 0.8;          // Частка виносу для вугілля
  static const double avunMazut = 1;            // Частка виносу для мазуту
  static const double ktvGas = 0;                // Показник емісії для газу
  static const double etvGas = 0;                 // Викиди для газу

  static EmissionResults calculate(double coalMassKg, double mazutMassKg, double gasVolume) {
    print('=== ДЕБАГ ІНФОРМАЦІЯ ===');
    print('Вхідні дані:');
    print('Вугілля: $coalMassKg кг');
    print('Мазут: $mazutMassKg кг');
    print('Газ: $gasVolume м³');

    // Розрахунок робочої теплоти згоряння мазуту
    double qMazutRob = QMazut * (100 - WMazut - AMazut) / 100 - 0.025 * WMazut;
    print('1. qMazutRob = $qMazutRob МДж/кг');

    // Розрахунок для вугілля
    double ktvCoal = (1e6 / QCoal) * avunCoal * (ACoal / (100 - GvunCoal)) * (1 - nzu);
    print('2. ktvCoal = $ktvCoal г/ГДж');

    // etvCoal в тоннах: 10^-6 * ktvCoal * QCoal * маса_в_кг
    double etvCoal = 1e-6 * ktvCoal * QCoal * coalMassKg;
    print('3. etvCoal = $etvCoal т (з масою ${coalMassKg} кг)');

    // Розрахунок для мазуту
    double ktvMazut = (1e6 / qMazutRob) * avunMazut * (AMazut / (100 - GvunMazut)) * (1 - nzu);
    print('4. ktvMazut = $ktvMazut г/ГДж');

    // etvMazut в тоннах: 10^-6 * ktvMazut * QMazut * маса_в_кг
    double etvMazut = 1e-6 * ktvMazut * QMazut * mazutMassKg;
    print('5. etvMazut = $etvMazut т (з масою ${mazutMassKg} кг)');

    // Для газу
    double ktvGasResult = ktvGas;
    double etvGasResult = etvGas;

    print('\n=== РЕЗУЛЬТАТИ ===');
    print('ktvCoal = ${ktvCoal.toStringAsFixed(2)} г/Гдж');
    print('etvCoal = ${etvCoal.toStringAsFixed(2)} т');
    print('ktvMazut = ${ktvMazut.toStringAsFixed(2)} г/Гдж');
    print('etvMazut = ${etvMazut.toStringAsFixed(2)} т');
    print('==================\n');

    return EmissionResults(
      ktvCoal: ktvCoal.toStringAsFixed(2),
      etvCoal: etvCoal.toStringAsFixed(2),
      ktvMazut: ktvMazut.toStringAsFixed(2),
      etvMazut: etvMazut.toStringAsFixed(2),
      ktvGas: ktvGasResult.toStringAsFixed(0),
      etvGas: etvGasResult.toStringAsFixed(0),
    );
  }
}