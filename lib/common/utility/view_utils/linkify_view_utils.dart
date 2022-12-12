import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum _LinkType {
  phoneNumber,
  email,
  address,
  url,
}

class _LinkResult {
  final _LinkType type;
  final String text;

  const _LinkResult({
    required this.type,
    required this.text,
  });
}

class LinkifyViewUtils {
  //regex phone number
  static final RegExp _phoneNumberRegex = RegExp(
      r'[+＋]*[(]{0,1}[0-9|０-９]{1,4}[)]{0,1}[-ー\\s/(0-9|０-９)\\s/0-9|０-９]{9,11}');

  //regex email
  static final RegExp _emailRegex = RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  //regex url
  static final RegExp _urlRegex = RegExp(
      r"(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})");
  static final RegExp _urlRegexHttp = RegExp(
      r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)");

  //regex adress
  static const String _postalCode =
      r'(?:(〒[0-9０-９]{3}[-－−][0-9０-９]{4})[\n\s　]*)?';
  static const String _prefectureOrMunicipalityOrMachichoson =
      r'([^\n\s　;<>。、,，.]{2,5}[都道府県市区町村]){1,3}';
  static const String _cityDistrictName = '([^\n;<>。、.,，0-9０-９]{2,})';
  static const String _specialCase =
      "([0-9０-９一二三四五六七八九]+条[^\\n\\s　;<>。、，.,0-9０-９]+)?";
  static const String _cityDictrictNumber =
      "((?:[0-9０-９一二三四五六七八九]+|(?:[-－−]|(?:丁目|番地?|号))){3,7})";
  static const String _building = "((?:[^\\n;<>。、，.,]+ビル)?)";
  static const String _floor =
      "((?:[^\\n;<>。、，.,0-9０-９]*[0-9０-９一二三四五六七八九]+[階F])?)";
  static final RegExp _addressRegex = RegExp(_postalCode +
      _prefectureOrMunicipalityOrMachichoson +
      _cityDistrictName +
      _specialCase +
      _cityDictrictNumber +
      _building +
      _floor);

  static _LinkType? _checkType(String input) {
    if (_emailRegex.hasMatch(input)) {
      return _LinkType.email;
    }
    if (_addressRegex.hasMatch(input)) {
      return _LinkType.address;
    }

    if (_urlRegex.hasMatch(input)) {
      return _LinkType.url;
    }
    if (_phoneNumberRegex.hasMatch(input)) {
      return _LinkType.phoneNumber;
    }
  }

  static _LinkResult? _extractLink(String input) {
    final linkType = _checkType(input);

    if (linkType == null) {
      return null;
    }

    String? match;
    switch (linkType) {
      case _LinkType.phoneNumber:
        match = _phoneNumberRegex.stringMatch(input);
        break;
      case _LinkType.email:
        match = _emailRegex.stringMatch(input);
        break;
      case _LinkType.address:
        match = _addressRegex.stringMatch(input);
        break;
      case _LinkType.url:
        match = _urlRegex.stringMatch(input);
        break;
    }

    if (match == null) {
      return null;
    }

    return _LinkResult(
      type: linkType,
      text: match,
    );
  }

  static String? getURL(String rawText) {
    return _urlRegexHttp.stringMatch(rawText);
  }

  static void _launchLink(_LinkResult linkResult) {
    final linkText = linkResult.text;
    switch (linkResult.type) {
      case _LinkType.phoneNumber:
        launch("tel://$linkText");
        break;
      case _LinkType.email:
        sendEmail(linkText);
        break;
      case _LinkType.address:
        launch(
          Uri.encodeFull('https://www.google.com/search?q=$linkText'),
        );
        break;
      case _LinkType.url:
        final url =
            !linkText.contains("https://") ? "https://$linkText" : linkText;
        launch(Uri.encodeFull(url));
        break;
    }
  }

  static bool isHyperlink(String text) {
    final result = LinkifyViewUtils._extractLink(text);
    if (result != null) {
      return true;
    }
    return false;
  }

  static void launchText(String text) {
    final result = LinkifyViewUtils._extractLink(text);
    if (result != null) {
      _launchLink(result);
    }
  }

  static void sendEmail(String match) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: match,
      query: encodeQueryParameters(<String, String>{'subject': ''}),
    );
    launch(emailLaunchUri.toString());
  }

  static TextSpan getTextSpan(String text, Color? color) {
    final result = LinkifyViewUtils._extractLink(text);

    if (result != null) {
      final String linkText = result.text;

      final List<String> listString = text.split(linkText);

      if (listString.length == 2) {
        return TextSpan(
          children: [
            TextSpan(
              style: TextStyle(color: color ?? Colors.black),
              text: listString[0],
            ),
            TextSpan(
                text: linkText,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchLink(result);
                  }),
            TextSpan(
              style: TextStyle(color: color ?? Colors.black),
              text: listString[1],
            ),
          ],
        );
      }
    }

    return TextSpan(
      text: text,
      style: TextStyle(
        color: color ?? Colors.black,
      ),
    );
  }
}
