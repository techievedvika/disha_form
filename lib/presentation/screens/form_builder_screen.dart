import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../logic/bloc/form_builder/form_builder_bloc.dart';
import '../../../logic/bloc/form_builder/form_builder_state.dart';
import '../../logic/bloc/form_builder/form_builder_event.dart';
import '../widgets/form_canvas.dart';
import '../../service/form_repository.dart';
import '../widgets/normal_widgets/custom_appbar.dart';
import '../widgets/normal_widgets/custom_dragable_drawer.dart';
import 'form_preview_screen.dart';

class FormBuilderScreen extends StatefulWidget {
  final String? formId;

  const FormBuilderScreen({super.key, this.formId});

  @override
  State<FormBuilderScreen> createState() => _FormBuilderScreenState();
}

class _FormBuilderScreenState extends State<FormBuilderScreen> {
  String _currentUserId = '';
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  // Fetch userId once when screen initializes
  Future<void> _loadUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _currentUserId = prefs.getString('user_id')!;
        _isLoadingUser = false;
      });
    } catch (e) {
      setState(() => _isLoadingUser = false);
    }
  }

  void _showSaveFormDialog(BuildContext context) {
    if (_currentUserId == '' || _currentUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save forms')),
      );
      return;
    }

    final formNameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.indigo.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.indigo.shade400, Colors.indigo.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.save_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Save Form',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: formNameController,
                    decoration: InputDecoration(
                      labelText: 'Form Name',
                      prefixIcon: const Icon(Icons.edit_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Enter a name' : null,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey.shade700)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final name = formNameController.text.trim();
                          Navigator.pop(dialogContext);
                          _executeSave(context,name); // Need to pass userId who created form
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _executeSave(BuildContext context,String formName) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text('Saving form...')),
    );

    try {
      final repo = FormRepository();

      final widgets = context.read<FormBuilderBloc>().state.widgets;

      final savedFormId = await repo.saveForm(widgets, _currentUserId, formName);

      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Form saved successfully!'),
        ),
      );
    } catch (e) {
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text('Error: $e')),
      );
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = FormBuilderBloc();
        if (widget.formId != null) {
          bloc.add(LoadFormEvent(widget.formId!,_currentUserId));
        }
        return bloc;
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: CustomAppBar(
              title: "Create Form",
              actions: [
                IconButton(
                    icon: const Icon(Icons.play_arrow_outlined, color: Colors.white),
                    tooltip: 'View Form Preview',
                    onPressed: () {
                      final widgets = context.read<FormBuilderBloc>().state.widgets;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormPreviewScreen(formFields: widgets),
                        ),
                      );
                    }
                ),
                IconButton(
                  icon: const Icon(Icons.list_alt, color: Colors.white),
                  tooltip: 'View My Forms',
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                ),
                BlocBuilder<FormBuilderBloc, FormBuilderState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: const Icon(Icons.save, color: Colors.white),
                      onPressed: (state.widgets.isEmpty || _isLoadingUser)
                          ? null
                          : () => _showSaveFormDialog(context),
                    );
                  },
                ),
              ],
            ),
            body: Row(
              children: [
                const DraggableWidgetDrawer(),
                const Expanded(child: FormCanvas()),
              ],
            ),
          );
        },
      ),
    );
  }
}