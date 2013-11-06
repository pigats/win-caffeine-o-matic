class Reel 

  constructor:  (el, @options) -> 
                  el.append($('<div class="reel-viewport">').append($('<ul class="reel">')))
                  @reel = el.children('.reel-viewport:last').children('.reel') 
                  @reel.append($('<li class="reel-item">').text(option['name']).append($('<img>').attr('src', "/images/#{option['name'].replace(' ','-')}.jpg"))) for option in options
                  @n_options = options.length
                  @height = parseInt(el.children('.reel-viewport').css('height'))
                  @index = 0
                  @spinning = false

  spin:         (stop_callback) -> 
                  @interval = window.setInterval( =>
                    @index = parseInt(Math.random() * 100) % @n_options
                    @reel.css('margin-top', - @height * @index)
                  , 200)

                  @spinning = true

                  timeout_s = 2 + (parseInt(Math.random() * 10) % 3)   
                  window.setTimeout( => 
                    this.stop(stop_callback)
                  , timeout_s * 1000)

  stop:         (callback) -> 
                  window.clearInterval(@interval)
                  @spinning = false
                  callback()


class window.Slot

  constructor:  (@el, options, @prizes) ->
                  
                  @reels = []
                  @reels.push new Reel(@el, reel_options) for reel_options in options
                  this.enable()
  
  enable:       -> 
                  $('.play').on('click', => this.play() )  
                  $('.lever').removeClass('active')             

  disable:      ->
                  $('.play').off('click')
                  $('.lever').addClass('active')

  play:         -> 
                  this.disable()
                  reel.spin(this.check_win) for reel in @reels



  check_win:    => # it is used as a callback
                  if this.n_spinning_reels() is 0
                    @winning_index = @reels[0].options[@reels[0].index]['winning_index']

                    (if reel.options[reel.index]['winning_index'] is @winning_index
                      continue 
                    else 
                      this.lost()
                      return false
                    ) for reel in @reels
                    
                    this.won()


  won:          ->
                  @el.addClass('won')
                  $('.prize-desc').text(@prizes[@winning_index])
                  this.enable()


  lost:         ->
                  @el.addClass('lost')
                  $('.prize-desc').text('nothing, this time. Try again!')
                  this.enable()

  n_spinning_reels: () -> 
                  count = 0
                  (count += 1 if reel.spinning is true) for reel in @reels 
                  return count
