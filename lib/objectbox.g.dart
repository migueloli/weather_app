// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'data/entity/city_entity.dart';
import 'data/entity/weather_entity.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 1441911497653429776),
      name: 'CityEntity',
      lastPropertyId: const obx_int.IdUid(8, 7165165734970507908),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 2395781566478709838),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 8048095066443829526),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 1152604935437928035),
            name: 'lat',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 460455100787761654),
            name: 'lon',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 2925861445964293376),
            name: 'country',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 2082212618908804478),
            name: 'state',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 7412129263334679211),
            name: 'savedAtTimestamp',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 7165165734970507908),
            name: 'coordinates',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 2948583525486954945),
      name: 'WeatherEntity',
      lastPropertyId: const obx_int.IdUid(6, 7407517599489945588),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 7983467925415125116),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 5997478955146787717),
            name: 'lat',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 3888875273938334763),
            name: 'lon',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 810928007147362113),
            name: 'weatherData',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 7896962551791066073),
            name: 'timestamp',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 7407517599489945588),
            name: 'coordinates',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(2, 2948583525486954945),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    CityEntity: obx_int.EntityDefinition<CityEntity>(
        model: _entities[0],
        toOneRelations: (CityEntity object) => [],
        toManyRelations: (CityEntity object) => {},
        getId: (CityEntity object) => object.id,
        setId: (CityEntity object, int id) {
          object.id = id;
        },
        objectToFB: (CityEntity object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final countryOffset = fbb.writeString(object.country);
          final stateOffset =
              object.state == null ? null : fbb.writeString(object.state!);
          final coordinatesOffset = fbb.writeString(object.coordinates);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addFloat64(2, object.lat);
          fbb.addFloat64(3, object.lon);
          fbb.addOffset(4, countryOffset);
          fbb.addOffset(5, stateOffset);
          fbb.addInt64(6, object.savedAtTimestamp);
          fbb.addOffset(7, coordinatesOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final countryParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 12, '');
          final latParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0);
          final lonParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 10, 0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final stateParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 14);
          final coordinatesParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 18, '');
          final savedAtTimestampParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0);
          final object = CityEntity(
              name: nameParam,
              country: countryParam,
              lat: latParam,
              lon: lonParam,
              id: idParam,
              state: stateParam,
              coordinates: coordinatesParam,
              savedAtTimestamp: savedAtTimestampParam);

          return object;
        }),
    WeatherEntity: obx_int.EntityDefinition<WeatherEntity>(
        model: _entities[1],
        toOneRelations: (WeatherEntity object) => [],
        toManyRelations: (WeatherEntity object) => {},
        getId: (WeatherEntity object) => object.id,
        setId: (WeatherEntity object, int id) {
          object.id = id;
        },
        objectToFB: (WeatherEntity object, fb.Builder fbb) {
          final weatherDataOffset = fbb.writeString(object.weatherData);
          final coordinatesOffset = fbb.writeString(object.coordinates);
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addFloat64(1, object.lat);
          fbb.addFloat64(2, object.lon);
          fbb.addOffset(3, weatherDataOffset);
          fbb.addInt64(4, object.timestamp);
          fbb.addOffset(5, coordinatesOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final latParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 6, 0);
          final lonParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0);
          final weatherDataParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 10, '');
          final timestampParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final coordinatesParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 14, '');
          final object = WeatherEntity(
              lat: latParam,
              lon: lonParam,
              weatherData: weatherDataParam,
              timestamp: timestampParam,
              id: idParam,
              coordinates: coordinatesParam);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [CityEntity] entity fields to define ObjectBox queries.
class CityEntity_ {
  /// See [CityEntity.id].
  static final id =
      obx.QueryIntegerProperty<CityEntity>(_entities[0].properties[0]);

  /// See [CityEntity.name].
  static final name =
      obx.QueryStringProperty<CityEntity>(_entities[0].properties[1]);

  /// See [CityEntity.lat].
  static final lat =
      obx.QueryDoubleProperty<CityEntity>(_entities[0].properties[2]);

  /// See [CityEntity.lon].
  static final lon =
      obx.QueryDoubleProperty<CityEntity>(_entities[0].properties[3]);

  /// See [CityEntity.country].
  static final country =
      obx.QueryStringProperty<CityEntity>(_entities[0].properties[4]);

  /// See [CityEntity.state].
  static final state =
      obx.QueryStringProperty<CityEntity>(_entities[0].properties[5]);

  /// See [CityEntity.savedAtTimestamp].
  static final savedAtTimestamp =
      obx.QueryIntegerProperty<CityEntity>(_entities[0].properties[6]);

  /// See [CityEntity.coordinates].
  static final coordinates =
      obx.QueryStringProperty<CityEntity>(_entities[0].properties[7]);
}

/// [WeatherEntity] entity fields to define ObjectBox queries.
class WeatherEntity_ {
  /// See [WeatherEntity.id].
  static final id =
      obx.QueryIntegerProperty<WeatherEntity>(_entities[1].properties[0]);

  /// See [WeatherEntity.lat].
  static final lat =
      obx.QueryDoubleProperty<WeatherEntity>(_entities[1].properties[1]);

  /// See [WeatherEntity.lon].
  static final lon =
      obx.QueryDoubleProperty<WeatherEntity>(_entities[1].properties[2]);

  /// See [WeatherEntity.weatherData].
  static final weatherData =
      obx.QueryStringProperty<WeatherEntity>(_entities[1].properties[3]);

  /// See [WeatherEntity.timestamp].
  static final timestamp =
      obx.QueryIntegerProperty<WeatherEntity>(_entities[1].properties[4]);

  /// See [WeatherEntity.coordinates].
  static final coordinates =
      obx.QueryStringProperty<WeatherEntity>(_entities[1].properties[5]);
}
