angular.module "board"
  .controller "VacanciesController", [
    "$scope", "$state", "$http", "Vacancies", "Tool",
    ($scope, $state, $http, Vacancies, Tool) ->
      console.log('$', $scope)
      $scope.page = 0
      $scope.pagesCount = Tool.pagesCount
      $scope.isActive = Tool.isActive
      $scope.block = Tool.block.vacancy
      $scope.hashUrl = $state.current.name
      $scope.beauty_phone = Tool.beauty_phone
      $scope.labelHelper = Tool.label_helper

      $scope.getVacancies = (page) ->
        handleSuccess = (data) ->
          $scope.vacancies = data.data.vacancies
          $scope.page_num  = data.data.page_num
          $scope.page = data.data.page

        handleError = (error) ->
          console.log('ERROR', error)

        Vacancies.getVacancies(page, $scope.hashUrl).then handleSuccess, handleError

      $scope.getVacancies($scope.page, $scope.hashUrl)
      $scope.getElements = $scope.getVacancies

      $scope.isEmptyVacancies = ->
        $scope.vacancies and $scope.vacancies.length is 0

      $scope.isPublic = ->
        $scope.hashUrl.indexOf("public") > -1

      $scope.removeVacancy = (index) ->
        handleSuccess = (data) ->
          $scope.vacancies.splice(index, 1)

        handleError = (error) ->
          console.log("ERROR", error)

        Vacancies.destroyVacancy($scope.vacancies[index], handleSuccess, handleError)
  ]
