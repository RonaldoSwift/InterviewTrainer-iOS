import Foundation

public enum PracticeLocalization {

    public static var configurationTitle: String { localized("practice.configuration_title") }
    public static var topic: String { localized("practice.topic") }
    public static var difficulty: String { localized("practice.difficulty") }
    public static var language: String { localized("practice.language") }
    public static var startExam: String { localized("practice.start_exam") }
    public static var startExamHint: String { localized("practice.start_exam_hint") }
    public static var sessionTitle: String { localized("practice.session_title") }
    public static var correctFeedback: String { localized("practice.correct_feedback") }
    public static var incorrectFeedback: String { localized("practice.incorrect_feedback") }
    public static var viewResults: String { localized("practice.view_results") }
    public static var nextQuestion: String { localized("practice.next_question") }
    public static var nextQuestionHint: String { localized("practice.next_question_hint") }
    public static var answer: String { localized("practice.answer") }
    public static var answerHint: String { localized("practice.answer_hint") }
    public static var selectAnswerHint: String { localized("practice.select_answer_hint") }
    public static var selectorHint: String { localized("practice.selector_hint") }
    public static var completedAccessibility: String { localized("practice.completed_accessibility") }
    public static var completedTitle: String { localized("practice.completed_title") }
    public static var correct: String { localized("practice.correct") }
    public static var incorrect: String { localized("practice.incorrect") }
    public static var backHome: String { localized("practice.back_home") }
    public static var noQuestions: String { localized("practice.no_questions") }
    public static var noQuestionsMessage: String { localized("practice.no_questions_message") }
    public static var retryFeedback: String { localized("practice.retry_feedback") }
    public static var feedbackError: String { localized("practice.feedback_error") }
    public static var correctOption: String { localized("practice.correct_option") }
    public static var incorrectSelectedOption: String { localized("practice.incorrect_selected_option") }
    public static var selectedOption: String { localized("practice.selected_option") }

    public static func formatted(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: localized(key), locale: Locale(identifier: "es_ES"), arguments: arguments)
    }

    public static func topicLabel(_ topic: ExamTopic) -> String {
        localized("practice.topic.\(topic.rawValue)")
    }

    public static func difficultyLabel(_ difficulty: ExamDifficulty) -> String {
        localized("practice.difficulty.\(difficulty.rawValue)")
    }

    public static func languageLabel(_ language: ExamLanguage) -> String {
        localized("practice.language.\(language.rawValue)")
    }

    private static func localized(_ key: String) -> String {
        let bundle = Bundle(for: PracticeLocalizationBundleToken.self)
        guard let stringsURL = bundle.url(
            forResource: "Localizable",
            withExtension: "strings",
            subdirectory: "es.lproj"
        ),
              let strings = NSDictionary(contentsOf: stringsURL),
              let value = strings[key] as? String else {
            return key
        }

        return value
    }
}

private final class PracticeLocalizationBundleToken: NSObject {}
