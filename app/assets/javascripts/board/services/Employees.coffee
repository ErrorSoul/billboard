angular.module "board"
  .factory "Employees", [
    "$http", ($http) ->
      #
      # Public Methods
      #
      getEmployees = (page, hash) ->
        api = if hash is "employees.index" then 'v1' else 'v2'
        $http.get("api/#{ api }/employees", params: { page: page })

      getEmployee = (userId, handleSuccess, handleError) ->
        $http.get("api/v1/employees/#{userId}").then handleSuccess, handleError

      createEmployee = (employee, handleSuccess, handleError) ->
        $http.post(
          "api/v1/employees", { employee: employee }
        ).then handleSuccess, handleError

      updateEmployee = (employee, handleSuccess, handleError) ->
        $http.put(
          "api/v1/employees/#{employee.id}", { employee: employee }
        ).then handleSuccess, handleError

      destroyEmployee = (employee, handleSuccess, handleError) ->
        $http.delete("api/v1/employees/#{employee.id}").then handleSuccess, handleError

      getAllElements = (id, page, handleSuccess, handleError) ->
        $http.get(
          "api/v2/vacancies/#{ id }/except", params: { page: page }
        ).then handleSuccess, handleError

      getPartElements = (id, page, handleSuccess, handleError) ->
        $http.get(
          "api/v2/vacancies/#{ id }/intersect", params: { page: page }
        ).then handleSuccess, handleError


      return {
        getEmployees: getEmployees
        getEmployee: getEmployee
        createEmployee: createEmployee
        updateEmployee: updateEmployee
        destroyEmployee: destroyEmployee
        getAllElements: getAllElements
        getPartElements: getPartElements
      }
  ]
