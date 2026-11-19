import Foundation

public enum HomeLocalization {

    public static var title: String { localized("home.title") }
    public static var subtitle: String { localized("home.subtitle") }
    public static var startPractice: String { localized("home.start_practice") }
    public static var startPracticeHint: String { localized("home.start_practice_hint") }

    private static func localized(_ key: String) -> String {
        let bundle = Bundle(for: HomeLocalizationBundleToken.self)
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

private final class HomeLocalizationBundleToken: NSObject {}
