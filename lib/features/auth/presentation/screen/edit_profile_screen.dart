import 'dart:io';
import 'package:clifting_app/features/auth/data/model/login_model.dart';
import 'package:clifting_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:clifting_app/utility/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final User user;
  final Function(User) onProfileUpdated;

  const EditProfileScreen({
    super.key,
    required this.user,
    required this.onProfileUpdated,
  });

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _professionController;
  late TextEditingController _educationController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _lookingForController;
  
  String? _gender;
  DateTime? _dateOfBirth;
  List<String> _interests = [];
  TextEditingController _interestController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController(text: widget.user.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.user.lastName ?? '');
    _emailController = TextEditingController(text: widget.user.email ?? '');
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
    _bioController = TextEditingController(text: widget.user.bio ?? '');
    _professionController = TextEditingController(text: widget.user.profession ?? '');
    _educationController = TextEditingController(text: widget.user.education ?? '');
    _cityController = TextEditingController(text: widget.user.city ?? '');
    _countryController = TextEditingController(text: widget.user.country ?? '');
    _lookingForController = TextEditingController(text: widget.user.lookingFor ?? '');
    _gender = widget.user.gender;
    _dateOfBirth = widget.user.dateOfBirth;
    _interests = widget.user.interests ?? [];
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // final apiService = ref.read(apiServiceProvider);
      
      // Prepare form data for image upload
      var formData = FormData();
      
      // Add image if selected
      if (_profileImage != null) {
        formData.files.add(MapEntry(
          'profileImage',
          await MultipartFile.fromFile(_profileImage!.path),
        ));
      }

      // Prepare user data
      // final updatedUser = User(
      //   id: widget.user.id,
      //   firstName: _firstNameController.text,
      //   lastName: _lastNameController.text,
      //   email: _emailController.text,
      //   phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      //   bio: _bioController.text.isNotEmpty ? _bioController.text : null,
      //   profession: _professionController.text.isNotEmpty ? _professionController.text : null,
      //   education: _educationController.text.isNotEmpty ? _educationController.text : null,
      //   city: _cityController.text.isNotEmpty ? _cityController.text : null,
      //   country: _countryController.text.isNotEmpty ? _countryController.text : null,
      //   lookingFor: _lookingForController.text.isNotEmpty ? _lookingForController.text : null,
      //   gender: _gender,
      //   dateOfBirth: _dateOfBirth,
      //   interests: _interests,
      //   verified: widget.user.verified,
      // );

      // Add user data to form
      // formData.fields.addAll(updatedUser.toJson().entries.map((e) => 
      //   MapEntry(e.key, e.value?.toString() ?? '')
      // ));

      // final response = await apiService.put('/auth/profile', data: formData);

      // if (response.statusCode == 200) {
      //   widget.onProfileUpdated(updatedUser);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Profile updated successfully'),
      //       backgroundColor: Colors.green,
      //     ),
      //   );
        Navigator.pop(context);
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addInterest() {
    if (_interestController.text.trim().isNotEmpty) {
      setState(() {
        _interests.add(_interestController.text.trim());
        _interestController.clear();
      });
    }
  }

  void _removeInterest(int index) {
    setState(() {
      _interests.removeAt(index);
    });
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.cyberBlue,
              onPrimary: Colors.white,
              surface: AppColors.midnightBlue,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppColors.midnightBlue,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.cyberBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _professionController.dispose();
    _educationController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _lookingForController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: _isLoading ? null : _saveProfile,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.cyberBlue,
                            AppColors.electricGold,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyberBlue.withOpacity(0.5),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Image Upload
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.electricGold,
                                  AppColors.cyberBlue,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.cyberBlue.withOpacity(0.6),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: _profileImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.file(
                                      _profileImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      (_firstNameController.text.isNotEmpty 
                                          ? _firstNameController.text[0] 
                                          : 'U').toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 46,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.cyberBlue,
                                    AppColors.electricGold,
                                  ],
                                ),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tap to change profile picture',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Form Fields
                    _buildTextField(_firstNameController, 'First Name', Icons.person_outline),
                    SizedBox(height: 16),
                    _buildTextField(_lastNameController, 'Last Name', Icons.person_outline),
                    SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email', Icons.email_outlined, enabled: false),
                    SizedBox(height: 16),
                    _buildTextField(_phoneController, 'Phone Number', Icons.phone_outlined),
                    SizedBox(height: 16),
                    _buildTextField(_professionController, 'Profession', Icons.work_outline),
                    SizedBox(height: 16),
                    _buildTextField(_educationController, 'Education', Icons.school_outlined),
                    SizedBox(height: 16),
                    _buildTextField(_cityController, 'City', Icons.location_city_outlined),
                    SizedBox(height: 16),
                    _buildTextField(_countryController, 'Country', Icons.public_outlined),
                    SizedBox(height: 16),

                    // Bio (Multi-line)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _bioController,
                        style: TextStyle(color: Colors.white),
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                          border: InputBorder.none,
                          icon: Icon(Icons.description_outlined, color: AppColors.cyberBlue),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Date of Birth
                    GestureDetector(
                      onTap: _selectDateOfBirth,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.cake_outlined, color: AppColors.cyberBlue),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date of Birth',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _dateOfBirth != null
                                        ? '${_getMonthName(_dateOfBirth!.month)} ${_dateOfBirth!.day}, ${_dateOfBirth!.year}'
                                        : 'Select date',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.white.withOpacity(0.7)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Gender Dropdown
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _gender,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.white.withOpacity(0.7)),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.white),
                          dropdownColor: AppColors.midnightBlue,
                          borderRadius: BorderRadius.circular(12),
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Icon(Icons.transgender, color: AppColors.cyberBlue),
                              SizedBox(width: 12),
                              Text(
                                'Select Gender',
                                style: TextStyle(color: Colors.white.withOpacity(0.7)),
                              ),
                            ],
                          ),
                          items: ['Male', 'Female', 'Other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _gender = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Looking For
                    _buildTextField(_lookingForController, 'Looking For', Icons.search),
                    SizedBox(height: 16),

                    // Interests
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.interests_outlined, color: AppColors.cyberBlue),
                              SizedBox(width: 12),
                              Text(
                                'Interests',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.1),
                                        Colors.white.withOpacity(0.05),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _interestController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Add an interest...',
                                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                      border: InputBorder.none,
                                    ),
                                    onSubmitted: (_) => _addInterest(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: _addInterest,
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.cyberBlue,
                                        AppColors.electricGold,
                                      ],
                                    ),
                                  ),
                                  child: Icon(Icons.add, color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(_interests.length, (index) {
                              return Chip(
                                label: Text(
                                  _interests[index],
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: AppColors.cyberBlue.withOpacity(0.3),
                                deleteIcon: Icon(Icons.close, size: 16, color: Colors.white),
                                onDeleted: () => _removeInterest(index),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool enabled = true}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          border: InputBorder.none,
          icon: Icon(icon, color: AppColors.cyberBlue),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }
}