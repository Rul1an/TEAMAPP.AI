import 'package:flutter/material.dart';

typedef WizardStepBuilder = Widget Function(BuildContext context);

class SessionBuilderWizard extends StatefulWidget {
  const SessionBuilderWizard({
    super.key,
    required this.stepTitles,
    required this.stepBuilders,
    required this.onFinished,
  })  : assert(stepTitles.length == stepBuilders.length,
            'Titles and builders must have equal length');

  final List<String> stepTitles;
  final List<WizardStepBuilder> stepBuilders;
  final VoidCallback onFinished;

  @override
  State<SessionBuilderWizard> createState() => _SessionBuilderWizardState();
}

class _SessionBuilderWizardState extends State<SessionBuilderWizard> {
  int _currentStep = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    if (_currentStep < widget.stepBuilders.length - 1) {
      _goToStep(_currentStep + 1);
    } else {
      widget.onFinished();
    }
  }

  void _previous() {
    if (_currentStep > 0) _goToStep(_currentStep - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _WizardStepper(
          titles: widget.stepTitles,
          currentStep: _currentStep,
          onStepTapped: _goToStep,
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentStep = page),
            children: widget.stepBuilders
                .map((builder) => builder(context))
                .toList(growable: false),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              if (_currentStep > 0)
                TextButton(onPressed: _previous, child: const Text('Vorige')),
              const Spacer(),
              ElevatedButton(
                onPressed: _next,
                child: Text(
                  _currentStep < widget.stepBuilders.length - 1
                      ? 'Volgende'
                      : 'Opslaan',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WizardStepper extends StatelessWidget {
  const _WizardStepper({
    required this.titles,
    required this.currentStep,
    required this.onStepTapped,
  });

  final List<String> titles;
  final int currentStep;
  final ValueChanged<int> onStepTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(titles.length, (index) {
        final active = index == currentStep;
        return GestureDetector(
          onTap: () => onStepTapped(index),
          child: Column(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor:
                    active ? Theme.of(context).primaryColor : Colors.grey,
                child: Text('${index + 1}',
                    style: const TextStyle(fontSize: 12, color: Colors.white)),
              ),
              const SizedBox(height: 4),
              Text(titles[index],
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center),
            ],
          ),
        );
      }),
    );
  }
}
