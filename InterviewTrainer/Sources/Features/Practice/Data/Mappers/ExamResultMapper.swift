

public enum ExamResultMapper {

    public static func toDomain(
        from dto: ExamResultResponseDTO
    ) -> ExamResult {

        let results = dto.results.map { resultDTO in
            QuestionResult(
                questionId: resultDTO.questionId,
                selectedOptionId: resultDTO.selectedOptionId,
                correctOptionId: resultDTO.correctOptionId,
                isCorrect: resultDTO.isCorrect,
                explanation: resultDTO.explanation,
                codeExample: resultDTO.codeExample
            )
        }

        return ExamResult(
            examId: dto.examId,
            score: dto.score,
            correctAnswers: dto.correctAnswers,
            incorrectAnswers: dto.incorrectAnswers,
            totalQuestions: dto.totalQuestions,
            results: results
        )
    }
}