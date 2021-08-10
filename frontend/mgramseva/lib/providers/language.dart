import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/services/LocalStorage.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/services/RequestInfo.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/custom_exception.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:universal_html/html.dart';

class LanguageProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  StateInfo? stateInfo;

  dispose() {
    streamController.close();
    super.dispose();
  }


  Future<void> getLocalizationData(BuildContext context) async {

    try {
      var localizationList = await CoreRepository().getMdms(initRequestBody({"tenantId":"pb"}));
      stateInfo = localizationList.mdmsRes?.commonMasters?.stateInfo?.first;
      if (stateInfo != null) {
        stateInfo?.languages?.first.isSelected = true;
        setSelectedState(stateInfo!);
        await ApplicationLocalizations(
                Locale(selectedLanguage?.label ?? '', selectedLanguage?.value))
            .load();
      }
      streamController.add(localizationList.mdmsRes?.commonMasters?.stateInfo ?? <StateInfo>[]);
    } on CustomException catch (e,s) {
      ErrorHandler.handleApiException(context, e,s);
      streamController.addError('error');
    }catch (e,s) {
      ErrorHandler.logError(e.toString(),s);
      streamController.add('error');
    }
  }

  void onSelectionOfLanguage(
      Languages language, List<Languages> languages) async {
    if (language.isSelected) return;
    languages.forEach((element) => element.isSelected = false);
    language.isSelected = true;
    setSelectedState(stateInfo!);
    await ApplicationLocalizations(
            Locale(selectedLanguage?.label ?? '', selectedLanguage?.value))
        .load();
    notifyListeners();
  }

  void setSelectedState(StateInfo stateInfo) {
    if (kIsWeb) {
      window.localStorage[Constants.STATES_KEY] =
          jsonEncode(stateInfo.toJson());
    } else {
      storage.write(
          key: Constants.STATES_KEY, value: jsonEncode(stateInfo.toJson()));
    }
  }

  Languages? get selectedLanguage =>
      stateInfo?.languages?.firstWhere((element) => element.isSelected);
}
