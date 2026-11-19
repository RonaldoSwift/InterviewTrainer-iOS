import Foundation

enum AppLocalization {

    static var preparingPractice: String { localized("app.preparing_practice") }
    static var preparationErrorTitle: String { localized("app.preparation_error_title") }
    static var preparationErrorMessage: String { localized("app.preparation_error_message") }
    static var backToConfiguration: String { localized("app.back_to_configuration") }

    private static func localized(_ key: String) -> String {
        guard let stringsURL = Bundle.main.url(
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
