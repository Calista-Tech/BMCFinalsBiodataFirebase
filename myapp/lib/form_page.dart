import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biodata',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const Biodata(),
    );
  }
}

class Biodata extends StatefulWidget {
  const Biodata({super.key});

  @override
  State<Biodata> createState() => _BiodataState();
}

class _BiodataState extends State<Biodata> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Basic Information
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final birthdayController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // Personal Information
  final genderController = TextEditingController();
  final nationalityController = TextEditingController();
  final civilStatusController = TextEditingController();
  final religionController = TextEditingController();

  // Education Background
  final elementaryController = TextEditingController();
  final highSchoolController = TextEditingController();
  final collegeController = TextEditingController();
  final degreeController = TextEditingController();

  // Other Information
  final skillsController = TextEditingController();
  final hobbiesController = TextEditingController();

  bool showBiodata = false;
  bool isSaving = false;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    birthdayController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();

    genderController.dispose();
    nationalityController.dispose();
    civilStatusController.dispose();
    religionController.dispose();

    elementaryController.dispose();
    highSchoolController.dispose();
    collegeController.dispose();
    degreeController.dispose();

    skillsController.dispose();
    hobbiesController.dispose();

    super.dispose();
  }

  // Save Biodata to Firestore
  Future<void> submitBiodata() async {
    // Check if all required fields are filled
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      // Save data to Firestore
      await FirebaseFirestore.instance.collection('biodata').add({
        'fullName': nameController.text.trim(),
        'age': ageController.text.trim(),
        'birthday': birthdayController.text.trim(),
        'address': addressController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'email': emailController.text.trim(),

        'gender': genderController.text.trim(),
        'nationality': nationalityController.text.trim(),
        'civilStatus': civilStatusController.text.trim(),
        'religion': religionController.text.trim(),

        'elementarySchool': elementaryController.text.trim(),
        'highSchool': highSchoolController.text.trim(),
        'collegeUniversity': collegeController.text.trim(),
        'degreeCourse': degreeController.text.trim(),

        'skills': skillsController.text.trim(),
        'hobbiesInterests': hobbiesController.text.trim(),

        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() {
        showBiodata = true;
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biodata saved successfully to Firestore!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving biodata: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // Text input field
  Widget textInput(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label is required';
                }
                return null;
              }
            : null,
      ),
    );
  }

  // Email input field
  Widget emailInput(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }

          if (!value.contains('@') || !value.contains('.')) {
            return 'Please enter a valid email';
          }

          return null;
        },
      ),
    );
  }

  // Age input field
  Widget ageInput(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }

          if (int.tryParse(value.trim()) == null) {
            return 'Please enter a valid age';
          }

          return null;
        },
      ),
    );
  }

  // Section title
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  // Biodata output row
  Widget biodataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not provided' : value,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biodata'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Biodata Form',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),


                sectionTitle('Basic Information'),

                textInput(
                  'Full Name',
                  nameController,
                ),

                ageInput(
                  'Age',
                  ageController,
                ),

                textInput(
                  'Birthday',
                  birthdayController,
                ),

                textInput(
                  'Address',
                  addressController,
                ),

                textInput(
                  'Phone Number',
                  phoneController,
                  keyboardType: TextInputType.phone,
                ),

                emailInput(
                  'Email',
                  emailController,
                ),


                sectionTitle('Personal Information'),

                textInput(
                  'Gender',
                  genderController,
                ),

                textInput(
                  'Nationality',
                  nationalityController,
                ),

                textInput(
                  'Civil Status',
                  civilStatusController,
                ),

                textInput(
                  'Religion',
                  religionController,
                ),


                sectionTitle('Education Background'),

                textInput(
                  'Elementary School',
                  elementaryController,
                ),

                textInput(
                  'High School',
                  highSchoolController,
                ),

                textInput(
                  'College / University',
                  collegeController,
                ),

                textInput(
                  'Degree / Course',
                  degreeController,
                ),


                sectionTitle('Other Information'),

                textInput(
                  'Skills',
                  skillsController,
                ),

                textInput(
                  'Hobbies / Interests',
                  hobbiesController,
                ),

                const SizedBox(height: 10),


                ElevatedButton(
                  onPressed: isSaving ? null : submitBiodata,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: isSaving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(fontSize: 16),
                        ),
                ),

                
                if (showBiodata) ...[
                  const SizedBox(height: 25),

                  const Divider(
                    thickness: 1.5,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'MY BIODATA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Basic Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  biodataRow(
                    'Full Name',
                    nameController.text,
                  ),

                  biodataRow(
                    'Age',
                    ageController.text,
                  ),

                  biodataRow(
                    'Birthday',
                    birthdayController.text,
                  ),

                  biodataRow(
                    'Address',
                    addressController.text,
                  ),

                  biodataRow(
                    'Phone',
                    phoneController.text,
                  ),

                  biodataRow(
                    'Email',
                    emailController.text,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  biodataRow(
                    'Gender',
                    genderController.text,
                  ),

                  biodataRow(
                    'Nationality',
                    nationalityController.text,
                  ),

                  biodataRow(
                    'Civil Status',
                    civilStatusController.text,
                  ),

                  biodataRow(
                    'Religion',
                    religionController.text,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Education Background',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  biodataRow(
                    'Elementary',
                    elementaryController.text,
                  ),

                  biodataRow(
                    'High School',
                    highSchoolController.text,
                  ),

                  biodataRow(
                    'College / University',
                    collegeController.text,
                  ),

                  biodataRow(
                    'Degree / Course',
                    degreeController.text,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Other Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  biodataRow(
                    'Skills',
                    skillsController.text,
                  ),

                  biodataRow(
                    'Hobbies',
                    hobbiesController.text,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}