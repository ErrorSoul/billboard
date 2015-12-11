module V2Shared
  extend ActiveSupport::Concern


  module ClassMethods
    STATES = {
      except: :needed,
      intersect: :part_of_needed
    }

    def create_index(class_name)
      array_name = class_pluralize(class_name)

      define_method :index do
        instance_variable_set(
          "@#{ array_name }",
          class_name.optional(params[:page])
        )
        @page_num = class_name.public_num

        render json: {
          array_name.to_sym => instance_variable_get("@#{array_name}"),
          page_num:  @page_num,
          page: params[:page]
        }
      end
    end

    def create_finder(class_name)
      other = another_class(class_name)
      array_name = class_pluralize(class_name)

      STATES.each do |key, value|
        define_method key do
          instance_variable_set(
            "@#{ other.downcase }",
            other.constantize.find(params[:id])
          )

          instance_variable_set(
            "@#{ array_name }",
            class_name.send(
              value,
              instance_variable_get("@#{ other.downcase }"),
              params[:page]
            )
          )

          render json: {
            message: "OK",
            array_name.to_sym => instance_variable_get(
              "@#{array_name}"
            ).as_json(include: :skills),
            page_flag: instance_variable_get("@#{array_name}").empty?
          }
        end
      end
    end

    def create_methods(class_name)
      create_index  class_name
      create_finder class_name
    end

    private

    def another_class(class_name)
      class_name.to_s == 'Vacancy' ? 'Employee' : 'Vacancy'
    end

    def class_pluralize(class_name)
      class_name.to_s.downcase.pluralize
    end
  end
end
