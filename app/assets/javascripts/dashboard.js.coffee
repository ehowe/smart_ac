$(document).ready ->
  $(".alert").fadeTo(2000, 500).slideUp(500, ->
    $(".alert").slideUp(500)
  )
