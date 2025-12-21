import 'package:clifting_app/features/auth/data/model/user_model.dart';
import 'package:clifting_app/utility/colors.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final UserResponse user;

  const AboutScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Format date of birth
    String formattedDateOfBirth = 'Not set';
    final date = user.dateOfBirth!;
    formattedDateOfBirth =
        '${_getMonthName(date.month)} ${date.day}, ${date.year}';

    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
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
                  SizedBox(width: 16),
                  Text(
                    'About',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                    // Profile Info Card
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            offset: Offset(0, 6),
                          ),
                          BoxShadow(
                            color: AppColors.cyberBlue.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bio Section
                          if (user.bio != null && user.bio!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.cyberBlue.withOpacity(
                                              0.3,
                                            ),
                                            AppColors.cyberBlue.withOpacity(
                                              0.1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.description_outlined,
                                        color: AppColors.cyberBlue,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Bio',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.05),
                                        Colors.white.withOpacity(0.02),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  child: Text(
                                    user.bio!,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),

                          // Personal Info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.cyberBlue.withOpacity(0.3),
                                          AppColors.cyberBlue.withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.person_outline,
                                      color: AppColors.cyberBlue,
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Personal Info',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              _buildInfoRow(
                                'Date of Birth',
                                formattedDateOfBirth,
                                Icons.cake_outlined,
                              ),
                              _buildInfoRow(
                                'Gender',
                                user.gender ?? 'Not set',
                                Icons.transgender,
                              ),
                              _buildInfoRow(
                                'Looking for',
                                user.lookingFor ?? 'Not set',
                                Icons.search,
                              ),
                              _buildInfoRow(
                                'Education',
                                user.education ?? 'Not set',
                                Icons.school_outlined,
                              ),
                              _buildInfoRow(
                                'Profession',
                                user.profession ?? 'Not set',
                                Icons.work_outline,
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Contact Info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.cyberBlue.withOpacity(0.3),
                                          AppColors.cyberBlue.withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.contact_mail_outlined,
                                      color: AppColors.cyberBlue,
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Contact',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              _buildInfoRow(
                                'Email',
                                user.email ?? '',
                                Icons.email_outlined,
                              ),
                              _buildInfoRow(
                                'Phone',
                                user.phoneNumber ?? 'Not set',
                                Icons.phone_outlined,
                              ),
                              _buildInfoRow(
                                'City',
                                user.city ?? 'Not set',
                                Icons.location_city_outlined,
                              ),
                              _buildInfoRow(
                                'Country',
                                user.country ?? 'Not set',
                                Icons.public_outlined,
                              ),
                            ],
                          ),

                          // Interests
                          if (user.interests != null &&
                              user.interests!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.cyberBlue.withOpacity(
                                              0.3,
                                            ),
                                            AppColors.cyberBlue.withOpacity(
                                              0.1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.interests_outlined,
                                        color: AppColors.cyberBlue,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Interests',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: user.interests!
                                      .map(
                                        (interest) => Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.cyberBlue.withOpacity(
                                                  0.3,
                                                ),
                                                AppColors.electricGold
                                                    .withOpacity(0.2),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            border: Border.all(
                                              color: AppColors.cyberBlue
                                                  .withOpacity(0.4),
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.cyberBlue
                                                    .withOpacity(0.2),
                                                blurRadius: 5,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            interest,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.03),
            Colors.white.withOpacity(0.01),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.cyberBlue, size: 16),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return monthNames[month - 1];
  }
}
