$ ->

  $('.backgrounds').fadeIn(1500)
  setInterval('ololo()', 7000)


  $('.send-form').on 'click', ->
    #$('.label').hide()
    $('.form').hide()
    $('.thank-you').show()



window.ololo = ->


  active = $('.backgrounds .active')
  next = if ($('.backgrounds .active').next().length > 0) then $('.backgrounds .active').next() else $('.backgrounds .background:first')

  next.css('z-index', 2)

  $('.city').css('opacity', '0.1')
  $(".city-#{$(next).attr('active')}").css('opacity', '1')
  $("#{next.attr('siblings')}").css('opacity', '0.7')
  $(".city-#{$(next).attr('nextnext')}").css('opacity', '0.6')

  active.fadeOut(1500, ->

    active.css('z-index', 1).show().removeClass('active')
    next.css('z-index', 3).addClass('active')
  )