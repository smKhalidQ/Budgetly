import 'package:budget_buddy/core/domain/entities/subcategory-entity.dart';
import 'package:budget_buddy/core/domain/repositories/subcategory_repository.dart';
import 'package:budget_buddy/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/domain/repositories/category_repository.dart';


class InsertSubcategoryDataUseCase {
  final SubcategoryRepository subcategoryRepository;

  InsertSubcategoryDataUseCase({required this.subcategoryRepository});

  Future<Either<Failure, Unit>> call(SubcategoryEntity subItem) async {
    return await subcategoryRepository.insertNewSubcategory( subItem);
  }
}
