angular.module "board"
  .controller "EmployeesController", [
    "$scope", "$state", "$http", "Employees", "Tool",
    ($scope, $state, $http, Employees, Tool) ->
      $scope.page = 0
      $scope.pagesCount = Tool.pagesCount
      $scope.isActive = Tool.isActive
      $scope.block = Tool.block.employee
      $scope.hashUrl = $state.current.name
      $scope.beauty_phone = Tool.beauty_phone
      $scope.labelHelper = Tool.label_helper


      $scope.getEmployees = (page) ->
        handleSuccess = (data) ->
          $scope.employees = data.data.employees
          $scope.page_num  = data.data.page_num
          $scope.page = data.data.page

        handleError = (error) ->
          console.log('ERROR', error)

        Employees.getEmployees(page, $scope.hashUrl).then handleSuccess, handleError

      $scope.getEmployees($scope.page, $scope.hashUrl)
      $scope.getElements = $scope.getEmployees

      $scope.isEmptyEmployees = ->
        $scope.employees and $scope.employees.length is 0

      $scope.isPublic = ->
        $scope.hashUrl.indexOf("public") > -1

      $scope.removeEmployee = (index) ->
        handleSuccess = (data) ->
          $scope.employees.splice(index, 1)

        handleError = (error) ->
          console.log("ERROR", error)

        Employees.destroyEmployee($scope.employees[index], handleSuccess, handleError)
  ]
