// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Flutter Riverpod Course 2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: const HomePage(),
      ),
    ),
  );
}

// Here we are creating an infix operator extension that,
// enables null values to be operated on without returning an error.
extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

// Now we create a class the records the state changes
class Counter extends StateNotifier<int?> {
  Counter() : super(null);
  void increment() => state = state == null ? 1 : state + 1;
  int? get value => state;
}

// Now we create a provider that relates this change in the state, increment to the UI.
final counterProvider = StateNotifierProvider<Counter, int?>(
  (ref) => Counter(),
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Here we use watch to watch for changes and rebuild the scaffold when the provider changes.
    // final counter = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Now, here we wish to use the appBar to display the actual count value.
        // We are doing this because we don't want the entire widget to be rebuild.
        title: Consumer(
          builder: (context, ref, child) {
            final counter = ref.watch(counterProvider);
            final text =
                counter == null ? 'Press the Button' : counter.toString();
            return Text(text);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () {
              // Here we use the provider's notifier function to get the notifier function.
              // using read gets the current snapshot of the value in the provider.
              ref.read(counterProvider.notifier).increment();
            },
            child: const Text(
              'Increment Counter',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
