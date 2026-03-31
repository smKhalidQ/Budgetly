import 'package:budget_buddy/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/category_entity.dart';
import '../../../../core/domain/repositories/category_repository.dart';



class GetCategoriesDataUseCase{

  final CategoryRepository categoryManagementRepository;

  GetCategoriesDataUseCase({required this.categoryManagementRepository});

  Future <Either<Failure,List<CategoryEntity>>> call()async{

    return await categoryManagementRepository.getCategoryData();
  }
}