import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/profile.dart';
import '../bloc/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.profile});
  final Profile profile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _fullName;
  late final TextEditingController _nickName;
  late final TextEditingController _phone;
  late final TextEditingController _bio;
  late final TextEditingController _languages;
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    _fullName = TextEditingController(text: widget.profile.fullName);
    _nickName = TextEditingController(text: widget.profile.nickName);
    _phone = TextEditingController(text: widget.profile.phone);
    _bio = TextEditingController(text: widget.profile.bio);
    _languages = TextEditingController(text: widget.profile.languages);
    _birthDate = widget.profile.birthDate;
  }

  @override
  void dispose() {
    _fullName.dispose();
    _nickName.dispose();
    _phone.dispose();
    _bio.dispose();
    _languages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (p, n) => p.saving != n.saving && !n.saving,
      listener: (context, state) {
        if (state.errorMessage == null && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Редактировать профиль'),
            actions: [
              TextButton(
                onPressed: state.saving ? null : _save,
                child: state.saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Сохранить',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
            children: [
              _Field(
                label: 'Полное имя',
                controller: _fullName,
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 12),
              _Field(
                label: 'Никнейм',
                controller: _nickName,
                icon: Icons.alternate_email_rounded,
              ),
              const SizedBox(height: 12),
              _Field(
                label: 'Телефон',
                controller: _phone,
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _DateField(
                value: _birthDate,
                onChange: (d) => setState(() => _birthDate = d),
              ),
              const SizedBox(height: 12),
              _Field(
                label: 'Языки (через запятую)',
                controller: _languages,
                icon: Icons.translate_rounded,
              ),
              const SizedBox(height: 12),
              _Field(
                label: 'О себе',
                controller: _bio,
                icon: Icons.notes_rounded,
                maxLines: 4,
              ),
            ],
          ),
        );
      },
    );
  }

  void _save() {
    final patch = ProfileUpdate(
      fullName: _fullName.text.trim(),
      nickName: _nickName.text.trim(),
      phone: _phone.text.trim(),
      bio: _bio.text.trim(),
      languages: _languages.text.trim(),
      birthDate: _birthDate,
    );
    context.read<ProfileBloc>().add(ProfileUpdateRequested(patch));
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryDeep),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.value, required this.onChange});
  final DateTime? value;
  final ValueChanged<DateTime?> onChange;

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? 'Не указано'
        : DateFormat('d MMMM y', 'ru').format(value!);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime(2000, 1, 1),
          firstDate: DateTime(1925),
          lastDate: DateTime.now(),
          locale: const Locale('ru'),
        );
        if (picked != null) onChange(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'День рождения',
          prefixIcon: const Icon(Icons.cake_rounded,
              color: AppColors.primaryDeep),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Text(text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            )),
      ),
    );
  }
}
