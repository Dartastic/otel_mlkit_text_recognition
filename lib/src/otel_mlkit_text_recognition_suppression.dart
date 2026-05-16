// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

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
