
function HealthvisManyBox() {

    this.width=1000;
    this.height=450;

    this.init = function(elementId, d3Params) {
        var dimensions = healthvis.getDimensions(this.width, this.height);

        this.width = dimensions.width;
        this.height = dimensions.height;

        this.ylab = d3Params.ylab;
        this.xlab = d3Params.xlab;

        this.ind = d3Params.ind;
        this.qu = d3Params.qu;
        this.breaks = d3Params.breaks;
        this.quant = JSON.parse(d3Params.quant);
        this.counts = JSON.parse(d3Params.counts);

        this.svg = d3.select('#main')
          .append('svg')
          .attr('width', this.width)
          .attr('height', this.height)
          .attr('class', 'chart');

        this.lowsvg = d3.select('#main')
          .append('svg')
          .attr('width', this.width)
          .attr('height', this.height)
     };

    this.visualize = function() {

        ylab = this.ylab;
        xlab = this.xlab;

        ind = this.ind;
        qu = this.qu;
        breaks = this.breaks;
        quant = this.quant;
        counts = this.counts;

        console.log("ind.length: " + ind.length);
        console.log("qu.length: " + qu.length);
        console.log("breaks.length: " + breaks.length);
        console.log("quant.length: " + quant.length);
        console.log("counts.length: " + counts.length);
        console.log("quant[0].length: " + quant[0].length);
        console.log("counts[0].length: " + counts[0].length);

        w = this.width;
        h = this.height;

        pad = {
            left: 60,
            top: 20,
            right: 60,
            bottom: 40
        };

      // the code below translated from Coffeescript (that's why it's so ugly!)

      topylim = [quant[0][0], quant[0][1]];
      for (i in quant) {
        _ref = quant[i];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          x = _ref[_i];
          if (x < topylim[0]) {
            topylim[0] = x;
          }
          if (x > topylim[1]) {
            topylim[1] = x;
          }
        }
      }
      topylim[0] = Math.floor(topylim[0]);
      topylim[1] = Math.ceil(topylim[1]);
      botylim = [0, counts[0][1]];
      for (i in counts) {
        _ref1 = counts[i];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          x = _ref1[_j];
          if (x > botylim[1]) {
            botylim[1] = x;
          }
        }
      }
      indindex = d3.range(ind.length);
      br2 = [];
      _ref2 = breaks;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        i = _ref2[_k];
        br2.push(i);
        br2.push(i);
      }
      fix4hist = function(d) {
        var _l, _len3;
        x = [0];
        for (_l = 0, _len3 = d.length; _l < _len3; _l++) {
          i = d[_l];
          x.push(i);
          x.push(i);
        }
        x.push(0);
        return x;
      };
      for (i in counts) {
        counts[i] = fix4hist(counts[i]);
      }
      nQuant = quant.length;
      midQuant = (nQuant + 1) / 2 - 1;
      xScale = d3.scale.linear().domain([-1, ind.length]).range([pad.left, w - pad.right]);
      recWidth = xScale(1) - xScale(0);
      yScale = d3.scale.linear().domain(topylim).range([h - pad.bottom, pad.top]);
      quline = function(j) {
        return d3.svg.line().x(function(d) {
          return xScale(d);
        }).y(function(d) {
          return yScale(quant[j][d]);
        });
      };
      this.svg.append("rect").attr("x", pad.left).attr("y", pad.top).attr("height", h - pad.top - pad.bottom).attr("width", w - pad.left - pad.right).attr("stroke", "none").attr("fill", d3.rgb(200, 200, 200)).attr("pointer-events", "none");
      LaxisData = yScale.ticks(6);
      Laxis = this.svg.append("g").attr("id", "Laxis");
      Laxis.append("g").selectAll("empty").data(LaxisData).enter().append("line").attr("class", "line").attr("class", "axis").attr("x1", pad.left).attr("x2", w - pad.right).attr("y1", function(d) {
        return yScale(d);
      }).attr("y2", function(d) {
        return yScale(d);
      }).attr("stroke", "white").attr("pointer-events", "none");
      formatAxis = function(d) {
        var ndig;
        d = d[1] - d[0];
        ndig = Math.floor(Math.log(d % 10) / Math.log(10));
        if (ndig > 0) {
          ndig = 0;
        }
        ndig = Math.abs(ndig);
        return d3.format("." + ndig + "f");
      };
      Laxis.append("g").selectAll("empty").data(LaxisData).enter().append("text").attr("class", "axis").text(function(d) {
        return formatAxis(LaxisData)(d);
      }).attr("x", pad.left * 0.9).attr("y", function(d) {
        return yScale(d);
      }).attr("dominant-baseline", "middle").attr("text-anchor", "end");
      BaxisData = xScale.ticks(10);
      Baxis = this.svg.append("g").attr("id", "Baxis");
      Baxis.append("g").selectAll("empty").data(BaxisData).enter().append("line").attr("class", "line").attr("class", "axis").attr("y1", pad.top).attr("y2", h - pad.bottom).attr("x1", function(d) {
        return xScale(d - 1);
      }).attr("x2", function(d) {
        return xScale(d - 1);
      }).attr("stroke", "white").attr("pointer-events", "none");
      Baxis.append("g").selectAll("empty").data(BaxisData).enter().append("text").attr("class", "axis").text(function(d) {
        return d;
      }).attr("y", h - pad.bottom * 0.75).attr("x", function(d) {
        return xScale(d - 1);
      }).attr("dominant-baseline", "middle").attr("text-anchor", "middle");
      colindex = d3.range((nQuant - 1) / 2);
      tmp = d3.scale.category10().domain(colindex);
      qucolors = [];
      for (_l = 0, _len3 = colindex.length; _l < _len3; _l++) {
        j = colindex[_l];
        qucolors.push(tmp(j));
      }
      qucolors.push("black");
      _ref3 = colindex.reverse();
      for (_m = 0, _len4 = _ref3.length; _m < _len4; _m++) {
        j = _ref3[_m];
        qucolors.push(tmp(j));
      }
      curves = this.svg.append("g").attr("id", "curves");
      for (j = _n = 0; 0 <= nQuant ? _n < nQuant : _n > nQuant; j = 0 <= nQuant ? ++_n : --_n) {
        curves.append("path").datum(indindex).attr("d", quline(j)).attr("class", "line").attr("stroke", qucolors[j]).attr("pointer-events", "none");
      }
      indRectGrp = this.svg.append("g").attr("id", "indRect");
      indRect = indRectGrp.selectAll("empty").data(indindex).enter().append("rect").attr("x", function(d) {
        return xScale(d) - recWidth / 2;
      }).attr("y", function(d) {
        return yScale(quant[nQuant - 1][d]);
      }).attr("id", function(d) {
        return "rect" + ind[d];
      }).attr("width", recWidth).attr("height", function(d) {
        return yScale(quant[0][d]) - yScale(quant[nQuant - 1][d]);
      }).attr("fill", "purple").attr("stroke", "none").attr("opacity", "0").attr("pointer-events", "none");
      longRectGrp = this.svg.append("g").attr("id", "longRect");
      longRect = indRectGrp.selectAll("empty").data(indindex).enter().append("rect").attr("x", function(d) {
        return xScale(d) - recWidth / 2;
      }).attr("y", pad.top).attr("width", recWidth).attr("height", h - pad.top - pad.bottom).attr("fill", "purple"          ).attr("stroke", "none").attr("opacity", "0");
      rightAxis = this.svg.append("g").attr("id", "rightAxis");
      rightAxis.selectAll("empty").data(qu).enter().append("text").attr("class", "qu").text(function(d) {
        return "" + (d * 100) + "%";
      }).attr("x", w).attr("y", function(d, i) {
        return yScale(((i + 0.5) / nQuant / 2 + 0.25) * (topylim[1] - topylim[0]) + topylim[0]);
      }).attr("fill", function(d, i) {
        return qucolors[i];
      }).attr("text-anchor", "end").attr("dominant-baseline", "middle");
      this.svg.append("rect").attr("x", pad.left).attr("y", pad.top).attr("height", h - pad.top - pad.bottom).attr("width", w - pad.left - pad.right).attr("stroke", "black").attr("stroke-width", 2).attr("fill", "none");
      lo = breaks[0] - (breaks[1] - breaks[0]);
      hi = breaks[breaks.length - 1] + (breaks[1] - breaks[0]);
      lowxScale = d3.scale.linear().domain([lo, hi]).range([pad.left, w - pad.right]);
      lowyScale = d3.scale.linear().domain([0, botylim[1] + 1]).range([h - pad.bottom, pad.top]);
      this.lowsvg.append("rect").attr("x", pad.left).attr("y", pad.top).attr("height", h - pad.top - pad.bottom).attr("width", w - pad.left - pad.right).attr("stroke", "none").attr("fill", d3.rgb(200, 200, 200));
      lowBaxisData = lowxScale.ticks(8);
      lowBaxis = this.lowsvg.append("g").attr("id", "lowBaxis");
      lowBaxis.append("g").selectAll("empty").data(lowBaxisData).enter().append("line").attr("class", "line").attr("class", "axis").attr("y1", pad.top).attr("y2", h - pad.bottom).attr("x1", function(d) {
        return lowxScale(d);
      }).attr("x2", function(d) {
        return lowxScale(d);
      }).attr("stroke", "white");
      lowBaxis.append("g").selectAll("empty").data(lowBaxisData).enter().append("text").attr("class", "axis").text(function(d) {
        return formatAxis(lowBaxisData)(d);
      }).attr("y", h - pad.bottom * 0.75).attr("x", function(d) {
        return lowxScale(d);
      }).attr("dominant-baseline", "middle").attr("text-anchor", "middle");
      grp4BkgdHist = this.lowsvg.append("g").attr("id", "bkgdHist");
      histline = d3.svg.line().x(function(d, i) {
        return lowxScale(br2[i]);
      }).y(function(d) {
        return lowyScale(d);
      });
      randomInd = indindex[Math.floor(Math.random() * ind.length)];
      hist = this.lowsvg.append("path").datum(counts[randomInd]).attr("d", histline).attr("id", "histline").attr("fill", "none").attr("stroke", "purple").attr("stroke-width", "2");
      histColors = ["blue", "red", "green", "MediumVioletRed", "black"];
      this.lowsvg.append("text").datum(randomInd).attr("x", pad.left * 1.1).attr("y", pad.top * 2).text(function(d) {
        return ind[d];
      }).attr("id", "histtitle").attr("text-anchor", "start").attr("dominant-baseline", "middle").attr("fill", "blue");
      clickStatus = [];
      for (_o = 0, _len5 = indindex.length; _o < _len5; _o++) {
        d = indindex[_o];
        clickStatus.push(0);
      }
      longRect.on("mouseover", function(d) {
        d3.select("rect#rect" + ind[d]).attr("opacity", "1");
        d3.select("#histline").datum(counts[d]).attr("d", histline);
        return d3.select("#histtitle").datum(d).text(function(d) {
          return ind[d];
        });
      }).on("mouseout", function(d) {
        if (!clickStatus[d]) {
          return d3.select("rect#rect" + ind[d]).attr("opacity", "0");
        }
      }).on("click", function(d) {
        var curcolor;
        console.log("Click: " + ind[d] + " (" + (d + 1) + ")");
        clickStatus[d] = 1 - clickStatus[d];
        d3.select("rect#rect" + ind[d]).attr("opacity", clickStatus[d]);
        if (clickStatus[d]) {
          curcolor = histColors.shift();
          histColors.push(curcolor);
          d3.select("rect#rect" + ind[d]).attr("fill", curcolor);
          return grp4BkgdHist.append("path").datum(counts[d]).attr("d", histline).attr("id", "path" + ind[d]).attr("fill", "none").attr("stroke", curcolor).attr("stroke-width", "2");
        } else {
          return d3.select("path#path" + ind[d]).remove();
        }
      });
      this.lowsvg.append("rect").attr("x", pad.left).attr("y", pad.top).attr("height", h - pad.bottom - pad.top).attr("width", w - pad.left - pad.right).attr("stroke", "black").attr("stroke-width", 2).attr("fill", "none");
      this.svg.append("text").text(ylab).attr("x", pad.left * 0.2).attr("y", h / 2).attr("fill", "blue").attr("transform", "rotate(270 " + (pad.left * 0.2) + " " + (h / 2) + ")").attr("dominant-baseline", "middle").attr("text-anchor", "middle");
      this.lowsvg.append("text").text(ylab).attr("x", (w - pad.left - pad.bottom) / 2 + pad.left).attr("y", h - pad.bottom * 0.2).attr("fill", "blue").attr("dominant-baseline", "middle").attr("text-anchor", "middle");
      this.svg.append("text").text(xlab).attr("x", (w - pad.left - pad.bottom) / 2 + pad.left).attr("y", h - pad.bottom * 0.2).attr("fill", "blue").attr("dominant-baseline", "middle").attr("text-anchor", "middle");
    };


    this.update = function(formdata) {
    };
}

healthvis.register(new HealthvisManyBox());


