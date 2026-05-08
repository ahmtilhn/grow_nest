import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/sync/remote_sync_models.dart';
import '../../core/sync/sync_queue.dart';
import '../../domain/entities/app_entities.dart';
import '../../domain/entities/app_entities.dart' as domain;
import '../local/app_database.dart'
    hide AppNotification, FamilyInvite, VaccineEvent;

class AppRepository {
  AppRepository(this._db);

  final AppDatabase _db;

  Future<AppSnapshot> loadSnapshot() async {
    final settings = await _db.select(_db.settingsRows).get();
    final settingMap = {for (final row in settings) row.key: row.value};
    final currentUserId = settingMap['currentUserId'];
    final userRow = currentUserId == null || currentUserId.trim().isEmpty
        ? null
        : await (_db.select(
            _db.users,
          )..where((tbl) => tbl.id.equals(currentUserId))).getSingleOrNull();

    dynamic familyRow;
    if (userRow != null) {
      familyRow = await _currentFamilyRow(userRow.id, settings: settingMap);
    }

    dynamic babyRow;
    if (familyRow != null) {
      babyRow = familyRow.activeBabyId == null
          ? await (_db.select(_db.babies)
                  ..where((tbl) => tbl.familyId.equals(familyRow.id))
                  ..limit(1))
                .getSingleOrNull()
          : await (_db.select(_db.babies)
                  ..where((tbl) => tbl.id.equals(familyRow.activeBabyId!)))
                .getSingleOrNull();
    }

    final pregnancyRow = userRow == null
        ? null
        : await (_db.select(
            _db.pregnancies,
          )..where((tbl) => tbl.userId.equals(userRow.id))).getSingleOrNull();
    if (pregnancyRow != null && babyRow == null) {
      await _ensurePregnancyDuePrompt(pregnancyRow, userRow, familyRow);
    }
    if (babyRow != null) {
      await _seedVaccineEvents(babyRow);
    }
    final records = userRow == null
        ? const []
        : await (_db.select(_db.trackerRecords)
                ..where((tbl) {
                  var scope = tbl.createdByUserId.equals(userRow.id);
                  if (familyRow != null) {
                    scope = scope | tbl.familyId.equals(familyRow.id);
                  }
                  return tbl.deletedAt.isNull() & scope;
                })
                ..orderBy([(tbl) => OrderingTerm.desc(tbl.occurredAt)]))
              .get();
    final reminders = userRow == null
        ? const []
        : await (_db.select(_db.reminders)
                ..where((tbl) {
                  var scope = tbl.ownerUserId.equals(userRow.id);
                  if (familyRow != null) {
                    scope = scope | tbl.familyId.equals(familyRow.id);
                  }
                  return scope;
                })
                ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
              .get();
    final notifications = userRow == null
        ? const []
        : await (_db.select(_db.appNotifications)
                ..where((tbl) {
                  var scope = tbl.userId.equals(userRow.id);
                  if (familyRow != null) {
                    scope = scope | tbl.familyId.equals(familyRow.id);
                  }
                  return scope & tbl.isDeleted.equals(false);
                })
                ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
              .get();
    final inviteRows = userRow == null
        ? const []
        : await (_db.select(
            _db.familyInvites,
          )..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])).get();
    final invites = userRow == null
        ? const []
        : inviteRows.where((invite) {
            final emailMatches =
                invite.invitedEmail.toLowerCase() ==
                userRow.email.toLowerCase();
            final sentByUser = invite.invitedByUserId == userRow.id;
            final sameFamily =
                familyRow != null && invite.familyId == familyRow.id;
            return emailMatches || sentByUser || sameFamily;
          }).toList();
    final vaccines = babyRow == null
        ? const []
        : await (_db.select(_db.vaccineEvents)
                ..where((tbl) => tbl.babyId.equals(babyRow.id))
                ..orderBy([(tbl) => OrderingTerm.asc(tbl.dueDate)]))
              .get();
    final articles = await _loadArticles();
    final effectiveMode = babyRow != null
        ? CareMode.baby.name
        : pregnancyRow != null
        ? CareMode.pregnancy.name
        : _settingForUser(settingMap, 'mode', userRow?.id) ??
              CareMode.pregnancy.name;
    final hasCompletedSetup =
        userRow != null &&
        (babyRow != null ||
            pregnancyRow != null ||
            _settingForUser(settingMap, 'onboardingComplete', userRow.id) ==
                'true');
    return AppSnapshot(
      user: userRow == null
          ? null
          : UserProfile(
              id: userRow.id,
              name: userRow.name,
              email: userRow.email,
              emailVerified: userRow.emailVerified,
              avatarUrl: userRow.avatarUrl,
              birthDate: userRow.birthDate,
              phone: userRow.phone,
              role: userRow.role,
              createdAt: userRow.createdAt,
              language: userRow.language,
              theme: userRow.theme,
            ),
      family: familyRow == null
          ? null
          : domain.Family(
              id: familyRow.id,
              ownerUserId: familyRow.ownerUserId,
              partnerUserIds: (jsonDecode(familyRow.partnerUserIds) as List)
                  .map((e) => e.toString())
                  .toList(),
              activeBabyId: familyRow.activeBabyId,
              createdAt: familyRow.createdAt,
            ),
      baby: babyRow == null
          ? null
          : BabyProfile(
              id: babyRow.id,
              familyId: babyRow.familyId,
              name: babyRow.name,
              birthDate: babyRow.birthDate,
              gender: babyRow.gender,
              birthWeight: babyRow.birthWeight,
              birthHeight: babyRow.birthHeight,
              birthHeadCircumference: babyRow.birthHeadCircumference,
              currentWeight: babyRow.currentWeight,
              currentHeight: babyRow.currentHeight,
              currentHeadCircumference: babyRow.currentHeadCircumference,
              createdAt: babyRow.createdAt,
            ),
      pregnancy: pregnancyRow == null
          ? null
          : PregnancyProfile(
              id: pregnancyRow.id,
              userId: pregnancyRow.userId,
              startDate: pregnancyRow.startDate,
              dueDate: pregnancyRow.dueDate,
              status: pregnancyRow.status,
              birthCompletedAt: pregnancyRow.birthCompletedAt,
            ),
      mode: CareMode.values.byName(effectiveMode),
      onboardingComplete: hasCompletedSetup,
      localeCode:
          _settingForUser(settingMap, 'localeCode', userRow?.id) ??
          userRow?.language ??
          'tr',
      records: records
          .map(
            (row) => domain.TrackerRecord(
              id: row.id,
              type: RecordType.values.byName(row.type),
              title: row.title,
              familyId: row.familyId,
              babyId: row.babyId,
              value: row.value,
              note: row.note,
              createdByUserId: row.createdByUserId,
              createdByName: row.createdByName,
              updatedByUserId: row.updatedByUserId,
              updatedByName: row.updatedByName,
              occurredAt: row.occurredAt,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
              syncStatus: SyncStatus.values.byName(row.syncStatus),
            ),
          )
          .toList(),
      reminders: reminders
          .map(
            (row) => ReminderItem(
              id: row.id,
              title: row.title,
              category: ReminderCategory.values.byName(row.category),
              time: row.time,
              frequency: row.frequency,
              notes: row.notes,
              isActive: row.isActive,
              createdAt: row.createdAt,
            ),
          )
          .toList(),
      notifications: notifications
          .map(
            (row) => domain.AppNotification(
              id: row.id,
              familyId: row.familyId,
              targetUserIds: _decodeStringList(row.targetUserIds),
              createdBy: row.createdBy,
              type: row.type,
              category: row.category,
              title: row.title,
              body: row.body,
              payload: row.payload,
              readBy: _decodeStringList(row.readBy),
              seenBy: _decodeStringList(row.seenBy),
              isDeleted: row.isDeleted,
              status: AppNotificationStatus.values.byName(row.status),
              createdAt: row.createdAt,
              readAt: row.readAt,
            ),
          )
          .toList(),
      invites: invites
          .map(
            (row) => domain.FamilyInvite(
              id: row.id,
              familyId: row.familyId,
              invitedEmail: row.invitedEmail,
              invitedByUserId: row.invitedByUserId,
              invitedByName: row.invitedByName,
              invitedDisplayName: row.invitedDisplayName,
              roleLabel: row.roleLabel,
              permissions: _decodePermissions(row.permissionsJson),
              acceptedUserId: row.acceptedUserId,
              status: FamilyInviteStatus.values.byName(row.status),
              createdAt: row.createdAt,
              respondedAt: row.respondedAt,
            ),
          )
          .toList(),
      vaccines: vaccines
          .map(
            (row) => domain.VaccineEvent(
              id: row.id,
              babyId: row.babyId,
              title: row.title,
              dose: row.dose,
              dueDate: row.dueDate,
              status: _effectiveVaccineStatus(row),
              notes: row.notes,
              completedAt: row.completedAt,
              createdAt: row.createdAt,
            ),
          )
          .toList(),
      articles: articles,
      notificationsEnabled:
          _settingForUser(settingMap, 'notificationsEnabled', userRow?.id) !=
          'false',
      healthNotificationsEnabled:
          _settingForUser(
            settingMap,
            'healthNotificationsEnabled',
            userRow?.id,
          ) !=
          'false',
      familyNotificationsEnabled:
          _settingForUser(
            settingMap,
            'familyNotificationsEnabled',
            userRow?.id,
          ) !=
          'false',
      reminderNotificationsEnabled:
          _settingForUser(
            settingMap,
            'reminderNotificationsEnabled',
            userRow?.id,
          ) !=
          'false',
      notificationSound:
          _settingForUser(settingMap, 'notificationSound', userRow?.id) ??
          'soft_chime',
    );
  }

  Future<void> seedContent() async {
    const disclaimer =
        'Bu bilgi tıbbi teşhis veya tedavi yerine geçmez. Acil veya şüpheli durumda sağlık uzmanına başvurun.';
    await _db.batch((batch) {
      batch.insertAll(_db.articles, [
        ArticlesCompanion.insert(
          id: 'safe-sleep',
          careMode: const Value('baby'),
          title: 'Bebeklerde Güvenli Uyku Rutini',
          category: 'Uyku',
          summary:
              'Sırtüstü uyku, ayrı uyku alanı ve boş beşik için pratik kontrol listesi.',
          content:
              'Her uyku için bebeği sırtüstü yatırın. Uyku alanı sert, düz ve çarşafı gergin olmalı; yastık, gevşek battaniye, oyuncak ve yatak bumperı bulunmamalı. Oda paylaşımı yapılabilir, yatak paylaşımı güvenli kabul edilmez.',
          readingMinutes: 8,
          sourceName: 'AAP',
          sourceUrl: 'https://www.aap.org/en/patient-care/safe-sleep/',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'solid-food',
          careMode: const Value('baby'),
          title: 'Ek Gıdaya Geçişte Alerjen Kuralları',
          category: 'Beslenme',
          summary: 'Yeni gıdaları sakin ve takip edilebilir biçimde tanıtma.',
          content:
              'AAP, katı gıdaya hazır oluşu baş kontrolü, destekli oturma ve yiyeceğe ilgi gibi işaretlerle birlikte değerlendirir. Yeni tek bileşenli gıdaları birkaç gün arayla denemek reaksiyonları ayırt etmeyi kolaylaştırır. Yumurta, süt, soya, fıstık ürünleri ve balık gibi bebek için güvenli alerjenleri gereksiz yere geciktirmek alerjiyi önlediği gösterilmiş bir yaklaşım değildir; ciddi egzama veya yumurta alerjisinde doktorla plan yapılmalıdır.',
          readingMinutes: 7,
          sourceName: 'AAP HealthyChildren',
          sourceUrl:
              'https://www.healthychildren.org/English/ages-stages/baby/feeding-nutrition/Pages/Starting-Solid-Foods.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'breastfeeding-policy',
          careMode: const Value('baby'),
          title: 'Anne Sütü, Mama ve İlk 6 Ay',
          category: 'Beslenme',
          summary:
              'Beslenme kararlarını suçluluk yerine sürdürülebilir bakım planıyla ele alma.',
          content:
              'AAP yalnızca anne sütünü yaklaşık ilk 6 ay için önerir ve katı gıdalar başladıktan sonra aile istediği sürece devamını destekler. Bazı aileler mama kullanır, karma besler veya daha kısa emzirir; önemli olan bebeğin güvenli, yeterli ve takip edilebilir beslenmesidir. Mama hazırlanırken sulandırma talimatlarına uyun ve artan mamayı güvenli sürelerin dışında kullanmayın.',
          readingMinutes: 6,
          sourceName: 'AAP HealthyChildren',
          sourceUrl:
              'https://www.healthychildren.org/English/ages-stages/baby/breastfeeding/pages/Where-We-Stand-Breastfeeding.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'fever-when-to-call',
          careMode: const Value('baby'),
          title: 'Ateş: Ne Zaman Doktoru Aramalı?',
          category: 'Sağlık',
          summary:
              'Ateşi tek sayı olarak değil yaş, genel durum ve eşlik eden belirtilerle değerlendirme.',
          content:
              'AAP aile kaynakları ateşin çoğu zaman vücudun enfeksiyonla yanıtı olduğunu, tek başına tanı olmadığını vurgular. Yenidoğan ve küçük bebeklerde ateş daha dikkatli değerlendirilir. Nefes alma güçlüğü, dalgınlık, beslenememe, morarma, havale, sıvı kaybı veya ebeveynin güçlü endişesi varsa beklemeyin ve sağlık profesyoneline ulaşın.',
          readingMinutes: 5,
          sourceName: 'AAP HealthyChildren',
          sourceUrl:
              'https://www.healthychildren.org/english/health-issues/conditions/fever/pages/default.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'well-child-visits',
          careMode: const Value('baby'),
          title: 'Sağlam Çocuk Ziyaretleri',
          category: 'Kontrol',
          summary:
              'Aşı, büyüme, gelişim ve aile sorularını düzenli ziyaretlerde bir araya getirme.',
          content:
              'Bright Futures/AAP periyodik bakım takvimi bebeklikten ergenliğe kadar tarama, değerlendirme ve danışmanlığı yapılandırır. İlk hafta, 1., 2., 4., 6., 9., 12., 15. ve 18. ay ziyaretleri ailelerin büyüme, beslenme, güvenlik, uyku ve gelişim sorularını sorması için önemli temas noktalarıdır.',
          readingMinutes: 5,
          sourceName: 'AAP Bright Futures',
          sourceUrl:
              'https://www.healthychildren.org/English/family-life/health-management/Pages/Well-Child-Care-A-Check-Up-for-Success.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'tummy-time',
          careMode: const Value('baby'),
          title: 'Sırtüstü Uyku, Yüzüstü Oyun',
          category: 'Gelişim',
          summary:
              'Uyurken güvenli sırtüstü pozisyonu, uyanıkken kısa ve izlenen karın üstü oyunlar.',
          content:
              'AAP, sağlıklı bebeklerin uyku için sırtüstü yatırılmasını; karın üstü zamanın ise yalnızca bebek uyanıkken ve izlenirken yapılmasını önerir. Hastaneden eve gelinen günden başlayarak kısa, sık ve keyifli denemeler boyun ve omuz gücünü destekleyebilir.',
          readingMinutes: 4,
          sourceName: 'AAP HealthyChildren',
          sourceUrl:
              'https://www.healthychildren.org/English/ages-stages/baby/sleep/Pages/back-to-sleep-tummy-to-play.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'bright-futures-family',
          careMode: const Value('baby'),
          title: 'Aile Merkezli Bakım',
          category: 'Aile',
          summary:
              'Ebeveynin gözlemini bakım ekibiyle ortak kararın parçası yapma.',
          content:
              'Bright Futures aileleri çocuğun sağlığında aktif ortak olarak görür. Kontrole giderken gözlemleri, soruları, beslenme-uyku düzenini, güvenlik kaygılarını ve aile desteği ihtiyacını kısa notlarla hazırlamak randevuyu daha verimli yapar.',
          readingMinutes: 4,
          sourceName: 'AAP Bright Futures',
          sourceUrl:
              'https://www.aap.org/en/practice-management/bright-futures/bright-futures-family-centered-care/',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'growth-who',
          careMode: const Value('baby'),
          title: 'Büyüme Eğrilerini Okuma',
          category: 'Gelişim',
          summary:
              'Kilo, boy ve baş çevresini WHO eğrileriyle sakin biçimde yorumlama.',
          content:
              'CDC ve AAP, doğumdan 2 yaşa kadar WHO büyüme standartlarının; 2 yaş sonrası CDC eğrilerinin kullanılmasını önerir. Tek ölçümden çok trend önemlidir. Ölçüm bandın dışına çıkarsa ya da eğri hızlı değişirse çocuk doktoruyla birlikte değerlendirin.',
          readingMinutes: 6,
          sourceName: 'CDC/AAP',
          sourceUrl:
              'https://www.cdc.gov/growth-chart-training/hcp/using-growth-charts/who-summary.html',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'oral-health-first-tooth',
          careMode: const Value('baby'),
          title: 'İlk Diş ve Ağız Bakımı',
          category: 'Ağız Sağlığı',
          summary:
              'İlk diş çıktığında florürlü macun, vernik ve diş hekimi planını sakinleştiren rehber.',
          content:
              'AAP, ağız sağlığının ilk dişten önce konuşulmasını ve ilk diş göründüğünde bakımın başlamasını önerir. İlk diş çıktığında pirinç tanesi kadar florürlü macunla fırçalama, florür vernik ihtiyacını çocuk doktoruyla konuşma ve ilk dişten sonraki 6 ay içinde ya da 1 yaşa kadar diş hekimi ziyareti planlama iyi bir başlangıçtır. Biberonla uyuma, tatlı içecekler ve ortak kaşık kullanımı çürük riskini artırabilir.',
          readingMinutes: 5,
          sourceName: 'AAP HealthyChildren',
          sourceUrl:
              'https://www.healthychildren.org/English/healthy-living/oral-health/pages/Brushing-Up-on-Oral-Health-Never-Too-Early-to-Start.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'screen-time-baby',
          careMode: const Value('baby'),
          title: 'Bebeklerde Ekran ve Medya',
          category: 'Medya',
          summary:
              '18 aydan küçük bebeklerde ekran yerine gerçek etkileşim ve video görüşme istisnası.',
          content:
              'AAP, 18 aydan küçük bebeklerin en iyi gerçek dünyadaki yüz, ses, oyun ve bakım etkileşimlerinden öğrendiğini vurgular. Rutin ekran maruziyetini azaltmak, video görüşmeyi aile bağı için kısa ve birlikte kullanılan bir istisna gibi ele almak ve yemek, uyku ve sakinleşme rutinlerinde ekranı ana araç yapmamak gelişimi destekler. Daha büyük bebeklerde içerik kalitesi, ebeveynle birlikte izleme ve uyku sınırları önemlidir.',
          readingMinutes: 4,
          sourceName: 'AAP HealthyChildren',
          sourceUrl:
              'https://www.healthychildren.org/English/family-life/Media/Pages/helping-kids-thrive-in-a-digital-world-AAP-policy-explained.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'choking-prevention',
          careMode: const Value('baby'),
          title: 'Boğulma Riskini Azaltma',
          category: 'Güvenlik',
          summary:
              'Ek gıda ve hareketlilik döneminde yiyecek, küçük parça ve ilk yardım hazırlığı.',
          content:
              'AAP aile kaynakları, bebek emeklemeye veya sofra gıdalarına yaklaşmaya başladığında boğulma riskinin aktif biçimde düşünülmesini önerir. Yuvarlak sert yiyecekleri uygun şekilde kesmek, küçük oyuncak ve parçaları zeminden uzak tutmak, bebeği yemek yerken oturur ve gözetim altında tutmak temel adımlardır. Nefes alamama, morarma veya sessiz panik görürseniz beklemeden acil yardım çağırın; temel bebek ilk yardım/CPR eğitimi almak bakım planının parçası olabilir.',
          readingMinutes: 6,
          sourceName: 'AAP HealthyChildren',
          sourceUrl:
              'https://www.healthychildren.org/English/health-issues/injuries-emergencies/Pages/Choking-Prevention.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'rear-facing-car-seat',
          careMode: const Value('baby'),
          title: 'Araç Koltuğu: Arkaya Dönük Başlangıç',
          category: 'Güvenlik',
          summary:
              'İlk yolculuktan itibaren arkaya dönük koltuk ve üretici sınırlarını takip etme.',
          content:
              'AAP, bebeklerin hastaneden eve ilk yolculuktan itibaren arkaya dönük araç koltuğunda taşınmasını önerir. Bebek ve küçük çocuklar, koltuğun üretici tarafından belirtilen en yüksek kilo veya boy sınırına ulaşana kadar mümkün olduğunca arkaya dönük kalmalıdır. Koltuk araç içinde uyku veya beslenme alanı gibi kullanılmamalı; kurulum için kılavuz okunmalı ve mümkünse uzman kontrolü alınmalıdır.',
          readingMinutes: 5,
          sourceName: 'AAP HealthyChildren',
          sourceUrl:
              'https://www.healthychildren.org/English/safety-prevention/on-the-go/Pages/Car-Safety-Seats-Information-for-Families.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'crying-safe-break',
          careMode: const Value('baby'),
          title: 'Ağlama, Mola ve Güvenli Bakım',
          category: 'Ruh Sağlığı',
          summary:
              'Yoğun ağlama anında ebeveynin kendini regüle etmesi ve bebeği güvenli alana koyması.',
          content:
              'AAP, bebeğin ağlamasının ebeveynin kötü olduğu anlamına gelmediğini ve bazı günler ağlamanın çok zorlayıcı olabileceğini hatırlatır. Öfke veya panik yükselirse bebeği sırtüstü, boş ve güvenli bir uyku alanına koyup kısa bir mola vermek, derin nefes almak ve destek kişisini aramak güvenli bir adımdır. Bebeği sarsmak veya sertçe hareket ettirmek ciddi beyin hasarına yol açabilir; nefes alma güçlüğü, dalgınlık, kusma veya havale gibi belirtilerde acil yardım alın.',
          readingMinutes: 6,
          sourceName: 'AAP HealthyChildren',
          sourceUrl:
              'https://www.healthychildren.org/English/safety-prevention/at-home/Pages/Abusive-Head-Trauma-Shaken-Baby-Syndrome.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'postpartum-mood-support',
          careMode: const Value('baby'),
          title: 'Doğum Sonrası Duygu Durumu',
          category: 'Ruh Sağlığı',
          summary:
              'Depresyon ve anksiyetenin tedavi edilebilir olduğunu hatırlatan ebeveyn destek rehberi.',
          content:
              'HealthyChildren, gebelikte veya doğumdan sonraki ilk yılda görülen depresyon ve anksiyetenin kişinin suçu olmadığını, tıbbi ve tedavi edilebilir durumlar olduğunu açıklar. Üzüntü, kaygı, boşluk hissi, uyuyamama veya günlük bakımı sürdürememe belirginleşirse bunu saklamak yerine doktor, çocuk doktoru veya güvendiğiniz destek kişisiyle paylaşın. Destek istemek bakımın zayıflığı değil, ailenin güvenlik planıdır.',
          readingMinutes: 5,
          sourceName: 'AAP HealthyChildren',
          sourceUrl:
              'https://www.healthychildren.org/English/ages-stages/prenatal/Pages/Depression-and-Anxiety-During-Pregnancy-and-After-Birth-FAQs.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'planning-newborn-safety',
          careMode: const Value('planning'),
          title: 'Bebek Gelmeden Güvenlik Hazırlığı',
          category: 'Hazırlık',
          summary:
              'Güvenli uyku alanı ve araç koltuğunu gebelik oluşmadan ya da doğuma yaklaşmadan sadece planlama.',
          content:
              'Planlama döneminde amaç mükemmel bir oda kurmak değil, tekrar kullanılabilir güvenlik kararlarını erkenden netleştirmektir. AAP güvenli uyku için düz, sert ve boş uyku alanını; araç yolculuğu için arkaya dönük uygun koltuk kullanımını vurgular. Büyük satın alma listesi yerine beşik yüzeyi, uyku alanında gevşek eşya olmaması ve araç koltuğu kurulum kontrolü gibi birkaç temel adımı not edin.',
          readingMinutes: 4,
          sourceName: 'AAP HealthyChildren',
          sourceUrl:
              'https://www.healthychildren.org/English/safety-prevention/on-the-go/Pages/Car-Safety-Seats-Information-for-Families.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'planning-parent-support',
          careMode: const Value('planning'),
          title: 'Destek Ağını Önceden Kurma',
          category: 'Ruh Sağlığı',
          summary:
              'Belirsizlik, kaygı ve yorgunluk için randevu soruları ve destek kişileri listesi.',
          content:
              'Planlama dönemi bazen umutla birlikte belirsizlik de getirir. HealthyChildren gebelik ve doğum sonrası ruh sağlığı konularında duyguları saklamamak, tıbbi destek almak ve güvenilir kişilerden yardım istemek gerektiğini vurgular. Şimdiden bir destek kişisi, bir sağlık sorusu listesi ve dinlenme/kriz anı planı oluşturmak ileride yükü azaltır.',
          readingMinutes: 4,
          sourceName: 'AAP HealthyChildren',
          sourceUrl:
              'https://www.healthychildren.org/English/ages-stages/prenatal/Pages/Depression-and-Anxiety-During-Pregnancy-and-After-Birth-FAQs.aspx',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'pregnancy-weekly-rhythm',
          careMode: const Value('pregnancy'),
          title: 'Haftalık Gebelik Ritmi',
          category: 'Gebelik',
          summary:
              'Bu hafta bedende ve zihinde neler olabileceğini takip etmek için kısa rehber.',
          content:
              'Her hafta aynı üç soruyu sorun: bedenimde ne değişti, zihnim neye ihtiyaç duyuyor, bugün beni ne rahatlatır? ACOG gebelik boyunca düzenli takip, soru sorma ve güvenilir bilgiyle ilerlemeyi önerir. Kısa yürüyüş, su, düzenli öğün ve dinlenme alanı günlük rutinin omurgası olabilir.',
          readingMinutes: 5,
          sourceName: 'ACOG',
          sourceUrl:
              'https://www.acog.org/womens-health/pregnancy/during-pregnancy',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'pregnancy-mental-support',
          careMode: const Value('pregnancy'),
          title: 'Gebelikte Duygusal Destek Planı',
          category: 'Ruh Sağlığı',
          summary: 'Kaygı ve dalgalanan ruh hali için günlük destek adımları.',
          content:
              'Duyguların değişmesi yaygındır, ama yalnız taşınmak zorunda değildir. ACOG, gebelik ve doğum sonrası dönemde depresyon ve anksiyete taramasının bakımın bir parçası olmasını önerir. Bugün 10 dakika kendine ayır, bir kişiye nasıl hissettiğini söyle ve kaygı şiddetlenirse sağlık profesyoneline haber ver.',
          readingMinutes: 4,
          sourceName: 'ACOG',
          sourceUrl:
              'https://www.acog.org/programs/perinatal-mental-health/patient-screening',
          medicalDisclaimer: disclaimer,
        ),
        ArticlesCompanion.insert(
          id: 'pregnancy-baby-prep',
          careMode: const Value('pregnancy'),
          title: 'Doğuma Hazırlık ve İlk Günler',
          category: 'Hazırlık',
          summary:
              'Bebeğin doğum sonrası güvenli uyku ve bakım ihtiyaçlarına yumuşak geçiş.',
          content:
              'Gebeliğin son döneminde güvenli uyku alanını sadeleştirmek, destek kişilerini netleştirmek ve beslenme planını konuşmak işleri hafifletir. AAP güvenli uyku için düz, sert yüzey ve boş uyku alanını vurgular. Hazırlığı kusursuzluk değil, tekrar kullanılabilir küçük rutinler olarak düşünün.',
          readingMinutes: 5,
          sourceName: 'AAP',
          sourceUrl: 'https://www.aap.org/en/patient-care/safe-sleep/',
          medicalDisclaimer: disclaimer,
        ),
      ], mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> loginLocal(String email, String password) async {
    final now = DateTime.now();
    final normalized = email.trim().toLowerCase();
    final userId = _stableLocalUserId(normalized);
    final existing = await (_db.select(
      _db.users,
    )..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
    final fallbackName = normalized.split('@').first;
    await _db
        .into(_db.users)
        .insertOnConflictUpdate(
          UsersCompanion.insert(
            id: userId,
            name:
                existing?.name ??
                (fallbackName.isEmpty ? 'MiniAdımlar' : fallbackName),
            email: normalized,
            emailVerified: const Value(true),
            avatarUrl: Value(existing?.avatarUrl),
            birthDate: Value(existing?.birthDate),
            phone: Value(existing?.phone),
            role: Value(existing?.role),
            language: Value(existing?.language ?? 'tr'),
            theme: Value(existing?.theme ?? 'light'),
            createdAt: existing?.createdAt ?? now,
          ),
        );
    await setSetting('currentUserId', userId);
    await setUserSetting(userId, 'localeCode', 'tr');
    await _attachPendingInvitesForUser(userId, normalized);
  }

  Future<void> upsertAuthenticatedUser({
    required String id,
    required String email,
    required String displayName,
    required bool emailVerified,
    String? avatarUrl,
    String? phone,
  }) async {
    final now = DateTime.now();
    final normalizedEmail = email.trim().toLowerCase();
    final existing = await (_db.select(
      _db.users,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    final resolvedName = displayName.trim().isEmpty
        ? existing?.name ?? 'MiniAdımlar'
        : displayName.trim();
    final resolvedAvatar = avatarUrl?.trim().isEmpty ?? true
        ? existing?.avatarUrl
        : avatarUrl!.trim();
    final resolvedPhone = phone?.trim().isEmpty ?? true
        ? existing?.phone
        : phone!.trim();
    await _db
        .into(_db.users)
        .insertOnConflictUpdate(
          UsersCompanion.insert(
            id: id,
            name: resolvedName,
            email: normalizedEmail,
            emailVerified: Value(
              emailVerified || existing?.emailVerified == true,
            ),
            avatarUrl: Value(resolvedAvatar),
            birthDate: Value(existing?.birthDate),
            phone: Value(resolvedPhone),
            role: Value(existing?.role),
            language: Value(existing?.language ?? 'tr'),
            theme: Value(existing?.theme ?? 'light'),
            createdAt: existing?.createdAt ?? now,
          ),
        );
    await setSetting('currentUserId', id);
    await setUserSetting(id, 'localeCode', existing?.language ?? 'tr');
    await _attachPendingInvitesForUser(id, normalizedEmail);
  }

  Future<void> updateUserProfile({
    required String name,
    required String email,
    DateTime? birthDate,
    String? phone,
    String? role,
  }) async {
    final userId = await _currentUserId();
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(userId))).write(
      UsersCompanion(
        name: Value(name.trim().isEmpty ? 'MiniAdımlar' : name.trim()),
        email: Value(email.trim()),
        birthDate: Value(birthDate),
        phone: Value(phone?.trim().isEmpty ?? true ? null : phone!.trim()),
        role: Value(role?.trim().isEmpty ?? true ? null : role!.trim()),
      ),
    );
  }

  Future<void> setCurrentUserEmailVerified(bool value) async {
    final userId = await _currentUserId();
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(userId))).write(
      UsersCompanion(emailVerified: Value(value)),
    );
  }

  Future<void> setLocale(String code) async {
    final userId = await _currentUserId();
    await setUserSetting(userId, 'localeCode', code);
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(userId))).write(
      UsersCompanion(language: Value(code)),
    );
  }

  Future<void> setTheme(String theme) async {
    final userId = await _currentUserId();
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(userId))).write(
      UsersCompanion(theme: Value(theme)),
    );
  }

  Future<void> setNotificationPreferences({
    required bool notificationsEnabled,
    required bool healthEnabled,
    required bool familyEnabled,
    required bool reminderEnabled,
    required String sound,
  }) async {
    final userId = await _currentUserId();
    await setUserSetting(
      userId,
      'notificationsEnabled',
      '$notificationsEnabled',
    );
    await setUserSetting(
      userId,
      'healthNotificationsEnabled',
      '$healthEnabled',
    );
    await setUserSetting(
      userId,
      'familyNotificationsEnabled',
      '$familyEnabled',
    );
    await setUserSetting(
      userId,
      'reminderNotificationsEnabled',
      '$reminderEnabled',
    );
    await setUserSetting(userId, 'notificationSound', sound);
  }

  Future<void> setSetting(String key, String value) {
    return _db
        .into(_db.settingsRows)
        .insertOnConflictUpdate(
          SettingsRowsCompanion.insert(key: key, value: value),
        );
  }

  Future<void> setUserSetting(String userId, String key, String value) {
    return setSetting(_userSettingKey(userId, key), value);
  }

  Future<void> setActiveFamilyForUser(String userId, String familyId) {
    return setUserSetting(userId, 'activeFamilyId', familyId);
  }

  Future<void> completePregnancyOnboarding({
    required String parentName,
    required DateTime dueDate,
  }) async {
    final now = DateTime.now();
    final userId = await _currentUserId();
    final startDate = dueDate.subtract(const Duration(days: 280));
    final familyId = 'family-$userId';
    await _db
        .into(_db.families)
        .insertOnConflictUpdate(
          FamiliesCompanion.insert(
            id: familyId,
            ownerUserId: userId,
            createdAt: now,
          ),
        );
    await _db
        .into(_db.pregnancies)
        .insertOnConflictUpdate(
          PregnanciesCompanion.insert(
            id: 'pregnancy-$userId',
            userId: userId,
            startDate: startDate,
            dueDate: dueDate,
            status: 'active',
          ),
        );
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(userId))).write(
      UsersCompanion(name: Value(parentName)),
    );
    await setActiveFamilyForUser(userId, familyId);
    await setUserSetting(userId, 'mode', CareMode.pregnancy.name);
    await setUserSetting(userId, 'onboardingComplete', 'true');
  }

  Future<void> completePlanningOnboarding({required String parentName}) async {
    final userId = await _currentUserId();
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(userId))).write(
      UsersCompanion(name: Value(parentName)),
    );
    await setUserSetting(userId, 'mode', CareMode.planning.name);
    await setUserSetting(userId, 'onboardingComplete', 'true');
  }

  Future<void> completeBabyOnboarding({
    required String parentName,
    required String babyName,
    required DateTime birthDate,
    double? weight,
    double? height,
    double? headCircumference,
  }) async {
    if (birthDate.isAfter(DateTime.now())) {
      throw ArgumentError('Birth date cannot be in the future.');
    }
    final now = DateTime.now();
    final userId = await _currentUserId();
    final familyId = 'family-$userId';
    final babyId = 'baby-$userId';
    await _db
        .into(_db.families)
        .insertOnConflictUpdate(
          FamiliesCompanion.insert(
            id: familyId,
            ownerUserId: userId,
            activeBabyId: Value(babyId),
            createdAt: now,
          ),
        );
    await _db
        .into(_db.babies)
        .insertOnConflictUpdate(
          BabiesCompanion.insert(
            id: babyId,
            familyId: familyId,
            name: babyName,
            birthDate: birthDate,
            birthWeight: Value(weight),
            birthHeight: Value(height),
            birthHeadCircumference: Value(headCircumference),
            currentWeight: Value(weight),
            currentHeight: Value(height),
            currentHeadCircumference: Value(headCircumference),
            createdAt: now,
          ),
        );
    final babyRow = await (_db.select(
      _db.babies,
    )..where((tbl) => tbl.id.equals(babyId))).getSingle();
    await _seedVaccineEvents(babyRow);
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(userId))).write(
      UsersCompanion(name: Value(parentName)),
    );
    await setActiveFamilyForUser(userId, familyId);
    await setUserSetting(userId, 'mode', CareMode.baby.name);
    await setUserSetting(userId, 'onboardingComplete', 'true');
  }

  Future<void> addFamilyPartner(
    String email, {
    String? displayName,
    String? roleLabel,
    List<FamilyPermission>? permissions,
  }) async {
    final userId = await _currentUserId();
    final family = await _currentFamilyRow(userId);
    if (family == null) return;
    final normalized = email.trim().toLowerCase();
    if (normalized.isEmpty) return;
    final currentUser = await (_db.select(
      _db.users,
    )..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
    if (currentUser != null && currentUser.email.toLowerCase() == normalized) {
      throw ArgumentError('Kendi hesabınıza davet gönderemezsiniz.');
    }
    final now = DateTime.now();
    final inviteId = 'invite-${family.id}-$normalized';
    final effectiveRole = roleLabel?.trim().isEmpty ?? true
        ? 'Ebeveyn'
        : roleLabel!.trim();
    final effectiveDisplayName = displayName?.trim().isEmpty ?? true
        ? effectiveRole
        : displayName!.trim();
    final effectivePermissions =
        permissions ?? FamilyPermissionSets.defaultsForRole(effectiveRole);
    final invitedUser = await (_db.select(
      _db.users,
    )..where((tbl) => tbl.email.equals(normalized))).getSingleOrNull();
    await _db
        .into(_db.familyInvites)
        .insertOnConflictUpdate(
          FamilyInvitesCompanion.insert(
            id: inviteId,
            familyId: family.id,
            invitedEmail: normalized,
            invitedByUserId: userId,
            invitedByName: currentUser?.name ?? 'MiniAdımlar',
            invitedDisplayName: Value(effectiveDisplayName),
            roleLabel: Value(effectiveRole),
            permissionsJson: Value(_encodePermissions(effectivePermissions)),
            status: Value(FamilyInviteStatus.pending.name),
            createdAt: now,
          ),
        );
    if (invitedUser != null) {
      await _createNotification(
        type: 'family_invite',
        category: 'family',
        title: 'Aile daveti',
        body:
            '${currentUser?.name ?? 'Ana kullanıcı'} sizi ortak aile hesabına davet etti. Gönderim: ${_formatDateTime(now)}.',
        payload: inviteId,
        userId: invitedUser.id,
        createdAt: now,
        attachCurrentFamily: false,
      );
    }
  }

  Future<void> updateFamilyInvitePermissions({
    required String inviteId,
    String? displayName,
    String? roleLabel,
    required List<FamilyPermission> permissions,
  }) async {
    final invite = await (_db.select(
      _db.familyInvites,
    )..where((tbl) => tbl.id.equals(inviteId))).getSingleOrNull();
    if (invite == null) return;
    final effectiveRole = roleLabel?.trim().isEmpty ?? true
        ? invite.roleLabel ?? 'Ebeveyn'
        : roleLabel!.trim();
    final effectiveDisplayName = displayName?.trim().isEmpty ?? true
        ? invite.invitedDisplayName ?? effectiveRole
        : displayName!.trim();
    await (_db.update(
      _db.familyInvites,
    )..where((tbl) => tbl.id.equals(inviteId))).write(
      FamilyInvitesCompanion(
        invitedDisplayName: Value(effectiveDisplayName),
        roleLabel: Value(effectiveRole),
        permissionsJson: Value(_encodePermissions(permissions)),
      ),
    );
  }

  Future<void> removeFamilyMember(String inviteId) async {
    final invite = await (_db.select(
      _db.familyInvites,
    )..where((tbl) => tbl.id.equals(inviteId))).getSingleOrNull();
    if (invite == null) return;
    final family = await (_db.select(
      _db.families,
    )..where((tbl) => tbl.id.equals(invite.familyId))).getSingleOrNull();
    final userId = await _currentUserIdOrNull();
    final normalizedEmail = invite.invitedEmail.trim().toLowerCase();
    if (family != null) {
      final partners = (jsonDecode(family.partnerUserIds) as List)
          .map((item) => item.toString().trim().toLowerCase())
          .where(
            (item) =>
                item.isNotEmpty &&
                item != normalizedEmail &&
                item != invite.acceptedUserId?.trim().toLowerCase(),
          )
          .toSet()
          .toList();
      await (_db.update(
        _db.families,
      )..where((tbl) => tbl.id.equals(family.id))).write(
        FamiliesCompanion(partnerUserIds: Value(jsonEncode(partners))),
      );
    }
    final now = DateTime.now();
    await (_db.update(
      _db.familyInvites,
    )..where((tbl) => tbl.id.equals(inviteId))).write(
      FamilyInvitesCompanion(
        status: Value(FamilyInviteStatus.declined.name),
        acceptedUserId: const Value<String?>(null),
        respondedAt: Value(now),
      ),
    );
    if (userId != null && invite.acceptedUserId == userId) {
      await (_db.delete(_db.settingsRows)..where(
            (tbl) =>
                tbl.key.equals(_userSettingKey(userId, 'activeFamilyId')) &
                tbl.value.equals(invite.familyId),
          ))
          .go();
    }
  }

  Future<void> acceptFamilyInvite(String inviteId) async {
    final invite = await (_db.select(
      _db.familyInvites,
    )..where((tbl) => tbl.id.equals(inviteId))).getSingleOrNull();
    if (invite == null || invite.status != FamilyInviteStatus.pending.name) {
      return;
    }
    final family = await (_db.select(
      _db.families,
    )..where((tbl) => tbl.id.equals(invite.familyId))).getSingleOrNull();
    if (family == null) return;
    final userId = await _currentUserId();
    final user = await (_db.select(
      _db.users,
    )..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
    final partners =
        (jsonDecode(family.partnerUserIds) as List)
            .map((e) => e.toString())
            .toSet()
          ..add((user?.email ?? invite.invitedEmail).toLowerCase());
    final now = DateTime.now();
    await (_db.update(
      _db.families,
    )..where((tbl) => tbl.id.equals(family.id))).write(
      FamiliesCompanion(partnerUserIds: Value(jsonEncode(partners.toList()))),
    );
    await (_db.update(
      _db.familyInvites,
    )..where((tbl) => tbl.id.equals(inviteId))).write(
      FamilyInvitesCompanion(
        status: Value(FamilyInviteStatus.accepted.name),
        acceptedUserId: Value(userId),
        respondedAt: Value(now),
      ),
    );
    await setActiveFamilyForUser(userId, family.id);
    await _markInviteNotification(inviteId, AppNotificationStatus.accepted);
  }

  Future<void> declineFamilyInvite(String inviteId) async {
    final now = DateTime.now();
    await (_db.update(
      _db.familyInvites,
    )..where((tbl) => tbl.id.equals(inviteId))).write(
      FamilyInvitesCompanion(
        status: Value(FamilyInviteStatus.declined.name),
        respondedAt: Value(now),
      ),
    );
    await _markInviteNotification(inviteId, AppNotificationStatus.declined);
  }

  Future<void> markNotificationRead(String notificationId) async {
    final userId = await _currentUserIdOrNull();
    final now = DateTime.now();
    final existing = await (_db.select(
      _db.appNotifications,
    )..where((tbl) => tbl.id.equals(notificationId))).getSingleOrNull();
    final readBy = {
      ..._decodeStringList(existing?.readBy ?? '[]'),
      ...?(userId == null ? null : [userId]),
    };
    final seenBy = {
      ..._decodeStringList(existing?.seenBy ?? '[]'),
      ...?(userId == null ? null : [userId]),
    };
    await (_db.update(
      _db.appNotifications,
    )..where((tbl) => tbl.id.equals(notificationId))).write(
      AppNotificationsCompanion(
        status: Value(AppNotificationStatus.read.name),
        readAt: Value(now),
        readBy: Value(_encodeStringList(readBy)),
        seenBy: Value(_encodeStringList(seenBy)),
      ),
    );
  }

  Future<List<String>> markNotificationsReadForCurrentUser() async {
    final userId = await _currentUserIdOrNull();
    if (userId == null) return const [];
    final familyId = await _currentFamilyIdOrNull(userId);
    final rows =
        await (_db.select(_db.appNotifications)..where((tbl) {
              var scope = tbl.userId.equals(userId);
              if (familyId != null) {
                scope = scope | tbl.familyId.equals(familyId);
              }
              return scope &
                  tbl.isDeleted.equals(false) &
                  tbl.status.equals(AppNotificationStatus.unread.name);
            }))
            .get();
    final now = DateTime.now();
    for (final row in rows) {
      final readBy = {..._decodeStringList(row.readBy), userId};
      final seenBy = {..._decodeStringList(row.seenBy), userId};
      await (_db.update(
        _db.appNotifications,
      )..where((tbl) => tbl.id.equals(row.id))).write(
        AppNotificationsCompanion(
          status: Value(AppNotificationStatus.read.name),
          readAt: Value(now),
          readBy: Value(_encodeStringList(readBy)),
          seenBy: Value(_encodeStringList(seenBy)),
        ),
      );
    }
    return rows.map((row) => row.id).toList();
  }

  Future<void> updateBabyProfile({
    required String babyId,
    required String name,
    required DateTime birthDate,
    String? gender,
    double? birthWeight,
    double? birthHeight,
    double? birthHeadCircumference,
  }) async {
    if (birthDate.isAfter(DateTime.now())) {
      throw ArgumentError('Birth date cannot be in the future.');
    }
    await (_db.update(_db.babies)..where((tbl) => tbl.id.equals(babyId))).write(
      BabiesCompanion(
        name: Value(name.trim().isEmpty ? 'Bebek' : name.trim()),
        birthDate: Value(birthDate),
        gender: Value(gender?.trim().isEmpty ?? true ? null : gender!.trim()),
        birthWeight: Value(birthWeight),
        birthHeight: Value(birthHeight),
        birthHeadCircumference: Value(birthHeadCircumference),
        currentWeight: Value(birthWeight),
        currentHeight: Value(birthHeight),
        currentHeadCircumference: Value(birthHeadCircumference),
      ),
    );
    final baby = await (_db.select(
      _db.babies,
    )..where((tbl) => tbl.id.equals(babyId))).getSingle();
    await _seedVaccineEvents(baby);
  }

  Future<void> updatePregnancyProfile({
    required String pregnancyId,
    required DateTime dueDate,
  }) async {
    await (_db.update(
      _db.pregnancies,
    )..where((tbl) => tbl.id.equals(pregnancyId))).write(
      PregnanciesCompanion(
        dueDate: Value(dueDate),
        startDate: Value(dueDate.subtract(const Duration(days: 280))),
      ),
    );
  }

  Future<void> completeBirthFromPregnancy({
    required String babyName,
    required DateTime birthDate,
    double? weight,
    double? height,
    double? headCircumference,
  }) async {
    if (birthDate.isAfter(DateTime.now())) {
      throw ArgumentError('Doğum tarihi gelecekte olamaz.');
    }
    final now = DateTime.now();
    final userId = await _currentUserId();
    final familyId = 'family-$userId';
    final babyId = 'baby-$userId';
    await _db
        .into(_db.families)
        .insertOnConflictUpdate(
          FamiliesCompanion.insert(
            id: familyId,
            ownerUserId: userId,
            activeBabyId: Value(babyId),
            createdAt: now,
          ),
        );
    await _db
        .into(_db.babies)
        .insertOnConflictUpdate(
          BabiesCompanion.insert(
            id: babyId,
            familyId: familyId,
            name: babyName.trim().isEmpty ? 'Bebek' : babyName.trim(),
            birthDate: birthDate,
            birthWeight: Value(weight),
            birthHeight: Value(height),
            birthHeadCircumference: Value(headCircumference),
            currentWeight: Value(weight),
            currentHeight: Value(height),
            currentHeadCircumference: Value(headCircumference),
            createdAt: now,
          ),
        );
    await (_db.update(
      _db.pregnancies,
    )..where((tbl) => tbl.userId.equals(userId))).write(
      PregnanciesCompanion(
        status: const Value('completed'),
        birthCompletedAt: Value(now),
      ),
    );
    final baby = await (_db.select(
      _db.babies,
    )..where((tbl) => tbl.id.equals(babyId))).getSingle();
    await _seedVaccineEvents(baby);
    await setUserSetting(userId, 'mode', CareMode.baby.name);
    await setUserSetting(userId, 'onboardingComplete', 'true');
    await _createNotification(
      type: 'birth_completed',
      category: 'family',
      title: 'Bebek profili başladı',
      body: 'Doğum bilgileri kaydedildi. Büyüme ve bakım takibi aktif.',
      userId: userId,
      familyId: familyId,
    );
  }

  Future<void> completeVaccine(String vaccineId, bool completed) async {
    await (_db.update(
      _db.vaccineEvents,
    )..where((tbl) => tbl.id.equals(vaccineId))).write(
      VaccineEventsCompanion(
        status: Value(
          completed
              ? VaccineStatus.completed.name
              : VaccineStatus.upcoming.name,
        ),
        completedAt: Value(completed ? DateTime.now() : null),
      ),
    );
  }

  Future<void> addRecord(domain.TrackerRecord record) async {
    await _db
        .into(_db.trackerRecords)
        .insertOnConflictUpdate(
          TrackerRecordsCompanion.insert(
            id: record.id,
            type: record.type.name,
            title: record.title,
            familyId: Value(record.familyId),
            babyId: Value(record.babyId),
            value: Value(record.value),
            note: Value(record.note),
            createdByUserId: Value(record.createdByUserId),
            createdByName: Value(record.createdByName),
            updatedByUserId: Value(record.updatedByUserId),
            updatedByName: Value(record.updatedByName),
            occurredAt: record.occurredAt,
            createdAt: record.createdAt,
            updatedAt: record.updatedAt,
            syncStatus: Value(record.syncStatus.name),
          ),
        );
    if (record.type == RecordType.growth && record.babyId != null) {
      await _refreshBabyGrowthFromHistory(record.babyId!);
    }
    await _db
        .into(_db.syncQueueItems)
        .insertOnConflictUpdate(
          SyncQueueItemsCompanion.insert(
            id: 'sync-${record.id}',
            entityKind: 'trackerRecord',
            entityId: record.id,
            status: 'pending',
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> updateRecord(domain.TrackerRecord record) async {
    await (_db.update(
      _db.trackerRecords,
    )..where((tbl) => tbl.id.equals(record.id))).write(
      TrackerRecordsCompanion(
        title: Value(record.title),
        value: Value(record.value),
        note: Value(record.note),
        createdByName: Value(record.createdByName),
        updatedByUserId: Value(record.updatedByUserId),
        updatedByName: Value(record.updatedByName),
        updatedAt: Value(record.updatedAt),
        syncStatus: Value(record.syncStatus.name),
        deletedAt: const Value(null),
      ),
    );
    if (record.type == RecordType.growth && record.babyId != null) {
      await _refreshBabyGrowthFromHistory(record.babyId!);
    }
    await _db
        .into(_db.syncQueueItems)
        .insertOnConflictUpdate(
          SyncQueueItemsCompanion.insert(
            id: 'sync-${record.id}',
            entityKind: 'trackerRecord',
            entityId: record.id,
            status: 'pending',
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> deleteRecord(String recordId) async {
    final record = await (_db.select(
      _db.trackerRecords,
    )..where((tbl) => tbl.id.equals(recordId))).getSingleOrNull();
    if (record == null) return;
    final now = DateTime.now();
    await (_db.update(
      _db.trackerRecords,
    )..where((tbl) => tbl.id.equals(recordId))).write(
      TrackerRecordsCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        syncStatus: Value(SyncStatus.pending.name),
      ),
    );
    if (record.type == RecordType.growth.name && record.babyId != null) {
      await _refreshBabyGrowthFromHistory(record.babyId!);
    }
    await _db
        .into(_db.syncQueueItems)
        .insertOnConflictUpdate(
          SyncQueueItemsCompanion.insert(
            id: 'sync-$recordId',
            entityKind: 'trackerRecord',
            entityId: recordId,
            status: 'pending',
            createdAt: now,
          ),
        );
  }

  Future<void> addReminder(ReminderItem reminder) async {
    final userId = await _currentUserId();
    final family = await _currentFamilyRow(userId);
    await _db
        .into(_db.reminders)
        .insertOnConflictUpdate(
          RemindersCompanion.insert(
            id: reminder.id,
            title: reminder.title,
            category: reminder.category.name,
            time: reminder.time,
            frequency: Value(reminder.frequency),
            notes: Value(reminder.notes),
            isActive: Value(reminder.isActive),
            ownerUserId: Value(userId),
            familyId: Value(family?.id),
            createdAt: reminder.createdAt,
          ),
        );
    await _createNotification(
      type: 'reminder',
      category:
          reminder.category == ReminderCategory.vaccine ||
              reminder.category == ReminderCategory.health
          ? 'health'
          : 'system',
      title: '${reminder.title} aktif',
      body:
          '${reminder.time.hour.toString().padLeft(2, '0')}:${reminder.time.minute.toString().padLeft(2, '0')} için hatırlatıcı kuruldu.',
      payload: reminder.id,
      userId: userId,
      familyId: family?.id,
    );
  }

  Future<void> updateReminder(ReminderItem reminder) async {
    await (_db.update(
      _db.reminders,
    )..where((tbl) => tbl.id.equals(reminder.id))).write(
      RemindersCompanion(
        title: Value(reminder.title),
        category: Value(reminder.category.name),
        time: Value(reminder.time),
        frequency: Value(reminder.frequency),
        notes: Value(reminder.notes),
        isActive: Value(reminder.isActive),
      ),
    );
  }

  Future<void> deleteReminder(String reminderId) async {
    await (_db.delete(
      _db.reminders,
    )..where((tbl) => tbl.id.equals(reminderId))).go();
  }

  Future<void> toggleSavedArticle(String articleId) async {
    final row = await (_db.select(
      _db.savedArticles,
    )..where((tbl) => tbl.articleId.equals(articleId))).getSingleOrNull();
    if (row == null) {
      await _db
          .into(_db.savedArticles)
          .insert(
            SavedArticlesCompanion.insert(
              articleId: articleId,
              savedAt: DateTime.now(),
            ),
          );
    } else {
      await (_db.delete(
        _db.savedArticles,
      )..where((tbl) => tbl.articleId.equals(articleId))).go();
    }
  }

  Future<List<domain.Article>> _loadArticles() async {
    final articles = await _db.select(_db.articles).get();
    final saved = await _db.select(_db.savedArticles).get();
    final savedIds = saved.map((e) => e.articleId).toSet();
    return articles
        .map(
          (row) => domain.Article(
            id: row.id,
            careMode: row.careMode,
            title: row.title,
            category: row.category,
            summary: row.summary,
            content: row.content,
            readingMinutes: row.readingMinutes,
            sourceName: row.sourceName,
            sourceUrl: row.sourceUrl,
            medicalDisclaimer: row.medicalDisclaimer,
            isSaved: savedIds.contains(row.id),
          ),
        )
        .toList();
  }

  Future<String> _currentUserId() async {
    final explicit = await _currentUserIdOrNull();
    if (explicit != null) return explicit;
    final user = await (_db.select(_db.users)..limit(1)).getSingleOrNull();
    if (user != null) return user.id;
    final now = DateTime.now();
    const userId = 'local-user';
    await _db
        .into(_db.users)
        .insert(
          UsersCompanion.insert(
            id: userId,
            name: 'MiniAdımlar',
            email: 'local@example.com',
            emailVerified: const Value(true),
            createdAt: now,
          ),
        );
    await setSetting('currentUserId', userId);
    return userId;
  }

  Future<String?> _currentUserIdOrNull() async {
    final settings = await _db.select(_db.settingsRows).get();
    final settingMap = {for (final row in settings) row.key: row.value};
    final userId = settingMap['currentUserId'];
    return userId == null || userId.trim().isEmpty ? null : userId;
  }

  Future<dynamic> _currentFamilyRow(
    String userId, {
    Map<String, String>? settings,
  }) async {
    final user = await (_db.select(
      _db.users,
    )..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
    if (user == null) return null;
    final families = await _db.select(_db.families).get();
    final email = user.email.toLowerCase();
    final activeFamilyId = settings == null
        ? await _settingForUserAsync(userId, 'activeFamilyId')
        : _settingForUser(settings, 'activeFamilyId', userId);
    if (activeFamilyId != null) {
      for (final family in families) {
        if (family.id != activeFamilyId) continue;
        if (_familyMatchesUser(family, userId, email)) {
          return family;
        }
      }
    }
    for (final family in families) {
      if (_familyMatchesUser(family, userId, email)) {
        return family;
      }
    }
    return null;
  }

  bool _familyMatchesUser(dynamic family, String userId, String email) {
    final partners = (jsonDecode(family.partnerUserIds) as List)
        .map((e) => e.toString().toLowerCase())
        .toSet();
    return family.ownerUserId == userId ||
        partners.contains(userId.toLowerCase()) ||
        partners.contains(email);
  }

  Future<String?> _settingForUserAsync(String userId, String key) async {
    final row =
        await (_db.select(_db.settingsRows)
              ..where((tbl) => tbl.key.equals(_userSettingKey(userId, key))))
            .getSingleOrNull();
    return row?.value;
  }

  Future<String?> _currentFamilyIdOrNull(String? userId) async {
    if (userId == null) return null;
    final family = await _currentFamilyRow(userId);
    return family?.id;
  }

  Future<void> clearCurrentSession() async {
    await (_db.delete(
      _db.settingsRows,
    )..where((tbl) => tbl.key.equals('currentUserId'))).go();
  }

  Future<void> upsertRemotePendingInvite(RemoteFamilyInvite invite) async {
    await _db
        .into(_db.families)
        .insertOnConflictUpdate(
          FamiliesCompanion.insert(
            id: invite.familyId,
            ownerUserId: invite.ownerUserId,
            activeBabyId: Value(invite.activeBabyId),
            createdAt: invite.createdAt,
          ),
        );
    await _db
        .into(_db.familyInvites)
        .insertOnConflictUpdate(
          FamilyInvitesCompanion.insert(
            id: invite.id,
            familyId: invite.familyId,
            invitedEmail: invite.invitedEmail.trim().toLowerCase(),
            invitedByUserId: invite.invitedByUserId,
            invitedByName: invite.invitedByName,
            invitedDisplayName: Value(invite.invitedDisplayName),
            roleLabel: Value(invite.roleLabel),
            permissionsJson: Value(_encodeStringList(invite.permissions)),
            acceptedUserId: Value(invite.acceptedUserId),
            status: Value(FamilyInviteStatus.pending.name),
            createdAt: invite.createdAt,
          ),
        );
  }

  Future<List<domain.AppNotification>> upsertRemoteFamily(
    RemoteFamilySummary family,
  ) async {
    final currentUserId = await _currentUserIdOrNull();
    final createdNotifications = <domain.AppNotification>[];
    final partnerIds = family.partnerEmails
        .map((email) => email.trim().toLowerCase())
        .where((email) => email.isNotEmpty)
        .toSet()
        .toList();
    final activeBabyId =
        family.activeBabyId ??
        (family.babies.isEmpty ? null : family.babies.first.id);
    await _db
        .into(_db.families)
        .insertOnConflictUpdate(
          FamiliesCompanion.insert(
            id: family.id,
            ownerUserId: family.ownerUserId,
            partnerUserIds: Value(jsonEncode(partnerIds)),
            activeBabyId: Value(activeBabyId),
            createdAt: family.createdAt,
          ),
        );
    if (currentUserId != null) {
      final currentUser = await (_db.select(
        _db.users,
      )..where((tbl) => tbl.id.equals(currentUserId))).getSingleOrNull();
      final currentEmail = currentUser?.email.trim().toLowerCase();
      final currentActiveFamilyId = await _settingForUserAsync(
        currentUserId,
        'activeFamilyId',
      );
      final isSharedMember =
          currentEmail != null && partnerIds.contains(currentEmail);
      final ownsFamily = family.ownerUserId == currentUserId;
      if ((isSharedMember && !ownsFamily) ||
          currentActiveFamilyId == null ||
          currentActiveFamilyId == family.id) {
        await setActiveFamilyForUser(currentUserId, family.id);
      }
    }
    for (final baby in family.babies) {
      await _db
          .into(_db.babies)
          .insertOnConflictUpdate(
            BabiesCompanion.insert(
              id: baby.id,
              familyId: baby.familyId,
              name: baby.name,
              birthDate: baby.birthDate,
              gender: Value(baby.gender),
              birthWeight: Value(baby.birthWeight),
              birthHeight: Value(baby.birthHeight),
              birthHeadCircumference: Value(baby.birthHeadCircumference),
              currentWeight: Value(baby.currentWeight),
              currentHeight: Value(baby.currentHeight),
              currentHeadCircumference: Value(baby.currentHeadCircumference),
              createdAt: baby.createdAt,
            ),
          );
    }
    for (final record in family.records) {
      final existingRecord = await (_db.select(
        _db.trackerRecords,
      )..where((tbl) => tbl.id.equals(record.id))).getSingleOrNull();
      if (record.deletedAt != null) {
        if (existingRecord != null) {
          await (_db.update(
            _db.trackerRecords,
          )..where((tbl) => tbl.id.equals(record.id))).write(
            TrackerRecordsCompanion(
              deletedAt: Value(record.deletedAt),
              updatedAt: Value(record.updatedAt),
              syncStatus: Value(SyncStatus.synced.name),
            ),
          );
          if (existingRecord.type == RecordType.growth.name &&
              existingRecord.babyId != null) {
            await _refreshBabyGrowthFromHistory(existingRecord.babyId!);
          }
        }
        continue;
      }
      await _db
          .into(_db.trackerRecords)
          .insertOnConflictUpdate(
            TrackerRecordsCompanion.insert(
              id: record.id,
              type: _safeRecordType(record.type).name,
              title: record.title,
              familyId: Value(record.familyId),
              babyId: Value(record.babyId),
              value: Value(record.value),
              note: Value(record.note),
              createdByUserId: Value(record.createdByUserId),
              createdByName: Value(record.createdByName),
              updatedByUserId: Value(record.updatedByUserId),
              updatedByName: Value(record.updatedByName),
              occurredAt: record.occurredAt,
              createdAt: record.createdAt,
              updatedAt: record.updatedAt,
              syncStatus: Value(SyncStatus.synced.name),
            ),
          );
      if (existingRecord == null &&
          currentUserId != null &&
          record.createdByUserId != null &&
          record.createdByUserId != currentUserId) {
        final notification = await _ensureRemoteRecordNotification(
          record: record,
          familyId: family.id,
          userId: currentUserId,
        );
        if (notification != null) createdNotifications.add(notification);
      } else if (existingRecord != null &&
          currentUserId != null &&
          record.updatedByUserId != null &&
          record.updatedByUserId != currentUserId &&
          record.updatedAt.isAfter(existingRecord.updatedAt)) {
        final notification = await _ensureRemoteRecordUpdateNotification(
          record: record,
          familyId: family.id,
          userId: currentUserId,
        );
        if (notification != null) createdNotifications.add(notification);
      }
    }
    for (final reminder in family.reminders) {
      if (reminder.deletedAt != null) {
        await (_db.delete(
          _db.reminders,
        )..where((tbl) => tbl.id.equals(reminder.id))).go();
        continue;
      }
      await _db
          .into(_db.reminders)
          .insertOnConflictUpdate(
            RemindersCompanion.insert(
              id: reminder.id,
              title: reminder.title,
              category: _safeReminderCategory(reminder.category).name,
              time: reminder.time,
              frequency: Value(reminder.frequency),
              notes: Value(reminder.notes),
              isActive: Value(reminder.isActive),
              ownerUserId: Value(reminder.createdByUserId),
              familyId: Value(reminder.familyId),
              createdAt: reminder.createdAt,
            ),
          );
    }
    for (final vaccine in family.vaccines) {
      await _db
          .into(_db.vaccineEvents)
          .insertOnConflictUpdate(
            VaccineEventsCompanion.insert(
              id: vaccine.id,
              babyId: vaccine.babyId,
              title: vaccine.title,
              dose: vaccine.dose,
              dueDate: vaccine.dueDate,
              status: Value(_safeVaccineStatus(vaccine.status).name),
              notes: Value(vaccine.notes),
              completedAt: Value(vaccine.completedAt),
              createdAt: vaccine.createdAt,
            ),
          );
    }
    if (currentUserId != null) {
      for (final notification in family.notifications) {
        if (notification.isDeleted) {
          await (_db.delete(
            _db.appNotifications,
          )..where((tbl) => tbl.id.equals(notification.id))).go();
          continue;
        }
        final status = notification.readBy.contains(currentUserId)
            ? AppNotificationStatus.read
            : AppNotificationStatus.unread;
        await _db
            .into(_db.appNotifications)
            .insertOnConflictUpdate(
              AppNotificationsCompanion.insert(
                id: notification.id,
                familyId: Value(notification.familyId),
                targetUserIds: Value(
                  _encodeStringList(notification.targetUserIds),
                ),
                createdBy: Value(notification.createdBy),
                type: notification.type,
                category: notification.category,
                title: notification.title,
                body: notification.body,
                payload: Value(notification.payload),
                readBy: Value(_encodeStringList(notification.readBy)),
                seenBy: Value(_encodeStringList(notification.seenBy)),
                isDeleted: Value(notification.isDeleted),
                status: Value(status.name),
                userId: Value(currentUserId),
                createdAt: notification.createdAt,
                readAt: Value(
                  status == AppNotificationStatus.read
                      ? notification.createdAt
                      : null,
                ),
              ),
            );
      }
    }
    for (final invite in family.invites) {
      await _db
          .into(_db.familyInvites)
          .insertOnConflictUpdate(
            FamilyInvitesCompanion.insert(
              id: invite.id,
              familyId: invite.familyId,
              invitedEmail: invite.invitedEmail.trim().toLowerCase(),
              invitedByUserId: invite.invitedByUserId,
              invitedByName: invite.invitedByName,
              invitedDisplayName: Value(invite.invitedDisplayName),
              roleLabel: Value(invite.roleLabel),
              permissionsJson: Value(_encodeStringList(invite.permissions)),
              acceptedUserId: Value(invite.acceptedUserId),
              status: Value(FamilyInviteStatus.accepted.name),
              createdAt: invite.createdAt,
              respondedAt: Value(DateTime.now()),
            ),
          );
    }
    for (final email in partnerIds) {
      final inviteId = 'invite-${family.id}-$email';
      final existing = await (_db.select(
        _db.familyInvites,
      )..where((tbl) => tbl.id.equals(inviteId))).getSingleOrNull();
      if (existing == null) {
        await _db
            .into(_db.familyInvites)
            .insert(
              FamilyInvitesCompanion.insert(
                id: inviteId,
                familyId: family.id,
                invitedEmail: email,
                invitedByUserId: family.ownerUserId,
                invitedByName: 'Ana kullanıcı',
                roleLabel: const Value('Ebeveyn'),
                permissionsJson: Value(
                  _encodePermissions(FamilyPermissionSets.parent),
                ),
                status: Value(FamilyInviteStatus.accepted.name),
                createdAt: family.createdAt,
                respondedAt: Value(DateTime.now()),
              ),
            );
      } else if (existing.status != FamilyInviteStatus.accepted.name) {
        await (_db.update(
          _db.familyInvites,
        )..where((tbl) => tbl.id.equals(inviteId))).write(
          FamilyInvitesCompanion(
            status: Value(FamilyInviteStatus.accepted.name),
            respondedAt: Value(DateTime.now()),
          ),
        );
      }
    }
    return createdNotifications;
  }

  Future<List<domain.AppNotification>>
  createPendingInviteNotificationsForCurrentUser() async {
    final userId = await _currentUserIdOrNull();
    if (userId == null) return const [];
    final user = await (_db.select(
      _db.users,
    )..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
    if (user == null) return const [];
    final invites =
        await (_db.select(_db.familyInvites)
              ..where(
                (tbl) =>
                    tbl.invitedEmail.equals(user.email.toLowerCase()) &
                    tbl.status.equals(FamilyInviteStatus.pending.name),
              )
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
            .get();
    final created = <domain.AppNotification>[];
    for (final invite in invites) {
      final notification = await _ensureInviteNotification(invite, user.id);
      if (notification != null) created.add(notification);
    }
    return created;
  }

  String? _settingForUser(
    Map<String, String> settings,
    String key,
    String? userId,
  ) {
    if (userId != null) {
      final scoped = settings[_userSettingKey(userId, key)];
      if (scoped != null) return scoped;
    }
    return key == 'localeCode' ? settings[key] : null;
  }

  List<String> _decodeStringList(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is! List) return const [];
      return decoded
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  String _encodeStringList(Iterable<String> values) {
    return jsonEncode(
      values
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toSet()
          .toList(),
    );
  }

  List<FamilyPermission> _decodePermissions(String value) {
    return _decodeStringList(value)
        .map(
          (item) => FamilyPermission.values
              .where((permission) => permission.name == item)
              .cast<FamilyPermission?>()
              .firstWhere(
                (permission) => permission != null,
                orElse: () => null,
              ),
        )
        .whereType<FamilyPermission>()
        .toList();
  }

  String _encodePermissions(Iterable<FamilyPermission> permissions) {
    return _encodeStringList(permissions.map((permission) => permission.name));
  }

  String _userSettingKey(String userId, String key) => 'user:$userId:$key';

  RecordType _safeRecordType(String value) {
    for (final type in RecordType.values) {
      if (type.name == value) return type;
    }
    return RecordType.health;
  }

  ReminderCategory _safeReminderCategory(String value) {
    for (final category in ReminderCategory.values) {
      if (category.name == value) return category;
    }
    return ReminderCategory.custom;
  }

  VaccineStatus _safeVaccineStatus(String value) {
    for (final status in VaccineStatus.values) {
      if (status.name == value) return status;
    }
    return VaccineStatus.upcoming;
  }

  String _stableLocalUserId(String email) {
    final slug = email
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return 'email-${slug.isEmpty ? 'local-user' : slug}';
  }

  Future<void> _attachPendingInvitesForUser(String userId, String email) async {
    final invites =
        await (_db.select(_db.familyInvites)..where(
              (tbl) =>
                  tbl.invitedEmail.equals(email.toLowerCase()) &
                  tbl.status.equals(FamilyInviteStatus.pending.name),
            ))
            .get();
    for (final invite in invites) {
      await _ensureInviteNotification(invite, userId);
    }
  }

  Future<domain.AppNotification?> _ensureInviteNotification(
    dynamic invite,
    String userId,
  ) async {
    final existing =
        await (_db.select(_db.appNotifications)..where(
              (tbl) =>
                  tbl.payload.equals(invite.id) &
                  tbl.userId.equals(userId) &
                  tbl.type.equals('family_invite'),
            ))
            .getSingleOrNull();
    if (existing != null) return null;
    return _createNotification(
      type: 'family_invite',
      category: 'family',
      title: 'Aile daveti',
      body:
          '${invite.invitedByName} sizi ortak aile hesabına davet etti. Gönderim: ${_formatDateTime(invite.createdAt)}.',
      payload: invite.id,
      userId: userId,
      createdAt: invite.createdAt,
      attachCurrentFamily: false,
    );
  }

  Future<domain.AppNotification?> _ensureRemoteRecordNotification({
    required RemoteTrackerRecordSummary record,
    required String familyId,
    required String userId,
  }) async {
    final existing =
        await (_db.select(_db.appNotifications)..where(
              (tbl) =>
                  tbl.payload.equals(record.id) &
                  tbl.userId.equals(userId) &
                  tbl.type.equals('family_record'),
            ))
            .getSingleOrNull();
    if (existing != null) return null;
    final actor = _cleanActorName(record.createdByName);
    return _createNotification(
      type: 'family_record',
      category: 'family',
      title: 'Yeni aile kaydı',
      body: '$actor ${record.title} kaydı ekledi.',
      payload: record.id,
      userId: userId,
      familyId: familyId,
      createdAt: record.createdAt,
    );
  }

  Future<domain.AppNotification?> _ensureRemoteRecordUpdateNotification({
    required RemoteTrackerRecordSummary record,
    required String familyId,
    required String userId,
  }) async {
    final payload = '${record.id}-${record.updatedAt.microsecondsSinceEpoch}';
    final existing =
        await (_db.select(_db.appNotifications)..where(
              (tbl) =>
                  tbl.payload.equals(payload) &
                  tbl.userId.equals(userId) &
                  tbl.type.equals('family_record_update'),
            ))
            .getSingleOrNull();
    if (existing != null) return null;
    final actor = _cleanActorName(record.updatedByName ?? record.createdByName);
    return _createNotification(
      type: 'family_record_update',
      category: 'family',
      title: 'Aile kaydı güncellendi',
      body: '$actor ${record.title} kaydını güncelledi.',
      payload: payload,
      userId: userId,
      familyId: familyId,
      createdAt: record.updatedAt,
    );
  }

  String _cleanActorName(String? name) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return 'Partneriniz';
    return trimmed;
  }

  Future<void> _ensurePregnancyDuePrompt(
    dynamic pregnancy,
    dynamic user,
    dynamic family,
  ) async {
    if (pregnancy.dueDate.isAfter(DateTime.now())) return;
    final payload = 'birth_prompt_${pregnancy.id}';
    final existing = await (_db.select(
      _db.appNotifications,
    )..where((tbl) => tbl.payload.equals(payload))).getSingleOrNull();
    if (existing != null) return;
    await _createNotification(
      type: 'birth_prompt',
      category: 'family',
      title: 'Doğum yaptınız mı?',
      body:
          'Tahmini doğum tarihiniz geldi. Doğum olduysa bebek bilgilerini girerek büyüme takibini başlatabilirsiniz.',
      payload: payload,
      userId: user.id,
      familyId: family?.id,
    );
  }

  Future<void> _refreshBabyGrowthFromHistory(String babyId) async {
    final baby = await (_db.select(
      _db.babies,
    )..where((tbl) => tbl.id.equals(babyId))).getSingleOrNull();
    if (baby == null) return;
    final latestGrowth =
        await (_db.select(_db.trackerRecords)
              ..where(
                (tbl) =>
                    tbl.babyId.equals(babyId) &
                    tbl.type.equals(RecordType.growth.name) &
                    tbl.deletedAt.isNull(),
              )
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.occurredAt)])
              ..limit(1))
            .getSingleOrNull();
    final parsed = latestGrowth == null
        ? const <String, double>{}
        : _parseGrowthValue(latestGrowth.value ?? '');
    await (_db.update(_db.babies)..where((tbl) => tbl.id.equals(babyId))).write(
      BabiesCompanion(
        currentWeight: Value(
          parsed['weightKg'] ?? baby.birthWeight ?? baby.currentWeight,
        ),
        currentHeight: Value(
          parsed['heightCm'] ?? baby.birthHeight ?? baby.currentHeight,
        ),
        currentHeadCircumference: Value(
          parsed['headCm'] ??
              baby.birthHeadCircumference ??
              baby.currentHeadCircumference,
        ),
      ),
    );
  }

  Map<String, double> _parseGrowthValue(String value) {
    final result = <String, double>{};
    for (final part in value.split(';')) {
      final pieces = part.split('=');
      if (pieces.length != 2) continue;
      final parsed = double.tryParse(pieces.last.replaceAll(',', '.').trim());
      if (parsed == null || parsed <= 0) continue;
      result[pieces.first.trim()] = parsed;
    }
    return result;
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    return '${local.day.toString().padLeft(2, '0')}.'
        '${local.month.toString().padLeft(2, '0')}.'
        '${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  VaccineStatus _effectiveVaccineStatus(dynamic row) {
    if (row.status == VaccineStatus.completed.name) {
      return VaccineStatus.completed;
    }
    final overdue = row.dueDate.isBefore(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    return overdue ? VaccineStatus.overdue : VaccineStatus.upcoming;
  }

  Future<void> _seedVaccineEvents(dynamic baby) async {
    final existing = await (_db.select(
      _db.vaccineEvents,
    )..where((tbl) => tbl.babyId.equals(baby.id))).get();
    final existingById = {for (final row in existing) row.id: row};
    final now = DateTime.now();
    final schedule = _vaccineSchedule();
    await _db.batch((batch) {
      for (final item in schedule) {
        final id = 'vaccine-${baby.id}-${item.key}';
        final previous = existingById[id];
        final completedAt = previous?.completedAt;
        batch.insert(
          _db.vaccineEvents,
          VaccineEventsCompanion.insert(
            id: id,
            babyId: baby.id,
            title: item.title,
            dose: item.dose,
            dueDate: _addCalendarMonths(baby.birthDate, item.monthOffset),
            status: Value(
              completedAt == null
                  ? VaccineStatus.upcoming.name
                  : VaccineStatus.completed.name,
            ),
            notes: Value(item.notes),
            completedAt: Value(completedAt),
            createdAt: previous?.createdAt ?? now,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  DateTime _addCalendarMonths(DateTime date, int months) {
    final targetMonth = date.month + months;
    final target = DateTime(date.year, targetMonth, 1);
    final nextMonth = DateTime(target.year, target.month + 1, 1);
    final lastDay = nextMonth.subtract(const Duration(days: 1)).day;
    final day = date.day > lastDay ? lastDay : date.day;
    return DateTime(date.year, targetMonth, day, date.hour, date.minute);
  }

  List<_VaccineTemplate> _vaccineSchedule() => const [
    _VaccineTemplate(
      key: 'hepb-birth',
      title: 'Hepatit B',
      dose: '1. doz',
      monthOffset: 0,
      notes:
          'AAP 2026 ve CDC/ACIP çocuk aşı takviminde doğum dozu olarak yer alır.',
    ),
    _VaccineTemplate(
      key: 'hepb-1m',
      title: 'Hepatit B',
      dose: '2. doz',
      monthOffset: 1,
      notes:
          'AAP 2026 takviminde 1-2 ay aralığında sağlık profesyoneliyle planlanır.',
    ),
    _VaccineTemplate(
      key: 'rota-2m',
      title: 'Rotavirüs',
      dose: '1. doz',
      monthOffset: 2,
      notes:
          'Seriye başlanma zamanı, ürün şeması ve üst yaş sınırları doktora göre netleşir.',
    ),
    _VaccineTemplate(
      key: 'dtap-hib-pcv-ipv-2m',
      title: 'DTaP, Hib, PCV, IPV',
      dose: '2. ay',
      monthOffset: 2,
      notes:
          'AAP 2026 takviminde 2. ay koruyucu ziyaretinde konuşulacak ana grup.',
    ),
    _VaccineTemplate(
      key: 'dtap-hib-pcv-ipv-rota-4m',
      title: 'DTaP, Hib, PCV, IPV, Rotavirüs',
      dose: '4. ay',
      monthOffset: 4,
      notes:
          'Devam dozları için aşı kartı, önceki doz tarihi ve doktor önerisi esas alınır.',
    ),
    _VaccineTemplate(
      key: 'dtap-hib-pcv-ipv-flu-6m',
      title: 'DTaP, Hib, PCV, IPV, Grip',
      dose: '6. ay',
      monthOffset: 6,
      notes:
          'Grip ve ek öneriler yaş, sezon ve risk durumuna göre değerlendirilir.',
    ),
    _VaccineTemplate(
      key: 'mmr-var-hepa-12m',
      title: 'MMR, Suçiçeği, Hepatit A',
      dose: '12. ay',
      monthOffset: 12,
      notes:
          '12. ay ziyaretinde doktorunuzla birlikte planlanır; yerel takvim farklılıkları olabilir.',
    ),
    _VaccineTemplate(
      key: 'dtap-15m',
      title: 'DTaP',
      dose: '15. ay',
      monthOffset: 15,
      notes: 'Rapel doz takvimi için çocuk doktorunuzun planını takip edin.',
    ),
    _VaccineTemplate(
      key: 'hepa-18m',
      title: 'Hepatit A',
      dose: '18. ay',
      monthOffset: 18,
      notes:
          'Serinin tamamlanması için önceki doz tarihi ve minimum aralıklar önemlidir.',
    ),
  ];

  Future<domain.AppNotification> _createNotification({
    required String type,
    required String category,
    required String title,
    required String body,
    String? payload,
    String? userId,
    String? familyId,
    String? createdBy,
    List<String> targetUserIds = const [],
    List<String> readBy = const [],
    List<String> seenBy = const [],
    DateTime? createdAt,
    bool attachCurrentFamily = true,
  }) async {
    final now = DateTime.now();
    final notificationId = 'notification-${now.microsecondsSinceEpoch}';
    final notificationCreatedAt = createdAt ?? now;
    final resolvedUserId = userId ?? await _currentUserIdOrNull();
    final resolvedFamilyId =
        familyId ??
        (attachCurrentFamily
            ? await _currentFamilyIdOrNull(resolvedUserId)
            : null);
    await _db
        .into(_db.appNotifications)
        .insert(
          AppNotificationsCompanion.insert(
            id: notificationId,
            familyId: Value(resolvedFamilyId),
            targetUserIds: Value(_encodeStringList(targetUserIds)),
            createdBy: Value(createdBy),
            type: type,
            category: category,
            title: title,
            body: body,
            payload: Value(payload),
            readBy: Value(_encodeStringList(readBy)),
            seenBy: Value(_encodeStringList(seenBy)),
            userId: Value(resolvedUserId),
            createdAt: notificationCreatedAt,
          ),
        );
    return domain.AppNotification(
      id: notificationId,
      familyId: resolvedFamilyId,
      targetUserIds: targetUserIds,
      createdBy: createdBy,
      type: type,
      category: category,
      title: title,
      body: body,
      payload: payload,
      readBy: readBy,
      seenBy: seenBy,
      createdAt: notificationCreatedAt,
    );
  }

  Future<void> _markInviteNotification(
    String inviteId,
    AppNotificationStatus status,
  ) async {
    await (_db.update(
      _db.appNotifications,
    )..where((tbl) => tbl.payload.equals(inviteId))).write(
      AppNotificationsCompanion(
        status: Value(status.name),
        readAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> reset() async {
    for (final table in _db.allTables) {
      await _db.delete(table).go();
    }
    await seedContent();
  }
}

class _VaccineTemplate {
  const _VaccineTemplate({
    required this.key,
    required this.title,
    required this.dose,
    required this.monthOffset,
    required this.notes,
  });

  final String key;
  final String title;
  final String dose;
  final int monthOffset;
  final String notes;
}
