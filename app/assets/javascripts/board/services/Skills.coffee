angular.module "board"
  .factory "Skills", [
    "$http", ($http) ->
      #
      # Public Methods
      #
      getSkills =  ->
        $http.get("api/v1/skills")

      return {
        getSkills: getSkills

      }
  ]
