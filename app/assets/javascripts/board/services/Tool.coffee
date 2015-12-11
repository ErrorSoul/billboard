angular.module "board"
  .factory "Tool", [ () ->

    PHONE_PATTERN = "^((8|\+7|7)-?)?\(?\d{3}\)?-?\d{1}-?\d{1}-?\d{1}-?\d{1}-?\d{1}-?\d{1}-?\d{1}$/"
    EMAIL_PATTERN = /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i
    CYRILLIC_PATTERN = /[\s\u0400-\u04FF]/gi

    pagesCount = (pages) -> num for num in [1...(pages + 1)]

    isActive = (index, page) -> 'active' if parseInt(page) is index

    block =
      vacancy:
        names: 'vacancies'
        name:  'vacancy'
        upName: 'Vacancy'
      employee:
        names: 'employees'
        name:  'employee'
        upName: 'Employee'

    isEmptyArray = (array) ->
      array.length is 0

    beauty_phone = (str) ->
      if str and str.indexOf("(") is -1
        re = /(\d{3})(\d{3})(\d{2})(\d{2})/
        result = str.match re
        "+7(#{ result[1] })#{ result[2] }-#{ result[3] }-#{ result[4] }"
      else
        str

    label_helper = (status) ->
      switch status
        when "stop", "unpublished" then "label label-warning"
        else  "label label-info"

    return {
      EMAIL_PATTERN: EMAIL_PATTERN
      PHONE_PATTERN: PHONE_PATTERN
      CYRILLIC_PATTERN: CYRILLIC_PATTERN
      pagesCount: pagesCount
      isActive: isActive
      block:   block
      isEmptyArray: isEmptyArray
      beauty_phone: beauty_phone
      label_helper: label_helper
    }
]
