$(document).on 'emoji:ready', ->
  if location.hash.length
    search $('.speedy-filter').val(location.hash.substr(1)).val()
  else
    search()

search = (keyword) ->
  keyword ?= ''
  $('.keyword').text keyword
  keyword = keyword.trim()

  unless window.speedy_keyword == keyword
    window.speedy_keyword = keyword
    if keyword.length
      $('.result').hide()
      $('.result').each ->
        $(this).show() if $(this).text().toLowerCase().indexOf(keyword.toLowerCase()) > -1
    else
      $('.result').show()

  setRelatedDOMVisibility(keyword)

setRelatedDOMVisibility = (keyword) ->
  foundSomething = !!$('.result:visible').length
  $('.no-results').toggle( !foundSomething )

  if keyword.length >= 3
    if !foundSomething
      ga 'send', 'event', 'search', 'no results'
    else
      ga 'send', 'event', 'search', keyword

timeout = null;
delayedSearch = (delayTime)->

  ###
  We don't want timeouts stacking on top of eachother 
  which would defeat what the delayed search function does
  ###
  clearTimeout(timeout)

  timeout = setTimeout(
    (-> search(
      location.hash = $('.speedy-filter').val()) 
    ), delayTime)


$(document).on 'search keyup', '.speedy-filter', -> 
  delayTime = 1000
  delayedSearch(delayTime)


$(document).on 'click', '.group', ->
  ga 'send', 'event', 'search', 'quick group search'
  search $('.speedy-filter').val($(this).attr('href').substr(1)).val()

$(document).on 'click', '.speedy-remover', ->
  $('.speedy-filter').val('')
  $('.result').show()
  location.hash = ''

window.onhashchange = ->
  search $('.speedy-filter').val(location.hash.substr(1)).val()
  $('[href^="#"]').removeClass('active')
  $("[href='#{location.hash}']").addClass('active')
