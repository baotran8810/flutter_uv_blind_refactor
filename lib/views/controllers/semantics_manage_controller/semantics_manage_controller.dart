abstract class SemanticsManageController {
  String? get semanticsIdToFocus;

  /// `defocusIfNotAvailable`: For the cases where semantics widget
  /// couldn't be available right away (eg: PageView's pages)
  void focus(
    String semanticsId, {
    bool defocusIfNotAvailable = true,
  });
  void defocus();

  // Those methods are for focusing back the previous focused buton after
  // closing popups (dialogs, dropdowns, etc)

  void setIsFocusing(String semanticsId);
  void queueFocusing();
  void focusQueueing();

  // Call on init & dispose semantics. We make sure that the semanticsId
  // we're trying to focus MUST be available in the widget tree, otherwise
  // a11y focus won't work anymore.
  // Case: Focus delete btn => press to open confirm dialog => OK
  // => previous delete btn wouldn't be there to focus anymore

  void addSemanticsId(String id);
  void removeSemanticsId(String id);
}

const String kPrefixPageTitleSemantics = 'page-title';

// This will be assigned to page's title
String getSemanticsIdOfPageTitle(String routeName) {
  return '$kPrefixPageTitleSemantics---$routeName';
}
