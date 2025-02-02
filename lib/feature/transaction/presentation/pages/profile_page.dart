import 'dart:io';
import 'package:cuanbijak_flutter_uas/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:cuanbijak_flutter_uas/core/common/entities/user_entity.dart';
import 'package:cuanbijak_flutter_uas/core/common/widgets/loader_widget.dart';
import 'package:cuanbijak_flutter_uas/core/utils/show_snackbar.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserEntity user;
  bool _isEditing = false;
  bool _isChangePassword = false;
  File? _profileImage;
  double _passwordStrength = 0.0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;

    setState(() {
      _nameController.text = user.name;
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phoneNumber;
    });
  }

  void _updateProfile() async {
    context.read<AuthBloc>().add(
          UpdateUserData(
              id: user.id,
              name: _nameController.text,
              phoneNumber: _phoneController.text,
              image: _profileImage),
        );
  }

  void _changePassword() async {
    context.read<AuthBloc>().add(
          ChangePasswordUsers(password: _passwordController.text),
        );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  void _logout() async {
    context.read<AuthBloc>().add(
          LogoutUsers(),
        );
  }

  void _calculatePasswordStrength(String value) {
    double strength = 0;
    if (value.length >= 8) strength += 0.3;
    if (value.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (value.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.3;
    setState(() => _passwordStrength = strength.clamp(0.0, 1.0));
  }

  void _showPasswordChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Change Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    suffixIcon: Icon(Icons.lock, color: AppPallete.gradient2),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _calculatePasswordStrength(value);
                    });
                  },
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _passwordStrength,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _passwordStrength >= 0.7
                        ? AppPallete.greenColor700
                        : _passwordStrength >= 0.4
                            ? Colors.orange
                            : AppPallete.errorColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _passwordStrength >= 0.7
                      ? "Strong Password"
                      : _passwordStrength >= 0.4
                          ? "Medium Strength"
                          : "Weak Password",
                  style: TextStyle(
                    color: _passwordStrength >= 0.7
                        ? AppPallete.greenColor700
                        : _passwordStrength >= 0.4
                            ? Colors.orange
                            : AppPallete.errorColor,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.gradient2,
                ),
                onPressed: () {
                  if (!_isChangePassword) {
                    _isChangePassword = true;
                    _changePassword();
                  }
                },
                child: const Text("Confirm",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          _isChangePassword = false;
          showSnackBar(context, state.message);
        } else if (state is ChangeUserSuccess) {
          _isChangePassword = false;
          Navigator.pop(context);
        } else if (state is LogoutUserSuccess) {
          Navigator.pushAndRemoveUntil(
              context, LoginPage.route(), (route) => false);
        } else if (state is UpdateSuccess) {
          setState(() {
            _isEditing = false;
          });
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const LoaderWidget();
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppPallete.gradient1, AppPallete.gradient2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: _isEditing ? _pickImage : null,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppPallete.whiteColor,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : user.avatarUrl != ''
                                      ? NetworkImage(user.avatarUrl)
                                      : null,
                              child:
                                  _profileImage == null && user.avatarUrl == ''
                                      ? const Icon(
                                          Icons.person,
                                          size: 80,
                                          color: AppPallete.gradient2,
                                        )
                                      : null,
                            ),
                            if (_isEditing)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppPallete.gradient2,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildProfileCard(
                        icon: Icons.person_outline,
                        title: "Personal Information",
                        children: [
                          _buildEditableField(
                            label: "Full Name",
                            controller: _nameController,
                          ),
                          _buildEditableField(
                            label: "Email Address",
                            controller: _emailController,
                            enabled: false,
                          ),
                          _buildEditableField(
                            label: "Phone Number",
                            controller: _phoneController,
                            inputType: TextInputType.phone,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.gradient2,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(400, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _isEditing
                            ? _updateProfile()
                            : setState(() => _isEditing = true),
                        child: Text(
                          _isEditing ? "Save Changes" : "Edit Profile",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildProfileCard(
                        icon: Icons.security,
                        title: "Security",
                        children: [
                          ListTile(
                            leading: const Icon(Icons.lock_outline,
                                color: AppPallete.gradient2),
                            title: const Text("Change Password"),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: _showPasswordChangeDialog,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.gradient2,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(400, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _logout,
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(
      {required IconData icon,
      required String title,
      required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: AppPallete.gradient2),
                const SizedBox(width: 12),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing && enabled,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: _isEditing
              ? const Icon(Icons.edit, color: AppPallete.gradient2)
              : null,
        ),
      ),
    );
  }
}
