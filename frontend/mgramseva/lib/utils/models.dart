
import 'package:flutter/material.dart';

enum RequestType { GET, PUT, POST, DELETE }

enum ExceptionType {UNAUTHORIZED, BADREQUEST, INVALIDINPUT, FETCHDATA, OTHER, CONNECTIONISSUE}

enum MDMSType {BusinessService, ConsumerType, TaxHeadCode}

class KeyValue {
  String label;
  dynamic key;
  KeyValue(this.label, this.key);
}

class HomeItem {
  final String label;
  final IconData iconData;
  final String link;

  const HomeItem(this.label, this.iconData, this.link);
}


class SuccessHandler {
  final String header;
  final String subtitle;
  final String backButtonText;
  SuccessHandler(this.header, this.subtitle, this.backButtonText);
}

class SearchResult {
 final String label;
 final List<dynamic> result;

  SearchResult(this.label, this.result);
}
