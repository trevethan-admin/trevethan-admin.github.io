---
---

redraw = ->
  path = path.data(voronoi(vertices), polygon)
  path.exit().remove()
  path.enter().append("path").attr("class", (d, i) ->
    "q" + (i % 9) + "-9"
  ).attr "d", polygon
  path.order()
  return
polygon = (d) ->
  "M" + d.join("L") + "Z"
width = document.width()
height = document.height()
vertices = d3.range(100).map((d) ->
  [
    Math.random() * width
    Math.random() * height
  ]
)
voronoi = d3.geom.voronoi().clipExtent([
  [
    0
    0
  ]
  [
    width
    height
  ]
])
svg = d3.select("body").append("svg").attr("width", width).attr("height", height).on("mousemove", ->
  vertices[0] = d3.mouse(this)
  redraw()
  return
)
path = svg.append("g").selectAll("path")
svg.selectAll("circle").data(vertices.slice(1)).enter().append("circle").attr("transform", (d) ->
  "translate(" + d + ")"
).attr "r", 1.5
redraw()


# width     = $(window).width()
# height    = $(window).height()
# vertices  = d3.range(100).map((d) ->
#   [
#     Math.random() * width
#     Math.random() * height
#   ]
# )
# voronoi   = d3.geom.voronoi().clipExtent([
#   [
#     0
#     0
#   ]
#   [
#     width
#     height
#   ]
# ])

# init = () ->

#   svg = d3.select("body").append("svg").attr("width", width).attr("height", height)
#   path = svg.append("g").selectAll("path")

#   redraw()
#   svg.selectAll("circle")
#     .data(vertices.slice(1))
#     .enter()
#     .append("circle")
#     .attr("transform", (d) -> return "translate(" + d + ")")
#     .attr("r", 1.5);

# redraw = () ->
#   path = path.data(voronoi(vertices), polygon)
#   path.exit().remove()
#   path.enter().append("path").attr("class", (d, i) ->
#     "q" + (i % 9) + "-9"
#   ).attr "d", polygon
#   path.order()
#   return

# polygon = (d) ->
#   "M" + d.join("L") + "Z"

# init()
