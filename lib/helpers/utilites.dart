import 'package:logger/logger.dart';

class CustomPrettyPrinter extends PrettyPrinter {
  CustomPrettyPrinter({
    int methodCount = 0,
    int errorMethodCount = 4,
    int lineLength = 120,
    bool colors = true,
    bool printEmojis = true,
  }) : super(
          methodCount: methodCount,
          errorMethodCount: errorMethodCount,
          lineLength: lineLength,
          colors: colors,
          printEmojis: printEmojis,
        );

  @override
  List<String> log(LogEvent event) {
    var lines = super.log(event);
    var customLines = <String>[];

    customLines.add('--- Start of Log ---');
    customLines.addAll(lines);
    customLines.add('--- End of Log ---');

    return customLines;
  }
}

Logger lg = Logger(
  printer: PrefixPrinter(CustomPrettyPrinter(
    methodCount: 0,
    errorMethodCount: 4,
    lineLength: 120,
    colors: true,
    printEmojis: true,
  )),
);
