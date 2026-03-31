import 'package:dartz/dartz.dart';

import '../../error/failures.dart';
import '../entities/subcategory-entity.dart';

abstract class SubcategoryRepository{
  Future<Either<Failure,List<SubcategoryEntity>>> getSubcategoryData();
  Future<Either<Failure, Unit>> updateSubcategoryData( {
    required int categoryId,
    required SubcategoryEntity subCategory,
  });
  Future<Either<Failure,Unit>> deleteSubcategoryData(int categoryId);
  Future<Either<Failure,Unit>> insertNewSubcategory(SubcategoryEntity item);
}