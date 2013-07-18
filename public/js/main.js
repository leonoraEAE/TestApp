
angular.module('myApp.service',['ngResource']).
   factory('UserFactory', function($resource) {
        return $resource('./myApp/users/:service', {}, {
        getAllUsers: {method:'GET', params:{service: 'all'}, isArray:true},
        updateUser: {method:'PUT', params:{service: 'update'}},
        deleteUser: {method:'DELETE', params:{service: 'delete'}},
        });
});

var app = angular.module("myApp", ['myApp.service']);

app.config(function($routeProvider, $locationProvider){
    $routeProvider.when('/list', {
        templateUrl: 'partials/list.html',
        controller: 'AppController'
    });
    $routeProvider.when('/add', {
        templateUrl: 'partials/add.html',
        controller: 'AppController'
    });
    $routeProvider.when('/remove/:id/:rev', {
        templateUrl: 'partials/list.html',
        controller: 'AppRemoveController'
    });
    $routeProvider.when('/reset/:id/:rev', {
        templateUrl: 'partials/list.html',
        controller: 'AppUpdateController'
    });
    $routeProvider.otherwise({redirectTo: '/list'});
    //$locationProvider.html5Mode(true);
});

app.factory('Users', function($resource){
        return $resource('user/:userId', {}, {
            info: {method:'GET', params:{section:'info'}, isArray:false}
          });
    });


//WORKS   <<<<   Run this when the app is ready.
/*
app.run(function($resource) {

            var messages = $resource("./myApp/usersResource/:userId", {userId: "@id"}, {});

            // GET with ID.
            messages.get({ id: '79faf210ecaf24547cfd66245b3f8504'});
        }
    );
*/
  
//add a controller to it
app.controller('AppController', function($scope, $http, UserFactory) {
    $scope.name = "Frank";
   
    //load the data.
    //$http.get('/myApp/users').success(function(data) {
    //   $scope.users = data;
    //});
});

//add a controller to it
app.controller('AppListController', function($scope, $http, UserFactory) {
    console.log($http);
    $scope.users = UserFactory.getAllUsers();
});

//
app.controller('AppRemoveController', function($scope, $routeParams, $http, UserFactory) {
    console.log("remove controller");
    $scope.users = UserFactory.deleteUser({id: $routeParams.id, rev: $routeParams.rev});
});

app.controller('AppUpdateController', function($scope, $routeParams, $http, UserFactory) {
    console.log("update controller");
    UserFactory.updateUser({id: $routeParams.id, name: "", email: ""}, 
                           function () {
                              $scope.users = UserFactory.getAllUsers(); 
                           });
});




