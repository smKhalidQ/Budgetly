import 'package:budget_buddy/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/category_entity.dart';
import '../../../../core/domain/repositories/category_repository.dart' show CategoryRepository;

class UpdateCategoryDataUseCase{

  final CategoryRepository categoryManagementRepository;

  UpdateCategoryDataUseCase({required this.categoryManagementRepository});

  Future <Either<Failure,Unit>> call(CategoryEntity item,int categoryId)async{

    return await categoryManagementRepository.updateCategoryData(item: item,categoryId: categoryId);
  }
}