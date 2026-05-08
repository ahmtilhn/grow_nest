import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/utils/app_calculators.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appSnapshotProvider);
    final controller = ref.read(appControllerProvider);
    final snapshot = controller.snapshot;
    final user = snapshot.user;
    final baby = snapshot.baby;
    final pregnancy = snapshot.pregnancy;
    final sharedReminders = [...snapshot.reminders]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Scaffold(
      appBar: AppBar(title: const Text('Profil ve Ayarlar')),
      body: AppScreen(
        bottomPadding: 32,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.softBlue,
                backgroundImage: user?.avatarUrl == null
                    ? null
                    : NetworkImage(user!.avatarUrl!),
                child: user?.avatarUrl == null
                    ? const Icon(
                        Icons.person_rounded,
                        size: 48,
                        color: AppColors.primary,
                      )
                    : null,
              ),
              const SizedBox(height: 14),
              Text(
                user?.name ?? 'MiniAdımlar',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                user?.email ?? 'ornek@email.com',
                style: const TextStyle(color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'KİŞİSEL BİLGİLER',
            action: 'Düzenle',
            onAction: () => _showUserEditor(context, controller),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.badge_outlined,
                  title: 'Rol',
                  value: user?.role ?? 'Ebeveyn',
                ),
                _InfoRow(
                  icon: Icons.cake_outlined,
                  title: 'Doğum tarihi',
                  value: _dateOrEmpty(user?.birthDate),
                ),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  title: 'Telefon',
                  value: user?.phone ?? 'Eklenmedi',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionHeader(
            title: baby == null ? 'GEBELİK BİLGİLERİ' : 'BEBEK BİLGİLERİ',
            action: 'Düzenle',
            onAction: () => baby == null
                ? _showPregnancyEditor(context, controller, pregnancy)
                : _showBabyEditor(context, controller, baby),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SoftIcon(
                    icon: baby == null
                        ? Icons.pregnant_woman_rounded
                        : Icons.child_care_rounded,
                    color: AppColors.softPink,
                  ),
                  title: Text(baby?.name ?? 'Aktif gebelik profili'),
                  subtitle: Text(
                    baby == null
                        ? pregnancy == null
                              ? 'Tahmini doğum tarihi eklenmedi'
                              : 'Tahmini doğum: ${_dateOrEmpty(pregnancy.dueDate)}'
                        : '${AgeUtils.babyAge(baby.birthDate, DateTime.now())} • ${_dateOrEmpty(baby.birthDate)}',
                  ),
                  trailing: IconButton(
                    onPressed: () => baby == null
                        ? _showPregnancyEditor(context, controller, pregnancy)
                        : _showBabyEditor(context, controller, baby),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ),
                if (baby == null && pregnancy != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showPregnancyEditor(
                            context,
                            controller,
                            pregnancy,
                          ),
                          icon: const Icon(Icons.event_rounded),
                          label: const Text('Tarihi Düzenle'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () =>
                              _showBirthCompletedEditor(context, controller),
                          icon: const Icon(Icons.child_care_rounded),
                          label: const Text('Doğum Yaptım'),
                        ),
                      ),
                    ],
                  ),
                  if (!pregnancy.dueDate.isAfter(DateTime.now())) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.softGreen,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: const Color(0xFFD3E3DC)),
                      ),
                      child: const Text(
                        'Tahmini doğum tarihiniz geldi. Doğum olduysa bebek bilgilerini girerek büyüme sürecini başlatabilirsiniz.',
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionHeader(
            title: 'AİLE PAYLAŞIMI',
            action: 'Davet Et',
            onAction: () => _showInvitePartner(context, controller),
          ),
          const SizedBox(height: 10),
          _FamilySharingCard(
            partners: snapshot.family?.partnerUserIds ?? const [],
            invites: snapshot.invites,
            onInvite: () => _showInvitePartner(context, controller),
          ),
          const SizedBox(height: 18),
          SectionHeader(
            title: 'ORTAK RUTİNLER',
            action: 'Yeni',
            onAction: () => context.push('/reminder/new'),
          ),
          const SizedBox(height: 10),
          _SharedReminderPlansCard(
            reminders: sharedReminders,
            onCreate: () => context.push('/reminder/new'),
            onEdit: (reminder) {
              final id = Uri.encodeComponent(reminder.id);
              context.push('/reminder/new?id=$id');
            },
            onToggleActive: (reminder, value) async {
              await controller.updateReminder(
                reminder.copyWith(isActive: value),
              );
              if (context.mounted) {
                showAppSnack(
                  context,
                  value
                      ? 'Ortak rutin yeniden aktifleştirildi.'
                      : 'Ortak rutin duraklatıldı.',
                );
              }
            },
          ),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const SoftIcon(
                    icon: Icons.dark_mode_outlined,
                    color: AppColors.softGreen,
                  ),
                  title: const Text('Karanlık Mod'),
                  value: user?.theme == 'dark',
                  onChanged: controller.setThemeMode,
                ),
                ListTile(
                  leading: const SoftIcon(
                    icon: Icons.notifications_none_rounded,
                  ),
                  title: const Text('Bildirim Tercihleri'),
                  subtitle: Text(_soundLabel(snapshot.notificationSound)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showNotificationPrefs(context, controller),
                ),
                ListTile(
                  leading: const SoftIcon(
                    icon: Icons.notifications_active_outlined,
                    color: AppColors.softPink,
                  ),
                  title: const Text('Bildirim Merkezi'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/notifications'),
                ),
                if (baby != null)
                  ListTile(
                    leading: const SoftIcon(
                      icon: Icons.vaccines_rounded,
                      color: AppColors.softGreen,
                    ),
                    title: const Text('Aşı Takvimi'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/vaccines'),
                  ),
                ListTile(
                  leading: const SoftIcon(
                    icon: Icons.palette_outlined,
                    color: AppColors.softGreen,
                  ),
                  title: const Text('Uygulama Dili'),
                  trailing: Text(snapshot.localeCode.toUpperCase()),
                  onTap: () => controller.setLocale(
                    snapshot.localeCode == 'tr' ? 'en' : 'tr',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  leading: const SoftIcon(icon: Icons.security_rounded),
                  title: const Text('Gizlilik ve Veri Paylaşımı'),
                  subtitle: const Text('Yerel kayıtlar ve Firebase hesabı'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => showPrivacyInfoDialog(context),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever_rounded,
                    color: AppColors.danger,
                  ),
                  title: const Text(
                    'Hesabımı Sil',
                    style: TextStyle(color: AppColors.danger),
                  ),
                  subtitle: const Text('Bu hesaba ait veriler temizlenir'),
                  onTap: () => _confirmDelete(context, controller),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          OutlinedButton.icon(
            onPressed: () => _confirmLogout(context, controller),
            icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
            label: const Text(
              'Çıkış Yap',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'MiniAdımlar v1.0.0',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  Future<void> _showUserEditor(
    BuildContext context,
    AppController controller,
  ) async {
    final user = controller.snapshot.user;
    final name = TextEditingController(text: user?.name ?? '');
    final email = TextEditingController(text: user?.email ?? '');
    final phone = TextEditingController(text: user?.phone ?? '');
    final role = TextEditingController(text: user?.role ?? 'Ebeveyn');
    var birthDate = user?.birthDate;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Kişisel Bilgiler'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(controller: name, label: 'Ad soyad'),
                const SizedBox(height: 10),
                AppTextField(
                  controller: email,
                  label: 'E-posta',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                AppTextField(controller: phone, label: 'Telefon'),
                const SizedBox(height: 10),
                AppTextField(controller: role, label: 'Rol'),
                const SizedBox(height: 10),
                AppCard(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: birthDate ?? DateTime(1994),
                      firstDate: DateTime(1940),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => birthDate = picked);
                  },
                  child: Text('Doğum tarihi: ${_dateOrEmpty(birthDate)}'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
    if (saved == true) {
      await controller.updateUserProfile(
        name: name.text,
        email: email.text,
        birthDate: birthDate,
        phone: phone.text,
        role: role.text,
      );
    }
  }

  Future<void> _showBabyEditor(
    BuildContext context,
    AppController controller,
    BabyProfile baby,
  ) async {
    final name = TextEditingController(text: baby.name);
    final gender = TextEditingController(text: baby.gender ?? '');
    final weight = TextEditingController(text: '${baby.birthWeight ?? ''}');
    final height = TextEditingController(text: '${baby.birthHeight ?? ''}');
    final head = TextEditingController(
      text: '${baby.birthHeadCircumference ?? ''}',
    );
    var birthDate = baby.birthDate;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Bebek Bilgileri'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(controller: name, label: 'Bebek adı'),
                const SizedBox(height: 10),
                AppTextField(controller: gender, label: 'Cinsiyet'),
                const SizedBox(height: 10),
                AppTextField(
                  controller: weight,
                  label: 'Doğum kilosu (kg)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  controller: height,
                  label: 'Doğum boyu / uzunluk (cm)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  controller: head,
                  label: 'Baş çevresi (cm)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                AppCard(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: birthDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 3650),
                      ),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => birthDate = picked);
                  },
                  child: Text('Doğum tarihi: ${_dateOrEmpty(birthDate)}'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
    if (saved == true) {
      await controller.updateBabyProfile(
        babyId: baby.id,
        name: name.text,
        birthDate: birthDate,
        gender: gender.text,
        birthWeight: ValidationUtils.positiveDouble(weight.text),
        birthHeight: ValidationUtils.positiveDouble(height.text),
        birthHeadCircumference: ValidationUtils.positiveDouble(head.text),
      );
    }
  }

  Future<void> _showPregnancyEditor(
    BuildContext context,
    AppController controller,
    PregnancyProfile? pregnancy,
  ) async {
    if (pregnancy == null) {
      showAppSnack(context, 'Önce gebelik profili oluşturulmalı.');
      return;
    }
    var dueDate = pregnancy.dueDate;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Gebelik Bilgileri'),
          content: AppCard(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: dueDate,
                firstDate: DateTime.now().subtract(const Duration(days: 280)),
                lastDate: DateTime.now().add(const Duration(days: 320)),
              );
              if (picked != null) setState(() => dueDate = picked);
            },
            child: Text('Tahmini doğum: ${_dateOrEmpty(dueDate)}'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
    if (saved == true) {
      await controller.updatePregnancyProfile(
        pregnancyId: pregnancy.id,
        dueDate: dueDate,
      );
    }
  }

  Future<void> _showNotificationPrefs(
    BuildContext context,
    AppController controller,
  ) async {
    var enabled = controller.snapshot.notificationsEnabled;
    var health = controller.snapshot.healthNotificationsEnabled;
    var family = controller.snapshot.familyNotificationsEnabled;
    var reminder = controller.snapshot.reminderNotificationsEnabled;
    var sound = controller.snapshot.notificationSound;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Bildirim Tercihleri'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  value: enabled,
                  onChanged: (value) => setState(() => enabled = value),
                  title: const Text('Bildirimler açık'),
                ),
                SwitchListTile(
                  value: health,
                  onChanged: enabled
                      ? (value) => setState(() => health = value)
                      : null,
                  title: const Text('Sağlık ve aşı bildirimleri'),
                ),
                SwitchListTile(
                  value: family,
                  onChanged: enabled
                      ? (value) => setState(() => family = value)
                      : null,
                  title: const Text('Aile davetleri'),
                ),
                SwitchListTile(
                  value: reminder,
                  onChanged: enabled
                      ? (value) => setState(() => reminder = value)
                      : null,
                  title: const Text('Rutin hatırlatıcılar'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: sound,
                  decoration: const InputDecoration(labelText: 'Bildirim sesi'),
                  items: const [
                    DropdownMenuItem(
                      value: 'soft_chime',
                      child: Text('Sakin çan'),
                    ),
                    DropdownMenuItem(
                      value: 'gentle_bell',
                      child: Text('Yumuşak zil'),
                    ),
                    DropdownMenuItem(value: 'silent', child: Text('Sessiz')),
                  ],
                  onChanged: enabled
                      ? (value) => setState(() => sound = value ?? sound)
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
    if (saved == true) {
      await controller.updateNotificationPreferences(
        notificationsEnabled: enabled,
        healthEnabled: health,
        familyEnabled: family,
        reminderEnabled: reminder,
        sound: sound,
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AppController controller,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesabı sil'),
        content: const Text(
          'Hesap silindiğinde bu cihazdaki profil, bebek, gebelik, kayıt ve davet verileri temizlenir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hesabımı Sil'),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.deleteAccount();
  }

  Future<void> _confirmLogout(
    BuildContext context,
    AppController controller,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış yap'),
        content: const Text('Oturum kapatılsın mı?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.logout();
  }

  Future<void> _showInvitePartner(
    BuildContext context,
    AppController controller,
  ) async {
    final email = TextEditingController();
    final invited = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aile üyesi ekle'),
        content: AppTextField(
          controller: email,
          label: 'E-posta',
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
    if (invited == true) {
      await controller.addFamilyPartner(email.text);
      if (context.mounted) {
        showAppSnack(context, 'Aile paylaşımı güncellendi.');
      }
    }
  }

  Future<void> _showBirthCompletedEditor(
    BuildContext context,
    AppController controller,
  ) async {
    final name = TextEditingController();
    final weight = TextEditingController();
    final height = TextEditingController();
    final head = TextEditingController();
    var birthDate = DateTime.now();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Doğum Bilgileri'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(controller: name, label: 'Bebek adı'),
                const SizedBox(height: 10),
                AppTextField(
                  controller: weight,
                  label: 'Doğum kilosu (kg)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  controller: height,
                  label: 'Doğum boyu / uzunluk (cm)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  controller: head,
                  label: 'Baş çevresi (cm)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                AppCard(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: birthDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => birthDate = picked);
                  },
                  child: Text('Doğum tarihi: ${_dateOrEmpty(birthDate)}'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Büyümeyi Başlat'),
            ),
          ],
        ),
      ),
    );
    if (saved == true) {
      await controller.completeBirthFromPregnancy(
        babyName: name.text,
        birthDate: birthDate,
        weight: ValidationUtils.positiveDouble(weight.text),
        height: ValidationUtils.positiveDouble(height.text),
        headCircumference: ValidationUtils.positiveDouble(head.text),
      );
      if (context.mounted) {
        showAppSnack(context, 'Bebek büyüme süreci başlatıldı.');
      }
    }
  }

  String _dateOrEmpty(DateTime? date) {
    if (date == null) return 'Eklenmedi';
    return '${date.day}.${date.month}.${date.year}';
  }

  String _soundLabel(String sound) => switch (sound) {
    'gentle_bell' => 'Bildirim sesi: Yumuşak zil',
    'silent' => 'Bildirim sesi: Sessiz',
    _ => 'Bildirim sesi: Sakin çan',
  };
}

class _FamilySharingCard extends StatelessWidget {
  const _FamilySharingCard({
    required this.partners,
    required this.invites,
    required this.onInvite,
  });

  final List<String> partners;
  final List<FamilyInvite> invites;
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const SoftIcon(
              icon: Icons.group_add_rounded,
              color: AppColors.softPink,
            ),
            title: const Text('Ortak aile hesabı'),
            subtitle: const Text(
              'Karşı hesaba uygulama içi davet gider; kabul edilince hesaplar birleşir.',
            ),
            trailing: IconButton(
              onPressed: onInvite,
              icon: const Icon(Icons.person_add_alt_1_rounded),
            ),
          ),
          if (partners.isEmpty && invites.isEmpty)
            const Text('Henüz ortak veya bekleyen davet yok.')
          else ...[
            for (final partner in partners)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(child: Icon(Icons.person_rounded)),
                title: Text(partner),
                subtitle: const Text('Ortak erişim açık'),
              ),
            for (final invite in invites.take(4))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.softBlue,
                  child: Icon(Icons.mail_outline_rounded),
                ),
                title: Text(invite.invitedEmail),
                subtitle: Text('Davet: ${invite.status.name}'),
              ),
          ],
        ],
      ),
    );
  }
}

class _SharedReminderPlansCard extends StatelessWidget {
  const _SharedReminderPlansCard({
    required this.reminders,
    required this.onCreate,
    required this.onEdit,
    required this.onToggleActive,
  });

  final List<ReminderItem> reminders;
  final VoidCallback onCreate;
  final ValueChanged<ReminderItem> onEdit;
  final Future<void> Function(ReminderItem reminder, bool value) onToggleActive;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const SoftIcon(
              icon: Icons.notifications_active_outlined,
              color: AppColors.softGreen,
            ),
            title: const Text('Paylaşılan bakım planları'),
            subtitle: const Text(
              'Buradaki planlar bağlı hesaplarda aynı görünür. Dokununca düzenlenir, form içinden silinebilir.',
            ),
            trailing: IconButton(
              onPressed: onCreate,
              icon: const Icon(Icons.add_alert_rounded),
            ),
          ),
          if (reminders.isEmpty)
            const Text('Henüz ortak rutin planı yok.')
          else
            for (final reminder in reminders.take(6))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SoftIcon(
                  icon: _reminderIcon(reminder.category),
                  color: reminder.isActive
                      ? AppColors.softBlue
                      : AppColors.softPink,
                ),
                title: Text(reminder.title),
                subtitle: Text(_reminderSubtitle(reminder)),
                trailing: Switch.adaptive(
                  value: reminder.isActive,
                  onChanged: (value) => onToggleActive(reminder, value),
                ),
                onTap: () => onEdit(reminder),
              ),
        ],
      ),
    );
  }

  IconData _reminderIcon(ReminderCategory category) => switch (category) {
    ReminderCategory.health => Icons.health_and_safety_outlined,
    ReminderCategory.water => Icons.water_drop_outlined,
    ReminderCategory.feeding => Icons.restaurant_rounded,
    ReminderCategory.vaccine => Icons.vaccines_rounded,
    ReminderCategory.appointment => Icons.event_available_rounded,
    ReminderCategory.vitamin => Icons.medication_liquid_rounded,
    ReminderCategory.medicine => Icons.medication_rounded,
    ReminderCategory.sleep => Icons.nightlight_round,
    ReminderCategory.diaper => Icons.baby_changing_station_rounded,
    ReminderCategory.custom => Icons.auto_awesome_rounded,
  };

  String _reminderSubtitle(ReminderItem reminder) {
    final plan = ReminderPlan.tryParse(reminder.frequency);
    final schedule = switch (plan?.type) {
      ReminderPlanType.hourly =>
        'Her ${(plan?.intervalHours ?? 1)} saatte'
            ' ${(plan?.startHour ?? reminder.time.hour).toString().padLeft(2, '0')}:00-'
            '${(plan?.endHour ?? reminder.time.hour).toString().padLeft(2, '0')}:00',
      ReminderPlanType.weeklyTimes => 'Haftalık rutin',
      ReminderPlanType.monthlyDates => 'Aylık rutin',
      ReminderPlanType.once => 'Tek seferlik',
      _ => 'Günlük rutin',
    };
    final time =
        '${reminder.time.hour.toString().padLeft(2, '0')}:'
        '${reminder.time.minute.toString().padLeft(2, '0')}';
    final status = reminder.isActive ? 'Aktif' : 'Duraklatıldı';
    return '$schedule • $time • $status';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SoftIcon(icon: icon, size: 38),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
