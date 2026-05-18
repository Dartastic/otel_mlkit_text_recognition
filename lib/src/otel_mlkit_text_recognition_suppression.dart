// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'dart:async';

const _key = #dartastic_otel_libs_mlkit_text_recognition_suppress;

bool mlkitTextRecognitionInstrumentationSuppressed() =>
    Zone.current[_key] == true;

T runWithoutMlkitTextRecognitionInstrumentation<T>(T Function() body) =>
    runZoned(body, zoneValues: {_key: true});

Future<T> runWithoutMlkitTextRecognitionInstrumentationAsync<T>(
  Future<T> Function() body,
) =>
    runZoned(body, zoneValues: {_key: true});
