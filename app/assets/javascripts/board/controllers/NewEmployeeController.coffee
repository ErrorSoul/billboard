angular.module "board"
  .controller "NewEmployeeController", [
    "$scope"
    "$state"
    "$stateParams"
    "$http"
    "Skills"
    'Employees'
    'Tool',
    (
     $scope
     $state
     $stateParams
     $http
     Skills
     Employees
     Tool
    ) ->

      $scope.statusArray = [{ name: 'search'}, { name: 'stop' }]
      $scope.EMAIL_PATTERN = Tool.EMAIL_PATTERN
      $scope.CYRILLIC_PATTERN = Tool.CYRILLIC_PATTERN
      $scope.obj = name: 'choose'
      $scope.newSkill = name: ''
      $scope.hashUrl = $state.current.name
      $scope.select = angular.copy $scope.obj

      $scope.getEmployee = (id) ->
        handleError = (error) ->
          console.log("ERROR", error)

        handleSuccess = (data) ->
          $scope.employee = data.data.employee
          $scope.employee.salary = parseInt($scope.employee.salary)

        Employees.getEmployee(id, handleSuccess, handleError)

      if $stateParams.id
        $scope.getEmployee($stateParams.id)
      else
        $scope.employee = skills: []


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
        $scope.employee.skills.push $scope.newSkill
        $scope.newSkill = {}

      $scope.addSkillSelect = ->
        if $scope.select.name isnt 'choose'
          $scope.employee.skills.push $scope.select
          $scope.select = angular.copy $scope.obj

      $scope.removeSkill = (index) ->
        $scope.employee.skills.splice(index, 1)

      $scope.createEmployee = (employee) ->
        handleSuccess = (data) ->
          if data.data.message is 'OK'
            return $state.go("employees.index")
        handleError = (error) ->
          console.log('ERROR', error)
          $scope.errors = error.data
          for key of error.data
            $scope.vForm[key].$setValidity('required', false)

        if $scope.hashUrl is "employees.new"
          Employees.createEmployee(employee, handleSuccess, handleError)
        else
          Employees.updateEmployee(employee, handleSuccess, handleError)


      console.log("$", $scope)

  ]
