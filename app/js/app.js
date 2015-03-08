var app = angular.module("teamApp", ["ngMaterial", "ngRoute"]);

app.config(["$routeProvider", function($routeProvider){
	$routeProvider
	.when("/", {templateUrl: "../views/landing/index.html"})
	.when("/home", {templateUrl: "../views/menu/index.html"})
	.when("/team", {templateUrl: "../views/team/index.html"})
	.when("/robot", {templateUrl: "../views/robot/index.html"})
	.when("/about_first", {templateUrl: "../views/about_first/index.html"})
	.when("/about", {templateUrl: "../views/about/index.html"})
	.when("/ressources", {templateUrl: "../views/ressources/index.html"})
	.when("/calendar", {templateUrl: "../views/calendar/index.html"})
	.when("/store", {templateUrl: "../views/store/index.html"})
	.when("/blog", {templateUrl: "../views/blog/index.html"})
	.otherwise({redirectTo: "/"})
}])