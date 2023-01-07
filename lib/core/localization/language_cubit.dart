import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template_app/core/localization/generated/l10n.dart';

String currentLanguage = "${LanguageCubit.baseLanguage.languageCode}_${LanguageCubit.baseLanguage.countryCode ?? ""}";
bool currentLanguageIsSystemLocal = false;

class LanguageCubit extends Cubit<Locale> {
  static const String keyIsSystemLocal = 'isSystemLocal';
  static const String keyLanguageCode = 'languageCode';
  static const String keyCountryCode = 'countryCode';

  static Locale baseLanguage = const Locale("en", "");

  LanguageCubit() : super(baseLanguage);

  void changeStartLanguage({bool checkCountryCodeInSystemLocal = false}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isSystemLocal = preferences.getBool(keyIsSystemLocal);
    if(isSystemLocal != null){
      if(isSystemLocal){
        List<dynamic> list = getSystemLocal(checkCountryCodeInSystemLocal: checkCountryCodeInSystemLocal);
        currentLanguageIsSystemLocal = true;
        currentLanguage = list[0] + "_" + list[1];
        emit(Locale(list[0], list[1]));
      }else{
        String? languageCode = preferences.getString(keyLanguageCode);
        String? countryCode = preferences.getString(keyCountryCode);

        if(languageCode != null){
          currentLanguageIsSystemLocal = false;
          currentLanguage = "${languageCode}_${countryCode ?? ""}";

          emit(Locale(languageCode, countryCode));
        }
      }
    }
  }

  List<dynamic> getSystemLocal({required bool checkCountryCodeInSystemLocal}){
    bool isSystemLocal = false;
    String languageCode = "";
    String countryCode = "";

    Locale systemLocal = Locale(
      Platform.localeName.split('_')[0],
        checkCountryCodeInSystemLocal ? Platform.localeName.split('_')[1] : ""
    );

    for (var element in I10n.delegate.supportedLocales){
      if(element == systemLocal){
        isSystemLocal = true;
        languageCode = systemLocal.languageCode;
        countryCode = systemLocal.countryCode ?? "";
        continue;
      }
    }
    if(languageCode == ""){
      languageCode = baseLanguage.languageCode;
      countryCode = baseLanguage.countryCode ?? "";
    }

    return [languageCode, countryCode, isSystemLocal];
  }

  void changeLanguage(BuildContext context, {required String languageCode, String countryCode = "", bool checkCountryCodeInSystemLocal = false}) async {
    bool isSystemLocal = false;
    if(languageCode == ""){
      List<dynamic> list = getSystemLocal(checkCountryCodeInSystemLocal: checkCountryCodeInSystemLocal);
      languageCode = list[0];
      countryCode = list[1];
      isSystemLocal = list[2];
    }

    emit(Locale(languageCode, countryCode));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    currentLanguageIsSystemLocal = isSystemLocal;
    currentLanguage = "${languageCode}_$countryCode";

    await preferences.setString(keyLanguageCode, languageCode);
    await preferences.setString(keyCountryCode, countryCode);
    await preferences.setBool(keyIsSystemLocal, isSystemLocal);
  }
}
