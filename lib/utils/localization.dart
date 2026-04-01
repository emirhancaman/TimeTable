import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'greeting_morning': 'Good Morning ☀️',
      'greeting_day': 'Good Day 🌤️',
      'greeting_evening': 'Good Evening 🌙',
      'greeting_night': 'Good Night 🌑',
      'settings_title': 'Settings',
      'language_label': 'Language',
      'theme_label': 'Theme',
      'theme_dark': 'Dark',
      'theme_light': 'Light',
      'theme_system': 'System',
      'category_work': 'Work',
      'category_personal': 'Personal',
      'category_health': 'Health',
      'category_education': 'Education',
      'category_shopping': 'Shopping',
      'category_other': 'Other',
      'new_plan': 'New Plan',
      'plan_title': 'Plan Title',
      'delete_plan': 'Delete Plan',
      'delete_confirm': 'Are you sure you want to delete this plan?',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'save': 'Save',
      'add': 'Add',
      'edit': 'Edit',
      'empty_state': 'No plans yet',
      'empty_state_desc': 'Start by adding your first plan',
      'completed': 'Completed',
      'plan_type_one_time': 'One Time',
      'plan_type_weekly': 'Weekly',
      'plan_type_selected_days': 'Selected Days',
      'repeat_days': 'Repeat Days',
      'select_days': 'Select Days',
      'day_mon': 'Mon',
      'day_tue': 'Tue',
      'day_wed': 'Wed',
      'day_thu': 'Thu',
      'day_fri': 'Fri',
      'day_sat': 'Sat',
      'day_sun': 'Sun',
      'category_all': 'All',
      'this_week': 'This Week',
      'select_focus': 'Select Focus',
      'tap_to_track': 'Tap to track',
      'focus_area': 'Focus Area',
      'my_plans': 'My Plans',
      'category_name_label': 'Category Name',
      'subcategory_name_label': 'Subcategory Name',
      'no_date': 'No date',
    },
    'tr': {
      'greeting_morning': 'Günaydın ☀️',
      'greeting_day': 'İyi Günler 🌤️',
      'greeting_evening': 'İyi Akşamlar 🌙',
      'greeting_night': 'İyi Geceler 🌑',
      'settings_title': 'Ayarlar',
      'language_label': 'Dil',
      'theme_label': 'Tema',
      'theme_dark': 'Koyu',
      'theme_light': 'Açık',
      'theme_system': 'Sistem',
      'category_work': 'İş',
      'category_personal': 'Kişisel',
      'category_health': 'Sağlık',
      'category_education': 'Eğitim',
      'category_shopping': 'Alışveriş',
      'category_other': 'Diğer',
      'new_plan': 'Yeni Plan',
      'plan_title': 'Plan Başlığı',
      'delete_plan': 'Planı Sil',
      'delete_confirm': 'Bu planı silmek istediğinizden emin misiniz?',
      'cancel': 'İptal',
      'delete': 'Sil',
      'save': 'Kaydet',
      'add': 'Ekle',
      'edit': 'Düzenle',
      'empty_state': 'Henüz plan yok',
      'empty_state_desc': 'İlk planınızı ekleyerek başlayın',
      'completed': 'Tamamlandı',
      'plan_type_one_time': 'Tek Kullanımlık',
      'plan_type_weekly': 'Haftalık',
      'plan_type_selected_days': 'Seçili Günlerde',
      'repeat_days': 'Tekrar Günleri',
      'select_days': 'Günleri Seçin',
      'day_mon': 'Pzt',
      'day_tue': 'Sal',
      'day_wed': 'Çar',
      'day_thu': 'Per',
      'day_fri': 'Cum',
      'day_sat': 'Cmt',
      'day_sun': 'Paz',
      'category_all': 'Tümü',
      'this_week': 'Bu Hafta',
      'select_focus': 'Bir Odak Seçin',
      'tap_to_track': 'Takip etmek için dokunun',
      'focus_area': 'Odak Alanı',
      'my_plans': 'Planlarım',
      'category_name_label': 'Kategori Adı',
      'subcategory_name_label': 'Alt Kategori Adı',
      'no_date': 'Tarih yok',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
