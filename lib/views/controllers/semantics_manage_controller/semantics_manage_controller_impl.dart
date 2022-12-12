import 'package:flutter_uv_blind_refactor/views/controllers/semantics_manage_controller/semantics_manage_controller.dart';
import 'package:get/get.dart';

class SemanticsManageControllerImpl implements SemanticsManageController {
  final Rx<String?> _semanticsIdToFocus = Rx(null);
  @override
  String? get semanticsIdToFocus => _semanticsIdToFocus.value;

  String? _focusingSemanticsId;
  String? _queueSemanticsId;

  final List<String> _activeSemanticsIdList = [];

  @override
  void focus(
    String id, {
    bool defocusIfNotAvailable = true,
  }) {
    _semanticsIdToFocus.value = id;

    if (defocusIfNotAvailable) {
      _defocusIfNotAvailable(id);
    }
  }

  void _defocusIfNotAvailable(String id) {
    // Return if that semantics is page title semantics, because we
    // can have multiple titles with the same semantics id if they're
    // the same route
    if (id.contains(kPrefixPageTitleSemantics)) {
      return;
    }

    if (_activeSemanticsIdList.contains(id)) {
      return;
    }

    // Likely that we're trying to focus on a disposed semantics
    defocus();
  }

  @override
  void defocus() {
    _semanticsIdToFocus.value = null;
  }

  @override
  void setIsFocusing(String id) {
    _focusingSemanticsId = id;
  }

  @override
  void queueFocusing() {
    _queueSemanticsId = _focusingSemanticsId;
  }

  @override
  void focusQueueing() {
    if (_queueSemanticsId == null) {
      return;
    }

    focus(_queueSemanticsId!);
    _queueSemanticsId = null;
  }

  @override
  void addSemanticsId(String id) {
    _activeSemanticsIdList.add(id);
  }

  @override
  void removeSemanticsId(String id) {
    _activeSemanticsIdList.remove(id);

    if (id == semanticsIdToFocus && !_activeSemanticsIdList.contains(id)) {
      // Wait for the widget to dispose
      Future.delayed(Duration.zero, () {
        defocus();
      });
    }
  }
}
