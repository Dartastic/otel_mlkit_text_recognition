// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_mlkit_text_recognition/otel_mlkit_text_recognition.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_mlkit_text_recognition-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('processImage records script + counts + processing ms', () async {
    await tracedMlkitTextRecognition<String>(
      operation: 'processImage',
      invoke: () async => const MlkitTextRecognitionCallResult(
        value: 'ok',
        result: MlkitTextRecognitionResult(
          script: 'latin',
          inputImageSource: 'camera',
          inputImageWidth: 1920,
          inputImageHeight: 1080,
          blockCount: 4,
          lineCount: 12,
          elementCount: 80,
          totalCharCount: 420,
          processingMs: 86,
          modelDownloaded: true,
          onDeviceOnly: true,
          confidence: 0.92,
        ),
      ),
    );
    final a = attrsOf(
      spans.findSpanByName('mlkit_text_recognition processImage')!,
    );
    expect(a['mlkit_text_recognition.script'], 'latin');
    expect(a['mlkit_text_recognition.line.count'], 12);
    expect(a['mlkit_text_recognition.processing_ms'], 86);
  });

  test('suppression skips spans', () async {
    await runWithoutMlkitTextRecognitionInstrumentationAsync(() async {
      await tracedMlkitTextRecognition<String>(
        operation: 'close',
        invoke: () async => const MlkitTextRecognitionCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('mlkit_text_recognition '), isEmpty);
  });
}
