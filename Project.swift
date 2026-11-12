import ProjectDescription

let project = Project(
    name: "InterviewTrainer",
    targets: [
        .target(
            name: "InterviewTrainer",
            destinations: .iOS,
            product: .app,
            bundleId: "com.example.interviewtrainer",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["InterviewTrainer/Sources/App/**"],
            resources: ["InterviewTrainer/Resources/**"],
            dependencies: [
                .target(name: "Home")
            ]
        ),
        .target(
            name: "Home",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.example.interviewtrainer.home",
            deploymentTargets: .iOS("17.0"),
            sources: ["InterviewTrainer/Sources/Features/Home/**"],
            dependencies: []
        ),
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
            )
        ]
)
