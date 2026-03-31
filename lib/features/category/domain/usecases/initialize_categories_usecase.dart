
import 'package:budget_buddy/core/domain/entities/category_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/domain/repositories/category_repository.dart';
import '../../../../core/error/failures.dart';


class InitializeCategoriesUseCase{
  final CategoryRepository categoryRepository;

  InitializeCategoriesUseCase({required this.categoryRepository});

  Future<Either<Failure, Unit>> call(List<CategoryEntity> categories) async {
    return await categoryRepository.setCategoriesData(categories);
  }
}