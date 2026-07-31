<div align="center">
  <img src="../assets/icon/app_icon_v2.png" alt="TimeTable ikonu" width="112" />

  # TimeTable

  **Yoğun günleri net adımlara dönüştüren, çevrimdışı öncelikli planlayıcı.**

  [English README](../README.md)
</div>

---

TimeTable; günlük planları, tekrarlanan rutinleri ve odak alanlarını tek yerde yönetmek için Flutter ile geliştirilmiş bir üretkenlik uygulamasıdır. Hive kullanan yerel veri katmanı sayesinde hesap açmadan ve internet bağlantısı olmadan çalışır.

## Özellikler

- Tek seferlik, haftalık veya seçili günlerde tekrarlanan planlar
- Kategori, alt kategori, öncelik ve favori desteği
- Odak alanı ve tamamlanma ilerlemesi takibi
- Türkçe/İngilizce dil ve açık/koyu tema seçenekleri
- Android ana ekranında sıradaki planı gösteren widget
- Bulut hesabı gerektirmeyen yerel veri saklama

## Kurulum

Flutter 3.38+ ve Dart 3.10+ kurulu olmalıdır.

```bash
git clone https://github.com/emirhancaman/TimeTable.git
cd TimeTable
flutter pub get
flutter run
```

Hive modelleri değiştiğinde adaptörleri yeniden üretin:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Kalite kontrolleri

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test
```

Teknik yapı için [mimari belgesine](ARCHITECTURE.md), katkı süreci için [CONTRIBUTING.md](../CONTRIBUTING.md) dosyasına bakın.
