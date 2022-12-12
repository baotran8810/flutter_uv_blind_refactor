import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/main.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

abstract class AppGetView<T> extends StatefulWidget {
  final T initialController;

  /// Must set this to `true` if use [onPushNext]/[onPopNext]
  final bool doRegisterRouteAware;

  const AppGetView({
    Key? key,
    required this.initialController,
    this.doRegisterRouteAware = false,
  }) : super(key: key);

  @override
  _AppGetViewState<T> createState() => _AppGetViewState<T>();

  Widget build(BuildContext context, T controller);

  // Route aware
  void onPushNext(T controller) {}
  void onPopNext(T controller) {}
}

class _AppGetViewState<T> extends State<AppGetView<T>> with RouteAware {
  final String _tag = const Uuid().v4();

  T get controller => Get.find<T>(tag: _tag);

  @override
  void initState() {
    super.initState();

    Get.put<T>(widget.initialController, tag: _tag, permanent: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.doRegisterRouteAware) {
      final modalRoute = ModalRoute.of(context);
      if (modalRoute is PageRoute) {
        appRouteObserver.subscribe(this, modalRoute);
      }
    }
  }

  @override
  void dispose() {
    if (widget.doRegisterRouteAware) {
      appRouteObserver.unsubscribe(this);
    }

    Get.delete<T>(tag: _tag, force: true);

    super.dispose();
  }

  @override
  void didPushNext() {
    if (!widget.doRegisterRouteAware) {
      throw Exception(
        'CUSTOM: To use this function, doRegisterRouteAware must be set to true',
      );
    }

    widget.onPushNext(controller);
  }

  @override
  void didPopNext() {
    if (!widget.doRegisterRouteAware) {
      throw Exception(
        'CUSTOM: To use this function, doRegisterRouteAware must be set to true',
      );
    }

    widget.onPopNext(controller);
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, controller);
  }
}
