$ ->
  $( ".root" ).nestedSortable {
    forcePlaceholderSize: true,
    handle: 'div',
    helper: 'clone',
    items: 'li',
    opacity: .6,
    placeholder: 'placeholder',
    revert: 250,
    tabSize: 25,
    tolerance: 'pointer',
    toleranceElement: '> div',
    isTree: true,
    expandOnHover: 700,
    startCollapsed: false
    update: build
    # protectRoot: true
  }
      
  $( ".draggable" ).draggable {
    connectToSortable: ".root"
    helper: "clone"
    revert: "invalid"
  }

  $( "#tabs" ).tabs()

  head = $("iframe").contents().find("head")
  head.append $("<link/>", { rel: "stylesheet", href: '/style/preview.css', type: "text/css" })

build_r = (parent, elem) ->  
  block = elem.children('.block')
  children = elem.children('ol').children()

  foo = null
  if block.hasClass('group')
    foo = $('<div>')

  else if block.hasClass('header')
    input = block.find('input:text')
    foo = $('<h1>').text input.val()
    input.bind 'input propertychange', () ->
      foo.text input.val()

  else if block.hasClass('paragraph')
    textarea = block.find 'textarea'
    foo = $('<p>').html textarea.val().replace(/\n/g, '<br>')
    textarea.bind 'input propertychange', () ->
      foo.html textarea.val().replace(/\n/g, '<br>')
  
  parent.append foo
  block.click () ->
    foo.effect("highlight", {}, 1000)

  children.each () ->
    build_r foo, $(@)

  null

build = () ->
  body = $('iframe').contents().find('body')
  body.children().remove()
  $('ol.root > li').first().children('ol').children().each () ->
    build_r body, $(@)
  null
  
  # $( ".store" ).draggable {
  #   connectToSortable: ".sortable",
  #   helper: "clone"
  #   revert: "invalid" 
  # }

  # $( ".blockRoot" ).draggable()

  # $( "ul, li" ).disableSelection();