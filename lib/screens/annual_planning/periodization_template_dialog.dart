import 'package:flutter/material.dart';
import '../../models/annual_planning/periodization_plan.dart';

class PeriodizationTemplateDialog extends StatefulWidget {
  const PeriodizationTemplateDialog({
    super.key,
    this.currentTemplate,
  });
  final PeriodizationPlan? currentTemplate;

  @override
  State<PeriodizationTemplateDialog> createState() =>
      _PeriodizationTemplateDialogState();
}

class _PeriodizationTemplateDialogState
    extends State<PeriodizationTemplateDialog> {
  PeriodizationPlan? selectedTemplate;

  final List<PeriodizationPlan> availableTemplates = [
    PeriodizationPlan.knvbYouthU17(),
    PeriodizationPlan.traditionalLinear(),
    PeriodizationPlan.blockPeriodization(),
    PeriodizationPlan.conjugateMethod(),
  ];

  @override
  void initState() {
    super.initState();
    selectedTemplate = widget.currentTemplate;
  }

  @override
  Widget build(BuildContext context) => Dialog(
        child: Container(
          width: 600,
          height: 700,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.timeline, size: 28, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Text(
                    'Periodiseringstemplate Selecteren',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Kies een periodiseringstemplate om je seizoensplanning automatisch in te richten.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Current selection
              if (selectedTemplate != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Geselecteerd: ${selectedTemplate!.name}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${selectedTemplate!.totalDurationWeeks} weken • ${selectedTemplate!.numberOfPeriods} periodes',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (selectedTemplate != null) const SizedBox(height: 16),

              // Template options
              Expanded(
                child: ListView.builder(
                  itemCount: availableTemplates.length,
                  itemBuilder: (context, index) {
                    final template = availableTemplates[index];
                    final isSelected = selectedTemplate?.name == template.name;

                    return Card(
                      elevation: isSelected ? 4 : 1,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedTemplate = template;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Radio<PeriodizationPlan>(
                                    value: template,
                                    groupValue: selectedTemplate,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedTemplate = value;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          template.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          template.description,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Template details
                              Row(
                                children: [
                                  _buildDetailChip(
                                    Icons.schedule,
                                    '${template.totalDurationWeeks} weken',
                                  ),
                                  const SizedBox(width: 8),
                                  _buildDetailChip(
                                    Icons.timeline,
                                    '${template.numberOfPeriods} periodes',
                                  ),
                                  const SizedBox(width: 8),
                                  _buildDetailChip(
                                    Icons.group,
                                    'JO17',
                                  ),
                                ],
                              ),

                              // Show periods preview
                              if (isSelected) ...[
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 8),
                                Text(
                                  'Periode overzicht:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ..._buildPeriodPreview(template),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Action buttons
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Annuleren'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: selectedTemplate != null
                        ? () => Navigator.of(context).pop(selectedTemplate)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Template Toepassen'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildDetailChip(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );

  List<Widget> _buildPeriodPreview(PeriodizationPlan template) {
    final params = PeriodizationPlan.getRecommendedParameters(
      template.modelType,
      template.targetAgeGroup,
    );
    final focusAreas = params['focusAreas'] as List<String>;
    final intensityProgression = params['intensityProgression'] as List<int>;

    final weeksPerPeriod =
        template.totalDurationWeeks ~/ template.numberOfPeriods;

    return List.generate(template.numberOfPeriods, (index) {
      final intensity =
          intensityProgression[index % intensityProgression.length];

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _getPeriodColor(index),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Periode ${index + 1}: ${focusAreas[index % focusAreas.length]}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '$weeksPerPeriod weken • $intensity% intensiteit',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Color _getPeriodColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}
