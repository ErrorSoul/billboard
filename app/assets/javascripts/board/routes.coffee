angular.module "board"
  .config [
    "$stateProvider"
    "$urlRouterProvider", (
      $stateProvider
      $urlRouterProvider
    ) ->
      $urlRouterProvider.otherwise("/main")
      $stateProvider

       .state "main", {
          url: "/"
          template: "<h2> Welcome! <h2>"

      }
       .state "vacancies", {
          abstract: true
          url: "/vacancies"
          template: "<ui-view/>"
      }

        .state "vacancies.index", {
          url: "/"
          templateUrl: "vacancies/index.html"
          controller: "VacanciesController"
      }

        .state "vacancies.new", {
          url: "/new"
          templateUrl: "vacancies/new.html"
          controller: "NewVacancyController"
      }

        .state "vacancies.show", {
          url: "/show/:id"
          templateUrl: "vacancies/show.html"
          controller: "ShowVacancyController"
      }

      .state "vacancies.update", {
          url: "/update/:id"
          templateUrl: "vacancies/new.html"
          controller: "NewVacancyController"
      }

      .state "employees", {
          abstract: true
          url: "/employees"
          template: "<ui-view/>"

      }

        .state "employees.index", {
          url: "/"
          templateUrl: "employees/index.html"
          controller: "EmployeesController"
      }

        .state "employees.new", {
          url: "/new"
          templateUrl: "employees/new.html"
          controller: "NewEmployeeController"
      }

        .state "employees.show", {
          url: "/show/:id"
          templateUrl: "employees/show.html"
          controller: "ShowEmployeeController"
      }

      .state "employees.update", {
          url: "/update/:id"
          templateUrl: "employees/new.html"
          controller: "NewEmployeeController"
      }


      .state "public", {
          abstract: true
          url: "/public"
          template: "<ui-view/>"
      }

      .state "public.vacancies", {
          abstract: true
          url: "/vacancies"
          template: "<ui-view/>"
      }

      .state "public.employees", {
          abstract: true
          url: "/employees"
          template: "<ui-view/>"
      }

      .state "public.vacancies.index", {
          url: "/"
          templateUrl: "vacancies/index.html"
          controller: "VacanciesController"
      }

      .state "public.vacancies.show", {
          url: "/show/:id"
          templateUrl: "vacancies/show.html"
          controller: "ShowVacancyController"
      }


      .state "public.employees.index", {
          url: "/"
          templateUrl: "employees/index.html"
          controller: "EmployeesController"
      }

       .state "public.employees.show", {
          url: "/show/:id"
          templateUrl: "employees/show.html"
          controller: "ShowEmployeeController"
      }

  ]
