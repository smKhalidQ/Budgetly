import 'package:budget_buddy/core/domain/entities/subcategory-entity.dart';
import 'package:budget_buddy/core/domain/repositories/subcategory_repository.dart';
import 'package:budget_buddy/core/error/failures.dart';

import 'package:dartz/dartz.dart';




class GetSubCategoriesDataUseCase{

  final SubcategoryRepository subcategoryRepository;

  GetSubCategoriesDataUseCase({required this.subcategoryRepository});

  Future<Either<Failure, List<SubcategoryEntity>>> call()async{

    return await subcategoryRepository.getSubcategoryData();
  }
}