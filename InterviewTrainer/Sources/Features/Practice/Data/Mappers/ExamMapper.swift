
public enum ExamMapper {

    public static func toDomain(
        from dto: ExamResponseDTO
    ) -> Exam {

        let questions = dto.questions.map { questionDTO in
            Question(
                questionId: questionDTO.questionId,
                statement: questionDTO.statement,
                codeSnippet: questionDTO.codeSnippet,
                options: questionDTO.options.map { optionDTO in
                    AnswerOption(
                        optionId: optionDTO.optionId,
                        text: optionDTO.text
                    )
                }
            )
        }

        return Exam(
            examId: dto.examId,
            topic: dto.topic,
            difficulty: dto.difficulty,
            language: dto.language,
            questions: questions
        )
    }
}