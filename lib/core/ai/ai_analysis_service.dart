enum AiRiskLevel { routine, caution, urgent }

class AiAnalysisResult {
  const AiAnalysisResult({
    required this.summary,
    required this.recommendation,
    required this.riskLevel,
  });

  final String summary;
  final String recommendation;
  final AiRiskLevel riskLevel;
}

abstract class AiAnalysisService {
  Future<AiAnalysisResult> analyzeHealth(String note, {double? fever});
  Future<AiAnalysisResult> analyzeDailySummary({
    required int feedingCount,
    required int diaperCount,
    required int sleepMinutes,
  });
}

class MockAiAnalysisService implements AiAnalysisService {
  static const disclaimer = 'Bu yorum tıbbi teşhis veya tedavi yerine geçmez.';

  static const _urgentWords = [
    'nefes',
    'morarma',
    'kanlı',
    'havale',
    'nöbet',
    'bilinç',
    'alerjik',
    'sürekli kusma',
  ];

  @override
  Future<AiAnalysisResult> analyzeHealth(String note, {double? fever}) async {
    final lowered = note.toLowerCase();
    final urgent =
        _urgentWords.any(lowered.contains) || (fever != null && fever >= 38.0);
    if (urgent) {
      return const AiAnalysisResult(
        summary: 'Kaydedilen belirti dikkat gerektirebilir.',
        recommendation:
            'Lütfen çocuk doktoru, sağlık uzmanı veya acil destek alın. $disclaimer',
        riskLevel: AiRiskLevel.urgent,
      );
    }
    return const AiAnalysisResult(
      summary: 'Kayıt genel takip için saklandı.',
      recommendation:
          'Belirti devam ederse sağlık uzmanına danışın. $disclaimer',
      riskLevel: AiRiskLevel.routine,
    );
  }

  @override
  Future<AiAnalysisResult> analyzeDailySummary({
    required int feedingCount,
    required int diaperCount,
    required int sleepMinutes,
  }) async {
    if (sleepMinutes < 480) {
      return const AiAnalysisResult(
        summary: 'Uyku süresi bugün daha kısa görünüyor.',
        recommendation: 'Uyku düzenini birkaç gün takip edin. $disclaimer',
        riskLevel: AiRiskLevel.caution,
      );
    }
    return const AiAnalysisResult(
      summary:
          'Bugünkü beslenme, bez ve uyku kayıtları genel takip için düzenli görünüyor.',
      recommendation: disclaimer,
      riskLevel: AiRiskLevel.routine,
    );
  }
}
