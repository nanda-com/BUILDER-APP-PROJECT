import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../services/mock_data_service.dart';
import '../../models/job_model.dart';
import '../../services/auth_service.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _wageCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _countCtrl = TextEditingController(text: '2');

  String _selectedCategory = 'Delivery';
  String _selectedDuration = '4 hrs';
  String _selectedDate = 'Today';
  bool _showPreview = false;
  bool _submitting = false;

  final _categories = [
    'Delivery',
    'Cafe',
    'Retail',
    'Warehouse',
    'Event',
    'IT Support',
    'Tutoring',
    'Cooking',
    'Security',
    'Cleaning'
  ];
  final _durations = ['2 hrs', '4 hrs', '6 hrs', '8 hrs', '10 hrs', '12 hrs'];
  final _dates = ['Today', 'Tomorrow', '18 Mar', '19 Mar', '20 Mar', '21 Mar'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _wageCtrl.dispose();
    _descCtrl.dispose();
    _addressCtrl.dispose();
    _countCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final wage = double.tryParse(_wageCtrl.text) ?? 150.0;
    final count = int.tryParse(_countCtrl.text) ?? 1;
    final currentUser = AuthService.currentUser;

    final newJob = JobModel(
      id: 'j${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.isEmpty ? 'New Job' : _titleCtrl.text,
      category: _selectedCategory,
      wagePerHour: wage,
      lat: 12.9716, // Default or mock lat
      lng: 77.5946, // Default or mock lng
      address: _addressCtrl.text.isEmpty ? 'Bengaluru' : _addressCtrl.text,
      city: 'Bengaluru',
      duration: _selectedDuration,
      shiftTime: '10:00 AM - 6:00 PM', // Default mock
      date: _selectedDate,
      description: _descCtrl.text,
      requirements: ['Any education'], // Default mock
      employerId: currentUser?.id ?? 'e001',
      employerName: currentUser?.name ?? 'Anonymous Employer',
      employerRating: currentUser?.rating ?? 5.0,
      employerVerified: currentUser?.isVerified ?? false,
      workersNeeded: count,
      workersBooked: 0,
      status: 'open',
    );
    
    // Add to mock data
    MockDataService.allJobs.insert(0, newJob);
    await MockDataService.saveJobs();

    if (!mounted) return;
    setState(() => _submitting = false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                  color: AppColors.emerald, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Job Posted! 🎉',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dark)),
            const SizedBox(height: 8),
            const Text(
                'Your job is live. Workers nearby will be notified instantly.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.grey500, fontSize: 13)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.saffron,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Go to Dashboard',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text('Post a Job'),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => _showPreview = !_showPreview),
            child: Text(_showPreview ? 'Edit' : 'Preview',
                style: const TextStyle(
                    color: AppColors.saffron, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: _showPreview ? _previewWidget() : _formWidget(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
        color: AppColors.white,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.saffronGrad,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: AppColors.saffron.withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8))
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _submitting ? null : _submit,
            icon: _submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.rocket_launch_rounded, size: 18),
            label: Text(_submitting ? 'Posting...' : 'Post Job Now ⚡',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('Job Details'),
            _Field(
                controller: _titleCtrl,
                label: 'Job Title',
                hint: 'e.g. Coffee Shop Assistant',
                icon: Icons.work_rounded),
            const SizedBox(height: 12),
            const _DropLabel('Category'),
            _CategorySelector(
                selected: _selectedCategory,
                categories: _categories,
                onSelect: (c) => setState(() => _selectedCategory = c)),
            const SizedBox(height: 16),
            _Field(
                controller: _descCtrl,
                label: 'Description',
                hint: 'Describe the tasks, benefits, requirements...',
                icon: Icons.description_rounded,
                maxLines: 3),
            const SizedBox(height: 20),
            const _SectionLabel('Compensation & Schedule'),
            Row(children: [
              Expanded(
                  child: _Field(
                      controller: _wageCtrl,
                      label: 'Wage (₹/hr)',
                      hint: '150',
                      icon: Icons.currency_rupee_rounded,
                      keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(
                  child: _Field(
                      controller: _countCtrl,
                      label: 'Workers Needed',
                      hint: '2',
                      icon: Icons.people_rounded,
                      keyboardType: TextInputType.number)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: _DropdownField(
                      label: 'Duration',
                      value: _selectedDuration,
                      items: _durations,
                      onChanged: (v) =>
                          setState(() => _selectedDuration = v!))),
              const SizedBox(width: 12),
              Expanded(
                  child: _DropdownField(
                      label: 'Date',
                      value: _selectedDate,
                      items: _dates,
                      onChanged: (v) => setState(() => _selectedDate = v!))),
            ]),
            const SizedBox(height: 20),
            const _SectionLabel('Location'),
            _Field(
                controller: _addressCtrl,
                label: 'Address / Landmark',
                hint: 'e.g. MG Road, Bengaluru',
                icon: Icons.location_on_rounded),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _previewWidget() {
    final color =
        AppColors.categoryColors[_selectedCategory] ?? AppColors.saffron;
    final wage = double.tryParse(_wageCtrl.text) ?? 0;
    final hrs = double.tryParse(_selectedDuration.split(' ')[0]) ?? 4;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Job Preview',
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w500)),
          const Text('This is how workers will see your post',
              style: TextStyle(fontSize: 12, color: AppColors.grey300)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(_selectedCategory,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                      const Spacer(),
                      Text(_selectedDate,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.grey500)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          _titleCtrl.text.isEmpty
                              ? 'Job Title'
                              : _titleCtrl.text,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.dark)),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.location_on_rounded,
                            size: 13, color: AppColors.grey500),
                        const SizedBox(width: 4),
                        Text(
                            _addressCtrl.text.isEmpty
                                ? 'Address'
                                : _addressCtrl.text,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.grey500)),
                      ]),
                      const SizedBox(height: 14),
                      Row(children: [
                        _PreviewChip('₹${wage.toInt()}/hr', AppColors.saffron),
                        const SizedBox(width: 8),
                        _PreviewChip(_selectedDuration, AppColors.sky),
                        const SizedBox(width: 8),
                        _PreviewChip(
                            'Earn ₹${(wage * hrs).toInt()}', AppColors.emerald),
                      ]),
                      const SizedBox(height: 14),
                      Text(
                          _descCtrl.text.isEmpty
                              ? 'Job description...'
                              : _descCtrl.text,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.grey500,
                              height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(label,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.dark)),
    );
  }
}

class _DropLabel extends StatelessWidget {
  final String label;
  const _DropLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.grey700)),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;
  const _Field(
      {required this.controller,
      required this.label,
      required this.hint,
      required this.icon,
      this.maxLines = 1,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.grey700)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18, color: AppColors.grey300),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label, value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropdownField(
      {required this.label,
      required this.value,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.grey700)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.grey300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.grey500),
              style: const TextStyle(
                  fontSize: 14, color: AppColors.dark, fontFamily: 'Poppins'),
              onChanged: onChanged,
              items: items
                  .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final String selected;
  final List<String> categories;
  final ValueChanged<String> onSelect;
  const _CategorySelector(
      {required this.selected,
      required this.categories,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categories.map((c) {
          final isSelected = c == selected;
          final color = AppColors.categoryColors[c] ?? AppColors.saffron;
          return GestureDetector(
            onTap: () => onSelect(c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? color : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: isSelected ? color : AppColors.grey300),
              ),
              child: Text(c,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.grey500)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PreviewChip extends StatelessWidget {
  final String label;
  final Color color;
  const _PreviewChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
