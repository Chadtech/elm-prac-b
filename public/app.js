(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var app, request, respond;

app = Elm.Main.fullscreen();

request = app.ports.request;

request.subscribe(function(thing) {
  return 'this is a ' + thing;
});

respond = function(s) {
  return app.ports.response.send(Math.floor(s / 1));
};

document.addEventListener("visibilitychange", function() {
  if (document.hidden) {
    return app.ports.response.send(false);
  }
}, false);


},{}]},{},[1])
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm5vZGVfbW9kdWxlcy9icm93c2VyaWZ5L25vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiLCJzcmMvanMvYXBwLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQTtBQ0NBLElBQUE7O0FBQUEsR0FBQSxHQUFZLEdBQUcsQ0FBQyxJQUFJLENBQUMsVUFBVCxDQUFBOztBQUNYLFVBQVcsR0FBRyxDQUFDLE1BQWY7O0FBR0QsT0FBTyxDQUFDLFNBQVIsQ0FBa0IsU0FBQyxLQUFEO1NBQ2hCLFlBQUEsR0FBZTtBQURDLENBQWxCOztBQUdBLE9BQUEsR0FBVSxTQUFDLENBQUQ7U0FDUixHQUFHLENBQUMsS0FBSyxDQUFDLFFBQVEsQ0FBQyxJQUFuQixZQUF3QixJQUFLLEVBQTdCO0FBRFE7O0FBR1YsUUFBUSxDQUFDLGdCQUFULENBQTBCLGtCQUExQixFQUNFLFNBQUE7RUFDRSxJQUFHLFFBQVEsQ0FBQyxNQUFaO1dBQ0UsR0FBRyxDQUFDLEtBQUssQ0FBQyxRQUFRLENBQUMsSUFBbkIsQ0FBd0IsS0FBeEIsRUFERjs7QUFERixDQURGLEVBSUUsS0FKRiIsImZpbGUiOiJnZW5lcmF0ZWQuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlc0NvbnRlbnQiOlsiKGZ1bmN0aW9uIGUodCxuLHIpe2Z1bmN0aW9uIHMobyx1KXtpZighbltvXSl7aWYoIXRbb10pe3ZhciBhPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7aWYoIXUmJmEpcmV0dXJuIGEobywhMCk7aWYoaSlyZXR1cm4gaShvLCEwKTt2YXIgZj1uZXcgRXJyb3IoXCJDYW5ub3QgZmluZCBtb2R1bGUgJ1wiK28rXCInXCIpO3Rocm93IGYuY29kZT1cIk1PRFVMRV9OT1RfRk9VTkRcIixmfXZhciBsPW5bb109e2V4cG9ydHM6e319O3Rbb11bMF0uY2FsbChsLmV4cG9ydHMsZnVuY3Rpb24oZSl7dmFyIG49dFtvXVsxXVtlXTtyZXR1cm4gcyhuP246ZSl9LGwsbC5leHBvcnRzLGUsdCxuLHIpfXJldHVybiBuW29dLmV4cG9ydHN9dmFyIGk9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtmb3IodmFyIG89MDtvPHIubGVuZ3RoO28rKylzKHJbb10pO3JldHVybiBzfSkiLCIjIF8gICAgICAgICA9IHJlcXVpcmUgJ2xvZGFzaCdcbmFwcCAgICAgICA9IEVsbS5NYWluLmZ1bGxzY3JlZW4oKVxue3JlcXVlc3R9ID0gYXBwLnBvcnRzXG5cblxucmVxdWVzdC5zdWJzY3JpYmUgKHRoaW5nKSAtPlxuICAndGhpcyBpcyBhICcgKyB0aGluZ1xuXG5yZXNwb25kID0gKHMpIC0+XG4gIGFwcC5wb3J0cy5yZXNwb25zZS5zZW5kIHMgLy8gMVxuXG5kb2N1bWVudC5hZGRFdmVudExpc3RlbmVyIFwidmlzaWJpbGl0eWNoYW5nZVwiLCBcbiAgLT5cbiAgICBpZiBkb2N1bWVudC5oaWRkZW5cbiAgICAgIGFwcC5wb3J0cy5yZXNwb25zZS5zZW5kIGZhbHNlXG4gIGZhbHNlXG4iXX0=
