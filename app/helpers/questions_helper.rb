module QuestionsHelper
  def random_order_question(question)
   results = [question.answer,question.incorrect_answer_one,question.incorrect_answer_two, question.incorrect_answer_three, question.incorrect_answer_four]
   results.select!{|r| r unless r.blank?}
   results.sample(results.count)
  end
end
