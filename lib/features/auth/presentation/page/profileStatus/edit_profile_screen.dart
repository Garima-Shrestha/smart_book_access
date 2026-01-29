import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_book_access/core/utils/snackbar_utils.dart';
import 'package:smart_book_access/features/auth/presentation/state/auth_state.dart';
import 'package:smart_book_access/features/auth/presentation/view_model/auth_view_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final Color primaryBlue = const Color(0xFF1E88E5);
  final Color darkBlue = const Color(0xFF003049);
  final Color lightBg = const Color(0xFFF7F9FC);

  bool _imageLoadFailed = false;

  String _selectedCountryCode = '+977'; // Default Nepal
  final List<Map<String, String>> _countryCodes = [
    {'code': '+977', 'name': 'Nepal', 'flag': '🇳🇵'},
    {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
    {'code': '+1', 'name': 'USA', 'flag': '🇺🇸'},
    {'code': '+44', 'name': 'UK', 'flag': '🇬🇧'},
    {'code': '+86', 'name': 'China', 'flag': '🇨🇳'},
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(authViewModelProvider).authEntity;
    _nameController.text = user?.username ?? "";
    _emailController.text = user?.email ?? "";
    _phoneController.text = user?.phone ?? "";
    _selectedCountryCode = user?.countryCode ?? "+977";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Permission
  final ImagePicker _imagePicker = ImagePicker();
  File? _profileImage; // To store the selected file locally for preview

  // Updated Permission Check
  Future<bool> _checkPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }
    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text("To update your privacy picture, please enable camera/gallery access in your settings."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")
          ),
          TextButton(
              onPressed: () {
                openAppSettings(); // Requires permission_handler package
                Navigator.pop(context);
              },
              child: const Text("Settings")
          ),
        ],
      ),
    );
  }

  // From Camera
  Future<void> _pickFromCamera() async {
    final hasPermission = await _checkPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _profileImage = File(photo.path);
        _imageLoadFailed = false;
      });
    }
  }

  // From Gallery
  Future<void> _pickFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
        _imageLoadFailed = false;
      });
    }
  }

  // code for dialogBox : showDialog for menu
  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          )
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Change Profile Picture",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: Icon(Icons.camera_alt, color: primaryBlue),
                title: const Text("Open Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: primaryBlue),
                title: const Text("Open Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Check if any text field or the privacy image is different from the original data.
  bool _hasChanges() {
    final user = ref.read(authViewModelProvider).authEntity;

    // Check if any text field value is different from the stored user data
    final nameChanged = _nameController.text.trim() != user?.username;
    final emailChanged = _emailController.text.trim() != user?.email;
    final phoneChanged = _phoneController.text.trim() != user?.phone;
    final countryChanged = _selectedCountryCode != user?.countryCode;

    // If _profileImage is not null, it means the user has picked a new file
    final imageChanged = _profileImage != null;
    return nameChanged || emailChanged || phoneChanged || countryChanged || imageChanged;
  }


  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;

    // This part listens for errors/success and shows Snackbars
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.updated) {
        SnackbarUtils.showSuccess(context, "Profile updated successfully!");
        setState(() {
          _profileImage = null;
          _imageLoadFailed = false;
        });

        ref.read(authViewModelProvider.notifier).clearError();
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
        ref.read(authViewModelProvider.notifier).clearError();
      }
    });


    ImageProvider? getImageProvider() {
      // 1. If a new image was just picked from gallery/camera, show that first
      if (_profileImage != null) {
        return FileImage(_profileImage!);
      }

      final savedPath = user?.imageUrl;
      // If there is no image path saved in the user profile, return null (shows initials)
      if (savedPath == null || savedPath.isEmpty) return null;

      // if (savedPath != null && savedPath.isNotEmpty) {
      //   // If the image is NOT on this phone, download it from our Node.js server
      //   if (savedPath.startsWith('/uploads')) {
      //     NetworkImage("http://10.0.2.2:5050$savedPath");
      //   }
      //   // If the image is saved on THIS phone (after we just picked it), load it from the phone's memory
      //   if (savedPath.startsWith('/') && !savedPath.startsWith('/uploads')) {
      //     final localFile = File(savedPath);
      //     if (localFile.existsSync()) {
      //       return FileImage(localFile);
      //     }
      //   }
      //   NetworkImage("http://10.0.2.2:5050$savedPath");
      // }


      // Load from Backend (Node.js server)
      if (savedPath.startsWith('/uploads')) {
        return NetworkImage("http://10.0.2.2:5050$savedPath");
      }

      // Load from Phone Storage (if path is local)
      if (File(savedPath).existsSync()) {
        return FileImage(File(savedPath));
      }

      // 4. Fallback: Try as a full network URL if applicable
      if (savedPath.startsWith('http')) {
        return NetworkImage(savedPath);
      }
      // Fallback: If none of the above match, show the initials.
      return null;
    }

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: lightBg,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Image Edit
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryBlue.withOpacity(0.1), width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color(0xFFE3F2FD),

                      // If load failed, don't even try to set the background image, set to null
                      backgroundImage: _imageLoadFailed ? null : getImageProvider(),

                      // It handles cases where the image file is missing on the server [If the image is null, this listener MUST also be null]
                        onBackgroundImageError: (_imageLoadFailed || getImageProvider() == null)
                            ? null
                            : (exception, stackTrace) {
                          // If it fails, set this to true to force the letter to show
                          if (!_imageLoadFailed) {
                            setState(() {
                              _imageLoadFailed = true;
                            });
                          }
                        },

                      // If no image, display the 1st letter of username
                      child: (getImageProvider() == null || _imageLoadFailed)
                          ? Text(
                        (user?.username != null && user!.username.trim().isNotEmpty)
                            ? user.username.trim()[0].toUpperCase()
                            : "U",
                        style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue
                        ),
                      )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _pickMedia(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: darkBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Form Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Field
                  const Text(
                    "Name",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Example",
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: primaryBlue, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Email Field
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "example@gmail.com",
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: primaryBlue, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Phone Number Field
                  const Text(
                    "Phone Number",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Country Code
                      SizedBox(
                        width: 120,
                        child: DropdownButtonFormField<String>(
                          value: _selectedCountryCode,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: primaryBlue, width: 1.5),
                            ),
                          ),
                          items: _countryCodes.map((country) {
                            return DropdownMenuItem<String>(
                              value: country['code'],
                              child: Text(
                                "${country['flag']} ${country['code']}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCountryCode = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "9000000000",
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: primaryBlue, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: authState.status == AuthStatus.loading
                          ? null
                          : () {
                        // Stop the update process if the user hasn't made any changes.
                        if (!_hasChanges()) {
                          SnackbarUtils.showInfo(context, "No changes detected to update.");
                          return; // Stop here, don't call the API
                        }

                        // Call the ViewModel
                        ref.read(authViewModelProvider.notifier).updateProfile(
                          username: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          countryCode: _selectedCountryCode,
                          phone: _phoneController.text.trim(),
                          imageUrl: _profileImage,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      // Show a loader if status is loading, otherwise show text
                      child: authState.status == AuthStatus.loading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}