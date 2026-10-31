// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_mlkit_text_recognition/otel_mlkit_text_recognition.dart';

/// Traces ML Kit Text Recognition calls with OpenTelemetry.
///
/// `otel_mlkit_text_recognition` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each ML Kit Text Recognition call in
/// [tracedMlkitTextRecognition]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'mlkit-text-recognition-example');

  // Wraps an ML Kit Text Recognition call in a CLIENT span.
  final mlkitTextRecognitionId = await tracedMlkitTextRecognition<String>(
    operation: 'create',
    invoke: () async {
      // Make the ML Kit Text Recognition call here, then report what it returned.
      const id = 'mlkit_text_recognition_8f3a2c';
      return const MlkitTextRecognitionCallResult(
          value: id,
          result: MlkitTextRecognitionResult(
              script: 'latin',
              inputImageSource: 'camera',
              inputImageWidth: 1,
              inputImageHeight: 1,
              blockCount: 3,
              lineCount: 3,
              elementCount: 3,
              totalCharCount: 3,
              detectedLanguages: ['recognizedLanguages'],
              processingMs: 120,
              modelDownloaded: true,
              onDeviceOnly: true,
              confidence: 0.5));
    },
  );
  OTelLog.info(
      'tracedMlkitTextRecognition create returned $mlkitTextRecognitionId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutMlkitTextRecognitionInstrumentationAsync.
  await runWithoutMlkitTextRecognitionInstrumentationAsync(
    () => tracedMlkitTextRecognition<String>(
      operation: 'create',
      invoke: () async {
        const id = 'mlkit_text_recognition_8f3a2c';
        return const MlkitTextRecognitionCallResult(
            value: id,
            result: MlkitTextRecognitionResult(
                script: 'latin',
                inputImageSource: 'camera',
                inputImageWidth: 1,
                inputImageHeight: 1,
                blockCount: 3,
                lineCount: 3,
                elementCount: 3,
                totalCharCount: 3,
                detectedLanguages: ['recognizedLanguages'],
                processingMs: 120,
                modelDownloaded: true,
                onDeviceOnly: true,
                confidence: 0.5));
      },
    ),
  );

  await OTel.shutdown();
}
