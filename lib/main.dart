import 'package:new_year_countdown/src/clickable_area.dart';
import 'package:new_year_countdown/src/fireworks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New year countdown',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LanguageSelector(),
    );
  }
}

class LanguageSelector extends StatelessWidget {
  LanguageSelector({Key? key}) : super(key: key);

  final _spacer = const SizedBox(
    height: 20,
    width: 20,
  );

  final nextYearsFirstDay = DateTime(DateTime.now().year + 1, 1, 1);

  final _testText = {
    'pt-BR': 'Clique aqui para\nver funcionando',
    'en-US': 'Click here to check\nhow it works',
  };

  final _languageName = {
    'pt-BR': 'Português',
    'en-US': 'Inglês',
  };

  _renderFlag({
    required String language,
    required String flagAsset,
    required BuildContext context,
    required DateTime end,
  }) {
    final testText = _testText[language];

    if (testText == null) {
      throw 'Language not implemented';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClickableArea(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => Fireworks(
                  language: language,
                  end: end,
                  year: '${end.year}',
                ),
              ),
            );
          },
          child: Column(
            children: [
              Text(
                _languageName[language]!,
                style: const TextStyle(
                  color: Colors.white,
                  height: 2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Container(
                height: 100,
                width: 150,
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  flagAsset,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ),
        _spacer,
        ClickableArea(
          child: Text(
            testText,
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.3,
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          onTap: () {
            final now = DateTime.now();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => Fireworks(
                  language: language,
                  end: now.add(const Duration(seconds: 15)),
                  year: '${now.year + 1}',
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _renderFlag(
              language: 'pt-BR',
              flagAsset: 'flags/brazil.svg',
              context: context,
              end: nextYearsFirstDay,
            ),
            _spacer,
            _renderFlag(
              language: 'en-US',
              flagAsset: 'flags/united-states.svg',
              context: context,
              end: nextYearsFirstDay,
            ),
          ],
        ),
      ),
    );
  }
}
