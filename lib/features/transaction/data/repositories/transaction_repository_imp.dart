import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../../../core/data/database/category_datasource.dart';
import '../datasources/transaction_datasources.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});
  @override
  Future<Either<Failure, Unit>> addExpenseEntry(TransactionEntity item) async {
    try {
      await localDataSource.addTransaction(
          categoryId: item.categoryId,
          amount: item.amount,
          date: item.date,
          note: item.note);
      return Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          message: "Failed to add expense entry: ${e.toString()}"));
    } catch (e) {
      return Left(DatabaseFailure(
          message: "An unknown error occurred while adding expense entry."));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExpenseEntry(int expenseEntryId) async {
    try {
      await localDataSource.deleteTransaction(expenseEntryId);
      return Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
        message: "Failed to delete expense entry: ${e.toString()}",
      ));
    } catch (e) {
      return Left(DatabaseFailure(
          message: "An unknown error occurred while deleting expense entry."));
    }
  }

  @override
  Future<Either<Failure, Unit>> editExpenseEntry(
      TransactionEntity item) async {
    try {
      final expenseEntryModel = TransactionModel(
        categoryId: item.categoryId,
        amount: item.amount,
        date: item.date,
        note: item.note,
        transactionId: item.transactionId,
      );

      await localDataSource.editTransaction(item.transactionId!,
          date: item.date,
          amount: item.amount,
          categoryId: item.categoryId,
          note: item.note);
      return Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          message: "Failed to edit expense entry: ${e.toString()}"));
    } catch (e) {
      return Left(DatabaseFailure(
          message: "An unknown error occurred while editing expense entry."));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getExpenseEntries() async {
    try {
      final entries = await localDataSource.fetchTransactions();
      // تحويل القائمة من نموذج قاعدة البيانات إلى كائنات الكيان
      final expenseEntries =
      entries.map((entry) => TransactionModel.fromJson(entry)).toList();
      return Right(expenseEntries.cast<TransactionEntity>());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(
          message: "Failed to retrieve expense entries: ${e.toString()}"));
    } catch (e) {
      return Left(DatabaseFailure(
          message:
          "An unknown error occurred while retrieving expense entries."));
    }
  }

  // @override
  // Future<Either<Failure, List<TransactionModel>>> getCategoryData() async {
  //   try {
  //     final response = await localDataSource.getCategoriesData();
  //     final categories = response.map((data) => TransactionModel.fromJson(data)).toList();
  //     return Right(categories);
  //   } on DatabaseException catch (e) {
  //     return Left(DatabaseFailure(message: e.toString()));
  //   } catch (e) {
  //     return Left(UnknownFailure(errorMessage: e.toString()));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, Unit>> insertNewCategory(TransactionEntity item) async {
  //   try {
  //     await localDataSource.insertNewCategory(
  //       name: item.name!,
  //       color: item.color!,
  //       icon: item.icon!,
  //       allocatedAmount: item.allocatedAmount!,
  //     );
  //     return const Right(unit);
  //   } on DatabaseException catch (e) {
  //     return Left(DataInsertionFailure(errorMessage: e.toString()));
  //   } catch (e) {
  //     return Left(UnknownFailure(errorMessage: e.toString()));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, Unit>> updateCategoryData({
  //   required int categoryId,
  //   required TransactionEntity item,
  // }) async {
  //   try {
  //     final Map<String, dynamic> updatedFields = {};
  //
  //     if (item.name != null) updatedFields['name'] = item.name;
  //     if (item.color != null) updatedFields['color'] = item.color;
  //     if (item.icon != null) updatedFields['icon'] = item.icon;
  //     if (item.allocatedAmount != null) updatedFields['allocatedAmount'] = item.allocatedAmount;
  //
  //     // التحقق من وجود بيانات للتحديث
  //     if (updatedFields.isEmpty) {
  //       return Left(DataUpdateFailure(errorMessage: "No fields to update"));
  //     }
  //
  //     // استدعاء دالة التحديث في الداتاسورس مع الحقول المحددة فقط
  //     await localDataSource.updateCategoryData(
  //       categoryId: categoryId,
  //       updatedFields: updatedFields,
  //     );
  //     return const Right(unit);
  //   } on DatabaseException catch (e) {
  //     return Left(DataUpdateFailure(errorMessage: e.toString()));
  //   } catch (e) {
  //     return Left(UnknownFailure(errorMessage: e.toString()));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, Unit>> deleteCategoryData(int categoryId) async {
  //   try {
  //     await localDataSource.deleteCategoryData(categoryId);
  //     return const Right(unit);
  //   } on DatabaseException catch (e) {
  //     return Left(DataDeletionFailure(errorMessage: e.toString()));
  //   } catch (e) {
  //     return Left(UnknownFailure(errorMessage: e.toString()));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, Unit>> updateSpentAmount(int categoryId, double storedSpentAmount) async {
  //   try {
  //     await localDataSource.updateSpentAmount(
  //       categoryId: categoryId,
  //       storedSpentAmount:  storedSpentAmount,
  //     );
  //     return const Right(unit);
  //   } on DatabaseException catch (e) {
  //     return Left(DataUpdateFailure(errorMessage: e.toString()));
  //   } catch (e) {
  //     return Left(UnknownFailure(errorMessage: e.toString()));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, Unit>> setCategoriesData({
  //   required List<TransactionEntity> categories,
  // }) async {
  //   try {
  //     await localDataSource.initializeCategoriesData(categories: categories);
  //     return const Right(unit);
  //   } on DatabaseException catch (e) {
  //     return Left(DataInsertionFailure(errorMessage: e.toString()));
  //   } catch (e) {
  //     return Left(UnknownFailure(errorMessage: e.toString()));
  //   }
  // }

}
