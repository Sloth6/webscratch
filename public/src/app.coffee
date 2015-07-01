'use strict'
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
    update: build_dom
    # protectRoot: true
  }
      
  $( ".draggable" ).draggable {
    connectToSortable: ".root"
    helper: "clone"
    revert: "invalid"
  }

  $( "#tabs" ).tabs()

  head = $("iframe").contents().find("head")

    # script(src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js")

  head.append $("<link/>", { rel: "stylesheet", href: '/style/preview.css', type: "text/css" })
  head.append $("<link/>", { rel: "stylesheet", href: 'http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css', type: "text/css" })
  head.append $('<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>')

  # $("iframe").contents().find("body").append $('<div class="row"> 
  #               <div class="col-xs-2">foobar</div> 
  #               <div class="col-xs-2">foobar</div> 
  #               <div class="col-xs-2">foobar</div> 
  #               <div class="col-xs-2">foobar</div> 
  #               <div class="col-xs-2">foobar</div> 
  #               <div class="col-xs-2">foobar</div> 
  #             </div>')

formatDivChildren = (div, children, areColumns) ->
  children.removeClass()
  if areColumns
    div = Math.floor(12 / children.length)
    rem = 12 % children.length
    colSize = if rem is 0 then div else 2
    children.removeClass().addClass('col-xs-'+colSize)


build_dom_r = (sandbox_elem) ->
  
  # every element has a block and children
  block = sandbox_elem.children '.block'
  sandbox_children = sandbox_elem.children('ol').children()

  # recursively get all the children of this element in the dom
  dom_children = sandbox_children.get().map (child) -> build_dom_r $(child)
  
  # the dom element we will return for this sandbox_elem
  dom = null

  if block.hasClass 'group'
    dom = $('<div>')
      .addClass 'well'
      .addClass 'group'
      .addClass 'row'
    
    if dom_children.length
      # console.log block.find('input[name="divFormat"]:checked'), block.find('input[name="divFormat"]').val()
      isColumns = block.find('input[name="divFormat"]:checked').val() is '|'
      # console.log dom_children.length, isColumns, $(dom_children)
      formatDivChildren dom, $(dom_children).map(() -> @toArray()), isColumns
      # formatDivChildren
      block.find('input[name="divFormat"]').click () ->
        formatDivChildren dom, dom.children(), @value is '|'
    else
      dom.css {
        'min-width': 20
        'min-height': 20
        'border-style': 'solid'
      }

  else if block.hasClass 'header'
    input = block.find 'input:text'
    header = $('<h1>').text input.val()
    input.bind 'input propertychange', () -> header.text input.val()
    dom = header

  else if block.hasClass 'paragraph'
    textarea = block.find 'textarea'
    p = $('<p>').
      html(textarea.val().replace(/\n/g, '<br>')).
      addClass 'well'

    textarea.bind 'input propertychange', () ->
      p.html textarea.val().replace(/\n/g, '<br>')
    dom = p
  
  else if block.hasClass 'button'
    button = $('<button type="button" class="btn btn-primary">Click Me</button>')
    dom = button
  
  else if block.hasClass 'contain'
    dom = $('<div class=container-fluid></div>')

  # use closure to blind sandbox ui to preview dom
  block.click () -> dom.effect("highlight", {}, 1000)

  dom.append dom_children


  $('<div>').append(dom)

build_tree_r = (li) ->


build_dom = () ->
  body = $('iframe').contents().find('body')
  body.children().remove()
  # body.apppend $('ol.root > li')
  #.first().children('ol').children().each () ->
  body.append build_dom_r $('ol.root > li')
  null
  
  # $( ".store" ).draggable {
  #   connectToSortable: ".sortable",
  #   helper: "clone"
  #   revert: "invalid" 
  # }

  # $( ".blockRoot" ).draggable()

  # $( "ul, li" ).disableSelection();