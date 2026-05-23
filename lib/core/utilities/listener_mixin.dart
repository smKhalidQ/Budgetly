import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin StreamListener on Closable {
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  void listen<T>(Stream<T> stream, void Function(T event)? onData) {
    final subscription = stream.listen(onData);
    _subscriptions.add(subscription);
  }

  @override
  Future<void> close() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();
    return super.close();
  }
}
