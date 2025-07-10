// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../models/formation_template.dart';
import '../repositories/formation_template_repository.dart';
import '../repositories/local_formation_template_repository.dart';

final formationTemplateRepositoryProvider =
    Provider<FormationTemplateRepository>((ref) {
      return LocalFormationTemplateRepository();
    });

final formationTemplatesProvider = FutureProvider<List<FormationTemplate>>((
  ref,
) async {
  final repo = ref.read(formationTemplateRepositoryProvider);
  final res = await repo.getAll();
  return res.dataOrNull ?? [];
});
