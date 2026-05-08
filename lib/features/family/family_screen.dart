import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_controller.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/app_ui.dart';
import '../../domain/entities/app_entities.dart';

class FamilyScreen extends ConsumerStatefulWidget {
  const FamilyScreen({super.key});

  @override
  ConsumerState<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends ConsumerState<FamilyScreen> {
  final _partnerEmail = TextEditingController();
  final _partnerName = TextEditingController();
  String _roleLabel = 'Ebeveyn';
  late Set<FamilyPermission> _selectedPermissions;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedPermissions = FamilyPermissionSets.defaultsForRole(
      _roleLabel,
    ).toSet();
    Future.microtask(() {
      final controller = ref.read(appControllerProvider);
      controller.refreshFamilyInvites(
        showDeviceNotification: false,
        force: false,
      );
      controller.refreshRemoteFamilies(force: false);
    });
  }

  @override
  void dispose() {
    _partnerEmail.dispose();
    _partnerName.dispose();
    super.dispose();
  }

  Future<void> _invitePartner() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(appControllerProvider)
          .addFamilyPartner(
            _partnerEmail.text,
            displayName: _partnerName.text,
            roleLabel: _roleLabel,
            permissions: _selectedPermissions.toList(),
          );
      _partnerEmail.clear();
      _partnerName.clear();
      if (mounted) {
        showAppSnack(context, 'Aile daveti karşı hesaba gönderildi.');
      }
    } catch (error) {
      if (mounted) showAppSnack(context, userFacingErrorMessage(error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(appSnapshotProvider);
    final partners = snapshot.family?.partnerUserIds ?? const <String>[];
    final invites = snapshot.invites;
    final controller = ref.read(appControllerProvider);
    final canInvite = controller.hasPermission(FamilyPermission.inviteUsers);
    final canManagePermissions = controller.hasPermission(
      FamilyPermission.manageUserPermissions,
    );
    final canRemoveMembers = controller.hasPermission(
      FamilyPermission.removeUsers,
    );
    return AppScreen(
      title: 'Ortak Çalışma Alanı',
      subtitle:
          'Bebeğinizin gelişimini partnerinizle birlikte yönetin ve senkronize kalın.',
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final inviteCard = _buildInviteCard(canInvite: canInvite);
            final membersCard = _buildMembersCard(
              partners: partners,
              invites: invites,
              canManagePermissions: canManagePermissions,
              canRemoveMembers: canRemoveMembers,
              currentUserId: snapshot.user?.id,
              isOwner: controller.isFamilyOwner,
            );
            if (constraints.maxWidth < 760) {
              return Column(
                children: [inviteCard, const SizedBox(height: 12), membersCard],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: inviteCard),
                const SizedBox(width: 12),
                Expanded(child: membersCard),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        AppCard(
          child: Column(
            children: [
              SwitchListTile(
                value: snapshot.familyNotificationsEnabled,
                onChanged: null,
                title: const Text('Senkronize Bildirimler'),
                subtitle: const Text(
                  'Aile bildirim tercihi Profil > Bildirimler bölümünden yönetilir.',
                ),
              ),
              const ListTile(
                title: Text('Beslenme Alarmları'),
                subtitle: Text('Her iki ebeveyn de aynı anda uyarılır'),
                trailing: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                ),
              ),
              const ListTile(
                title: Text('İlaç & Vitamin Takibi'),
                subtitle: Text('Doz atlanmasın diye ortak hatırlatıcılar'),
                trailing: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                ),
              ),
              SwitchListTile(
                value: false,
                onChanged: (_) => context.push('/sleep'),
                title: const Text('Uyku Rutini'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        AppCard(
          color: AppColors.softBlue,
          borderColor: const Color(0xFFD7E8F8),
          onTap: () => context.push('/quick-actions'),
          child: Row(
            children: [
              Image.asset(
                'assets/images/widget_mock.png',
                width: 88,
                height: 112,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Hızlı Onay Widget’ı\nUygulamayı açmadan beslenme veya bez değişimini tek dokunuşla onaylayın.',
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
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => showPrivacyInfoDialog(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.danger,
                ),
                title: const Text(
                  'Oturumu Kapat',
                  style: TextStyle(color: AppColors.danger),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () =>
                    _confirmLogout(context, ref.read(appControllerProvider)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Aktif aile: ${snapshot.family?.id ?? 'Yerel'}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }

  Widget _buildInviteCard({required bool canInvite}) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SoftIcon(
            icon: Icons.group_add_rounded,
            color: AppColors.softPink,
          ),
          const SizedBox(height: 14),
          const Text(
            'Ebeveyn Davet Et',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Text('Davet, karşı hesabın bildirimlerinde görünür.'),
          const SizedBox(height: 14),
          TextField(
            controller: _partnerEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'E-posta',
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
            onSubmitted: (_) => _invitePartner(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _partnerName,
            decoration: const InputDecoration(
              labelText: 'Görünen ad / özel rol adı',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _roleLabel,
            decoration: const InputDecoration(labelText: 'Rol'),
            items: const [
              DropdownMenuItem(value: 'Ebeveyn', child: Text('Ebeveyn')),
              DropdownMenuItem(value: 'Anne', child: Text('Anne')),
              DropdownMenuItem(value: 'Baba', child: Text('Baba')),
              DropdownMenuItem(value: 'Bakıcı', child: Text('Bakıcı')),
              DropdownMenuItem(value: 'Aile Üyesi', child: Text('Aile Üyesi')),
              DropdownMenuItem(value: 'Doktor', child: Text('Doktor')),
              DropdownMenuItem(
                value: 'Görüntüleyici',
                child: Text('Sadece görüntüleme'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _roleLabel = value;
                _selectedPermissions = FamilyPermissionSets.defaultsForRole(
                  value,
                ).toSet();
              });
            },
          ),
          const SizedBox(height: 12),
          _PermissionPicker(
            selected: _selectedPermissions,
            onChanged: (next) => setState(() => _selectedPermissions = next),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _saving || !canInvite ? null : _invitePartner,
            child: Text(_saving ? 'KAYDEDİLİYOR' : 'DAVET GÖNDER'),
          ),
          if (!canInvite) ...[
            const SizedBox(height: 8),
            const Text(
              'Davet göndermek için owner veya davet yetkisi gerekir.',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMembersCard({
    required List<String> partners,
    required List<FamilyInvite> invites,
    required bool canManagePermissions,
    required bool canRemoveMembers,
    required bool isOwner,
    String? currentUserId,
  }) {
    return AppCard(
      color: AppColors.softGreen,
      borderColor: const Color(0xFFD3E3DC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ortaklar ve Davetler',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          if (partners.isEmpty && invites.isEmpty)
            const Text('Henüz ortak eklenmedi.')
          else ...[
            for (final partner in partners)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(child: Icon(Icons.person_rounded)),
                title: Text(partner),
                subtitle: const Text('Hesap birleşti'),
              ),
            for (final invite in invites)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.softPink,
                  child: Icon(Icons.mail_outline_rounded),
                ),
                title: Text(
                  invite.invitedDisplayName?.trim().isNotEmpty == true
                      ? invite.invitedDisplayName!
                      : invite.invitedEmail,
                ),
                subtitle: Text(
                  '${invite.invitedEmail}\n${invite.roleLabel ?? 'Rol'} - ${invite.permissions.length} izin - Davet: ${invite.status.name}',
                ),
                isThreeLine: true,
                trailing: _InviteActions(
                  canEdit: canManagePermissions,
                  canRemove:
                      canRemoveMembers &&
                      invite.acceptedUserId != currentUserId,
                  onEdit: () => _editInvitePermissions(invite),
                  onRemove: () => _confirmRemoveMember(invite),
                ),
              ),
          ],
          Wrap(
            spacing: 8,
            children: [
              const Chip(label: Text('Paylaşım açık')),
              Chip(label: Text(isOwner ? 'Yetki: Owner' : 'Yetki: Sınırlı')),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _editInvitePermissions(FamilyInvite invite) async {
    final rootContext = context;
    final nameController = TextEditingController(
      text: invite.invitedDisplayName ?? '',
    );
    var roleLabel = _supportedRoleLabel(invite.roleLabel);
    var selected = invite.permissions.isEmpty
        ? FamilyPermissionSets.defaultsForRole(roleLabel).toSet()
        : invite.permissions.toSet();
    var saving = false;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> save() async {
              setSheetState(() => saving = true);
              try {
                await ref
                    .read(appControllerProvider)
                    .updateFamilyInvitePermissions(
                      inviteId: invite.id,
                      displayName: nameController.text,
                      roleLabel: roleLabel,
                      permissions: selected.toList(),
                    );
                if (sheetContext.mounted && rootContext.mounted) {
                  Navigator.pop(sheetContext);
                  showAppSnack(rootContext, 'Yetkiler güncellendi.');
                }
              } catch (error) {
                if (rootContext.mounted) {
                  showAppSnack(rootContext, userFacingErrorMessage(error));
                }
              } finally {
                if (sheetContext.mounted) {
                  setSheetState(() => saving = false);
                }
              }
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  MediaQuery.viewInsetsOf(context).bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        invite.invitedEmail,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Kişi Yetkileri',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Görünen ad / özel rol adı',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: roleLabel,
                        decoration: const InputDecoration(labelText: 'Rol'),
                        items: const [
                          DropdownMenuItem(
                            value: 'Ebeveyn',
                            child: Text('Ebeveyn'),
                          ),
                          DropdownMenuItem(value: 'Anne', child: Text('Anne')),
                          DropdownMenuItem(value: 'Baba', child: Text('Baba')),
                          DropdownMenuItem(
                            value: 'Bakıcı',
                            child: Text('Bakıcı'),
                          ),
                          DropdownMenuItem(
                            value: 'Aile Üyesi',
                            child: Text('Aile Üyesi'),
                          ),
                          DropdownMenuItem(
                            value: 'Doktor',
                            child: Text('Doktor'),
                          ),
                          DropdownMenuItem(
                            value: 'Görüntüleyici',
                            child: Text('Sadece görüntüleme'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setSheetState(() {
                            roleLabel = value;
                            selected = FamilyPermissionSets.defaultsForRole(
                              value,
                            ).toSet();
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _PermissionPicker(
                        selected: selected,
                        onChanged: (next) =>
                            setSheetState(() => selected = next),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: saving
                                  ? null
                                  : () => Navigator.pop(sheetContext),
                              child: const Text('Vazgeç'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton(
                              onPressed: saving ? null : save,
                              child: Text(saving ? 'KAYDEDİLİYOR' : 'KAYDET'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    nameController.dispose();
  }

  Future<void> _confirmRemoveMember(FamilyInvite invite) async {
    final label = invite.invitedDisplayName?.trim().isNotEmpty == true
        ? invite.invitedDisplayName!.trim()
        : invite.invitedEmail;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aile üyesini kaldır'),
        content: Text(
          '$label artık bu aile alanındaki kayıtları göremeyecek. Devam edilsin mi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Kaldır'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(appControllerProvider).removeFamilyMember(invite.id);
      if (mounted) showAppSnack(context, 'Aile üyesi kaldırıldı.');
    } catch (error) {
      if (mounted) showAppSnack(context, userFacingErrorMessage(error));
    }
  }

  String _supportedRoleLabel(String? value) {
    const roles = {
      'Ebeveyn',
      'Anne',
      'Baba',
      'Bakıcı',
      'Aile Üyesi',
      'Doktor',
      'Görüntüleyici',
    };
    final trimmed = value?.trim();
    return trimmed != null && roles.contains(trimmed) ? trimmed : 'Ebeveyn';
  }

  Future<void> _confirmLogout(
    BuildContext context,
    AppController controller,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Oturumu kapat'),
        content: const Text(
          'Bu cihazdaki oturum kapatılır; kayıtlarınız silinmez.',
        ),
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
}

class _InviteActions extends StatelessWidget {
  const _InviteActions({
    required this.canEdit,
    required this.canRemove,
    required this.onEdit,
    required this.onRemove,
  });

  final bool canEdit;
  final bool canRemove;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (!canEdit && !canRemove) return const SizedBox.shrink();
    return Wrap(
      spacing: 2,
      children: [
        if (canEdit)
          IconButton(
            tooltip: 'Yetkileri düzenle',
            icon: const Icon(Icons.tune_rounded),
            onPressed: onEdit,
          ),
        if (canRemove)
          IconButton(
            tooltip: 'Aile üyesini kaldır',
            icon: const Icon(Icons.person_remove_alt_1_rounded),
            color: AppColors.danger,
            onPressed: onRemove,
          ),
      ],
    );
  }
}

class _PermissionPicker extends StatelessWidget {
  const _PermissionPicker({required this.selected, required this.onChanged});

  final Set<FamilyPermission> selected;
  final ValueChanged<Set<FamilyPermission>> onChanged;

  @override
  Widget build(BuildContext context) {
    final groups = [
      (
        'Görüntüleme',
        [
          FamilyPermission.viewBaby,
          FamilyPermission.viewFeeding,
          FamilyPermission.viewDiaper,
          FamilyPermission.viewSleep,
          FamilyPermission.viewVaccines,
          FamilyPermission.viewAppointments,
          FamilyPermission.viewMemories,
          FamilyPermission.viewNotifications,
          FamilyPermission.viewStats,
        ],
      ),
      (
        'İşlem',
        [
          FamilyPermission.addFeeding,
          FamilyPermission.addDiaper,
          FamilyPermission.manageSleep,
          FamilyPermission.addGrowth,
          FamilyPermission.addVaccine,
          FamilyPermission.addAppointment,
          FamilyPermission.addMemory,
          FamilyPermission.saveArticle,
          FamilyPermission.editRecords,
          FamilyPermission.deleteRecords,
        ],
      ),
      (
        'Yönetim',
        [
          FamilyPermission.inviteUsers,
          FamilyPermission.manageUserPermissions,
          FamilyPermission.removeUsers,
          FamilyPermission.editFamily,
          FamilyPermission.editBaby,
          FamilyPermission.deleteFamilyData,
        ],
      ),
    ];
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      title: const Text(
        'Yetkiler',
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
      subtitle: Text('${selected.length} izin seçili'),
      children: [
        for (final group in groups) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Text(
                group.$1,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final permission in group.$2)
                FilterChip(
                  selected: selected.contains(permission),
                  label: Text(_label(permission)),
                  onSelected: (value) {
                    final next = {...selected};
                    if (value) {
                      next.add(permission);
                    } else {
                      next.remove(permission);
                    }
                    onChanged(next);
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }

  String _label(FamilyPermission permission) => switch (permission) {
    FamilyPermission.viewBaby => 'Bebek',
    FamilyPermission.viewFeeding => 'Beslenme',
    FamilyPermission.viewDiaper => 'Bez',
    FamilyPermission.viewSleep => 'Uyku',
    FamilyPermission.viewVaccines => 'Aşı',
    FamilyPermission.viewAppointments => 'Randevu',
    FamilyPermission.viewMemories => 'Anı',
    FamilyPermission.viewNotifications => 'Bildirim',
    FamilyPermission.viewStats => 'İstatistik',
    FamilyPermission.addFeeding => 'Beslenme ekle',
    FamilyPermission.addDiaper => 'Bez ekle',
    FamilyPermission.manageSleep => 'Uyku yönet',
    FamilyPermission.addGrowth => 'Ölçüm ekle',
    FamilyPermission.addVaccine => 'Aşı ekle',
    FamilyPermission.addAppointment => 'Randevu ekle',
    FamilyPermission.addMemory => 'Anı ekle',
    FamilyPermission.saveArticle => 'Makale kaydet',
    FamilyPermission.editRecords => 'Düzenle',
    FamilyPermission.deleteRecords => 'Sil',
    FamilyPermission.inviteUsers => 'Davet',
    FamilyPermission.manageUserPermissions => 'Yetki',
    FamilyPermission.removeUsers => 'Çıkar',
    FamilyPermission.editFamily => 'Aile düzenle',
    FamilyPermission.editBaby => 'Bebek düzenle',
    FamilyPermission.deleteFamilyData => 'Veri sil',
  };
}
