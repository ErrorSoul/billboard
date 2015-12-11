angular.module "board"
  .factory "Vacancies", [
    "$http", ($http) ->
      #
      # Public Methods
      #
      getVacancies = (page, hash) ->
       api =  if hash is "vacancies.index" then 'v1' else 'v2'
       $http.get("api/#{ api }/vacancies", params: { page: page })

      getVacancy = (userId, handleSuccess, handleError) ->
        $http.get("api/v1/vacancies/#{userId}").then handleSuccess, handleError

      createVacancy = (vacancy, handleSuccess, handleError) ->
        $http.post(
          "api/v1/vacancies", { vacancy: vacancy }
        ).then handleSuccess, handleError

      updateVacancy = (vacancy, handleSuccess, handleError) ->
        $http.put(
          "api/v1/vacancies/#{vacancy.id}", { vacancy: vacancy }
        ).then handleSuccess, handleError

      destroyVacancy = (vacancy, handleSuccess, handleError) ->
        $http.delete("api/v1/vacancies/#{vacancy.id}").then handleSuccess, handleError

      getAllElements = (id, page, handleSuccess, handleError) ->
        $http.get(
          "api/v2/employees/#{ id }/except", params: { page: page }
        ).then handleSuccess, handleError

      getPartElements = (id, page, handleSuccess, handleError) ->
        $http.get(
          "api/v2/employees/#{ id }/intersect", params: { page: page }
        ).then handleSuccess, handleError


      return {
        getVacancies: getVacancies
        getVacancy: getVacancy
        createVacancy: createVacancy
        updateVacancy: updateVacancy
        destroyVacancy: destroyVacancy
        getAllElements: getAllElements
        getPartElements: getPartElements
      }
  ]
