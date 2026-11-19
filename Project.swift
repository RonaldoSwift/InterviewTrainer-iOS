
import ProjectDescription

let project = Project(
    name: "InterviewTrainer",
    targets: [
        // MARK: - App
        .target(
            name: "InterviewTrainer",
            destinations: .iOS,
            product: .app,
            bundleId: "com.example.interviewtrainer",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDevelopmentRegion": "es",
                "CFBundleLocalizations": ["es", "en"]
            ]),
            sources: ["InterviewTrainer/Sources/App/**"],
            resources: ["InterviewTrainer/Resources/**"],
            dependencies: [
                .target(name: "Home"),
                .target(name: "Practice")
            ]
        ),

        // MARK: - Home Framework
        .target(
            name: "Home",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.example.interviewtrainer.home",
            deploymentTargets: .iOS("17.0"),
            sources: ["InterviewTrainer/Sources/Features/Home/**"],
            resources: ["InterviewTrainer/Sources/Features/Home/Resources/**"],
            dependencies: []
        ),

        // MARK: - Home Tests
        .target(
            name: "HomeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.example.interviewtrainer.hometests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["HomeTests/Tests/**"],
            dependencies: [
                .target(name: "Home")
            ]
        ),

        // MARK: - Practice Framework
        .target(
            name: "Practice",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.example.interviewtrainer.practice",
            deploymentTargets: .iOS("17.0"),
            sources: ["InterviewTrainer/Sources/Features/Practice/**"],
            resources: ["InterviewTrainer/Sources/Features/Practice/Resources/**"],
            dependencies: []
        ),

        // MARK: - Practice Tests
        .target(
            name: "PracticeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.example.interviewtrainer.practicetests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["PracticeTests/Tests/**"],
            dependencies: [
                .target(name: "Practice")
            ]
        ),

        // MARK: - App Tests
        .target(
            name: "InterviewTrainerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.example.interviewtrainer.tests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["InterviewTrainerTests/Tests/**"],
            dependencies: [
                .target(name: "InterviewTrainer")
            ]
        )
    ],

    // MARK: - Schemes
    schemes: [
        .scheme(
            name: "Home-Tests",
            buildAction: .buildAction(
                targets: [
                    .target("Home")
                ]
            ),
            testAction: .targets([
                .testableTarget(
                    target: .target("HomeTests")
                )
            ])
        ),

        .scheme(
            name: "Practice-Tests",
            buildAction: .buildAction(
                targets: [
                    .target("Practice")
                ]
            ),
            testAction: .targets([
                .testableTarget(
                    target: .target("PracticeTests")
                )
            ])
        )
    ]
)
