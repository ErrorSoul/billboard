angular.module("board")
  .directive 'ngUnique', ['$http', ($http) ->

    require: 'ngModel'
    link: (scope, elem, attrs, ctrl) ->
      elem.on 'blur', (evt) ->
        scope.$apply( ()->
          if elem.val()
            $http.get("api/v1/skills/#{elem.val()}")
              .success (data, status, headers, config) ->
                ctrl.$setValidity('unique', data.message)
        )
  ]
