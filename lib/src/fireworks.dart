import 'package:new_year_countdown/src/fireworks_background.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Fireworks extends StatefulWidget {
  const Fireworks({
    Key? key,
    required this.language,
    required this.end,
    required this.year,
  }) : super(key: key);

  final String language;
  final DateTime end;
  final String year;

  @override
  State<Fireworks> createState() => _FireworksState();
}

class _FireworksState extends State<Fireworks> with TickerProviderStateMixin {
  late final AnimationController _timeController;
  late final String _dayWord;

  int _fontSizeFactorCount = 1;

  Duration get _diff => widget.end.difference(DateTime.now());

  @override
  void initState() {
    _setLocalization();

    _initTimeController();

    super.initState();
  }

  void _initTimeController() {
    _timeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _timeController.forward();

    _timeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_diff.inSeconds <= 0) {
          return;
        }

        if (_diff.inSeconds > 0 && _diff.inSeconds < 10) {
          _fontSizeFactorCount += 1;
        }

        _timeController.forward(from: 0);
      }
    });
  }

  void _setLocalization() {
    final dayWord = {
      'pt-BR': 'dia',
      'en-US': 'day',
    }[widget.language];

    if (dayWord == null) {
      throw 'Language not implemented';
    }

    _dayWord = dayWord;
  }

  @override
  void dispose() {
    _timeController.dispose();

    super.dispose();
  }

  String _getCurrentDiff() {
    final diff = _diff;

    if (diff.inDays >= 1) {
      return '${diff.inDays} $_dayWord${diff.inDays > 1 ? 's' : ''}';
    }

    if (diff.inSeconds <= 0) {
      return widget.year;
    }

    if (diff.inSeconds <= 60) {
      return '${diff.inSeconds}';
    }

    final hour = diff.inHours;
    final minutes = diff.inMinutes - (hour * 60);
    final seconds = diff.inSeconds - (hour * 3600) - (minutes * 60);

    if (hour < 1) {
      return '${minutes}m ${seconds}s';
    }

    return '${hour}h ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _timeController,
      builder: (context, child) {
        final fontSizeFactor = _getCurrentFontSizeFactor();

        return Stack(
          fit: StackFit.expand,
          children: [
            if (_diff.inSeconds <= 20)
              AnimatedOpacity(
                opacity: _diff.inSeconds <= 0 ? 1 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: FireworksBackground(
                  size: size,
                ),
              ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: FittedBox(
                fit: BoxFit.contain,
                child: AutoSizeText(
                  _getCurrentDiff(),
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: (size.width * 0.3) + fontSizeFactor,
                    fontWeight: _diff.inSeconds <= 60
                        ? FontWeight.w900
                        : FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _getCurrentFontSizeFactor() {
    return _diff.inSeconds >= 10
        ? 0
        : (15 * (_timeController.value + _fontSizeFactorCount));
  }
}
