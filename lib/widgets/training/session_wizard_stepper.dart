import 'package:flutter/material.dart';

class SessionWizardStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final Function(int)? onStepTapped;

  const SessionWizardStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // Progress bar
          Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              value: (currentStep + 1) / steps.length,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(height: 12),

          // Step indicators
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final isActive = index == currentStep;
                final isCompleted = index < currentStep;
                final isClickable = index <= currentStep;

                return GestureDetector(
                  onTap: isClickable ? () => onStepTapped?.call(index) : null,
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        // Step circle
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? Colors.green
                                : isActive
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade300,
                            border: Border.all(
                              color: isActive
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            isCompleted
                                ? Icons.check
                                : Icons.circle,
                            color: isCompleted || isActive
                                ? Colors.white
                                : Colors.grey.shade600,
                            size: isCompleted ? 20 : 12,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Step label
                        Text(
                          steps[index],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                            color: isActive
                                ? Theme.of(context).primaryColor
                                : isCompleted
                                    ? Colors.green
                                    : Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
