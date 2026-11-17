
public enum ExamAnswerMapper {

    public static func toDTO(
        from answers: [ExamAnswer]
    ) -> SubmitAnswersRequestDTO {

        let answerDTOs = answers.map { answer in
            AnswerDTO(
                questionId: answer.questionId,
                selectedOptionId: answer.selectedOptionId
            )
        }

        return SubmitAnswersRequestDTO(
            answers: answerDTOs
        )
    }
}