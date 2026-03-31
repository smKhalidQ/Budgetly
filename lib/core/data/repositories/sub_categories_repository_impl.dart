    import 'package:dartz/dartz.dart';
    import 'package:sqflite/sqflite.dart';

    import '../../domain/entities/subcategory-entity.dart';
    import '../database/subcategory_datasource.dart';
    import '../../domain/repositories/subcategory_repository.dart';
    import '../../error/failures.dart';
    import '../models/subcategory_model.dart';

    class SubcategoryRepositoryImpl implements SubcategoryRepository {
      final SubcategoryDataSource localDataSource;

      SubcategoryRepositoryImpl({required this.localDataSource});

      @override
      Future<Either<Failure, List<SubcategoryModel>>> getSubcategoryData() async {
        try {
          final response = await localDataSource.getSubcategoriesData();
          final subCategories = response.map((data) => SubcategoryModel.fromJson(data)).toList();
          return Right(subCategories);
        } on DatabaseException catch (e) {
          return Left(DatabaseFailure(message: e.toString()));
        } catch (e) {
          return Left(UnknownFailure(errorMessage: e.toString()));
        }
      }

      @override
      Future<Either<Failure, Unit>> insertNewSubcategory(SubcategoryEntity item) async {
        try {
          await localDataSource.insertNewSubcategory(
            subcategoryName: item.subcategoryName!,
            subcategoryColor: item.subcategoryColor!,
            subcategoryIcon: item.subcategoryIcon!,
            parentCategoryId: item.parentCategoryId!,
          );
          return const Right(unit);
        } on DatabaseException catch (e) {
          return Left(DataInsertionFailure(errorMessage: e.toString()));
        } catch (e) {
          return Left(UnknownFailure(errorMessage: e.toString()));
        }
      }

      @override
      Future<Either<Failure, Unit>> updateSubcategoryData({
        required int categoryId,
        required SubcategoryEntity subCategory,
      }) async {
        try {
          final Map<String, dynamic> updatedFields = {};

          if (subCategory.subcategoryName != null) {
            updatedFields['subcategoryName'] = subCategory.subcategoryName;
          }
          if (subCategory.subcategoryColor != null) {
            updatedFields['subcategoryColor'] = subCategory.subcategoryColor;
          }
          if (subCategory.subcategoryIcon != null) {
            updatedFields['subcategoryIcon'] = subCategory.subcategoryIcon;
          }
          if (subCategory.parentCategoryId != null) {
            updatedFields['categoryId'] = subCategory.parentCategoryId;
          }

          // التحقق من وجود بيانات للتحديث
          if (updatedFields.isEmpty) {
            return Left(DataUpdateFailure(errorMessage: "No fields to update"));
          }

          // استدعاء دالة التحديث في الداتاسورس مع الحقول المحددة فقط
          await localDataSource.updateSubcategoryData(
            subcategoryId: subCategory.subcategoryId!,
            updatedFields: updatedFields,
          );
          return const Right(unit);
        } on DatabaseException catch (e) {
          return Left(DataUpdateFailure(errorMessage: e.toString()));
        } catch (e) {
          return Left(UnknownFailure(errorMessage: e.toString()));
        }
      }

      @override
      Future<Either<Failure, Unit>> deleteSubcategoryData(int subCategoryId) async {
        try {
          await localDataSource.deleteSubcategoryData(subCategoryId);
          return const Right(unit);
        } on DatabaseException catch (e) {
          return Left(DataDeletionFailure(errorMessage: e.toString()));
        } catch (e) {
          return Left(UnknownFailure(errorMessage: e.toString()));
        }
      }
    }