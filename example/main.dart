// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_arize/otel_arize.dart';

/// Traces Arize calls with OpenTelemetry.
///
/// `otel_arize` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Arize call in
/// [tracedArize]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'arize-example');

  // Traces a Arize call.
  final arizeId = await tracedArize<String>(
    operation: 'create',
    invoke: () async {
      // Make the Arize call here, then report what it returned.
      const id = 'arize_8f3a2c';
      return const ArizeCallResult(
          value: id,
          result: ArizeResult(
              spaceId: 'space_8f3a2c',
              modelId: 'model_8f3a2c',
              modelVersion: 'standard',
              modelType: 'standard',
              environment: 'example',
              predictionId: 'prediction_8f3a2c',
              records: 1,
              featuresCount: 3,
              embeddingFeaturesCount: 3,
              actualLabel: 'example',
              predictionLabel: 'example',
              predictionScore: 0.5,
              driftMetric: 'example',
              driftValue: 0.5,
              dataQualityMetric: 'example',
              dataQualityValue: 0.5,
              evalName: 'example',
              evalScore: 0.5,
              spanKind: 'example',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedArize create returned $arizeId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutArizeInstrumentationAsync.
  await runWithoutArizeInstrumentationAsync(
    () => tracedArize<String>(
      operation: 'create',
      invoke: () async {
        const id = 'arize_8f3a2c';
        return const ArizeCallResult(
            value: id,
            result: ArizeResult(
                spaceId: 'space_8f3a2c',
                modelId: 'model_8f3a2c',
                modelVersion: 'standard',
                modelType: 'standard',
                environment: 'example',
                predictionId: 'prediction_8f3a2c',
                records: 1,
                featuresCount: 3,
                embeddingFeaturesCount: 3,
                actualLabel: 'example',
                predictionLabel: 'example',
                predictionScore: 0.5,
                driftMetric: 'example',
                driftValue: 0.5,
                dataQualityMetric: 'example',
                dataQualityValue: 0.5,
                evalName: 'example',
                evalScore: 0.5,
                spanKind: 'example',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
