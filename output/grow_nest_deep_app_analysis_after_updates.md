# MiniAdimlar / Grow Nest Ikinci Tur Derin Uygulama Analizi

Tarih: 6 Mayis 2026  
Kapsam: Ilk kritik duzeltmeler ve 8. basliktaki UX/Firebase/icerik iyilestirmeleri sonrasinda yeniden durum okuma. Bu dosya, onceki raporun uzerine yazilmis bir "temiz tablo" degil; guncel kodun ikinci tur sunum analizidir.

---

## 1. Yonetici Ozeti

MiniAdimlar artik ilk analizdeki en can yakan sorunlarin buyuk bolumunu kapatmis durumda: aile sayfasi route'u calisiyor, asi tamamlama sonrasi durum tazeleniyor, kayit formunda bebek yasina gore kritik ates uyarisi var, sahte sosyal kanitlar kaldirilmis, dashboard'daki sahte AI hissi azaltildi, egitim makaleleri AAP/HealthyChildren ekseninde genisletildi ve Firebase okuma maliyeti daha kontrollu hale getirildi.

Guncel tablo guclu bir MVP'ye yaklasti, fakat uygulama henuz "tibbi guvenilirlik" veya "ebeveyn psikolojisi acisindan tam olgun" seviyesinde degil. En onemli kalan konu, kullanici kontrolu ve veri yasam dongusu: hesap silme metni ile Firestore'daki gercek silme davranisi tam uyumlu degil, hatali girilen kayitlari duzeltme/silme akisi eksik, MockAiAnalysisService hala urun dilinde yanlis anlasilabilecek bir risk tasiyor.

### Guncel Skor Tablosu

| Alan | Skor | Durum |
| --- | ---: | --- |
| Teknik stabilite | 88/100 | `flutter analyze` temiz, `flutter test` 20/20 basarili. |
| UX akiskanligi | 80/100 | Kritik kirilmalar kapandi; edit/delete ve bilgi mimarisi hala gelismeli. |
| AAP/HealthyChildren uyumu | 82/100 | Icerik artmis ve temel guvenlik hatlari dogru; kaynak metadata, buyume/milestone ve asi ayrintilari eksik. |
| Kullanici psikolojisi | 82/100 | Ton daha sakin ve daha az suclayici; duygu trendi, destek yonlendirmesi ve kontrol hissi eksik. |
| Firebase/maliyet disiplini | 76/100 | Standard/free tier ve lokal-oncelikli mimari iyi; listener sayisi ve silme yasam dongusu dikkat istiyor. |
| Urun hazirligi | 74/100 | Guclu beta/MVP; pediatrik rehberlik iddiasi icin daha fazla kaynak ve klinik netlik gerekli. |

---

## 2. Kanitlar ve Guncel Olcum

### Kod ve Test Kanitlari

- `flutter analyze`: No issues found.
- `flutter test`: 20 test basarili.
- Ana Dart dosyalari: 42
- Ana Dart satirlari: 13.467
- Test dosyalari: 5
- Seed egitim makalesi: 20
- Uygulama route sayisi: 17
- Feature klasoru: 15

### Firebase Kaniti

- Firebase projesi: `grownest-f4141`
- Firestore database: `(default)`
- Mode: `FIRESTORE_NATIVE`
- Edition: `STANDARD`
- Region: `europe-west4`
- `freeTier`: true
- PITR: disabled
- Delete protection: disabled
- Bu analizde deploy, veri yazma veya destructive islem yapilmadi.

### Guncel Route Haritasi

- Auth: `/login`, `/register`, `/forgot-password`
- Onboarding: `/onboarding`
- Shell tablari: `/growth`, `/tracker`, `/journal`
- Detay ve aksiyonlar: `/add`, `/reminder`, `/sleep`, `/education`, `/education/:id`, `/notifications`, `/vaccines`, `/quick-actions`, `/profile`, `/family`

---

## 3. Ilk Analizden Sonra Duzelen Kritikler

### Artik Dogruya Yakin Calisan Alanlar

- Family route bos ekran/yanlis yonlendirme olmaktan cikti.
- Asi tamamlamada eski snapshot sorunu giderildi; durum taze veriyle yeniden hesaplaniyor.
- Gebelik/bebek/planlama modelleri birbirine daha az karisiyor.
- Onboarding ve profil tarafinda gizlilik ozetleri daha gorunur.
- Auth hatalari ham Firebase metni yerine kullaniciya daha okunabilir mesajlarla donuyor.
- Bebek dashboard'unda sahte "AI analizi" hissi azaltilmis.
- Kayit formunda sayisal guardrail ve kritik ates uyarisi guclendi.
- Uyku, ilac/su hatirlaticilari ve asi kaynak metinlerinde AAP/CDC eksenli aciklama arttirilmis.
- Egitim makalelerinde AAP/HealthyChildren kaynakli basliklar artmis.
- Firebase background refresh icin cooldown ve live query limitleri daha minimalist hale getirilmis.

### Hala Uzerinde Durulmasi Gereken Cekirdek Riskler

- Hesap silme akisi, Firestore verilerinin uzaktan silinmesini garanti etmiyor.
- Mock/rule-based saglik analizi hala `AI` gibi algilanabilir.
- Kayit, hatirlatici ve anilar icin edit/delete/archive eksikligi kullanici kontrolunu zayiflatiyor.
- Egitim iceriginde `reviewedAt`, `sourceReviewedAt`, `contentVersion` gibi kaynak yasam dongusu yok.
- Buyume percentilleri, milestone mantigi ve asi araliklari henuz tam klinik ayrintida degil.

---

## 4. AAP / HealthyChildren Uyum Degerlendirmesi

### Guclu Uyum Alanlari

Uygulama artik AAP/HealthyChildren cizgisine daha yakin duruyor. Safe sleep checklist, 3 aydan kucuk bebekte 38.0 C ve uzeri ates icin acil pediatrist yonlendirmesi, choking prevention, car seat, oral health, caregiver mental health ve digital media gibi basliklar dogru kaynak ailesine dayanacak sekilde genisletilmis.

AAP safe sleep kaynaklari, bebeklerin sirtustu, kendi uyku alaninda, sert/duz yuzeyde ve yumusak objeler olmadan yatirilmasini vurguluyor. Uygulamadaki uyku checklist'i bu ana hattin buyuk bolumunu karsiliyor.

HealthyChildren fever rehberi, 3 ay ve alti bebekte rektal 38.0 C veya uzeri ates icin hemen pediatrist aranmasini soyluyor. Kayit formundaki yas-bazli kritik ates uyarisinin bu hatta yaklasmasi onemli bir dogru.

HealthyChildren oral health rehberi, ilk dis cikinca dis fircalama/fluoride ve ilk dogum gunu veya ilk dis sonrasi dis hekimi temasini vurguluyor. Bu baslik seed makalelerde yer almali ve ileride hatirlaticilara baglanabilir.

HealthyChildren digital media rehberi, ozellikle 18 ay altinda gercek dunya etkilesimini one aliyor ve sadece sure siniri yerine kalite, baglam ve birlikte kullanim perspektifi veriyor. Uygulama bu konuya "ekran suresi sayaci" gibi suclayici degil, rehberlik eden bir tonla yaklasmali.

### Eksik Kalan Uyum Alanlari

- Kaynak iceriklerinin guncellenme tarihi uygulama icinde gorunmuyor.
- Seed makalelerde kaynak linki var, fakat her makale icin kaynak kurum, son gozden gecirme tarihi, uygulama icinde yayin tarihi ve versiyon ayrimi yok.
- Asi takvimi temel aylara dayali; minimum interval, catch-up schedule, risk grubuna gore farklilik ve istisnalar yok.
- Buyume grafikleri cinsiyete ve yas araligina gore WHO/CDC percentile tablolari ile tam bagli gorunmuyor.
- Milestone/donum noktasi akisi AAP Bright Futures/CDC Learn the Signs cizgisinde detaylandirilmamis.
- Saglik analizi, tibbi tani gibi okunabilecek iddiali bir dil kullanmamali; "kural tabanli onceliklendirme" olarak konumlanmali.

### AAP Uyum Sonucu

Uygulama su an "AAP kaynakli aile egitim uygulamasi" olmaya yaklasti; fakat "AAP protokolune tam uyumlu pediatrik karar destek sistemi" degil. Bu ayrim urun dilinde net olursa guven artar, hukuki ve etik risk azalir.

---

## 5. Kullanici Psikolojisi Degerlendirmesi

### Iyi Hissettiren Alanlar

- Dil genel olarak sakin ve yardimci.
- Sahte sosyal kanit ve gercek olmayan grafik dili kaldirildigi icin kullanicida kandirilma hissi azalir.
- Onboarding'de gizlilik bilgisinin gorunmesi kontrol hissini artirir.
- Guvenli uyku, ates ve ilac/su uyarilari ebeveyne netlik verir.
- Gunluk ozetler "sen basarisizsin" degil, "bugun burada duruyoruz" hissi verir.

### Kullanici Psikolojisini Zedeleyebilecek Alanlar

- Kullanici yanlis kayit girdiginde edit/delete yoksa kaygi ve kontrol kaybi hisseder.
- "Hesabimi sil" metni uzaktaki verinin de temizlenecegini ima ederse, gercek davranis farkliysa guven kirilir.
- Journal duygu secimi var ama devaminda destek, trend veya "bu his normal olabilir" turu sefkatli geri donus yok.
- Mock AI gibi duran analizler kullanicida sahte uzman hissi yaratabilir.
- Planlama modunda bazi metinlerin bebek/gebelik tonuna kaymasi, kullanicinin kendini "yanlis yerde" hissetmesine neden olabilir.

### Psikolojik Sonuc

Evet, uygulama kullanici psikolojisi icin iyi bir temele sahip. Ama en iyi hissettiren ebeveyn uygulamalari sadece bilgi vermez; kullaniciya duzeltme hakki, geri alma hakki, sakinlestirici destek, acik sinirlar ve kaynak seffafligi verir. MiniAdimlar bu yonde ilerliyor, fakat kontrol ve destek katmani tamamlanmali.

---

## 6. Sayfa Sayfa UX Durum Analizi

### 6.1 Auth: Login / Register / Forgot Password

Durum: Hata mesajlari daha okunabilir hale geldi. Yerel auth fallback artik env bayragi olmadan devreye girmiyor. Bu, guvenlik ve kullanici guveni acisindan dogru.

Dogru mantik:
- Firebase Auth ana kaynak.
- Kullaniciya teknik hata metni basmak yerine sade mesaj gostermek dogru.
- Local fallback'in prod ortamda sessizce calismamasi kritik bir iyilestirme.

Eksik:
- Google giris butonu varsa marka/availability durumu daha net olmali.
- Register sonrasinda veri kullanimi ve ebeveyn rolunun kisa aciklamasi daha iyi konumlanabilir.
- Forgot password akisi basarili islem sonrasi "mail kutunu kontrol et" tonunda daha guven verici kapanmali.

Oncelik: P2

### 6.2 Onboarding

Durum: Gebelik, bebek ve planlama ayrimi temizlendi. Gizlilik ozeti daha gorunur.

Dogru mantik:
- Mod bazli onboarding, uygulamanin ebeveynin donemine gore davranmasini sagliyor.
- Minimal veri istemek iyi; maliyet ve privacy acisindan dogru.

Eksik:
- Planlama modunda hedef, son adet tarihi veya tahmini baslangic gibi istege bagli alanlar yoksa dashboard daha genel kalir.
- Gizlilik ozetinin "hukuki metin degil, urun ozeti" oldugu netlestirilmeli.
- Onboarding sonunda kullanici hangi verilerin lokal, hangilerinin Firebase'e gittigini sade bir cumleyle gorebilmeli.

Oncelik: P1

### 6.3 Home Shell / Navigasyon

Durum: Route haritasi artik daha tutarli. Ana tablar buyume/takip/gunluk ekseninde anlasilir.

Dogru mantik:
- Ana gunluk isler tablarda, destekleyici isler secondary route'larda.
- Bildirim rozeti ve profil/family ayrimi temel olarak dogru.

Eksik:
- Family ve Profile tarafinda aile daveti/uye yonetimi konulari hala bilgi mimarisi olarak ayrismali.
- Ana shell'de mod degistirme veya aktif bebek/aile secimi ileride karisik hale gelebilir.

Oncelik: P2

### 6.4 Gebelik Dashboard

Durum: Gebelik verisi artik bebek verisiyle daha az karisiyor. Haftalik meyve/gelisim dili duygusal olarak olumlu.

Dogru mantik:
- Haftalik durum ve sakin tavsiye kartlari kullanici kaygisini dusurur.
- Gunluk takip, su/semptom gibi hafif davranislari destekler.

Eksik:
- AAP/ACOG ayrimi yapilmali; gebelik icerigi AAP'den cok ACOG/CDC gibi kaynaklara dayanir.
- Su hedefi ve semptom tavsiyeleri kisiden kisiye degisebilir; daha guclu "doktorunun onceligi" notu gerekir.
- Postpartum hazirlik, dogum sonrasi mental saglik ve yenidogan guvenligi daha gorunur olabilir.

Oncelik: P1

### 6.5 Bebek Dashboard

Durum: Sahte AI ozeti yerine daha lokal/gunluk ozet hissi var. Bu iyi bir psikolojik ve etik duzeltme.

Dogru mantik:
- Gunluk takipleri ozetlemek pratik.
- Asi ve buyume aksiyonlarini yakinda tutmak dogru.

Eksik:
- Buyume degerleri gercek percentile mantigiyla desteklenmiyorsa "normal/ideal" gibi yorumlardan kacinilmali.
- Sonraki beklenen aksiyonlarin "neden" bilgisi kisaca verilmeli.
- Birden fazla bebek/aile varsa aktif bebek secimi cok net olmali.

Oncelik: P1

### 6.6 Tracker Liste

Durum: Temel kayitlar ve hizli akis calisir. Offline-first model burada iyi bir tercih.

Dogru mantik:
- Kullanici gun icinde az eforla kayit girebiliyor.
- Kategori bazli takip ebeveynin zihinsel yukunu azaltir.

Eksik:
- Mevcut kayitlari duzenleme/silme/archive akisi yoksa hata toleransi dusuk kalir.
- Liste icinde kaynak/analiz sonucuna gore filtreleme yok.
- Aile icinde kimin girdigi bilgisi ileride guven ve sorumluluk icin onemli olabilir.

Oncelik: P0/P1

### 6.7 Add Record / Kayit Formu

Durum: Sayisal guardrail ve kritik ates uyarisi eklendi. Bu, ilk analize gore ciddi bir iyilesme.

Dogru mantik:
- Olcum tipine gore form davranisi ayriliyor.
- 90 gunden kucuk bebekte 38.0 C ve ustu icin acil uyarinin gorunmesi dogru.
- Quick action'dan deger gerektiren kayitlarda detay formuna gitmek dogru.

Eksik:
- Kayit duzenleme modu yok.
- Mock/rule-based analiz hizmetinin adi ve metni "AI doktor" gibi algilanabilir.
- Ates threshold'lari yas gruplarina gore daha ayrintili hale getirilmeli.

Oncelik: P0

### 6.8 Sleep Screen

Durum: Safe sleep checklist ile AAP hattina daha yakin. Ses toggle'larinin sahte oynatma gibi durmamasi iyi.

Dogru mantik:
- Uyku takibi sadece sure degil, guvenli ortam kontroluyle destekleniyor.
- Checklist ebeveyne net bir "kontrol ettim" hissi verir.

Eksik:
- Uyku araliklari kaynak tarihiyle verilmezse genel tavsiye gibi kalir.
- Ses ozelligi gercek degilse ya tamamen kaldirilmali ya da net "hazir degil" durumunda tutulmali.
- Checklist gecmisi ve tekrar eden riskler icin egitim yonlendirmesi eklenebilir.

Oncelik: P1/P2

### 6.9 Reminder Screen

Durum: Ilac ve su hatirlaticilarinda daha iyi guardrail var.

Dogru mantik:
- Ilac hatirlaticisi tibbilesmeden, ebeveynin kendi planini destekliyor.
- Su gibi yas hassasiyeti olan konularda uyarilar dogru.

Eksik:
- Hatirlatici edit/delete akisi kritik.
- Scheduler ilk 32 occurrence ile sinirli; tekrar eden planlar icin yenileme stratejisi gerekir.
- Ilac hatirlaticisinda doz bilgisi giriliyorsa disclaimer ve pediatrist/recete vurgusu guclenmeli.

Oncelik: P1

### 6.10 Vaccines

Durum: Calendar month hesaplamasi duzeldi ve kaynak metni AAP/CDC cizgisine yaklasti.

Dogru mantik:
- Asi gorevlerinin tamamlanma/tazelenme dongusu artik daha guvenilir.
- Dogum tarihinden ay ekleyerek planlamak basit MVP icin uygun.

Eksik:
- 2026 schedule kaynakli detaylar, catch-up, minimum interval, risk grubuna gore farklilik yok.
- Tamamlanan asi icin uygulama "kayit" mi tutuyor, "tibbi uygunluk" mu soyluyor net olmali.
- Kaynak yil ve son guncelleme UI'da gorunmeli.

Oncelik: P1

### 6.11 Education

Durum: 20 seed makale ile icerik alani cok daha dolu. Kaynak linkinin disarida acilmasi dogru.

Dogru mantik:
- AAP/HealthyChildren ailesinden basliklar ebeveyn guveni icin dogru.
- Kaydedilen makaleler ve kategori yapisi kullanisli.

Eksik:
- Makale kaynak metadata'si zayif: `source`, `sourceUrl`, `sourceReviewedAt`, `appReviewedAt`, `contentVersion` gibi alanlar gerekir.
- Makaleler hekim onayi aldi mi, uygulama tarafindan ozet mi, birebir kaynak mi net degil.
- Turkce icerikler kaynakla ne kadar birebir uyumlu, ceviri/uyarlama notu yok.

Oncelik: P1

### 6.12 Article Detail

Durum: Eksik makale fallback'i ve kaynak acma iyilesmis.

Dogru mantik:
- Kullanici bos/kirik sayfada kalmiyor.
- Kaynaga gitme sansi guven yaratir.

Eksik:
- Uzun makalelerde taranabilirlik icin ozet, ana aksiyonlar, "ne zaman doktora" bloklari standardize edilmeli.
- Kaynak son guncelleme tarihi makale detayinda gorunmeli.
- Medikal aciliyet iceren makalelerde acil durum siniri digerlerinden ayrilmali.

Oncelik: P1

### 6.13 Journal

Durum: Duygu odakli alan uygulamanin en iyi psikolojik potansiyellerinden biri.

Dogru mantik:
- Anilar ve ruh hali kaydi ebeveynin sadece "bakim makinesi" gibi hissetmesini engeller.
- Dusuk friksiyonlu kayit iyi.

Eksik:
- Planlama modunda bazi metinler bebek odakli kalabiliyor.
- Mood trendi yok; surekli kotu ruh hali varsa nazik destek yonlendirmesi yok.
- Anilari duzenleme/silme yoksa mahremiyet ve kontrol hissi eksik kalir.

Oncelik: P1

### 6.14 Notifications

Durum: Bildirim aksiyonlarinda geri bildirim daha iyi.

Dogru mantik:
- Kullanici bildirimle uygulamadaki ilgili aksiyona baglanabiliyor.
- Lokal notification yaklasimi maliyet acisindan dogru.

Eksik:
- Bulk mark-read/clear read yok.
- Bildirim izin isteme zamani kullanici baglamina gore optimize edilmeli.
- Aile ile paylasilan aksiyonlarda "kim tetikledi" bilgisi ileride gerekebilir.

Oncelik: P2

### 6.15 Profile

Durum: Gizlilik ve hesap ayarlari daha iyi gorunuyor.

Dogru mantik:
- Kullanici profil, bebek ve gizlilik alanlarini tek yerden gorebiliyor.
- Cikis ve hesap silme gibi guvenlik aksiyonlari profil altinda dogru yerde.

Kritik eksik:
- Hesap silme metni "veriler temizlenir" gibi okunurken Firestore rules delete'e izin vermiyor; app local reset yapiyor ve FirebaseAuth kullanicisini silmeye calisiyor. Remote verinin ne olacagi acik degil. Bu ya teknik olarak cozulmeli ya da metin gercegi soylemeli.

Diger eksikler:
- Bebek profilindeki olcum alanlarinda record formdaki guardrail seviyesi yok.
- FirebaseAuth delete islemi recent-login gerektirebilir; hata yakalama ve yeniden giris akisi netlesmeli.
- Family davet aksiyonlari Profile ile Family arasinda daginik.

Oncelik: P0

### 6.16 Family

Durum: Route ve temel davet akisi calisir hale geldi.

Dogru mantik:
- Aile paylasimi ebeveyn yukununu azaltabilir.
- Kabul edilmis invite ve owner/member ayrimi Firestore kurallarinda da var.

Eksik:
- Rol, uye kaldirma, davet iptal etme, yetki siniri ve audit dili daha net olmali.
- Family ve Profile arasindaki fonksiyon ayrimi sadeleştirilmeli.
- Sync ve listener maliyeti aile buyudukce artabilir.

Oncelik: P1

### 6.17 Quick Actions

Durum: Deger gereken aksiyonlarda detay formuna gitmek dogru bir duzeltme.

Dogru mantik:
- Hizlik ve guvenlik dengesi iyilesmis.
- Tek dokunusla yanlis tibbi kayit olusma riski azalmis.

Eksik:
- Undo/snackbar geri alma yok.
- Hangi aksiyonun lokal, hangisinin Firebase'e sync oldugu kullaniciya acik degil.
- Widget/kilit ekran entegrasyonu ileride faydali olur ama simdilik maliyet acisindan ertelenebilir.

Oncelik: P2

---

## 7. Islem Mantiklari: Dogru / Riskli / Yanlis

### Dogru Mantiklar

- Offline-first repository yaklasimi ebeveyn uygulamasi icin dogru; internet yokken takip kaydi girebilmek kritik.
- Firestore rules genel olarak kullanici/aile yetkisini sinirli tutuyor.
- Aile davetlerinde accepted invite ve owner/member kontrolleri dogru yonde.
- Firebase local fallback'in prod'da kapali olmasi guvenlik acisindan dogru.
- Asi tamamlamadan sonra fresh snapshot kullanilmasi veri tutarliligi acisindan dogru.
- Safe sleep, ates ve ilac/su alanlarinda guardrail eklenmesi dogru.

### Riskli Mantiklar

- MockAiAnalysisService, kullanici tarafinda gercek AI veya tibbi karar destek gibi algilanabilir.
- Profile delete akisi remote veri yasam dongusunu net cozmuyor.
- Live family watcher cok sayida stream aciyor; kucuk aile icin uygun, buyume halinde maliyet artar.
- Bootstrap'ta families/invites refresh baslangicta force davranisina yakin; kucuk olcekte sorun degil ama buyume halinde okunma maliyeti yaratir.
- Scheduler'in ilk 32 occurrence ile sinirli olmasi uzun vadeli hatirlaticilarda sessiz bosluk yaratabilir.

### Yanlis veya Hemen Duzeltilmesi Gereken Mantiklar

- "Hesabimi sil" uzaktaki tum aile/veri kayitlarini temizliyor gibi anlatilmamali; teknik gercek garanti edilene kadar metin degismeli.
- Tibbi analiz ekraninda "AI" veya "tani" hissi veren her metin kural tabanli onceliklendirme olarak yeniden adlandirilmali.
- Kullanici hatali kayit girebildigi halde edit/delete yoksa takip uygulamasinin temel guven hissi eksik kalir.

---

## 8. Firebase ve Maliyet Degerlendirmesi

### Maliyet Acisindan Iyi Kararlar

- Firestore Standard/free tier kullaniliyor.
- Offline-first Drift mimarisi, her ekranin direkt Firestore okumamasini sagliyor.
- Cloud Functions, Storage, AI API gibi ekstra maliyetli servisler su an cekirdek akista zorunlu degil.
- Live listener limitleri onceki duruma gore daha dusuk.
- Background refresh cooldown eklenmesi gereksiz okumalari azaltir.
- Firestore rules public read/write acmiyor.

### Maliyet Riski Olan Alanlar

- Family watcher bir aile icin birden fazla stream aciyor: family, babies, tracker records, reminders, accepted invites ve baby vaccine stream'leri. Kucuk MVP'de kabul edilebilir, fakat aktif aile sayisi artinca okuma maliyeti belirginlesir.
- `limit` var ama `orderBy`/pagination stratejisi net degilse "son N kayit" her zaman beklenen davranisi vermeyebilir.
- Baslangicta force refresh davranisi kucuk olcekte tamam, ama gunluk aktif kullanici artinca gereksiz read uretir.
- Data Connect generated dosyalari repo icinde gorunuyor fakat aktif urun mimarisi Firestore. Kullanilmiyorsa kafa karistirir.
- Hesap silme icin admin yetkili remote cleanup gerekiyorsa Cloud Functions veya benzeri server-side is kacilmaz olabilir; bu maliyet dogurur ama veri guveni icin gerekli olabilir.

### Minimalist Firebase Yol Haritasi

1. Tek aktif aile/bebek icin listener ac; diger aileleri manuel refresh ile yukle.
2. Tracker/reminder/vaccine listelerine deterministik `orderBy(createdAt/dueDate)` ve ihtiyac kadar `limit` ekle.
3. "Daha eski kayitlari yukle" butonu ile pagination yap; otomatik sonsuz sync yapma.
4. Account delete icin ya remote cleanup'i Cloud Function ile cozumle ya da UI metnini "bu cihazdaki veriler" olarak netlestir.
5. App Check'i gercek app initialization icine al; sadece dependency/build dosyasinda kalmasin.
6. Composite index eklemeyi sadece query gercekten gerektirdiginde yap.
7. Push notification/Cloud Messaging yerine lokal notification ile devam et; bu MVP icin maliyeti dogru yerde tutar.

---

## 9. Oncelikli Backlog

### P0: Guven ve Veri Butunlugu

1. Hesap silme gercegini duzelt: remote Firestore cleanup ya uygulanmali ya da metin sadece lokal/FirebaseAuth etkisini anlatmali.
2. `MockAiAnalysisService` adini ve UI dilini "RuleBasedHealthTriageService" benzeri bir yapıya cevirmek.
3. Tracker kayitlari icin edit/delete/archive akisi eklemek.

### P1: Pediatrik Guvenilirlik ve Kontrol Hissi

1. Profile bebek olcum alanlarina record formdaki sayisal guardrail'i tasimak.
2. Hatirlatici edit/delete ve tekrar plan yenileme stratejisini eklemek.
3. Journal icin mood trendi ve destek yonlendirmesi eklemek.
4. Planlama modu metinlerini bebek/gebelik metinlerinden tamamen ayirmak.
5. Makalelere `sourceReviewedAt`, `appReviewedAt`, `contentVersion` eklemek.
6. Asi pencereleri ve minimum interval mantigini temel seviyede eklemek.

### P2: Olgunluk ve Zevk

1. Google sign-in branding ve availability durumunu netlestirmek.
2. Bildirimlerde bulk mark-read/clear read eklemek.
3. Safe sleep checklist gecmisi ve egitim yonlendirmesi eklemek.
4. Ses ozelligi gercek asset ile yapilmayacaksa UI'dan tamamen sadeleştirmek.
5. Buyume grafikleri icin WHO/CDC percentile veri seti ve cinsiyet/yas ayrimi eklemek.

---

## 10. Sunum Sonucu

MiniAdimlar'in ikinci tur hali, ilk analize gore cok daha tutarli ve daha guven verici. Uygulamanin "ebeveynin yaninda duran sakin takip asistanı" olma cekirdegi dogru. En cok ilerleme kaydeden alanlar: route butunlugu, kritik saglik uyarilari, AAP kaynakli egitim kapsamı, sahte AI/sosyal kanit riskinin azalmasi ve Firebase maliyet kontrolu.

Henuz kapanmayan ana tema su: kullaniciya kontrol ve seffaflik vermek. Ebeveyn uygulamasinda guven sadece dogru bilgiyle kurulmaz; yanlis kaydi duzeltebilmek, verisini silebilmek, kaynagin ne zaman guncellendigini gorebilmek ve uygulamanin "doktor degil rehber" oldugunu hissetmek gerekir.

Bir sonraki en mantikli sprint, yeni parlak ozellik eklemek degil; hesap silme/veri yasam dongusu, kural tabanli saglik triyaji adlandirmasi, edit/delete akislari ve kaynak metadata'si uzerine kurulmalı. Bu dortlu tamamlandiginda uygulama hem AAP uyumu hem kullanici psikolojisi hem Firebase maliyeti acisindan daha dengeli bir beta seviyesine gelir.

---

## 11. Kullanilan Resmi Kaynaklar

- AAP Safe Sleep: https://www.aap.org/en/patient-care/safe-sleep/
- HealthyChildren 2026 Immunization Schedule: https://www.healthychildren.org/English/news/Pages/AAPs-recommended-childhood-and-adolescent-immunization-schedule-for-2026.aspx
- HealthyChildren Fever and Your Baby: https://www.healthychildren.org/English/health-issues/conditions/fever/Pages/Fever-and-Your-Baby.aspx
- HealthyChildren Choking Prevention: https://www.healthychildren.org/English/health-issues/injuries-emergencies/Pages/Choking-Prevention.aspx
- HealthyChildren Oral Health: https://www.healthychildren.org/English/healthy-living/oral-health/pages/Brushing-Up-on-Oral-Health-Never-Too-Early-to-Start.aspx
- HealthyChildren Rear-Facing Car Seats: https://healthychildren.org/English/safety-prevention/on-the-go/Pages/Rear-Facing-Car-Seats-for-Infants-Toddlers.aspx
- HealthyChildren Depression and Anxiety During Pregnancy and After Birth: https://www.healthychildren.org/English/ages-stages/prenatal/Pages/Depression-and-Anxiety-During-Pregnancy-and-After-Birth-FAQs.aspx
- HealthyChildren Abusive Head Trauma: https://www.healthychildren.org/English/safety-prevention/at-home/Pages/Abusive-Head-Trauma-Shaken-Baby-Syndrome.aspx
- HealthyChildren Digital World / AAP Policy Explained: https://www.healthychildren.org/English/family-life/Media/Pages/helping-kids-thrive-in-a-digital-world-AAP-policy-explained.aspx
