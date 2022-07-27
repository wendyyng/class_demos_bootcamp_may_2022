# module Api
#     module V1
#         class QuestionController < Api::ApplicationController
#         end
#     end
# end
# 👆🏻 is like this 👇🏻
class Api::V1::QuestionsController < Api::ApplicationController
    # this controller is generated by rails g controller api/v1/questions --no-assets --no-helper --skip-template-engine
    # also remember to change the parent class => Api::ApplicationController
    before_action :authenticate_user!, except: [:index, :show]

    def index
        questions = Question.order(created_at: :desc)
        render(json: questions, each_serializer: QuestionCollectionSerializer)
        # we will provide 'each_serializer' named argument to the option hash of the render method that tells which serializer to use with each instance
    end

    def show
        question = Question.find(params[:id])
        # return a single question in json format
        render(json: question)
    end

    def create
        question = Question.new(question_params)
        # question.user = User.first #hard code the user for now
        question.user = current_user
        if question.save
            render json: { id: question.id }
        else
            render(
                json: { errors: question.errors.messages },
                status: 422 #unprocessable entity HTTP status code
            )
        end
    end

    def update
        question = Question.find(params[:id])
        # based on the id of the user request, update that question with the given params
        if question.update(question_params)
            render json: {id: question.id}
        else
            render(
                json: { errors: question.errors.messages },
                status: 422 #unprocessable entity HTTP status code
            )
        end
    end

    def destroy
        question = Question.find(params[:id])
        # based on the id of the user request, delete that question
        if question.destroy
            # head :ok
            render( json: {status: 200 })
        else
            #head :bad_request
            render( json: {status: 500 })
        end
    end

    private

    def question_params
        params.require(:question).permit(:title, :body, :tag_names)
    end
end