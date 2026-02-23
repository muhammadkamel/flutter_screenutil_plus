import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    if (data != null) {
      final timeline = data['timeline_summary'];
      if (timeline != null) {
        // Driver extracts the timeline_summary payload for test analysis
      }
    }
  },
);
