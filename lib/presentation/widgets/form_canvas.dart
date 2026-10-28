import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/bloc/form_builder/form_builder_bloc.dart';
import '../../../logic/bloc/form_builder/form_builder_event.dart';
import '../../../logic/bloc/form_builder/form_builder_state.dart';
import '../../../data/models/form_widget_model.dart';
import '../../../core/utils/widget_id_generator.dart';

class FormCanvas extends StatefulWidget {
  const FormCanvas({super.key});

  @override
  State<FormCanvas> createState() => _FormCanvasState();
}

class _FormCanvasState extends State<FormCanvas> {
  final ScrollController _scrollController = ScrollController();
  int _lastItemCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DragTarget<Map<String, dynamic>>(
        onWillAccept: (data) => data != null && data.containsKey('type'),
        onAccept: (template) {
          final model = FormWidgetModel(
            id: WidgetIdGenerator.generate(),
            type: template['type'] as String,
            label: template['label'] as String? ?? 'Untitled',
            meta: Map<String, dynamic>.from(template['meta'] ?? {}),
          );
          context.read<FormBuilderBloc>().add(AddWidgetEvent(model));
        },
        builder: (context, candidateData, rejectedData) {
          return SafeArea(
            child: Container(
              color: Colors.grey[100],
              child: BlocConsumer<FormBuilderBloc, FormBuilderState>(
                // Use BlocConsumer to listen for state changes and trigger scroll
                listener: (context, state) {
                  if (state.widgets.length > _lastItemCount) {
                    _scrollToBottom();
                  }
                  _lastItemCount = state.widgets.length;
                },
                builder: (context, state) {
                  if (state.widgets.isEmpty) {
                    return const Center(
                      child: Text(
                        'Drag widgets here',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ReorderableListView.builder(
                    scrollController: _scrollController,
                    itemCount: state.widgets.length,
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex--;
                      context.read<FormBuilderBloc>().add(MoveWidgetEvent(oldIndex, newIndex));
                    },
                    itemBuilder: (context, index) {
                      final widgetModel = state.widgets[index];
                      return _WidgetTile(
                          key: ValueKey(widgetModel.id),
                          model: widgetModel
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WidgetTile extends StatefulWidget {
  final FormWidgetModel model;
  const _WidgetTile({super.key , required this.model});

  @override
  State<_WidgetTile> createState() => _WidgetTileState();
}

class _WidgetTileState extends State<_WidgetTile> {
  late final TextEditingController _labelController;

  @override
  void initState() {
    super.initState();
    //To show label of the widget till start
    _labelController = TextEditingController(text: widget.model.label);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the tree.
    _labelController.dispose();
    super.dispose();
  }

  // This is the build logic
  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(widget.model.id),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label Input - Takes most space
                  TextField(
                    controller: _labelController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Field Label',
                      labelStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      isDense: true,
                    ),
                    onChanged: (val) {
                      final updated = widget.model.copyWith(label: val);
                      context
                          .read<FormBuilderBloc>()
                          .add(UpdateWidgetEvent(widget.model.id, updated));
                    },
                  ),

                  const SizedBox(height: 16),

                  // Required Toggle - Compact design
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: widget.model.meta['required'] == true
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.model.meta['required'] == true
                            ? Colors.red.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Required',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: widget.model.meta['required'] == true
                                ? Colors.red[700]
                                : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: double.minPositive),
                        Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: widget.model.meta['required'] == true,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            activeColor: Colors.red,
                            onChanged: (value) {
                              final updated = widget.model.copyWith(
                                meta: {
                                  ...widget.model.meta,
                                  'required': value,
                                },
                              );
                              context
                                  .read<FormBuilderBloc>()
                                  .add(UpdateWidgetEvent(widget.model.id, updated));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
            // More Options Menu
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey[600],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onSelected: (value) {
                if (value == 'options') {
                  _showOptionsDialog(widget.model, context);
                }
              },
              itemBuilder: (context) => [
                if (_hasOptions(widget.model))
                  const PopupMenuItem<String>(
                    value: 'options',
                    child: Row(
                      children: [
                        Icon(Icons.tune, size: 20, color: Colors.blue),
                        SizedBox(width: 12),
                        Text(
                          "Configure",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                PopupMenuItem<String>(
                  value: 'Delete',
                  onTap: () {
                    context
                        .read<FormBuilderBloc>()
                        .add(RemoveWidgetEvent(widget.model.id));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text(
                        "Delete",
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  /// Checks if a given widget model type should have configurable options.
  bool _hasOptions(FormWidgetModel model) {
    return ['dropdown', 'radio', 'checkbox', 'matrix', 'date_picker', 'address'].contains(model.type);
  }



  ///Showing bottomsheet for editing options
  void _showOptionsDialog(FormWidgetModel model, BuildContext parentContext) {
    final formBuilderBloc = parentContext.read<FormBuilderBloc>();

    //for date format selection
    final isDatePicker = model.type == 'date_picker';
    final currentFormat = model.meta['dateFormat'] ?? 'dd/MM/yyyy';

    //for address
    final isAddress = model.type == 'address';
    final List<String> laneName = List<String>.from(model.meta['lane'] ?? ["Address Lane"]);
    final List<String> addressOptions = ['Country','State', 'City', 'Pincode', 'Block', 'District'];

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
              child: StatefulBuilder(
                builder: (stfContext, setSheetState) {
                  // We use BlocBuilder to ensure the dialog stays in sync with the actual state
                  return BlocBuilder<FormBuilderBloc, FormBuilderState>(
                    bloc: formBuilderBloc,
                    builder: (context, state) {
                      // Find the current version of the model from the state
                      final currentModel = state.widgets.firstWhere((w) => w.id == model.id, orElse: () => model);

                      final isMatrix = currentModel.type == 'matrix';
                      final List<String> currentRows = List<String>.from(currentModel.meta['rows'] as List? ?? ['Row 1']);
                      final List<String> currentColumns = List<String>.from(currentModel.meta['columns'] as List? ?? ['Col 1', 'Col 2']);
                      final List<String> currentOptions = List<String>.from(currentModel.meta['options'] as List? ?? []);

                      // Local helper for real-time updates
                      void updateMeta(String key, dynamic newList) {
                        final newMeta = Map<String, dynamic>.from(currentModel.meta);
                        newMeta[key] = newList;
                        formBuilderBloc.add(UpdateWidgetEvent(currentModel.id, currentModel.copyWith(meta: newMeta)));
                      }

                      Widget buildEditableList(String title, List<String> list, String metaKey) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(width: 4, height: 20, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(2))),
                                      const SizedBox(width: 8),
                                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    ],
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      final newList = [...list, '$title ${list.length + 1}'];
                                      updateMeta(metaKey, newList);
                                    },
                                    icon: const Icon(Icons.add, size: 18),
                                    label: Text("Add $title"),
                                  )
                                ],
                              ),
                            ),
                            ...list.asMap().entries.map((entry) {
                              int idx = entry.key;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: entry.value,
                                        key: ValueKey('${currentModel.id}_${metaKey}_$idx'), // Ensure focus is kept correctly
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        ),
                                        onChanged: (val) {
                                          final newList = [...list];
                                          newList[idx] = val;
                                          updateMeta(metaKey, newList);
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      onPressed: list.length > 1 ? () {
                                        final newList = [...list]..removeAt(idx);
                                        updateMeta(metaKey, newList);
                                      } : null,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        );
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isDatePicker) ...[
                                      Row(
                                        children: [
                                          Container(
                                            width: 4,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Date Display Format",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      DropdownButtonFormField<String>(
                                        value: currentFormat,
                                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.grey[300]!),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.grey[300]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.blue, width: 2),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                        ),
                                        items: [
                                          'dd/MM/yyyy',
                                          'MM/dd/yyyy',
                                          'yyyy-MM-dd',
                                        ].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                                        onChanged: (newFormat) {
                                          if (newFormat != null) {
                                            setSheetState(() {});

                                            final newMeta = Map<String, dynamic>.from(model.meta)
                                              ..['dateFormat'] = newFormat;

                                            formBuilderBloc.add(
                                              UpdateWidgetEvent(
                                                model.id,
                                                model.copyWith(meta: newMeta),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ] else if (isMatrix) ...[
                                      Row(
                                        children: [
                                          Container(
                                            width: 4,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Matrix Cell Type",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      DropdownButtonFormField<String>(
                                        value: model.meta['cellType'] ?? 'Text',
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        items: ['Text', 'Radio', 'Checkbox', 'Dropdown']
                                            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                                            .toList(),
                                        onChanged: (val) {

                                          updateMeta('cellType', val);
                                        },
                                      ),
                                      buildEditableList("Rows", currentRows, "rows"),
                                      buildEditableList("Columns", currentColumns, "columns"),
                                    ] else if (isAddress) ...[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 4,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                "Address Lane",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 8),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                                            child: TextFormField(
                                              key: ValueKey('${currentModel.id}_lane_0_${laneName[0]}'),
                                              initialValue: laneName[0],
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[50],
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                              ),
                                              onChanged: (val) {
                                                final newLanes = List<String>.from(laneName);
                                                newLanes[0] = val;
                                                updateMeta('lane', newLanes);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      const Divider(),
                                      const Text("Select Additional Fields", style: TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: addressOptions.map((field) {
                                          final List<String> enabled = List<String>.from(currentModel.meta['address_fields'] ?? []);
                                          final isSelected = enabled.contains(field);
                                          return FilterChip(
                                            padding: EdgeInsets.all(8),
                                            label: Text(field),
                                            selected: isSelected,
                                            onSelected: (val) {
                                              final newList = [...enabled];
                                              if (val) newList.add(field);
                                              else newList.remove(field);
                                              updateMeta('address_fields', newList);
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ] else ...[
                                      buildEditableList("Options", currentOptions, "options"),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 52),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(sheetContext),
                                child: const Text("Done"),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}