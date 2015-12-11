angular.module "board"
  .config [
    "$httpProvider"
    "$rootScopeProvider", (
      $httpProvider
      $RootScopeProvider
    ) ->
      $httpProvider.defaults.headers
        .common["X-CSRF-TOKEN"] = $("meta[name=csrf-token]").attr "content"
  ]
