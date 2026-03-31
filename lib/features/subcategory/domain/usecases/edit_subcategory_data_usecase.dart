import 'package:budget_buddy/core/domain/repositories/subcategory_repository.dart';
import 'package:budget_buddy/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/category_entity.dart';
import '../../../../core/domain/entities/subcategory-entity.dart';
import '../../../../core/domain/repositories/category_repository.dart' show CategoryRepository;

class UpdateSubcategoryDataUseCase{

  final SubcategoryRepository subcategoryRepository;

  UpdateSubcategoryDataUseCase({required this.subcategoryRepository});

  Future <Either<Failure,Unit>> call(SubcategoryEntity subItem,int categoryId)async{

    return await subcategoryRepository.updateSubcategoryData(
      categoryId: categoryId,
      subCategory: subItem
    );
  }
}