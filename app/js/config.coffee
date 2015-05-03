class Routes extends Config
  constructor: ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise '/'

    $stateProvider
      .state 'landing',
        url: '/'
        templateUrl: 'views/landing/index.html'
      .state 'menu',
        url: '/menu'
        templateUrl: 'views/menu/index.html'
      .state 'team',
        url: '/team'
        templateUrl: 'views/team/index.html'
      .state 'robot',
        url: '/robot'
        templateUrl: 'views/robot/index.html'
      .state 'first',
        url: '/about_first'
        templateUrl: 'views/about_first/index.html'
      .state 'about',
        url: '/about'
        templateUrl: 'views/about/index.html'
      .state 'blog',
        url: '/blog'
        templateUrl: 'views/blog/index.html'
