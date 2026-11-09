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
            sources: ["InterviewTrainer/Sources/**"],
            resources: ["InterviewTrainer/Resources/**"],
            dependencies: []
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
    ]
)
