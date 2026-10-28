import 'package:disha_form/presentation/widgets/normal_widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../service/api_service.dart';
import 'form_builder_screen.dart';
import 'form_filling_screen.dart';

class MyFormsScreen extends StatefulWidget {

  final String userId;

  const MyFormsScreen({super.key, required this.userId});

  @override
  State<MyFormsScreen> createState() => _MyFormsScreenState();
}

class _MyFormsScreenState extends State<MyFormsScreen> {

  List<dynamic> _data = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadAllForms();
    _fetchData();
  }

  Future<void> loadAllForms() async {
    final allForms = await ApiService.getAllForms(widget.userId);

    if (allForms != null) {
      print("Total forms fetched: ${allForms.length}");

      for (var form in allForms) {
        print("Form Name: ${form["form_name"]}");
        print("Fields: ${form["form"]}");
      }
    }
  }


  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      //final fetchedData = await ApiService.fetchData();
      final allForms = await ApiService.getAllForms(widget.userId);
      setState(() {
        //_data = fetchedData;
        _data = allForms ?? [];
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => _data = []);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _fetchData();
  }

  Widget _buildFormItem(dynamic form) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade400, Colors.indigo.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormFillingScreen(
                  formId: form['id'].toString(),
                  formName: form['form_name'],
                  formFields: form['form'],
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon container with pulse animation
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.description_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(width: 16),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        form['form_name'] ?? 'No Name',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tap to fill form',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow icon with subtle background
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "All Form",
        centerTitle: false,
        actions: [
          IconButton(
              icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
              tooltip: 'Create new form',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormBuilderScreen(),
                  ),
                );
              }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.refresh),
        onPressed: _refreshData,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.indigo))
          : SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: Colors.indigo,
          child: _data.isEmpty
              ? ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Center(
                child: Text(
                  "No forms found",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          )
              : ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: _data.length,
            itemBuilder: (context, index) {
              final form = _data[index];
              return _buildFormItem(form);
            },
          ),
        ),
      ),
    );
  }

}

