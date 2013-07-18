head.js("/js/libs/angular.js")
    .js("/js/libs/jquery-1.4.4.min.js");
 

//create your application module.
var app = angular.module('myApp', []);

//add a controller to it
app.controller('MyCtrl', function($scope, $http) {

   //a scope function to load the data.
   $scope.loadData = function () {
      $http.get('/example.json').success(function(data) {
         $scope.items = data;
      });
   };

});

