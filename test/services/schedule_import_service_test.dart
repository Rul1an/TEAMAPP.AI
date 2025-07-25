import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/repositories/match_repository.dart';
import 'package:jo17_tactical_manager/services/schedule_import_service.dart';

class _FakeMatchRepo implements MatchRepository {
  final List<Match> _matches = [];
  int addCalls = 0;

  @override
  Future<Result<void>> add(Match match) async {
    addCalls += 1;
    _matches.add(match);
    return const Success(null);
  }

  // Unused repo methods for these tests
  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<List<Match>>> getAll() async => Success(List.unmodifiable(_matches));

  @override
  Future<Result<Match?>> getById(String id) async => const Success(null);

  @override
  Future<Result<List<Match>>> getRecent() async => const Success([]);

  @override
  Future<Result<List<Match>>> getUpcoming() async => const Success([]);

  @override
  Future<Result<void>> update(Match match) async => const Success(null);

  // getByDateRange not needed for these tests
}

void main() {
  group('ScheduleImportService', () {
    late _FakeMatchRepo repo;
    late ScheduleImportService service;

    setUp(() {
      repo = _FakeMatchRepo();
      service = ScheduleImportService(repo);
    });

    Uint8List bytes(String csv) => Uint8List.fromList(utf8.encode(csv));

    test('imports valid CSV rows', () async {
      const csv = 'date,time,opponent,competition,location\n'
          '2025-09-12,19:30,FC Utrecht U17,Eredivisie,Thuis\n'
          '2025-09-19,18:00,PSV U17,Eredivisie,Uit\n';
      final res = await service.importCsvBytes(bytes(csv));
      expect(res.isSuccess, isTrue);
      final report = res.dataOrNull!;
      expect(report.imported, 2);
      expect(report.errors, isEmpty);
      expect(repo.addCalls, 2);
    });

    test('returns error when required column missing', () async {
      const csv = 'date,time,opponent,location\n2025-09-12,19:30,FC,Thuis\n';
      final res = await service.importCsvBytes(bytes(csv));
      expect(res.isSuccess, isTrue);
      final report = res.dataOrNull!;
      expect(report.imported, 0);
      expect(report.errors, isNotEmpty);
    });

    test('skips invalid row and collects error', () async {
      const csv = 'date,time,opponent,competition,location\n'
          'invalid-date,19:30,FC,U17,Eredivisie,Thuis\n'
          '2025-09-19,18:00,PSV U17,Eredivisie,Uit\n';
      // Note: first row malformed date
      final res = await service.importCsvBytes(bytes(csv));
      final report = res.dataOrNull!;
      expect(report.imported, 1);
      expect(report.errors.length, 1);
    });

    test('detects duplicate rows and skips import', () async {
      // Pre-seed repo with an existing match on 2025-09-12 vs FC Utrecht U17
      await repo.add(Match()
        ..id = 'seed'
        ..date = DateTime.parse('2025-09-12 19:30')
        ..opponent = 'FC Utrecht U17'
        ..competition = Competition.league
        ..location = Location.home,);

      // reset counter before import
      repo.addCalls = 0;

      const csv = 'date,time,opponent,competition,location\n'
          '2025-09-12,19:30,FC Utrecht U17,Eredivisie,Thuis\n';

      final res = await service.importCsvBytes(bytes(csv));
      final report = res.dataOrNull!;
      expect(report.imported, 0);
      expect(report.errors, isNotEmpty);
      expect(repo.addCalls, 0);
    });
  });
}
