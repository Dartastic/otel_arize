// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_arize/otel_arize.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_arize-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('log_predictions records model + records + features', () async {
    await tracedArize<String>(
      operation: 'log_predictions',
      invoke: () async => const ArizeCallResult(
        value: 'ok',
        result: ArizeResult(
          modelId: 'fraud-classifier',
          modelVersion: 'v3',
          modelType: 'binary_classification',
          environment: 'production',
          records: 10000,
          featuresCount: 24,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('arize log_predictions')!);
    expect(a['arize.model.id'], 'fraud-classifier');
    expect(a['arize.records'], 10000);
    expect(a['arize.features.count'], 24);
  });

  test('drift metric recorded', () async {
    await tracedArize<String>(
      operation: 'drift.compute',
      invoke: () async => const ArizeCallResult(
        value: 'ok',
        result: ArizeResult(
          driftMetric: 'PSI',
          driftValue: 0.18,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('arize drift.compute')!);
    expect(a['arize.drift.metric'], 'PSI');
    expect(a['arize.drift.value'], 0.18);
  });

  test('error code sets span error', () async {
    await tracedArize<String>(
      operation: 'log_predictions',
      invoke: () async => const ArizeCallResult(
        value: 'ok',
        result: ArizeResult(
          errorCode: 'invalid_schema',
          statusCode: 400,
        ),
      ),
    );
    expect(
      spans.findSpanByName('arize log_predictions')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutArizeInstrumentationAsync(() async {
      await tracedArize<String>(
        operation: 'models.list',
        invoke: () async => const ArizeCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('arize '), isEmpty);
  });
}
