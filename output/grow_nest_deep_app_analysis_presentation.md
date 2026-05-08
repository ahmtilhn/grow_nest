# MiniAdimlar / Grow Nest Derin Uygulama Analizi

Tarih: 6 Mayis 2026  
Kapsam: Flutter uygulama kodu, yerel veri katmani, Firebase senkronizasyonu, Firestore kurallari, testler, mevcut egitim icerikleri ve AAP/HealthyChildren kaynak uyumu.

---

## 1. Yonetici Ozeti

MiniAdimlar iyi niyetli, sakin tonlu ve teknik olarak temiz bir MVP. `flutter analyze` temiz, `flutter test` tum testleri geciyor. Uygulama offline-first mimari, Drift yerel veritabani, Firebase Auth/Firestore senkronizasyonu, aile davetleri, bildirim plani, bebek/gebelik modu, takip kayitlari, asi takvimi ve egitim makaleleri gibi genis bir temel kurmus.

Ana sorun: teknik temel, urun iddiasindan daha hizli buyumus. Bazi ekranlar ve metinler kullaniciya tamamlanmis hissi veriyor ama altta henuz MVP/placeholder davranisi var. Saglik odakli bir ebeveyn uygulamasinda bu fark guven, kaygi ve klinik uygunluk acisindan kritik.

Genel olgunluk puanlari:

| Alan | Puan | Durum |
|---|---:|---|
| Teknik stabilite | 82/100 | Analyze ve testler temiz, mimari iyi. |
| UX akiskanligi | 72/100 | Ana akislari var; bazi rota, metin ve placeholder sorunlari var. |
| AAP uyumu | 68/100 | Cekirdek AAP konulari var; asi, fever triage, oral health, screen time, choking eksik. |
| Kullanici psikolojisi | 74/100 | Sakin ve sucluluk azaltan dil guclu; fake social proof ve "AI danisman" iddiasi riski var. |
| Urun hazirlik seviyesi | 63/100 | MVP guclu, ama "medical-grade" algisi icin henuz erken. |

---

## 2. Kanit ve Metodoloji

Incelenen yerel kanitlar:

| Kanit | Bulgu |
|---|---|
| Dart kaynaklari | 41 ana Dart dosyasi, yaklasik 24.688 satir uygulama kodu, generated dosyalar haric. |
| Feature alanlari | 15 feature klasoru: auth, onboarding, dashboard, tracker, sleep, vaccines, education, family, profile vb. |
| Testler | 17 test senaryosu; hepsi gecti. |
| Icerik | 11 seed makale: 8 bebek, 3 gebelik. |
| Gorsel varlik | 14 image asset. |
| Firebase | Auth, Firestore, Data Connect uretimleri ve guvenlik kurallari mevcut. |

Kosulan komutlar:

```text
flutter analyze
flutter test
```

Sonuc:

```text
No issues found
All tests passed
```

---

## 3. Uygulama Haritasi

Ana modlar:

| Mod | Baslangic ekrani | Temel islev |
|---|---|---|
| Gebelik | PregnancyDashboardScreen | Hafta/gun, su, vitamin, randevu, ruhsal destek, gunluk. |
| Bebek | BabyDashboardScreen | Son beslenme, bez, uyku, buyume, asi, hizli kayit. |
| Planlama | UI'da secenek var | Mantikta ayri ele alinmiyor; gebelik akisi gibi tamamlaniyor. |

Ana navigasyon:

| Rota | Ekran | Not |
|---|---|---|
| `/login`, `/register`, `/forgot-password` | Auth ekranlari | Firebase varsa gercek auth, hata olursa local fallback. |
| `/onboarding` | OnboardingFlow | Medikal/gizlilik onayi var. |
| `/growth` | GrowthRootScreen | Moda gore gebelik veya bebek dashboard. |
| `/tracker` | TrackerScreen | Bebek veya gebelik tracker. |
| `/journal` | JournalScreen | Anilar ve gunluk not. |
| `/education` | EducationScreen | Seed makaleler, arama, kaydetme. |
| `/vaccines` | VaccineCalendarScreen | CDC/AAP temelli asi listesi. |
| `/family` | ProfileScreen | Kritik: FamilyScreen yazilmis ama rota ona bagli degil. |

---

## 4. Guclu Yanlar

Uygulamanin iyi yaptiklari:

| Alan | Degerlendirme |
|---|---|
| Offline-first | Drift + yerel snapshot yapisi ebeveyn uygulamasi icin dogru. Bakim kaydi internet beklememeli. |
| Medikal uyarilar | Global `MedicalWarningCard` var; teshis yerine gecmedigi soyleniyor. |
| Aile paylasimi | Davet, kabul, ortak kayit bildirimi ve Firestore kurallari dusunulmus. |
| Duygusal ton | Gebelik ve beslenme metinlerinde sucluluk azaltici, destekleyici dil var. |
| Veri modeli | `RecordType`, `ReminderCategory`, `VaccineEvent`, `Article`, `AppSnapshot` iyi ayrilmis. |
| Test odagi | Beslenme zamanlamasi, hatirlatici, AI acil yonlendirme, aile davetleri testlenmis. |

---

## 5. Kritik Eksikler ve Yarim Kalan Isler

| Oncelik | Bulgu | Kanit | Etki |
|---|---|---|---|
| P0 | `/family` rotasi `FamilyScreen` yerine `ProfileScreen`e gidiyor. | `lib/app/router/app_router.dart:171-175` | Yazilmis aile calisma alani kullaniciya kapali kaliyor. |
| P0 | Asi tamamlama remote sync eski snapshot'i senkronluyor. | `lib/app/app_controller.dart:422-438` | Kullanici "tamamlandi" dese bile Firestore'a eski `upcoming/overdue` durumu gidebilir. |
| P0 | Saglik kaydinda AI analiz sonucu ekranda kullanilmiyor; urgent/routine ayni karti gosteriyor. | `lib/features/tracker/record_form_screen.dart:201-205` | Acil durumda kullaniciya ayrismis eylem verilmiyor. |
| P0 | Planning onboarding secimi ayri tamamlanmiyor; gebelik gibi davraniliyor. | `lib/features/onboarding/onboarding_flow.dart:69-83` | "Hamilelik planliyorum" diyen kullanici yanlis bakim moduna alinabilir. |
| P1 | FamilyScreen icinde "Oturumu Kapat" yerel verileri sifirlama dialoguna bagli. | `lib/features/family/family_screen.dart:220-267` | Veri kaybi algisi ve guven problemi. |
| P1 | Tracker'da dummy grafik ve iddiali metinler var. | `lib/features/tracker/tracker_screen.dart:139-156` | Kullanici gercek veri sanabilir. |
| P1 | "24 anne daha burada" hardcoded sosyal kanit. | `lib/features/pregnancy/pregnancy_dashboard.dart:137-143` | Gercek degilse guven zedeler. |
| P1 | Local auth fallback herhangi e-posta/sifreyi oturum gibi kabul ediyor. | `lib/core/firebase/firebase_auth_gateway.dart:64-84` | Prod ortaminda Firebase init hatasi olursa guvenlik algisi bozulur. |
| P1 | Gizlilik/veri paylasimi ayarlari "sonra yapilandirilacak" dialogu. | `showConfiguredLaterDialog`, profil/family linkleri | Saglik verisi uygulamasinda legal/consent eksigi. |
| P2 | TR lokalizasyonunda nav etiketleri Ingilizce. | `lib/app/localization/tr.json:20-23` | Yerellesme kalite hissini dusurur. |

---

## 6. AAP Uygunlugu: Genel Degerlendirme

Uygulama AAP uyumluluguna yaklasiyor, ama "AAP temelli rehber" iddiasi icin kaynak derinligi ve klinik ayrimlar eksik.

Guculu AAP eslesmeleri:

| Konu | Uygulamadaki durum | Uyum |
|---|---|---|
| Guvenli uyku | Sirtustu, sert/duz yuzey, bos beşik, yatak paylasmama anlatiliyor. | Iyi |
| Ek gida | Hazirlik isaretleri ve alerjenleri gereksiz geciktirmeme var. | Iyi |
| Emzirme | Ilk 6 ay ve devam destegi var; sucluluk azaltici ton iyi. | Iyi |
| Saglam cocuk ziyaretleri | Bright Futures temaslari var. | Orta-iyi |
| WHO buyume egri notu | 0-2 yas WHO, 2 yas sonrasi CDC ifadesi var. | Orta |

Zayif veya eksik AAP alanlari:

| Konu | Eksik |
|---|---|
| Fever triage | 3 aydan kucuk bebekte 38.0 C / 100.4 F gibi yas temelli aciliyet ayrimi UI'da yok. |
| Asi takvimi | Takvim 30 gun ay offset'iyle yaklasik; 2026 AAP schedule kaynak baglantisi yok. |
| Oral health | Ilk dis, florur, ilk dis hekimi ziyareti, dis temizligi yok. |
| Choking / first aid | Tracker'da "Bonaza" yazim hatali acil durum karti var; AAP choking guidance yok. |
| Screen time | 18 aydan kucuklerde medya/video chat ayrimi yok. |
| Car seat | Rear-facing, uygun koltuk ve guvenlik yok. |
| Caregiver mental health | Dogum sonrasi depresyon, ebeveyn tukenmisligi, sarsilmis bebek onleme yok. |
| Developmental surveillance | Milestone tarama, doktorla konusma sinyalleri ve "alarm degil trend" mantigi eksik. |

Kullanilan resmi kaynaklar:

- AAP Safe Sleep: https://www.aap.org/en/patient-care/safe-sleep/
- AAP Immunizations / 2026 AAP Immunization Schedule hub: https://www.aap.org/en/patient-care/immunizations/
- HealthyChildren Starting Solid Foods: https://www.healthychildren.org/English/ages-stages/baby/feeding-nutrition/Pages/Starting-Solid-Foods.aspx
- HealthyChildren Breastfeeding: https://www.healthychildren.org/English/ages-stages/baby/breastfeeding/pages/Where-We-Stand-Breastfeeding.aspx
- HealthyChildren Fever: https://www.healthychildren.org/english/health-issues/conditions/fever/pages/default.aspx
- Bright Futures periodicity/family-centered care: https://www.aap.org/en/practice-management/bright-futures/
- CDC growth chart training with AAP note: https://www.cdc.gov/growth-chart-training/hcp/using-growth-charts/who-summary.html

---

## 7. Daha Fazla Eklenmesi Gereken AAP/HealthyChildren Makaleleri

Onerilen yeni makale backlog'u:

| Baslik | Kategori | Neden gerekli |
|---|---|---|
| 3 Aydan Kucuk Bebekte Ates | Saglik | Acil yonlendirme yas bazli olmali. |
| Bebeklerde Bogulma ve Guvenli Ek Gida | Ilk Yardim/Beslenme | Solid food akisi choking guvenligiyle tamamlanmali. |
| Ilk Dis ve Agiz Bakimi | Gelisim | Ilk dis gorseli var ama icerik yok. |
| Araba Koltugu: Rear-Facing Guvenlik | Guvenlik | Bebek guvenligi icin temel AAP konusu. |
| Ekran Suresi ve Dijital Medya | Gelisim | Ebeveyn uygulamalarinda sik soru. |
| Dogum Sonrasi Depresyon ve Kaygi | Ruh Sagligi | Kullanici psikolojisini dogrudan iyilestirir. |
| Aglanda Sakin Kalma ve Guvenli Teselli | Ruh Sagligi/Guvenlik | Bakim veren stresini azaltir; zarar onleme. |
| Gelisimsel Kilometre Taslari | Gelisim | "Super gelisim" yerine izlem ve doktorla konusma sinyalleri. |
| Ilac Guvenligi ve Doz Hatirlatici | Saglik | Hatirlatici var; medikal risk dilinin guclenmesi gerek. |
| Alerji Belirtileri ve Ne Zaman Yardim Alinmali | Beslenme/Saglik | Alerjen makalesinin acil durum parcasi eksik. |
| Asi Randevusuna Hazirlik | Asi | Takvimden randevuya pratik gecis. |
| Guvenli Uyku Alani Kontrol Listesi | Uyku | Mevcut icerigi checklist formatina cevirmek UX'i guclendirir. |

---

## 8. Sayfa Sayfa UX Analizi

### 8.1 Login / Register / Forgot Password

Dogru:

| Alan | Degerlendirme |
|---|---|
| Basit giris | E-posta, sifre, Google akisi sade. |
| Form validasyonu | E-posta ve minimum sifre uzunlugu kontrol ediliyor. |
| Offline mesaj | Kayitlarin once cihazda tutuldugu anlatiliyor. |

Gelisecek:

| Sorun | Oneri |
|---|---|
| Firebase init hatasinda local auth devreye giriyor ve herhangi sifre ile giris olabiliyor. | Prod build'de local fallback'i kapat; sadece emulator/dev icin kullan. |
| Hata mesajlari teknik olabilir. | Firebase hata kodlarini insani mesaja cevir. |
| Google butonu gercek marka standardindan uzak. | Google Sign-In marka kurallarina uygun button. |

Psikolojik etki: Hos geldin tonu iyi. Ancak "Firebase ile baglanir" teknik metni ebeveyn icin gereksiz; guvenlik ve mahremiyet dili daha sade olmali.

### 8.2 Onboarding

Dogru:

| Alan | Degerlendirme |
|---|---|
| Baslangic secimi | Gebelik, bebek, planlama secenekleri var. |
| Medikal onay | Saglik sorumlulugu icin temel bir guardrail var. |
| Profil bilgisi | Bebek dogum bilgileri ve olcumler erken aliniyor. |

Yanlis / eksik:

| Sorun | Kanit | Oneri |
|---|---|---|
| Planlama modu ayri islenmiyor. | `_mode == baby` degilse pregnancy onboarding. | Planlama icin ayri profil: hedef, son adet tarihi opsiyonel, ACOG/AAP olmayan gebelik oncesi kaynaklar. |
| Gizlilik onayi checkbox var ama belge yok. | Consent step sadece metin. | KVKK/GDPR/HIPAA-benzeri acik veri metni ve acil durum disclaimer sayfasi. |
| Tarih defaultlari baglamsiz. | Bebek icin 102 gun once, gebelik icin 196 gun sonra. | "Son adet tarihi / tahmini dogum / dogum tarihi" secimini acik et. |

Psikolojik etki: Kontrol hissi veriyor; ancak planlama kullanicisini gebelik gibi ele almak hassas olabilir.

### 8.3 Home Shell / Ana Navigasyon

Dogru:

| Alan | Degerlendirme |
|---|---|
| 3 ana tab | Growth, Tracker, Journal basit ve odakli. |
| FAB | Hizli kayit mantigi ebeveyn uygulamasi icin dogru. |
| Bildirim badge | Aile ve hatirlatici akisini gorunur kiliyor. |

Gelisecek:

| Sorun | Oneri |
|---|---|
| TR nav etiketleri Ingilizce. | `Growth`, `Tracker`, `Journal`, `Family` -> `Gelisim`, `Takip`, `Gunluk`, `Aile`. |
| Egitim ve aile ana nav disinda kalmis. | Aile profilde kalabilir ama rota dogru ekrana baglanmali; egitim dashboard CTA'lari yeterli. |

### 8.4 Gebelik Dashboard

Dogru:

| Alan | Degerlendirme |
|---|---|
| Haftalik ritim | Kullanicinin bugun yapabilecegi kucuk adimlar iyi. |
| Su/vitamin izleme | Gebelik modunda beklenen destek. |
| Ruhsal destek tonu | Kaygiyi saklamama ve destek isteme dili iyi. |

Yanlis / risk:

| Sorun | Kanit | Oneri |
|---|---|---|
| "Seninle ayni haftada olan 24 anne" gercek veri degil. | Hardcoded metin. | Gercek community yoksa kaldir; "Bu haftanin hazirlik listesi" yap. |
| Su hedefi medikal baglama bagli degil. | Default 2.0 L. | "Doktorun farkli oneriyse onu uygula" metni ve ozellestirme. |
| Gebelik icerikleri ACOG agirlikli; AAP sadece dogum sonrasi hazirlikta. | Seed articles. | AAP yeni dogan hazirlik, safe sleep, feeding once-birth plan makaleleri ekle. |

Psikolojik etki: Gunluk minik rutinler iyi; sahte sosyal kanit guven duygusunu zedeleyebilir.

### 8.5 Bebek Dashboard

Dogru:

| Alan | Degerlendirme |
|---|---|
| Son kayit kartlari | Ebeveynin en cok sordugu "en son ne zaman" sorusuna cevap veriyor. |
| Buyume kartlari | Kilo, boy, bas cevresi ayrimi guzel. |
| Asi yaklasimi | Siradaki asi gorunur. |
| Uyku ozeti | Yas hedefiyle gunluk uykuyu karsilastiriyor. |

Risk / eksik:

| Sorun | Kanit | Oneri |
|---|---|---|
| `SÜPER GELİŞİM` etiketi gereksiz iddiali. | Dashboard chip. | "Bugunku ozet" veya "Takipte" gibi sakin metin. |
| AI yorumu mock ve build basina FutureBuilder. | `MockAiAnalysisService`, dashboard FutureBuilder. | Gercek AI yoksa "Ozet" de; async hesaplamayi state'e al. |
| Buyume referansi cinsiyet ayrimi yapmiyor. | `GrowthReference` tek tablo. | WHO sex-specific data, percentile trend grafikleri, "tek olcum degil trend" UI. |
| Sonraki asi tarihlerinde 30 gun ay offset'i. | `monthOffset * 30`. | Dogum tarihine calendar month ekleme ve resmi schedule exceptions. |

Psikolojik etki: Hemen ozet almak iyi; "super" ve AI dili gereksiz performans baskisi yaratabilir.

### 8.6 Tracker

Dogru:

| Alan | Degerlendirme |
|---|---|
| Bebek ve gebelik icin farkli kayit seti | Dogru bilgi mimarisi. |
| Saglik/belirti hizli aksiyonlari | Bakim gunlugunu kolaylastirir. |
| Son kayitlar | Partner/aile kayitlarini gormek iyi. |

Yanlis / eksik:

| Sorun | Kanit | Oneri |
|---|---|---|
| "Haftalik Kalori Alimi" dummy veri. | Sabit `[3.0, 2.5...]`. | Gercek beslenme ml/ogun grafigi veya kaldir. |
| "AI destekli danisman" iddiasi agir. | Tracker hero. | "Kayitlardan ozet" veya "Guvenilir rehberler" yap. |
| "Bonaza bir sey kacmasi" yazim hatasi ve yanlis ifade. | Acil durum karti. | AAP choking ilk yardim makalesine bagla. |
| "5 temel super gida" iddiasi AAP diline uygun degil. | Beslenme karti. | "Alerjenleri guvenli ve tek tek tanitma" gibi kaynakli metin. |

Psikolojik etki: Hizli kayit iyi; dummy ve iddiali saglik iddialari kaygi/guven dengesini bozar.

### 8.7 Record Form

Dogru:

| Alan | Degerlendirme |
|---|---|
| Tipe gore alanlar | Beslenme, bez, uyku, buyume, saglik ayrimi mantikli. |
| Growth icin en az bir olcum zorunlu | Dogru guardrail. |
| Saglik kaydinda fever degeri aliniyor | Gerekli bir baslangic. |

Yanlis / eksik:

| Sorun | Kanit | Oneri |
|---|---|---|
| Urgent AI sonucu ekranda ayrismiyor. | Urgent ve routine ayni `MedicalWarningCard`. | Kirmizi urgent card: "3 aydan kucuk ve 38 C ise acil ara" gibi yas bazli eylem. |
| Numeric alanlarda ust limit yok. | `positiveDouble` negatif haric kabul ediyor. | Ateş 34-43 C, kilo 0.5-30 kg, su/feeding makul aralik. |
| Mevcut kayda tiklayinca edit degil yeni kayit formu aciliyor. | `context.push('/add/${record.type.name}')`. | Edit route veya "kopyala/yeni" ayrimi. |

### 8.8 Sleep Routine

Dogru:

| Alan | Degerlendirme |
|---|---|
| Start/finish uyku | Ebeveyn icin pratik. |
| AAP safe sleep ozeti | Sirtustu, sert yuzey, bos alan, oda paylasimi var. |
| 24 saat clamp | Uyku timer'inin asiri uzamasini sinirliyor. |

Eksik:

| Sorun | Oneri |
|---|---|
| Yagmur/ninni toggle ses caldirmiyor. | Ya gercek audio ekle ya "ses ortam notu" diye davran. |
| Uyku hedefleri AAP/AASM kaynak baglantisi olmadan gosteriliyor. | Kaynakli range ve "bebekler farklidir" notu. |
| Safe sleep sadece kartta; checklist yok. | Uyku baslatmadan once kisa checklist: sirtustu, bos besik, sert yuzey. |

### 8.9 Reminder Form

Dogru:

| Alan | Degerlendirme |
|---|---|
| Plan turleri | Saatlik, gunluk, haftalik, aylik, tek sefer iyi. |
| Preview | Kullanici ne olacagini kaydetmeden goruyor. |
| Bildirim izni reddi ele aliniyor | Scheduler false donduruyor. |

Eksik:

| Sorun | Oneri |
|---|---|
| Ilac/vitamin dozlari medikal guardrail icermiyor. | "Doktor talimatina gore" sabit uyarisi, doz tekrar kontrol. |
| Kaydedilen reminder duzenleme/silme UI yok. | Reminder listesi ve edit/delete akisi. |
| Saatlik plan en fazla 32 occurrence schedule ediyor. | Periyodik yenileme stratejisi veya sistem repeating schedule. |

### 8.10 Vaccine Calendar

Dogru:

| Alan | Degerlendirme |
|---|---|
| Siradaki asi ve tamamlandi kontrolu | Kullanici icin faydali. |
| Medikal uyarisi var | Takvimin doktor yerine gecmedigi anlasilmali. |

Risk:

| Sorun | Kanit | Oneri |
|---|---|---|
| 30 gun ay offset'i. | `baby.birthDate.add(Duration(days: item.monthOffset * 30))`. | `DateTime(year, month + offset, day)` mantigi ve resmi window araliklari. |
| Remote sync eski status sorunu. | Controller vaccine snapshot bug. | Load sonrasi guncel vaccine ile sync. |
| 2026 AAP schedule kaynakli degil. | Seed notlari CDC diyor. | AAP 2026 immunization schedule linki ve CDC/ACIP uyum notu. |

### 8.11 Education

Dogru:

| Alan | Degerlendirme |
|---|---|
| Kaynak adi/linki ve disclaimer | Medikal icerik icin gerekli. |
| Arama + kategori | Basit ama islevsel. |
| Kaydetme | Daha sonra okuma icin iyi. |

Eksik:

| Sorun | Oneri |
|---|---|
| Saved bolumunde "Duzenle" calismiyor. | Kaydedilenlerden cikarma, kategori filtre, offline kaynak tarihi. |
| Source URL sadece text, tiklanabilir degil. | `url_launcher` ile kaynak acma. |
| Makalelerde yayin/guncelleme tarihi yok. | `reviewedAt`, `sourceReviewedAt`, `contentVersion`. |
| Makale sayisi az. | AAP backlog'u ekle. |

### 8.12 Article Detail

Dogru:

| Alan | Degerlendirme |
|---|---|
| Ozet, kaynak, disclaimer, related | Makale okuma hiyerarsisi iyi. |
| "Kucuk yaklasim" karti | Psikolojik olarak yumusak. |

Eksik:

| Sorun | Oneri |
|---|---|
| Article bulunamazsa `articles.first` crash riski. | Bos liste/fallback sayfasi. |
| Kaynak linki tiklanamiyor. | Harici kaynak butonu. |
| Cumle bolme regex'i basit. | Markdown-like bolum basliklari veya structured content. |

### 8.13 Journal

Dogru:

| Alan | Degerlendirme |
|---|---|
| Mood chip'leri ve anilar | Ebeveyn psikolojisi icin iyi. |
| Timeline | Bakim disindaki duygusal hatirayi sakliyor. |

Gelisecek:

| Sorun | Oneri |
|---|---|
| Mood kayitlari klinik destekle baglanmiyor. | Uzun sureli kaygi/uzuntu trendinde "destek al" rehberi. |
| Anilar edit/delete yok. | Mahremiyet ve kontrol hissi icin gerekli. |

### 8.14 Notifications

Dogru:

| Alan | Degerlendirme |
|---|---|
| Bugun/dun/eski gruplama | Okunabilir. |
| Davet icin onay/red aksiyonu | Islevsel. |
| Filtreler | Aile/saglik/sistem ayrimi var. |

Eksik:

| Sorun | Oneri |
|---|---|
| Okundu/okunmadi ayrimi yalnizca border ile hafif. | Badge, bulk mark read, empty state per filter. |
| Accept/decline hata durumlari snackbar vermiyor. | Islem feedback'i ve loading. |

### 8.15 Profile / Settings

Dogru:

| Alan | Degerlendirme |
|---|---|
| Kullanici, bebek, gebelik duzenleme | Temel hesap yonetimi var. |
| Dogumdan bebek moduna gecis | Onemli yasam olayi desteklenmis. |
| Bildirim tercihleri | Aile/saglik/reminder ayrimi iyi. |

Eksik:

| Sorun | Oneri |
|---|---|
| Gizlilik/veri paylasimi yapilandirilmamis. | Veri ihrac/disari aktarim, silme kapsami, retention. |
| Hesap silme sadece local temizleme gibi davranabilir. | Firebase delete + Firestore verisi lifecycle netlestirilmeli. |
| Aile daveti burada var ama FamilyScreen ayrica var. | Tek bilgi mimarisi: ya Profile icinde kalacak ya Family route aktif olacak. |

### 8.16 Family Screen

Durum: Kod yazilmis, ama rota ona gitmiyor. Bu "yarim kalmis is" olarak isaretlenmeli.

Dogru:

| Alan | Degerlendirme |
|---|---|
| Partner daveti UI | Aile paylasimi icin iyi baslangic. |
| Ortaklar/davetler listesi | Seffaflik sagliyor. |

Yanlis:

| Sorun | Oneri |
|---|---|
| `/family` ProfileScreen'e bagli. | Router'da `FamilyScreen()` kullan. |
| "Oturumu Kapat" yerel reset dialogu aciyor. | Gercek logout veya profile logout akisi. |
| Toggle'larin bir kismi configured-later. | Aktif olmayan islevler "yakinda" diye ayrilmali. |

### 8.17 Quick Actions

Dogru:

| Alan | Degerlendirme |
|---|---|
| Tek dokunus kayit | Ebeveyn is yukunu azaltir. |
| Mode'a gore aksiyonlar | Bebek/gebelik ayrimi dogru. |

Eksik:

| Sorun | Oneri |
|---|---|
| Quick actions deger girmeden kayit atiyor. | Son kullanilan miktar, varsayilan preset, undo. |
| Widget entegrasyonu yok ama ekran basligi widget hissi veriyor. | "Uygulama ici hizli onay" diye netlestir veya gercek native widget ekle. |

---

## 9. Is Mantigi Degerlendirmesi

| Islem | Calisma prensibi | Dogru | Risk / Hata |
|---|---|---|---|
| Bootstrap | Firebase init denenir, hata olursa local auth/noop sync. | Offline/dev icin iyi. | Prod'da sessiz fallback riskli. |
| Login/Register | Auth gateway -> repository user upsert -> load -> sync care state. | Katmanli. | Local gateway sifre dogrulamiyor. |
| Onboarding | Mode + consent + profil -> family/baby veya pregnancy olusturur. | Basit. | Planning modu yok. |
| Add record | Controller domain record uretir, local DB'ye yazar, load, remote sync. | Offline-first. | Sync hata olursa sadece `lastError`; UI belirgin degil. |
| Growth record | `weightKg=...;heightCm=...` string formatinda saklar. | Hizli MVP. | Structured columns daha guvenli olur. |
| Sleep | Active sleep `value=active`, finish ile dakika yazilir. | Pratik. | Ses toggle'lari fake; manual sleep ile timer ayrimi belirsiz. |
| Reminder | Plan JSON encode edilir, local reminder ve local notifications schedule. | Esnek. | Edit/delete/renew yok. |
| Family invite | Remote strict action, sonra local invite. | Guvenli. | FamilyScreen route kapali. |
| Notifications | Local DB notification, device notification opsiyonel. | Iyi. | Accept/decline loading/error feedback zayif. |
| Vaccine | Seed schedule, checkbox complete. | MVP icin iyi. | Remote stale status bug; 30-gun offset; 2026 kaynak eksik. |
| Education | Seed makale + saved articles. | Cihazda calisir. | Source link tiklanamaz, tarih/review yok. |

---

## 10. Kullanici Psikolojisi Degerlendirmesi

Bu uygulama kullanici psikolojisi icin potansiyel olarak iyi bir uygulama; cunku kayitlari "mukemmel ebeveynlik" yerine "kucuk adimlar" olarak cerceveliyor. Ancak bazi metinler ve tamamlanmamis islevler kaygi veya guven kaybi yaratabilir.

Iyi hissettiren alanlar:

| Alan | Neden iyi |
|---|---|
| Sucluluk azaltici beslenme dili | Mama/emzirme kararini yargilamiyor. |
| Kucuk rutinler | Gebelikte basit, yapilabilir adimlar oneriyor. |
| Trend vurgusu | Tek olcumu buyutmemeye calisiyor. |
| Journal | Bakim disindaki duygusal hatiralari da degerli kiliyor. |
| Family sharing | Ebeveyn yukunu bolusturur. |

Kaygi yaratabilecek alanlar:

| Alan | Neden riskli |
|---|---|
| "Super gelisim" | Bebegi performans gibi cerceveleyebilir. |
| "AI danisman" | Medikal yetki algisi dogurabilir. |
| Dummy grafik | Kullanici gercek veri zannedebilir. |
| Fake sosyal kanit | Guven kirabilir. |
| Acil durum ayrimi yetersiz | Ebeveynin "ne yapacagim?" aninda belirsizlik yaratir. |

Onerilen psikolojik tasarim ilkeleri:

1. "Kusursuzluk" degil "fark etme ve destek alma" dili.
2. Kirmizi/acil kartlari az ama cok net kullan.
3. AI yerine "kayit ozeti" ve "kaynakli rehber" ifadesi.
4. Anne-baba ruh sagligi icin destek kaynaklari ekle.
5. Tum metriklerde "tek olcum degil trend" dilini koru.

---

## 11. AAP Uyumunu Artirmak Icin Icerik Modeli Onerisi

Mevcut `Article` modeli kaynak adi/linki/disclaimer tasiyor. Bir saglik uygulamasi icin su alanlar eklenmeli:

```text
sourcePublishedAt
sourceReviewedAt
appReviewedAt
clinicalCategory
ageRangeStartMonths
ageRangeEndMonths
redFlagLevel
countryOrSchedule
lastVerifiedBy
```

Bu alanlar sayesinde kullaniciya "Bu makale en son ne zaman kontrol edildi?" sorusunun cevabi verilir.

---

## 12. Oncelikli Yol Haritasi

### P0: Guven ve medikal risk

| Is | Beklenen etki |
|---|---|
| `/family` rotasini `FamilyScreen`e bagla veya FamilyScreen'i kaldir. | Yarim ekran riski cozulur. |
| Asi complete remote sync bug'ini duzelt. | Aile cihazlari tutarli olur. |
| Saglik formunda urgent sonuc karti ve yas bazli fever triage ekle. | AAP uyumu ve guvenlik artar. |
| Planning mode icin ayri onboarding veya secenegi kaldir. | Yanlis mod onlenir. |
| Dummy grafik/fake sosyal kanit/metinleri kaldir. | Guven hissi artar. |

### P1: AAP icerik ve UX derinligi

| Is | Beklenen etki |
|---|---|
| 12 yeni AAP/HealthyChildren makalesi ekle. | Icerik kapsam skoru artar. |
| Source linklerini tiklanabilir yap. | Guven ve seffaflik artar. |
| Asi takvimini 2026 AAP/CDC kaynagi ve calendar-month mantigiyla guncelle. | Klinik uygunluk artar. |
| Growth reference'i cinsiyet ve percentile trend olarak modelle. | Yanlis yorum riski azalir. |
| Reminder list/edit/delete ekle. | Kullanici kontrolu artar. |

### P2: His ve polish

| Is | Beklenen etki |
|---|---|
| TR lokalizasyonu tamamla. | Yerel kalite artar. |
| Journal mood trend + destek kaynaklari. | Ebeveyn psikolojisi guclenir. |
| Safe sleep checklist. | AAP bilgisini davranisa cevirir. |
| Quick action undo/preset. | Hata telafisi ve hiz artar. |
| Bos durumlari filtreye gore ozellestir. | Daha sakin deneyim. |

---

## 13. Kabul Kriterleri

Bu uygulamanin "AAP uyumlu, guven veren ebeveyn takip uygulamasi" olarak daha rahat konumlanmasi icin minimum kabul kriterleri:

| Kriter | Olcum |
|---|---|
| Tum aktif rota ve butonlar gercek ekrana gider. | Playwright/widget route smoke test. |
| Saglik acil durumlari net ayrisir. | Fever/respiratory/seizure/red-flag testleri. |
| Makaleler resmi kaynak, review tarihi ve disclaimer tasir. | Article seed testleri. |
| Asi takvimi kaynakli ve tarih mantigi dogru. | Dogum tarihine gore schedule unit testleri. |
| Placeholder/dummy veri prod UI'da yok. | Metin tarama + screenshot QA. |
| Kullanici veri kontrolu var. | Export/delete/privacy sayfasi. |

---

## 14. Son Karar

MiniAdimlar'in cekirdegi guclu: offline-first takip, aile paylasimi, sakin dil, egitim kaynaklari ve testli domain mantigi dogru yone gidiyor.

Ama saglik ve ebeveyn psikolojisi alani hassas oldugu icin uygulama su anda "guclu MVP" olarak konumlanmali; "AAP ile tamamen uyumlu medikal rehber" olarak degil.

Bir sonraki en degerli hamle: once guven kiracak yarim/placeholder isleri temizlemek, sonra AAP icerik kapsamlarini yas bazli ve kaynak tarihli hale getirmek.
