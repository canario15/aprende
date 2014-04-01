module GameHelper

  def show_question(show_answer)
    show_answer ? "invisible" : ""
  end

  def alert_succes_or_warning(was_correct)
    was_correct ? "alert-success" : "alert-warning"
  end
end
