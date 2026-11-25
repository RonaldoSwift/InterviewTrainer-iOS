import ProjectDescription

let project = Project(
    name: "InterviewTrainer",
    organizationName: "RonaldoSwift",
    targets: [
        .target(
            name: "InterviewTrainer",
            destinations: .iOS,
            product: .app,
            bundleId: "com.ronaldoswift.interviewtrainer",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(with: [
                "NSAppTransportSecurity": .dictionary([
                    "NSAllowsLocalNetworking": .boolean(true),
                ]),
                "NSLocalNetworkUsageDescription": .string(
                    "InterviewTrainer se conecta al backend de desarrollo en la red local."
                ),
            ]),
            sources: ["InterviewTrainer/Sources/**"],
            dependencies: [
                .target(name: "Home"),
                .target(name: "Practice"),
            ]
        ),
        .target(
            name: "Home",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ronaldoswift.interviewtrainer.home",
            deploymentTargets: .iOS("15.0"),
            sources: ["Home/Sources/**"],
            dependencies: []
        ),
        .target(
            name: "HomeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ronaldoswift.interviewtrainer.hometests",
            deploymentTargets: .iOS("15.0"),
            sources: ["Home/Tests/**"],
            dependencies: [
                .target(name: "Home"),
            ]
        ),
        .target(
            name: "Practice",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.ronaldoswift.interviewtrainer.practice",
            deploymentTargets: .iOS("15.0"),
            sources: ["Practice/Sources/**"],
            dependencies: []
        ),
        .target(
            name: "PracticeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ronaldoswift.interviewtrainer.practicetests",
            deploymentTargets: .iOS("15.0"),
            sources: ["Practice/Tests/**"],
            dependencies: [
                .target(name: "Practice"),
            ]
        ),
        .target(
            name: "InterviewTrainerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.ronaldoswift.interviewtrainer.tests",
            deploymentTargets: .iOS("15.0"),
            sources: ["InterviewTrainerTests/Sources/**"],
            dependencies: [
                .target(name: "InterviewTrainer"),
            ]
        ),
    ]
)
