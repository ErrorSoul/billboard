angular.module "board"
  .controller "NewVacancyController", [
    "$scope"
    "$state"
    "$stateParams"
    "$http"
    "Skills"
    'Vacancies'
    'Tool',
    (
     $scope
     $state
     $stateParams
     $http
     Skills
     Vacancies
     Tool
    ) ->

      $scope.hashUrl = $state.current.name
      console.log("HASH URL", $scope.hashUrl)
      $scope.EMAIL_PATTERN = Tool.EMAIL_PATTERN
      $scope.DateMin = Date.now()
      $scope.obj = name: 'choose'
      $scope.newSkill = name: ''
      $scope.select = angular.copy $scope.obj


      $scope.getVacancy = (id) ->
        handleError = (error) ->
          console.log("ERROR", error)

        handleSuccess = (data) ->
          $scope.vacancy = data.data.vacancy
          $scope.vacancy.salary = parseInt($scope.vacancy.salary)
          $scope.vacancy.published_at = new Date($scope.vacancy.published_at)

        Vacancies.getVacancy(id, handleSuccess, handleError)

      if $stateParams.id
        $scope.getVacancy($stateParams.id)
      else
        $scope.vacancy = skills: []

      $scope.selectArray = ->
        [angular.copy($scope.obj)].concat $scope.skills


      $scope.getSkills = ->
        handleSuccess = (data) ->
          $scope.skills = data.data.skills
          $scope.skillsArray = $scope.selectArray()

        handleError = (data) ->
          console.log("Error", data)

        Skills.getSkills().then handleSuccess, handleError

      $scope.getSkills()

      $scope.addSkill = ->
        $scope.vacancy.skills.push $scope.newSkill
        $scope.newSkill = {}

      $scope.addSkillSelect = ->
        if $scope.select.name isnt 'choose'
          $scope.vacancy.skills.push $scope.select
          $scope.select = angular.copy $scope.obj

      $scope.removeSkill = (index) ->
        $scope.vacancy.skills.splice(index, 1)

      $scope.createVacancy = (vacancy) ->
        handleSuccess = (data) ->
          if data.data.message is 'OK'
            return $state.go("vacancies.index")
        handleError = (error) ->
          console.log('ERROR', error)
          $scope.errors = error.data
          for key of error.data
            $scope.vForm[key].$setValidity('required', false)

        if $scope.hashUrl is "vacancies.new"
          Vacancies.createVacancy(vacancy, handleSuccess, handleError)
        else
          Vacancies.updateVacancy(vacancy, handleSuccess, handleError)

  ]
