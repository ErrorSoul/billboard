angular.module "board"
  .controller "ShowEmployeeController", [
    "$scope"
    "$state"
    "$stateParams"
    "$http"
    'Employees'
    'Tool'
    (
     $scope
     $state
     $stateParams
     $http
     Employees
     Tool
    ) ->

      $scope.id = $stateParams.id
      $scope.hashUrl = $state.current.name
      $scope.find_flag = false
      $scope.page_need = 0
      $scope.page_part = 0
      $scope.needed_array = []
      $scope.parted_array = []
      $scope.isEmptyArray = Tool.isEmptyArray
      $scope.beauty_phone = Tool.beauty_phone
      $scope.labelHelper = Tool.label_helper

      $scope.findElements = ->
        $scope.find_flag = true if $scope.find_flag is false
        $scope.getAllElements()
        $scope.getPartElements()

      $scope.isPublic = ->
        $scope.hashUrl.indexOf("public") > -1

      $scope.handleError = (error) ->
        console.log("ERROR", error)

      $scope.makeUrl = ->
        "shared/media_employee.html"


      $scope.getAllElements =  ->
        handleSuccess = (data) ->
          angular.forEach data.data.vacancies, (obj) ->
            $scope.needed_array.push obj
          $scope.need_flag = data.data.page_flag
          $scope.page_need += 1

        Employees.getAllElements(
          $scope.id, $scope.page_need, handleSuccess, $scope.handleError
        )

      $scope.getPartElements =  ->
        handleSuccess = (data) ->
          angular.forEach data.data.vacancies, (obj) ->
            $scope.parted_array.push obj
          $scope.part_flag = data.data.page_flag
          $scope.page_part += 1

        Employees.getPartElements(
          $scope.id, $scope.page_need, handleSuccess, $scope.handleError
        )
      $scope.getEmployee = (id) ->
        handleSuccess = (data) ->
          $scope.employee = data.data.employee
          $scope.skills = $scope.employee.skills

        Employees.getEmployee(id, handleSuccess, $scope.handleError)

      $scope.getEmployee($scope.id)

  ]
