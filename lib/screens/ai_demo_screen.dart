import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple AI Demo Screen - Phase 1 Implementation
/// Shows the potential of AI features without complex dependencies
class AIDemoScreen extends ConsumerStatefulWidget {
  const AIDemoScreen({super.key});

  @override
  ConsumerState<AIDemoScreen> createState() => _AIDemoScreenState();
}

class _AIDemoScreenState extends ConsumerState<AIDemoScreen> {
  bool _isGenerating = false;
  String? _generatedContent;
  final _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant Demo'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, 
                             color: Colors.purple.shade700, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI-Powered Training Assistant',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Roadmap 2025 - Phase 1 Preview',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.purple.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Deze demo toont de toekomstige AI-mogelijkheden van de JO17 Tactical Manager. '
                      'In de volledige implementatie zal AI helpen bij het genereren van trainingen, '
                      'tactische analyses en spelersbeoordelingen.',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Features Overview
            Text(
              'Geplande AI Features (2025)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.fitness_center,
              title: 'AI Training Generator',
              description: 'Automatische generatie van trainingen op basis van spelersstatistieken, '
                          'weersverwachtingen en komende wedstrijden.',
              status: 'Ontwikkeling Q3 2025',
              color: Colors.blue,
            ),
            
            const SizedBox(height: 12),
            
            _buildFeatureCard(
              icon: Icons.psychology,
              title: 'Tactische AI Assistent',
              description: 'Real-time tactische suggesties, formatie-optimalisatie en '
                          'spelerswissel adviezen tijdens wedstrijden.',
              status: 'Ontwikkeling Q3 2025',
              color: Colors.green,
            ),
            
            const SizedBox(height: 12),
            
            _buildFeatureCard(
              icon: Icons.mic,
              title: 'Voice Commands',
              description: 'Spraakgestuurde bediening voor snelle acties tijdens trainingen '
                          'en wedstrijden.',
              status: 'Prototype Q4 2025',
              color: Colors.orange,
            ),
            
            const SizedBox(height: 12),
            
            _buildFeatureCard(
              icon: Icons.analytics,
              title: 'Speler Performance AI',
              description: 'Geautomatiseerde analyse van spelersprestaties met '
                          'gepersonaliseerde verbeteringsuggesties.',
              status: 'Planning Q4 2025',
              color: Colors.red,
            ),
            
            const SizedBox(height: 24),
            
            // Demo Section
            Text(
              'Interactive Demo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Prompt Simulator',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: _promptController,
                      decoration: const InputDecoration(
                        labelText: 'Vraag aan de AI',
                        hintText: 'Bijvoorbeeld: "Maak een verdedigende training voor JO17"',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.chat),
                      ),
                      maxLines: 3,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isGenerating ? null : _generateDemoResponse,
                        icon: _isGenerating 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.auto_awesome),
                        label: Text(_isGenerating ? 'Genereren...' : 'Genereer AI Response'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    
                    if (_generatedContent != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.smart_toy, color: Colors.purple.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  'AI Response',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(_generatedContent!),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Technical Specs
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Technische Specificaties',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTechSpec('AI Model', 'Google Gemini 1.5 Flash'),
                    _buildTechSpec('Framework', 'Flutter 3.32 + Dart 3.8'),
                    _buildTechSpec('State Management', 'Riverpod 2.6'),
                    _buildTechSpec('Backend', 'Supabase + Microservices'),
                    _buildTechSpec('Deployment', 'Progressive Web App'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required String status,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechSpec(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _generateDemoResponse() async {
    if (_promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voer eerst een vraag in')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _generatedContent = null;
    });

    // Simulate AI processing
    await Future.delayed(const Duration(seconds: 2));

    final prompt = _promptController.text.toLowerCase();
    String response;

    if (prompt.contains('training') || prompt.contains('oefening')) {
      response = '''🏃‍♂️ AI-gegenereerde Training: "Verdedigende Organisatie"

⏱️ Duur: 90 minuten
🎯 Focus: Verdediging, Pressing, Compactheid

📋 Opwarming (15 min):
• Lichte looppas met bal
• Dynamische rekoefeningen
• Korte passing in paren

🛡️ Hoofddeel (60 min):
• 4v2 pressing oefening (20 min)
• Verdedigende lijnvorming (20 min)
• 8v8 op half veld met verdedigende focus (20 min)

❄️ Cooling-down (15 min):
• Lichte stretching
• Reflectie op verdedigende principes

💡 Coach Tips: Focus op communicatie en tijdig druk zetten!''';
    } else if (prompt.contains('tactiek') || prompt.contains('formatie')) {
      response = '''⚽ Tactische Analyse: 4-3-3 Formatie

📊 Aanbevolen opstelling tegen aanvallende tegenstander:

🥅 Keeper: Actief in opbouw
🛡️ Verdediging: Hoge linie, pressing
⚙️ Middenveld: Driehoeksvorming, balcontrole  
⚡ Aanval: Breedte en diepte

🎯 Sterke punten:
• Goede balans tussen verdediging en aanval
• Flexibiliteit in omschakeling
• Pressing mogelijkheden

⚠️ Aandachtspunten:
• Communicatie tussen linies
• Dekking bij corners
• Snelle omschakeling

🔄 In-game aanpassingen:
• Bij achterstand: 4-2-4
• Bij voorsprong: 5-3-2''';
    } else if (prompt.contains('speler') || prompt.contains('prestatie')) {
      response = '''📈 Speler Performance Analyse

🎯 Gebaseerd op recente wedstrijddata:

💪 Sterke punten:
• Technische vaardigheden: 8.5/10
• Fysieke conditie: 7.8/10  
• Tactisch inzicht: 8.2/10

🔧 Verbeterpunten:
• Kopspel: Meer oefening nodig
• Zwakke voet: 15% meer gebruik
• Communicatie: Meer vocal leadership

📋 Training aanbevelingen:
• 2x per week kopbaltraining
• Dagelijks 20 min zwakke voet
• Leadership workshops

⏰ Verwachte verbetering: 6-8 weken''';
    } else {
      response = '''🤖 AI Assistent Response:

Bedankt voor je vraag! In de volledige versie kan ik helpen met:

• Trainingen genereren op basis van je specifieke behoeften
• Tactische analyses en formatie-adviezen  
• Speler prestatie evaluaties
• Wedstrijd voorbereiding
• Voice commands verwerken

💡 Tip: Probeer specifiekere vragen zoals:
"Maak een technische training voor JO17"
"Analyseer onze verdediging"
"Welke formatie tegen aanvallende tegenstander?"

De volledige AI implementatie komt beschikbaar in Q3 2025!''';
    }

    setState(() {
      _isGenerating = false;
      _generatedContent = response;
    });

    _promptController.clear();
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Assistant Info'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Dit is een preview van de AI-functionaliteiten die in 2025 beschikbaar komen.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('Roadmap Timeline:'),
              SizedBox(height: 8),
              Text('• Q3 2025: AI Training Generator'),
              Text('• Q3 2025: Tactische AI Assistent'),
              Text('• Q4 2025: Voice Commands'),
              Text('• Q4 2025: Performance Analysis'),
              SizedBox(height: 16),
              Text('Deze demo toont gesimuleerde AI responses. '
                   'De echte implementatie zal gebruik maken van '
                   'Google Gemini AI en machine learning modellen.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Begrepen'),
          ),
        ],
      ),
    );
  }
}
