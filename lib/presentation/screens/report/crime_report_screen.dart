import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CrimeReportScreen extends StatefulWidget {
  const CrimeReportScreen({super.key});

  @override
  State<CrimeReportScreen> createState() => _CrimeReportScreenState();
}

class _CrimeReportScreenState extends State<CrimeReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String _crimeType = 'Theft';
  String _description = '';
  bool _isAnonymous = true;
  List<String> _attachments = [];

  final List<String> _crimeTypes = [
    'Theft',
    'Assault',
    'Vandalism',
    'Suspicious Activity',
    'Other'
  ];

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Implement report submission logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted successfully'),
          backgroundColor: AppColors.navyBlue,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Crime'),
        backgroundColor: AppColors.navyBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: AppColors.burgundy.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.security, color: AppColors.burgundy),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Your report will help keep the community safe. All information is encrypted and secure.',
                          style: TextStyle(color: AppColors.burgundy),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _crimeType,
                decoration: const InputDecoration(
                  labelText: 'Type of Crime',
                  border: OutlineInputBorder(),
                ),
                items: _crimeTypes.map((String type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _crimeType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  hintText: 'Provide details about the incident...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Submit Anonymously'),
                value: _isAnonymous,
                onChanged: (bool value) {
                  setState(() {
                    _isAnonymous = value;
                  });
                },
                activeColor: AppColors.burgundy,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement file attachment
                  setState(() {
                    _attachments.add('New attachment');
                  });
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Add Photos/Videos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.crimsonRed,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              if (_attachments.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  '${_attachments.length} attachments',
                  style: TextStyle(color: AppColors.burgundy),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navyBlue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 