require 'spec_helper'

describe TriviumController do
  before :all do
    @course = Course.make!
  end

  before :each do
    @teacher = Teacher.make!
    @teacher.confirm!
    sign_in @teacher
  end

  describe "GET 'index'" do
    it "returns http success(code=200)" do
      get 'index'
      expect(response.code).to eq("200")
    end
  end

  describe "GET 'new'" do
    it "returns http success(code=200)" do
      get 'new'
      expect(response.code).to eq("200")
    end
  end

  describe "POST 'create'" do
    before :each do
      @trivia = Trivia.make(:filled)
      @level = Level.make!
    end

    render_views
    it "create a new trivia" do
      get 'new'
      expect(response.code).to eq("200")
    end

    it "returns http success" do
      params = {:trivia => {:title => "New trivia", :course_id => @course.id, :tag => "mathematic", :description => "Trivia the mathematic", :type => 1}}
      expect {post('create', params) }.to change{Trivia.count}.by(1)
    end

    it "invalid trivia without teacher" do
      sign_out @teacher
      params = {trivia_level: @level,:trivia => {:title => "New trivia", :course_id => @course.id, :tag => "mathematic", :description => "Trivia the mathematic", :type => 1}}
      expect {post('create', params) }.to change{Trivia.count}.by(0)
    end

    it "error without title" do
      @trivia.title = nil
      post(:create,trivia_level: @level, trivia: @trivia.attributes)
      expect(assigns[:trivia].errors.full_messages.first).to eq("Title can't be blank")
    end

    it "error without type" do
      @trivia.type = nil
      post(:create,trivia_level: @level ,trivia: @trivia.attributes)
      expect(assigns[:trivia].errors.full_messages.first).to eq("Type can't be blank")
    end

    it "error without course" do
      @trivia.course =  nil
      post(:create,trivia_level: @level ,trivia: @trivia.attributes)
      expect(assigns[:trivia].errors.full_messages.first).to eq("Course can't be blank")
    end

    it "error render new" do
      @trivia.title = nil
      post(:create,trivia_level: @level,trivia: @trivia.attributes)
      expect(response.body).to match("Title can\.*t be blank")
    end

     context "not select contents" do
        let(:contents){ @trivia.contents_init.each{|c|c[:containable_type] = "" } }

        it "redirect to questions" do
          contents_params = {content_attributes:
            Hash[contents.map.with_index do |content,index|
                [index.to_s,Hash[
                    containable_attributes:
                    Hash[ document:
                      content.containable.document
                    ].reverse_merge(content.containable.attributes)
                  ].reverse_merge(content.attributes)
                ]
            end
            ]
          }
          params = contents_params.reverse_merge(@trivia.attributes)
          post(:create, trivia: params)
          expect(response.location).to eq(new_question_trivia_url(assigns[:trivia].id))
        end
      end

    #Content::TYPE =["Pdf",  "Written"]
    Content::TYPE.each do |type|
      context "contents #{type} selected" do
       let(:trivia){ Trivia.make(:filled)}
        let(:contents){
          trivia.contents_init.each{|c|
            c[:containable_type] = "" unless c[:containable_type] == type
          }
        }
        let(:doc) {
          type == "Pdf" ?
            Rack::Test::UploadedFile.new('spec/fixtures/Test.pdf', 'application/pdf')
          :
            eval(type).make.document
        }

        it "valid #{type}"  do
          contents_params = {content_attributes:
            Hash[contents.map.with_index do |content,index|
              content[:containable_type] == type ?
                [index.to_s,Hash[
                    containable_attributes:
                    Hash[ document:
                      content.containable.document = doc
                    ].reverse_merge(content.containable.attributes)
                  ].reverse_merge(content.attributes)
                ]
              :
                [index.to_s,content.attributes]
            end
            ]
          }
          post(:create, trivia_level:  1 , trivia: contents_params.reverse_merge(trivia.attributes))
          expect(response.location).to eq(new_question_trivia_url(assigns[:trivia].id))
        end

        it "not document #{type}" do
          contents_params = {content_attributes:
            Hash[contents.map.with_index do |content,index|
              content[:containable_type] == type ?
                [index.to_s,Hash[
                    containable_attributes:
                    Hash[ document: nil].reverse_merge(content.containable.attributes)
                  ].reverse_merge(Hash["containable_type" => type])
                ]
              :
                [index.to_s,content.attributes]
              end
              ]
            }
          post(:create, trivia_level:  1 , trivia: contents_params.reverse_merge(trivia.attributes))
          expect(response.body).to match "Content containable document can\.*t be blank"
        end

        it "not conteinable #{type}" do
          contents_params = {content_attributes:
            Hash[contents.map.with_index do |content,index|
              content[:containable_type] == type ?
                [index.to_s,Hash["containable_type" => type]]
              :
                [index.to_s,content.attributes]
            end
            ]
          }
          post(:create, trivia_level:  1 , trivia: contents_params.reverse_merge(trivia.attributes))
          expect(response.body).to match "Content containable can\.*t be blank"
        end

      end
    end
  end

  describe "GET 'edit'" do
    before :each do
      @trivia = Trivia.make!
    end

    it "returns http success(code=200)" do
      get 'edit', {:id => @trivia.id}
      expect(response.code).to eq("200")
    end
  end

  describe "POST 'update'" do
    render_views

    before :each do
      @trivia = Trivia.make!
    end

    it "returns http success" do
      params = {:id=> @trivia.id, :trivia => {:title => "update trivia", :course_id => @course.id, :tag => "mathematic", :description => "Trivia the mathematic"}}
      post 'update', params
      expect(response).to redirect_to(new_question_trivia_url(@trivia.id))
    end

    it "error without title" do
      @trivia.title = nil
      post(:update,id: @trivia.id, trivia_level: @trivia.course.level, trivia: @trivia.attributes)
      expect(assigns[:trivia].errors.full_messages.first).to eq("Title can't be blank")
    end

    it "error without type" do
      @trivia.type = nil
      post(:update, id: @trivia.id, trivia_level: @trivia.course.level, trivia: @trivia.attributes)
      expect(assigns[:trivia].errors.full_messages.first).to eq("Type can't be blank")
    end

    it "error without course" do
      level = @trivia.course.level
      @trivia.course = nil
      post(:update, id: @trivia.id, trivia_level: level, trivia: @trivia.attributes)
      expect(assigns[:trivia].errors.full_messages.first).to eq("Course can't be blank")
    end

    it "error render new" do
      @trivia.title = nil
      post(:update,id: @trivia.id, trivia_level: @trivia.course.level, trivia: @trivia.attributes)
      expect(response.body).to match("Title can\.*t be blank")
    end

    #Content::TYPE =["Pdf",  "Written"]
    Content::TYPE.each do |type|
      context "contents #{type} redirect to questions"  do
        let(:trivia){ Trivia.make!(content: Content.make!(containable: eval(type).make!))}
        let(:contents){ trivia.contents_init }

        it "not select" do
          contents_params = {content_attributes:
            Hash[contents.map.with_index do |content,index|
                if content[:containable_type] == type
                  [index.to_s,Hash[
                      containable_attributes:
                      Hash[ document:
                        content.containable.document
                      ].reverse_merge(content.containable.attributes)
                    ].reverse_merge(Hash["containable_type" => ""])
                  ]
                else
                  doc = content.containable_type == "Pdf" ?
                    Rack::Test::UploadedFile.new('spec/fixtures/Test.pdf', 'application/pdf')
                  :
                    eval(content.containable_type).make.document
                 [index.to_s,Hash[
                      containable_attributes:
                      Hash[ document:
                        content.containable.document = doc
                      ].reverse_merge(content.containable.attributes)
                    ].reverse_merge(Hash["containable_type" => ""])
                  ]
                end
              end
            ]
          }
          params = contents_params.reverse_merge(trivia.attributes)
          post(:update, id: trivia.id,trivia: params)
          expect(response.location).to eq(new_question_trivia_url(assigns[:trivia].id))
        end

        it "select other" do
          contents_params = {content_attributes:
            Hash[contents.map.with_index do |content,index|
                if content[:containable_type] == type
                  [index.to_s,Hash[
                      containable_attributes:
                      Hash[ document:
                        content.containable.document
                      ].reverse_merge(content.containable.attributes)
                    ].reverse_merge(Hash["containable_type" => ""])
                  ]
                else
                  doc = content.containable_type == "Pdf" ?
                    Rack::Test::UploadedFile.new('spec/fixtures/Test.pdf', 'application/pdf')
                  :
                    eval(content.containable_type).make.document
                 [index.to_s,Hash[
                      containable_attributes:
                      Hash[ document:
                        content.containable.document = doc
                      ].reverse_merge(content.containable.attributes)
                    ].reverse_merge(content.attributes)
                  ]
                end
              end
            ]
          }
          params = contents_params.reverse_merge(trivia.attributes)
          post(:update, id: trivia.id,trivia: params)
          expect(response.location).to eq(new_question_trivia_url(assigns[:trivia].id))
        end

         it "select same" do
          contents_params = {content_attributes:
            Hash[contents.map.with_index do |content,index|
                doc = content.containable_type == "Pdf" ?
                    Rack::Test::UploadedFile.new('spec/fixtures/Test.pdf', 'application/pdf')
                  :
                    eval(content.containable_type).make.document
                if content[:containable_type] == type
                  [index.to_s,Hash[
                      containable_attributes:
                      Hash[ document:
                        content.containable.document = doc
                      ].reverse_merge(content.containable.attributes)
                    ].reverse_merge(content.attributes)
                  ]
                else
                 [index.to_s,Hash[
                      containable_attributes:
                      Hash[ document:
                        content.containable.document = doc
                      ].reverse_merge(content.containable.attributes)
                    ].reverse_merge(Hash["containable_type" => ""])
                  ]
                end
              end
            ]
          }
          params = contents_params.reverse_merge(trivia.attributes)
          post(:update, id: trivia.id,trivia: params)
          expect(response.location).to eq(new_question_trivia_url(assigns[:trivia].id))
        end
      end

      context "contents #{type} fail"  do
        let(:trivia){ Trivia.make!(:filled,content: Content.make!(containable: eval(type).make!))}
        let(:contents){
          trivia.contents_init.each{|c|
            c[:containable_type] = "" unless c[:containable_type] == type
          }
        }

        it "not document #{type}" do
          contents_params = {content_attributes:
            Hash[contents.map.with_index do |content,index|
              content[:containable_type] == type ?
                [index.to_s,Hash[
                    containable_attributes:
                    Hash[ document: nil].reverse_merge(content.containable.attributes)
                  ].reverse_merge(Hash["containable_type" => type])
                ]
              :
                [index.to_s,content.attributes]
              end
              ]
            }
          params = contents_params.reverse_merge(trivia.attributes)
          post(:update, id: trivia.id,trivia_level:  @trivia.course.level,trivia: params)
          expect(response.body).to match "Content containable document can\.*t be blank"
        end

        it "not conteinable #{type}" do
          contents_params = {content_attributes:
            Hash[contents.map.with_index do |content,index|
              content[:containable_type] == type ?
                [index.to_s,Hash["containable_type" => type]]
              :
                [index.to_s,content.attributes]
            end
            ]
          }
          params = contents_params.reverse_merge(trivia.attributes)
          post(:update, id: trivia.id,trivia_level:  @trivia.course.level,trivia: params)
          expect(response.body).to match "Content containable can\.*t be blank"
        end
      end
    end
  end

  describe "POST 'cannot update trivia with games'" do
    before :each do
      @trivia = Trivia.make!
      @game = Game.make!
      @trivia.games << @game
    end

    it "assigns the value to the flash notice" do
      post(:update,:id => @trivia.id,trivia_level:  @trivia.course.level,trivia: @trivia.attributes)
      expect(flash[:alert]).to eq ("No se puede editar una trivia si tiene juegos asociados")
    end
  end

  describe "GET 'new_question'" do
    before :each do
      @trivia = Trivia.make!
      @question = Question.make!
    end

    it "returns http success(code=200) without question" do
      get 'new_question', {:id => @trivia.id}
      expect(response.code).to eq("200")
    end

    it "returns http success with question" do
      get 'new_question', {:id => @question.trivia.id}
      expect(response.code).to eq("200")
    end
  end

  describe "POST 'create_question'" do
    render_views
    before :each do
      @trivia = Trivia.make!
    end

    let(:question){Question.make(:filled)}

    it "created a new question to trivia " do
      params = {:id => @trivia.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      expect {post('create_question', params) }.to change{Question.count}.by(1)
    end

    it "returns http success, return 'new_question_trivia_url'" do
      params = {:id => @trivia.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      post 'create_question', params
      expect(response).to redirect_to(new_question_trivia_url(@trivia.id))
    end

    it "returns http success, return 'trivium_url' " do
      params = {:id => @trivia.id, :finish => "true", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      post 'create_question', params
      expect(response).to redirect_to(trivium_url)
    end

    it "does not create a question to the trivia without a question description " do
      params = {:id => @trivia.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => nil, :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      expect {post('create_question', params) }.to change{Question.count}.by(0)
    end

    it "with description nil it redirects to the new question action again " do
      params = {:id => @trivia.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => nil, :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      post 'create_question', params
      expect(response.body).to match /Preguntas y Respuestas/
    end

    context "does not create a question" do
      it "without a question answer" do
        question.answer = nil
        expect { post :create_question ,{ id:@trivia.id, finish: :false , question: question.attributes } }.to change{Question.count}.by(0)
      end

      it "on trivia type multiple chooise and without a question incorrect answer one" do
        question.incorrect_answer_one = nil
        expect { post :create_question ,{ id:@trivia.id, finish: :false , question: question.attributes } }.to change{Question.count}.by(0)
      end
    end

    context "render the new question view again and finish create questions" do
      it "without a question answer" do
        question.answer = nil
        post :create_question ,{ id:@trivia.id, finish: :true , question: question.attributes }
        expect(response.body).to match /Preguntas y Respuestas/
      end

      it "on trivia type multiple chooise and without a question  incorrect answer one" do
        question.incorrect_answer_one = nil
        post :create_question ,{ id:@trivia.id, finish: :true , question: question.attributes }
        expect(response.body).to match /Preguntas y Respuestas/
      end

    end

    context "error messages" do
      it "without a question answer" do
        question.answer = nil
        post :create_question ,{ id:@trivia.id, finish: :false , question: question.attributes }
        expect(assigns[:question].errors.full_messages.first).to match /Answer can't be blank/
      end

      it "on trivia type multiple chooise and  without a question  incorrect answer one" do
        question.incorrect_answer_one = nil
        post :create_question ,{ id:@trivia.id, finish: :false , question: question.attributes }
        expect(assigns[:question].errors.full_messages.first).to match /Incorrect answer one can't be blank/
      end
    end

    context "does create a question on trivia type free" do
       it "without a question incorrect answer one" do
        question.incorrect_answer_one = nil
        @trivia.update(type: 2)
        expect { post :create_question ,{ id:@trivia.id, finish: :false , question: question.attributes } }.to change{Question.count}.by(1)
      end

      it "on trivia type multiple chooise and without a question  incorrect answer one" do
        question.incorrect_answer_one = nil
        @trivia.update(type: 2)
        post :create_question ,{ id:@trivia.id, finish: :false , question: question.attributes }
        expect(response.body).to match new_question_trivia_path(@trivia)
      end
    end
  end

  describe "POST 'cannot create_question if the trivia has a game'" do
    render_views
    before :each do
      @trivia = Trivia.make!
      @game = Game.make!
      @trivia.games << @game
    end

    it "cannot create a new question to a trivia with games " do
      params = {:id => @trivia.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      expect {post('create_question', params) }.to change{Question.count}.by(0)
      expect(flash[:alert]).to eq ("No se puede crear una pregunta si su trivia tiene juegos asociados")
    end

  end

  describe "GET 'edit_question'" do
    before :each do
      @question = Question.make!
    end

    it "returns http success(code= 200)" do
      get 'edit_question', {:id => @question.trivia.id, :question_id => @question.id}
      expect(response.code).to eq("200")
    end
  end

  describe "GET 'update_question'" do
    render_views
    before :each do
      @question = Question.make!
    end

    it "returns http success, return 'new_question_trivia_url' " do
      params = {:id => @question.trivia.id, :question_id => @question.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      post 'update_question', params
      expect(response).to redirect_to(new_question_trivia_url)
    end

    it "returns http success, return 'trivium_url' " do
      params = {:id => @question.trivia.id, :question_id => @question.id, :finish => "true", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      post 'update_question', params
      expect(response).to redirect_to(trivium_url)
    end

    it "with description nil does not update the question" do
      params = {:id => @question.trivia.id, :question_id => @question.id, :finish => "true", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => nil, :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      post 'update_question', params
      expect(response.body).to match /Editar Pregunta y Respuestas de Trivia/
    end
  end

  describe "POST 'cannot update_question of a trivia with games'" do
    render_views
    before :each do
      @trivia = Trivia.make!
      @question = Question.make!(trivia: @trivia)
      @game = Game.make!(trivia: @trivia)
    end

    it "cannot edit a question of a trivia with games ' " do
      params = {:id => @trivia.id, :question_id => @question.id, :finish => "false", :question => {:answer => "De que color es el logo de vairix", :dificulty => "1", :description => "Verde", :incorrect_answer_one => "Negro", :incorrect_answer_two => "Amarillo", :incorrect_answer_three => "Azul", :incorrect_answer_four => "Rojo" }}
      post 'update_question', params
      expect(response.code).to eq("200")
      expect(flash[:alert]).to eq("No se puede editar una pregunta si su trivia tiene juegos asociados")
    end

  end

 describe "POST 'clone'" do
    before :each do
      @trivia = Trivia.make!(:filled)
    end

    it "clone a trivia" do
      post :clone, id: @trivia.id
      expect(response.code).to eq("302")
    end

    it "redirect to index" do
      post :clone, id: @trivia.id
      expect(response).to redirect_to(trivium_url)
    end

     it "notice messages" do
      post :clone, id: @trivia.id
      expect(flash[:notice]).to match("Nueva trivia clonada: ")
    end

    it "notice messages correct link" do
      post :clone, id: @trivia.id
      expect(flash[:link][:url]).to match(edit_trivia_path(Trivia.last))
    end
  end
end