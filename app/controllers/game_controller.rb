class GameController < ApplicationController
  def new
    @question = new_question
    if @question.nil?
      flash[:notice] = "Ya ha respondido todas las preguntas!! Felicitaiones!!"
      redirect_to action: :finish
    end
  end

  def eval_answer
    question_id = params[:question][:id]
    save_answered_question question_id
    @question = Question.find question_id 

    resp = validate_answer @question, params[:answer]

    if resp
      flash[:notice] = "Ud. ha acertado!! Felicitaciones!"
    else
      flash[:error] = "Respuesta equivocada :(. Siga intentando.."
    end
    redirect_to action: :new
  end

  def reset
  end

  def finish
  end

private
  def validate_answer question, answer 
    if question.answer.downcase == answer.downcase
      true
    else
      false
    end
  end

  def new_question
    question = nil
    count = Question.count
    if count == answereds.count
      return nil
    end
    while !question
      random_id = rand(count) + 1
      question = Question.find_by_id random_id unless answereds.include?(random_id)
    end
    question
  end

  def save_answered_question question_id
    session[:answereds] ||= []
    session[:answereds] << question_id
  end

  def answereds
    session[:answereds]
  end

end
