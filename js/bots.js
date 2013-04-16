// Generated by CoffeeScript 1.5.0
(function() {
  var colors, draw, drawChart, formatDate, makeData, makeLabels, pad, period, stats;

  stats = {};

  period = null;

  jQuery(function() {
    var $;
    $ = jQuery;
    return draw();
  });

  $(window).bind("hashchange", function() {
    return draw();
  });

  draw = function() {
    var url;
    period = $.bbq.getState("period") || "hour";
    url = "stats/" + period + ".json";
    return $.getJSON(url, function(stats) {
      drawChart(stats);
      $(".nav li").removeClass("active");
      return $("#period-" + period).addClass("active");
    });
  };

  drawChart = function(stats, selected) {
    var chart, ctx, data, dataset, legend, li, opts, _i, _len, _ref;
    ctx = $('#chart').get(0).getContext("2d");
    chart = new Chart(ctx);
    data = makeData(stats, selected);
    opts = {
      pointDot: false,
      datasetFill: false,
      scaleShowLabels: true,
      datasetStrokeWidth: 2,
      animation: false
    };
    chart.Line(data, opts);
    legend = $("#legend");
    legend.empty();
    _ref = data.datasets;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      dataset = _ref[_i];
      li = $('<li><a data-dataset="' + dataset.name + '" style="color: ' + dataset.strokeColor + '" href="http://wikidata.org/wiki/User:' + dataset.name + '">' + dataset.name + '</a></li>');
      legend.append(li);
    }
    return $("#legend a").hover(function(ev) {
      var newSelected;
      newSelected = $(ev.target).data('dataset');
      if (newSelected !== selected) {
        return drawChart(stats, newSelected);
      }
    }, function(ev) {
      $(ev.target).css('font-weight', 'normal');
      return drawChart(stats);
    });
  };

  makeData = function(stats, selected) {
    var botStats, color, data, datasets, hasData, labels, name, row, _i, _len;
    labels = makeLabels(stats);
    datasets = [];
    for (name in stats) {
      botStats = stats[name];
      color = colors[datasets.length];
      if (selected && selected !== name) {
        color = color.replace('0.7', '0.1');
      }
      data = [];
      hasData = false;
      for (_i = 0, _len = botStats.length; _i < _len; _i++) {
        row = botStats[_i];
        if (row[1] > 0) {
          hasData = true;
        }
        data.push(row[1]);
      }
      if (hasData) {
        datasets.push({
          name: name,
          strokeColor: color,
          data: data
        });
      }
    }
    return {
      labels: labels,
      datasets: datasets
    };
  };

  makeLabels = function(stats) {
    var count, d, data, labels, name, row, _i, _len;
    count = 0;
    labels = [];
    for (name in stats) {
      data = stats[name];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        row = data[_i];
        if (count % 7 === 0) {
          d = new Date(row[0] * 1000);
          labels.push(formatDate(d));
        } else {
          labels.push("");
        }
        count += 1;
      }
      return labels;
    }
  };

  pad = function(n) {
    if (n < 10) {
      return '0' + n;
    } else {
      return n;
    }
  };

  formatDate = function(d) {
    return d.getUTCFullYear() + '-' + pad(d.getUTCMonth() + 1) + '-' + pad(d.getUTCDate()) + ' ';
  };

  colors = ["rgba(103, 0, 31, 0.7)", "rgba(178, 24, 43, 0.7)", "rgba(214, 96, 77, 0.7)", "rgba(244, 165, 130, 0.7)", "rgba(209, 229, 240, 0.7)", "rgba(146, 197, 222, 0.7)", "rgba(67, 147, 195, 0.7)", "rgba(33, 102, 172, 0.7)", "rgba(5, 48, 97, 0.7)", "rgba(103, 0, 31, 0.7)", "rgba(178, 24, 43, 0.7)", "rgba(214, 96, 77, 0.7)", "rgba(244, 165, 130, 0.7)", "rgba(186, 186, 186, 0.7)", "rgba(135, 135, 135, 0.7)", "rgba(77, 77, 77, 0.7)", "rgba(26, 26, 26, 0.7)", "rgba(165, 0, 38, 0.7)", "rgba(215, 48, 39, 0.7)", "rgba(244, 109, 67, 0.7)", "rgba(253, 174, 97, 0.7)", "rgba(254, 224, 144, 0.7)", "rgba(171, 217, 233, 0.7)", "rgba(116, 173, 209, 0.7)", "rgba(69, 117, 180, 0.7)", "rgba(49, 54, 149, 0.7)", "rgba(165, 0, 38, 0.7)", "rgba(215, 48, 39, 0.7)", "rgba(244, 109, 67, 0.7)", "rgba(253, 174, 97, 0.7)", "rgba(254, 224, 139, 0.7)", "rgba(255, 255, 191, 0.7)", "rgba(217, 239, 139, 0.7)", "rgba(166, 217, 106, 0.7)", "rgba(102, 189, 99, 0.7)", "rgba(26, 152, 80, 0.7)", "rgba(0, 104, 55, 0.7)"];

}).call(this);
