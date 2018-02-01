class RecentStatistics
  @needsReload = true

  constructor: (context, stats) ->
    @stats = stats
    @context = context

  render: (graphName) ->
    labels = []
    options = {}
    chart = new Chart(@context, {type: 'line', options: {responsive: true}, data: {}})

    if graphName == 'temp'
      options = @tempOptions()
      labels = @statDates(@tempStats())
    else if graphName == 'co'
      options = @coOptions()
      labels = @statDates(@coStats())
    else if graphName == 'humidity'
      options = @humidityOptions()
      labels = @statDates(@humidityStats())

    chart.data.labels = labels.map (date) -> Intl.DateTimeFormat('en-US', {year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric"}).format(date)
    chart.data.datasets = [options]
    chart.update()

  tempOptions: =>
    {
      label: "Temperature",
      borderColor: "#FF0000",
      data: @statValues(@tempStats()),
      lineTension: 0,
      yAxisId: 1
    }

  coOptions: =>
    {
      label: "Carbon Monoxide Levels",
      borderColor: "#00FF00",
      data: @statValues(@coStats()),
      lineTension: 0,
      yAxisId: 2
    }

  humidityOptions: =>
    {
      label: "Humidity Levels",
      borderColor: "#0000FF",
      data: @statValues(@humidityStats()),
      lineTension: 0,
      yAxisId: 3
    }


  tempStats: =>
    @stats.filter (stat) -> stat.type == 'Temperature'

  coStats: =>
    @stats.filter (stat) -> stat.type == 'CoLevel'

  humidityStats: =>
    @stats.filter (stat) -> stat.type == 'Humidity'

  statDates: (stats) =>
    stats.map (stat) -> new Date(stat.read_at)

  statValues: (stats) =>
    stats.map (stat) -> stat.value

class StatsTable
  constructor: ->
    @apiKey = $("#apiKey").data("apikey")
    @deviceId = $("#deviceId").data("deviceid")
    @dataTable = $("#allStatsTable").DataTable({
      "autoWidth": false,
      "serverSide": true,
      "columnDefs": [{searchable: false, targets: 1 }],
      "columns":    [{"width": "33%"}, {"width": "33%"}, {"width": "33%"}],
      "ajax": "/api/ajax_sensor_readings?api_key=#{@apiKey}&device=#{@deviceId}"
    })

  render: ->
    @dataTable.column(0).search($(".chooseSensor.active").data("action")).column(2).search($(".chooseTimeframe.active").data("action")).draw()


$(document).ready ->
  stats = $("#recentStats").data("stats")

  recentCanvas = $("#mostRecent")[0]
  recentStatsGraph = new RecentStatistics(recentCanvas.getContext("2d"), stats)
  recentStatsGraph.render('temp')

  allStatsTable = new StatsTable
  $(".chooseSensor, .chooseTimeframe").click ->
    $(this).addClass('active').siblings().removeClass('active')
    allStatsTable.render()
  $('.renderRecentGraph').click ->
    recentStatsGraph.render($(this).data("action"))
