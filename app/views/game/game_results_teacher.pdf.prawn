pdf = Prawn::Document.new
pdf.font "Helvetica", style: :bold_italic do
  pdf.move_down 5
  pdf.text "Resultado de la trivia: \"#{@game.trivia.title}\"", size: 18
  pdf.stroke_horizontal_rule

  pdf.move_down 20
  pdf.text "#{@game.user.try(&:name)}", align: :center, size: 14

  pdf.move_down 5
  pdf.text "Puntaje: #{ @game.score }", align: :center, size: 14
end

pdf.move_down 20
unless @game_answers.empty?
  game_answers = [["<b>Pregunta</b>", "<b>Respuesta</b>", "<b>Es correcta</b>", "<b>Respuesta Correcta</b>","<b>Puntaje</b>"]]
  game_answers += @game_answers.map do |answer|
    [
      answer.question.description,
      answer.answer,
      I18n.t("dictionary.#{answer.was_correct}"),
      answer.was_correct ? nil : answer.question.answer,
      answer.was_correct ? Game::POINTS[answer.question.dificulty] : 0
    ]
  end

  table_options = {
    cell_style:{
      border_color: "0d747c",
      border_width: 0.1,
      padding: 7,
      inline_format: true,
      size: 10
    },
    header: true,
    position: :center,
    row_colors: ["0F7F88", "FFFFFF"],
    width: 550
  }
  pdf.table game_answers, table_options
end
pdf.render
