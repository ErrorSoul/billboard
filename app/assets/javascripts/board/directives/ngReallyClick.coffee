
 angular.module("board")
   .directive('ngReallyClick', [ () ->
      restrict: 'A'
      link: (scope, elem, attrs) ->
        elem.bind('click', () ->
          message = attrs.ngReallyMessage
          if message and confirm(message)
            scope.$apply(attrs.ngReallyClick))
    ])
