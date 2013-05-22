# manyboxplots.coffee
#
# Top panel is like a set of box plots:
#   lines are drawn at various quantiles
# Hover over a column in the top panel and the corresponding histogram
#   is show below; click for it to persist; click again to make it go away.
#

HealthvisManyBox = () ->
  this.width=1000
  this.height=450

  this.init = (elementID, d3Params) ->
    dimensions = healthvis.getDimensions(this.width, this.height)
    this.width = dimensions.width
    this.height = dimensions.height

    this.ylab = d3Params.ylab
    this.xlab = d3Params.xlab

    this.ind = d3Params.ind
    this.qu = d3Params.qu
    this.breaks = d3Params.breaks
    this.quant = JSON.parse(d3Params.quant)
    this.counts = JSON.parse(d3Params.counts)

    this.svg = d3.select('#main')
      .append('svg')
      .attr('width', this.width)
      .attr('height', this.height)
      .attr('class', 'chart')

    this.lowsvg = d3.select('#main')
      .append('svg')
      .attr('width', this.width)
      .attr('height', this.height)

  this.visualize = () ->
    ylab = this.ylab
    xlab = this.xlab

    ind = this.ind
    qu = this.qu
    breaks = this.breaks
    quant = this.quant
    counts = this.counts

    w = this.width
    h = this.height

    pad = {
        left: 60,
        top: 20,
        right: 60,
        bottom: 40
    }

    # y-axis limits for top figure
    topylim = [quant[0][0], quant[0][1]]
    for i of quant
      for x in quant[i]
        topylim[0] = x if x < topylim[0]
        topylim[1] = x if x > topylim[1]
    topylim[0] = Math.floor(topylim[0])
    topylim[1] = Math.ceil(topylim[1])

    # y-axis limits for bottom figure
    botylim = [0, counts[0][1]]
    for i of counts
      for x in counts[i]
        botylim[1] = x if x > botylim[1]

    indindex = d3.range(ind.length)

    # adjust counts object to make proper histogram
    br2 = []
    for i in breaks
      br2.push(i)
      br2.push(i)

    fix4hist = (d) ->
      x = [0]
      for i in d
         x.push(i)
         x.push(i)
      x.push(0)
      x

    for i of counts
      counts[i] = fix4hist(counts[i])

    # number of quantiles
    nQuant = quant.length
    midQuant = (nQuant+1)/2 - 1

    # x and y scales for top figure
    xScale = d3.scale.linear()
               .domain([-1, ind.length])
               .range([pad.left, w-pad.right])

    # width of rectangles in top panel
    recWidth = xScale(1) - xScale(0)

    yScale = d3.scale.linear()
               .domain(topylim)
               .range([h-pad.bottom, pad.top])

    # function to create quantile lines
    quline = (j) ->
      d3.svg.line()
          .x((d) -> xScale(d))
          .y((d) -> yScale(quant[j][d]))

    # gray background
    this.svg.append("rect")
       .attr("x", pad.left)
       .attr("y", pad.top)
       .attr("height", h-pad.top-pad.bottom)
       .attr("width", w-pad.left-pad.right)
       .attr("stroke", "none")
       .attr("fill", d3.rgb(200, 200, 200))
       .attr("pointer-events", "none")

    # axis on left
    LaxisData = yScale.ticks(6)
    Laxis = this.svg.append("g").attr("id", "Laxis")

    # axis: white lines
    Laxis.append("g").selectAll("empty")
       .data(LaxisData)
       .enter()
       .append("line")
       .attr("class", "line")
       .attr("class", "axis")
       .attr("x1", pad.left)
       .attr("x2", w-pad.right)
       .attr("y1", (d) -> yScale(d))
       .attr("y2", (d) -> yScale(d))
       .attr("stroke", "white")
       .attr("pointer-events", "none")

    # function to determine rounding of axis labels
    formatAxis = (d) ->
      d = d[1] - d[0]
      ndig = Math.floor( Math.log(d % 10) / Math.log(10) )
      ndig = 0 if ndig > 0
      ndig = Math.abs(ndig)
      d3.format(".#{ndig}f")

    # axis: labels
    Laxis.append("g").selectAll("empty")
       .data(LaxisData)
       .enter()
       .append("text")
       .attr("class", "axis")
       .text((d) -> formatAxis(LaxisData)(d))
       .attr("x", pad.left*0.9)
       .attr("y", (d) -> yScale(d))
       .attr("dominant-baseline", "middle")
       .attr("text-anchor", "end")

    # axis on bottom
    BaxisData = xScale.ticks(10)
    Baxis = this.svg.append("g").attr("id", "Baxis")

    # axis: white lines
    Baxis.append("g").selectAll("empty")
       .data(BaxisData)
       .enter()
       .append("line")
       .attr("class", "line")
       .attr("class", "axis")
       .attr("y1", pad.top)
       .attr("y2", h-pad.bottom)
       .attr("x1", (d) -> xScale(d-1))
       .attr("x2", (d) -> xScale(d-1))
       .attr("stroke", "white")
       .attr("pointer-events", "none")

    # axis: labels
    Baxis.append("g").selectAll("empty")
       .data(BaxisData)
       .enter()
       .append("text")
       .attr("class", "axis")
       .text((d) -> d)
       .attr("y", h-pad.bottom*0.75)
       .attr("x", (d) -> xScale(d-1))
       .attr("dominant-baseline", "middle")
       .attr("text-anchor", "middle")

    # colors for quantile curves
    colindex = d3.range((nQuant-1)/2)
    tmp = d3.scale.category10().domain(colindex)
    qucolors = []
    for j in colindex
      qucolors.push(tmp(j))
    qucolors.push("black")
    for j in colindex.reverse()
      qucolors.push(tmp(j))

    # curves for quantiles
    curves = this.svg.append("g").attr("id", "curves")

    for j in [0...nQuant]
      curves.append("path")
         .datum(indindex)
         .attr("d", quline(j))
         .attr("class", "line")
         .attr("stroke", qucolors[j])
         .attr("pointer-events", "none")

    # vertical rectangles representing each array
    indRectGrp = this.svg.append("g").attr("id", "indRect")

    indRect = indRectGrp.selectAll("empty")
                   .data(indindex)
                   .enter()
                   .append("rect")
                   .attr("x", (d) -> xScale(d) - recWidth/2)
                   .attr("y", (d) -> yScale(quant[nQuant-1][d]))
                   .attr("id", (d) -> "rect#{ind[d]}")
                   .attr("width", recWidth)
                   .attr("height", (d) ->
                      yScale(quant[0][d]) - yScale(quant[nQuant-1][d]))
                   .attr("fill", "purple")
                   .attr("stroke", "none")
                   .attr("opacity", "0")
                   .attr("pointer-events", "none")

    # vertical rectangles representing each array
    longRectGrp = this.svg.append("g").attr("id", "longRect")

    longRect = indRectGrp.selectAll("empty")
                   .data(indindex)
                   .enter()
                   .append("rect")
                   .attr("x", (d) -> xScale(d) - recWidth/2)
                   .attr("y", pad.top)
                   .attr("width", recWidth)
                   .attr("height", h - pad.top - pad.bottom)
                   .attr("fill", "purple")
                   .attr("stroke", "none")
                   .attr("opacity", "0")

    # label quantiles on right
    rightAxis = this.svg.append("g").attr("id", "rightAxis")

    rightAxis.selectAll("empty")
         .data(qu)
         .enter()
         .append("text")
         .attr("class", "qu")
         .text( (d) -> "#{d*100}%")
         .attr("x", w)
         .attr("y", (d,i) -> yScale(((i+0.5)/nQuant/2 + 0.25) * (topylim[1] - topylim[0]) + topylim[0]))
         .attr("fill", (d,i) -> qucolors[i])
         .attr("text-anchor", "end")
         .attr("dominant-baseline", "middle")

    # box around the outside
    this.svg.append("rect")
       .attr("x", pad.left)
       .attr("y", pad.top)
       .attr("height", h-pad.top-pad.bottom)
       .attr("width", w-pad.left-pad.right)
       .attr("stroke", "black")
       .attr("stroke-width", 2)
       .attr("fill", "none")

    lo = breaks[0] - (breaks[1] - breaks[0])
    hi = breaks[breaks.length-1] + (breaks[1] - breaks[0])

    lowxScale = d3.scale.linear()
               .domain([lo, hi])
               .range([pad.left, w-pad.right])

    lowyScale = d3.scale.linear()
               .domain([0, botylim[1]+1])
               .range([h-pad.bottom, pad.top])

    # gray background
    this.lowsvg.append("rect")
       .attr("x", pad.left)
       .attr("y", pad.top)
       .attr("height", h-pad.top-pad.bottom)
       .attr("width", w-pad.left-pad.right)
       .attr("stroke", "none")
       .attr("fill", d3.rgb(200, 200, 200))

    # axis on left
    lowBaxisData = lowxScale.ticks(8)
    lowBaxis = this.lowsvg.append("g").attr("id", "lowBaxis")

    # axis: white lines
    lowBaxis.append("g").selectAll("empty")
       .data(lowBaxisData)
       .enter()
       .append("line")
       .attr("class", "line")
       .attr("class", "axis")
       .attr("y1", pad.top)
       .attr("y2", h-pad.bottom)
       .attr("x1", (d) -> lowxScale(d))
       .attr("x2", (d) -> lowxScale(d))
       .attr("stroke", "white")

    # axis: labels
    lowBaxis.append("g").selectAll("empty")
       .data(lowBaxisData)
       .enter()
       .append("text")
       .attr("class", "axis")
       .text((d) -> formatAxis(lowBaxisData)(d))
       .attr("y", h-pad.bottom*0.75)
       .attr("x", (d) -> lowxScale(d))
       .attr("dominant-baseline", "middle")
       .attr("text-anchor", "middle")

    grp4BkgdHist = this.lowsvg.append("g").attr("id", "bkgdHist")

    histline = d3.svg.line()
          .x((d,i) -> lowxScale(br2[i]))
          .y((d) -> lowyScale(d))

    randomInd = indindex[Math.floor(Math.random()*ind.length)]

    hist = this.lowsvg.append("path")
      .datum(counts[randomInd])
         .attr("d", histline)
         .attr("id", "histline")
         .attr("fill", "none")
         .attr("stroke", "purple")
         .attr("stroke-width", "2")


    histColors = ["blue", "red", "green", "MediumVioletRed", "black"]

    this.lowsvg.append("text")
          .datum(randomInd)
          .attr("x", pad.left*1.1)
          .attr("y", pad.top*2)
          .text((d) -> ind[d])
          .attr("id", "histtitle")
          .attr("text-anchor", "start")
          .attr("dominant-baseline", "middle")
          .attr("fill", "blue")

    clickStatus = []
    for d in indindex
      clickStatus.push(0)

    longRect
      .on "mouseover", (d) ->
                d3.select("rect#rect#{ind[d]}")
                   .attr("opacity", "1")
                d3.select("#histline")
                   .datum(counts[d])
                   .attr("d", histline)
                d3.select("#histtitle")
                   .datum(d)
                   .text((d) -> ind[d])

      .on "mouseout", (d) ->
                if !clickStatus[d]
                  d3.select("rect#rect#{ind[d]}").attr("opacity", "0")

      .on "click", (d) ->
                console.log("Click: #{ind[d]} (#{d+1})")
                clickStatus[d] = 1 - clickStatus[d]
                d3.select("rect#rect#{ind[d]}").attr("opacity", clickStatus[d])
                if clickStatus[d]
                  curcolor = histColors.shift()
                  histColors.push(curcolor)

                  d3.select("rect#rect#{ind[d]}").attr("fill", curcolor)

                  grp4BkgdHist.append("path")
                        .datum(counts[d])
                        .attr("d", histline)
                        .attr("id", "path#{ind[d]}")
                        .attr("fill", "none")
                        .attr("stroke", curcolor)
                        .attr("stroke-width", "2")
                else
                  d3.select("path#path#{ind[d]}").remove()

    # box around the outside
    this.lowsvg.append("rect")
       .attr("x", pad.left)
       .attr("y", pad.top)
       .attr("height", h-pad.bottom-pad.top)
       .attr("width", w-pad.left-pad.right)
       .attr("stroke", "black")
       .attr("stroke-width", 2)
       .attr("fill", "none")

    this.svg.append("text")
       .text(ylab)
       .attr("x", pad.left*0.2)
       .attr("y", h/2)
       .attr("fill", "blue")
       .attr("transform", "rotate(270 #{pad.left*0.2} #{h/2})")
       .attr("dominant-baseline", "middle")
       .attr("text-anchor", "middle")

    this.lowsvg.append("text")
       .text(ylab)
       .attr("x", (w-pad.left-pad.bottom)/2+pad.left)
       .attr("y", h-pad.bottom*0.2)
       .attr("fill", "blue")
       .attr("dominant-baseline", "middle")
       .attr("text-anchor", "middle")

    this.svg.append("text")
       .text(xlab)
       .attr("x", (w-pad.left-pad.bottom)/2+pad.left)
       .attr("y", h-pad.bottom*0.2)
       .attr("fill", "blue")
       .attr("dominant-baseline", "middle")
       .attr("text-anchor", "middle")

  this.update = (formdata) -> return(null)

  return(null)

healthvis.register(new HealthvisManyBox())
