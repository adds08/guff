import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guff/core/routing/route_manager.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("🙏", style: Theme.of(context).textTheme.displayLarge),
            SizedBox(height: 21),
            Text("Namaste", style: Theme.of(context).textTheme.displayMedium),
            SizedBox(height: 26),
            Text("Welcome to Guff App", style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 26),
            SizedBox(width: 120, child: LinearProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
