// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_arize_suppression.dart';

class ArizeResult {
  const ArizeResult({
    this.spaceId,
    this.modelId,
    this.modelVersion,
    this.modelType,
    this.environment,
    this.predictionId,
    this.records,
    this.featuresCount,
    this.embeddingFeaturesCount,
    this.actualLabel,
    this.predictionLabel,
    this.predictionScore,
    this.driftMetric,
    this.driftValue,
    this.dataQualityMetric,
    this.dataQualityValue,
    this.evalName,
    this.evalScore,
    this.spanKind,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? spaceId;
  final String? modelId;
  final String? modelVersion;
  final String? modelType;
  final String? environment;
  final String? predictionId;
  final int? records;
  final int? featuresCount;
  final int? embeddingFeaturesCount;
  final String? actualLabel;
  final String? predictionLabel;
  final double? predictionScore;
  final String? driftMetric;
  final double? driftValue;
  final String? dataQualityMetric;
  final double? dataQualityValue;
  final String? evalName;
  final double? evalScore;
  final String? spanKind;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class ArizeCallResult<T> {
  const ArizeCallResult({required this.value, this.result});
  final T value;
  final ArizeResult? result;
}

Future<T> tracedArize<T>({
  required String operation,
  required Future<ArizeCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (arizeInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_arize');
  final span = t.startSpan('arize $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.system', 'arize')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.spaceId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('arize.space.id', res.spaceId!)]));
      }
      if (res.modelId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('arize.model.id', res.modelId!)]));
      }
      if (res.modelVersion != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('arize.model.version', res.modelVersion!)
        ]));
      }
      if (res.modelType != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('arize.model.type', res.modelType!)]));
      }
      if (res.environment != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('arize.environment', res.environment!)]));
      }
      if (res.predictionId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('arize.prediction.id', res.predictionId!)
        ]));
      }
      if (res.records != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('arize.records', res.records!)]));
      }
      if (res.featuresCount != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('arize.features.count', res.featuresCount!)
        ]));
      }
      if (res.embeddingFeaturesCount != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'arize.embedding_features.count', res.embeddingFeaturesCount!)
        ]));
      }
      if (res.actualLabel != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('arize.actual.label', res.actualLabel!)]));
      }
      if (res.predictionLabel != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'arize.prediction.label', res.predictionLabel!)
        ]));
      }
      if (res.predictionScore != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeDouble(
              'arize.prediction.score', res.predictionScore!)
        ]));
      }
      if (res.driftMetric != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('arize.drift.metric', res.driftMetric!)]));
      }
      if (res.driftValue != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeDouble('arize.drift.value', res.driftValue!)]));
      }
      if (res.dataQualityMetric != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'arize.data_quality.metric', res.dataQualityMetric!)
        ]));
      }
      if (res.dataQualityValue != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeDouble(
              'arize.data_quality.value', res.dataQualityValue!)
        ]));
      }
      if (res.evalName != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('arize.eval.name', res.evalName!)]));
      }
      if (res.evalScore != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeDouble('arize.eval.score', res.evalScore!)]));
      }
      if (res.spanKind != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('arize.span.kind', res.spanKind!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('arize.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              ErrorAttributes.errorType.key, res.errorCode ?? 'arize.error')
        ]));
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
