// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_mlkit_text_recognition_suppression.dart';

const _tracerName = 'dartastic_otel_libs_mlkit_text_recognition';

Tracer _tracer() => OTel.tracerProvider().getTracer(_tracerName);

class MlkitTextRecognitionResult {
  const MlkitTextRecognitionResult({
    this.script,
    this.inputImageSource,
    this.inputImageWidth,
    this.inputImageHeight,
    this.blockCount,
    this.lineCount,
    this.elementCount,
    this.totalCharCount,
    this.detectedLanguages,
    this.processingMs,
    this.modelDownloaded,
    this.onDeviceOnly,
    this.confidence,
  });

  /// `latin`, `chinese`, `devanagari`, `japanese`, `korean`.
  final String? script;

  /// `camera`, `file`, `asset`, `bytes`.
  final String? inputImageSource;
  final int? inputImageWidth;
  final int? inputImageHeight;

  /// `RecognizedText.blocks.length`.
  final int? blockCount;
  final int? lineCount;
  final int? elementCount;
  final int? totalCharCount;

  /// BCP-47 codes recognized by `recognizedLanguages`.
  final List<String>? detectedLanguages;

  /// Wall-clock time spent in the recognizer.
  final int? processingMs;

  /// On-device model file present (no first-run download).
  final bool? modelDownloaded;

  /// On-device-only inference (no cloud fallback).
  final bool? onDeviceOnly;

  /// Average confidence (0..1) across `Element`s.
  final double? confidence;
}

class MlkitTextRecognitionCallResult<T> {
  const MlkitTextRecognitionCallResult({required this.value, this.result});
  final T value;
  final MlkitTextRecognitionResult? result;
}

/// Wraps an ML Kit Text Recognition call in a CLIENT span. [operation] is
/// one of `processImage`, `close`.
Future<T> tracedMlkitTextRecognition<T>({
  required String operation,
  required Future<MlkitTextRecognitionCallResult<T>> Function() invoke,
}) async {
  if (mlkitTextRecognitionInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final m = <String, Object>{
    'rpc.system': 'mlkit_text_recognition',
    'rpc.method': operation,
    'mlkit_text_recognition.operation': operation,
  };

  final span = _tracer().startSpan(
    'mlkit_text_recognition $operation',
    kind: SpanKind.client,
    attributes: OTel.attributesFromMap(m),
  );
  try {
    final r = await invoke();
    if (r.result != null) {
      final res = r.result!;
      final extras = <Attribute<Object>>[];
      if (res.script != null) {
        extras.add(OTel.attributeString(
          'mlkit_text_recognition.script',
          res.script!,
        ));
      }
      if (res.inputImageSource != null) {
        extras.add(OTel.attributeString(
          'mlkit_text_recognition.input.source',
          res.inputImageSource!,
        ));
      }
      if (res.inputImageWidth != null) {
        extras.add(OTel.attributeInt(
          'mlkit_text_recognition.input.width',
          res.inputImageWidth!,
        ));
      }
      if (res.inputImageHeight != null) {
        extras.add(OTel.attributeInt(
          'mlkit_text_recognition.input.height',
          res.inputImageHeight!,
        ));
      }
      if (res.blockCount != null) {
        extras.add(OTel.attributeInt(
          'mlkit_text_recognition.block.count',
          res.blockCount!,
        ));
      }
      if (res.lineCount != null) {
        extras.add(OTel.attributeInt(
          'mlkit_text_recognition.line.count',
          res.lineCount!,
        ));
      }
      if (res.elementCount != null) {
        extras.add(OTel.attributeInt(
          'mlkit_text_recognition.element.count',
          res.elementCount!,
        ));
      }
      if (res.totalCharCount != null) {
        extras.add(OTel.attributeInt(
          'mlkit_text_recognition.char.count',
          res.totalCharCount!,
        ));
      }
      if (res.detectedLanguages != null) {
        extras.add(OTel.attributeStringList(
          'mlkit_text_recognition.detected_languages',
          res.detectedLanguages!,
        ));
      }
      if (res.processingMs != null) {
        extras.add(OTel.attributeInt(
          'mlkit_text_recognition.processing_ms',
          res.processingMs!,
        ));
      }
      if (res.modelDownloaded != null) {
        extras.add(OTel.attributeBool(
          'mlkit_text_recognition.model.downloaded',
          res.modelDownloaded!,
        ));
      }
      if (res.onDeviceOnly != null) {
        extras.add(OTel.attributeBool(
          'mlkit_text_recognition.on_device_only',
          res.onDeviceOnly!,
        ));
      }
      if (res.confidence != null) {
        extras.add(OTel.attributeDouble(
          'mlkit_text_recognition.confidence',
          res.confidence!,
        ));
      }
      if (extras.isNotEmpty) span.addAttributes(OTel.attributes(extras));
    }
    return r.value;
  } catch (e, st) {
    span.addAttributes(OTel.attributes([
      OTel.attributeString(
        ErrorResource.errorType.key,
        e.runtimeType.toString(),
      ),
    ]));
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
